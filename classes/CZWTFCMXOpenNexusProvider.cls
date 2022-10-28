public with sharing class CZWTFCMXOpenNexusProvider {
  @TestVisible
  private static boolean testException = false;
  public static String getSessionToken(String generatedToken) {
    try {
      tffa.Logger.debug('inside MXOpenNexusProvider');
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      Map<String, String> reqParams = new Map<String, String>();
      reqParams.put('apiToken', generatedToken);
      CZWTFCMXOpenNexusResponseDTO responseDTO = CZWTFCMXOpenNexusServiceProvider.invokeAPI(reqParams);
      tffa.Logger.debug('Response DTO : ' + responseDTO);

      CZWTFCMXOpenNexusResponseDTO.Session session = new CZWTFCMXOpenNexusResponseDTO.Session();
      if (responseDTO.session != null) {
        session = responseDTO.session;
        CZWTFCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.GETSESSIONTOKEN);
        return session.token;
      }
      CZWTFCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.GETSESSIONTOKEN);
      return '';
    } catch (Exception e) {
      tffa.Logger.debug('Exception in MXOpenNexusProvider : ' + e.getStackTraceString() + e.getMessage());
      CZWTFCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.GETSESSIONTOKEN);
      return '';
    }
  }
}