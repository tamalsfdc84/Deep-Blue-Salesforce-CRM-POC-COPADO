public inherited sharing class FISCCDebitCardNoGenResponseBuilder implements FISCCHostResponseBuilder {
  public FISCCDebitCardNoGenResponseBuilder() {
  }
  @TestVisible
  private static boolean testException = false;
  public FISCCTransactionResponseBaseDTO build(
    String hostResponse,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt codeConnectConfig
  ) {
    if (hostResponse != null && String.isNotBlank(hostResponse)) {
      hostResponse = hostResponse.replace('card-number', 'CardNumber');
    }
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      return (String.isNotBlank(hostResponse))
        ? (FISCCDebitCardNoGenResponseDTO) System.JSON.deserialize(hostResponse, FISCCDebitCardNoGenResponseDTO.class)
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
    FISCCDebitCardNoGenResponseDTO perOutputResponse = null;
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      if (response != null) {
        perOutputResponse = (FISCCDebitCardNoGenResponseDTO) response;
      }
    } catch (Exception ex) {
      tffa.Logger.error(
        'Exception in FISCCDebitCardNoGenResponseBuilder : ' +
        ex.getMessage() +
        ' Exception :::' +
        ex.getStackTraceString()
      );
    }
    tffa.Logger.debug('Response in FISCCDebitCardNoGenResponseBuilder ::: ' + perOutputResponse);
    return perOutputResponse;
  }
}