public with sharing class CZWTFCMXReadMemberAccountService {
  @TestVisible
  private static boolean testException = false;

  public static CZWTFCMXReadMemberAccountRespDTO execute(Map<String, String> params) {
    CZWTFCMXReadMemberAccountRespDTO responseObj;
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      HttpResponse response;
      response = CZWTFCMXReadMemberAccountAdapter.execute(params);
      tffa.Logger.debug('Response :::' + response);
      if (response != null && String.isNotBlank(response.getBody())) {
        responseObj = parseResponse(response.getBody());
      }
    } catch (Exception ex) {
      tffa.Logger.debug('Exception :::' + ex.getMessage() + 'LineNumber :::' + ex.getLineNumber());
    }
    return responseObj;
  }

  public static CZWTFCMXReadMemberAccountRespDTO parseResponse(String reponseBody) {
    CZWTFCMXReadMemberAccountRespDTO responseDTO = (CZWTFCMXReadMemberAccountRespDTO) JSON.deserialize(
      reponseBody,
      CZWTFCMXReadMemberAccountRespDTO.class
    );
    return responseDTO;
  }
}