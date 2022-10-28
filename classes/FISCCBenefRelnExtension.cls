public with sharing class FISCCBenefRelnExtension {
  public static Boolean invokeApiCall(
    tffa__Application__c appObj,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    tffa.Logger.debug('--------- called');
    FISCCRequestBaseDTO fisccRequestBaseDTO = null;
    Object result = null;
    Boolean isSuccess;
    try {
      fisccRequestBaseDTO = FISCCBenefRelnExtension.generateBenefRelnReq(appObj);
      tffa.Logger.debug('--------- fisccRequestBaseDTO' + fisccRequestBaseDTO);
      result = FISCCHostAdapter.processHostRequest(fisccRequestBaseDTO, adapterConfig, charterConfig);
      tffa.Logger.debug('--------- result' + result);
      isSuccess = FISCCBenefRelnExtension.parseBenefRelnResponse(result);
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in FISCCBenefRelnExtension ' + ex.getMessage() + ' Exception :::' + ex.getStackTraceString());
    }
    return isSuccess;
  }

  public static FISCCRequestBaseDTO generateBenefRelnReq(tffa__Application__c appObj) {
    tffa.Logger.debug('In generateBenefRelnReq');
    FISCCRequestBaseDTO fisccRequestBaseDTO = null;
    FISCCBenefRelnRequestDTO benefRelnReq = new FISCCBenefRelnRequestDTO();

    try {
      if (appObj != null && appObj.tffa__Beneficiaries__r != null && !appObj.tffa__Beneficiaries__r.isEmpty()) {
        benefRelnReq.caMaintainAcc.ApCd1 = FISCCIntegrationConstants.GenDPApplID;
        benefRelnReq.caMaintainAcc.ApNbr1 = appObj.tffa__AccountNumber__c;
        tffa.Logger.debug('In benefRelnReq');
        for (tffa__Beneficiary__c benefObj : appObj.tffa__Beneficiaries__r) {
          FISCCBenefRelnRequestDTO.CustomerAccountRelnList customerDetail = new FISCCBenefRelnRequestDTO.CustomerAccountRelnList();
          customerDetail.AcNbr2 = benefObj.Customer_Number__c;
          customerDetail.E1ToE2RlCd = 411;
          customerDetail.E2ToE1RlCd = 902;
          benefRelnReq.caAccRelnList.add(customerDetail);
        }
        fisccRequestBaseDTO = benefRelnReq;
      }
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in generateBenefRelnReq ' + ex.getMessage() + ' Exception :::' + ex.getStackTraceString());
    }
    return fisccRequestBaseDTO;
  }

  public static Boolean parseBenefRelnResponse(Object response) {
    tffa.Logger.debug('parseBenefRelnResponse----> ' + response);
    try {
      if (response instanceof FISCCBenefRelnResponseDTO) {
        FISCCBenefRelnResponseDTO benefResp = (FISCCBenefRelnResponseDTO) response;
        tffa.Logger.debug('parseBenefRelnResponse--> ' + benefResp);
        return true;
      } else {
        return false;
      }
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in parseBenefRelnResponse ' + ex.getMessage() + ' Exception :::' + ex.getStackTraceString());
      return false;
    }
  }
}