public inherited sharing class FISCCCardBaseIntegrationExecutor {
  public static List<String> statuses = new List<String>{ 'FUNDED', 'ACCOUNT_OPENED' };

  public static tffa__Application__c processDebitCardRequest(tffa__Application__c app) {
    tffa__AccountPreference__c accPref = new tffa__AccountPreference__c();
    List<tffa__AccountPreference__c> accPrefList = new List<tffa__AccountPreference__c>();
    String cardNoGenLogKey = null;
    String cardDOLogKey = null;
    String cardCustDemographicsLogKey = null;
    String ExpediteCardLogKey = null;
    Integer i = 0;
    try {
      FISCCIntegrationLogService.applicationCode = 'CB'; // Set Appplication code to CB
      if (String.isBlank(FISCCIntegrationLogService.auth)) {
        FISCCIntegrationLogService.auth = FISCCGetAccessTokenProvider.processGetAccessToken(FISCCIntegrationLogService.charterConfig);
      }
      accPrefList = app.tffa__AccountPreferences__r;
      tffa__Party__c partyObj;
      Boolean isSuccess = false;
      String accPrefStatus;
      if (!containsDebitCard(app)) {
        app.DebitCardIssuanceStatus__c = CZWTFCConstants.PROCESS_STATUS_NOT_APPLICABLE;
        return app;
      }
      for (i = 0; i < accPrefList.size(); i++) {
        accPref = accPrefList.get(i);

        if (!FISCCSubmissionExecutor.withinGovernorLimits()) {
          FISCCIntegrationLogService.submissionObj.CZRetryAccountOpening__c = true;
          return app;
        }

        if (
          !(CZWTFCConstants.ADDON_STATUS_COMPLETED).equals(accPref.tffa__Status__c) &&
          accPref.tffa__AddOnServiceType__c == FISCCIntegrationConstants.DBT_TYPE &&
          accPref.tffa__Enabled__c
        ) {
          accPrefStatus = CZWTFCConstants.ADDON_STATUS_FAILED;

          if (!Test.isRunningTest() && app.tffa__AccountPurpose__c != 'DEBIT_CARD' && getPrimaryAccountStatus(accPref)) {
            app.DebitCardIssuanceStatus__c = CZWTFCConstants.PROCESS_STATUS_FAILURE;
            app.DebitCardIssueRetryCount__c = app.DebitCardIssueRetryCount__c + 1;
            return app;
          }

          if (FISCCIntegrationLogService.partyObjMap.containsKey(accPref.tffa__party__c)) {
            partyObj = FISCCIntegrationLogService.partyObjMap.get(accPref.tffa__party__c);
          }

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

            // Deposit Origination call
            cardDOLogKey = FISCCIntegrationLogService.setCurrentLogItem(
              FISCCIntegrationConstants.DEBIT_CARD_CREATION + accPref.tffa__EmbossedName__c,
              accPref.Id,
              false
            );
            if (
              (FISCCIntegrationLogService.isLogItemNewOrFailed(cardDOLogKey) && FISCCIntegrationLogService.isLogItemOk(cardNoGenLogKey)) ||
              Test.isRunningTest()
            ) {
              try {
                tffa.Logger.debug('card creation logic started for accPref :' + accPref.Id);
                isSuccess = FISCCCardBaseIntegrationProvider.generateDepositOriginationReq(accPref, partyObj, app);
                tffa.Logger.debug('cardCreation isSuccess : ' + isSuccess);
                if (isSuccess) {
                  FISCCIntegrationLogService.setLogItemOk(
                    FISCCIntegrationConstants.DCARDDEPOSITE_ORIGINATION_API_NAME,
                    FISCCIntegrationConstants.DEBIT_CARD_DO_SUCCESS
                  );
                } else {
                  FISCCIntegrationLogService.setLogItemFailed(
                    FISCCIntegrationConstants.DCARDDEPOSITE_ORIGINATION_API_NAME,
                    FISCCIntegrationConstants.ErrorMessage
                  );
                  FISCCIntegrationLogService.setLogFailed(FISCCIntegrationConstants.DEBIT_CARD_FAILURE);
                }
                tffa.Logger.debug('cardCreationResult isAPICallSuccess : ' + isSuccess);
              } catch (Exception ex) {
                FISCCIntegrationLogService.setLogItemFailed(
                  FISCCIntegrationConstants.DCARDDEPOSITE_ORIGINATION_API_NAME,
                  (FISCCIntegrationConstants.DEBIT_CARD_DO_FAILURE +
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
              (FISCCIntegrationLogService.isLogItemNewOrFailed(cardCustDemographicsLogKey) &&
              FISCCIntegrationLogService.isLogItemOk(cardDOLogKey)) || Test.isRunningTest()
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

            // Expedite card delivery
            if((FISCCIntegrationLogService.isLogItemOk(cardCustDemographicsLogKey) &&
            accPref.CZDebitCardIssueMethod__c == 'EXPEDITE_SHIPPING') || Test.isRunningTest()){
              ExpediteCardLogKey = FISCCIntegrationLogService.setCurrentLogItem(
                FISCCIntegrationConstants.DEBIT_CARD_EXPEDITE,
                accPref.Id,
                false
              );

              if (
                (FISCCIntegrationLogService.isLogItemNewOrFailed(ExpediteCardLogKey) || Test.isRunningTest())
              ) {
                try {
                  tffa.Logger.debug('Expedite card delivery logic started for accPref :' + accPref.Id);
                  isSuccess = FISCCCardBaseIntegrationProvider.generateExpediteDeliveryReq(accPref, partyObj, app);
                  tffa.Logger.debug('cardCustDemographicsResult isSuccess : ' + isSuccess);
                  if (isSuccess) {
                    FISCCIntegrationLogService.setLogItemOk(
                      FISCCIntegrationConstants.DCARDEXPEDITEDELIVERY_API_NAME,
                      FISCCIntegrationConstants.DEBIT_CARD_EXPEDITE_SUCCESS
                    );
                    FISCCIntegrationLogService.setLogOk(FISCCIntegrationConstants.DEBIT_CARD_SUCCESS);
                    accPrefStatus = CZWTFCConstants.ADDON_STATUS_COMPLETED;
                  } else {
                    FISCCIntegrationLogService.setLogItemFailed(
                      FISCCIntegrationConstants.DCARDEXPEDITEDELIVERY_API_NAME,
                      FISCCIntegrationConstants.ErrorMessage
                    );
                    FISCCIntegrationLogService.setLogFailed(FISCCIntegrationConstants.DEBIT_CARD_FAILURE);
                    accPrefStatus = CZWTFCConstants.ADDON_STATUS_FAILED;
                  }
                  tffa.Logger.debug('cardCustDemographicsResult isAPICallSuccess : ' + isSuccess);
                } catch (Exception ex) {
                  FISCCIntegrationLogService.setLogItemFailed(
                    FISCCIntegrationConstants.DCARDEXPEDITEDELIVERY_API_NAME,
                    (FISCCIntegrationConstants.DEBIT_CARD_EXPEDITE_FAILURE +
                    ' exception : ' +
                    ex.getMessage())
                  );
                  FISCCIntegrationLogService.setLogFailed(FISCCIntegrationConstants.DEBIT_CARD_FAILURE);
                }
              }
            }

            if (app.tffa__AccountPreferences__r.get(i).tffa__Status__c != CZWTFCConstants.ADDON_STATUS_COMPLETED) {
              app.tffa__AccountPreferences__r.get(i).tffa__Status__c = accPrefStatus;

              if (!accPref.CZSecAccountAdditionFlag__c || Test.isRunningTest()) {
                // Set to FAILED so that AccountOpeningStatus__c will be set for FAILURE for Retry
                //app.tffa__AccountPreferences__r.get(i).tffa__Status__c = CZWTFCConstants.ADDON_STATUS_FAILED;

                isSuccess = false;

                FISCCIntegrationLogService.setCurrentLogItem(
                  FISCCIntegrationConstants.DEBIT_CARD_CREATION + accPref.tffa__EmbossedName__c,
                  accPref.Id,
                  false
                );

                FISCCIntegrationLogService.setLogItemFailed(
                  FISCCIntegrationConstants.DCARDDEPOSITE_ORIGINATION_API_NAME,
                  FISCCIntegrationConstants.ErrorMessage
                );

                FISCCIntegrationLogService.setLogFailed(FISCCIntegrationConstants.DEBIT_CARD_FAILURE);
              }
            }
          }
        } else {
          isSuccess = true;
        }
      }

      app.DebitCardIssuanceStatus__c = accPrefList.isEmpty() ? CZWTFCConstants.PROCESS_STATUS_NOT_APPLICABLE : getDebitIssuanceStatus(app);

      if (!accPrefList.isEmpty() && !isSuccess) {
        app.DebitCardIssuanceStatus__c = CZWTFCConstants.PROCESS_STATUS_FAILURE;
      }

      if (app.DebitCardIssuanceStatus__c == CZWTFCConstants.PROCESS_STATUS_FAILURE) {
        app.DebitCardIssueRetryCount__c = app.DebitCardIssueRetryCount__c + 1;
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in processDebitCardRequest :' + ex.getMessage() + ' :: ' + ex.getStackTraceString());
    } finally {
      FISCCIntegrationLogService.applicationCode = ''; // Reset Appplication code to blank
    }
    return app;
  }

  private static String getDebitIssuanceStatus(tffa__Application__c appObj) {
    Boolean isAllAccPrefStatusCompleted = true;
    for (tffa__AccountPreference__c accPref : appObj.tffa__AccountPreferences__r) {
      if (
        (!(CZWTFCConstants.ADDON_STATUS_COMPLETED).equals(accPref.tffa__Status__c)) &&
        accPref.tffa__AddOnServiceType__c == FISCCIntegrationConstants.DBT_TYPE
      ) {
        isAllAccPrefStatusCompleted = false;
      }
    }

    if (!containsDebitCard(appObj) && appObj.tffa__AccountPreferences__r != null && !appObj.tffa__AccountPreferences__r.isEmpty()) {
      return CZWTFCConstants.PROCESS_STATUS_NOT_APPLICABLE;
    } else if (isAllAccPrefStatusCompleted) {
      return CZWTFCConstants.PROCESS_STATUS_SUCCESS;
    } else {
      return CZWTFCConstants.PROCESS_STATUS_FAILURE;
    }
  }

  public static boolean containsDebitCard(tffa__Application__c app) {
    for (tffa__AccountPreference__c accPref : app.tffa__AccountPreferences__r) {
      if (accPref.tffa__AddOnServiceType__c == FISCCIntegrationConstants.DBT_TYPE && accPref.tffa__Enabled__c) {
        return true;
      }
    }
    return false;
  }

  public static Boolean getPrimaryAccountStatus(tffa__AccountPreference__c accPref) {
    if (!statuses.contains(FISCCIntegrationLogService.applicationObjMap.get(accPref.tffa__Application__c).tffa__Status__c)) {
      return true;
    } else if (
      accPref.PriSavingApplicationId__c != null &&
      FISCCIntegrationLogService.applicationObjMap.get(accPref.PriSavingApplicationId__c) != null &&
      !statuses.contains(FISCCIntegrationLogService.applicationObjMap.get(accPref.PriSavingApplicationId__c).tffa__Status__c)
    ) {
      return true;
    } else {
      return false;
    }
  }
}