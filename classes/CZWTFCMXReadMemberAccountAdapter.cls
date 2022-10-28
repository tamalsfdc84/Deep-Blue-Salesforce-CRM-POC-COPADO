public with sharing class CZWTFCMXReadMemberAccountAdapter {
  @TestVisible
  private static boolean testException = false;
  public static HttpResponse execute(Map<String, String> params) {
    HttpRequest req = new HttpRequest();
    HttpResponse response;
    try {
      // Read account - Nexus
      req.setTimeout(Integer.valueOf(CZWTFCMXServiceConfiguration.getMXConfig().Timeout__c)); // 120 sec waiting Time
      req.setHeader('Content-Type', CZWTFCMXServiceConfiguration.getMXConfig().ContentType__c);
      req.setHeader('Accept', CZWTFCMXServiceConfiguration.getMXConfig().Accept__c);
      req.setHeader('MD-SESSION-TOKEN', params.get('sessionToken'));
      String endpoint = CZWTFCMXServiceConfiguration.getMXConfig().EndPoint__c + '/accounts/' + params.get('accountGUID');
      if (CZWTFCMXServiceConfiguration.getMXConfig().LogRequest__c) {
        CZWTFCIntegrationLogService.setLogItemRequestAndResponse(endpoint, null);
      }
      req.setEndpoint(endpoint); //https://int-data.moneydesktop.com/accounts/:account_guid
      req.setMethod('GET');
      tffa.Logger.debug('Read account number Request : ' + req + 'body ' + req.getBody());
      Http http = new Http();
      response = http.send(req);
      if (CZWTFCMXServiceConfiguration.getMXConfig().LogResponse__c) {
        CZWTFCIntegrationLogService.setLogItemRequestAndResponse(null, response.getBody());
      }
      tffa.Logger.debug('Read account number response : ' + response + 'body ' + response.getBody());
    } catch (Exception ex) {
      tffa.Logger.debug('Exception :::' + ex.getMessage() + 'LineNumber :::' + ex.getLineNumber());
    }
    return response;
  }
}