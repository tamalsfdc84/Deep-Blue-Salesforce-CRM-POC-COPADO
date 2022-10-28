public inherited sharing class CZWTFCIRAFetchPlansDetailsExtension {
  public static CZWTFCIRAPlanDetailsResponse invokeIRAPlanDetails(
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    CZWTFCIRAPlanDetailsResponse response;

    try {
      Object result = FISCCHostAdapter.processHostRequest(null, adapterConfig, charterConfig);
      tffa.logger.debug('CZWTFCIRAFetchPlansDetailsExtension : invokeIRAPlanDetails result ==>' + result);
      response = isFISCCAPICallSuccess(result);
      tffa.logger.debug('CZWTFCIRAFetchPlansDetailsExtension : response ==>' + response);
    } catch (Exception ex) {
      tffa.Logger.error('Exception in CZWTFCIRAFetchPlansDetailsExtension.invokeIRAPlanDetails : ' + ex.getMessage() + ex.getStackTraceString());
    }

    return response;
  }

  public static CZWTFCIRAPlanDetailsResponse isFISCCAPICallSuccess(Object response) {
    CZWTFCIRAPlanDetailsResponse objCZWTFCIRAPlanDetailsResponse;
    try {
      if (response instanceof CZWTFCIRAPlanDetailsResponse) {
        objCZWTFCIRAPlanDetailsResponse = (CZWTFCIRAPlanDetailsResponse) response;
      }
    } catch (Exception ex) {
      tffa.Logger.debug(
        'Exception in CZWTFCIRAFetchPlansDetailsExtension.isFISCCAPICallSuccess : ' +
        +ex.getMessage() +
        ' Exception:::' +
        ex.getStackTraceString()
      );
    }
    return objCZWTFCIRAPlanDetailsResponse;
  }
}