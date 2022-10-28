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

    try {
      for (tffa__Application__c app : appList) {
        boolean odProtectionATMPresent = false;
        boolean estmtFailed = false;
        boolean odDeficitFailed = false;
        boolean odAtmFailed = false;
        boolean accOpeningPendingDeficit = false;

        tffa.Logger.debug('FISAccountPreferencesExecutor processAccPrefRequest for app: ==-> ' + app.Id);
        tffa.Logger.debug('app.tffa__AccountPreferences__r ' + app.tffa__AccountPreferences__r);
        FISCCIntegrationLogService.setSubmissionObj(String.valueOf(app.tffa__Submission__c));
        FISCCIntegrationLogService.setPartyObjs();
        FISCCIntegrationLogService.setIntegrationLog(String.valueOf(app.tffa__Submission__c));
        FISCCIntegrationLogService.setApplicationObjs();

        // if (app.tffa__AccountPreferences__r == null || app.tffa__AccountPreferences__r.isEmpty()) {
        //   tffa.Logger.debug('OLB enrollment not required for app ' + app.id);
        //   app.AccountPreference__c = CZWTFCConstants.PROCESS_STATUS_NOT_APPLICABLE;
        //   app = CZWTFCAppRoutingService.routeApplication(app);
        //   resultAppList.add(app);
        //   break;
        // }

        if (containService(app.tffa__AccountPreferences__r, FISCCIntegrationConstants.ESTMT_TYPE)) {
          Integer idx;
          for (Integer i = 0; i < app.tffa__AccountPreferences__r.size(); i++) {
            if ((app.tffa__AccountPreferences__r[i].tffa__AddOnServiceType__c).equalsIgnoreCase(FISCCIntegrationConstants.ESTMT_TYPE)) {
              idx = i;
              break;
            }
          }
          if (isOLBEnrolled(app)) {
            if (FISCCIntegrationLogService.isLogNewOrFailed(FISCCIntegrationConstants.ESTMT_REG + app.Id)) {
              try {
                FISCCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.ESTMT_REG + app.Id);
                FISCCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.ESTMT_REG, app.Id, true);
                estmtResult = FISAccountPreferenceProvider.processMultiKeywords(app, FISCCIntegrationConstants.ESTMT_TYPE);
                if (isAPICallSuccess(estmtResult.Metadata.MsgLst)) {
                  tffa.Logger.debug('FISAccountPreferencesExecutor success');
                  app.tffa__AccountPreferences__r[idx].tffa__Status__c = CZWTFCConstants.ADDON_STATUS_COMPLETED;
                  FISCCIntegrationLogService.setLogItemOk(API_NAME, FISCCIntegrationConstants.ESTMT_REG_SUCCESS);
                  FISCCIntegrationLogService.setLogOk(FISCCIntegrationConstants.ESTMT_REG_SUCCESS);
                } else {
                  tffa.Logger.error('FISAccountPreferencesExecutor failed for app : ' + app.Id);
                  estmtFailed = true;
                  FISCCIntegrationLogService.setLogItemFailed(API_NAME, FISCCIntegrationConstants.ESTMT_REG_FAILED);
                  FISCCIntegrationLogService.setLogFailed(FISCCIntegrationConstants.ESTMT_REG_FAILED);
                }
              } catch (Exception ex) {
                estmtFailed = true;
                tffa.Logger.debug('exception in processAccPrefRequest in executor ..');
                FISCCIntegrationLogService.setLogItemFailed(API_NAME, FISCCIntegrationConstants.ESTMT_REG_FAILED);
                FISCCIntegrationLogService.setLogFailed(FISCCIntegrationConstants.ESTMT_REG_FAILED);
              }
            }
          } else {
            app.tffa__AccountPreferences__r[idx].tffa__Status__c = CZWTFCConstants.ADDON_STATUS_COMPLETED;
            app.tffa__AccountPreferences__r[idx].tffa__Comments__c = 'E-Statement Registration Skipped as OLB is not registrated';
          }
        }

        if (containService(app.tffa__AccountPreferences__r, FISCCIntegrationConstants.OD_DEFICIT_TRANSFER_TYPE)) {
          if (eligibleForDeficitTransfer(app.tffa__AccountPreferences__r)) {
            try {
              if (Test.isRunningTest() && testException) {
                throw new tffa.ApplicationException('Called through test class');
              }
              Integer idx;

              for (Integer i = 0; i < app.tffa__AccountPreferences__r.size(); i++) {
                if (
                  (app.tffa__AccountPreferences__r[i].tffa__AddOnServiceType__c)
                    .equalsIgnoreCase(FISCCIntegrationConstants.OD_DEFICIT_TRANSFER_TYPE)
                ) {
                  idx = i;
                  break;
                }
              }
              if (
                FISCCIntegrationLogService.isLogNewOrFailed(FISCCIntegrationConstants.OD_DEFICIT_TRANSFER + '-' + app.Name + '-' + app.Id)
              ) {
                FISCCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.OD_DEFICIT_TRANSFER + '-' + app.Name + '-' + app.Id);
                FISCCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.OD_DEFICIT_TRANSFER, app.Id, false);

                Map<String, String> params = new Map<String, String>();
                params.put('accNbr', app.tffa__AccountNumber__c);
                params.put('senderAccNbr', fetchAccountNumberForDeficit(app));
                params.put('custName', getPrimaryPartyFrmtedName(app));
                isOdDeficitSuccess = FISCCDeficitTransferProvider.transferFundInstructions(params, app.tffa__Brand__c);
                if (isOdDeficitSuccess) {
                  app.tffa__AccountPreferences__r[idx].tffa__Status__c = CZWTFCConstants.ADDON_STATUS_COMPLETED;
                  FISCCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.OD_DEFICIT_TRANSFER_SUCCESS);
                  FISCCIntegrationLogService.setLogOk(FISCCIntegrationConstants.OD_DEFICIT_TRANSFER_SUCCESS);
                } else {
                  app.tffa__AccountPreferences__r[idx].tffa__Status__c = CZWTFCConstants.ADDON_STATUS_FAILED;
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

        if (containService(app.tffa__AccountPreferences__r, FISCCIntegrationConstants.OD_ATM_TRANSFER_TYPE)) {
          odAtmFailed = processODProtectionAtm(app, FISCCIntegrationConstants.OD_ATM_Y);
          Integer idx;
          for (Integer i = 0; i < app.tffa__AccountPreferences__r.size(); i++) {
            if (
              (app.tffa__AccountPreferences__r[i].tffa__AddOnServiceType__c)
                .equalsIgnoreCase(FISCCIntegrationConstants.OD_ATM_TRANSFER_TYPE)
            ) {
              idx = i;
              break;
            }
          }
          if (!odAtmFailed) {
            app.tffa__AccountPreferences__r[idx].tffa__Status__c = CZWTFCConstants.ADDON_STATUS_COMPLETED;
          } else {
            app.tffa__AccountPreferences__r[idx].tffa__Status__c = CZWTFCConstants.ADDON_STATUS_FAILED;
          }
        } else {
          if (odConfiguredForProduct(app.tffa__Product__c, FISCCIntegrationConstants.OD_ATM_TRANSFER_TYPE)) {
            odProtectionATMPresent = true;
          } else {
            odProtectionATMPresent = false;
            app.CZIsODAtmProcessed__c = true;
          }
        }

        if (odProtectionATMPresent) {
          odAtmFailed = processODProtectionAtm(app, FISCCIntegrationConstants.OD_ATM_N);
        }

        if (!odAtmFailed) {
          app.CZIsODAtmProcessed__c = true;
        }

        if (estmtFailed || odDeficitFailed || odAtmFailed) {
          app.AccountPreference__c = CZWTFCConstants.PROCESS_STATUS_FAILURE;
          app.AccPrefRetryCount__c = app.AccPrefRetryCount__c + 1;
        } else {
          app.AccountPreference__c = CZWTFCConstants.PROCESS_STATUS_SUCCESS;
        }

        if ((accOpeningPendingDeficit) && !(app.AccountPreference__c).equalsIgnoreCase(CZWTFCConstants.PROCESS_STATUS_FAILURE)) {
          app.AccountPreference__c = CZWTFCConstants.PROCESS_STATUS_PENDING;
        }

        if (
          !accOpeningPendingDeficit &&
          !odConfiguredForProduct(app.tffa__Product__c, FISCCIntegrationConstants.OD_ATM_TRANSFER_TYPE) &&
          app.tffa__AccountPreferences__r.isEmpty()
        ) {
          app.AccountPreference__c = CZWTFCConstants.PROCESS_STATUS_NOT_APPLICABLE;
        }
        app = CZWTFCAppRoutingService.routeApplication(app);
        resultAppList.add(app);
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in processAccPrefRequest : ' + ex.getMessage() + ' Exception : ' + ex.getStackTraceString());
    }
    return resultAppList;
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

  private static Boolean isAPICallSuccess(List<FISCCMsgListDTO> msgList) {
    Boolean isScuccess = false;
    if (msgList != null && !msgList.isEmpty()) {
      if (('0').equalsIgnoreCase(msgList[0].Code) && ('Success').equalsIgnoreCase(msgList[0].Text)) {
        isScuccess = true;
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

  public static boolean odConfiguredForProduct(Id productId, String odType) {
    List<tffa__AddOnServiceItem__c> addOnServiceList = FISCCIntegrationLogRepository.findAddOnServiceItem(productId, odType);
    if (addOnServiceList.isEmpty()) {
      return false;
    } else {
      return true;
    }
  }

  public static boolean processODProtectionAtm(tffa__Application__c app, String reqType) {
    if (FISCCIntegrationLogService.isLogNewOrFailed(FISCCIntegrationConstants.OD_ATM_TRANSFER + '-' + app.Name + '-' + app.Id)) {
      FISCCMultiKeywordsResponseDTO odProtectionAtmResult;
      try {
        if (Test.isRunningTest() && testException) {
          throw new tffa.ApplicationException('Called through test class');
        }
        FISCCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.OD_ATM_TRANSFER + '-' + app.Name + '-' + app.Id);
        FISCCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.OD_ATM_TRANSFER_TYPE, app.Id, true);

        odProtectionAtmResult = FISAccountPreferenceProvider.processMultiKeywords(app, reqType);

        if (isAPICallSuccess(odProtectionAtmResult.Metadata.MsgLst)) {
          FISCCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.OD_PROTECTION_ATM_SUCCESS);
          FISCCIntegrationLogService.setLogOk(FISCCIntegrationConstants.OD_PROTECTION_ATM_SUCCESS);
        } else {
          FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.OD_PROTECTION_ATM_FAILURE);
          FISCCIntegrationLogService.setLogFailed(FISCCIntegrationConstants.OD_PROTECTION_ATM_FAILURE);
          return true;
        }
      } catch (Exception ex) {
        tffa.Logger.error('Exception in od protection atm  : ' + ex.getMessage() + ' Exception : ' + ex.getStackTraceString());
        FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.OD_PROTECTION_ATM_FAILURE);
        FISCCIntegrationLogService.setLogFailed(FISCCIntegrationConstants.OD_PROTECTION_ATM_FAILURE);
        return true;
      }
    }
    return false;
  }

  public static String fetchAccountNumberForDeficit(tffa__Application__c appObj) {
    for (tffa__AccountPreference__c accPref : appObj.tffa__AccountPreferences__r) {
      if ((accPref.tffa__AddOnServiceType__c).equalsIgnoreCase(FISCCIntegrationConstants.OD_DEFICIT_TRANSFER_TYPE)) {
        if (String.isNotBlank(accPref.tffa__AccountNumber__c)) {
          return accPref.tffa__AccountNumber__c;
        } else if (String.isNotBlank(accPref.SourceApplication__c)) {
          tffa__Application__c app = fetchApplication(FISCCIntegrationLogService.applicationObjs, accPref.SourceApplication__c);
          return app.tffa__AccountNumber__c;
        }
      }
    }
    return '';
  }

  public static boolean eligibleForDeficitTransfer(List<tffa__AccountPreference__c> accList) {
    for (tffa__AccountPreference__c accPref : accList) {
      if ((accPref.tffa__AddOnServiceType__c).equalsIgnoreCase(FISCCIntegrationConstants.OD_DEFICIT_TRANSFER_TYPE)) {
        if (String.isNotBlank(accPref.tffa__AccountNumber__c)) {
          return true;
        } else if (String.isNotBlank(accPref.SourceApplication__c)) {
          tffa__Application__c app = fetchApplication(FISCCIntegrationLogService.applicationObjs, accPref.SourceApplication__c);
          if ((app.tffa__Status__c).equalsIgnoreCase('ACCOUNT_OPENED') || (app.tffa__Status__c).equalsIgnoreCase('FUNDED')) {
            return true;
          }
        }
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