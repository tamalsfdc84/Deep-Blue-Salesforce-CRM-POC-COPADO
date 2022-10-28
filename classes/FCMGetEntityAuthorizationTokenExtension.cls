public inherited sharing class FCMGetEntityAuthorizationTokenExtension {
  public static String authorization = '';
  public static String getAuthorizationToken(FISCC_Adapter_Configs__mdt adapterConfig, FISCC_Charter_Config__mdt charterConfig) {
    FISCCRequestBaseDTO fisccRequestBaseDTO = null;
    Object result = null;
    try {
      fisccRequestBaseDTO = createGetAccessTokenRequest(adapterConfig, charterConfig);
      result = FISCCHostAdapter.processHostRequest(fisccRequestBaseDTO, adapterConfig, charterConfig);

      if(result != null){
        authorization = String.valueOf(result);
        authorization = authorization.replace('"', '');

        if(authorization.contains('fault') || authorization.contains('400') || authorization.contains('500') || authorization.contains('401')){
          authorization ='';
        }
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
        
    fisccRequestBaseDTO = new FISCCGetAccessTokenDTO();
    return fisccRequestBaseDTO;
  }
}