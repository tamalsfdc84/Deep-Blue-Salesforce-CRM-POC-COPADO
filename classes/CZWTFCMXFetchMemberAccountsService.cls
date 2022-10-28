public with sharing class CZWTFCMXFetchMemberAccountsService {
  @TestVisible
  private static boolean testException = false;

  public static CZWTFCMXFetchMemberAccountResponseDTO execute(Map<String, String> params) {
    CZWTFCMXFetchMemberAccountResponseDTO responseObj;
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      HttpResponse response;
      response = CZWTFCMXFetchMemberAccountsAdapter.execute(params);
      tffa.Logger.debug('Response :::' + response);
      if (response != null && String.isNotBlank(response.getBody())) {
        tffa.Logger.debug('Response Body :::' + response.getBody());
        responseObj = parseResponse(response.getBody());
        tffa.Logger.debug('After parseResponse' + responseObj);
      }
    } catch (Exception ex) {
      tffa.Logger.debug('Exception :::' + ex.getMessage() + 'LineNumber :::' + ex.getLineNumber());
    }
    return responseObj;
  }

  public static CZWTFCMXFetchMemberAccountResponseDTO parseResponse(String reponseBody) {
    CZWTFCMXFetchMemberAccountResponseDTO responseDTO = (CZWTFCMXFetchMemberAccountResponseDTO) JSON.deserialize(
      reponseBody,
      CZWTFCMXFetchMemberAccountResponseDTO.class
    );
    return responseDTO;
  }
}