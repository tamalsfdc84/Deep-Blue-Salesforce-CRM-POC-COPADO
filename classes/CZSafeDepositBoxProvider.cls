global inherited sharing virtual class CZSafeDepositBoxProvider extends tffa.DepositBoxProvider {

  global CZSafeDepositBoxProvider() {
  }

  global override Map<String, Object> fetchAvailableDepositBoxes(Map<String, Object> facts){

    if(!facts.containsKey('brandCode') || !facts.containsKey('branch')){
      return new Map<String, Object>();
    }

    String adapterName = 'FetchVacantBox';
    FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig(adapterName);
    adapterConfig.ServiceURL__c = adapterConfig.ServiceURL__c.replace('{branch}', (String) facts.get('branch'));
    adapterConfig.ServiceURL__c = adapterConfig.ServiceURL__c + '?StatCde=V';

    if(facts.containsKey('BoxPrfx') && facts.get('BoxPrfx') != null){
      adapterConfig.ServiceURL__c = adapterConfig.ServiceURL__c + '&BoxPrfx=' + (String) facts.get('BoxPrfx');
    }

    if(facts.containsKey('BoxTyp') && facts.get('BoxTyp') != null){
      adapterConfig.ServiceURL__c = adapterConfig.ServiceURL__c + '&BoxTyp=' + (String) facts.get('BoxTyp');
    }

    FISCCIntegrationLogService.setCharterConfig(String.valueOf(facts.get('brandCode')));
    FISCCIntegrationLogService.auth = FISCCGetAccessTokenProvider.processGetAccessToken(FISCCIntegrationLogService.charterConfig);

    CZSDBVacantBoxResponse res = CZSDBFetchVacantBoxExtension.invokeFetchVacantBoxes(adapterConfig, FISCCIntegrationLogService.charterConfig);

    if(res != null && res.entity != null){
      return (Map<String, Object>) JSON.deserializeUntyped(getResponseData(res, (String) facts.get('branch')));
    } 

    return new Map<String, Object>();
  }

  public static String getResponseData(CZSDBVacantBoxResponse res, String branch){
    CZSDBVacantBoxResponseDTO vacantBoxResponseData = new CZSDBVacantBoxResponseDTO();
    for(CZSDBVacantBoxDTO boxData : res.entity.sdbVacantBox){
      CZSDBVacantBoxResponseDTO.BoxData vacantBoxResponse = new CZSDBVacantBoxResponseDTO.BoxData();
      vacantBoxResponse.AccountNumber = branch.leftPad(3, '0') + '-' + String.valueOf(boxData.SafeBoxPrfx).leftPad(3, '0') + '-' + String.valueOf(boxData.SafeBoxNbr).leftPad(3, '0');
      vacantBoxResponseData.boxData.add(vacantBoxResponse);
    }

    vacantBoxResponseData.count = vacantBoxResponseData.boxData.size();

    String responseStr = System.JSON.serialize(vacantBoxResponseData, true);
    responseStr = responseStr.replaceAll('boxData', 'Items__r');
    responseStr = responseStr.replaceAll('AccountNumber', 'AccountNumber__c');

    return responseStr;
  }
}