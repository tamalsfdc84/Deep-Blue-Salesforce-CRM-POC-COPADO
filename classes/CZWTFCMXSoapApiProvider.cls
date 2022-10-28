public with sharing class CZWTFCMXSoapApiProvider {
  @TestVisible
  private static boolean testException = false;
  public static String generateURL(String generatedUserId, Map<String, String> params) {
    try {
      String url = '';
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      Map<String, Object> responseMap = new Map<String, Object>();
      Map<String, String> reqParams = new Map<String, String>();
      if (params.containsKey('microDepositGUID')) {
        reqParams.put('microDepositGUID', params.get('microDepositGUID'));
      }
      reqParams.put('userId', generatedUserId);
      responseMap = CZWTFCMXSSOAPIServiceProvider.invokeAPI(reqParams);
      if (responseMap != null && responseMap.get('Data') != null && String.valueOf(responseMap.get('Status')).equals('200')) {
        // Status 200 and success
        Map<String, Object> ssoApiResMap = (Map<String, Object>) responseMap.get('Data');
        if (ssoApiResMap.get('url') != null) {
          url = String.valueOf(ssoApiResMap.get('url'));
        }
      }
      CZWTFCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.GENERATEURL);
      return url;
    } catch (Exception e) {
      CZWTFCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.GENERATEURL);
      tffa.Logger.debug('Exception :::' + e.getMessage() + 'LineNumber :::' + e.getLineNumber());
      return '';
    }
  }
}