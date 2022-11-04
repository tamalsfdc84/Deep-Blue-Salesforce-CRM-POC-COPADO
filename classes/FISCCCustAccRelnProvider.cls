public with sharing class FISCCCustAccRelnProvider {
  public static boolean createCustAccountRelnship(List<tffa__Party__c> partyObjs, tffa__Application__c appObj, tffa__Submission__c subObj) {
    tffa.Logger.debug('In createCustAccountRelnship');
    Boolean isSuccess = false;
    Boolean isAPICall = false;
    Boolean isAPICallFailed = false;

    try {
      if (String.isBlank(FISCCIntegrationLogService.auth)) {
        FISCCIntegrationLogService.auth = FISCCGetAccessTokenProvider.processGetAccessToken(FISCCIntegrationLogService.charterConfig);
      }
      tffa.logger.debug('FISCCIntegrationLogService.auth in DO==>' + FISCCIntegrationLogService.auth);
      isAPICall = FISCCCustAccRelnExtension.invokeCustAccRelnAPI(partyObjs, appObj, subObj);
      tffa.logger.debug('isAPICall in createCustAccountRelnship==>' + isAPICall);
      if (isAPICall != null && isAPICall) {
        //FISCCIntegrationLogService.setLogOk(FISCCIntegrationConstants.CUSTOMER_ACCOUNT_RELATIONSHIP_SUCCESS);
      } else {
        //FISCCIntegrationLogService.setLogFailed(FISCCIntegrationConstants.CUSTOMER_ACCOUNT_RELATIONSHIP_FAILURE);
        isAPICallFailed = true;
        tffa.Logger.debug('Create DO  Call Failed for parties ::: ' + partyObjs);
      }

      if (isAPICall) {
        isSuccess = true;
      }

      tffa.logger.debug('isSuccess in createCustomerProvider ==>' + isSuccess);
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in createCustAccountRelnship ' + ex.getLineNumber() + ' ' + ex.getMessage());
    }
    return isSuccess;
  }
}