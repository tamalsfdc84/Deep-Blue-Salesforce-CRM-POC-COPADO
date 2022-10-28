public with sharing class FISCCDeficitTransferProvider {
  @TestVisible
  private static boolean testException = false;

  public static boolean transferFundInstructions(Map<String, String> reqData, String brandCode) {
    tffa.Logger.debug('in FISIBSDeficitTransferProvider transferFundInstructions brandCode: ' + brandCode + ' reqData: ' + reqData);

    Boolean isSuccess = false;
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      String strDeveloperName = 'DeficitFundTransfer';
      FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig(strDeveloperName);

      FISCC_Charter_Config__mdt charterConfig = FISCCIntegrationLogRepository.findCharterConfigByBrandCode(brandCode);

      FISCCIntegrationLogService.auth = FISCCGetAccessTokenProvider.processGetAccessToken(charterConfig);

      FISIBSAuthConfig__c fisAuthConfig = FISCCIntegrationLogRepository.findAuthByBrandandActiveState(brandCode, true);

      charterConfig.IBSAuthorization__c = fisAuthConfig.IBSAuthorization__c;
      isSuccess = FISCCDeficitTransferExtension.invokeApiCall(reqData, adapterConfig, charterConfig);
    } catch (Exception ex) {
      tffa.Logger.debug(
        'Exception in FISIBSDeficitTransferProvider transferFundInstructions ' +
        ex.getMessage() +
        ' Exception :::' +
        ex.getStackTraceString()
      );
    }
    return isSuccess;
  }
}