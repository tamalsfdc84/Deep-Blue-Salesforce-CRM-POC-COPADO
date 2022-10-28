public inherited sharing class FISCCDebitCardAccRelResponseBuilder implements FISCCHostResponseBuilder {
  public FISCCDebitCardAccRelResponseBuilder() {
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
      return (String.isNotBlank(hostResponse))
        ? (FISCCDebitCardAccRelResponseDTO) System.JSON.deserialize(hostResponse, FISCCDebitCardAccRelResponseDTO.class)
        : null;
    } catch (Exception ex) {
      tffa.Logger.error('Exception in getHostResponseString :::' + ex.getMessage() + ' LineNumber :::' + ex.getStackTraceString());
      return null;
    }
  }

  public Object parseResponse(
    FISCCTransactionResponseBaseDTO response,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt codeConnectConfig
  ) {
    FISCCDebitCardAccRelResponseDTO perOutputResponse = null;
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      if (response != null) {
        perOutputResponse = (FISCCDebitCardAccRelResponseDTO) response;
      }
    } catch (Exception ex) {
      tffa.Logger.error(
        'Exception in FISCCDebitCardAccRelResponseBuilder : ' +
        ex.getMessage() +
        ' Exception :::' +
        ex.getStackTraceString()
      );
    }
    tffa.Logger.debug('Response in FISCCDebitCardAccRelResponseBuilder ::: ' + perOutputResponse);
    return perOutputResponse;
  }
}