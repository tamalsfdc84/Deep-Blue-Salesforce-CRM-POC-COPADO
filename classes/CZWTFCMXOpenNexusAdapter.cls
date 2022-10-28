public with sharing class CZWTFCMXOpenNexusAdapter {
  @TestVisible
  private static boolean testException = false;
  public static HttpResponse execute(Map<String, String> params, String requestBody) {
    if (Test.isRunningTest() && testException) {
      throw new tffa.ApplicationException('Called through test class');
    }
    HttpRequest req = new HttpRequest();
    HttpResponse response;
    try {
      if (CZWTFCMXServiceConfiguration.getMXConfig().LogRequest__c) {
        CZWTFCIntegrationLogService.setLogItemRequestAndResponse(requestBody, null);
      }
      //Get an API token - Verify
      req.setTimeout(Integer.valueOf(CZWTFCMXServiceConfiguration.getMXConfig().Timeout__c)); // 120 sec waiting Time
      req.setHeader('Content-Type', CZWTFCMXServiceConfiguration.getMXConfig().ContentType__c);
      req.setHeader('Accept', CZWTFCMXServiceConfiguration.getMXConfig().Accept__c);
      req.setHeader('MD-API-TOKEN', params.get('apiToken'));
      String endpoint = CZWTFCMXServiceConfiguration.getMXConfig().EndPoint__c + '/sessions';
      req.setEndpoint(endpoint); // https://int-data.moneydesktop.com/sessions
      req.setMethod('POST');
      req.setBody(requestBody);
      tffa.Logger.debug('open nexus Request : ' + req + 'body ' + req.getBody());

      Http http = new Http();
      response = http.send(req);
      if (CZWTFCMXServiceConfiguration.getMXConfig().LogResponse__c) {
        CZWTFCIntegrationLogService.setLogItemRequestAndResponse(null, response.getBody());
      }
      tffa.Logger.debug('open nexus response : ' + response + 'body ' + response.getBody());
    } catch (Exception ex) {
      tffa.Logger.debug('Exception :::' + ex.getMessage() + 'LineNumber :::' + ex.getLineNumber());
    }
    return response;
  }
}