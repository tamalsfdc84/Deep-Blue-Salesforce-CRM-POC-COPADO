public with sharing class CZWTFCMXReadMemberAccountProvider {
  @TestVisible
  private static boolean testException = false;
  public static CZWTFCMXReadMemberAccountRespDTO.Account fetchMemberAccountDetails(Map<String, String> reqParams) {
    try {
      tffa.Logger.debug('inside MXReadMemberAccountProvider');
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }

      CZWTFCMXReadMemberAccountRespDTO responseDTO = CZWTFCMXReadMemberAccountServiceProvider.invokeAPI(reqParams);
      tffa.Logger.debug('Response DTO : ' + responseDTO);

      if (responseDTO.account != null) {
        CZWTFCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.READIAVACCOUNTS);
        return responseDTO.account;
      }
      CZWTFCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.READIAVACCOUNTS);
      return new CZWTFCMXReadMemberAccountRespDTO.Account();
    } catch (Exception e) {
      tffa.Logger.debug('Exception in MXReadMemberAccountProvider : ' + e.getStackTraceString() + e.getMessage());
      CZWTFCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.READIAVACCOUNTS);
      return new CZWTFCMXReadMemberAccountRespDTO.Account();
    }
  }
}