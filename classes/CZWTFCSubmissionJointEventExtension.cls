// Copyright (c) 2019 Terafina Inc
/**
 * Used for publishing notifications about a Submission's lifecycle event to relevant stakeholders.
 * Lifecycle events include - <br>
 * 1. Submission_Primary_Submitted <br>
 * 2. Submission_Joint_Completed <br>
 * 3. Submission_Joint_Submitted <br>
 *
 * Typically invoked from SubmissionService. Mapping to a lifecycle event is done via EventConfiguration
 * (Custom Metadata).
 */
global inherited sharing class CZWTFCSubmissionJointEventExtension extends tffa.EventExtension {
  global CZWTFCSubmissionJointEventExtension(string eventName) {
    this.eventName = eventName;
  }

  global CZWTFCSubmissionJointEventExtension() {
  }

  public override Object post(Object obj) {
    if (!(obj instanceof tffa__Submission__c || obj instanceof tffa__SubmissionPartyXref__c)) {
      tffa.Logger.error('Input is not of type tffa__Submission__c or tffa__SubmissionPartyXref__c');
      return obj;
    }
    tffa__Submission__c sub;
    tffa__SubmissionPartyXref__c xref;

    if (obj instanceof tffa__Submission__c) {
      sub = (tffa__Submission__c) obj;
    } else if (obj instanceof tffa__SubmissionPartyXref__c) {
      xref = (tffa__SubmissionPartyXref__c) obj;
    }
    tffa.Logger.debug('in CZWTFCSubmissionJointEventExtension.post for eventname ::' + eventName);

    //move this to switch case
    if (eventName == 'Submission_Primary_Submitted') {
      processPrimaryApplicantNotifications(sub);
      processJointInitiatedNotifications(sub);
    } else if (eventName == 'Submission_Joint_Abandoned' || eventName == 'Submission_Joint_Saved') {
      processJointApplicantNotifications(xref);
    }

    return obj;
  }

  private void processPrimaryApplicantNotifications(tffa__Submission__c sub) {
    // sub = tffa.SubmissionRepository.findByIdWithPartiesAndApplications(sub.Id);
    sub = CZWTFCSubmissionRepository.findSubmissionAndChildObjById(sub.Id);
    List<tffa.NotificationDTO> notifications = new List<tffa.NotificationDTO>();
    if (!sub.tffa__PartyXrefs__r.isEmpty()) {
      for (tffa__SubmissionPartyXref__c spx : sub.tffa__PartyXrefs__r) {
        tffa.NotificationDTO.NotificationRecipientDTO[] recipients = new List<tffa.NotificationDTO.NotificationRecipientDTO>{};
        if (spx.tffa__Primary__c) {
          tffa__Party__c p = spx.tffa__Party__r;
          recipients.add(
            new tffa.NotificationDTO.NotificationRecipientDTO(
              tffa.NotificationDTO.NotificationRecipientType.PARTY,
              p.Id,
              p.Name,
              p.tffa__PrimaryEmail__c,
              p.tffa__PrimaryPhone__c
            )
          );
          if (!recipients.isEmpty()) {
            tffa.NotificationDTO notif = new tffa.NotificationDTO();
            notif.primaryEntityId = p.Id;
            notif.eventName = eventName;
            notif.recipients = recipients;
            notif = buildNotificationFacts(notif, sub, spx);
            notifications.add(notif);
          }
        }
      }
      if (!notifications.isEmpty()) {
        Map<String, Object> facts = new Map<String, Object>();
        facts.put('EventName', eventName);
        tffa.NotificationDispatcher dispatcher = tffa.NotificationDispatcherFactory.getInstance().getProvider(facts);
        dispatcher.dispatch(notifications, facts);
      }
    }
  }

  private void processJointInitiatedNotifications(tffa__Submission__c sub) {
    //sub = tffa.SubmissionRepository.findByIdWithPartiesAndApplications(sub.Id);
    sub = CZWTFCSubmissionRepository.findSubmissionAndChildObjById(sub.Id);
    List<tffa.NotificationDTO> notifications = new List<tffa.NotificationDTO>();
    if (!sub.tffa__PartyXrefs__r.isEmpty()) {
      for (tffa__SubmissionPartyXref__c spx : sub.tffa__PartyXrefs__r) {
        tffa.NotificationDTO.NotificationRecipientDTO[] recipients = new List<tffa.NotificationDTO.NotificationRecipientDTO>{};
        if (!spx.tffa__Primary__c && !spx.tffa__IsPresent__c) {
          tffa__Party__c p = spx.tffa__Party__r;
          recipients.add(
            new tffa.NotificationDTO.NotificationRecipientDTO(
              tffa.NotificationDTO.NotificationRecipientType.PARTY,
              p.Id,
              p.Name,
              p.tffa__PrimaryEmail__c,
              p.tffa__PrimaryPhone__c
            )
          );
          if (!recipients.isEmpty()) {
            //build url mail - Submission_Joint_Initiated
            tffa.NotificationDTO notif = new tffa.NotificationDTO();
            notif.eventName = 'Submission_Joint_Initiated';
            notif.primaryEntityId = p.Id;
            notif.recipients = recipients;
            notif = buildNotificationFacts(notif, sub, spx);
            notifications.add(notif);

            //build for otp mail - Submission_OTP_Generated
            notif = new tffa.NotificationDTO();
            notif.eventName = 'Submission_OTP_Generated';
            notif.primaryEntityId = p.Id;
            notif.confidential = true;
            notif.recipients = recipients;
            notif = buildNotificationFacts(notif, sub, spx);
            notifications.add(notif);
          }
        }
      }
      if (!notifications.isEmpty()) {
        Map<String, Object> facts = new Map<String, Object>();
        facts.put('EventName', eventName);
        tffa.NotificationDispatcher dispatcher = tffa.NotificationDispatcherFactory.getInstance().getProvider(facts);
        dispatcher.dispatch(notifications, facts);
      }
    }
  }

  @TestVisible
  private void processJointApplicantNotifications(tffa__SubmissionPartyXref__c spx) {
    // tffa__Submission__c sub = tffa.SubmissionRepository.findByIdWithPrimaryPartyAndApplications(spx.tffa__Submission__c);
    tffa__Submission__c sub = new tffa__Submission__c();
    sub = CZWTFCSubmissionRepository.findSubmissionAndChildObjById(spx.tffa__Submission__c);
    List<tffa.NotificationDTO> notifications = new List<tffa.NotificationDTO>();
    tffa.NotificationDTO.NotificationRecipientDTO[] recipients = new List<tffa.NotificationDTO.NotificationRecipientDTO>{};
    tffa.NotificationDTO.NotificationRecipientDTO[] ccRecipients = new List<tffa.NotificationDTO.NotificationRecipientDTO>{};
    tffa__Party__c p = spx.tffa__Party__r;
    recipients.add(
      new tffa.NotificationDTO.NotificationRecipientDTO(
        tffa.NotificationDTO.NotificationRecipientType.PARTY,
        p.Id,
        p.Name,
        p.tffa__PrimaryEmail__c,
        p.tffa__PrimaryPhone__c
      )
    );
    if (!recipients.isEmpty()) {
      //build for url mail
      tffa.NotificationDTO notif = new tffa.NotificationDTO();
      notifications.add(notif);
      notif.eventName = eventName;
      notif.recipients = recipients;
      notif = buildNotificationFacts(notif, sub, spx);
      if (eventName == 'Submission_Joint_Abandoned') {
        tffa__Party__c primaryParty = sub.tffa__PartyXrefs__r[0].tffa__Party__r;
        ccRecipients.add(
          new tffa.NotificationDTO.NotificationRecipientDTO(
            tffa.NotificationDTO.NotificationRecipientType.PARTY,
            primaryParty.Id,
            primaryParty.Name,
            primaryParty.tffa__PrimaryEmail__c,
            primaryParty.tffa__PrimaryPhone__c
          )
        );
        if (!ccRecipients.isEmpty()) {
          notif.ccRecipients = ccRecipients;
        }
      }
    }

    if (!notifications.isEmpty()) {
      Map<String, Object> facts = new Map<String, Object>();
      facts.put('EventName', eventName);
      tffa.NotificationDispatcher dispatcher = tffa.NotificationDispatcherFactory.getInstance().getProvider(facts);
      dispatcher.dispatch(notifications, facts);
    }
  }

  private tffa.NotificationDTO buildNotificationFacts(
    tffa.NotificationDTO notif,
    tffa__Submission__c sub,
    tffa__SubmissionPartyXref__c xref
  ) {
    Map<String, Object> factsMap = new Map<String, Object>(); //Notification DTO level fact map
    tffa__Party__c party = xref.tffa__Party__r;
    String suffix = '';
    switch on eventName {
      when 'Submission_Joint_Abandoned', 'Submission_Joint_Saved' {
        //notif.addFact('PartyName', party.Name);
        suffix = party.tffa__Suffix__c != null ? ' ' + party.tffa__Suffix__c : '';
        factsMap.put('PartyName', party.tffa__FirstName__c + ' ' + party.tffa__LastName__c + suffix);
        PageReference pageRef = new PageReference(tffa__SiteUrl__c.getOrgDefaults().tffa__Url__c + '/sales');
        pageRef.getParameters().put('q', buildQueryParam(sub, party, false));
        pageRef.getParameters().put('medium', 'email');
        pageRef.getParameters().put('source', 'notification');
        pageRef.getParameters().put('campaign', notif.eventName.toLowerCase());
        //notif.addFact('SubmissionQueryParam', pageRef.getUrl());
        factsMap.put('SubmissionQueryParam', pageRef.getUrl());
      }
      when 'Submission_Joint_Initiated', 'Submission_Primary_Submitted' {
        //notif.addFact('PartyName', party.Name);
        suffix = party.tffa__Suffix__c != null ? ' ' + party.tffa__Suffix__c : '';
        factsMap.put('PartyName', party.tffa__FirstName__c + ' ' + party.tffa__LastName__c + suffix);
        PageReference pageRef = new PageReference(tffa__SiteUrl__c.getOrgDefaults().tffa__Url__c + '/sales');
        pageRef.getParameters().put('q', buildQueryParam(sub, party, true));
        pageRef.getParameters().put('medium', 'email');
        pageRef.getParameters().put('source', 'notification');
        pageRef.getParameters().put('campaign', notif.eventName.toLowerCase());
        pageRef.getParameters().put('brandCode', sub.tffa__Brand__c);
        //notif.addFact('SubmissionQueryParam', pageRef.getUrl());
        factsMap.put('SubmissionQueryParam', pageRef.getUrl());

        //build for addition of facts  Submission_Joint_Initiated / Submission_Primary_Submitted
        tffa.Logger.debug('sub.tffa__Brand__c ::::' + sub.tffa__Brand__c);
        tffa__Brand__c brandObj = CZWTFCBrandRepository.fetchBrandByCode(sub.tffa__Brand__c);
        tffa.Logger.debug('brandObj subjointevnt ::::' + brandObj);
        factsMap.put('brandName', brandObj.Name);
        factsMap.put('phoneNo', brandObj.EmailPhone__c);
        factsMap.put('logoUrl', brandObj.EmailHeaderLogoUrl__c);
        factsMap.put('address', brandObj.Address__c);
        factsMap.put('city', brandObj.City__c);
        factsMap.put('state', brandObj.State__c);
        factsMap.put('zip', brandObj.Zip__c);
        factsMap.put('bankUrl', brandObj.tffa__InfoUrl__c);
        factsMap.put('email', brandObj.tffa__ContactEmail__c);
        tffa__Party__c primaryPartyObj = new tffa__Party__c();
        if (!sub.tffa__PartyXrefs__r.isEmpty()) {
          for (tffa__SubmissionPartyXref__c spXref : sub.tffa__PartyXrefs__r) {
            if (spXref.tffa__Type__c == 'INDIVIDUAL' && (spXref.tffa__Primary__c || spXref.tffa__PrimaryContact__c)) {
              primaryPartyObj = spXref.tffa__Party__r;
            }
          }
        }
        suffix = primaryPartyObj.tffa__Suffix__c != null ? ' ' + primaryPartyObj.tffa__Suffix__c : '';
        factsMap.put('primaryPartyName', primaryPartyObj.tffa__FirstName__c + ' ' + primaryPartyObj.tffa__LastName__c + suffix);
        if (brandObj.subBrand__r != null && !brandObj.subBrand__r.isEmpty()) {
          String subBrandName = '';
          String commaSeperateSubBrandName = '';
          for (SubBrand__c subBrandObj : brandObj.subBrand__r) {
            if (subBrandName == '') {
              subBrandName += subBrandObj.Name;
              commaSeperateSubBrandName += subBrandObj.Name;
            } else {
              subBrandName += ' | ' + subBrandObj.Name;
              commaSeperateSubBrandName += ', ' + subBrandObj.Name;
            }
          }

          factsMap.put('subBranchHeading', 'Our family of banks');
          factsMap.put('subBrandName', subBrandName);
          factsMap.put('footerBrand', commaSeperateSubBrandName + ' are branches of ' + brandObj.Name);
        } else {
          factsMap.put('subBranchHeading', ' ');
          factsMap.put('subBrandName', ' ');
          factsMap.put('footerBrand', ' ');
        }

        tffa.Logger.debug('factsMap subjointevnt ::::' + factsMap);
        notif.orgWideEmailAddress = brandObj.SenderEmailId__c;
        notif.facts = factsMap;
      }
      when 'Submission_OTP_Generated' {
        suffix = party.tffa__Suffix__c != null ? ' ' + party.tffa__Suffix__c : '';
        factsMap.put('PartyName', party.tffa__FirstName__c + ' ' + party.tffa__LastName__c + suffix);
        tffa.Logger.debug('sub.tffa__Brand__c ::::' + sub.tffa__Brand__c);
        tffa__Brand__c brandObj = CZWTFCBrandRepository.fetchBrandByCode(sub.tffa__Brand__c);
        tffa.Logger.debug('brandObj subjointevnt ::::' + brandObj);
        factsMap.put('brandName', brandObj.Name);
        factsMap.put('phoneNo', brandObj.EmailPhone__c);
        factsMap.put('logoUrl', brandObj.EmailHeaderLogoUrl__c);
        factsMap.put('address', brandObj.Address__c);
        factsMap.put('city', brandObj.City__c);
        factsMap.put('state', brandObj.State__c);
        factsMap.put('zip', brandObj.Zip__c);
        factsMap.put('bankUrl', brandObj.tffa__InfoUrl__c);
        factsMap.put('email', brandObj.tffa__ContactEmail__c);
        if (brandObj.subBrand__r != null && !brandObj.subBrand__r.isEmpty()) {
          String subBrandName = '';
          String commaSeperateSubBrandName = '';
          for (SubBrand__c subBrandObj : brandObj.subBrand__r) {
            if (subBrandName == '') {
              subBrandName += subBrandObj.Name;
              commaSeperateSubBrandName += subBrandObj.Name;
            } else {
              subBrandName += ' | ' + subBrandObj.Name;
              commaSeperateSubBrandName += ', ' + subBrandObj.Name;
            }
          }

          factsMap.put('subBranchHeading', 'Our family of banks');
          factsMap.put('subBrandName', subBrandName);
          factsMap.put('footerBrand', commaSeperateSubBrandName + ' are branches of ' + brandObj.Name);
        } else {
          factsMap.put('subBranchHeading', ' ');
          factsMap.put('subBrandName', ' ');
          factsMap.put('footerBrand', ' ');
        }

        tffa.Logger.debug('factsMap subjointevnt ::::' + factsMap);
        notif.orgWideEmailAddress = brandObj.SenderEmailId__c;
        notif.facts = factsMap;
      }
      when else {
        notif.primaryEntityId = party.Id;
      }
    }
    tffa.Logger.debug('Notification dto ::::' + notif);
    return notif;
  }

  private String buildQueryParam(tffa__Submission__c sub, tffa__Party__c party, Boolean otpStatus) {
    //build url params
    Map<String, String> urlParams = new Map<String, String>();
    urlParams.put('Submission__c', sub.Id);
    urlParams.put('Party__c', party.Id);
    if (otpStatus) {
      urlParams.put('OTPStatus__c', 'CHALLENGED');
    }

    //encrypt
    // String q = tffa.ApexPageUtils.encryptQueryParameters(urlParams);
    String q = '';
    if (!Test.isRunningTest()) {
      q = tffa.Cipher.encrypt(JSON.serialize(urlParams));
    }
    return q;
  }
}