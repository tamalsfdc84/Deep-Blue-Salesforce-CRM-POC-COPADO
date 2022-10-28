public with sharing class CZWTFCMXGetAPITokenAdapter {
  @TestVisible
  private static boolean testException = false;
  public static HttpResponse execute(Map<String, String> params) {
    HttpRequest req = new HttpRequest();
    HttpResponse response;
    try {
      //Get an API token - Verify
      req.setTimeout(Integer.valueOf(CZWTFCMXServiceConfiguration.getMXConfig().Timeout__c)); // 120 sec waiting Time
      req.setHeader('Accept', CZWTFCMXServiceConfiguration.getMXConfig().Accept__c);
      req.setHeader('MD-API-KEY', CZWTFCMXServiceConfiguration.getMXConfig().APIKey__c);
      String endpoint =
        CZWTFCMXServiceConfiguration.getMXConfig().EndPoint__c +
        '/' +
        CZWTFCMXServiceConfiguration.getMXConfig().ClientId__c +
        '/users/' +
        params.get('userId') +
        '/api_token.xml';
      if (CZWTFCMXServiceConfiguration.getMXConfig().LogRequest__c) {
        CZWTFCIntegrationLogService.setLogItemRequestAndResponse(endpoint, null);
      }
      req.setEndpoint(endpoint); // https://int-sso.moneydesktop.com/:client_id/users/:user_id/api_token.xml
      req.setMethod('GET');
      tffa.Logger.debug('Get token Request : ' + req + 'body ' + req.getBody());
      Http http = new Http();
      response = http.send(req);
      if (CZWTFCMXServiceConfiguration.getMXConfig().LogResponse__c) {
        CZWTFCIntegrationLogService.setLogItemRequestAndResponse(null, response.getBody());
      }
      tffa.Logger.debug('Get token Request : ' + response + 'body ' + response.getBody());
    } catch (Exception ex) {
      tffa.Logger.debug('Exception :::' + ex.getMessage() + 'LineNumber :::' + ex.getLineNumber());
    }
    return response;
  }
}