public with sharing class FISCCPasswordChangeExtension {
  @TestVisible
  private static boolean testException = false;

  public static boolean invokeApiCall(
    FISIBSAuthConfig__c fisAuth,
    String updatedPassword,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    tffa.Logger.debug('In FISCCPasswordChangeExtension invokeApiCall');

    FISCCRequestBaseDTO fisccRequestBaseDTO = null;
    Object result = null;
    Boolean isSuccess;

    fisccRequestBaseDTO = FISCCPasswordChangeExtension.generateRequest(updatedPassword);
    tffa.Logger.debug('--------- fisccRequestBaseDTO' + fisccRequestBaseDTO);

    result = FISCCHostAdapter.processHostRequest(fisccRequestBaseDTO, adapterConfig, charterConfig);
    tffa.Logger.debug('--------- result' + result);

    isSuccess = FISCCPasswordChangeExtension.parsePassChangeResp(fisAuth, result);
    return isSuccess;
  }

  public static FISCCRequestBaseDTO generateRequest(String updatedPassword) {
    tffa.Logger.debug('In FISCCPasswordChangeExtension generateRequest');
    FISCCRequestBaseDTO fisccRequestBaseDTO = null;
    FISCCPassChangeRequest fisPassChangeReq = new FISCCPassChangeRequest();

    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }

      fisPassChangeReq.racfpass.NewPwd = updatedPassword;
      fisccRequestBaseDTO = fisPassChangeReq;
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in parsePassChangeReq ' + ex.getMessage() + ' Exception :::' + ex.getStackTraceString());
    }
    return fisccRequestBaseDTO;
  }

  public static Boolean parsePassChangeResp(FISIBSAuthConfig__c fisAuth, Object response) {
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }

      fisAuth.FailedReason__c = ' ';
      if (response instanceof Map<String, Object>) {
        Map<String, Object> mapResponse = (Map<String, Object>) response;
        if (mapResponse.containsKey('StatusMessage')) {
          tffa.Logger.debug('response ' + mapResponse.get('StatusMessage'));
          fisAuth.FailedReason__c = (String) mapResponse.get('StatusMessage');
        }
        return false;
      }

      if (response instanceof FISCCPassChangeResponse) {
        FISCCPassChangeResponse passChangeResp = (FISCCPassChangeResponse) response;
        return true;
      } else {
        return false;
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in parsePassChangeResp ' + ex.getMessage() + ' Exception :::' + ex.getStackTraceString());
      fisAuth.FailedReason__c = ' ';
      return false;
    }
  }
}