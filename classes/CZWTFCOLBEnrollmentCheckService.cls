public with sharing class CZWTFCOLBEnrollmentCheckService {
  public static String EndPoint_2;
  public static String Method_2;
  public static String Auth_Header;
  public static Boolean isEnrolled;

  public static boolean checkIfOLBIsEnrolled(String mdmPartyId) {
    isEnrolled = false;
    MuleSoft_Adapter_Config__mdt adapterConfig = CZWTFCHelperRepository.fetchMulesoftAdapterConfig('OLB');
    tffa.Logger.debug('mdmPartyId ' + mdmPartyId);

    String finalEndpoint = adapterConfig.EndPoint__c + '?wtfcPartyId=' + mdmPartyId;
    if (!Test.isRunningTest()) {
      //if (CZMulesoftAdapter.auth == null) {
      CZMulesoftAdapter.auth = CZWTFCMulesoftOAuthProvider.getAuthHeader();
      //}
    }
    adapterConfig.EndPoint__c = finalEndpoint;
    tffa.Logger.debug('CZMulesoftAdapter.auth ' + CZMulesoftAdapter.auth);

    Object resp = CZMulesoftAdapter.invokeAPI(null, adapterConfig);
    if (resp != null) {
      CZMDMOLBResponse olbResp = (CZMDMOLBResponse) resp;
      if (olbResp.isOLBEnrolled) {
        isEnrolled = true;
        return isEnrolled;
      }
    }
    isEnrolled = false;
    return isEnrolled;
  }
}