public with sharing class FISCCAddBenefRelnProvider {
  public static Boolean addBenefReln(tffa__Application__c appObj) {
    Object result = null;
    Boolean isSuccess = false;
    String strDeveloperName = 'BenefReln';

    try {
      FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig(strDeveloperName);
      FISCC_Charter_Config__mdt charterConfig = FISCCIntegrationLogService.charterConfig;
      if (String.isBlank(FISCCIntegrationLogService.auth)) {
        FISCCIntegrationLogService.auth = FISCCGetAccessTokenProvider.processGetAccessToken(charterConfig);
      }

      if (!Test.isRunningTest()) {
        FISCCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.ADD_BENEFICIARY, appObj.Name, true);
      }

      isSuccess = FISCCBenefRelnExtension.invokeApiCall(appObj, adapterConfig, charterConfig);
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in FISCCAddBenefRelnProvider ' + ex.getMessage() + ' Exception :::' + ex.getStackTraceString());
    }
    return isSuccess;
  }
}