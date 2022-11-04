public with sharing class CZWTFCFISHolidayProvider {
  public static CZWTFCFISHolidayResponse getHolidayDetails(String brandCode) {
    tffa.logger.debug('CZWTFCFISHolidayProvider : getHolidayDetails');
    CZWTFCFISHolidayResponse response;
    try {
      Boolean isAPICallFailed = false;
      Boolean isSuccess = false;
      String adapterName = 'GetFISHolidayDetails';
      FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig(adapterName);
      FISCCIntegrationLogService.setCharterConfig(brandCode);
      FISCCIntegrationLogService.auth = FISCCGetAccessTokenProvider.processGetAccessToken(FISCCIntegrationLogService.charterConfig);
      response = CZWTFCHolidayDetailsExtension.invokeHolidayDetails(adapterConfig, FISCCIntegrationLogService.charterConfig);
    } catch (Exception ex) {
      tffa.logger.debug('CZWTFCFISHolidayProvider.getHolidayDetails: Exception :::' + ex.getMessage() + ex.getStackTraceString());
    }
    return response;
  }
}