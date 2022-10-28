public with sharing class CZWTFCMXOpenNexusService {
  @TestVisible
  private static boolean testException = false;
  public static String generateRequestBody() {
    HttpRequest req = new HttpRequest();
    String body = '{"session":{"skip_aggregation":true}}';
    req.setBody(body);
    return req.getBody();
  }

  public static String buildRequest() {
    String body = CZWTFCMXOpenNexusService.generateRequestBody();
    return body;
  }

  public static CZWTFCMXOpenNexusResponseDTO execute(Map<String, String> params) {
    CZWTFCMXOpenNexusResponseDTO responseObj;
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      String requestBody = buildRequest();
      tffa.Logger.debug('Request Body :::' + requestBody);
      HttpResponse response;
      response = CZWTFCMXOpenNexusAdapter.execute(params, requestBody);
      tffa.Logger.debug('Response :::' + response);
      if (response != null && String.isNotBlank(response.getBody())) {
        tffa.Logger.debug('Response Body :::' + response.getBody());
        responseObj = parseResponse(response.getBody());
        tffa.Logger.debug('After parseResponse');
      }
    } catch (Exception ex) {
      tffa.Logger.debug('Exception :::' + ex.getMessage() + 'LineNumber :::' + ex.getLineNumber());
    }
    return responseObj;
  }

  public static CZWTFCMXOpenNexusResponseDTO parseResponse(String reponseBody) {
    CZWTFCMXOpenNexusResponseDTO responseDTO = (CZWTFCMXOpenNexusResponseDTO) JSON.deserialize(
      reponseBody,
      CZWTFCMXOpenNexusResponseDTO.class
    );
    return responseDTO;
  }
}