public inherited sharing class FISAccountPreferenceProvider {
  public static FISCCMultiKeywordsResponseDTO processMultiKeywords(tffa__Application__c app, String type) {
    FISCCMultiKeywordsResponseDTO result = new FISCCMultiKeywordsResponseDTO();
    String strDeveloperName = 'MultiKeywords';
    try {
      FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig(strDeveloperName);
      FISCC_Charter_Config__mdt charterConfig = FISCCIntegrationLogRepository.findCharterConfigByBrandCode(app.tffa__Brand__c);
      if (app.tffa__AccountNumber__c != null) {
        String dpAcctNbr = adapterConfig.IsEncrypted__c
          ? FISCCCommonHelper.encrypt(app.tffa__AccountNumber__c)
          : app.tffa__AccountNumber__c;

        adapterConfig.ServiceURL__c = adapterConfig.ServiceURL__c.replace('{DPAcctNbr}', dpAcctNbr);
      }
      FISCCIntegrationLogService.auth = FISCCGetAccessTokenProvider.processGetAccessToken(charterConfig);

      if (!Test.isRunningTest()) {
        FISIBSAuthConfig__c fisAuthConfig = FISCCIntegrationLogRepository.findAuthByBrandandActiveState(app.tffa__Brand__c, true);
        charterConfig.IBSAuthorization__c = fisAuthConfig.IBSAuthorization__c;
        tffa.Logger.debug('IBSAuth in charter config: ' + charterConfig.IBSAuthorization__c);
      }

      result = (FISCCMultiKeywordsResponseDTO) FISAccountPreferenceExtension.invokemultiKeywordsApi(
        adapterConfig,
        charterConfig,
        type,
        app
      );
    } catch (Exception ex) {
      tffa.Logger.error('Exception in processMultiKeywords : ' + ex.getMessage() + ' Exception :::' + ex.getStackTraceString());
    }
    tffa.logger.debug('result in processMultiKeywords :: ' + result);
    return result;
  }
}