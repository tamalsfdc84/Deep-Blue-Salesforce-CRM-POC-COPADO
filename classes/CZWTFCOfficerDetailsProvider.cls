public with sharing class CZWTFCOfficerDetailsProvider {
  public static CZWTFCOfficerDetailsResponse getOfficerDetails(String brandCode) {
    tffa.logger.debug('CZWTFCOfficerDetailsProvider : getOfficerDetails');
    CZWTFCOfficerDetailsResponse response;
    try {
      Boolean isAPICallFailed = false;
      Boolean isSuccess = false;
      String adapterName = 'GetOfficerDetails';
      FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig(adapterName);
      FISCCIntegrationLogService.setCharterConfig(brandCode);
      FISCCIntegrationLogService.auth = FISCCGetAccessTokenProvider.processGetAccessToken(FISCCIntegrationLogService.charterConfig);

      response = CZWTFCOfficerDetailsExtension.invokeOfficeDetails(adapterConfig, FISCCIntegrationLogService.charterConfig);
    } catch (Exception ex) {
      tffa.logger.debug(
        'CZWTFCOfficerDetailsProvider.getOfficerDetails: Exception :::' +
        ex.getMessage() +
        ' Exception:::' +
        ex.getStackTraceString()
      );
      tffa.logger.debug('CZWTFCOfficerDetailsProvider.getOfficerDetails: Execution failed');
    }
    return response;
  }
}