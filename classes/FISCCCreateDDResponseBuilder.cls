public with sharing class FISCCCreateDDResponseBuilder implements FISCCHostResponseBuilder {
  public FISCCCreateDDResponseBuilder() {
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
        ? (FISCCCreateDDResponseDTO) System.JSON.deserialize(hostResponse, FISCCCreateDDResponseDTO.class)
        : null;
    } catch (Exception ex) {
      tffa.Logger.error(
        'Exception into FISCCCreateDDResponseDTO getHostResponseString :::' +
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
    FISCCCreateDDResponseDTO perOutputResponse = null;
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      if (response != null) {
        perOutputResponse = (FISCCCreateDDResponseDTO) response;
        tffa.Logger.debug('perOutputResponse  in response builder ==> ' + perOutputResponse);
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in FISCCCreateDDResponseDTO : ' + ex.getMessage() + ' Exception :::' + ex.getStackTraceString());
      return null;
    }
    tffa.Logger.debug('Response in FISCCCreateDDResponseDTO ::: ' + perOutputResponse);
    return perOutputResponse;
  }
}