public inherited sharing class CZWTFCIRAFetchBeneficiaryExtension {
  public static CZWTFCIRAPlanBeneficiaryResponse invokeIRAPlanBeneficiary(
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    CZWTFCIRAPlanBeneficiaryResponse response;
    CZWTFCIRAPlanBeneficiaryResponse finalResponse = new CZWTFCIRAPlanBeneficiaryResponse();
    Object result = null;
    
    try {
      result = FISCCHostAdapter.processHostRequest(null, adapterConfig, charterConfig);
      tffa.logger.debug('CZWTFCIRAFetchBeneficiaryExtension : invokeIRAPlanBeneficiary result ==>' + result);
      response = isFISCCAPICallSuccess(result);
      tffa.logger.debug('CZWTFCIRAFetchBeneficiaryExtension : response ==>' + response);
      if (response != null && response.planBeneficiariesDataLst != null && response.planBeneficiariesDataLst.size() > 0) {
        finalResponse.planBeneficiariesDataLst = response.planBeneficiariesDataLst;
      } else {
        finalResponse = null;
      }
      
    } catch (Exception ex) {
      tffa.Logger.error('Exception in CZWTFCIRAFetchBeneficiaryExtension.invokeIRAPlanBeneficiary : ' + ex.getMessage() + ex.getStackTraceString());
    }

    return finalResponse;
  }

  public static CZWTFCIRAPlanBeneficiaryResponse isFISCCAPICallSuccess(Object response) {
    CZWTFCIRAPlanBeneficiaryResponse objCZWTFCIRAPlanBeneficiaryResponse;
    try {
      if (response instanceof CZWTFCIRAPlanBeneficiaryResponse) {
        objCZWTFCIRAPlanBeneficiaryResponse = (CZWTFCIRAPlanBeneficiaryResponse) response;
      }
    } catch (Exception ex) {
      tffa.Logger.debug(
        'Exception in CZWTFCIRAFetchBeneficiaryExtension.isFISCCAPICallSuccess : ' +
        +ex.getMessage() +
        ' Exception:::' +
        ex.getStackTraceString()
      );
    }
    return objCZWTFCIRAPlanBeneficiaryResponse;
  }
}