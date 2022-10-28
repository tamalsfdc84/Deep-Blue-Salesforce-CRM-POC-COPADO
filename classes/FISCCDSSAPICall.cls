public with sharing class FISCCDSSAPICall {
  public static HttpResponse execute(String requestBody, FISCC_Adapter_Configs__mdt adptrConfig, FISCC_Charter_Config__mdt charterConfig) {
    tffa.logger.debug('Inside FISCCDSSAPICall');
    HttpRequest httpRequest = null;
    HttpResponse httpResponse = null;
    Http http = new Http();
    tffa.Interaction.begin(FISCCDSSAPICall.class,'execute');
    try {
      httpRequest = new HttpRequest();
      string postData = '';

      httpRequest.setHeader('content-Type', adptrConfig.ContentType__c);
      tffa.logger.debug('content in else==>' + httpRequest.getHeader('content-Type'));
      httpRequest.setMethod(adptrConfig.HTTPMethod__c);
      tffa.logger.debug('HTTPMethod__c in else ==>' + adptrConfig.HTTPMethod__c);
      httpRequest.setTimeout(Integer.valueOf(adptrConfig.Timeout__c));

      httpRequest.setEndpoint(charterConfig.EndpointURLDSS__c + adptrConfig.ServiceURL__c);

      if (adptrConfig.LogRequest__c) {
        FISCCIntegrationLogService.setLogItemRequestAndResponse(
          'Endpoint: ' +
          httpRequest.getEndpoint() +
          ' Request: ' +
          requestBody,
          null
        );
      }

      httpRequest.setHeader('application-id', adptrConfig.ApplicationId__c);

      httpRequest.setHeader('security-token-type', charterConfig.SecurityTokenTypeDSS__c);

      tffa.logger.debug('security-token-type : ' + httpRequest.getHeader('security-token-type'));

      httpRequest.setHeader('Accept', '*/*');
      tffa.logger.debug('organizationID : ' + httpRequest.getHeader('organization-id'));

      httpRequest.setHeader('uuid', CZWTFCCommonHelper.generateUUID());

      tffa.logger.debug('uuid : ' + httpRequest.getHeader('uuid'));

      httpRequest.setHeader('source-id', charterConfig.SourceIdDSS__c);

      tffa.logger.debug('sourceid :' + httpRequest.getHeader('source-id'));
      tffa.logger.debug('requestBody ==> ' + requestBody);
      tffa.logger.debug('httpRequest ==> ' + httpRequest);

      httpRequest.setBody(requestBody);

      httpResponse = http.send(httpRequest);
      tffa.logger.debug('httpResponse in coreApiCall =>' + httpResponse);
      if (httpResponse != null) {
        tffa.logger.debug('httpResponse body in coreApiCall =>' + httpResponse.getBody());
      }
    } catch (Exception ex) {
      tffa.logger.error('Exception :::' + ex.getMessage() + ' LineNumber :::' + ex.getStackTraceString());
    } finally{
      tffa.Interaction.close();
    }
    return httpResponse;
  }
}