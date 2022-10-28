public inherited sharing class FISCCDebitCardCreationResponseBuilder implements FISCCHostResponseBuilder {
  public FISCCDebitCardCreationResponseBuilder() {
  }
  @TestVisible
  private static boolean testException = false;
  public FISCCTransactionResponseBaseDTO build(
    String hostResponse,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt codeConnectConfig
  ) {
    if (hostResponse != null && String.isNotBlank(hostResponse)) {
      hostResponse = hostResponse.replace('card-new', 'CardNew');
    }
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      return (String.isNotBlank(hostResponse))
        ? (FISCCDebitCardCreationResponseDTO) System.JSON.deserialize(hostResponse, FISCCDebitCardCreationResponseDTO.class)
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
    FISCCDebitCardCreationResponseDTO perOutputResponse = null;
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      if (response != null) {
        perOutputResponse = (FISCCDebitCardCreationResponseDTO) response;
      }
    } catch (Exception ex) {
      tffa.Logger.error(
        'Exception in FISCCDebitCardCreationResponseBuilder : ' +
        ex.getMessage() +
        ' Exception :::' +
        ex.getStackTraceString()
      );
    }
    tffa.Logger.debug('Response in FISCCDebitCardCreationResponseBuilder ::: ' + perOutputResponse);
    return perOutputResponse;
  }
}