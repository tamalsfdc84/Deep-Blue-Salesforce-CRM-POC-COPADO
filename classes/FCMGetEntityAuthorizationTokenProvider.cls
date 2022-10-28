public inherited sharing class FCMGetEntityAuthorizationTokenProvider {
  public static String processGetAuthorizationTokenToken(FISCC_Charter_Config__mdt charterConfig) {
    String authorization = '';
    try {
      String strAPiName = 'AuthorizationToken';

      FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig(strAPiName);
      adapterConfig.ServiceURL__c = adapterConfig.ServiceURL__c.replace('{EntityID}', charterConfig.FCMEntityId__c );

      authorization = FCMGetEntityAuthorizationTokenExtension.getAuthorizationToken(adapterConfig, charterConfig);

    } catch (Exception ex) {
      tffa.logger.error('Exception in FISCCGetAccessTokenProvider ' + ex.getMessage() + ' ' + ex.getStackTraceString());
    }
    return authorization;
  }
}