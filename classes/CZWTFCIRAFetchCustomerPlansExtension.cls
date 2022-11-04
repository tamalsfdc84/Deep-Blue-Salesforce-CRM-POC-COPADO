public inherited sharing class CZWTFCIRAFetchCustomerPlansExtension {
  public static CZWTFCExistingIRAPlanResponse invokeIRAPlans(
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    CZWTFCExistingIRAPlanResponse response;
    CZWTFCExistingIRAPlanResponse finalResponse = new CZWTFCExistingIRAPlanResponse();

    Object result = null;
    String moreInd = 'Y';
    String reqStartKey = null;
    try {
      while (moreInd.equals('Y')) {
        FISCC_Adapter_Configs__mdt adapterConfigInput = adapterConfig.clone(false, true);

        adapterConfigInput.ServiceURL__c = adapterConfig.ServiceURL__c;

        if (reqStartKey != null) {
          adapterConfigInput.ServiceURL__c += '?NextPageCursor=' + reqStartKey;
        }

        result = FISCCHostAdapter.processHostRequest(null, adapterConfigInput, charterConfig);
        tffa.logger.debug('CZWTFCIRAFetchCustomerPlansExtension : invokeIRAPlans result ==>' + result);
        response = isFISCCAPICallSuccess(result);
        tffa.logger.debug('CZWTFCIRAFetchCustomerPlansExtension : response ==>' + response);
        if (response != null) {
          moreInd = response.customerData.MorePages;
          reqStartKey = response.customerData.NextPageCursor;
          finalResponse.customerData = response.customerData;
          finalResponse.existingPlanList.addAll(response.existingPlanList);
        } else {
          moreInd = 'N';
          finalResponse = null;
        }
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in CZWTFCIRAFetchCustomerPlansExtension.invokeIRAPlans : ' + ex.getMessage() + ex.getStackTraceString());
    }

    return finalResponse;
  }

  public static CZWTFCExistingIRAPlanResponse isFISCCAPICallSuccess(Object response) {
    CZWTFCExistingIRAPlanResponse objCZWTFCExistingIRAPlanResponse;
    try {
      if (response instanceof CZWTFCExistingIRAPlanResponse) {
        objCZWTFCExistingIRAPlanResponse = (CZWTFCExistingIRAPlanResponse) response;
      }
    } catch (Exception ex) {
      tffa.Logger.debug(
        'Exception in CZWTFCIRAFetchCustomerPlansExtension.isFISCCAPICallSuccess : ' +
        +ex.getMessage() +
        ' Exception:::' +
        ex.getStackTraceString()
      );
    }
    return objCZWTFCExistingIRAPlanResponse;
  }
}