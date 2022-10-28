public with sharing class FISCCIntegrationLogService extends CZWTFCIntegrationLogService {
  //submission attribute
  public static tffa__Submission__c submissionObj { get; set; }
  //party attribute
  public static list<tffa__Party__c> partyObjs { get; set; }
  //Application attribute
  public static list<tffa__Application__c> applicationObjs { get; set; }

  public static list<tffa__Application__c> reviewApps { get; set; }

  public static FISCC_Charter_Config__mdt charterConfig { get; set; }
  public static tffa__Brand__c brandObj { get; set; }

  public static String auth;
  public static String tempAuth;
  public static String applicationCode = '';
  public static Boolean isBatchSource = false;
  public static String entityAuthToken;

  public static Blob contentVersionData;
  public static String fcmDocumentId;

  public static void setCharterConfig(String brandCode) {
    charterConfig = FISCCIntegrationLogRepository.findCharterConfigByBrandCode(brandCode);
    if (!Test.isRunningTest()) {
      FISIBSAuthConfig__c fisAuthConfig = FISCCIntegrationLogRepository.findAuthByBrandandActiveState(brandCode, true);
      if (fisAuthConfig != null) {
        charterConfig.IBSAuthorization__c = fisAuthConfig.IBSAuthorization__c;
      }
    }
  }

  public static void setBrandObj(String brandCode) {
    brandObj = CZWTFCBrandRepository.fetchBrandByCode(brandCode);
  }

  public static void setSubmissionObj(String submissionId) {
    submissionObj = FISCCIntegrationLogRepository.findSubmissionById(submissionId);
    if (submissionObj != null)
      setCharterConfig(submissionObj.tffa__Brand__c);
    setBrandObj(submissionObj.tffa__Brand__c);
  }

  public static void setApplicationObjs() {
    applicationObjs = FISCCIntegrationLogRepository.findApplicationWithChildObjects(submissionObj.tffa__Applications__r);
  }

  public static void setPartyObjs() {
    List<Id> partyIds = new List<id>();
    for (tffa__SubmissionPartyXref__c partyXrefObj : submissionObj.tffa__PartyXrefs__r) {
      partyIds.add(partyXrefObj.tffa__Party__c);
    }
    partyObjs = FISCCIntegrationLogRepository.findPartydWithChildObjects(partyIds);
  }

  public static tffa__Submission__c fetchSubmissionById(String submissionId) {
    return FISCCIntegrationLogRepository.findSubmissionById(submissionId);
  }

  public static void persistData() {
    tffa.Logger.debug('Before Persist : Submission obj ::: ' + json.serialize(FISCCIntegrationLogService.submissionObj));
    tffa.Logger.debug('Before Persist : applicationObjs::: ' + json.serialize(FISCCIntegrationLogService.applicationObjs));
    tffa.Logger.debug('Before Persist : setPartyObjs ::: ' + json.serialize(FISCCIntegrationLogService.partyObjs));
    List<tffa__Beneficiary__c> benefList = new List<tffa__Beneficiary__c>();
    List<tffa__ApplicationPartyXref__c> appPartyLst = new List<tffa__ApplicationPartyXref__c>();
    List<tffa__AccountPreference__c> accPrefObjLst = new List<tffa__AccountPreference__c>();
    List<tffa__FundingRequest__c> fundingReqList = new List<tffa__FundingRequest__c>();
    List<tffa__AdditionalPreference__c> additionalPreferenceList = new List<tffa__AdditionalPreference__c>();
    //upsert party in salesforce
    if (FISCCIntegrationLogService.partyObjs != null && FISCCIntegrationLogService.partyObjs.size() != 0) {
      FISCCObjectManagerRepository.doUpsertPartys(FISCCIntegrationLogService.partyObjs);

      for(tffa__Party__c partyObj : FISCCIntegrationLogService.partyObjs){
        for(tffa__AdditionalPreference__c additionalPreference : partyObj.tffa__AdditionalPreferences__r){
          additionalPreferenceList.add(additionalPreference);
        }
      }

      FISCCObjectManagerRepository.doUpsertAdditionalPrefObj(additionalPreferenceList);
    }

    tffa.Logger.debug('party updated');
    if (isBatchSource) {
      for (tffa__Application__c applicationObject : FISCCIntegrationLogService.applicationObjs) {
        applicationObject.IsRoutingRequired__c = true;
      }
    }

    //upsert account
    if (FISCCIntegrationLogService.applicationObjs != null && !FISCCIntegrationLogService.applicationObjs.isEmpty()) {
      FISCCObjectManagerRepository.doUpsertApplications(FISCCIntegrationLogService.applicationObjs);
    }
    tffa.Logger.debug('Applications updated');
    if (FISCCIntegrationLogService.applicationObjs != null && !FISCCIntegrationLogService.applicationObjs.isEmpty()) {
      for (tffa__Application__c applicationObject : FISCCIntegrationLogService.applicationObjs) {
        if (applicationObject.tffa__Beneficiaries__r != null && !applicationObject.tffa__Beneficiaries__r.isEmpty()) {
          benefList.addAll(applicationObject.tffa__Beneficiaries__r);
        }

        if (applicationObject.tffa__PartyXrefs__r != null && !applicationObject.tffa__PartyXrefs__r.isEmpty()) {
          appPartyLst.addAll(applicationObject.tffa__PartyXrefs__r);
        }

        if (applicationObject.tffa__LinkedFundingRequests__r != null && !applicationObject.tffa__LinkedFundingRequests__r.isEmpty()) {
          fundingReqList.addAll(applicationObject.tffa__LinkedFundingRequests__r);
        }

        if (
          (applicationObject.tffa__Status__c == CZWTFCConstants.ACCOUNT_OPENED ||
          applicationObject.tffa__Status__c == CZWTFCConstants.FUNDED) &&
          applicationObject.tffa__AccountPreferences__r != null &&
          !applicationObject.tffa__AccountPreferences__r.isEmpty()
        ) {
          for (tffa__AccountPreference__c accPrefObj : applicationObject.tffa__AccountPreferences__r) {
            if (FISCCIntegrationConstants.OD_FOR_STANDARD_ADDON_TYPE == accPrefObj.tffa__AddOnServiceType__c) {
              accPrefObj.tffa__Status__c = CZWTFCConstants.ADDON_STATUS_COMPLETED;
              accPrefObjLst.add(accPrefObj);
            }
          }
        }

        /* send account opening email*/
        if (!isBatchSource) {
          try {
            System.enqueueJob(new CZWTFCAppRoutingService(applicationObject));
          } catch (Exception ex) {
            tffa.Logger.error('Exception in Routing Enqueue Job ' + ex.getMessage() + ' ' + ex.getStackTraceString());
            applicationObject.IsRoutingRequired__c = true;
          }
        }
      }
    }

    if (benefList != null && !benefList.isEmpty()) {
      FISCCObjectManagerRepository.doUpsertBeneficiarys(benefList);
      tffa.Logger.debug('Beneficiary updated updated');
    }

    if (appPartyLst != null && !appPartyLst.isEmpty()) {
      FISCCObjectManagerRepository.doApplicationPartyReq(appPartyLst);
      tffa.Logger.debug('ApplicationPartyXref updated');
    }

    if (fundingReqList != null && !fundingReqList.isEmpty()) {
      FISCCObjectManagerRepository.doUpsertFundingReq(fundingReqList);
      tffa.Logger.debug('fundingReqList updated updated');
    }

    if (accPrefObjLst != null && !accPrefObjLst.isEmpty()) {
      FISCCObjectManagerRepository.doUpsertAccountPrefObj(accPrefObjLst);
      tffa.Logger.debug('AccountPreference updated');
    }

    persistIntegationLogs();
    //--- Update Submission

    FISCCObjectManagerRepository.doUpsertSubmission(FISCCIntegrationLogService.submissionObj);
    tffa.Logger.debug('Submission updated');
  }

  /**
   * Triggers one mail (only primary applicant) per submission having a funding request verification status as Manual pending
   */
  public static void triggerMailForManualFundingPending(String subId) {
    tffa__FundingRequest__c fundingRequest = null;
    String fundingVerificationStatus = null;
    tffa__Submission__c subObj;
    List<tffa__Application__c> appList;
    try {
      tffa.Logger.debug('start of funding verification status event');
      subObj = FISCCIntegrationLogRepository.findSubmissionById(subId);
      appList = FISCCIntegrationLogRepository.findApplicationWithChildObjects(subObj.tffa__Applications__r);
      if (!appList.isEmpty()) {
        for (tffa__application__c application : appList) {
          if (application != null && !application.tffa__LinkedFundingRequests__r.isEmpty()) {
            for (Integer i = 0; i < application.tffa__LinkedFundingRequests__r.size(); i++) {
              fundingRequest = application.tffa__LinkedFundingRequests__r[i];
              if (fundingRequest != null && !String.isBlank(fundingRequest.tffa__VerificationStatus__c)) {
                fundingVerificationStatus = String.valueOf(fundingRequest.tffa__VerificationStatus__c);
                if (FISCCIntegrationConstants.PENDING_MANUAL_VERIFICATION.endsWithIgnoreCase(fundingVerificationStatus)) {
                  try {
                    tffa.Logger.debug('TRIGGERING EVENT FOR FUNDING VERIFICATION STATUS');
                    (new CZWTFCApplicationEventExtension('Funding_Manual_Verification')).post(application);
                    return;
                  } catch (Exception ex) {
                    tffa.Logger.debug(
                      'Exception in Mail Events Triggering :::' +
                      ex.getMessage() +
                      ' LineNumber :::' +
                      ex.getStackTraceString()
                    );
                  }
                }
              }
            }
          }
        }
      }
    } catch (Exception e) {
      tffa.Logger.debug(' Exception in generateMails : ' + e.getMessage() + ' Exception :::' + e.getStackTraceString());
    }
  }
}