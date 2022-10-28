// Copyright (c) 2019 Terafina Inc
/**
 * Used for publishing notifications about a Submission's lifecycle event to relevant stakeholders.
 * Lifecycle events included are - <br>
 * 1. Submission_Reminder <br>
 * 2. Submission_Abandoned <br>
 * 3. Submission_Cancelled <br>
 * 4  Submission_Saved <br>
 * 5. Submission_Submitted <br>
 * 6. Submission_OTP_Generated <br>
 * 7. Submission_Link_Generated <br>
 * 8. Submission_Reminder_Unsubscribed <br>
 *
 * Typically invoked from SubmissionService. Mapping to a lifecycle event is done via EventConfiguration
 * (Custom Metadata).
 */
global inherited sharing class CZWTFCSubmissionEventExtension extends tffa.EventExtension {
  global CZWTFCSubmissionEventExtension(string eventName) {
    this.eventName = eventName;
  }

  global CZWTFCSubmissionEventExtension() {
  }
  /**
   * List of events to skip notifications if initiated from branch channel
   */
  static List<String> eventList {
    get {
      if (eventList == null) {
        eventList = new List<String>{
          'Submission_Reminder',
          'Submission_Abandoned',
          'Submission_Saved',
          'Submission_Cancelled',
          'Submission_Submitted',
          'Submission_Review'
        };
      }
      return eventList;
    }
    private set;
  }

  public override Object post(Object obj) {
    List<tffa__Submission__c> subs;
    tffa__SubmissionPartyXref__c xref;

    tffa.Logger.debug('in SubmissionEventExtension.post for submission eventname ::' + eventName);

    if (obj instanceof List<tffa__Submission__c>) {
      subs = (List<tffa__Submission__c>) obj;
    } else if (obj instanceof tffa__Submission__c) {
      subs = new List<tffa__Submission__c>{ (tffa__Submission__c) obj };
    } else if (obj instanceof tffa__SubmissionPartyXref__c) {
      xref = (tffa__SubmissionPartyXref__c) obj;
    } else {
      tffa.Logger.error('Input is not of type List<Submission__c> or Submission__c or SubmissionPartyXref__c');
      return obj;
    }

    if (eventName == 'Submission_OTP_Generated') {
      processOTPNotifications(xref);
    } else {
      processSubmissionNotifications(subs);
    }
    return obj;
  }

  private void processSubmissionNotifications(List<tffa__Submission__c> subs) {
    // support transient submissions
    List<tffa.NotificationDTO> notifications = new List<tffa.NotificationDTO>();
    Boolean reviewMailFlag;
    for (tffa__Submission__c sub : subs) {
      try {
        sub = sub.Id == null ? sub : CZWTFCSubmissionRepository.findSubmissionAndChildObjById(sub.Id);

        reviewMailFlag = false;

        // The email should not be triggered for business applications.
        // For consumer applications in branch channel this is to be sent only if an application has a joint not present.
        if (
          sub.tffa__Channel__c.equalsIgnoreCase('BRANCH') &&
          eventName == 'Submission_Submitted' &&
          sub.tffa__KYCDecisionOutcome__c == 'REVIEW'
        ) {
          if (sub.tffa__Flow__c.equalsIgnoreCase('consumer') && (!sub.tffa__FilledJointly__c)) {
            reviewMailFlag = true;
          }
        }

        if (sub.tffa__SubmittedChannel__c == 'BRANCH' && eventList.contains(eventName) && (!reviewMailFlag)) {
          return;
        }

        // If Cancellation Reason is NON_RESIDENT Dont send the mail.
        if (
          (eventName == 'Submission_Saved' ||
          eventName == 'Submission_Reminder') &&
          !String.isEmpty(sub.tffa__CancellationReason__c) &&
          sub.tffa__CancellationReason__c == 'NON_RESIDENT'
        ) {
          continue;
        }

        //tffa.Logger.debug('sub obj-->'+sub);
        if (!sub.tffa__PartyXrefs__r.isEmpty()) {
          List<tffa__Party__c> parties = new List<tffa__Party__c>();
          //in case if submission goes in review state then we are sending mail to all applicants
          if (
            eventName == null &&
            system.today().format() == (sub.tffa__ReminderDate__c != null ? sub.tffa__ReminderDate__c.format() : null)
          ) {
            eventName = 'Submission_Reminder';
          }

          if (eventName == 'Submission_Submitted') {
            Boolean flgAdverseActionNoticeSent = false;
            for (tffa__Application__c app : sub.tffa__Applications__r) {
              /* for account opened cases .. email will be sent from Submission Executor */
              tffa.Logger.debug(app.Id + ' Submission_Submitted called : ' + app.tffa__Status__c);
              if (
                (sub.tffa__FilledJointly__c &&
                (app.tffa__Status__c.equals(CZWTFCConstants.DECLINED) || app.tffa__Status__c.equals(CZWTFCConstants.REVIEW)))
              ) {
                System.enqueueJob(new CZWTFCInvokeEmailService(app));
              }

              // adverse action notice mails as enqueue context will not have same user for doc upload
              if (!flgAdverseActionNoticeSent) {
                List<tffa__Party__c> partyList = new List<tffa__Party__c>();
                partyList.addAll(fetchAllParties(sub));
                for (tffa__Party__c pObj : partyList) {
                  if (
                    pObj.tffa__KYCDecisionOutcome__c.equals(CZWTFCConstants.DECLINED) &&
                    (app.tffa__KYCDecisionOutcome__c.equals(CZWTFCConstants.DECLINED) ||
                    app.tffa__KYCDecisionOutcome__c.equals(CZWTFCConstants.COUNTER_OFFER))
                  ) {
                    tffa.Logger.debug(pObj.Id + ' | triggering adverse event..');
                    new CZWTFCPartyEventExtension('Application_Declined_Adverse').post(pObj);
                  }
                }
                flgAdverseActionNoticeSent = true;
              }
            }
          }

          if (eventName == 'Submission_Submitted' && sub.tffa__KYCDecisionOutcome__c == 'REVIEW') {
            parties.addAll(fetchAllParties(sub));
            eventName = 'Submission_Review';
          }
          if (eventName == 'Submission_Submitted' && sub.tffa__KYCDecisionOutcome__c == 'DECLINED') {
            eventName = ''; // in case if submission goes into submitted state while it is auto declined we should not be triggering submission submitted mail.
          }
          if (eventName == 'Submission_Submitted' && sub.tffa__KYCDecisionOutcome__c == 'APPROVED') {
            eventName = ''; // in case if submission goes into submitted state while it is auto approved we should not be triggering submission submitted mail.
          }

          if (eventName == 'Micro_Deposit_Pending') {
            tffa__Party__c primaryParty = fetchPrimaryParty(sub);
            parties.add(primaryParty);
            eventName = 'Micro_Deposit_Pending';
          }

          if (eventName == 'Submission_Submitted' && sub.tffa__KYCDecisionOutcome__c == null) {
            eventName = '';
          } else {
            if (parties.isEmpty()) {
              parties.add(fetchPrimaryParty(sub));
            }
          }

          //continue code for Submission_Review event
          if (!parties.isEmpty()) {
            for (tffa__Party__c party : parties) {
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
              tffa.NotificationDTO notif = buildNotification(sub, party);
              notif.recipients = recipients;
              notifications.add(notif);
            }
          }
        }
      } catch (Exception ex) {
        tffa.Logger.error(
          'Exception in CZWTFCSubmissionEventExtension for submission ' +
          sub.Name +
          ': ' +
          ex.getMessage() +
          'LineNumber  :::' +
          ex.getStackTraceString()
        );
      }
    }

    if (!notifications.isEmpty()) {
      Map<String, Object> facts = new Map<String, Object>(); //these are dispatcher level facts
      facts.put('EventName', eventName);
      tffa.EmailNotificationDispatcher dispatcher = new tffa.EmailNotificationDispatcher();
      //.getInstance().getProvider(facts);
      dispatcher.dispatch(notifications, facts);
    }
  }

  private void processOTPNotifications(tffa__SubmissionPartyXref__c spx) {
    tffa__Submission__c sub = CZWTFCSubmissionRepository.findSubmissionAndChildObjById(spx.tffa__Submission__c);
    List<tffa.NotificationDTO> notifications = new List<tffa.NotificationDTO>();
    tffa.NotificationDTO.NotificationRecipientDTO[] recipients = new List<tffa.NotificationDTO.NotificationRecipientDTO>{};
    tffa__Party__c p = spx.tffa__Party__r;
    tffa.Logger.error('name of the party is ' + p.Name);
    tffa.Logger.error('Id of the party is ' + p.Id);
    tffa.Logger.error('otp of the party is ' + p.tffa__OTP__c);
    recipients.add(
      new tffa.NotificationDTO.NotificationRecipientDTO(
        tffa.NotificationDTO.NotificationRecipientType.PARTY,
        p.Id,
        p.Name,
        p.tffa__PrimaryEmail__c,
        p.tffa__PrimaryPhone__c
      )
    );
    //build for url mail
    tffa.NotificationDTO notif = buildNotification(sub, p);
    notif.confidential = true;
    notif.primaryEntityId = p.Id;
    notif.eventName = eventName;
    notif.recipients = recipients;
    notifications.add(notif);

    Map<String, Object> facts = new Map<String, Object>();
    facts.put('EventName', eventName);
    tffa.EmailNotificationDispatcher dispatcher = new tffa.EmailNotificationDispatcher();
    //.getInstance().getProvider(facts);
    dispatcher.dispatch(notifications, facts);
  }

  private tffa.NotificationDTO buildNotification(tffa__Submission__c sub, tffa__Party__c party) {
    Map<String, Object> factsMap = new Map<String, Object>(); //Notification DTO level fact map

    tffa__Brand__c brandObj = CZWTFCBrandRepository.fetchBrandByCode(sub.tffa__Brand__c);

    String accType = '';
    for (tffa__Application__c app : sub.tffa__Applications__r) {
      accType = app.Name + ', ' + accType;
    }
    accType = accType.substring(0, accType.length() - 2);
    tffa.Logger.debug('CZWTFCSubmissionEventExtension.processSubmissionNotifications accType : ' + accType);

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
    factsMap.put('AccountType', accType); //  app.Name
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

    tffa.NotificationDTO notif = new tffa.NotificationDTO();
    notif.eventName = eventName;
    String suffix = '';
    switch on eventName {
      when 'Submission_Saved', 'Submission_Abandoned', 'Micro_Deposit_Pending' {
        // notif.primaryEntityId = xref.Id;
        notif.primaryEntityId = sub.Id;
        suffix = party.tffa__Suffix__c != null ? ' ' + party.tffa__Suffix__c : '';
        factsMap.put('PartyName', party.tffa__FirstName__c + ' ' + party.tffa__LastName__c + suffix);
        PageReference pageRef = new PageReference(tffa__SiteUrl__c.getOrgDefaults().tffa__Url__c + '/apptracker');
        //pageRef.getParameters().put('q', buildQueryParam(sub, party));
        //pageRef.getParameters().put('medium', 'email');
        //pageRef.getParameters().put('source', 'notification');
        //pageRef.getParameters().put('campaign', notif.eventName.toLowerCase());
        pageRef.getParameters().put('brandCode', sub.tffa__Brand__c);
        pageRef.getParameters().put('Id', party.Id);
        factsMap.put('SubmissionQueryParam', pageRef.getUrl());
      }
      when 'Submission_Review' {
        notif.primaryEntityId = sub.Id;
        suffix = party.tffa__Suffix__c != null ? ' ' + party.tffa__Suffix__c : '';
        factsMap.put('PartyName', party.tffa__FirstName__c + ' ' + party.tffa__LastName__c + suffix);
        PageReference pageRef = new PageReference(tffa__SiteUrl__c.getOrgDefaults().tffa__Url__c + '/apptracker');
        // pageRef.getParameters().put('q', buildQueryParam(sub, party));
        // pageRef.getParameters().put('medium', 'email');
        // pageRef.getParameters().put('source', 'notification');
        // pageRef.getParameters().put('campaign', notif.eventName.toLowerCase());
        pageRef.getParameters().put('brandCode', sub.tffa__Brand__c);
        pageRef.getParameters().put('Id', party.Id);
        factsMap.put('SubmissionQueryParam', pageRef.getUrl());
      }
      when 'Submission_Cancelled' {
        notif.primaryEntityId = sub.Id;
        suffix = party.tffa__Suffix__c != null ? ' ' + party.tffa__Suffix__c : '';
        factsMap.put('PartyName', party.tffa__FirstName__c + ' ' + party.tffa__LastName__c + suffix);
        if (!Test.isRunningTest()) {
          PageReference pageRef = new PageReference(tffa__SiteUrl__c.getOrgDefaults().tffa__Url__c);
          pageRef.getParameters().put('brandCode', sub.tffa__Brand__c);
          pageRef.getParameters().put('Id', party.Id);
          factsMap.put('SubmissionQueryParam', pageRef.getUrl());
        }
      }
      when 'Submission_Reminder' {
        notif.primaryEntityId = sub.Id;
        suffix = party.tffa__Suffix__c != null ? ' ' + party.tffa__Suffix__c : '';
        factsMap.put('PartyName', party.tffa__FirstName__c + ' ' + party.tffa__LastName__c + suffix);
        /*       PageReference pageRef = new PageReference(tffa__SiteUrl__c.getOrgDefaults().tffa__Url__c + '/sales');
         */
        PageReference unsubscribePageRef = new PageReference(tffa__SiteUrl__c.getOrgDefaults().tffa__Url__c + '/unsubscribe');
        /*       pageRef.getParameters().put('q', buildQueryParam(sub, party));
        pageRef.getParameters().put('medium', 'email');
        pageRef.getParameters().put('source', 'notification');
        pageRef.getParameters().put('campaign', notif.eventName.toLowerCase());
        factsMap.put('SubmissionQueryParam', pageRef.getUrl());
        pageRef.getParameters().put('brandCode', sub.tffa__Brand__c);
*/
        PageReference pageRef = new PageReference(tffa__SiteUrl__c.getOrgDefaults().tffa__Url__c + '/apptracker');
        pageRef.getParameters().put('brandCode', sub.tffa__Brand__c);
        pageRef.getParameters().put('Id', party.Id);
        factsMap.put('SubmissionQueryParam', pageRef.getUrl());
        factsMap.put('SubmissionUnsubscribeQueryParam', unsubscribePageRef.getUrl());
      }
      when 'Submission_Link_Generated' {
        // skip setting primaryEntityId
        suffix = party.tffa__Suffix__c != null ? ' ' + party.tffa__Suffix__c : '';
        factsMap.put('PartyName', party.tffa__FirstName__c + ' ' + party.tffa__LastName__c + suffix);
        factsMap.put('SubmissionUrl', sub.tffa__Url__c);
      }
      when 'Submission_Reopened' {
        notif.primaryEntityId = sub.Id;
        PageReference pageRef = new PageReference(tffa__SiteUrl__c.getOrgDefaults().tffa__Url__c + '/sales');
        pageRef.getParameters().put('q', buildQueryParam(sub, party));
        pageRef.getParameters().put('medium', 'email');
        pageRef.getParameters().put('source', 'notification');
        pageRef.getParameters().put('campaign', notif.eventName.toLowerCase());
        factsMap.put('SubmissionQueryParam', pageRef.getUrl());
      }
      when 'Submission_OTP_Generated' {
        tffa.Logger.error('54321 Party Id is ' + party.Id);
        notif.primaryEntityId = party.Id;
        suffix = party.tffa__Suffix__c != null ? ' ' + party.tffa__Suffix__c : '';
        factsMap.put('PartyName', party.tffa__FirstName__c + ' ' + party.tffa__LastName__c + suffix);
        factsMap.put('otp', party.tffa__OTP__c);
      }
      when else {
        notif.primaryEntityId = party.Id;
      }
    }
    notif.facts = factsMap;
    notif.orgWideEmailAddress = brandObj.SenderEmailId__c;
    return notif;
  }

  private String buildQueryParam(tffa__Submission__c sub, tffa__Party__c party) {
    //build url params
    Map<String, String> urlParams = new Map<String, String>();
    urlParams.put('Submission__c', sub.Id);
    urlParams.put('Party__c', party.Id);
    String q = '';
    //encrypt
    if (!Test.isRunningTest()) {
      q = tffa.Cipher.encrypt(JSON.serialize(urlParams));
    }
    return q;
  }

  private tffa__Party__c fetchPrimaryParty(tffa__Submission__c sub) {
    tffa__Party__c primaryParty;
    for (tffa__SubmissionPartyXref__c xref : sub.tffa__PartyXrefs__r) {
      if (xref.tffa__Type__c == 'INDIVIDUAL' && (xref.tffa__Primary__c || xref.tffa__PrimaryContact__c)) {
        primaryParty = xref.tffa__Party__r;
      }
    }
    if (primaryParty == null) {
      throw new tffa.ApplicationException('PRIMARY_PARTY_NOT_FOUND');
    }
    return primaryParty;
  }

  @TestVisible
  private List<tffa__Party__c> fetchAllParties(tffa__Submission__c sub) {
    List<tffa__Party__c> parties = new List<tffa__Party__c>();
    for (tffa__SubmissionPartyXref__c xref : sub.tffa__PartyXrefs__r) {
      if (xref.tffa__Type__c == 'INDIVIDUAL') {
        parties.add(xref.tffa__Party__r);
      }
    }
    if (parties == null || parties.isEmpty()) {
      throw new tffa.ApplicationException('PARTIES_NOT_FOUND');
    }
    return parties;
  }
}