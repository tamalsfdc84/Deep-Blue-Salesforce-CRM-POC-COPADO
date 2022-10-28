public inherited sharing class FISCCDebitCardCustDetailsResponseBuilder implements FISCCHostResponseBuilder {
  public FISCCDebitCardCustDetailsResponseBuilder() {
  }
  @TestVisible
  private static boolean testException = false;
  public FISCCTransactionResponseBaseDTO build(
    String hostResponse,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt codeConnectConfig
  ) {
    if (hostResponse != null && String.isNotBlank(hostResponse)) {
      hostResponse = hostResponse.replace('cards-cardholder-address', 'CardsCardholderAddress');
    }
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      return (String.isNotBlank(hostResponse))
        ? (FISCCDebitCardCustDetailsResponseDTO) System.JSON.deserialize(hostResponse, FISCCDebitCardCustDetailsResponseDTO.class)
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
    FISCCDebitCardCustDetailsResponseDTO perOutputResponse = null;
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      if (response != null) {
        perOutputResponse = (FISCCDebitCardCustDetailsResponseDTO) response;
      }
    } catch (Exception ex) {
      tffa.Logger.error(
        'Exception in FISCCDebitCardCustDetailsResponseBuilder : ' +
        ex.getMessage() +
        ' Exception :::' +
        ex.getStackTraceString()
      );
    }
    tffa.Logger.debug('Response in FISCCDebitCardCustDetailsResponseBuilder ::: ' + perOutputResponse);
    return perOutputResponse;
  }
}