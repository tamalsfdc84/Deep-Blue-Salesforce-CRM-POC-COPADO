public with sharing class CZWTFCMXCheckVerificationStatusAdapter {
  @TestVisible
  private static boolean testException = false;
  public static HttpResponse execute(Map<String, String> params) {
    if (Test.isRunningTest() && testException) {
      throw new tffa.ApplicationException('Called through test class');
    }

    HttpRequest req = new HttpRequest();
    HttpResponse response;
    try {
      // Check verification status - verify
      req.setTimeout(Integer.valueOf(CZWTFCMXServiceConfiguration.getMXConfig().Timeout__c)); // 120 sec waiting Time
      req.setHeader('Content-Type', CZWTFCMXServiceConfiguration.getMXConfig().ContentType__c);
      req.setHeader('Accept', CZWTFCMXServiceConfiguration.getMXConfig().Accept__c);
      req.setHeader('MD-SESSION-TOKEN', params.get('sessionToken'));
      String endpoint = CZWTFCMXServiceConfiguration.getMXConfig().EndPoint__c + '/members/' + params.get('memberGUID');
      if (CZWTFCMXServiceConfiguration.getMXConfig().LogRequest__c) {
        CZWTFCIntegrationLogService.setLogItemRequestAndResponse(endpoint, null);
      }
      req.setEndpoint(endpoint); //https://int-data.moneydesktop.com/members/:member_guid
      req.setMethod('GET');
      tffa.Logger.debug('Check verification status req :' + req);
      Http http = new Http();
      response = http.send(req);
      if (CZWTFCMXServiceConfiguration.getMXConfig().LogResponse__c) {
        CZWTFCIntegrationLogService.setLogItemRequestAndResponse(null, response.getBody());
      }
    } catch (Exception ex) {
      tffa.Logger.debug('Exception :::' + ex.getMessage() + 'LineNumber :::' + ex.getLineNumber());
    }
    return response;
  }
}