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
  public static List<Date> holidayList { get; set; }

  public static Map<Id, tffa__Party__c> partyObjMap { get; set; }

  public static tffa__Party__c primaryPartyObj { get; set; }

  public static Map<Id, tffa__Application__c> applicationObjMap { get; set; }

  public static Map<Id, List<tffa__DueDiligence__c>> cddObjMap { get; set; }

  public static List<UploadFileHistory__c> uploadFileHistoryObjList { get; set; }

  public static Map<String, tffa__ApplicantRole__c> applicantRoleMap { get; set; }
  public static Map<String, tffa__Brand__c> brandMap { get; set; }

  public static Map<String, tffa__FundingRequest__c> SDB_Funding_Details_MAP { get; set; }

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
    brandMap = CZWTFCBrandRepository.fetchBrandCodeAndBrandInfo();
    holidayList = CZWTFCBrandRepository.fetchBrandHolidays(brandCode);
  }

  public static void setSubmissionObj(String submissionId) {
    submissionObj = FISCCIntegrationLogRepository.findSubmissionById(submissionId);
    if (submissionObj != null) {
      setCharterConfig(submissionObj.tffa__Brand__c);
      setBrandObj(submissionObj.tffa__Brand__c);
    }
  }

  public static void setApplicationObjs() {
    applicationObjMap = new Map<Id, tffa__Application__c>();
    applicantRoleMap = new Map<String, tffa__ApplicantRole__c>();
    applicationObjs = FISCCIntegrationLogRepository.findApplicationWithChildObjects(submissionObj.tffa__Applications__r);
    List<tffa__ApplicantRole__c> applicantRoleList = FISCCIntegrationLogRepository.findAllApplicantRole();
    if (!applicantRoleList.isEmpty()) {
      for (tffa__ApplicantRole__c appRole : applicantRoleList) {
        applicantRoleMap.put(appRole.tffa__Code__c, appRole);
      }
    }
    if (FISCCCommonHelper.containsSDBProduct(applicationObjs)) {
      SDB_Funding_Details_MAP = FISCCIntegrationLogRepository.getSDBFundingDetails(applicationObjs);
    }
  }

  public static void setPartyObjs() {
    List<Id> partyIds = new List<id>();
    List<Id> orgIds = new List<id>();
    for (tffa__SubmissionPartyXref__c partyXrefObj : submissionObj.tffa__PartyXrefs__r) {
      partyIds.add(partyXrefObj.tffa__Party__c);
    }
    partyObjs = FISCCIntegrationLogRepository.findPartydWithChildObjects(partyIds);
    partyObjMap = new Map<Id, tffa__Party__c>();
    if (partyObjs != null && !partyObjs.isEmpty()) {
      for (tffa__Party__c partyobject : partyObjs) {
        partyObjMap.put(partyobject.Id, partyobject);
        if (partyobject.tffa__Type__c == FISCCIntegrationConstants.ORGANIZATION) {
          orgIds.add(partyobject.Id);
        }
      }
    }

    if (orgIds != null && !orgIds.isEmpty()) {
      cddObjMap = new Map<Id, List<tffa__DueDiligence__c>>();
      List<tffa__DueDiligence__c> ddLst = FISCCIntegrationLogRepository.getCDDList(orgIds);
      if (ddLst != null && !ddLst.isEmpty()) {
        for (tffa__DueDiligence__c ddObj : ddLst) {
          if (cddObjMap.containsKey(ddObj.tffa__party__c)) {
            cddObjMap.get(ddObj.tffa__party__c).add(ddObj);
          } else {
            cddObjMap.put(ddObj.tffa__party__c, new List<tffa__DueDiligence__c>{ ddObj });
          }
        }
      }
    }

    tffa.logger.debug('partyObjs in FISCCIntegrationLogRepository ==>' + partyObjs);
  }

  public static void setUploadFileHistory(List<UploadFileHistory__c> uploadFileHistory) {
    tffa.logger.debug('uploadFileHistory in FISCCIntegrationLogRepository ==>' + uploadFileHistory);
    if (uploadFileHistoryObjList == null && !Test.isRunningTest()) {
      uploadFileHistoryObjList = new List<UploadFileHistory__c>();
    }
    uploadFileHistoryObjList.addAll(uploadFileHistory);
    tffa.logger.debug('uploadFileHistoryObjList in FISCCIntegrationLogRepository ==>' + uploadFileHistoryObjList);
  }

  public static tffa__Submission__c fetchSubmissionById(String submissionId) {
    return FISCCIntegrationLogRepository.findSubmissionById(submissionId);
  }

  public static void persistData() {
    tffa.Logger.debug('Before Persist : Submission obj ::: ' + json.serialize(FISCCIntegrationLogService.submissionObj));
    // tffa.Logger.debug('Before Persist : applicationObjs::: ' + json.serialize(FISCCIntegrationLogService.applicationObjs));
    List<tffa__Beneficiary__c> benefList = new List<tffa__Beneficiary__c>();
    List<tffa__ApplicationPartyXref__c> appPartyLst = new List<tffa__ApplicationPartyXref__c>();
    List<tffa__AccountPreference__c> accPrefObjLst = new List<tffa__AccountPreference__c>();
    List<tffa__FundingRequest__c> fundingReqList = new List<tffa__FundingRequest__c>();
    Set<tffa__Party__c> partyUpdatedLst = new Set<tffa__Party__c>();
    List<tffa__AdditionalPreference__c> additionalPreferenceList = new List<tffa__AdditionalPreference__c>();
    List<tffa__PartyPartyXref__c> partyXrefList = new List<tffa__PartyPartyXref__c>();
    List<Id> partyIdLst = new List<Id>();
    //upsert party in salesforce
    if (
      FISCCIntegrationLogService.partyObjMap != null &&
      FISCCIntegrationLogService.partyObjMap.values() != null &&
      FISCCIntegrationLogService.partyObjMap.size() != 0
    ) {
      for (tffa__Party__c partyObj : FISCCIntegrationLogService.partyObjMap.values()) {
        for (tffa__AdditionalPreference__c additionalPreference : partyObj.tffa__AdditionalPreferences__r) {
          additionalPreferenceList.add(additionalPreference);
        }
        if (
          partyObj.tffa__Type__c == FISCCIntegrationConstants.ORGANIZATION &&
          partyObj.tffa__PartyXrefs__r != null &&
          !partyObj.tffa__PartyXrefs__r.isEmpty()
        ) {
          partyXrefList.addAll(partyObj.tffa__PartyXrefs__r);
        }
        if (String.isBlank(partyObj.CZBatchUpdateStatus__c)) {
          partyObj.CZBatchUpdateStatus__c = FISCCIntegrationConstants.PARTY_UPDATE_REQUIRED;
        }
      }

      try {
        FISCCObjectManagerRepository.doUpsertParties(FISCCIntegrationLogService.partyObjMap.values());
      } catch (Exception ex) {
        tffa.Logger.error('Exception in PersistLog.doUpsertParties: ' + ex.getMessage() + ' ' + ex.getStackTraceString());
      }
      try {
        FISCCObjectManagerRepository.doUpsertAdditionalPrefObj(additionalPreferenceList);
      } catch (Exception ex) {
        tffa.Logger.error('Exception in PersistLog.doUpsertAdditionalPrefObj: ' + ex.getMessage() + ' ' + ex.getStackTraceString());
      }
      if (!partyXrefList.isEmpty()) {
        try {
          FISCCObjectManagerRepository.updateRecords(partyXrefList);
        } catch (Exception ex) {
          tffa.Logger.error('Exception in PersistLog.partyXrefList: ' + ex.getMessage() + ' ' + ex.getStackTraceString());
        }
      }

      // tffa.Logger.debug('Before Persist : party objs::: ' + json.serialize(FISCCIntegrationLogService.partyObjMap.values()));
    }

    tffa.Logger.debug('party updated');
    if (isBatchSource) {
      for (tffa__Application__c applicationObject : FISCCIntegrationLogService.applicationObjs) {
        applicationObject.IsRoutingRequired__c = true;
      }
    }

    //upsert account
    if (FISCCIntegrationLogService.applicationObjs != null && !FISCCIntegrationLogService.applicationObjs.isEmpty()) {
      try {
        FISCCObjectManagerRepository.doUpsertApplications(FISCCIntegrationLogService.applicationObjs);
      } catch (Exception ex) {
        tffa.Logger.error('Exception in PersistLog.doUpsertApplications: ' + ex.getMessage() + ' ' + ex.getStackTraceString());
      }
    }
    tffa.Logger.debug('Applications updated');
    if (FISCCIntegrationLogService.applicationObjs != null && !FISCCIntegrationLogService.applicationObjs.isEmpty()) {
      for (tffa__Application__c applicationObject : FISCCIntegrationLogService.applicationObjs) {
        if (applicationObject.tffa__Beneficiaries__r != null && !applicationObject.tffa__Beneficiaries__r.isEmpty()) {
          benefList.addAll(applicationObject.tffa__Beneficiaries__r);
        }

        if (applicationObject.tffa__PartyXrefs__r != null && !applicationObject.tffa__PartyXrefs__r.isEmpty()) {
          appPartyLst.addAll(applicationObject.tffa__PartyXrefs__r);
          tffa.Logger.debug('appPartyLst ' + appPartyLst);
          /*for (tffa__ApplicationPartyXref__c partyAppObj : applicationObject.tffa__PartyXrefs__r) {
            if (!partyIdLst.contains(partyAppObj.tffa__party__r.Id) && String.isNotBlank(partyAppObj.tffa__party__r.Customer_Number__c)) {
              partyUpdatedLst.add(partyAppObj.tffa__party__r);
              partyIdLst.add(partyAppObj.tffa__party__r.Id);
            }
          }
          tffa.Logger.debug('PartyLst ' + partyUpdatedLst);
          FISCCObjectManagerRepository.doUpsertParties(new List<tffa__Party__c>(partyUpdatedLst));*/
        }

        if (applicationObject.tffa__LinkedFundingRequests__r != null && !applicationObject.tffa__LinkedFundingRequests__r.isEmpty()) {
          fundingReqList.addAll(applicationObject.tffa__LinkedFundingRequests__r);
        }

        if (
          (applicationObject.tffa__Status__c == CZWTFCConstants.ACCOUNT_OPENED ||
          applicationObject.tffa__Status__c == CZWTFCConstants.FUNDED ||
          (applicationObject.tffa__AccountPurpose__c == 'DEBIT_CARD' &&
          applicationObject.tffa__Status__c == 'COMPLETED')) &&
          applicationObject.tffa__AccountPreferences__r != null &&
          !applicationObject.tffa__AccountPreferences__r.isEmpty()
        ) {
          for (tffa__AccountPreference__c accPrefObj : applicationObject.tffa__AccountPreferences__r) {
            if (FISCCIntegrationConstants.OD_FOR_STANDARD_ADDON_TYPE == accPrefObj.tffa__AddOnServiceType__c) {
              accPrefObj.tffa__Status__c = CZWTFCConstants.ADDON_STATUS_COMPLETED;
              accPrefObjLst.add(accPrefObj);
            }

            if (FISCCIntegrationConstants.DBT_TYPE == accPrefObj.tffa__AddOnServiceType__c) {
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
      try {
        FISCCObjectManagerRepository.doUpsertBeneficiarys(benefList);
        tffa.Logger.debug('Beneficiary updated updated');
      } catch (Exception ex) {
        tffa.Logger.error('Exception in PersistLog.doUpsertBeneficiarys: ' + ex.getMessage() + ' ' + ex.getStackTraceString());
      }
    }

    if (appPartyLst != null && !appPartyLst.isEmpty()) {
      try {
        FISCCObjectManagerRepository.doApplicationPartyReq(appPartyLst);
        tffa.Logger.debug('ApplicationPartyXref updated');
      } catch (Exception ex) {
        tffa.Logger.error('Exception in PersistLog.doApplicationPartyReq: ' + ex.getMessage() + ' ' + ex.getStackTraceString());
      }
    }

    if (fundingReqList != null && !fundingReqList.isEmpty()) {
      try {
        FISCCObjectManagerRepository.doUpsertFundingReq(fundingReqList);
        tffa.Logger.debug('fundingReqList updated updated');
      } catch (Exception ex) {
        tffa.Logger.error('Exception in PersistLog.doUpsertFundingReq: ' + ex.getMessage() + ' ' + ex.getStackTraceString());
      }
    }

    if (accPrefObjLst != null && !accPrefObjLst.isEmpty()) {
      try {
        FISCCObjectManagerRepository.doUpsertAccountPrefObj(accPrefObjLst);
        tffa.Logger.debug('AccountPreference updated' + accPrefObjLst);
      } catch (Exception ex) {
        tffa.Logger.error('Exception in PersistLog.doUpsertAccountPrefObj: ' + ex.getMessage() + ' ' + ex.getStackTraceString());
      }
    }

    if (uploadFileHistoryObjList != null && !uploadFileHistoryObjList.isEmpty()) {
      try {
        FISCCObjectManagerRepository.doUpsertuploadFileHistoryObj(uploadFileHistoryObjList);
        tffa.Logger.debug('uploadFileHistoryObjList updated' + uploadFileHistoryObjList);
      } catch (Exception ex) {
        tffa.Logger.error('Exception in PersistLog.doUpsertuploadFileHistoryObj: ' + ex.getMessage() + ' ' + ex.getStackTraceString());
      }
    }

    try {
      persistIntegationLogs();
    } catch (Exception ex) {
      tffa.Logger.error('Exception in PersistLog.persistIntegationLogs: ' + ex.getMessage() + ' ' + ex.getStackTraceString());
    }
    //--- Update Submission

    try {
      FISCCObjectManagerRepository.doUpsertSubmission(submissionObj);
      tffa.Logger.debug('Submission updated');
    } catch (Exception ex) {
      tffa.Logger.error('Exception in PersistLog.doUpsertSubmission: ' + ex.getMessage() + ' ' + ex.getStackTraceString());
    }
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