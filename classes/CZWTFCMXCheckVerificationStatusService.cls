public with sharing class CZWTFCMXCheckVerificationStatusService {
  @TestVisible
  private static boolean testException = false;

  public static CZWTFCMXCheckVerificationStatusRespDTO execute(Map<String, String> params) {
    CZWTFCMXCheckVerificationStatusRespDTO responseObj;
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      HttpResponse response;
      response = CZWTFCMXCheckVerificationStatusAdapter.execute(params);
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

  public static CZWTFCMXCheckVerificationStatusRespDTO parseResponse(String reponseBody) {
    CZWTFCMXCheckVerificationStatusRespDTO responseDTO = (CZWTFCMXCheckVerificationStatusRespDTO) JSON.deserialize(
      reponseBody,
      CZWTFCMXCheckVerificationStatusRespDTO.class
    );
    return responseDTO;
  }
}