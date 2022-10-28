public inherited sharing class CZWTFCFetchSDBTaxRateProvider {
  public static CZWTFCFetchSDBTaxRateResponseDTO generateBranchDetails(String branchCode, FISCC_Charter_Config__mdt charterConfig) {
    Object result = null;
    try {
      FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig('GetBranchDetails');
      adapterConfig.ServiceURL__c = adapterConfig.ServiceURL__c.replace('{BrchNbr}', branchCode);
      result = FISCCHostAdapter.processHostRequest(null, adapterConfig, FISCCIntegrationLogService.charterConfig);

      if (result instanceof CZWTFCFetchSDBTaxRateResponseDTO) {
        CZWTFCFetchSDBTaxRateResponseDTO resp = (CZWTFCFetchSDBTaxRateResponseDTO) result;
        return resp;
      }
    } catch (Exception ex) {
      tffa.logger.error('Exception in  CZWTFCFetchSDBTaxRateBatchProvider ' + ex.getMessage() + ' ' + ex.getStackTraceString());
    }
    return null;
  }
}