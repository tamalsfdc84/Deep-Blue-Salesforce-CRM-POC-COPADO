public inherited sharing class CZIRAAddBeneficiaryResponseBuilder implements FISCCHostResponseBuilder {
  public CZIRAAddBeneficiaryResponseBuilder() {
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

    try {
      return (String.isNotBlank(hostResponse))
        ? (CZIRAAddBeneficiaryResponseDTO) System.JSON.deserialize(hostResponse, CZIRAAddBeneficiaryResponseDTO.class)
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
    CZIRAAddBeneficiaryResponseDTO perOutputResponse = null;
    try {
      if (response != null) {
        perOutputResponse = (CZIRAAddBeneficiaryResponseDTO) response;
      }
    } catch (Exception ex) {
      tffa.Logger.error(
        'Exception in CZIRAAddBeneficiaryResponseBuilder : ' +
        ex.getMessage() +
        ' Exception :::' +
        ex.getStackTraceString()
      );
    }
    tffa.Logger.debug('Response in CZIRAAddBeneficiaryResponseBuilder ::: ' + perOutputResponse);
    return perOutputResponse;
  }
}