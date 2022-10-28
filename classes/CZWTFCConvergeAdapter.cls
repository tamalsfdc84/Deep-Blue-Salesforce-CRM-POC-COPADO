public with sharing class CZWTFCConvergeAdapter {
  @TestVisible
  private static boolean testException = false;
  public static HttpResponse execute(CZConvergeConfiguration__mdt convergeConfig, Map<String, Object> params, String requestBody) {
    HttpRequest req = new HttpRequest();
    HttpResponse response;
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      req.setMethod(convergeConfig.Method__c);
      req.setEndpoint(convergeConfig.EndPoint__c);
      req.setTimeout(Integer.valueOf(convergeConfig.RequestTimeout__c));

      if (String.isNotBlank(requestBody)) {
        req.setBody(requestBody);
      }

      if (convergeConfig.LogRequest__c) {
        CZWTFCIntegrationLogService.setLogItemRequestAndResponse('Endpoint: ' + req.getEndpoint() + ' Request: ' + requestBody, null);
      }

      Http http = new Http();
      tffa.Logger.debug('Endpoint ' + convergeConfig.EndPoint__c);
      response = http.send(req);
      if (convergeConfig.LogResponse__c) {
        CZWTFCIntegrationLogService.setLogItemRequestAndResponse(null, response.getBody());
      }
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in execute :::' + ex.getMessage() + 'LineNumber :::' + ex.getLineNumber());
    }
    tffa.Logger.debug('Response ' + response);
    return response;
  }
}