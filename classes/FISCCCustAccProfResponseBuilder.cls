public with sharing class FISCCCustAccProfResponseBuilder implements FISCCHostResponseBuilder {
  public FISCCCustAccProfResponseBuilder() {
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

      for (String strMapKey : FISCCIntegrationConstants.mapOfHyphenValues.keySet()) {
        if (hostResponse.contains(FISCCIntegrationConstants.mapOfHyphenValues.get(strMapKey))) {
          hostResponse = hostResponse.replace(FISCCIntegrationConstants.mapOfHyphenValues.get(strMapKey), strMapKey);
        }
      }
      tffa.Logger.debug('hostResponse after hyphen replaced ==>' + hostResponse);
      //hostResponse = hostResponse.replace('control-data', 'controlData');
      tffa.Logger.debug('Response ==> ' + System.JSON.deserialize(hostResponse, FISCCCustomerAccProfileResponse.class));
      tffa.Logger.debug(
        'deserialized Response ==> ' +
        (FISCCCustomerAccProfileResponse) System.JSON.deserialize(hostResponse, FISCCCustomerAccProfileResponse.class)
      );
      return (String.isNotBlank(hostResponse))
        ? (FISCCCustomerAccProfileResponse) System.JSON.deserialize(hostResponse, FISCCCustomerAccProfileResponse.class)
        : null;
    } catch (Exception ex) {
      tffa.Logger.error(
        'Exception into FISCCCustomerAccProfileResponse getHostResponseString :::' +
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
    FISCCCustomerAccProfileResponse perOutputResponse = null;
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      if (response != null) {
        perOutputResponse = (FISCCCustomerAccProfileResponse) response;
        tffa.Logger.debug('perOutputResponse  in response builder ==> ' + perOutputResponse);
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in FISCCCustomerAccProfileResponse : ' + ex.getMessage() + ' Exception :::' + ex.getStackTraceString());
      return null;
    }
    tffa.Logger.debug('Response in FISCCCustomerAccProfileResponse ::: ' + perOutputResponse);
    return perOutputResponse;
  }
}