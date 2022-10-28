public with sharing class CZWTFCMXFetchMemberAccountsProvider {
  @TestVisible
  private static boolean testException = false;
  public static List<CZWTFCMXFetchMemberAccountResponseDTO.Account_numbers> fetchMemberAccountList(Map<String, String> reqParams) {
    try {
      tffa.Logger.debug('inside MXFetchMemberAccountsProvider');
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }

      CZWTFCMXFetchMemberAccountResponseDTO responseDTO = CZWTFCMXFetchAccountsServiceProvider.invokeAPI(reqParams);
      tffa.Logger.debug('List of Accounts : ' + responseDTO);

      if (responseDTO.account_numbers != null) {
        CZWTFCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.FETCHIAVACCOUNTS);
        return responseDTO.account_numbers;
      }
      CZWTFCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.FETCHIAVACCOUNTS);
      return new List<CZWTFCMXFetchMemberAccountResponseDTO.Account_numbers>{};
    } catch (Exception e) {
      tffa.Logger.debug('Exception in MXFetchMemberAccountsProvider : ' + e.getStackTraceString() + e.getMessage());
      CZWTFCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.FETCHIAVACCOUNTS);
      return new List<CZWTFCMXFetchMemberAccountResponseDTO.Account_numbers>{};
    }
  }
}