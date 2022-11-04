public inherited sharing class FISCCGetOfficerDetailsResponseBuilder implements FISCCHostResponseBuilder {
  @TestVisible
  private static boolean testException = false;
  public FISCCGetOfficerDetailsResponseBuilder() {
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

      hostResponse = hostResponse.replace('query-parameters-officers-list', 'controlData');

      tffa.Logger.debug('FISCCGetOfficerDetailsResponseBuilder.build hostResponse ==> ' + hostResponse);
      return (String.isNotBlank(hostResponse))
        ? (FISCCGetOfficerDetailsEntityResponse) System.JSON.deserialize(hostResponse, FISCCGetOfficerDetailsEntityResponse.class)
        : null;
    } catch (Exception ex) {
      tffa.Logger.debug(
        'Exception into FISCCGetOfficerDetailsResponseBuilder.build :::' +
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
    FISCCGetOfficerDetailsEntityResponse perOutputResponse = null;

    CZWTFCOfficerDetailsResponse objOfficerDetailsResponse;
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      if (response != null) {
        perOutputResponse = (FISCCGetOfficerDetailsEntityResponse) response;
        tffa.Logger.debug('FISCCGetOfficerDetailsResponseBuilder.parseResponse: perOutputResponse  ==> ' + perOutputResponse);
        objOfficerDetailsResponse = new CZWTFCOfficerDetailsResponse();
        objOfficerDetailsResponse.controlData = perOutputResponse.Entity.ControlData;
        if (perOutputResponse.Entity != null) {
          List<CZWTFCOfficerDetailsDTO> offDtList = new List<CZWTFCOfficerDetailsDTO>();
          for (CZWTFCOfficerDetailsDTO offDtl : perOutputResponse.Entity.officerDetailsLts) {
            if(offDtl.OfcrNbr == 1000){
              continue;
            }
            offDtList.add(offDtl);
          }
          objOfficerDetailsResponse.officerDetailsLts = offDtList;
        }
        tffa.Logger.debug(
          'FISCCGetOfficerDetailsResponseBuilder.parseResponse: objOfficerDetailsResponse ==> ' + objOfficerDetailsResponse
        );
      }
    } catch (Exception ex) {
      tffa.Logger.debug(
        'Exception in FISCCGetOfficerDetailsResponseBuilder.parseResponse : ' +
        ex.getMessage() +
        ' Exception :::' +
        ex.getStackTraceString()
      );
      return null;
    }
    tffa.Logger.debug('FISCCGetOfficerDetailsResponseBuilder.parseResponse: GetOfficer Response : ' + objOfficerDetailsResponse);
    return objOfficerDetailsResponse;
  }
}