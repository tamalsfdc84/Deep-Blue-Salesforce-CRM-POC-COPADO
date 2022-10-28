public with sharing class CZWTFCMXGetAPITokenService {
  @TestVisible
  private static boolean testException = false;

  public static Map<String, Object> execute(Map<String, String> params) {
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }

      HttpResponse response;
      response = CZWTFCMXGetAPITokenAdapter.execute(params);
      tffa.Logger.debug('Response :::' + response);
      if (response != null && String.isNotBlank(response.getBody())) {
        tffa.Logger.debug('Response Body :::' + response.getBody());
        Map<String, Object> responseObj = parseResponse(response.getBody());

        return responseObj;
      } else {
        return (new Map<String, object>{ 'Status' => '400', 'StatusMessage' => 'API call Failed', 'Data' => '' });
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

    Map<String, Object> getTokenResponse = mapObject != null ? (Map<String, Object>) mapObject.get('api_token') : null;
    Map<String, Object> fault = mapObject != null ? (Map<String, Object>) mapObject.get('Fault') : null;

    if (getTokenResponse != null) {
      result.put('Data', (Object) CZWTFCMXGetAPITokenHelper.onSuccess(getTokenResponse));
      result.put('Status', '200');
    } else if (fault != null) {
      result.put('Data', (Object) CZWTFCMXGetAPITokenHelper.onError(fault));
      result.put('Status', '400');
    }

    return result;
  }
}