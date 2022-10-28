public with sharing class CZWTFCIRAPlanBeneficiaryRespBuilder implements FISCCHostResponseBuilder {
  @TestVisible
  private static boolean testException = false;
  public CZWTFCIRAPlanBeneficiaryRespBuilder() {
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

      hostResponse = hostResponse.replace('plan-beneficiaries-dataLst', 'planBeneficiariesDataLst');
      hostResponse = hostResponse.replace('plan-beneficiaries', 'planBeneficiary');

      tffa.Logger.debug('CZWTFCIRAPlanBeneficiaryRespBuilder.build hostResponse ==> ' + hostResponse);
      return (String.isNotBlank(hostResponse))
        ? (FISCCGetIRAPlanBeneficiaryEntityResponse) System.JSON.deserialize(hostResponse, FISCCGetIRAPlanBeneficiaryEntityResponse.class)
        : null;
    } catch (Exception ex) {
      tffa.Logger.debug(
        'Exception into CZWTFCIRAPlanBeneficiaryRespBuilder.build :::' +
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
    FISCCGetIRAPlanBeneficiaryEntityResponse perOutputResponse = null;

    CZWTFCIRAPlanBeneficiaryResponse objCZWTFCIRAPlanBeneficiaryResponse;
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      if (response != null) {
        perOutputResponse = (FISCCGetIRAPlanBeneficiaryEntityResponse) response;
        tffa.Logger.debug('CZWTFCIRAPlanBeneficiaryRespBuilder.parseResponse: perOutputResponse  ==> ' + perOutputResponse);
        objCZWTFCIRAPlanBeneficiaryResponse = new CZWTFCIRAPlanBeneficiaryResponse();
        if (perOutputResponse.Entity != null) {
          objCZWTFCIRAPlanBeneficiaryResponse.planBeneficiariesDataLst = perOutputResponse.Entity.planBeneficiariesDataLst; 
        }
        tffa.Logger.debug(
          'CZWTFCIRAPlanBeneficiaryRespBuilder.parseResponse: objCZWTFCIRAPlanBeneficiaryResponse ==> ' + objCZWTFCIRAPlanBeneficiaryResponse
        );
      }
    } catch (Exception ex) {
      tffa.Logger.debug(
        'Exception in CZWTFCIRAPlanBeneficiaryRespBuilder.parseResponse : ' +
        ex.getMessage() +
        ' Exception :::' +
        ex.getStackTraceString()
      );
      return null;
    }
    tffa.Logger.debug('CZWTFCIRAPlanBeneficiaryRespBuilder.parseResponse: GetOfficer Response : ' + objCZWTFCIRAPlanBeneficiaryResponse);

    return objCZWTFCIRAPlanBeneficiaryResponse;
  }
}