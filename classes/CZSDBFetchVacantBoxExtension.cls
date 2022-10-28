public with sharing class CZSDBFetchVacantBoxExtension {
  public static CZSDBVacantBoxResponse invokeFetchVacantBoxes(
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    CZSDBVacantBoxResponse response;
    CZSDBVacantBoxResponse finalResponse = new CZSDBVacantBoxResponse();

    Object result = null;
    String moreInd = 'Y';
    String reqStartKey = null;
    try {
      while (moreInd.equals('Y')) {
        tffa.logger.debug('moreInd ==>' + moreInd);

        FISCC_Adapter_Configs__mdt adapterConfigInput = adapterConfig.clone(false, true);

        adapterConfigInput.ServiceURL__c = adapterConfig.ServiceURL__c;

        if (reqStartKey != null) {
          adapterConfigInput.ServiceURL__c += '&RepositionBox=' + reqStartKey;
        }

        result = FISCCHostAdapter.processHostRequest(null, adapterConfigInput, charterConfig);
        tffa.logger.debug('CZSDBFetchVacantBoxExtension : invokeFetchVacantBoxes result ==>' + result);
        response = isFISCCAPICallSuccess(result);
        tffa.logger.debug('CZSDBFetchVacantBoxExtension : response ==>' + response);
        if (response != null && response.entity != null) {
          moreInd = response.entity.sdbControlData.MoreInd;
          reqStartKey = response.entity.sdbControlData.RepositionBox;
          finalResponse.entity.sdbControlData = response.entity.sdbControlData;
          finalResponse.entity.sdbVacantBox.addAll(response.entity.sdbVacantBox);
        } else {
          moreInd = 'N';
          finalResponse = null;
        }
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in CZSDBFetchVacantBoxExtension.invokeFetchVacantBoxes : ' + ex.getMessage() + ex.getStackTraceString());
    }
    return finalResponse;
  }

  public static CZSDBVacantBoxResponse isFISCCAPICallSuccess(Object response) {
    CZSDBVacantBoxResponse objCZSDBVacantBoxResponse;
    try {
      if (response instanceof CZSDBVacantBoxResponse) {
        objCZSDBVacantBoxResponse = (CZSDBVacantBoxResponse) response;
      }
    } catch (Exception ex) {
      tffa.Logger.debug(
        'Exception in CZSDBFetchVacantBoxExtension.isFISCCAPICallSuccess : ' +
        +ex.getMessage() +
        ' Exception:::' +
        ex.getStackTraceString()
      );
    }
    return objCZSDBVacantBoxResponse;
  }
}