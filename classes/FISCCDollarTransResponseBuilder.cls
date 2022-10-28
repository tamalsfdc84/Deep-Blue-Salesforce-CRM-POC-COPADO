public with sharing class FISCCDollarTransResponseBuilder implements FISCCHostResponseBuilder {
  public FISCCDollarTransResponseBuilder() {
  }

  @TestVisible
  private static boolean testException = false;
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
      return (String.isNotBlank(hostResponse))
        ? (FISCCDollarTransResponseDTO) System.JSON.deserialize(hostResponse, FISCCDollarTransResponseDTO.class)
        : null;
    } catch (Exception ex) {
      tffa.Logger.error(
        'Exception into FISCCDollarTransResponseDTO getHostResponseString :::' +
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
    FISCCDollarTransResponseDTO perOutputResponse = null;
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      if (response != null) {
        perOutputResponse = (FISCCDollarTransResponseDTO) response;
        tffa.Logger.debug('perOutputResponse  in response builder ==> ' + perOutputResponse);
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in FISCCDollarTransResponseDTO : ' + ex.getMessage() + ' Exception :::' + ex.getStackTraceString());
      return null;
    }
    tffa.Logger.debug('Response in FISCCDollarTransResponseDTO ::: ' + perOutputResponse);
    return perOutputResponse;
  }
}