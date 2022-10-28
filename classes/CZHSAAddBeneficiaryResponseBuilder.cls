public inherited sharing class CZHSAAddBeneficiaryResponseBuilder implements FISCCHostResponseBuilder {
  public CZHSAAddBeneficiaryResponseBuilder() {
  }

  public FISCCTransactionResponseBaseDTO build(
    String hostResponse,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt codeConnectConfig
  ) {
    tffa.Logger.debug('build response is called');
    tffa.Logger.debug('hostResponse inside responsebuilder ==>' + hostResponse);

    for (String strMapKey : FISCCIntegrationConstants.mapOfHyphenValues.keySet()) {
      if (hostResponse.contains(FISCCIntegrationConstants.mapOfHyphenValues.get(strMapKey))) {
        hostResponse = hostResponse.replace(FISCCIntegrationConstants.mapOfHyphenValues.get(strMapKey), strMapKey);
      }
    }

    tffa.Logger.debug('hostResponse::' + hostResponse);

    try {
      return (String.isNotBlank(hostResponse))
        ? (CZHSAAddBeneficiaryResponseDTO) System.JSON.deserialize(hostResponse, CZHSAAddBeneficiaryResponseDTO.class)
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
    CZHSAAddBeneficiaryResponseDTO perOutputResponse = null;
    try {
      if (response != null) {
        perOutputResponse = (CZHSAAddBeneficiaryResponseDTO) response;
      }
    } catch (Exception ex) {
      tffa.Logger.error(
        'Exception in CZHSAAddBeneficiaryResponseBuilder : ' +
        ex.getMessage() +
        ' Exception :::' +
        ex.getStackTraceString()
      );
    }
    tffa.Logger.debug('Response in CZHSAAddBeneficiaryResponseBuilder ::: ' + perOutputResponse);
    return perOutputResponse;
  }
}