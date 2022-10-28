public inherited sharing class FISCCCardBaseIntegrationExecutor {
  public static List<tffa__Application__c> processDebitCardRequest(List<tffa__Application__c> applicationObjs) {
    tffa__AccountPreference__c accPref = new tffa__AccountPreference__c();
    List<tffa__Application__c> appList = applicationObjs;
    List<tffa__Application__c> resultAppList = new List<tffa__Application__c>();
    List<tffa__AccountPreference__c> accPrefList = new List<tffa__AccountPreference__c>();
    String cardNoGenLogKey = null;
    String cardCreationLogKey = null;
    String cardCustToAccRelnLogKey = null;
    String cardCustDemographicsLogKey = null;
    Integer i = 0;
    try {
      FISCCIntegrationLogService.applicationCode = 'CB';
      for (tffa__Application__c app : appList) {
        FISCCIntegrationLogService.setSubmissionObj(String.valueOf(app.tffa__Submission__c));
        FISCCIntegrationLogService.setIntegrationLog(String.valueOf(app.tffa__Submission__c));
        FISCC_Charter_Config__mdt charterConfig = FISCCIntegrationLogRepository.findCharterConfigByBrandCode(app.tffa__Brand__c);
        FISCCIntegrationLogService.auth = FISCCGetAccessTokenProvider.processGetAccessToken(charterConfig);
        accPrefList = app.tffa__AccountPreferences__r;
        tffa__Party__c partyObj;
        Boolean isSuccess = false;
        String accPrefStatus;
        for (i = 0; i < accPrefList.size(); i++) {
          accPref = accPrefList.get(i);
          if (!(CZWTFCConstants.ADDON_STATUS_COMPLETED).equals(accPref.tffa__Status__c)) {
            accPrefStatus = CZWTFCConstants.ADDON_STATUS_FAILED;
            partyObj = CZWTFCPartyRepository.findByIdWithChildObjects(accPref.tffa__party__c);
            FISCCIntegrationLogService.setCurrentLog(
              FISCCIntegrationConstants.DEBIT_CARD_ISSUE +
              accPref.tffa__EmbossedName__c +
              '-' +
              accPref.Id
            );
            if (
              FISCCIntegrationLogService.isLogNewOrFailed(
                FISCCIntegrationConstants.DEBIT_CARD_ISSUE +
                accPref.tffa__EmbossedName__c +
                '-' +
                accPref.Id
              )
            ) {
              // CardNo generation
              cardNoGenLogKey = FISCCIntegrationLogService.setCurrentLogItem(
                FISCCIntegrationConstants.DEBIT_CARDNO_GEN + accPref.tffa__EmbossedName__c,
                accPref.Id,
                false
              );
              if (FISCCIntegrationLogService.isLogItemNewOrFailed(cardNoGenLogKey)) {
                try {
                  tffa.Logger.debug('cardNoGen logic started for accPref :' + accPref.Id);
                  isSuccess = FISCCCardBaseIntegrationProvider.generateCardNo(accPref, partyObj);
                  tffa.Logger.debug('cardNoGen isSuccess : ' + isSuccess);
                  if (isSuccess) {
                    FISCCIntegrationLogService.setLogItemOk(
                      FISCCIntegrationConstants.DCARDNOGEN_API_NAME,
                      FISCCIntegrationConstants.DEBIT_CARDNO_GEN_SUCCESS
                    );
                    app.tffa__AccountPreferences__r.get(i).tffa__CardNumber__c = FISCCCardBaseIntegrationHelper.cardNumber;
                    //tffa.Logger.debug('cardNo set to : ' + accPref.tffa__CardNumber__c + ' for ' + accPref.Id);
                  } else {
                    FISCCIntegrationLogService.setLogItemFailed(
                      FISCCIntegrationConstants.DCARDNOGEN_API_NAME,
                      FISCCIntegrationConstants.ErrorMessage
                    );
                    FISCCIntegrationLogService.setLogFailed(FISCCIntegrationConstants.DEBIT_CARD_FAILURE);
                  }
                  tffa.Logger.debug('cardNoGenResult isAPICallSuccess : ' + isSuccess);
                } catch (Exception ex) {
                  FISCCIntegrationLogService.setLogItemFailed(
                    FISCCIntegrationConstants.DCARDNOGEN_API_NAME,
                    (FISCCIntegrationConstants.DEBIT_CARDNO_GEN_FAILURE +
                    ' exception : ' +
                    ex.getMessage())
                  );
                  FISCCIntegrationLogService.setLogFailed(FISCCIntegrationConstants.DEBIT_CARD_FAILURE);
                }
              }

              //Card Creation
              cardCreationLogKey = FISCCIntegrationLogService.setCurrentLogItem(
                FISCCIntegrationConstants.DEBIT_CARD_CREATION + accPref.tffa__EmbossedName__c,
                accPref.Id,
                false
              );
              if (
                FISCCIntegrationLogService.isLogItemNewOrFailed(cardCreationLogKey) &&
                FISCCIntegrationLogService.isLogItemOk(cardNoGenLogKey)
              ) {
                try {
                  tffa.Logger.debug('card creation logic started for accPref :' + accPref.Id);
                  isSuccess = FISCCCardBaseIntegrationProvider.createDebitCard(accPref, partyObj, app);
                  tffa.Logger.debug('cardCreation isSuccess : ' + isSuccess);
                  if (isSuccess) {
                    FISCCIntegrationLogService.setLogItemOk(
                      FISCCIntegrationConstants.DCARDCREATION_API_NAME,
                      FISCCIntegrationConstants.DEBIT_CARD_CREATION_SUCCESS
                    );
                  } else {
                    FISCCIntegrationLogService.setLogItemFailed(
                      FISCCIntegrationConstants.DCARDCREATION_API_NAME,
                      FISCCIntegrationConstants.ErrorMessage
                    );
                    FISCCIntegrationLogService.setLogFailed(FISCCIntegrationConstants.DEBIT_CARD_FAILURE);
                  }
                  tffa.Logger.debug('cardCreationResult isAPICallSuccess : ' + isSuccess);
                } catch (Exception ex) {
                  FISCCIntegrationLogService.setLogItemFailed(
                    FISCCIntegrationConstants.DCARDCREATION_API_NAME,
                    (FISCCIntegrationConstants.DEBIT_CARD_CREATION_FAILURE +
                    ' exception : ' +
                    ex.getMessage())
                  );
                  FISCCIntegrationLogService.setLogFailed(FISCCIntegrationConstants.DEBIT_CARD_FAILURE);
                }
              }

              // customer to Account Relation
              cardCustToAccRelnLogKey = FISCCIntegrationLogService.setCurrentLogItem(
                FISCCIntegrationConstants.DEBIT_CARD_ACCRELATION + accPref.tffa__EmbossedName__c,
                accPref.Id,
                false
              );
              if (
                FISCCIntegrationLogService.isLogItemNewOrFailed(cardCustToAccRelnLogKey) &&
                FISCCIntegrationLogService.isLogItemOk(cardCreationLogKey)
              ) {
                try {
                  tffa.Logger.debug('cardToAccRelation logic started for accPref :' + accPref.Id);
                  isSuccess = FISCCCardBaseIntegrationProvider.relateCustomerToAccount(accPref, partyObj, app);
                  tffa.Logger.debug('cardAccRelationResult isSuccess : ' + isSuccess);
                  if (isSuccess) {
                    FISCCIntegrationLogService.setLogItemOk(
                      FISCCIntegrationConstants.DCARDACCRELATION_API_NAME,
                      FISCCIntegrationConstants.DEBIT_CARD_ACCRELATION_SUCCESS
                    );
                  } else {
                    FISCCIntegrationLogService.setLogItemFailed(
                      FISCCIntegrationConstants.DCARDACCRELATION_API_NAME,
                      FISCCIntegrationConstants.ErrorMessage
                    );
                    FISCCIntegrationLogService.setLogFailed(FISCCIntegrationConstants.DEBIT_CARD_FAILURE);
                  }
                  tffa.Logger.debug('cardAccRelationResult isAPICallSuccess : ' + isSuccess);
                } catch (Exception ex) {
                  FISCCIntegrationLogService.setLogItemFailed(
                    FISCCIntegrationConstants.DCARDACCRELATION_API_NAME,
                    (FISCCIntegrationConstants.DEBIT_CARD_ACCRELATION_FAILURE +
                    ' exception : ' +
                    ex.getMessage())
                  );
                  FISCCIntegrationLogService.setLogFailed(FISCCIntegrationConstants.DEBIT_CARD_FAILURE);
                }
              }

              // Customer Demographics
              cardCustDemographicsLogKey = FISCCIntegrationLogService.setCurrentLogItem(
                FISCCIntegrationConstants.DEBIT_CARD_DEMOGRAPHICS,
                accPref.Id,
                false
              );
              if (
                FISCCIntegrationLogService.isLogItemNewOrFailed(cardCustDemographicsLogKey) &&
                FISCCIntegrationLogService.isLogItemOk(cardCustToAccRelnLogKey)
              ) {
                try {
                  tffa.Logger.debug('CardCustDemographics logic started for accPref :' + accPref.Id);
                  isSuccess = FISCCCardBaseIntegrationProvider.updateCustomerDemographics(accPref, partyObj, app);
                  tffa.Logger.debug('cardCustDemographicsResult isSuccess : ' + isSuccess);
                  if (isSuccess) {
                    FISCCIntegrationLogService.setLogItemOk(
                      FISCCIntegrationConstants.DCARDCUSTDEMOGRAPHICS_API_NAME,
                      FISCCIntegrationConstants.DEBIT_CARD_DEMOGRAPHICS_SUCCESS
                    );
                    FISCCIntegrationLogService.setLogOk(FISCCIntegrationConstants.DEBIT_CARD_SUCCESS);
                    accPrefStatus = CZWTFCConstants.ADDON_STATUS_COMPLETED;
                  } else {
                    FISCCIntegrationLogService.setLogItemFailed(
                      FISCCIntegrationConstants.DCARDCUSTDEMOGRAPHICS_API_NAME,
                      FISCCIntegrationConstants.ErrorMessage
                    );
                    FISCCIntegrationLogService.setLogFailed(FISCCIntegrationConstants.DEBIT_CARD_FAILURE);
                  }
                  tffa.Logger.debug('cardCustDemographicsResult isAPICallSuccess : ' + isSuccess);
                } catch (Exception ex) {
                  FISCCIntegrationLogService.setLogItemFailed(
                    FISCCIntegrationConstants.DCARDCUSTDEMOGRAPHICS_API_NAME,
                    (FISCCIntegrationConstants.DEBIT_CARD_DEMOGRAPHICS_FAILURE +
                    ' exception : ' +
                    ex.getMessage())
                  );
                  FISCCIntegrationLogService.setLogFailed(FISCCIntegrationConstants.DEBIT_CARD_FAILURE);
                }
              }
              app.tffa__AccountPreferences__r.get(i).tffa__Status__c = accPrefStatus;
            }
          }
        }
        app.DebitCardIssuanceStatus__c = accPrefList.isEmpty()
          ? CZWTFCConstants.PROCESS_STATUS_NOT_APPLICABLE
          : getDebitIssuanceStatus(app);
        resultAppList.add(app);
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in processDebitCardRequest :' + ex.getMessage() + ' :: ' + ex.getStackTraceString());
    } finally {
      FISCCIntegrationLogService.persistIntegationLogs();
    }
    return resultAppList;
  }

  private static String getDebitIssuanceStatus(tffa__Application__c appObj) {
    Boolean isAllAccPrefStatusCompleted = true;
    for (tffa__AccountPreference__c accPref : appObj.tffa__AccountPreferences__r) {
      if ((!(CZWTFCConstants.ADDON_STATUS_COMPLETED).equals(accPref.tffa__Status__c))) {
        isAllAccPrefStatusCompleted = false;
      }
    }
    if (isAllAccPrefStatusCompleted) {
      return CZWTFCConstants.PROCESS_STATUS_SUCCESS;
    } else {
      return CZWTFCConstants.PROCESS_STATUS_FAILURE;
    }
  }
}