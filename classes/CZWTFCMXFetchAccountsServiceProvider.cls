public with sharing class CZWTFCMXFetchAccountsServiceProvider {
  @TestVisible
  private static boolean testException = false;

  public static CZWTFCMXFetchMemberAccountResponseDTO invokeAPI(Map<String, String> params) {
    Map<String, String> data = params.clone();

    if (params.containsKey('microDepositGUID')) {
      CZWTFCMXServiceConfiguration.setMXConfig(CZWTFCMXServiceMapper.MICRODEPOSITACCOUNTS);
    } else {
      CZWTFCMXServiceConfiguration.setMXConfig(CZWTFCMXServiceMapper.FETCHMEMBERACCOUNTS);
    }

    tffa.Logger.debug(CZWTFCMXServiceConfiguration.getMXConfig());
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      if (params != null && !params.keySet().isEmpty()) {
        // invoke build request
        return CZWTFCMXFetchMemberAccountsService.execute(data);
      }
    } catch (Exception ex) {
      tffa.Logger.debug('Exception :::' + ex.getMessage() + 'LineNumber :::' + ex.getLineNumber());
      return new CZWTFCMXFetchMemberAccountResponseDTO();
    }
    return new CZWTFCMXFetchMemberAccountResponseDTO();
  }
}