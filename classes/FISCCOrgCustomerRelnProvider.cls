public with sharing class FISCCOrgCustomerRelnProvider {
  public static boolean createBusinessAndOwnersReln(List<tffa__Party__c> partyObjs, tffa__Submission__c subObj) {
    tffa.Logger.debug('In FISCCDepositOriginationProvider createBusinessAndOwnersReln');
    Boolean isAPICall = false;
    try {
      if (String.isBlank(FISCCIntegrationLogService.auth)) {
        FISCCIntegrationLogService.auth = FISCCGetAccessTokenProvider.processGetAccessToken(FISCCIntegrationLogService.charterConfig);
      }
      tffa.logger.debug('FISCCIntegrationLogService.auth in DO==>' + FISCCIntegrationLogService.auth);
      isAPICall = FISCCOrgCustomerRelnExtension.invokeBusinessOwnerRelnCall(partyObjs, subObj);
      tffa.logger.debug('isAPICall in DO==>' + isAPICall);
    } catch (Exception ex) {
      tffa.Logger.error('Exception in createBusinessAndOwnersReln ' + ex.getLineNumber() + ' ' + ex.getMessage());
    }
    return isAPICall;
  }
}