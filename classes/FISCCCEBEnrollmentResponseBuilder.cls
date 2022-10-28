public inherited sharing class FISCCCEBEnrollmentResponseBuilder implements FISCCHostResponseBuilder {
  public FISCCCEBEnrollmentResponseBuilder() {
  }
  @TestVisible
  private static boolean testException = false;
  public FISCCTransactionResponseBaseDTO build(
    String hostResponse,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt codeConnectConfig
  ) {
    tffa.Logger.debug('build response is called');
    tffa.Logger.debug('hostResponse inside responsebuilder ==>' + hostResponse);

    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      //hostResponse = hostResponse.replace('control-data', 'controlData');
      tffa.Logger.debug('Response ==> ' + System.JSON.deserialize(hostResponse, FISCCCEBEnrollmentResponseDTO.class));
      tffa.Logger.debug(
        'deserialized Response ==> ' +
        (FISCCCEBEnrollmentResponseDTO) System.JSON.deserialize(hostResponse, FISCCCEBEnrollmentResponseDTO.class)
      );
      return (String.isNotBlank(hostResponse))
        ? (FISCCCEBEnrollmentResponseDTO) System.JSON.deserialize(hostResponse, FISCCCEBEnrollmentResponseDTO.class)
        : null;
    } catch (Exception ex) {
      tffa.Logger.error('Exception into getHostResponseString :::' + ex.getMessage() + ' LineNumber :::' + ex.getStackTraceString());
      return null;
    }
  }

  public Object parseResponse(
    FISCCTransactionResponseBaseDTO response,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt codeConnectConfig
  ) {
    FISCCCEBEnrollmentResponseDTO perOutputResponse = null;
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      if (response != null) {
        perOutputResponse = (FISCCCEBEnrollmentResponseDTO) response;
        tffa.Logger.debug('perOutputResponse  in response builder ==> ' + perOutputResponse);
      }
    } catch (Exception ex) {
      tffa.Logger.error(
        'Exception in FISCCCEBEnrollmentResponseBuilder : ' +
        ex.getMessage() +
        ' Exception :::' +
        ex.getStackTraceString()
      );
      return null;
    }
    tffa.Logger.debug('Response in FISCCCEBEnrollmentResponseBuilder ::: ' + perOutputResponse);
    return perOutputResponse;
  }
}