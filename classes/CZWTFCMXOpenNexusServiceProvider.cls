public with sharing class CZWTFCMXOpenNexusServiceProvider {
  @TestVisible
  private static boolean testException = false;

  public static CZWTFCMXOpenNexusResponseDTO invokeAPI(Map<String, String> params) {
    Map<String, String> data = params.clone();

    CZWTFCMXServiceConfiguration.setMXConfig(CZWTFCMXServiceMapper.OPENNEXUSSESSION);

    tffa.Logger.debug(CZWTFCMXServiceConfiguration.getMXConfig());
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      if (params != null && !params.keySet().isEmpty()) {
        // invoke build request
        return CZWTFCMXOpenNexusService.execute(data);
      }
    } catch (Exception ex) {
      tffa.Logger.debug('Exception :::' + ex.getMessage() + 'LineNumber :::' + ex.getLineNumber());
    }
    return CZWTFCMXOpenNexusService.execute(data);
  }
}