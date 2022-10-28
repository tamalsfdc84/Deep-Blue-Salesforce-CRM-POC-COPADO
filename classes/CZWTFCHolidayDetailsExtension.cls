public with sharing class CZWTFCHolidayDetailsExtension {
  public static CZWTFCFISHolidayResponse invokeHolidayDetails(
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    CZWTFCFISHolidayResponse response;
    CZWTFCFISHolidayResponse finalResponse = new CZWTFCFISHolidayResponse();
    Object result = null;

    try {
      FISCC_Adapter_Configs__mdt adapterConfigInput = adapterConfig.clone(false, true);

      result = FISCCHostAdapter.processHostRequest(null, adapterConfigInput, charterConfig);
      tffa.logger.debug('CZWTFCHolidayDetailsExtension : invokeHolidayDetail result ==>' + result);
      response = isFISCCAPICallSuccess(result);
      tffa.logger.debug('CZWTFCHolidayDetailsExtension : response ==>' + response);
      if (response != null) {
        finalResponse.controlData = response.controlData;
        finalResponse.holidayList = response.holidayList;
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in CZWTFCHolidayDetailsExtension.invokeHolidayDetails : ' + ex.getMessage() + ex.getStackTraceString());
    }
    return finalResponse;
  }

  public static CZWTFCFISHolidayResponse isFISCCAPICallSuccess(Object response) {
    CZWTFCFISHolidayResponse objCZWTFCFISHolidayResponse;
    try {
      if (response instanceof CZWTFCFISHolidayResponse) {
        objCZWTFCFISHolidayResponse = (CZWTFCFISHolidayResponse) response;
      }
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in CZWTFCHolidayDetailsExtension.isFISCCAPICallSuccess : ' + ex.getMessage() + ex.getStackTraceString());
    }
    return objCZWTFCFISHolidayResponse;
  }
}