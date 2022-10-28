public inherited sharing class FCMGenerateDocIdResponseBuilder implements FISCCHostResponseBuilder {
  public FISCCTransactionResponseBaseDTO build(
    String hostResponse,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    try {
      return (String.isNotBlank(hostResponse))
        ? (FCMGenerateDocIdResponse) System.JSON.deserialize(hostResponse, FCMGenerateDocIdResponse.class)
        : null;
    } catch (Exception ex) {
      tffa.Logger.error('Exception into getHostResponseString :::' + ex.getMessage() + ' LineNumber :::' + ex.getStackTraceString());
      return null;
    }
  }

  public Object parseResponse(
    FISCCTransactionResponseBaseDTO response,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    FCMGenerateDocIdResponse perOutputResponse = null;
    perOutputResponse = (FCMGenerateDocIdResponse) response;

    return perOutputResponse;
  }
}