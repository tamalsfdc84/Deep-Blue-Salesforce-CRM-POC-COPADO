public inherited sharing class FISCCHostAdapter {
  @TestVisible
  private static boolean testException = false;
  public static Object processHostRequest(
    FISCCRequestBaseDTO request,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    try {
      String requestStr = null;
      String responseStr = null;
      HttpResponse hostResponse = null;
      FISCCTransactionResponseBaseDTO outResponse = null;
      String responseBuilderclassName = null;
      Type responseBuilderType = null;
      FISCCHostResponseBuilder fisccHostResponseBuilder = null;
      Object result = null;
      requestStr = System.JSON.serialize(request, true);
      for (String strMapKey : FISCCIntegrationConstants.mapOfHyphenValues.keySet()) {
        if (requestStr.contains(strMapKey)) {
          requestStr = requestStr.replace(strMapKey, FISCCIntegrationConstants.mapOfHyphenValues.get(strMapKey));
        }
      }
      if (adapterConfig != null && charterConfig != null) {
        if (('DSS').equals(FISCCIntegrationLogService.applicationCode)) {
          hostResponse = FISCCDSSAPICall.execute(requestStr, adapterConfig, charterConfig);
        } else {
          hostResponse = FISCCCoreAPICall.execute(requestStr, adapterConfig, charterConfig);
        }

        if (adapterConfig.DeveloperName.equalsIgnoreCase('UploadFCMDocument')) {
          return hostResponse.getStatus();
        }

        if (adapterConfig.DeveloperName.equalsIgnoreCase('GetAccountDetails')) {
          return hostResponse;
        }

        FISCCIntegrationConstants.ErrorMessage = '';

        if (hostResponse != null && !String.isBlank(hostResponse.getBody())) {
          responseStr = hostResponse.getBody();
          if (adapterConfig.LogResponse__c) {
            FISCCIntegrationLogService.setLogItemRequestAndResponse(null, responseStr);
          }

          if (adapterConfig.DeveloperName.equalsIgnoreCase('AuthorizationToken')) {
            return responseStr;
          }

          responseBuilderclassName = adapterConfig.ResponseBuilderClass__c;

          if (!String.isBlank(responseBuilderclassName)) {
            responseBuilderType = Type.forName(responseBuilderclassName);
            fisccHostResponseBuilder = (FISCCHostResponseBuilder) responseBuilderType.newInstance();
            outResponse = fisccHostResponseBuilder.build(responseStr, adapterConfig, charterConfig);
            tffa.logger.debug('outResponse == >' + outResponse);
            if (outResponse != null) {
              String code;
              result = fisccHostResponseBuilder.parseResponse(outResponse, adapterConfig, charterConfig);
              if (
                !responseBuilderclassName.equalsIgnoreCase('FISIDAResponseBuilder') &&
                !responseBuilderclassName.equalsIgnoreCase('FISIDVResponseBuilder') &&
                !responseBuilderclassName.equalsIgnoreCase('FISCCGetAccessTokenResponseBuilder') &&
                !responseBuilderclassName.equalsIgnoreCase('FCMGenerateDocIdResponseBuilder') &&
                !responseBuilderclassName.equalsIgnoreCase('FISCCDollarTransResponseBuilder') &&
                !responseBuilderclassName.equalsIgnoreCase('FISCCImmediateTransResponseBuilder') &&
                (outResponse.Metadata.MsgLst[0].Severity).equalsIgnoreCase('Error')
              ) {
                for (FISCCMsgListDTO msg : outResponse.Metadata.MsgLst) {
                  if (
                    msg.text != null &&
                    !msg.text.contains('previous function error') &&
                    !msg.text.contains('null') &&
                    (msg.Severity).equalsIgnoreCase('Error')
                  ) {
                    FISCCIntegrationConstants.ErrorMessage = FISCCIntegrationConstants.ErrorMessage + '   ' + msg.text;
                    code = code + '  ' + msg.code;
                    tffa.logger.debug(' FISCCIntegrationConstants.ErrorMessage ==> ' + FISCCIntegrationConstants.ErrorMessage);
                  }
                }
                result = new Map<String, object>{ 'Status' => code, 'StatusMessage' => FISCCIntegrationConstants.ErrorMessage };
              }
            } else {
              FISCCIntegrationConstants.ErrorMessage = 'Host Response deserialization failed.';
              return (new Map<String, object>{ 'Status' => '400', 'StatusMessage' => 'Host Response deserialization failed.' });
            }
          } else {
            FISCCIntegrationConstants.ErrorMessage = 'Invalid FISCC configuration.';
            return (new Map<String, object>{ 'Status' => '400', 'StatusMessage' => 'Invalid FISCC configuration.' });
          }
        } else {
          FISCCIntegrationConstants.ErrorMessage = 'Invalid FISCC API Response.';
          return (new Map<String, object>{ 'Status' => '400', 'StatusMessage' => 'Invalid FISCC API Response.' });
        }
      } else {
        FISCCIntegrationConstants.ErrorMessage = 'Host API Request generation failed..!!';
        return (new Map<String, object>{ 'Status' => '400', 'StatusMessage' => 'Host API Request generation failed..!!' });
      }
      return result;
    } catch (Exception ex) {
      tffa.logger.error(' Exception into processHostRequest  :::' + ex.getMessage() + ' Exception:::' + ex.getStackTraceString());
      return (new Map<String, object>{ 'Status' => '400', 'StatusMessage' => ex.getMessage() });
    }
  }
}