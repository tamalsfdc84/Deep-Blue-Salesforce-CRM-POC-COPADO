public with sharing class CZAccNbrGenerationProvider {
  @TestVisible
  private static boolean testException = false;
  public static boolean generateAccountNbr(List<tffa__Application__c> appObjLst) {
    // tffa.Interaction.begin(CZAccNbrGenerationProvider.class, 'generateAccountNbr');
    tffa.Logger.debug('In CZAccNbrGenerationProvider.generateAccountNbr appObjLst ' + appObjLst);
    Object result = null;
    boolean isSuccess = false;
    String strDeveloperName = FISCCIntegrationConstants.DeveloperName_Deposit_Originate;

    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig(strDeveloperName);
      FISCC_Charter_Config__mdt charterConfig = FISCCIntegrationLogService.charterConfig;
      if (String.isBlank(FISCCIntegrationLogService.auth)) {
        FISCCIntegrationLogService.auth = FISCCGetAccessTokenProvider.processGetAccessToken(charterConfig);
      }
      FISCCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.ACCOUNT_NBR_GENERATION);
      FISCCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.ACCOUNT_NBR_GENERATION, '', true);
      isSuccess = CZAccNbrGenerationExtension.invokeApiCall(adapterConfig, charterConfig, appObjLst);
      return isSuccess;
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in CZAccNbrGenerationProvider ' + ex.getMessage() + ' Exception :::' + ex.getStackTraceString());
    } finally {
      // tffa.Interaction.close();
    }
    return isSuccess;
  }
}