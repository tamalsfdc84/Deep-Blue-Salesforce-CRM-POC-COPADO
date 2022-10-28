public with sharing class FISCCGetInterestRatesProvider {
  //Get Interest Rates
  public static FISCCGetInterestRatesResponse getInterestRates(String brandCode) {
    tffa.logger.debug('FISCCGetInterestRatesProvider.getInterestRates: Inside getInterestRates');
    FISCCGetInterestRatesResponse response;
    try {
      Boolean isAPICallFailed = false;
      Boolean isSuccess = false;
      String adapterName = 'GetInterestRates';
      FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig(adapterName);
      FISCCIntegrationLogService.setCharterConfig(brandCode);
      FISCCIntegrationLogService.auth = FISCCGetAccessTokenProvider.processGetAccessToken(FISCCIntegrationLogService.charterConfig);

      response = FISCCGetInterestRatesExtension.invokeGetInterestRates(adapterConfig, FISCCIntegrationLogService.charterConfig);
    } catch (Exception ex) {
      tffa.logger.debug(
        'FISCCGetInterestRatesProvider.getInterestRates: Exception :::' +
        ex.getMessage() +
        ' Exception:::' +
        ex.getStackTraceString()
      );
      tffa.logger.debug('FISCCGetInterestRatesProvider.getInterestRates: Execution failed');
    }
    return response;
  }
}