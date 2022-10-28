public inherited sharing class FISCCGetFISHolidayDtlsResponseBuilder implements FISCCHostResponseBuilder {
  @TestVisible
  private static boolean testException = false;
  public FISCCGetFISHolidayDtlsResponseBuilder() {
  }

  public FISCCTransactionResponseBaseDTO build(
    String hostResponse,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt codeConnectConfig
  ) {
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }

      for (String strMapKey : FISCCIntegrationConstants.mapOfHyphenValues.keySet()) {
        if (hostResponse.contains(FISCCIntegrationConstants.mapOfHyphenValues.get(strMapKey))) {
          hostResponse = hostResponse.replace(FISCCIntegrationConstants.mapOfHyphenValues.get(strMapKey), strMapKey);
        }
      }

      tffa.Logger.debug('FISCCGetFISHolidayDtlsResponseBuilder.build hostResponse ==> ' + hostResponse);
      return (String.isNotBlank(hostResponse))
        ? (FISCCGetHolidayEntityResponse) System.JSON.deserialize(hostResponse, FISCCGetHolidayEntityResponse.class)
        : null;
    } catch (Exception ex) {
      tffa.Logger.debug(
        'Exception into FISCCGetFISHolidayDtlsResponseBuilder.build :::' +
        ex.getMessage() +
        ' LineNumber :::' +
        ex.getStackTraceString()
      );
      return null;
    }
  }

  public Object parseResponse(
    FISCCTransactionResponseBaseDTO response,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt codeConnectConfig
  ) {
    FISCCGetHolidayEntityResponse perOutputResponse = null;

    CZWTFCFISHolidayResponse objHolidayDetailsResponse;
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      if (response != null) {
        perOutputResponse = (FISCCGetHolidayEntityResponse) response;
        tffa.Logger.debug('FISCCGetFISHolidayDtlsResponseBuilder.parseResponse: perOutputResponse  ==> ' + perOutputResponse);
        objHolidayDetailsResponse = new CZWTFCFISHolidayResponse();
        objHolidayDetailsResponse.controlData = perOutputResponse.Entity.ControlData;
        if (perOutputResponse.Entity != null) {
          List<CZWTFCFISHolidayDTO> holidayList = new List<CZWTFCFISHolidayDTO>();
          for (CZWTFCFISHolidayDTO holidayDtl : perOutputResponse.Entity.holidayList) {
            holidayList.add(holidayDtl);
          }
          objHolidayDetailsResponse.holidayList = holidayList;
        }
        tffa.Logger.debug(
          'FISCCGetFISHolidayDtlsResponseBuilder.parseResponse: objHolidayDetailsResponse ==> ' + objHolidayDetailsResponse
        );
      }
    } catch (Exception ex) {
      tffa.Logger.debug(
        'Exception in FISCCGetFISHolidayDtlsResponseBuilder.parseResponse : ' +
        ex.getMessage() +
        ' Exception :::' +
        ex.getStackTraceString()
      );
      return null;
    }
    tffa.Logger.debug('FISCCGetFISHolidayDtlsResponseBuilder.parseResponse: ' + objHolidayDetailsResponse);
    return objHolidayDetailsResponse;
  }
}