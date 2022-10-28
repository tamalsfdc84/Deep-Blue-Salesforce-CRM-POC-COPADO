public inherited sharing class FISCCCEBEnrollmentProvider {
  public static Object CEBEnroll(tffa__Party__c partyObj, String userName, String password) {
    Boolean isSuccess = false;
    Boolean isAPICall = false;
    Boolean isAPICallFailed = false;

    Object result = null;

    String strDeveloperName = 'CEBEnroll';

    try {
      FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig(strDeveloperName);
      FISCC_Charter_Config__mdt charterConfig = FISCCIntegrationLogRepository.findCharterConfigByBrandCode(partyObj.tffa__BrandCode__c);
      if (!Test.isRunningTest()) {
        FISIBSAuthConfig__c fisAuthConfig = FISCCIntegrationLogRepository.findAuthByBrandandActiveState(partyObj.tffa__BrandCode__c, true);
        charterConfig.IBSAuthorization__c = fisAuthConfig.IBSAuthorization__c;
      }
      FISCCIntegrationLogService.applicationCode = 'CEB';
      FISCCIntegrationLogService.charterConfig = charterConfig;
      FISCCIntegrationLogService.auth = FISCCGetAccessTokenProvider.processGetAccessToken(charterConfig);

      tffa.logger.debug('partyObj' + partyObj);
      if (partyObj != null) {
        tffa.logger.debug('param partyObj is not empty ..');
        Map<String, Object> paramMap = new Map<String, Object>();
        paramMap.put('partyObj', partyObj);
        paramMap.put('userName', userName);
        paramMap.put('password', password);
        //tffa.logger.debug('paramMap for invokeCEBEnroll :: ' + paramMap);
        result = FISCCCEBEnrollmentExtension.invokeCEBEnroll(paramMap, adapterConfig, charterConfig);
        tffa.logger.debug('result from CEBEnroll provider :: ' + result);
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in FISCCCEBEnrollmentProvider : ' + ex.getMessage() + ' Exception :::' + ex.getStackTraceString());
    }
    tffa.logger.debug('result from CEBEnroll provider :: ' + result);
    return result;
  }
}