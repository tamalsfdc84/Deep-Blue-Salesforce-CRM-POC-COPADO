public with sharing class CZWTFCMXGetAPITokenProvider {
  @TestVisible
  private static boolean testException = false;
  public static String getAPIToken(Map<String, String> reqParams) {
    try {
      String token = '';
      tffa.Logger.debug('inside MXGetAPITokenProvider');
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }

      Map<String, Object> responseMap = new Map<String, Object>();
      responseMap = CZWTFCMXGetAPITokenServiceProvider.invokeAPI(reqParams);
      if (responseMap != null && responseMap.get('Data') != null && String.valueOf(responseMap.get('Status')).equals('200')) {
        // Status 200 and success

        Map<String, Object> apiTokenResMap = (Map<String, Object>) responseMap.get('Data');
        if (apiTokenResMap.get('token') != null) {
          token = String.valueOf(apiTokenResMap.get('token'));
        }
      }
      CZWTFCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.GETAPITOKEN);
      return token;
    } catch (Exception e) {
      tffa.Logger.debug('Exception in MXGetAPITokenProvider : ' + e.getStackTraceString() + e.getMessage());
      CZWTFCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.GETAPITOKEN);
      return '';
    }
  }
}