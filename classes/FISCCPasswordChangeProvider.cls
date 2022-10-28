public with sharing class FISCCPasswordChangeProvider {
  @TestVisible
  private static boolean testException = false;

  public static Boolean processPasswordChange(FISIBSAuthConfig__c fisAuth, String password) {
    tffa.Logger.debug('in FISCCPasswordChangeProvider processPasswordChange fisAuth: ' + fisAuth + ' Password: ' + password);

    Boolean isSuccess = false;
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }

      String strDeveloperName = 'PasswordChange';
      FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig(strDeveloperName);

      FISCC_Charter_Config__mdt charterConfig = FISCCIntegrationLogRepository.findCharterConfigByBrandCode(fisAuth.BrandCode__c);

      FISCCIntegrationLogService.auth = FISCCGetAccessTokenProvider.processGetAccessToken(charterConfig);

      charterConfig.IBSAuthorization__c = fisAuth.IBSAuthorization__c;
      isSuccess = FISCCPasswordChangeExtension.invokeApiCall(fisAuth, password, adapterConfig, charterConfig);
    } catch (Exception ex) {
      tffa.Logger.debug(
        'Exception in FISCCPasswordChangeProvider processPasswordChange ' +
        ex.getMessage() +
        ' Exception :::' +
        ex.getStackTraceString()
      );
    }
    return isSuccess;
  }
}