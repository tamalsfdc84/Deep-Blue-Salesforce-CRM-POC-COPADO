public inherited sharing class FISCCGetAccessTokenResponseBuilder implements FISCCHostResponseBuilder {
  public FISCCTransactionResponseBaseDTO build(
    String hostResponse,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    try {
      return (String.isNotBlank(hostResponse))
        ? (FISCCGetAccessTokenResponse) System.JSON.deserialize(hostResponse, FISCCGetAccessTokenResponse.class)
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
    FISCCGetAccessTokenResponse perOutputResponse = null;
    perOutputResponse = (FISCCGetAccessTokenResponse) response;
    tffa.Logger.debug('perOutputResponse ==>' + perOutputResponse);
    string access_token = '';
    string token_type = '';
    access_token = perOutputResponse.access_token;
    token_type = perOutputResponse.token_type;
    tffa.Logger.debug('access_token :' + access_token);
    tffa.Logger.debug('token_type :' + token_type);

    return perOutputResponse;
  }
}