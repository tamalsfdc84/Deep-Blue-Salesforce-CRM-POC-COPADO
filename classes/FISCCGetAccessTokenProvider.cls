public inherited sharing class FISCCGetAccessTokenProvider {
  public static String processGetAccessToken(FISCC_Charter_Config__mdt charterConfig) {
    Boolean success;
    String custAddKey = null;
    Boolean isAPICallFailed = false;
    String authorization = '';
    try {
      String strAPiName = 'AccessToken';

      FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig(strAPiName);

      tffa.Logger.debug('adapterConfig ==>' + adapterConfig);

      authorization = FISCCGetAccessTokenExtension.getAccessToken(adapterConfig, charterConfig);
      tffa.Logger.debug('authorization => in provider ==>' + authorization);
      tffa.Logger.debug('extension called');

      if (isAPICallFailed != null && isAPICallFailed) {
        throw new tffa.ApplicationException('Party details validation failed ....!!!');
      }
    } catch (Exception ex) {
      tffa.logger.error('Exception in FISCCGetAccessTokenProvider ' + ex.getMessage() + ' ' + ex.getStackTraceString());
    }
    return authorization;
  }
}