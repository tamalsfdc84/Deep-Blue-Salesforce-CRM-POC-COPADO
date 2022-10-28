// Copyright (c) 2019 Terafina Inc
/**
 * Used for publishing notifications about a Application's lifecycle event to relevant stakeholders.
 * Lifecycle events include status events like Application_Approved, Application_Declined, etc.<br>
 * Typically invoked from ApplicationService. Mapping to a lifecycle event is done via EventConfiguration
 * (Custom Metadata).
 */
global inherited sharing class CZWTFCApplicationEventExtension extends tffa.EventExtension {
  public String eventName = '';
  public final String MANUAL_FUNDING_EVENT = 'Funding_Manual_Verification';

  global CZWTFCApplicationEventExtension(string eventName) {
    this.eventName = eventName;
  }

  global CZWTFCApplicationEventExtension() {
  }
  /**
   * Map of event names with respect to prequal application status
   */
  @TestVisible
  static Map<String, String> prequalEventMap {
    get {
      if (prequalEventMap == null) {
        prequalEventMap = new Map<String, String>();
        prequalEventMap.put('DECLINED', 'Application_PrequalDeclined');
        prequalEventMap.put('CREDIT_APPROVED', 'Application_PrequalCreditApproved');
        prequalEventMap.put('SUBMITTED', 'Application_PrequalSubmitted');
      }
      return prequalEventMap;
    }
    private set;
  }

  global override Object post(Object obj) {
    if (!(obj instanceof tffa__Application__c)) {
      tffa.Logger.error('Input is not of type Application__c');
      return obj;
    }
    tffa__Application__c app = (tffa__Application__c) obj;
    tffa.Logger.debug('in ApplicationEventExtension.post for application ::' + app.Id + ' & eventname ::' + eventName);
    app = CZWTFCApplicationRepository.findApplicationById(app.Id);

    tffa.Logger.debug('app.tffa__Submission__r.tffa__Channel__c : ' + app.tffa__Submission__r.tffa__Channel__c);

    if (
      (app.tffa__Submission__r.tffa__Channel__c.equals('BRANCH') && app.tffa__Status__c.equals(CZWTFCConstants.DECLINED)) ||
      app.tffa__AccountPurpose__c == 'DEBIT_CARD' // will not send mail if applied for any Debit Card.
    ) {
      tffa.Logger.debug('Channel - BRANCH && Status - Declined');
      return obj;
    }
    eventName = fetchEventName(app);

    if (app.tffa__ProductCategory__c.contains('SAFE_DEPOSIT_BOX')) {
      // will not send mail if ProductCategory contain SDB.
      tffa.Logger.debug('ProductCategory : ' + app.tffa__ProductCategory__c);
      return obj;
    }

    // The email should not be triggered for business applications.
    // For consumer applications in branch channel this is to be sent only if an application has a joint not present.
    if (eventName == 'Application_Approved') {
      if (app.tffa__Submission__r.tffa__Flow__c.equalsIgnoreCase('business')) {
        tffa.Logger.debug('CZWTFCApplicationEventExtension.post tffa__Flow__c :' + app.tffa__Submission__r.tffa__Flow__c);
        return obj;
      } else if (app.tffa__Submission__r.tffa__Channel__c.equalsIgnoreCase('BRANCH') && (app.tffa__Submission__r.tffa__FilledJointly__c)) {
        tffa.Logger.debug(
          'CZWTFCApplicationEventExtension.post tffa__Channel__c:' +
          app.tffa__Submission__r.tffa__Channel__c +
          ' & tffa__FilledJointly__c ::' +
          app.tffa__Submission__r.tffa__FilledJointly__c
        );
        return obj;
      }
    }

    // if (eventName == 'Application_Declined' || eventName == 'Application_PrequalDeclined') {
    //   processApplicationDeclinedEvents(app);
    // } else {
    processApplicationEvents(app);
    //}

    //resolveDisclosures(app.tffa__Submission__c, app);
    return obj;
  }

  private String fetchEventName(tffa__Application__c app) {
    // if (app.tffa__ProductCategory__c == 'MORTGAGE' && app.tffa__Prequal__c) {
    //   eventName = prequalEventMap.get(app.tffa__Status__c) != null ? prequalEventMap.get(app.tffa__Status__c) : eventName;
    // }
    tffa.Logger.debug('Inside  fetchEventName');
    if (MANUAL_FUNDING_EVENT.equals(eventName)) {
      return eventName;
    }
    tffa.Logger.debug(
      'app.tffa__Status__c = ' +
      app.tffa__Status__c +
      ', app.tffa__AutoKYCDecisionOutcome__c = ' +
      app.tffa__AutoKYCDecisionOutcome__c
    );

    if (app.tffa__Status__c.equals(CZWTFCConstants.APPROVED)) {
      eventName = 'Application_Approved';
    } else if (app.tffa__Status__c.equals(CZWTFCConstants.ACCOUNT_OPENED) || app.tffa__Status__c.equals(CZWTFCConstants.FUNDED)) {
      if (app.tffa__AutoKYCDecisionOutcome__c.equals(CZWTFCConstants.APPROVED)) {
        eventName = 'Application_AccountOpened';
      } else if (app.tffa__KYCDecisionOutcome__c.equals(CZWTFCConstants.APPROVED)) {
        eventName = 'AppManuallyApproved_AccOpened';
      }
    } else if (app.tffa__Status__c.equals(CZWTFCConstants.DECLINED)) {
      if (app.tffa__AutoKYCDecisionOutcome__c.equals(CZWTFCConstants.DECLINED)) {
        eventName = 'Application_Declined';
      } else if (app.tffa__KYCDecisionOutcome__c.equals(CZWTFCConstants.DECLINED)) {
        eventName = 'ApplicationManuallyDeclined';
      }
    } else {
      eventName = '';
    }

    tffa.Logger.debug('eventName =' + eventName);
    return eventName;
  }
  @TestVisible
  private void processApplicationEvents(tffa__Application__c app) {
    String ACH_FUNDING_TEXT = ' During the application process, you opted to fund your new account by an external transfer.';
    String BRANCH_FUNDING_TEXT = ' During the application process, you opted to fund your new account through an ATM/Branch Deposit. Please visit a Wintrust Branch or a participating ATM within the Wintrust Community Bank network to fund your new account within the next 30 days.';
    String WIRE_FUNDING_TEXT = ' During the application process, you opted to fund your new account through a wire transfer. Funds must be received within 30 days from today.';
    String DEBIT_FUNDING_TEXT = ' During the application process, you opted to fund your new account using a Debit Card.';
    String INTERNAL_FUNDING_TEXT = ' During the application process, you opted to fund your new account using an Existing Wintrust Account.';
    String DEBIT_CARD_FUNDING_FAILURE_TEXT = 'Notice: There was an issue with the funding of your new account. While we<br>still opened your account, you will need to fund it within 30 days from<br>today. Please find a branch or an ATM closest to you by going to<br><a href="www.wintrust.com/findus" style="color:#003e7e;text-decoration:underline;">www.wintrust.com/findus</a> to make a deposit.<br/><br/>';

    Map<String, Object> factsMap = new Map<String, Object>();
    // if (eventName == 'Application_AccountOpened') {
    tffa.Logger.debug('eventname-->' + eventName);
    tffa.Logger.debug('app.BrandCode__c-->' + app.tffa__Brand__c);
    tffa__Brand__c brandObj;

    brandObj = CZWTFCBrandRepository.fetchBrandByCode(app.tffa__Brand__c);

    factsMap.put('brandName', brandObj.Name);
    factsMap.put('brandShortName', (brandObj.BankShortName__c) == null ? '' : brandObj.BankShortName__c);
    factsMap.put('phoneNo', brandObj.EmailPhone__c);
    factsMap.put('logoUrl', brandObj.EmailHeaderLogoUrl__c);
    factsMap.put('address', brandObj.Address__c);
    factsMap.put('city', brandObj.City__c);
    factsMap.put('state', brandObj.State__c);
    factsMap.put('zip', brandObj.Zip__c);
    factsMap.put('bankUrl', brandObj.tffa__InfoUrl__c);
    factsMap.put('email', brandObj.tffa__ContactEmail__c);

    factsMap.put('ConfirmationNumber', app.SubmissionName__c);
    factsMap.put('onlineBankText', '');
    factsMap.put('DebitCardFailureText', '');

    if (brandObj != null && brandObj.subBrand__r != null && !brandObj.subBrand__r.isEmpty()) {
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
      if (brandObj != null) {
        factsMap.put('footerBrand', commaSeperateSubBrandName + ' are branches of ' + brandObj.Name);
      }

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

    List<tffa__FundingRequest__c> lstFunding = app.tffa__LinkedFundingRequests__r;
    factsMap.put('AccountType', app.Name);
    factsMap.put('AccountNumber', app.tffa__AccountNumber__c);
    if (!Test.isRunningTest()) {
      factsMap.put('RoutingNumber', brandObj.tffa__RoutingNumber__c);
    }
    if (lstFunding != null && !lstFunding.isEmpty()) {
      if (lstFunding[0].tffa__Type__c.equalsIgnoreCase(CZWTFCConstants.FUNDING_TYPE_ACH)) {
        factsMap.put('FundingText', ACH_FUNDING_TEXT);
      } else if (lstFunding[0].tffa__Type__c.equalsIgnoreCase(CZWTFCConstants.FUNDING_TYPE_WIRE)) {
        factsMap.put('FundingText', WIRE_FUNDING_TEXT);
      } else if (lstFunding[0].tffa__Type__c.equalsIgnoreCase(CZWTFCConstants.FUNDING_TYPE_BRANCH)) {
        factsMap.put('FundingText', BRANCH_FUNDING_TEXT);
      } else if (lstFunding[0].tffa__Type__c.equalsIgnoreCase(CZWTFCConstants.DEBIT_CARD)) {
        factsMap.put('FundingText', DEBIT_FUNDING_TEXT);
      } else if (lstFunding[0].tffa__Type__c.equalsIgnoreCase(CZWTFCConstants.INTERNAL_TRANSFER)) {
        factsMap.put('FundingText', INTERNAL_FUNDING_TEXT);
      } else {
        factsMap.put('FundingText', ' ');
      }
    } else {
      factsMap.put('FundingText', ' ');
    }
    // }

    if (MANUAL_FUNDING_EVENT.equals(eventName)) {
      triggerManualFundingEmailToPrimary(app, factsMap, brandObj);
      return;
    }

    tffa__Submission__c submission = CZWTFCSubmissionRepository.findSubmissionAndChildObjById(app.tffa__Submission__c);

    Map<String, Boolean> subPartyMap = new Map<String, Boolean>();
    for (tffa__SubmissionPartyXref__c subP : submission.tffa__PartyXrefs__r) {
      subPartyMap.put(subP.tffa__Party__c, subP.tffa__IsPresent__c);
    }
    tffa.Logger.debug('app.tffa__PartyXrefs__r = ' + app.tffa__PartyXrefs__r);

    if (!app.tffa__PartyXrefs__r.isEmpty()) {
      for (tffa__ApplicationPartyXref__c apx : app.tffa__PartyXrefs__r) {
        tffa.Logger.debug(
          'Channel : ' +
          app.tffa__Submission__r.tffa__Channel__c +
          ', Flow : ' +
          app.tffa__Submission__r.tffa__Flow__c +
          ', IsSigner : ' +
          apx.tffa__Party__r.CZIsSigner__c
        );
        if (
          app.tffa__ProductCategory__c.contains('BUSINESS') &&
          !(CZWTFCDisclosureHelper.ROLE_MAP.get('BUSINESS_SIGNER').contains(apx.tffa__RoleCode__c))
        ) {
          // will not send mail if ProductCategory contains BUSINESS & RoleCode is not AUTHORIZED_SIGNER.
          tffa.Logger.debug('continue : ProductCategory == business && RoleCode != authorized_signer');
          continue;
        }
        List<tffa.NotificationDTO> notifications = new List<tffa.NotificationDTO>();
        tffa.NotificationDTO.NotificationRecipientDTO[] recipients = new List<tffa.NotificationDTO.NotificationRecipientDTO>{};
        tffa__Party__c p = apx.tffa__Party__r;
        String suffix = p.tffa__Suffix__c != null ? ' ' + p.tffa__Suffix__c : '';
        factsMap.put('PartyName', p.tffa__FirstName__c + ' ' + p.tffa__LastName__c + suffix);
        factsMap.put('onlineBankText', '');
        if (!Test.isRunningTest()) {
          PageReference pageRef = new PageReference(tffa__SiteUrl__c.getOrgDefaults().tffa__Url__c + '/apptracker');
          pageRef.getParameters().put('brandCode', app.tffa__Brand__c);
          pageRef.getParameters().put('Id', p.Id);
          factsMap.put('SubmissionQueryParam', pageRef.getUrl());
        }

        if (
          lstFunding != null &&
          !lstFunding.isEmpty() &&
          lstFunding[0].tffa__Type__c.equalsIgnoreCase(CZWTFCConstants.DEBIT_CARD) &&
          lstFunding[0].tffa__Status__c.equalsIgnoreCase(CZWTFCConstants.FAILED) &&
          app.tffa__Status__c.equals(CZWTFCConstants.ACCOUNT_OPENED)
        ) {
          factsMap.put('DebitCardFailureText', DEBIT_CARD_FUNDING_FAILURE_TEXT);
        }

        /*if (eventName == 'AppManuallyApproved_AccOpened') {
          tffa__AdditionalPreference__c additionalPreference = CZWTFCPartyRepository.findAdditionalPreferenceByPartyIdAndCode(
            p.Id,
            'ONLINE-BANKING'
          );

          if (app.tffa__AutoKYCDecisionOutcome__c != 'COUNTER_OFFER' && additionalPreference != null && additionalPreference.tffa__Enabled__c) {
            factsMap.put('onlineBankText', fetchOnlineBankingText(factsMap.get('SubmissionQueryParam')));
          }
        }

        if (eventName == 'Application_AccountOpened') {
          tffa__Submission__c sub = CZWTFCSubmissionRepository.findSubWithProdById(p.Id);
          tffa__AdditionalPreference__c additionalPreference = CZWTFCPartyRepository.findAdditionalPreferenceByPartyIdAndCode(
            p.Id,
            'ONLINE-BANKING'
          );

          // If submitted by Joint then add OLB link in mail
          if (sub != null && !sub.tffa__FilledJointly__c && additionalPreference != null && additionalPreference.tffa__Enabled__c) {
            factsMap.put('onlineBankText', fetchOnlineBankingText(factsMap.get('SubmissionQueryParam')));
          }
        }*/

        tffa__AdditionalPreference__c additionalPreference = CZWTFCPartyRepository.findAdditionalPreferenceByPartyIdAndCode(
          p.Id,
          'ONLINE-BANKING'
        );

        tffa.Logger.debug('additionalPreference = ' + additionalPreference);

        if (additionalPreference != null && additionalPreference.tffa__Enabled__c) {
          factsMap.put(
            'onlineBankText',
            additionalPreference.tffa__Status__c == 'COMPLETED'
              ? fetchOnlineBankingText('ONLINE_BANKING_SUCCESS_TEXT', brandObj)
              : fetchOnlineBankingText('ONLINE_BANKING_FAILURE_TEXT', brandObj)
          );
        }

        if (subPartyMap.get(p.Id) != null && !subPartyMap.get(p.Id) && additionalPreference == null && p.IsOLBEnrolled__c != 'Y') {
          factsMap.put('onlineBankText', fetchOnlineBankingText('ONLINE_BANKING_JOINT_NOT_PRESENT_TEXT', brandObj));
        }

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
          // if (eventName == 'Application_AccountOpened') {
          //   notif.primaryEntityId = app.Id;
          // } else {
          //notif.primaryEntityId = fetchPrimaryPartyId(app);
          notif.primaryEntityId = app.id;
          //}
          notif.eventName = eventName;
          notif.recipients = recipients;
          notif.confidential = false;
          notif.facts = factsMap;
          notif.orgWideEmailAddress = brandObj.SenderEmailId__c;
          notifications.add(notif);
        }
        if (!notifications.isEmpty()) {
          Map<String, Object> facts = new Map<String, Object>();
          facts.put('EventName', eventName);
          facts = buildFacts(facts, app);

          tffa.EmailNotificationDispatcher dispatcher = new tffa.EmailNotificationDispatcher();

          dispatcher.dispatch(notifications, facts);
        }
        // if (p.tffa__AdverseActionNoticeRequired__c && eventName == 'Application_Declined') {
        //   new CZWTFCPartyEventExtension('Application_Declined_Adverse').post(p);
        // }
      }
    }
  }

  /**
   * Custom fact builder
   *
   * @param facts
   * @param app
   * @returns `Map<String, Object>`
   */
  private Map<String, Object> buildFacts(Map<String, Object> facts, tffa__Application__c app) {
    if (app.tffa__ProductCategory__c == 'MORTGAGE' && app.tffa__Prequal__c) {
      facts.put('RequestedAmount', app.tffa__RequestedAmount__c);
    }
    return facts;
  }

  /**
   *
   * @param app
   * @returns `String`
   
  private String fetchPrimaryPartyId(tffa__Application__c app) {
    tffa__Party__c primaryParty;
    for (tffa__ApplicationPartyXref__c xref : app.tffa__PartyXrefs__r) {
      if (xref.tffa__Type__c == 'INDIVIDUAL' && (xref.tffa__Primary__c || xref.tffa__PrimaryContact__c)) {
        primaryParty = xref.tffa__Party__r;
      }
    }
    if (primaryParty == null) {
      throw new tffa.ApplicationException('PRIMARY_PARTY_NOT_FOUND');
    }
    return primaryParty.Id;
  }
*/
  public void triggerManualFundingEmailToPrimary(tffa__Application__c app, Map<String, Object> factsMap, tffa__Brand__c brandObj) {
    tffa__Party__c p = new tffa__Party__c();
    if (!app.tffa__PartyXrefs__r.isEmpty()) {
      for (tffa__ApplicationPartyXref__c xref : app.tffa__PartyXrefs__r) {
        if (xref.tffa__Type__c == 'INDIVIDUAL' && (xref.tffa__Primary__c || xref.tffa__PrimaryContact__c)) {
          p = xref.tffa__Party__r;
        }
      }
      List<tffa.NotificationDTO> notifications = new List<tffa.NotificationDTO>();
      tffa.NotificationDTO.NotificationRecipientDTO[] recipients = new List<tffa.NotificationDTO.NotificationRecipientDTO>{};
      //factsMap.put('PartyName', p.tffa__FirstName__c);
      String suffix = p.tffa__Suffix__c != null ? ' ' + p.tffa__Suffix__c : '';
      factsMap.put('PartyName', p.tffa__FirstName__c + ' ' + p.tffa__LastName__c + suffix);
      if (!Test.isRunningTest()) {
        PageReference pageRef = new PageReference(tffa__SiteUrl__c.getOrgDefaults().tffa__Url__c + '/apptracker');
        pageRef.getParameters().put('brandCode', app.tffa__Brand__c);
        pageRef.getParameters().put('Id', p.Id);
        factsMap.put('SubmissionQueryParam', pageRef.getUrl());
      }
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
        // if (eventName == 'Application_AccountOpened') {
        //   notif.primaryEntityId = app.Id;
        // } else {
        //notif.primaryEntityId = fetchPrimaryPartyId(app);
        notif.primaryEntityId = p.id;
        //}
        notif.eventName = eventName;
        notif.recipients = recipients;
        notif.confidential = false;
        tffa.Logger.debug('Confidential attribute set to false 852741');
        notif.facts = factsMap;
        notif.orgWideEmailAddress = brandObj.SenderEmailId__c;
        notifications.add(notif);
      }
      if (!notifications.isEmpty()) {
        Map<String, Object> facts = new Map<String, Object>();
        facts.put('EventName', eventName);
        facts = buildFacts(facts, app);

        tffa.EmailNotificationDispatcher dispatcher = new tffa.EmailNotificationDispatcher();

        dispatcher.dispatch(notifications, facts);
      }
    }
  }

  // @TestVisible
  // private void processApplicationDeclinedEvents(tffa__Application__c app) {
  //   if (!app.tffa__PartyXrefs__r.isEmpty()) {
  //     tffa__Party__c primaryParty;
  //     List<tffa.NotificationDTO> notifications = new List<tffa.NotificationDTO>();
  //     tffa.NotificationDTO.NotificationRecipientDTO[] recipients = new List<tffa.NotificationDTO.NotificationRecipientDTO>{};
  //     for (tffa__ApplicationPartyXref__c apx : app.tffa__PartyXrefs__r) {
  //       tffa__Party__c p = apx.tffa__Party__r;
  //       recipients.add(
  //         new tffa.NotificationDTO.NotificationRecipientDTO(
  //           tffa.NotificationDTO.NotificationRecipientType.PARTY,
  //           p.Id,
  //           p.Name,
  //           p.tffa__PrimaryEmail__c,
  //           p.tffa__PrimaryPhone__c
  //         )
  //       );
  //       if (!recipients.isEmpty()) {
  //         tffa.NotificationDTO notif = new tffa.NotificationDTO();
  //         notif.primaryEntityId = app.Id;
  //         notif.eventName = eventName;
  //         notif.recipients = recipients;
  //         if (
  //           (eventName == 'Application_Declined' ||
  //           eventName == 'Application_PrequalDeclined') &&
  //           app.tffa__AdverseActionNoticeRequired__c &&
  //           p.tffa__KYCDecisionOutcome__c == 'DECLINED'
  //         ) {
  //           PageReference pageRef = Page.adverseActionLetter;
  //           pageRef.getParameters().put('id', tffa.Cipher.encrypt(apx.Id));
  //           if (!Test.isRunningTest()) {
  //             notif.attachments.put('AdverseActionNotice.pdf', pageRef.getContent());
  //           }
  //         }
  //         notifications.add(notif);
  //       }

  //       if (!notifications.isEmpty()) {
  //         Map<String, Object> facts = new Map<String, Object>();
  //         facts.put('EventName', eventName);
  //         tffa.EmailNotificationDispatcher dispatcher = new tffa.EmailNotificationDispatcher();

  //         dispatcher.dispatch(notifications, facts);
  //       }
  //     }
  //   }
  // }

  /**
   * Resolves and persists any additional disclosure for application with status as ACCCOUNT_OPENED.
   * @param sub Instance of submission object
   * @param apps Instance of applications
   */
  // private void resolveDisclosures(String submissionId, tffa__Application__c app) {
  //   tffa.Context ctx = tffa.Context.get();
  //   String originalEvent = ctx.eventName;
  //   ctx.eventName = eventName;
  //   tffa.Context.set(ctx);
  //   Map<String, Object> facts = new Map<String, Object>();
  //   facts.put('Submission__c', submissionId);
  //   facts.put('Application__c', app.id);
  //   List<tffa__Disclosure__c> disclosures = tffa.DisclosureService.resolve(facts);
  //   List<tffa__Disclosure__c> externalDisclosures = tffa.DisclosureService.fetchExternalDisclosures(app, facts);
  //   if (externalDisclosures != null && !externalDisclosures.isEmpty()) {
  //     disclosures.addAll(externalDisclosures);
  //   }
  //   if (disclosures != null && !disclosures.isEmpty()) {
  //     tffa.EventExtension.getInstance('Disclosure_Generated').post(disclosures);
  //   }
  //   ctx.eventName = originalEvent;
  //   tffa.Context.set(ctx);
  // }

  public String fetchOnlineBankingText(String code, tffa__Brand__c brandObj) {
    tffa.Logger.debug('fetchOnlineBankingText : code = ' + code);
    if (code == 'ONLINE_BANKING_SUCCESS_TEXT') {
      return '<br/>Congratulations! You have successfully enrolled for Online Banking.  For security purposes, you will receive a separate email with your temporary password and login instructions shortly.<br/>';
    } else if (code == 'ONLINE_BANKING_FAILURE_TEXT') {
      return '<br/>There was a system issue and your Online Banking enrollment was not successful.  Please click <a href="' +
        (String) tffa__EnvironmentConfiguration__c.getOrgDefaults().tffa__OnlineBankingUrl__c +
        '#pre-auth/self-enrollment' +
        '" style="text-decoration:underline;">here</a>' +
        ' to self-enroll or call us at ' +
        brandObj.EmailPhone__c +
        ' for assistance. We sincerely apologize for the inconvenience.<br/>';
    } else if (code == 'ONLINE_BANKING_JOINT_NOT_PRESENT_TEXT') {
      String buttonUrl = tffa__SiteUrl__c.getOrgDefaults().tffa__Url__c + PageReference.forResource('OLBEnroll').getUrl();

      return '<br/><p style="font-size:20px;font-weight:bold">Don’t forget!<p/><p>Sign up for online banking.</p><br/> <a href="' +
        (String) tffa__EnvironmentConfiguration__c.getOrgDefaults().tffa__OnlineBankingUrl__c +
        '#pre-auth/self-enrollment' +
        '"><img width="100" height="50" align="left" src="' +
        buttonUrl +
        '" alt="Enroll"/></a><br/><br/><br/>';
    }

    return '';
  }
}