public with sharing class CZWTFCMXSSOAPIService {
  @TestVisible
  private static boolean testException = false;
  public static String generateRequestBody(Map<String, String> params) {
    HttpRequest req = new HttpRequest();
    String body;
    if (params.containsKey('microDepositGUID')) {
      body =
        '{"url":{"type":"connect_widget","is_mobile_webview":false,"mode":"verification","wait_for_full_aggregation":true,"ui_message_version":4,"current_microdeposit_guid":"' +
        params.get('microDepositGUID') +
        '"}}';
    } else {
      body = '{"url":{"type":"connect_widget","is_mobile_webview":false,"mode":"verification","wait_for_full_aggregation":true,"ui_message_version":4}}';
    }

    req.setBody(body);
    return req.getBody();
  }

  public static String buildRequest(Map<String, String> params) {
    String body = CZWTFCMXSSOAPIService.generateRequestBody(params);
    return body;
  }

  public static Map<String, Object> execute(Map<String, String> params) {
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      String requestBody = buildRequest(params);

      HttpResponse response;

      if (String.isNotBlank(requestBody)) {
        response = CZWTFCMXSSOAPIAdapter.execute(requestBody, String.valueOf(params.get('userId')));
        if (response != null && String.isNotBlank(response.getBody())) {
          Map<String, Object> responseObj = parseResponse(response.getBody());

          return responseObj;
        } else {
          return (new Map<String, object>{ 'Status' => '400', 'StatusMessage' => 'API call Failed', 'Data' => '' });
        }
      } else {
        // Request body is empty
        return (new Map<String, object>{ 'Status' => '400', 'StatusMessage' => 'Empty Request Body', 'Data' => '' });
      }
    } catch (Exception ex) {
      return (new Map<String, object>{ 'Status' => '400', 'StatusMessage' => ex.getMessage() });
    }
  }

  public static Map<String, Object> parseResponse(String reponseBody) {
    Map<string, object> result = new Map<String, Object>();
    object reponseBodyObj = (new CZWTFCXMLSerializer()).deSerializeUnTyped(reponseBody);

    String jsonString = reponseBodyObj != null ? system.JSON.serialize(reponseBodyObj) : '';

    Map<String, Object> mapObject = reponseBodyObj != null ? (Map<String, Object>) reponseBodyObj : null;
    Map<String, Object> ssoAPIResponse = mapObject != null ? (Map<String, Object>) mapObject.get('url') : null;
    Map<String, Object> fault = mapObject != null ? (Map<String, Object>) mapObject.get('Fault') : null;

    if (ssoAPIResponse != null) {
      result.put('Data', (Object) CZWTFCMXSSOAPIHelper.onSuccess(ssoAPIResponse));
      result.put('Status', '200');
    } else if (fault != null) {
      result.put('Data', (Object) CZWTFCMXSSOAPIHelper.onError(fault));
      result.put('Status', '400');
    }
    return result;
  }
}