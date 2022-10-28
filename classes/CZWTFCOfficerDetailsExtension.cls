public with sharing class CZWTFCOfficerDetailsExtension {
  public static CZWTFCOfficerDetailsResponse invokeOfficeDetails(
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    CZWTFCOfficerDetailsResponse response;
    CZWTFCOfficerDetailsResponse finalResponse = new CZWTFCOfficerDetailsResponse();

    Object result = null;
    String moreInd = 'Y';
    String reqStartKey = null;
    try {
      while (moreInd.equals('Y')) {
        FISCC_Adapter_Configs__mdt adapterConfigInput = adapterConfig.clone(false, true);

        adapterConfigInput.ServiceURL__c = adapterConfig.ServiceURL__c + '?ReqCde=R&MaxNbrRtes=9999&MaxNbrTiers=9999';

        if (reqStartKey != null) {
          adapterConfigInput.ServiceURL__c += '&StrtOfcrNbr=' + reqStartKey;
        }

        result = FISCCHostAdapter.processHostRequest(null, adapterConfigInput, charterConfig);
        tffa.logger.debug('CZWTFCOfficerDetailsExtension : invokeOfficeDetail result ==>' + result);
        response = isFISCCAPICallSuccess(result);
        tffa.logger.debug('CZWTFCOfficerDetailsExtension : response ==>' + response);
        if (response != null) {
          moreInd = response.controlData.MoreInd;
          reqStartKey = response.controlData.StrtOfcrNbr;
          finalResponse.controlData = response.controlData;
          finalResponse.officerDetailsLts.addAll(response.officerDetailsLts);
        } else {
          moreInd = 'N';
          finalResponse = null;
        }
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in CZWTFCOfficerDetailsExtension.invokeOfficeDetails : ' + ex.getMessage() + ex.getStackTraceString());
    }
    return finalResponse;
  }

  public static CZWTFCOfficerDetailsResponse isFISCCAPICallSuccess(Object response) {
    CZWTFCOfficerDetailsResponse objCZWTFCOfficerDetailsResponse;
    try {
      if (response instanceof CZWTFCOfficerDetailsResponse) {
        objCZWTFCOfficerDetailsResponse = (CZWTFCOfficerDetailsResponse) response;
      }
    } catch (Exception ex) {
      tffa.Logger.debug(
        'Exception in CZWTFCOfficerDetailsExtension.isFISCCAPICallSuccess : ' +
        +ex.getMessage() +
        ' Exception:::' +
        ex.getStackTraceString()
      );
    }
    return objCZWTFCOfficerDetailsResponse;
  }
}