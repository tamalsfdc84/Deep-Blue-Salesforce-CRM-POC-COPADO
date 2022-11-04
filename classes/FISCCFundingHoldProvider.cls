public with sharing class FISCCFundingHoldProvider {
  public static Boolean holdFunds(tffa__Application__c appObj, String requestType) {
    Object result = null;
    Boolean isSuccess = false;
    String strDeveloperName = 'FundingHold';

    try {
      FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig(strDeveloperName);
      FISCC_Charter_Config__mdt charterConfig = FISCCIntegrationLogService.charterConfig;
      if (String.isBlank(FISCCIntegrationLogService.auth)) {
        FISCCIntegrationLogService.auth = FISCCGetAccessTokenProvider.processGetAccessToken(charterConfig);
      }

      isSuccess = FISCCFundingHoldExtension.invokeApiCall(appObj, adapterConfig, charterConfig, requestType);
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in FISCCFundingHoldProvider ' + ex.getMessage() + ' Exception :::' + ex.getStackTraceString());
    }
    return isSuccess;
  }
}