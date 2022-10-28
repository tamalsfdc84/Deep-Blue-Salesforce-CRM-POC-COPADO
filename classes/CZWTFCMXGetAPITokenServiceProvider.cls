public with sharing class CZWTFCMXGetAPITokenServiceProvider {
  @TestVisible
  private static boolean testException = false;

  public static map<String, object> invokeAPI(Map<String, String> params) {
    Map<String, String> data = params.clone();

    CZWTFCMXServiceConfiguration.setMXConfig(CZWTFCMXServiceMapper.GETAPITOKEN);

    tffa.Logger.debug(CZWTFCMXServiceConfiguration.getMXConfig());
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      if (params != null && !params.keySet().isEmpty()) {
        // invoke build request
        return CZWTFCMXGetAPITokenService.execute(data);
      } else {
        return (new Map<String, object>{ 'Status' => '400', 'StatusMessage' => 'Empty Parameter Passed' });
      }
    } catch (Exception ex) {
      tffa.Logger.debug('Exception :::' + ex.getMessage() + 'LineNumber :::' + ex.getLineNumber());
      return (new Map<String, object>{ 'Status' => '400', 'StatusMessage' => ex.getMessage() });
    }
  }
}