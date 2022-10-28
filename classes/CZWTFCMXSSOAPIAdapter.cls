public with sharing class CZWTFCMXSSOAPIAdapter {
  @TestVisible
  private static boolean testException = false;
  public static HttpResponse execute(String requestBody, String generatedUserId) {
    if (Test.isRunningTest() && testException) {
      throw new tffa.ApplicationException('Called through test class');
    }

    HttpRequest req = new HttpRequest();
    HttpResponse response;
    try {
      if (CZWTFCMXServiceConfiguration.getMXConfig().LogRequest__c) {
        CZWTFCIntegrationLogService.setLogItemRequestAndResponse(requestBody, null);
      }
      req.setTimeout(Integer.valueOf(CZWTFCMXServiceConfiguration.getMXConfig().Timeout__c)); // 120 sec waiting Time
      req.setHeader('Content-Type', CZWTFCMXServiceConfiguration.getMXConfig().ContentType__c);
      req.setHeader('Accept', CZWTFCMXServiceConfiguration.getMXConfig().Accept__c);
      req.setHeader('MD-API-KEY', CZWTFCMXServiceConfiguration.getMXConfig().APIKey__c);
      String endpoint =
        CZWTFCMXServiceConfiguration.getMXConfig().EndPoint__c +
        '/' +
        CZWTFCMXServiceConfiguration.getMXConfig().ClientId__c +
        '/users/' +
        generatedUserId +
        '/urls.xml';
      req.setEndpoint(endpoint);
      req.setMethod('POST');
      req.setbody(requestBody);
      tffa.Logger.debug('SSO API Request : ' + req + 'body ' + req.getBody());
      Http http = new Http();
      response = http.send(req);
      if (CZWTFCMXServiceConfiguration.getMXConfig().LogResponse__c) {
        CZWTFCIntegrationLogService.setLogItemRequestAndResponse(null, response.getBody());
      }
      tffa.Logger.debug('SSO API response : ' + response + 'body ' + response.getBody());
    } catch (Exception ex) {
      tffa.Logger.debug('Exception :::' + ex.getMessage() + 'LineNumber :::' + ex.getLineNumber());
    }
    return response;
  }
}