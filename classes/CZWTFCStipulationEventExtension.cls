// Copyright (c) 2019 Terafina Inc
/**
 * Used for publishing notifications about a Submission's lifecycle event to relevant stakeholders.
 * Lifecycle events include Submission_Reminder, status events like Submission_Abandoned,
 * Submission_Cancelled, etc.<br>
 * Typically invoked from SubmissionService. Mapping to a lifecycle event is done via EventConfiguration
 * (Custom Metadata).
 */
global inherited sharing class CZWTFCStipulationEventExtension extends tffa.EventExtension {
  public string eventName;

  global CZWTFCStipulationEventExtension(string eventName) {
    this.eventName = eventName;
  }

  global CZWTFCStipulationEventExtension() {
  }

  global override Object post(Object obj) {
    tffa.Logger.debug('post - CZWTFCStipulationEventExtension');
    // this.eventName = 'Submission_Saved';
    List<tffa__Stipulation__c> stiLst = new List<tffa__Stipulation__c>();
    tffa__Stipulation__c stip = new tffa__Stipulation__c();

    if (obj instanceof List<tffa__Stipulation__c>) {
      stiLst = (List<tffa__Stipulation__c>) obj;
    } else if (obj instanceof tffa__Stipulation__c) {
      stiLst.add((tffa__Stipulation__c) obj);
    } else {
      tffa.Logger.error('Input is not of type tffa__Stipulation__c');
      return obj;
    }

    stip = stiLst.get(0);
    String stipId = stip.id;

    tffa__Stipulation__c stipulation = StipCustomMetadataRepository.getStipulation(stipId);
    tffa.Logger.debug('stipulation obj ::' + stip + ' & eventname ::' + eventName);
    tffa.Logger.debug('in CZWTFCStipulationEventExtension.post for submission ::' + stip.Id + ' & eventname ::' + eventName);
    //System.debug('in CZWTFCStipulationEventExtension.post for submission ::' + stip.Id + ' & eventname ::' + eventName);
    List<tffa.NotificationDTO> notifications = new List<tffa.NotificationDTO>();
    // tffa.Logger.debug('stipulation' + sub.tffa__Party__c + ' & eventname ::' + eventName);

    if (stipulation.tffa__Application__c != null) {
      String status = stipulation.tffa__Status__c;
      String emailid = stipulation.tffa__Party__r.tffa__PrimaryEmail__c;
      String userId = stipulation.CreatedById;
      User owner = CZDocusignRepository.fetchUserDetails(userId);
      tffa.Logger.debug('CZWTFCStipulationEventExtension.post : userId = ' + userId + ', owner =' + owner);
      tffa.Logger.debug('status = ' + status);

      if (status == 'UPLOADED' && stipulation.tffa__Submission__c != null) {
        tffa__Submission__c sub = CZWTFCSubmissionRepository.findOne(stipulation.tffa__Submission__c);
        if (sub.tffa__Status__c != 'SUBMITTED') {
          return obj;
        }
      }

      switch on status {
        when 'UPLOADED' {
          eventName = 'Stipulation_Uploaded';
        }
        when 'APPROVED' {
          eventName = 'Stipulation_Approved';
        }
        when 'NEW' {
          eventName = 'Stipulation_Created';
        }
        when 'REJECTED' {
          eventName = 'Stipulation_Rejected';
        }
        when 'WAIVED' {
          eventName = 'Stipulation_Created';
        }
        when else {
          eventName = '';
        }
      }

      // sub = tffa.SubmissionService.readWithPartiesAndApplications(sub.Id);
      // if (!sub.tffa__PartyXrefs__r.isEmpty()) {

      tffa.NotificationDTO.NotificationRecipientDTO[] recipients = new List<tffa.NotificationDTO.NotificationRecipientDTO>{};
      // tffa__Party__c p = spx.tffa__Party__r;

      if (status == 'UPLOADED') {
        recipients.add(
          new tffa.NotificationDTO.NotificationRecipientDTO(
            tffa.NotificationDTO.NotificationRecipientType.USER,
            owner.Id,
            owner.Name,
            owner.Email,
            owner.Phone
          )
        );
      } else {
        recipients.add(
          new tffa.NotificationDTO.NotificationRecipientDTO(
            tffa.NotificationDTO.NotificationRecipientType.PARTY,
            stipulation.tffa__Party__r.Id,
            stipulation.tffa__Party__r.Name,
            emailid,
            stipulation.tffa__Party__r.tffa__PrimaryPhone__c
          )
        );
      }
      if (!recipients.isEmpty()) {
        tffa.NotificationDTO notif = new tffa.NotificationDTO();
        notif = buildNotification(stipulation);
        notif.primaryEntityId = stipulation.tffa__Party__r.Id;
        notif.eventName = eventName;
        notif.recipients = recipients;
        notifications.add(notif);
      }
    }
    if (!notifications.isEmpty()) {
      Map<String, Object> facts = new Map<String, Object>();
      facts.put('EventName', eventName);
      //tffa.NotificationDispatcher dispatcher = tffa.NotificationDispatcherFactory.getInstance().getProvider(facts);
      tffa.EmailNotificationDispatcher dispatcher = new tffa.EmailNotificationDispatcher();
      dispatcher.dispatch(notifications, facts);
    }

    return obj;
  }

  private tffa.NotificationDTO buildNotification(tffa__Stipulation__c stipulation) {
    Map<String, Object> factsMap = new Map<String, Object>(); //Notification DTO level fact map
    tffa.NotificationDTO notif = new tffa.NotificationDTO();
    String appid = stipulation.tffa__Application__c;
    tffa__Application__c app = new tffa__Application__c();

    app = CZWTFCApplicationRepository.findApplicationById(appid);
    tffa__Brand__c brandObj = CZWTFCBrandRepository.fetchBrandByCode(app.tffa__Brand__c);
    String suffix = stipulation.tffa__Party__r.tffa__Suffix__c != null ? ' ' + stipulation.tffa__Party__r.tffa__Suffix__c : '';

    if (stipulation.tffa__Party__r.tffa__Type__c == 'INDIVIDUAL') {
      factsMap.put(
        'PartyName',
        stipulation.tffa__Party__r.tffa__FirstName__c +
        ' ' +
        stipulation.tffa__Party__r.tffa__LastName__c +
        suffix
      );
    } else {
      factsMap.put('PartyName', stipulation.tffa__Party__r.tffa__LegalName__c);
    }

    factsMap.put('brandName', brandObj.Name);
    factsMap.put('phoneNo', brandObj.EmailPhone__c);
    factsMap.put('logoUrl', brandObj.EmailHeaderLogoUrl__c);
    factsMap.put('address', brandObj.Address__c);
    factsMap.put('city', brandObj.City__c);
    factsMap.put('state', brandObj.State__c);
    factsMap.put('zip', brandObj.Zip__c);
    factsMap.put('bankUrl', brandObj.tffa__InfoUrl__c);
    factsMap.put('email', brandObj.tffa__ContactEmail__c);
    factsMap.put('ConfirmationNumber', app.SubmissionName__c);
    factsMap.put('Banker_Comments', stipulation.tffa__Comments__c);
    factsMap.put('Rejected_Comments', stipulation.tffa__RejectedComments__c);
    if (!Test.isRunningTest()) {
      PageReference pageRef = new PageReference(tffa__SiteUrl__c.getOrgDefaults().tffa__Url__c + '/apptracker');
      pageRef.getParameters().put('brandCode', app.tffa__Brand__c);
      pageRef.getParameters().put('Id', stipulation.tffa__Party__r.Id);
      factsMap.put('SubmissionQueryParam', pageRef.getUrl());
      tffa__EnvironmentConfiguration__c config = tffa__EnvironmentConfiguration__c.getOrgDefaults();
      factsMap.put('StipulationUploadClickHereURL', config.tffa__BaseUrl__c + '/' + stipulation.tffa__Party__r.Id);
    }
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

    notif.facts = factsMap;
    notif.orgWideEmailAddress = brandObj.SenderEmailId__c;
    tffa.Logger.debug('factsMap-->' + factsMap);
    return notif;
  }
}