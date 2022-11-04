public inherited sharing class FISAccountPreferencesExecutor {
  @TestVisible
  private static boolean testException = false;
  public static final String API_NAME = 'E-Statement Registration';

  public static List<tffa__Application__c> processAccPrefRequest(List<tffa__Application__c> appList) {
    List<tffa__Application__c> resultAppList = new List<tffa__Application__c>();
    List<tffa__AccountPreference__c> accPrefList = new List<tffa__AccountPreference__c>();
    FISCCMultiKeywordsResponseDTO estmtResult;
    tffa__AccountPreference__c accPref;
    boolean isOdDeficitSuccess = false;
    tffa__AccountPreference__c estatementAcctPref;
    tffa__AccountPreference__c odATMAcctPref;
    tffa__AccountPreference__c odDeficitTransferAcctPref;

    try {
      FISCCIntegrationLogService.setSubmissionObj(String.valueOf(appList[0].tffa__Submission__c));
      FISCCIntegrationLogService.setPartyObjs();
      FISCCIntegrationLogService.setIntegrationLog(
        String.valueOf(appList[0].tffa__Submission__c),
        FISCCIntegrationConstants.ACCOUNT_PREF_LOG
      );
      FISCCIntegrationLogService.setApplicationObjs();
      for (tffa__Application__c app : appList) {
        if (
          app.tffa__AccountPurpose__c == FISCCIntegrationConstants.ALLOWED_PURPOSE_DEBIT_CARD ||
          FISCCIntegrationConstants.SAFE_DEPOSIT_PROD_CATEGORY.contains(app.tffa__ProductCategory__c)
        ) {
          app.AccountPreference__c = CZWTFCConstants.PROCESS_STATUS_NOT_APPLICABLE;
          app = CZWTFCAppRoutingService.routeApplication(app);
          resultAppList.add(app);
          return resultAppList;
        }
        boolean odProtectionATMPresent = false;
        boolean keywordsAPISuccess = false;
        boolean odDeficitFailed = false;
        boolean odAtmFailed = false;
        boolean accOpeningPendingDeficit = false;
        estatementAcctPref = null;
        odATMAcctPref = null;
        odDeficitTransferAcctPref = null;
        tffa.Logger.debug('FISAccountPreferencesExecutor processAccPrefRequest for app: ==-> ' + app.Id);
        tffa.Logger.debug('app.tffa__AccountPreferences__r ' + app.tffa__AccountPreferences__r);
        for (Integer i = 0; i < app.tffa__AccountPreferences__r.size(); i++) {
          if ((app.tffa__AccountPreferences__r[i].tffa__AddOnServiceType__c).equalsIgnoreCase(FISCCIntegrationConstants.ESTMT_TYPE)) {
            estatementAcctPref = app.tffa__AccountPreferences__r[i];
          } else if (
            (app.tffa__AccountPreferences__r[i].tffa__AddOnServiceType__c)
              .equalsIgnoreCase(FISCCIntegrationConstants.OD_DEFICIT_TRANSFER_TYPE)
          ) {
            odDeficitTransferAcctPref = app.tffa__AccountPreferences__r[i];
          } else if (
            (app.tffa__AccountPreferences__r[i].tffa__AddOnServiceType__c).equalsIgnoreCase(FISCCIntegrationConstants.OD_ATM_TRANSFER_TYPE)
          ) {
            odATMAcctPref = app.tffa__AccountPreferences__r[i];
          }
        }

        FISCCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.ACCOUNT_PREF_LOG + app.Name + '-' + app.tffa__AccountNumber__c);

        String keywordReqType = '';
        if (estatementAcctPref != null) {
          if (isOLBEnrolled(app)) {
            keywordReqType = FISCCIntegrationConstants.ESTMT_TYPE;
          } else {
            estatementAcctPref.tffa__Status__c = CZWTFCConstants.ADDON_STATUS_COMPLETED;
            estatementAcctPref.tffa__Comments__c = 'E-Statement Registration Skipped as OLB is not registrated';
          }
        }

        if (odATMAcctPref != null) {
          keywordReqType = keywordReqType + ',' + FISCCIntegrationConstants.OD_ATM_Y;
        } else {
          if (odConfiguredForProduct(app.tffa__Product__r, FISCCIntegrationConstants.OD_ATM_TRANSFER_TYPE)) {
            keywordReqType = keywordReqType + ',' + FISCCIntegrationConstants.OD_ATM_N;
          }
        }

        if (app.CZStatusCode1ExpiryDate__c != null || app.CZStatusCode2ExpiryDate__c != null || app.CZStatusCode3ExpiryDate__c != null) {
          keywordReqType = keywordReqType + ',' + 'StatusCodeExpiry';
        }

        if (isTypeCertificateAndBranchFlow(app)) {
          keywordReqType = keywordReqType + ',' + FISCCIntegrationConstants.APY_INFO;
        }

        //Account Opening Indicator
        if (
          app.tffa__AccountPurpose__c != FISCCIntegrationConstants.ALLOWED_PURPOSE_DEBIT_CARD &&
          !FISCCIntegrationConstants.SAFE_DEPOSIT_PROD_CATEGORY.contains(app.tffa__ProductCategory__c)
        ) {
          keywordReqType = keywordReqType + ',' + FISCCIntegrationConstants.ACCOUNT_OPENING_INFO;
        }

        if (String.isNotBlank(keywordReqType)) {
          keywordsAPISuccess = processKeywordAPI(app, keywordReqType);
          if (keywordsAPISuccess) {
            if (estatementAcctPref != null) {
              estatementAcctPref.tffa__Status__c = CZWTFCConstants.ADDON_STATUS_COMPLETED;
            }
            if (odATMAcctPref != null) {
              odATMAcctPref.tffa__Status__c = CZWTFCConstants.ADDON_STATUS_COMPLETED;
            }
          }
        }
        if (odDeficitTransferAcctPref != null) {
          if (eligibleForDeficitTransfer(odDeficitTransferAcctPref)) {
            try {
              if (Test.isRunningTest() && testException) {
                throw new tffa.ApplicationException('Called through test class');
              }
              String itemLog = FISCCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.OD_DEFICIT_TRANSFER, app.Id, false);
              if (FISCCIntegrationLogService.isLogItemNewOrFailed(itemLog)) {
                Map<String, String> params = new Map<String, String>();
                params.put('accNbr', app.tffa__AccountNumber__c);
                params.put('senderAccNbr', fetchAccountNumberForDeficit(odDeficitTransferAcctPref));
                params.put('custName', getPrimaryPartyFrmtedName(app));
                isOdDeficitSuccess = FISCCDeficitTransferProvider.transferFundInstructions(params, app.tffa__Brand__c);
                if (isOdDeficitSuccess) {
                  odDeficitTransferAcctPref.tffa__Status__c = CZWTFCConstants.ADDON_STATUS_COMPLETED;
                  FISCCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.OD_DEFICIT_TRANSFER_SUCCESS);
                  FISCCIntegrationLogService.setLogOk(FISCCIntegrationConstants.OD_DEFICIT_TRANSFER_SUCCESS);
                } else {
                  odDeficitTransferAcctPref.tffa__Status__c = CZWTFCConstants.ADDON_STATUS_FAILED;
                  odDeficitFailed = true;
                  FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.OD_DEFICIT_TRANSFER_FAILURE);
                  FISCCIntegrationLogService.setLogFailed(FISCCIntegrationConstants.OD_DEFICIT_TRANSFER_FAILURE);
                }
              }
            } catch (Exception ex) {
              tffa.Logger.debug('exception in OD Deficit in executor ..' + ex.getStackTraceString());
              odDeficitFailed = true;
              FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.OD_DEFICIT_TRANSFER_FAILURE);
              FISCCIntegrationLogService.setLogFailed(FISCCIntegrationConstants.OD_DEFICIT_TRANSFER_FAILURE);
            }
          } else {
            accOpeningPendingDeficit = true;
          }
        }

        if (!keywordsAPISuccess || odDeficitFailed) {
          app.AccountPreference__c = CZWTFCConstants.PROCESS_STATUS_FAILURE;
          app.AccPrefRetryCount__c = app.AccPrefRetryCount__c + 1;
        } else {
          app.AccountPreference__c = CZWTFCConstants.PROCESS_STATUS_SUCCESS;
        }

        if ((accOpeningPendingDeficit) && !(app.AccountPreference__c).equalsIgnoreCase(CZWTFCConstants.PROCESS_STATUS_FAILURE)) {
          app.AccountPreference__c = CZWTFCConstants.PROCESS_STATUS_PENDING;
        }

        // if (
        //   !accOpeningPendingDeficit &&
        //   !odConfiguredForProduct(app.tffa__Product__c, FISCCIntegrationConstants.OD_ATM_TRANSFER_TYPE) &&
        //   app.tffa__AccountPreferences__r.isEmpty()
        // ) {
        //   app.AccountPreference__c = CZWTFCConstants.PROCESS_STATUS_NOT_APPLICABLE;
        // }
        app = CZWTFCAppRoutingService.routeApplication(app);
        resultAppList.add(app);
        /**
         * Update tffa__AccountPreference__c
         */
        List<tffa__AccountPreference__c> updatedaccPref = new List<tffa__AccountPreference__c>();
        if (estatementAcctPref != null) {
          updatedaccPref.add(estatementAcctPref);
        }
        if (odATMAcctPref != null) {
          updatedaccPref.add(odATMAcctPref);
        }
        if (odDeficitTransferAcctPref != null) {
          updatedaccPref.add(odDeficitTransferAcctPref);
        }

        CZWTFCApplicationRepository.save(updatedaccPref);
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in processAccPrefRequest : ' + ex.getMessage() + ' Exception : ' + ex.getStackTraceString());
    }

    return resultAppList;
  }

  private static Boolean isTypeCertificateAndBranchFlow(tffa__Application__c appObj) {
    if (
      FISCCIntegrationLogService.submissionObj.tffa__SubmittedChannel__c == FISCCIntegrationConstants.BRANCH &&
      CZWTFCCommonHelper.isCertificateProduct(appObj) &&
      appObj.tffa__Status__c == 'FUNDED' &&
      appObj.tffa__APY__c != null &&
      appObj.DPTDId__c != null
    ) {
      return true;
    }
    return false;
  }
  private static Boolean isOLBEnrolled(tffa__Application__c app) {
    Boolean resultStatus = false;
    try {
      for (tffa__ApplicationPartyXref__c appPartyXref : app.tffa__PartyXrefs__r) {
        tffa__Party__c partyObj = CZWTFCPartyRepository.findByIdWithOLBAddPref(appPartyXref.tffa__Party__c);
        if (partyObj.IsOLBEnrolled__c != null && partyObj.IsOLBEnrolled__c.equals('Y')) {
          tffa.Logger.debug('isOLBEnrolled existing true for app ' + app.id);
          return true;
        }
        for (tffa__AdditionalPreference__c addPrefOLB : partyObj.tffa__AdditionalPreferences__r) {
          if ((CZWTFCConstants.ADDON_STATUS_COMPLETED).equals(addPrefOLB.tffa__Status__c) && addPrefOLB.tffa__Enabled__c == true) {
            tffa.Logger.debug('OLB enrollment completed for app ' + app.id);
            return true;
          }
        }
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in isOLBCheckOrCompleted : ' + ex.getMessage() + ' Exception : ' + ex.getStackTraceString());
      return false;
    }
    tffa.Logger.debug('OLB enrollment not done for app ' + app.id);
    return false;
  }

  private static Boolean isAPICallSuccess(List<FISCCMsgListDTO> msgList, tffa__Application__c app) {
    Boolean isScuccess = false;
    if (msgList != null && !msgList.isEmpty()) {
      if (('0').equalsIgnoreCase(msgList[0].Code) && ('Success').equalsIgnoreCase(msgList[0].Text)) {
        isScuccess = true;

        for (tffa__AccountPreference__c accPref : app.tffa__AccountPreferences__r) {
          if (
            accPref.tffa__AddOnServiceType__c == FISCCIntegrationConstants.ESTMT_TYPE ||
            accPref.tffa__AddOnServiceType__c == FISCCIntegrationConstants.OD_ATM_TRANSFER_TYPE
          ) {
            accPref.tffa__Status__c = CZWTFCConstants.ADDON_STATUS_COMPLETED;
          }
        }
      }
    }
    return isScuccess;
  }

  public static String getPrimaryPartyFrmtedName(tffa__Application__c app) {
    tffa.Logger.debug('In getPrimaryPartyFrmtedName ' + app.Id);
    for (tffa__ApplicationPartyXref__c appPartyXref : app.tffa__PartyXrefs__r) {
      if (appPartyXref.tffa__Primary__c && appPartyXref.tffa__Party__r != null) {
        return CZWTFCCommonHelper.getFormattedFullName(
          appPartyXref.tffa__Party__r.tffa__FirstName__c,
          appPartyXref.tffa__Party__r.tffa__MiddleName__c,
          appPartyXref.tffa__Party__r.tffa__LastName__c,
          appPartyXref.tffa__Party__r.tffa__Suffix__c,
          20
        );
      }
    }
    return '';
  }

  public static boolean containService(List<tffa__AccountPreference__c> accList, String service) {
    for (tffa__AccountPreference__c accPref : accList) {
      if ((accPref.tffa__AddOnServiceType__c).equalsIgnoreCase(service)) {
        return true;
      }
    }
    return false;
  }

  public static boolean odConfiguredForProduct(tffa__Product__c product, String odType) {
    Map<String, Object> factsMap = new Map<String, Object>();
    factsMap.put('ProductCategory__c', product.tffa__Category__c);
    factsMap.put('ProductCode__c', product.tffa__Code__c);
    factsMap.put('EntityType__c', 'APPLICATION');
    List<Id> checklistIds = FISCCIntegrationLogRepository.findAddOnServiceChecklistIdsByFacts('tffa__Facts', factsMap);
    if (checklistIds != null && !checklistIds.isEmpty()) {
      List<tffa__AddOnServiceItem__c> addOnServiceList = FISCCIntegrationLogRepository.findAddOnServiceItem(checklistIds, odType);
      if (addOnServiceList.isEmpty()) {
        return false;
      } else {
        return true;
      }
    }
    return false;
  }

  public static boolean processKeywordAPI(tffa__Application__c app, String reqType) {
    String logItem = FISCCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.FIS_KEYWORD_API, app.Id, false);
    if (FISCCIntegrationLogService.isLogItemNewOrFailed(logItem)) {
      FISCCMultiKeywordsResponseDTO multiKeywordsResp;
      try {
        if (Test.isRunningTest() && testException) {
          throw new tffa.ApplicationException('Called through test class');
        }
        multiKeywordsResp = FISAccountPreferenceProvider.processMultiKeywords(app, reqType);

        if (isAPICallSuccess(multiKeywordsResp.Metadata.MsgLst, app)) {
          FISCCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.LOG_ITEM_STATUS_SUCCESS);
        } else {
          FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.LOG_ITEM_STATUS_FAILURE);
          return false;
        }
      } catch (Exception ex) {
        tffa.Logger.error('Exception in processKeywordAPI  : ' + ex.getMessage() + ' Exception : ' + ex.getStackTraceString());
        FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.LOG_ITEM_STATUS_FAILURE);
        return false;
      }
    }
    return true;
  }

  public static String fetchAccountNumberForDeficit(tffa__AccountPreference__c accPref) {
    if (String.isNotBlank(accPref.tffa__AccountNumber__c)) {
      return accPref.tffa__AccountNumber__c;
    } else if (String.isNotBlank(accPref.SourceApplication__c)) {
      tffa__Application__c app = fetchApplication(FISCCIntegrationLogService.applicationObjs, accPref.SourceApplication__c);
      return app.tffa__AccountNumber__c;
    }

    return '';
  }

  public static boolean eligibleForDeficitTransfer(tffa__AccountPreference__c accPref) {
    if (String.isNotBlank(accPref.tffa__AccountNumber__c)) {
      return true;
    } else if (String.isNotBlank(accPref.SourceApplication__c)) {
      tffa__Application__c app = fetchApplication(FISCCIntegrationLogService.applicationObjs, accPref.SourceApplication__c);
      if ((app.tffa__Status__c).equalsIgnoreCase('ACCOUNT_OPENED') || (app.tffa__Status__c).equalsIgnoreCase('FUNDED')) {
        return true;
      }
    }

    return false;
  }

  public static tffa__Application__c fetchApplication(List<tffa__Application__c> appList, String appId) {
    for (tffa__Application__c appObj : appList) {
      if (String.valueOf(appObj.Id).equalsIgnoreCase(appId)) {
        return appObj;
      }
    }
    tffa__Application__c app = CZWTFCApplicationRepository.findAppById(appId);
    return app;
  }
}