public with sharing class CZWTFCMXCreateUserServiceProvider {
  public static CZWTFCMXCreateUserResponseDTO invokeCreateUserAPI(Map<String, String> params) {
    Map<String, String> data = params.clone();

    CZWTFCMXServiceConfiguration.setMXConfig(CZWTFCMXServiceMapper.CREATEUSER);
    try {
      if (params != null && !params.keySet().isEmpty()) {
        // invoke build request
        return CZWTFCMXCreateUserService.createUser(data);
      }
    } catch (Exception ex) {
    }
    return CZWTFCMXCreateUserService.createUser(data);
  }
}