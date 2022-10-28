public with sharing class CZWTFCMulesoftOAuthProvider {
  public static String getAuthHeader() {
    MuleSoft_Adapter_Config__mdt adapterConfig = CZWTFCHelperRepository.fetchMulesoftAdapterConfig('OAuth');

    String requestBody =
      'grant_type=' +
      adapterConfig.GrantType__c +
      '&client_id=' +
      adapterConfig.ClientId__c +
      '&client_secret=' +
      adapterConfig.ClientSecret__c;
    String authHeader;
    Object resp = CZMulesoftAdapter.invokeAPI(requestBody, adapterConfig);
    if (resp != null) {
      CZMDMOAuthResponse authResp = (CZMDMOAuthResponse) resp;
      authHeader = authResp.token_type+' '+ authResp.access_token;
    }
    tffa.Logger.debug(authHeader);
    return authHeader;
  }
}