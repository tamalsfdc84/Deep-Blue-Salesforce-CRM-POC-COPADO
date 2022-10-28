public with sharing class CZWTFCMXCheckVerificationStatusProvider {
  @TestVisible
  private static boolean testException = false;
  public static CZWTFCMXCheckVerificationStatusRespDTO checkVerificationStatus(Map<String, String> reqParams) {
    try {
      tffa.Logger.debug('inside MXCheckVerificationStatusProvider');
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }

      CZWTFCMXCheckVerificationStatusRespDTO responseDTO = CZWTFCMXCheckVerificationServiceProvider.invokeAPI(reqParams);
      CZWTFCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.CHECKVERIFICATIONSTATUS);
      return responseDTO;
    } catch (Exception e) {
      tffa.Logger.debug('Exception in MXCheckVerificationStatusProvider : ' + e.getStackTraceString() + e.getMessage());
      CZWTFCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.CHECKVERIFICATIONSTATUS);
      return new CZWTFCMXCheckVerificationStatusRespDTO();
    }
  }
}