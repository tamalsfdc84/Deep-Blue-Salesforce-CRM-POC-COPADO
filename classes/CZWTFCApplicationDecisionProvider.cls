global with sharing class CZWTFCApplicationDecisionProvider extends tffa.ApplicationDecisionProvider {
  private static final String STATUS_REVIEW = 'REVIEW';
  private static final String STATUS_DECLINE = 'DECLINED';
  private static final String STATUS_APPROVE = 'APPROVED';
  private static final String STATUS_INCOMPLETE = 'INCOMPLETE';
  private static final String ID_SCAN = 'IDScan';
  private static final String COUNTER_OFFER = 'COUNTER_OFFER';
  @TestVisible
  private static tffa__Submission__c testSubmissionObj;

  private static WintrustEnvConfig__mdt wintrustEnvConfig = CZWTFCHelperRepository.fetchWintrustEnvConfig();
  private static Map<Id, tffa__Party__c> partyMap = new Map<Id, tffa__Party__c>();

  global override List<tffa__Application__c> doDecision(List<tffa__Application__c> applicationObjs, Map<String, Object> facts) {
    tffa__Submission__c submissionObj = null;
    String submissionId = null;
    Boolean allPartiesPresent = true;
    Boolean allPartiesCompleted = true;

    List<tffa__Application__c> modifiedApps = new List<tffa__Application__c>();
    tffa.Interaction.begin(CZWTFCApplicationDecisionProvider.class, 'doDecision');
    try {
      submissionId = tffa.Context.get() != null ? tffa.Context.get().id : '';
      submissionObj = CZWTFCSubmissionRepository.findSubmissionById(submissionId);
      if (Test.isRunningTest()) {
        submissionObj = testSubmissionObj;
      }
      applicationObjs = FISCCIntegrationLogRepository.findApplicationWithChildObjects(submissionObj.tffa__Applications__r);
      for (tffa__SubmissionPartyXref__c partyXref : submissionObj.tffa__PartyXrefs__r) {
        tffa.logger.debug('partyXref:' + partyXref);
        if (!partyXref.tffa__IsPresent__c)
          allPartiesPresent = false;
        if (STATUS_INCOMPLETE.equalsIgnoreCase(partyXref.tffa__Status__c))
          allPartiesCompleted = false;
      }

      if (!allPartiesCompleted) {
        tffa.logger.error('Since all parties have not completed their part, we will not go ahead with decisioning');
        return applicationObjs;
      }
      CZWTFCApplicationDecisionProvider.setPartyMap(submissionObj);
      List<String> appOutcomes = new List<String>();
      for (tffa__Application__c app : applicationObjs) {
        tffa.Logger.debug('Before tffa__Application__c doDecision ::: ' + app);
        app = doDecision(app, new Map<String, Object>(facts), submissionObj);
        //app = CZWTFCAppRoutingService.routeApplication(app);
        appOutcomes.add(app.tffa__AutoKYCDecisionOutcome__c);
        modifiedApps.add(app);
      }
      CZWTFCApplicationRepository.save(modifiedApps);
      //tffa.ApplicationAssigner appAssigner = new tffa.ApplicationAssigner();
      //appAssigner.assign(modifiedApps);

      submissionObj = updateSubmissionKYCStatus(submissionObj, modifiedApps);

      if (!allPartiesPresent && allPartiesCompleted && (CZWTFCConstants.SUBMITTED).equals(submissionObj.tffa__Status__c)) {
        tffa.Logger.error('All Parties completed now calling Process Submission Submission Name: ' + submissionObj.Name);
        if (appOutcomes.contains(STATUS_REVIEW) || appOutcomes.contains(STATUS_DECLINE)) {
          new CZWTFCSubmissionEventExtension('Submission_Submitted').post(submissionObj);
        }
      }
    } catch (Exception ex) {
      tffa.Logger.error(
        'Exception in List<tffa__Application__c> doDecision = ' +
        ex.getStackTraceString() +
        ' -> Message :' +
        ex.getMessage()
      );
    } finally {
      tffa.Interaction.close();
    }

    return modifiedApps;
  }

  public static tffa__Application__c doDecision(tffa__Application__c app, Map<String, Object> facts, tffa__Submission__c submissionObj) {
    List<tffa__Party__c> partyList = new List<tffa__Party__c>();
    boolean allPartiesPresent = true;
    // if KYC decision was overridden, skip performing a decision
    if (app.tffa__KYCDecisionOverridden__c) {
      return app;
    }
    List<tffa__ApplicationDecisionMatrix__c> appDMatrixList = new List<tffa__ApplicationDecisionMatrix__c>();
    for (tffa__SubmissionPartyXref__c partyXref : submissionObj.tffa__PartyXrefs__r) {
      tffa__Party__c party = partyXref.tffa__party__r;
      facts = fetchFacts(partyXref, app);
      tffa.Logger.debug('doDecision fetched facts :: ' + facts);
      List<tffa__ApplicationDecisionMatrix__c> result = tffa.ApplicationDecisionMatrixService.resolveByFacts('tffa__KYCFacts', facts);
      tffa.Logger.debug('Application Decision Outcome ' + result);
      tffa__ApplicationDecisionMatrix__c adm = result.isEmpty() ? null : result[0];
      if (adm == null) {
        tffa.Logger.error('No rule conditions matched in ApplicationDecisionMatrix, going with default outcome REVIEW');
        // default outcome
        adm = new tffa__ApplicationDecisionMatrix__c(
          tffa__Outcome__c = STATUS_REVIEW,
          tffa__Description__c = 'No rule conditions matched in ApplicationDecisionMatrix, setting default outcome REVIEW',
          tffa__SortOrder__c = -1
        );
      }

      appDMatrixList.add(adm);
      // updating party fields after decisioning
      //party.tffa__AutoKYCDecisionOutcome__c = adm.tffa__Outcome__c;
      //party.tffa__KYCDecisionOutcome__c = adm.tffa__Outcome__c;
      //party.tffa__AutoKYCDecisionRemarks__c = adm.tffa__Description__c;
      // party.tffa__AdverseActionNoticeRequired__c = adm.tffa__AdverseActionNoticeRequired__c;
      partyList.add(party);

      if (!partyXref.tffa__IsPresent__c && allPartiesPresent) {
        allPartiesPresent = false;
      }
    }
    partyList = CZWTFCPartyRepository.save(partyList);
    Integer worstPartyIndex = getWorstPartyIndex(appDMatrixList);
    // updating application fields after decisioning
    if (appDMatrixList != null) {
      if (!allPartiesPresent && (appDMatrixList.get(worstPartyIndex).tffa__Outcome__c).equalsIgnoreCase('COUNTER_OFFER')) {
        appDMatrixList.get(worstPartyIndex).tffa__Outcome__c = 'DECLINED';
      }
      if (String.isNotBlank(appDMatrixList.get(worstPartyIndex).CZAssignToQueue__c)) {
        app.CZKYCOutcomeQueueName__c = appDMatrixList.get(worstPartyIndex).CZAssignToQueue__c;
      }
      app.tffa__AutoKYCDecisionOutcome__c = appDMatrixList.get(worstPartyIndex).tffa__Outcome__c;
      app.tffa__KYCDecisionOutcome__c = appDMatrixList.get(worstPartyIndex).tffa__Outcome__c;
      // app.tffa__AdverseActionNoticeRequired__c = appDMatrixList.get(worstPartyIndex).tffa__AdverseActionNoticeRequired__c;
      app.tffa__Status__c = appDMatrixList.get(worstPartyIndex).tffa__Outcome__c == null
        ? app.tffa__Status__c
        : appDMatrixList.get(worstPartyIndex).tffa__Outcome__c;
      // if (STATUS_DECLINE.equalsIgnoreCase(app.tffa__KYCDecisionOutcome__c))
      //   app.tffa__Status__c = STATUS_DECLINE;

      if (COUNTER_OFFER.equalsIgnoreCase(app.tffa__KYCDecisionOutcome__c)) {
        app.tffa__CounterOffers__c = getCounterOfferItems(appDMatrixList.get(worstPartyIndex).tffa__CounterOffers__r);
      }

      if (appDMatrixList.get(worstPartyIndex).tffa__SortOrder__c == -1) {
        app.tffa__AutoKYCDecisionRemarks__c =
          'No rule condition matched in Application decision Matrix for Party  [' +
          partyList.get(worstPartyIndex).tffa__FirstName__c +
          ' ' +
          partyList.get(worstPartyIndex).tffa__LastName__c +
          '] - Setting default outcome REVIEW';
      } else {
        app.tffa__AutoKYCDecisionRemarks__c =
          'Matched row with sort order [' +
          appDMatrixList.get(worstPartyIndex).tffa__SortOrder__c +
          '] for Party  [' +
          partyList.get(worstPartyIndex).tffa__FirstName__c +
          ' ' +
          partyList.get(worstPartyIndex).tffa__LastName__c +
          '] - Remarks : ' +
          appDMatrixList.get(worstPartyIndex).tffa__Description__c;
      }
    }
    return app;
  }

  private static Map<String, Object> fetchFacts(tffa__SubmissionPartyXref__c partyXref, tffa__Application__c app) {
    Map<String, Object> facts = new Map<String, Object>();
    tffa__Party__c party = partyXref.tffa__Party__r;
    facts.put('Product__c', app.tffa__Product__r.Id);

    facts.put('DebitBureauScore__c', party.tffa__DebitBureauScore__c);

    facts.put('ProductCategory__c', app.tffa__Product__r.tffa__Category__c);
    facts.put('ProductCategorySet__c', app.tffa__Product__r.tffa__Category__c);
    facts.put('IDVStatus__c', party.tffa__IDVStatus__c);
    facts.put('DebitBureauStatus__c', party.tffa__DebitBureauStatus__c);
    facts.put('CZFraudStatus__c', party.tffa__FraudStatus__c);
    facts.put('CZPartyDecisionOutcome__c', party.tffa__AutoKYCDecisionOutcome__c);

    facts.put('IsAuthenticatedCustomer__c', party.IsAuthenticatedCustomer__c ? 'Yes' : 'No');

    facts.put('IsKYCRequired__c', (party.IsKYCRequired__c) ? 'Yes' : 'No');
    facts.put('IsAuthenticatedFlow__c', 'No');

    for (tffa__ApplicationPartyXref__c xref : app.tffa__PartyXrefs__r) {
      if (partyMap.containsKey(xref.tffa__party__c) && partyMap.get(xref.tffa__party__c).IsAuthenticatedCustomer__c) {
        facts.put('IsAuthenticatedFlow__c', 'Yes');
      }
    }

    if (party.tffa__IsExistingCustomer__c) {
      if (String.isNotBlank(party.FISLastName__c)) {
        facts.put('ExistingCustomerLastNameMatch__c', (party.FISLastName__c.equalsignorecase(party.tffa__LastName__c)) ? 'Yes' : 'No');
      } else {
        facts.put('ExistingCustomerLastNameMatch__c', 'Yes');
      }
      if (String.isNotBlank(party.FISDob__c)) {
        facts.put('ExistingCustomerDOBMatch__c', (Date.valueOf(party.FISDob__c) == party.tffa__BirthDate__c) ? 'Yes' : 'No');
      } else {
        facts.put('ExistingCustomerDOBMatch__c', 'Yes');
      }
    } else {
      facts.put('ExistingCustomerLastNameMatch__c', 'Yes');
      facts.put('ExistingCustomerDOBMatch__c', 'Yes');
    }
    return facts;
  }

  /**
   * Returns index of worst application outcome index for a given Application Decision Matrix list
   * @param List<tffa__ApplicationDecisionMatrix__c> admList
   * @return  Integer
   **/
  public static Integer getWorstPartyIndex(List<tffa__ApplicationDecisionMatrix__c> admList) {
    Integer i = 0;
    Integer worstPartyIndex = 0;
    for (tffa__ApplicationDecisionMatrix__c admResult : admList) {
      if (i == 0) {
        worstPartyIndex = i;
      } else {
        if (
          STATUS_REVIEW.equalsIgnoreCase(admResult.tffa__Outcome__c) &&
          STATUS_APPROVE.equalsIgnoreCase(admList.get(worstPartyIndex).tffa__Outcome__c)
        ) {
          worstPartyIndex = i;
        } else if (
          STATUS_REVIEW.equalsIgnoreCase(admResult.tffa__Outcome__c) &&
          COUNTER_OFFER.equalsIgnoreCase(admList.get(worstPartyIndex).tffa__Outcome__c)
        ) {
          worstPartyIndex = i;
        } else if (
          COUNTER_OFFER.equalsIgnoreCase(admResult.tffa__Outcome__c) &&
          STATUS_APPROVE.equalsIgnoreCase(admList.get(worstPartyIndex).tffa__Outcome__c)
        ) {
          worstPartyIndex = i;
        } else if (
          STATUS_DECLINE.equalsIgnoreCase(admResult.tffa__Outcome__c) &&
          (STATUS_APPROVE.equalsIgnoreCase(admList.get(worstPartyIndex).tffa__Outcome__c) ||
          STATUS_REVIEW.equalsIgnoreCase(admList.get(worstPartyIndex).tffa__Outcome__c) ||
          COUNTER_OFFER.equalsIgnoreCase(admList.get(worstPartyIndex).tffa__Outcome__c))
        ) {
          worstPartyIndex = i;
        }
      }
      i++;
    }
    return worstPartyIndex;
  }

  public static tffa__Submission__c updateSubmissionKYCStatus(tffa__Submission__c sub, List<tffa__Application__c> appList) {
    String submissionDecOutcome;
    Boolean reviewFlag = false;
    Boolean approvedFlag = false;
    for (tffa__Application__c appResult : appList) {
      if (STATUS_REVIEW.equalsIgnoreCase(appResult.tffa__KYCDecisionOutcome__c)) {
        submissionDecOutcome = STATUS_REVIEW;
        reviewFlag = true;
      } else if (STATUS_APPROVE.equalsIgnoreCase(appResult.tffa__KYCDecisionOutcome__c) && !reviewFlag) {
        submissionDecOutcome = STATUS_APPROVE;
        approvedFlag = true;
      } else if (STATUS_DECLINE.equalsIgnoreCase(appResult.tffa__KYCDecisionOutcome__c) && !reviewFlag && !approvedFlag)
        submissionDecOutcome = STATUS_DECLINE;
    }
    tffa.Logger.debug('submissionOutcome in doDecision :: ' + submissionDecOutcome);
    sub.tffa__KYCDecisionOutcome__c = submissionDecOutcome;
    CZWTFCApplicationRepository.save(new List<tffa__Submission__c>{ sub });
    return sub;
  }

  /**
   * Updates Manual KYC Decision of aplication
   * @param List<tffa__Application__c> apps
   * @param Map<String, Object> facts
   * @return  List<tffa__Application__c>
   **/
  global override List<tffa__Application__c> updateDecision(List<tffa__Application__c> apps, Map<String, Object> facts) {
    tffa.Logger.debug('Inside updateDecision');
    tffa.Interaction.begin(CZWTFCApplicationDecisionProvider.class, 'updateDecision');
    List<tffa__Application__c> appList = new List<tffa__Application__c>();
    tffa__Submission__c subObj = new tffa__Submission__c();
    try {
      if (apps.isEmpty()) {
        return apps;
      }
      Boolean flgAdverseActionNoticeSent = false;
      for (tffa__Application__c appObj : apps) {
        tffa__Application__c app = appObj;
        tffa__Application__c loadedApp = CZWTFCApplicationRepository.findApplicationById(appObj.Id);
        tffa.Logger.debug('Loaded Application : ' + loadedApp);
        if (loadedApp.tffa__Status__c.equals('ACCOUNT_OPENED') || loadedApp.tffa__Status__c.equals('FUNDED')) {
          throw new tffa.ApplicationException('Account is already opened.');
        }
        loadedApp.tffa__KYCDecisionOutcome__c = app.tffa__KYCDecisionOutcome__c;
        loadedApp.tffa__KYCApprovalReason__c = app.tffa__KYCApprovalReason__c;
        loadedApp.tffa__KYCDecisionOverrideComments__c = app.tffa__KYCDecisionOverrideComments__c;
        loadedApp.tffa__KYCDeclinedReason__c = app.tffa__KYCDeclinedReason__c;
        if (String.isNotBlank(app.tffa__Product__c)) {
          loadedApp.tffa__Product__c = app.tffa__Product__c;
        }

        if (String.isNotBlank(app.tffa__ProductCode__c)) {
          loadedApp.tffa__ProductCode__c = app.tffa__ProductCode__c;
        }

        if (String.isNotBlank(app.tffa__ProductCategory__c)) {
          loadedApp.tffa__ProductCategory__c = app.tffa__ProductCategory__c;
        }

        if (String.isNotBlank(app.Name)) {
          loadedApp.Name = app.Name;
        }
        app = loadedApp;
        tffa.Logger.debug('app.tffa__KYCDecisionOutcome__c  : ' + app.tffa__KYCDecisionOutcome__c);
        tffa.Logger.debug('app.tffa__KYCDeclinedReason__c : ' + app.tffa__KYCDeclinedReason__c);

        //apps = new List<tffa__Application__c>{ app };

        subObj = CZWTFCSubmissionRepository.findOne(app.tffa__Submission__c);

        if (STATUS_APPROVE.equalsIgnoreCase(app.tffa__KYCDecisionOutcome__c)) {
          try {
            if (facts.containsKey('IsCounterOffer__c') && !flgAdverseActionNoticeSent) {
              tffa__Submission__c submissionObj = CZWTFCSubmissionRepository.findSubmissionById(app.tffa__Submission__c);
              for (tffa__SubmissionPartyXref__c partyXref : submissionObj.tffa__PartyXrefs__r) {
                if (partyXref.tffa__Party__r.tffa__KYCDecisionOutcome__c.equals(CZWTFCConstants.DECLINED)) {
                  new CZWTFCPartyEventExtension('Application_Declined_Adverse').post(partyXref.tffa__Party__r);
                  flgAdverseActionNoticeSent = true;
                }
              }
            }
          } catch (Exception ex) {
            tffa.Logger.debug(' Exception in advAction block: ' + ex.getStackTraceString());
          }
          app.tffa__Status__c = STATUS_APPROVE;
          app = CZWTFCApplicationRepository.save(new List<tffa__Application__c>{ app })[0];
          if ((subObj.tffa__Status__c).equalsIgnoreCase('SUBMITTED')) {
            processSubmission(app.tffa__Submission__c);
          }
        } else if (STATUS_DECLINE.equalsIgnoreCase(app.tffa__KYCDecisionOutcome__c)) {
          app.tffa__Status__c = STATUS_DECLINE;
          app = CZWTFCAppRoutingService.routeApplication(app);
          CZWTFCApplicationRepository.save(new List<tffa__Application__c>{ app });
          if (!facts.containsKey('IsCounterOffer__c')) {
            // for other than counter offer flow
            (new CZWTFCApplicationEventExtension()).post(app);
          }
          //Adverse Action Mail
          if (!facts.containsKey('IsCounterOffer__c') && !flgAdverseActionNoticeSent) {
            tffa__Submission__c submissionObj = CZWTFCSubmissionRepository.findSubmissionById(app.tffa__Submission__c);
            for (tffa__SubmissionPartyXref__c partyXref : submissionObj.tffa__PartyXrefs__r) {
              if (partyXref.tffa__Party__r.tffa__KYCDecisionOutcome__c.equals(CZWTFCConstants.DECLINED)) {
                new CZWTFCPartyEventExtension('Application_Declined_Adverse').sendAdverseActionMail(partyXref.tffa__Party__r, app);
                flgAdverseActionNoticeSent = true;
              }
            }
          }
        }
        appList.add(app);
      }
      //select all applications .
      apps = CZWTFCApplicationRepository.findApplicationWithChildObjsBySubId(subObj);
      subObj = updateSubmissionKYCStatus(subObj, apps);

      return appList;
    } catch (Exception ex) {
      tffa.Logger.error(' Exception msg : ' + ex.getMessage() + ' ' + ex.getStackTraceString());
      throw new tffa.ApplicationException('Failed to update decision : ' + ex.getMessage());
    } finally {
      tffa.Interaction.close();
    }
  }

  @future(callout=true)
  public static void processSubmission(Id id) {
    tffa.Interaction.begin(CZWTFCApplicationDecisionProvider.class, 'processSubmission');
    try {
      FISCCIntegrationLogService.isBatchSource = true;
      FISCCSubmissionExecutor.processApplication(id);
    } catch (Exception ex) {
      tffa.Logger.error(' Exception msg : ' + ex.getMessage() + ' ' + ex.getStackTraceString());
    } finally {
      tffa.Interaction.close();
    }
  }

  public static boolean isIdUploaded(String partyId) {
    tffa__Party__c detailedParty = CZWTFCPartyRepository.findByIdWithChildObjects(partyId);
    if (
      detailedParty.tffa__Identifications__r != null &&
      !detailedParty.tffa__Identifications__r.isEmpty() &&
      detailedParty.tffa__Identifications__r[0] != null
    ) {
      if (
        !String.isBlank(detailedParty.tffa__Identifications__r[0].tffa__FrontPhotoId__c) ||
        !String.isBlank(detailedParty.tffa__Identifications__r[0].tffa__BackPhotoId__c)
      ) {
        return true;
      }
    }
    return false;
  }

  public static String getCounterOfferItems(List<tffa__CounterOfferItem__c> counteritemlist) {
    String idString = '';
    try {
      if (counteritemlist != null) {
        if (counteritemlist.size() > 0) {
          String[] tmp1 = new List<String>{};
          for (tffa__CounterOfferItem__c citem : counteritemlist) {
            tmp1.add(citem.tffa__Product__c);
          }

          idString = String.join(tmp1, ';');
        }
      }
    } catch (Exception ex) {
      tffa.Logger.debug(' Exception getCounterOfferItems : ' + ex.getMessage() + ' ' + ex.getLineNumber());
    }
    tffa.Logger.debug('CounterOfferItems list ids::' + idString);
    return idString;
  }

  public static void setPartyMap(tffa__Submission__c sub) {
    if (sub != null && sub.tffa__PartyXrefs__r != null && !sub.tffa__PartyXrefs__r.isEmpty()) {
      for (tffa__SubmissionPartyXref__c subPartyXref : sub.tffa__PartyXrefs__r) {
        partyMap.put(subPartyXref.tffa__party__c, subPartyXref.tffa__Party__r);
      }
    }
  }
}