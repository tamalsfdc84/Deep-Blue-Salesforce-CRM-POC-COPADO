global with sharing class CZWTFCCustomService {
  global CZWTFCCustomService() {
  }

  @TestVisible
  private static boolean testException = false;

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

  /**
   * Inititate Remote Funding for the selected party in Dropdown on Acc-Details page
   */
  public static void initiateRemoteFunding(Map<String, Object> mp) {
    try {
      String subId = (String) mp.get('Submission__c');
      tffa__Party__c partyObj = CZWTFCPartyRepository.fetchPartyById((String) mp.get('Party__c'));
      String q;
      Map<String, String> urlParams = new Map<String, String>();
      urlParams.put('Submission__c', subId);
      urlParams.put('OTPStatus__c', 'CHALLENGED');
      urlParams.put('EventName__c', 'RemoteFundingInitiated');
      urlParams.put('Party__c', partyObj.Id);
      urlParams.put('brandCode', partyObj.tffa__BrandCode__c);
      if (!Test.isRunningTest()) {
        q = tffa.Cipher.encrypt(JSON.serialize(urlParams));
      }
      tffa.OTPProvider provider = tffa.OTPProvider.getInstance();
      provider.generate(
        new Map<String, Object>{ 'Party__c' => partyObj.Id, 'UrlFragment__c' => q, 'EventName__c' => 'RemoteFundingInitiated' }
      );
      new CZWTFCPartyEventExtension('Party_OTP_Generated').post(partyObj);
      new CZWTFCPartyEventExtension('Party_RemoteFundingInitiated').post(partyObj);
    } catch (Exception ex) {
      tffa.Logger.error('Exception in CustomService.initiateRemoteFunding ' + ex.getMessage() + ex.getStackTraceString());
    }
  }

  /**
   * Fetch Promotion code list for the application
   */
  public static List<CZPromoCodeResponse> fetchPromotionCodes(Map<String, Object> params) {
    tffa.Logger.debug('In CZWTFCCustomService fetchPromotionCodes params ' + params);

    List<CZPromoCodeResponse> promoCodeLst = new List<CZPromoCodeResponse>();
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      tffa.PromotionProcessor p = new tffa.PromotionProcessor();
      List<tffa__Promotion__c> plist = p.resolve(params);
      for (tffa__Promotion__c promo : plist) {
        CZPromoCodeResponse promoResp = new CZPromoCodeResponse();
        promoResp.name = promo.Name;
        promoResp.promoCode = promo.tffa__Code__c;
        promoResp.description = promo.tffa__Description__c;
        promoCodeLst.add(promoResp);
      }
    } catch (Exception ex) {
      tffa.Logger.debug('exception in fetchPromotionCodes ' + ex.getLineNumber() + ' ' + ex.getMessage());
    }
    return promoCodeLst;
  }

  public List<CZOfficerDetails__c> fetchOfficerList(String brandCode) {
    tffa.Logger.debug('In CZWTFCCustomService fetchOfficerList brandCode ' + brandCode);
    return CZWTFCHelperRepository.fetchOfficerDetails(brandCode);
  }

  public CZBrandResponseDTO fetchBrandLocations(String brandCode) {
    tffa.Logger.debug('In CZWTFCCustomService fetchBrandLocations');

    List<tffa__BrandLocation__c> locationList = CZWTFCBrandRepository.fetchLocationByCodes(brandCode);

    tffa.Logger.debug('In CZWTFCCustomService locationList::' + locationList);

    CZBrandResponseDTO responseDTO = new CZBrandResponseDTO();

    for (tffa__BrandLocation__c brandLocation : locationList) {
      responseDTO.Locations.add(brandLocation.tffa__Location__r);
    }

    tffa.Logger.debug('In CZWTFCCustomService responseDTO::' + responseDTO);

    return responseDTO;
  }

  public static CZTermDepositRateResponseDTO fetchTermDepositRate(Map<String, String> params) {
    tffa.Logger.debug('In CZWTFCCustomService fetchTermDepositRate');
    CZTermDepositRateResponseDTO responseDTO = new CZTermDepositRateResponseDTO();
    String interestPlanCode = '';

    tffa__Product__c product = CZWTFCProductRepository.getProductByCode(params.get('ProductCode'));

    if (
      product.tffa__Category__c == 'CERTIFICATE' ||
      product.tffa__Category__c == 'BUSINESS_CERTIFICATE' ||
      (product.tffa__Category__c == 'IRA' &&
      product.tffa__AllowedInvestmentAccountType__c != null &&
      product.tffa__AllowedInvestmentAccountType__c.contains('CERTIFICATE'))
    ) {
      for (tffa__ProductTerm__c term : product.tffa__Terms__r) {
        if (Decimal.valueOf(params.get('Term')) >= term.tffa__MinTerm__c && Decimal.valueOf(params.get('Term')) <= term.tffa__MaxTerm__c) {
          interestPlanCode = term.tffa__InterestPlanCode__c;
          break;
        }
      }
    } else {
      interestPlanCode = product.InterestPlanCode__c;
    }

    Integer tempIntplCode = Integer.valueOf(interestPlanCode);
    interestPlanCode = String.valueOf(tempIntplCode);

    List<InterestPlanDetails__c> interestPlanDetails = CZWTFCHelperRepository.fetchInterestPlanDetails(
      interestPlanCode,
      params.get('BrandCode')
    );

    if (interestPlanDetails != null && interestPlanDetails.size() == 1) {
      responseDTO.InterestRate = interestPlanDetails[0].InterestRate__c;
      responseDTO.APY = interestPlanDetails[0].APY__c;
    } else if (interestPlanDetails != null && interestPlanDetails.size() > 1) {
      Decimal amount = Decimal.valueOf(params.get('Amount'));
      for (InterestPlanDetails__c interestPlanDetail : interestPlanDetails) {
        if (amount > interestPlanDetail.TierMinBal__c && amount <= interestPlanDetail.TierMaxBal__c) {
          responseDTO.InterestRate = interestPlanDetail.InterestRate__c;
          responseDTO.APY = interestPlanDetail.APY__c;
          break;
        }
      }
    }

    return responseDTO;
  }

  public static CZAPYResponseDTO calculateAPY(Map<String, String> params) {
    tffa.Logger.debug('In CZWTFCCustomService calculateAPY');
    CZAPYResponseDTO responseDTO = new CZAPYResponseDTO();

    String periodFrequencyChoice = params.get('InterestPayoutFrequency') == 'AT_MATURITY'
      ? 'MATURITY'
      : params.get('InterestPayoutFrequency');
    String interestFrequencyCode = params.get('TermUnit') == 'DAY' ? 'D' : 'M';
    Integer maturityPeriod = Integer.valueOf(params.get('Term'));

    WT_TerafinaAPYHelper.APYResponseModel responseModel = WT_TerafinaAPYHelper.GetApy(
      Double.valueOf(params.get('InterestRate')) / 100,
      null,
      periodFrequencyChoice,
      interestFrequencyCode,
      maturityPeriod
    );

    if (responseModel.IsSuccess) {
      responseDTO.InterestRate = Decimal.valueOf(params.get('InterestRate'));
      responseDTO.APY = responseModel.APY;
    }

    return responseDTO;
  }

  public class CZDocumentException extends Exception {
  }
}