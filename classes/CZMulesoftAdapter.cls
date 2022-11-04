public with sharing class CZMulesoftAdapter {
  public static String auth;

  public static CZMDMResponseBaseDTO invokeAPI(String requestBody, MuleSoft_Adapter_Config__mdt adapterConfig) {
    tffa.Logger.debug('In CZMulesoftAdapter.invokeAPI');
    Type responseType = null;
    HttpRequest req = new HttpRequest();
    Http h = new Http();
    HttpResponse res = new HttpResponse();
    tffa.Interaction.begin(CZMulesoftAdapter.class, adapterConfig.DeveloperName);
    try {
      req.setEndpoint(adapterConfig.EndPoint__c);
      req.setMethod(adapterConfig.Method__c);

      if (adapterConfig.Accept__c != null) {
        req.setHeader('accept', adapterConfig.Accept__c);
      }

      if (adapterConfig.ContentType__c != null) {
        req.setHeader('Content-Type', adapterConfig.ContentType__c);
      }

      if (adapterConfig.Timeout__c != null) {
        req.setTimeout(Integer.valueOf(adapterConfig.Timeout__c));
      }

      if (adapterConfig.VerificationScenario__c != null) {
        req.setHeader('wtfc-verify-scenario', adapterConfig.VerificationScenario__c);
      }

      if (adapterConfig.ProdCategory__c != null) {
        req.setHeader('wtfc-product-category', adapterConfig.ProdCategory__c);
      }

      if (adapterConfig.CorrelationId__c) {
        req.setHeader('X-Correlation-Id', CZWTFCCommonHelper.generateUUID());
      }

      if (requestBody != null) {
        tffa.Logger.debug('requestBody ' + requestBody);
        req.setBody(requestBody);
        if (!Test.isRunningTest() && adapterConfig.LogRequest__c) {
          if (adapterConfig.CorrelationId__c) {
            CZWTFCIntegrationLogService.setLogItemRequestAndResponse(
              'Correlation-Id: ' +
              req.getHeader('X-Correlation-Id') +
              +' ' +
              adapterConfig.EndPoint__c +
              ' ' +
              requestBody,
              null
            );
          } else {
            CZWTFCIntegrationLogService.setLogItemRequestAndResponse(requestBody, null);
          }
        }
      } else {
        if (!Test.isRunningTest() && adapterConfig.LogRequest__c) {
          if (adapterConfig.CorrelationId__c) {
            CZWTFCIntegrationLogService.setLogItemRequestAndResponse(
              'Correlation-Id: ' +
              req.getHeader('X-Correlation-Id') +
              +' ' +
              adapterConfig.EndPoint__c,
              null
            );
          } else {
            CZWTFCIntegrationLogService.setLogItemRequestAndResponse(requestBody, null);
          }
        }
      }
      if (!(adapterConfig.DeveloperName).equalsIgnoreCase('OAuth')) {
        req.setHeader('Authorization', auth);
      }
      res = h.send(req);
      tffa.Logger.debug('resp ' + res.getBody());
      if (!Test.isRunningTest() && adapterConfig.LogResponse__c) {
        CZWTFCIntegrationLogService.setLogItemRequestAndResponse(null, res.getBody());
      }
    } catch (Exception ex) {
      tffa.Logger.error('Error in CZMulesoftAdapter.invokeAPI ' + ex.getMessage() + ' ' + ex.getStackTraceString());
      if (!Test.isRunningTest() && adapterConfig.LogResponse__c) {
        CZWTFCIntegrationLogService.setLogItemRequestAndResponse(null, ex.getMessage());
      }
    } finally {
      tffa.Interaction.close();
    }
    if (String.valueOf(res.getStatusCode()).equalsIgnoreCase('200')) {
      if (!String.isBlank(adapterConfig.ResponseClass__c)) {
        responseType = Type.forName(adapterConfig.ResponseClass__c);
        CZMDMResponseBaseDTO resp = (CZMDMResponseBaseDTO) System.JSON.deserialize(res.getBody(), responseType);
        return resp;
      } else {
        return null;
      }
    }
    Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
    if (!String.isBlank(String.valueOf(jsonMap.get('error')))) {
      tffa.Logger.error('Error Response :' + jsonMap.get('error'));
      throw new tffa.ApplicationException(String.valueOf(jsonMap.get('error')));
    } else if (!String.isBlank(String.valueOf(jsonMap.get('errorMessage')))) {
      tffa.Logger.error('Error Response :' + jsonMap.get('errorMessage'));
      throw new tffa.ApplicationException(String.valueOf(jsonMap.get('errorMessage')));
    } else {
      tffa.Logger.debug(res.getStatusCode() + ' ' + res.getBody());
      throw new tffa.ApplicationException(res.getStatusCode() + ' ' + res.getBody());
    }
  }
}