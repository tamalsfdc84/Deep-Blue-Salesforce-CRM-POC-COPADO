// Copyright (c) 2019 Terafina Inc
/**
 * Used for publishing notifications about a party's lifecycle event to relevant stakeholders.
 * Lifecycle events include Party_OTP_Generated.<br>
 * Typically invoked from PartyService. Mapping to a lifecycle event is done via EventConfiguration
 * (Custom Metadata).
 */
global inherited sharing class CZWTFCPartyEventExtension extends tffa.EventExtension {
  //public string eventName;
  public String productName;
  public String bankerName;
  global CZWTFCPartyEventExtension(string eventName) {
    this.eventName = eventName;
  }

  global CZWTFCPartyEventExtension() {
  }
  global override Object post(Object obj) {
    if (!(obj instanceof tffa__Party__c)) {
      tffa.Logger.error('Input is not of type Party__c');
      return obj;
    }
    tffa__Party__c party = (tffa__Party__c) obj;
    party = tffa.PartyService.read(party.Id);

    tffa.Logger.debug('in PartyEventExtension.post for party ::' + party.Id + ' & eventname ::' + eventName);

    List<tffa.NotificationDTO> notifications = new List<tffa.NotificationDTO>();
    tffa.NotificationDTO.NotificationRecipientDTO[] recipients = new List<tffa.NotificationDTO.NotificationRecipientDTO>{};
    recipients.add(
      new tffa.NotificationDTO.NotificationRecipientDTO(
        tffa.NotificationDTO.NotificationRecipientType.PARTY,
        party.Id,
        party.Name,
        party.tffa__PrimaryEmail__c,
        party.tffa__PrimaryPhone__c
      )
    );
    if (!recipients.isEmpty()) {
      tffa.NotificationDTO notif = buildNotification(party, null, eventName);
      notif.recipients = recipients;
      notifications.add(notif);
    }

    if (!notifications.isEmpty()) {
      Map<String, Object> facts = new Map<String, Object>();
      facts.put('EventName', eventName);
      tffa.EmailNotificationDispatcher dispatcher = new tffa.EmailNotificationDispatcher();
      //.getInstance().getProvider(facts);
      dispatcher.dispatch(notifications, facts);
    }

    return obj;
  }

  private tffa.NotificationDTO buildNotification(tffa__Party__c party, tffa__Application__c applicationObject, String eventName) {
    Map<String, Object> factsMap = new Map<String, Object>(); //Notification DTO level fact map
    tffa.NotificationDTO notif = new tffa.NotificationDTO();
    List<Id> partyIds = new List<Id>();
    partyIds.add(party.Id);
    List<tffa__SubmissionPartyXref__c> subPartyXref = CZWTFCSubmissionRepository.findSubmissionByParty(partyIds);
    tffa__Submission__c sub = CZWTFCSubmissionRepository.findOne(subPartyXref[0].tffa__Submission__c);
    tffa__Brand__c brandObj = CZWTFCBrandRepository.fetchBrandByCode(sub.tffa__Brand__c);
    String suffix = party.tffa__Suffix__c != null ? ' ' + party.tffa__Suffix__c : '';
    User currentUserObj = tffa.UserService.getCurrentUser();
    tffa__AgentDetail__c agentDetails = CZWTFCHelperRepository.getAgentDetailsByUserId(currentUserObj.Id);

    if (party.tffa__Type__c == 'INDIVIDUAL') {
      factsMap.put('PartyName', party.tffa__FirstName__c + ' ' + party.tffa__LastName__c + suffix);
    } else {
      factsMap.put('PartyName', party.tffa__LegalName__c);
    }

    factsMap.put('otp', party.tffa__OTP__c);
    factsMap.put('brandName', brandObj.Name);
    factsMap.put('phoneNo', brandObj.EmailPhone__c);
    factsMap.put('logoUrl', brandObj.EmailHeaderLogoUrl__c);
    factsMap.put('address', brandObj.Address__c);
    factsMap.put('city', brandObj.City__c);
    factsMap.put('state', brandObj.State__c);
    factsMap.put('zip', brandObj.Zip__c);
    factsMap.put('bankUrl', brandObj.tffa__InfoUrl__c);
    factsMap.put('email', brandObj.tffa__ContactEmail__c);
    factsMap.put('ConfirmationNumber', sub.Name);
    factsMap.put('BankerName', currentUserObj.Name);
    factsMap.put('BankerEmail', currentUserObj.Email);

    if (bankerName != null) {
      factsMap.put('BankerName', bankerName);
    }

    if (brandObj.subBrand__r != null && !brandObj.subBrand__r.isEmpty()) {
      String subBrandName = '';
      boolean updatedfooter = true;
      String commaSeperateSubBrandName = '';
      for (SubBrand__c subBrandObj : brandObj.subBrand__r) {
        if (subBrandObj.ShowInEmail__c) {
          updatedfooter = false;
          if (subBrandName == '') {
            subBrandName += subBrandObj.Name;
            commaSeperateSubBrandName += subBrandObj.Name;
          } else {
            subBrandName += ' | ' + subBrandObj.Name;
            commaSeperateSubBrandName += ', ' + subBrandObj.Name;
          }
        }
      }

      factsMap.put('subBranchHeading', 'Our family of banks');
      factsMap.put('subBrandName', subBrandName);
      factsMap.put('footerBrand', commaSeperateSubBrandName + ' are branches of ' + brandObj.Name);

      if (updatedfooter) {
        factsMap.put('subBranchHeading', ' ');
        factsMap.put('subBrandName', ' ');
        factsMap.put('footerBrand', ' ');
      }
    } else {
      factsMap.put('subBranchHeading', ' ');
      factsMap.put('subBrandName', ' ');
      factsMap.put('footerBrand', ' ');
    }

    String buttonUrl = tffa__SiteUrl__c.getOrgDefaults().tffa__Url__c + PageReference.forResource('ReviewSignDisclosure').getUrl();
    String url =
      '<a href="' +
      party.tffa__Url__c +
      '&brandCode=' +
      sub.tffa__Brand__c +
      '"><img width="100" height="50" align="left" src="' +
      buttonUrl +
      '" alt="ReviewSignDisclosure"/></a><br/>';
    factsMap.put('appTrackerUrl', url);
    factsMap.put('disclosureDeliveryEmail', party.tffa__Url__c + '&brandCode=' + sub.tffa__Brand__c);
    tffa.Logger.debug('url ' + url);

    if (eventName == 'Party_OTP_Generated') {
      notif.confidential = true;
    } else if (eventName == 'Application_Declined_Adverse' && party.tffa__KYCDecisionOutcome__c == CZWTFCConstants.DECLINED) {
      String products = '';
      if (sub.tffa__Channel__c == FISCCIntegrationConstants.DIGITAL) {
        List<String> productNames = new List<String>();
        if (applicationObject == null && sub.tffa__Applications__r != null && !sub.tffa__Applications__r.isEmpty()) {
          for (tffa__Application__c app : sub.tffa__Applications__r) {
            if (app.tffa__Status__c == CZWTFCConstants.DECLINED || app.tffa__Status__c == CZWTFCConstants.COUNTER_OFFER) {
              productNames.add(app.Name);
            }
          }
        } else if (applicationObject != null) {
          productNames.add(applicationObject.Name);
        }

        if (productNames.size() == 1) {
          products = products + productNames[0];
        } else if (productNames.size() > 1) {
          Integer index = 1;
          for (String productName : productNames) {
            if (index != productNames.size()) {
              products = products + productName + ', ';
            } else {
              products = products.substring(0, products.lastIndexOf(', '));
              products = products + ' And ' + productName;
            }
            index++;
          }
        }
      } else {
        if (String.isNotBlank(productName)) {
          products = productName;
        } else {
          products = 'products';
        }
      }
      factsMap.put('products', products);
      PageReference pageRef = Page.adverseActionLetter;
      pageRef.getParameters().put('id', party.Id);
      if (!Test.isRunningTest()) {
        notif.attachments.put('AdverseActionNotice.pdf', pageRef.getContent());
        tffa__SubmissionPartyXref__c subPartyObj = CZWTFCPartyRepository.findSubPartyById(party.Id);
        String docName = party.Name.toLowerCase().replaceAll('\\s+', '_') + '_AdverseActionNotice.pdf';
        tffa.DocumentMetadataDTO adverseNoticeDoc = new tffa.DocumentMetadataDTO(docName, pageRef.getContent(), party.id, 'OTHER');
        //adverseNoticeDoc.participants.add(new tffa.DocumentParticipantDTO(null, (String) subPartyObj.tffa__Submission__c));
        tffa.ContentService.createContentWithParticipant(adverseNoticeDoc);
      }
    }
    notif.eventName = eventName;
    notif.facts = factsMap;
    notif.primaryEntityId = party.Id;
    notif.orgWideEmailAddress = brandObj.SenderEmailId__c;
    return notif;
  }

  global Object sendAdverseActionMail(tffa__Party__c party, tffa__Application__c appObj) {
    tffa.Logger.debug('in PartyEventExtension.sendAdverseActionMail for party ::' + party.Id + ' & eventname ::' + eventName);

    List<tffa.NotificationDTO> notifications = new List<tffa.NotificationDTO>();
    tffa.NotificationDTO.NotificationRecipientDTO[] recipients = new List<tffa.NotificationDTO.NotificationRecipientDTO>{};
    recipients.add(
      new tffa.NotificationDTO.NotificationRecipientDTO(
        tffa.NotificationDTO.NotificationRecipientType.PARTY,
        party.Id,
        party.Name,
        party.tffa__PrimaryEmail__c,
        party.tffa__PrimaryPhone__c
      )
    );
    if (!recipients.isEmpty()) {
      tffa.NotificationDTO notif = buildNotification(party, appObj, '');
      notif.recipients = recipients;
      notifications.add(notif);
    }

    if (!notifications.isEmpty()) {
      Map<String, Object> facts = new Map<String, Object>();
      facts.put('EventName', eventName);
      tffa.EmailNotificationDispatcher dispatcher = new tffa.EmailNotificationDispatcher();
      //.getInstance().getProvider(facts);
      dispatcher.dispatch(notifications, facts);
    }

    return party;
  }
}