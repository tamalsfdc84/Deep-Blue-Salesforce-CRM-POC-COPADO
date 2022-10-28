global with sharing class CZWTFCCustomService {
  global CZWTFCCustomService() {
  }

  /**
   * Returns Brand Object
   */
  public tffa__Brand__c fetchBrand(String code) {
    tffa__Brand__c brandObj = CZWTFCBrandRepository.fetchBrandByCode(code);

    //Fetch header and footer logo public url
    if (brandObj != null) {
      String orgId = UserInfo.getOrganizationId();

      if (!(brandObj.HeaderLogo__c).contains('https')) {
        Document headerLogo = CZWTFCHelperRepository.getDoc(brandObj.HeaderLogo__c);
        if (headerLogo != null) {
          brandObj.HeaderLogo__c = '/servlet/servlet.ImageServer?' + 'id=' + headerLogo.Id + '&oid=' + orgId;
        }
      }

      if (!(brandObj.FooterLogo__c).contains('https')) {
        Document footerLogo = CZWTFCHelperRepository.getDoc(brandObj.FooterLogo__c);
        if (footerLogo != null) {
          brandObj.FooterLogo__c = '/servlet/servlet.ImageServer?' + 'id=' + footerLogo.Id + '&oid=' + orgId;
        }
      }
      return brandObj;
    } else {
      throw new IllegalArgumentException('Invalid Brand Code');
    }
  }
  public List<SubBrand__c> fetchSubBrands(String code) {
    tffa__Brand__c brandObj = CZWTFCBrandRepository.fetchBrandByCode(code);
    List<SubBrand__c> subBrandList = new List<SubBrand__c>();

    if (brandObj != null) {
      subBrandList = CZWTFCBrandRepository.fetchSubBrandByBrandId(brandObj.Id);
    }
    return subBrandList;
  }

  public static Object getAccountDetails(Map<String, Object> params) {
    FISCCIntegrationLogService.setCharterConfig((String) params.get('charterCode'));

    //fetch adapter config
    FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig('GetAccountDetails');

    //fetch access token
    FISCCIntegrationLogService.auth = FISCCGetAccessTokenProvider.processGetAccessToken(FISCCIntegrationLogService.charterConfig);

    // retrun to controller if auth generation fails
    if (String.isEmpty(FISCCIntegrationLogService.auth) && !Test.isRunningTest()) {
      return null;
    }

    adapterConfig.ServiceURL__c = adapterConfig.ServiceURL__c + FISCCCommonHelper.encrypt((String) params.get('accountNumber'));

    HttpResponse response = null;

    response = (HttpResponse) FISCCHostAdapter.processHostRequest(null, adapterConfig, FISCCIntegrationLogService.charterConfig);

    String responseBody = Test.isRunningTest() ? '{"Entity":{"account":{"CurBal":100}}}' : response.getBody();

    if (responseBody != null && responseBody.contains('Error')) {
     return null;
    }

    Map<String, Object> responseData = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

    Map<String, Object> entityData = (Map<String, Object>) responseData.get('Entity');

    Map<String, Object> accountData = (Map<String, Object>) entityData.get('account');

    CZWTFCFISAccountDetailsResponseDTO dtoResponse = new CZWTFCFISAccountDetailsResponseDTO();
    dtoResponse.balance = (Decimal) accountData.get('CurBal');

    // If DormAcctInd key is not present set status as 'A'
    if (!accountData.containsKey('DormAcctInd')) {
      dtoResponse.status = 'A';
    } else {
      dtoResponse.status = (String) accountData.get('DormAcctInd');
    }

    return System.JSON.serialize(dtoResponse, true);
  }
}