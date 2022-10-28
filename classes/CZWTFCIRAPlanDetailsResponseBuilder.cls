public with sharing class CZWTFCIRAPlanDetailsResponseBuilder implements FISCCHostResponseBuilder {
  @TestVisible
  private static boolean testException = false;

  public CZWTFCIRAPlanDetailsResponseBuilder() {
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

      hostResponse = hostResponse.replace('plans-data', 'planData');
      hostResponse = hostResponse.replace('plans-accounts-dataLst', 'planAccountData');

      tffa.Logger.debug('CZWTFCIRAPlanDetailsResponseBuilder.build hostResponse ==> ' + hostResponse);
      return (String.isNotBlank(hostResponse))
        ? (FISCCGetIRAPlansDetailsEntityResponse) System.JSON.deserialize(hostResponse, FISCCGetIRAPlansDetailsEntityResponse.class)
        : null;
    } catch (Exception ex) {
      tffa.Logger.debug(
        'Exception into CZWTFCIRAPlanDetailsResponseBuilder.build :::' +
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
    FISCCGetIRAPlansDetailsEntityResponse perOutputResponse = null;

    CZWTFCIRAPlanDetailsResponse objCZWTFCIRAPlanDetailsResponse;
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }

      if (response != null) {
        perOutputResponse = (FISCCGetIRAPlansDetailsEntityResponse) response;
        tffa.Logger.debug('CZWTFCIRAPlanDetailsResponseBuilder.parseResponse: perOutputResponse  ==> ' + perOutputResponse);
        objCZWTFCIRAPlanDetailsResponse = new CZWTFCIRAPlanDetailsResponse();
        if (perOutputResponse.Entity != null) {
          objCZWTFCIRAPlanDetailsResponse.planData = perOutputResponse.Entity.planData;
          objCZWTFCIRAPlanDetailsResponse.planAccountData = perOutputResponse.Entity.planAccountData;
        }
        tffa.Logger.debug(
          'CZWTFCIRAPlanDetailsResponseBuilder.parseResponse: objCZWTFCIRAPlanDetailsResponse ==> ' + objCZWTFCIRAPlanDetailsResponse
        );
      }
    } catch (Exception ex) {
      tffa.Logger.debug(
        'Exception in CZWTFCIRAPlanDetailsResponseBuilder.parseResponse : ' +
        ex.getMessage() +
        ' Exception :::' +
        ex.getStackTraceString()
      );
      return null;
    }
    tffa.Logger.debug('CZWTFCIRAPlanDetailsResponseBuilder.parseResponse: objCZWTFCIRAPlanDetailsResponse : ' + objCZWTFCIRAPlanDetailsResponse);

    return objCZWTFCIRAPlanDetailsResponse;
  }
}