public with sharing class CZWTFCMXFetchMicroDepoAccProvider {
  @TestVisible
  private static boolean testException = false;
  public static List<CZWTFCMXFetchMemberAccountResponseDTO.Account_verifications> fetchMemberAccountList(Map<String, String> reqParams) {
    try {
      tffa.Logger.debug('inside MXFetchMemberAccountsProvider');
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }

      CZWTFCMXFetchMemberAccountResponseDTO responseDTO = CZWTFCMXFetchAccountsServiceProvider.invokeAPI(reqParams);
      tffa.Logger.debug('List of Accounts : ' + responseDTO);

      if (responseDTO.account_verifications != null) {
        CZWTFCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.FETCHMICRODEPOSITACCOUNTS);
        return responseDTO.account_verifications;
      }
      CZWTFCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.FETCHMICRODEPOSITACCOUNTS);
      return new List<CZWTFCMXFetchMemberAccountResponseDTO.Account_verifications>{};
    } catch (Exception e) {
      tffa.Logger.debug('Exception in MXFetchMemberAccountsProvider : ' + e.getStackTraceString() + e.getMessage());
      CZWTFCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.FETCHMICRODEPOSITACCOUNTS);
      return new List<CZWTFCMXFetchMemberAccountResponseDTO.Account_verifications>{};
    }
  }
}