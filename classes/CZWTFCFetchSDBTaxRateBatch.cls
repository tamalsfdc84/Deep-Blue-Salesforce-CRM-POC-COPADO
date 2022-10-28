global with sharing class CZWTFCFetchSDBTaxRateBatch extends tffa.AbstractBatchJob {
  public static List<tffa__Location__c> locationlst = new List<tffa__Location__c>();
  public List<tffa__BrandLocation__c> start(Database.BatchableContext bc) {
    tffa.Logger.debug('CZWTFCFetchSDBTaxRateBatch start Datetime : ' + String.valueOf(Datetime.now()));
    return CZWTFCHelperRepository.getBrandLocations();
  }

  public void execute(Database.BatchableContext bc, List<tffa__BrandLocation__c> brandLocations) {
    tffa.Interaction.begin(CZWTFCFetchSDBTaxRateBatch.class, 'execute');
    try {
      for (tffa__BrandLocation__c brandLocation : brandLocations) {
        tffa__Location__c locationObj = brandLocation.tffa__Location__r;
        CZWTFCFetchSDBTaxRateResponseDTO result = new CZWTFCFetchSDBTaxRateResponseDTO();
        FISCCIntegrationLogService.setCharterConfig(brandLocation.tffa__Brand__r.tffa__Code__c);
        FISCCIntegrationLogService.auth = FISCCGetAccessTokenProvider.processGetAccessToken(FISCCIntegrationLogService.charterConfig);
        result = CZWTFCFetchSDBTaxRateProvider.generateBranchDetails(
          locationObj.FISBranchCode__c,
          FISCCIntegrationLogService.charterConfig
        );

        if (result != null && result.entity != null && result.entity.branchesDetail != null) {
          locationObj.CZSDBSalesTaxPct__c = result.entity.branchesDetail.SafeDPBoxSalesTaxPct;
        } else {
          locationObj.CZSDBSalesTaxPct__c = '0.000';
        }

        locationlst.add(locationObj);
      }

      CZWTFCHelperRepository.saveLocation(locationlst);
    } catch (Exception ex) {
      tffa.logger.error('Exception in  CZWTFCFetchSDBTaxRateBatch ' + ex.getMessage() + ' ' + ex.getStackTraceString());
    } finally {
      tffa.Logger.debug('CZWTFCFetchSDBTaxRateBatch.execute: Execute Datetime Ended on : ' + String.valueOf(Datetime.now()));
      tffa.Interaction.close();
    }
  }

  public void finish(Database.BatchableContext bc) {
    tffa.Logger.debug('CZWTFCFetchSDBTaxRateBatch Completed at  : ' + String.valueOf(Datetime.now()));
  }
}