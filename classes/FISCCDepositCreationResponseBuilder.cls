public with sharing class FISCCDepositCreationResponseBuilder implements FISCCHostResponseBuilder {
  public FISCCDepositCreationResponseBuilder() {
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
        ? (FISCCDepositCreationResponseDTO) System.JSON.deserialize(hostResponse, FISCCDepositCreationResponseDTO.class)
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
    FISCCDepositCreationResponseDTO perOutputResponse = null;
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      if (response != null) {
        perOutputResponse = (FISCCDepositCreationResponseDTO) response;
        tffa.Logger.debug('perOutputResponse  in response builder ==> ' + perOutputResponse);
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in FISCCDepositCreationResponseDTO : ' + ex.getMessage() + ' Exception :::' + ex.getStackTraceString());
      return null;
    }
    tffa.Logger.debug('Response in FISCCDepositCreationResponseDTO ::: ' + perOutputResponse);
    return perOutputResponse;
  }
}