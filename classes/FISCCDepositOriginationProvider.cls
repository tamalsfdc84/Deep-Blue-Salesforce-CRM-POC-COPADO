public with sharing class FISCCDepositOriginationProvider {
  public static boolean createDepositOrigination(List<tffa__Party__c> partyObjs, tffa__Application__c appObj, tffa__Submission__c subObj) {
    Boolean isSuccess = false;
    Boolean isAPICall = false;
    Boolean isAPICallFailed = false;
    String custAddKey = null;
    List<tffa__Party__c> listParty = new List<tffa__Party__c>();
    tffa.logger.debug('partyObjs.size()==>' + partyObjs.size());

    if (String.isBlank(FISCCIntegrationLogService.auth)) {
      FISCCIntegrationLogService.auth = FISCCGetAccessTokenProvider.processGetAccessToken(FISCCIntegrationLogService.charterConfig);
    }
    custAddKey = FISCCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.DEPOSIT_ORIGINATOR, appObj.Name, true);
    tffa.logger.debug('FISCCIntegrationLogService.auth in DO==>' + FISCCIntegrationLogService.auth);

    if (FISCCIntegrationLogService.isLogItemNewOrFailed(custAddKey)) {
      isAPICall = FISCCDepositOriginationExtension.invokeDepositOriginationApiCall(partyObjs, appObj, subObj);
      tffa.logger.debug('isAPICall in DO==>' + isAPICall);
      if (isAPICall != null && isAPICall) {
        FISCCIntegrationLogService.setLogOk(FISCCIntegrationConstants.DEPOSIT_ORIGINATOR_COMPLETED);
      } else {
        FISCCIntegrationLogService.setLogFailed(FISCCIntegrationConstants.DEPOSIT_ORIGINATOR_FAILED);
        isAPICallFailed = true;
        tffa.Logger.debug('Create DO  Call Failed for parties ::: ' + partyObjs);
      }
    }
    if (isAPICall) {
      isSuccess = true;
    }

    tffa.logger.debug('isSuccess in createCustomerProvider ==>' + isSuccess);
    return isSuccess;
  }

  public static boolean updateCustomerInformation(tffa__Party__c partyObj) {
    Boolean isApiSuccess = true;
    try {
      String logitemMissingInfo = FISCCIntegrationLogService.setCurrentLogItem(
        FISCCIntegrationConstants.UPDATED_CUSTOMER_INFORMATION,
        partyObj.Name,
        false
      );
      if (FISCCIntegrationLogService.isLogItemNewOrFailed(logitemMissingInfo)) {
        isApiSuccess = FISCCDepositOriginationExtension.sendCustInfo(partyObj);
        if (isApiSuccess) {
          FISCCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.UPDATED_CUSTOMER_INFORMATION);
        } else {
          FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.UPDATED_CUSTOMER_INFORMATION);
        }
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in updateCustomerInformation ' + ex.getMessage() + ' ' + ex.getStackTraceString());
      FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.UPDATED_CUSTOMER_INFORMATION);
    }
    return isApiSuccess;
  }

  public static boolean createPendingApplicants(List<tffa__Party__c> partyObjs, tffa__Application__c appObj, tffa__Submission__c subObj) {
    tffa.Logger.debug('In createPendingApplicants');
    Boolean isSuccess = false;
    Boolean isAPICall = false;
    Boolean isAPICallFailed = false;
    try {
      if (String.isBlank(FISCCIntegrationLogService.auth)) {
        FISCCIntegrationLogService.auth = FISCCGetAccessTokenProvider.processGetAccessToken(FISCCIntegrationLogService.charterConfig);
      }
      tffa.logger.debug('FISCCIntegrationLogService.auth in DO==>' + FISCCIntegrationLogService.auth);
      isAPICall = FISCCDepositOriginationExtension.invokePendingApplicantCreation(partyObjs, appObj, subObj);
      tffa.logger.debug('isAPICall in DO==>' + isAPICall);
      if (isAPICall != null && isAPICall) {
        FISCCIntegrationLogService.setLogOk(FISCCIntegrationConstants.DEPOSIT_ORIGINATOR_CUSTOMER_CREATION_SUCCESS);
      } else {
        FISCCIntegrationLogService.setLogFailed(FISCCIntegrationConstants.DEPOSIT_ORIGINATOR_CUSTOMER_CREATION_FAILURE);
        isAPICallFailed = true;
        tffa.Logger.debug('Create DO  Call Failed for parties ::: ' + partyObjs);
      }

      if (isAPICall) {
        isSuccess = true;
      }

      tffa.logger.debug('isSuccess in createCustomerProvider ==>' + isSuccess);
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in createPendingApplicants ' + ex.getLineNumber() + ' ' + ex.getMessage());
    }
    return isSuccess;
  }

  public static boolean createBusinessAndOwners(List<tffa__Party__c> partyObjs, tffa__Submission__c subObj) {
    tffa.Logger.debug('In FISCCDepositOriginationProvider createBusinessAndOwners');
    Boolean isAPICall = false;
    try {
      if (String.isBlank(FISCCIntegrationLogService.auth)) {
        FISCCIntegrationLogService.auth = FISCCGetAccessTokenProvider.processGetAccessToken(FISCCIntegrationLogService.charterConfig);
      }
      tffa.logger.debug('FISCCIntegrationLogService.auth in DO==>' + FISCCIntegrationLogService.auth);
      isAPICall = FISCCDepositOriginationExtension.invokeDOBusinessCall(partyObjs, subObj);
      tffa.logger.debug('isAPICall in DO==>' + isAPICall);
    } catch (Exception ex) {
      tffa.Logger.error('Exception in createBusinessAndOwners ' + ex.getLineNumber() + ' ' + ex.getMessage());
    }
    return isAPICall;
  }
}