public with sharing class FISCCGetInterestRatesExtension {
  public static FISCCGetInterestRatesResponse invokeGetInterestRates(
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    FISCCRequestBaseDTO fisccRequestBaseDTO = null;
    FISCCGetInterestRatesResponse response;
    FISCCGetInterestRatesResponse finalResponse = new FISCCGetInterestRatesResponse();

    Object result = null;
    String moreInd = 'Y';
    String reqStartKey = null;
    try {
      while (moreInd.equals('Y')) {
        FISCC_Adapter_Configs__mdt adapterConfigInput = adapterConfig.clone(false, true);
        adapterConfigInput.ServiceURL__c = adapterConfig.ServiceURL__c + '?ReqCde=R&MaxNbrRtes=9999&MaxNbrTiers=9999';
        if (reqStartKey != null) {
          adapterConfigInput.ServiceURL__c += '&ReqStartKey=' + reqStartKey;
        }

        result = FISCCHostAdapter.processHostRequest(null, adapterConfigInput, charterConfig);
        tffa.logger.debug('FISCCGetInterestRatesExtension.invokeGetInterestRates: result ==>' + result);
        response = isFISCCAPICallSuccess(result);
        if (response != null) {
          moreInd = response.controlData.MoreInd;
          reqStartKey = response.controlData.ReqStartKey;
          finalResponse.investmentRateSchedulesMap.putAll(response.investmentRateSchedulesMap);
          finalResponse.investmentRateTiersMap.putAll(response.investmentRateTiersMap);
        } else {
          moreInd = 'N';
          finalResponse = null;
        }
      }
    } catch (Exception ex) {
      tffa.Logger.error(
        'Exception in FISCCGetInterestRatesExtension.invokeGetInterestRates : ' +
        ex.getMessage() +
        ex.getStackTraceString()
      );
    }
    return finalResponse;
  }

  public static FISCCGetInterestRatesResponse isFISCCAPICallSuccess(Object response) {
    FISCCGetInterestRatesResponse objFISCCGetInterestRatesResponse;
    try {
      if (response instanceof FISCCGetInterestRatesResponse) {
        objFISCCGetInterestRatesResponse = (FISCCGetInterestRatesResponse) response;
      }
    } catch (Exception ex) {
      tffa.Logger.debug(
        'Exception in FISCCGetInterestRatesExtension.isFISCCAPICallSuccess : ' +
        +ex.getMessage() +
        ' Exception:::' +
        ex.getStackTraceString()
      );
    }
    return objFISCCGetInterestRatesResponse;
  }
}