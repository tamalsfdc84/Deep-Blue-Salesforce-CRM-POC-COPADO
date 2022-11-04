public inherited sharing class CZWTFCHSAProvider {
  
  public static void addHSABeneficiary( List<tffa__Beneficiary__c> beneficiaryList, tffa__Application__c applicationObj) {
    try {
      FISCCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.HSA_ENQUIRY);
      FISCCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.HSA_NEW_BENEFICIARY, applicationObj.Id, true);
      FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig('NewHSABeneficiary');
      CZHSAAddBeneficiaryExtension.invokeApiCall(adapterConfig, FISCCIntegrationLogService.charterConfig, beneficiaryList, applicationObj);
    } catch (Exception ex) {
      tffa.logger.error('Exception in  CZWTFCHSAProvider ' + ex.getMessage() + ' ' + ex.getStackTraceString());
    }
  }
}