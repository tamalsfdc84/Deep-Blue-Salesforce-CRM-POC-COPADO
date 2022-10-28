public inherited sharing class FISCCGetAccessTokenExtension {
  public static String authorization = '';
  public static String getAccessToken(FISCC_Adapter_Configs__mdt adapterConfig, FISCC_Charter_Config__mdt charterConfig) {
    FISCCRequestBaseDTO fisccRequestBaseDTO = null;
    Object result = null;
    try {
      fisccRequestBaseDTO = createGetAccessTokenRequest(adapterConfig, charterConfig);
      tffa.Logger.debug('createGetAccessTokenRequest is called');
      result = FISCCHostAdapter.processHostRequest(fisccRequestBaseDTO, adapterConfig, charterConfig);
      tffa.Logger.debug('result in createGetAccessTokenRequest ==>' + result);
      if (isFISCCAPICallSuccess(result)) {
        tffa.Logger.debug('authorization in getAccessToken ==>' + authorization);
      } else {
        tffa.Logger.error('getAccessToken failed');
      }
      return authorization;
    } catch (Exception ex) {
      tffa.Logger.error('Exception in getAccessToken : ' + ex.getMessage() + ex.getLineNumber() + ex.getStackTraceString());
      return authorization;
    }
  }

  public static FISCCRequestBaseDTO createGetAccessTokenRequest(
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    tffa.Logger.debug('started createGetAccessTokenRequest');
    FISCCRequestBaseDTO fisccRequestBaseDTO = null;
    FISCCGetAccessTokenDTO objFISCCGetAccessTokenRequest = new FISCCGetAccessTokenDTO();
    String strGrant_type = charterConfig.Grant_type__c;
    String strValidityPeriod = String.valueOf(charterConfig.Validity_Period__c);
    String strScopes = charterConfig.Application_Scope__c;
    objFISCCGetAccessTokenRequest.postData =
      'grant_type=' +
      strGrant_type +
      '&validity_period=' +
      strValidityPeriod +
      '&scope=' +
      strScopes;
    tffa.Logger.debug('objFISCCGetAccessTokenRequest.postData ==> ' + objFISCCGetAccessTokenRequest.postData);
    tffa.Logger.debug('objFISCCGetAccessTokenRequest ==>' + objFISCCGetAccessTokenRequest);
    fisccRequestBaseDTO = objFISCCGetAccessTokenRequest;
    return fisccRequestBaseDTO;
  }

  public static boolean isFISCCAPICallSuccess(Object response) {
    Boolean result = null;
    FISCCGetAccessTokenResponse objFISCCGetAccessTokenResponse = null;
    try {
      if (response == null) {
        tffa.Logger.debug('inside if response null');
        result = false;
      }
      String access_token = '';
      String token_type = '';
      objFISCCGetAccessTokenResponse = (FISCCGetAccessTokenResponse) response;
      access_token = objFISCCGetAccessTokenResponse.access_token;
      token_type = objFISCCGetAccessTokenResponse.token_type;
      authorization = token_type + ' ' + access_token;
      result = true;
    } catch (Exception ex) {
      tffa.Logger.error(
        'Exception in FISCCGetAccessTokenExtension isFISCCAPICallSuccess : ' +
        ex.getMessage() +
        ex.getLineNumber() +
        ex.getStackTraceString()
      );
      return false;
    }
    return result;
  }
}