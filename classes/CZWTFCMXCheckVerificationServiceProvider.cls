public with sharing class CZWTFCMXCheckVerificationServiceProvider {
  @TestVisible
  private static boolean testException = false;

  public static CZWTFCMXCheckVerificationStatusRespDTO invokeAPI(Map<String, String> params) {
    Map<String, String> data = params.clone();

    CZWTFCMXServiceConfiguration.setMXConfig(CZWTFCMXServiceMapper.CHECKVERIFICATIONSTATUS);

    tffa.Logger.debug(CZWTFCMXServiceConfiguration.getMXConfig());
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      if (params != null && !params.keySet().isEmpty()) {
        // invoke build request
        return CZWTFCMXCheckVerificationStatusService.execute(data);
      }
    } catch (Exception ex) {
      tffa.Logger.debug('Exception :::' + ex.getMessage() + 'LineNumber :::' + ex.getLineNumber());
      return new CZWTFCMXCheckVerificationStatusRespDTO();
    }
    return new CZWTFCMXCheckVerificationStatusRespDTO();
  }
}