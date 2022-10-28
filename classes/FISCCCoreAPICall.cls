public inherited sharing class FISCCCoreAPICall {
  public static HttpResponse execute(String requestBody, FISCC_Adapter_Configs__mdt adptrConfig, FISCC_Charter_Config__mdt charterConfig) {
    HttpRequest httpRequest = null;
    HttpResponse httpResponse = null;
    Http http = new Http();
    tffa.Interaction.begin(FISCCCoreAPICall.class, adptrConfig.DeveloperName);
    try {
      httpRequest = new HttpRequest();
      string postData = '';
      string auth = '';
      if (adptrConfig.DeveloperName.equalsIgnoreCase('AccessToken')) {
        if (adptrConfig.LogRequest__c) {
          FISCCIntegrationLogService.setLogItemRequestAndResponse(requestBody, null);
        }
        if (('CB').equals(FISCCIntegrationLogService.applicationCode)) {
          httpRequest.setEndpoint(charterConfig.EndpointUrlCBAuth__c + adptrConfig.ServiceURL__c);
        } else if (('FCM').equals(FISCCIntegrationLogService.applicationCode)) {
          httpRequest.setEndpoint(charterConfig.EndpointUrlFCM__c + adptrConfig.ServiceURL__c);
        } else {
          httpRequest.setEndpoint(charterConfig.EndpointUrl__c + adptrConfig.ServiceURL__c);
        }

        Blob headerValue = Blob.valueOf(charterConfig.ConsumerKey__c + ':' + charterConfig.ConsumerSecret__c);
        if (('FCM').equals(FISCCIntegrationLogService.applicationCode)) {
          headerValue = Blob.valueOf(charterConfig.FCMConsumerKey__c + ':' + charterConfig.FCMConsumerSecret__c);
        }
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        httpRequest.setHeader('Authorization', authorizationHeader);

        // commented and added by Rishi to handle CEB/CB integration dummy host
        httpRequest.setMethod(adptrConfig.HTTPMethod__c);
        httpRequest.setHeader('content-Type', adptrConfig.ContentType__c);
        postData = requestBody.substringAfter('"postData":"').substringBefore('"');
        tffa.logger.debug('postData ==>' + postData);
        httpRequest.setBody(postData);
      } else {
        if (('FCM').equals(FISCCIntegrationLogService.applicationCode)) {
          if (adptrConfig.DeveloperName.equalsIgnoreCase('AuthorizationToken')) {
            httpRequest.setHeader('entityToken', 'Basic ' + charterConfig.FCMEntityToken__c);
          } else {
            httpRequest.setHeader('entityToken', 'Bearer ' + FISCCIntegrationLogService.entityAuthToken);
          }
        }
        httpRequest.setHeader('content-Type', adptrConfig.ContentType__c);
        httpRequest.setMethod(adptrConfig.HTTPMethod__c);
        httpRequest.setTimeout(Integer.valueOf(adptrConfig.Timeout__c)); // 20 sec waiting Time
        // commented and added by Rishi to handle CEB integration dummy host
        //httpRequest.setEndpoint(charterConfig.ServiceURL__c + adptrConfig.ServiceURL__c);
        if (('CEB').equals(FISCCIntegrationLogService.applicationCode)) {
          httpRequest.setEndpoint(charterConfig.EndpointUrlCEB__c + adptrConfig.ServiceURL__c);
        } else if (('CB').equals(FISCCIntegrationLogService.applicationCode)) {
          httpRequest.setEndpoint(charterConfig.EndpointUrlCB__c + adptrConfig.ServiceURL__c);
        } else if (('FCM').equals(FISCCIntegrationLogService.applicationCode)) {
          httpRequest.setEndpoint(charterConfig.EndpointUrlFCM__c + adptrConfig.ServiceURL__c);
        } else {
          httpRequest.setEndpoint(charterConfig.EndpointUrl__c + adptrConfig.ServiceURL__c);
        }

        httpRequest.setHeader('uuid', CZWTFCCommonHelper.generateUUID());
        tffa.logger.debug('uuid ==>' + httpRequest.getHeader('uuid'));

        if (adptrConfig.LogRequest__c) {
          FISCCIntegrationLogService.setLogItemRequestAndResponse(
            'Endpoint: ' +
            httpRequest.getEndpoint() +
            'UUID ' +
            httpRequest.getHeader('uuid') +
            ' Request: ' +
            requestBody,
            null
          );
        }

        httpRequest.setHeader('application-id', adptrConfig.ApplicationId__c);
        httpRequest.setHeader('security-token-type', 'Oauth2');
        httpRequest.setHeader('organization-id', charterConfig.OrganizationId__c);
        httpRequest.setHeader('Accept', '*/*');

        httpRequest.setHeader('source-id', charterConfig.SourceId__c);

        httpRequest.setHeader('security-token-type', 'Oauth2');

        if (adptrConfig.IsIBSAuthRequired__c) {
          if (adptrConfig.IsEncrypted__c)
            httpRequest.setHeader('IBS-Authorization', FISCCCommonHelper.encrypt(charterConfig.IBSAuthorization__c));
          else
            httpRequest.setHeader('IBS-Authorization', charterConfig.IBSAuthorization__c);
        }
        if (adptrConfig.IsEncrypted__c) {
          httpRequest.setHeader('fis-ic-enc-x5ts256', charterConfig.FISIcEncX5ts256__c);
          httpRequest.setHeader('fis-ic-enc-sk', charterConfig.FISIcEncSk1__c + charterConfig.FISIcEncSk2__c);
        }
        httpRequest.setHeader('Authorization', FISCCIntegrationLogService.auth);
        tffa.logger.debug('Header Values ==>' + httpRequest.getHeader('Authorization'));

        if (adptrConfig.DeveloperName.equalsIgnoreCase('UploadFCMDocument')) {
          if (FISCCIntegrationLogService.contentVersionData != null) {
            tffa.logger.debug('FISCCCoreAPICall - Setting ContentVersionData in request body');
            httpRequest.setBodyAsBlob(FISCCIntegrationLogService.contentVersionData);
          }
        } else if (String.isNotBlank(requestBody) && !adptrConfig.HTTPMethod__c.equalsIgnoreCase('GET')) {
          httpRequest.setBody(requestBody);
        }
      }

      tffa.logger.debug('httpRequest3 ==> ' + httpRequest);
      httpResponse = http.send(httpRequest);
      tffa.logger.debug('httpResponse in coreApiCall =>' + httpResponse);
      if (httpResponse != null) {
        tffa.logger.debug('httpResponse body in coreApiCall =>' + httpResponse.getBody());
      }
    } catch (Exception ex) {
      tffa.logger.error('Exception :::' + ex.getMessage() + ' LineNumber :::' + ex.getStackTraceString());
    } finally {
      tffa.Interaction.close();
    }
    return httpResponse;
  }
}