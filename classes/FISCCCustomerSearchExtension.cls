public with sharing class FISCCCustomerSearchExtension {
  @TestVisible
  private static boolean testException = false;

  public static Object searchCustomer(Map<String, Object> params) {
    Object result = null;

    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      FISCC_Adapter_Configs__mdt adapterConfig;
      FISCCIntegrationLogService.setCharterConfig((String) params.get('brandCode'));
      if (String.isBlank(FISCCIntegrationLogService.auth)) {
        FISCCIntegrationLogService.auth = FISCCGetAccessTokenProvider.processGetAccessToken(FISCCIntegrationLogService.charterConfig);
      }
      if (params.containsKey('acctNum') && String.isBlank((String) params.get('acctNum'))) {
        params.remove('acctNum');
      }
      adapterConfig = setUrl(params);
      result = FISCCHostAdapter.processHostRequest(null, adapterConfig, FISCCIntegrationLogService.charterConfig);
      if ((String) params.get('custType') == 'I' && !params.containsKey('acctNum')) {
        return parseIndResp(result);
      } else if ((String) params.get('custType') == 'O' && !params.containsKey('acctNum')) {
        return parseOrgResp(result);
      } else if ((String) params.get('custType') == 'I' && params.containsKey('acctNum')) {
        return parseIndAccountRelatedResp(result);
      } else if ((String) params.get('custType') == 'O' && params.containsKey('acctNum')) {
        return parseOrgAccountRelatedResp(result);
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception searchCustomer ' + ex.getStackTraceString());
    }
    return result;
  }

  public static FISCC_Adapter_Configs__mdt setUrl(Map<String, Object> params) {
    FISCC_Adapter_Configs__mdt adapterConfig;
    String url;
    boolean firstParam = false;
    if (
      (params.containsKey('frstNm') && String.isNotBlank((String) params.get('frstNm'))) ||
      (params.containsKey('lstNm') && String.isNotBlank((String) params.get('lstNm'))) ||
      (params.containsKey('businessNm') && String.isNotBlank((String) params.get('businessNm'))) ||
      (params.containsKey('street') && String.isNotBlank((String) params.get('street'))) ||
      (params.containsKey('city') && String.isNotBlank((String) params.get('city'))) ||
      (params.containsKey('state') && String.isNotBlank((String) params.get('state'))) ||
      (params.containsKey('zip') && String.isNotBlank((String) params.get('zip')))
    ) {
      adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig('SearchCustomerUsingName');
      url = adapterConfig.ServiceURL__c + '?';
      if (
        (params.containsKey('frstNm') && String.isNotBlank((String) params.get('frstNm'))) ||
        (params.containsKey('lstNm') && String.isNotBlank((String) params.get('lstNm'))) ||
        (params.containsKey('businessNm') && String.isNotBlank((String) params.get('businessNm')))
      ) {
        String name = '';
        if (params.containsKey('frstNm') && String.isNotBlank((String) params.get('frstNm'))) {
          name = (String) params.get('frstNm');
        }
        if (params.containsKey('lstNm') && String.isNotBlank((String) params.get('lstNm'))) {
          if (String.isNotBlank(name)) {
            name = name + ' ';
          }
          name = name + '\\' + (String) params.get('lstNm') + '*';
        }
        if (params.containsKey('businessNm') && String.isNotBlank((String) params.get('businessNm'))) {
          name = (String) params.get('businessNm');
        }
        url = url + 'CICustNme=' + FISCCCommonHelper.encrypt(name);
        firstParam = true;
      }
      if (params.containsKey('street') && String.isNotBlank((String) params.get('street'))) {
        url = firstParam ? url + '&' : url;
        url = url + 'CIKeyStrNme=' + (String) params.get('street');
        firstParam = true;
      }

      if (params.containsKey('city') && String.isNotBlank((String) params.get('city'))) {
        url = firstParam ? url + '&' : url;
        url = url + 'CIKeyCtyNme=' + (String) params.get('city');
        firstParam = true;
      }

      if (params.containsKey('state') && String.isNotBlank((String) params.get('state'))) {
        url = firstParam ? url + '&' : url;
        url = url + 'CIKeyStCde=' + (String) params.get('state');
        firstParam = true;
      }
      if (params.containsKey('zip') && String.isNotBlank((String) params.get('zip'))) {
        url = firstParam ? url + '&' : url;
        url = url + 'CIKeyZIP=' + (String) params.get('zip');
        firstParam = true;
      }
    } else if (params.containsKey('customerNbr') && String.isNotBlank((String) params.get('customerNbr'))) {
      adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig('SearchCustomerUsingCIS');
      url = adapterConfig.ServiceURL__c + '?';
      if (params.containsKey('customerNbr')) {
        url = url + 'CICustNbr=' + FISCCCommonHelper.encrypt((String) params.get('customerNbr'));
        firstParam = true;
      }
    } else if (params.containsKey('ssnNum') && String.isNotBlank((String) params.get('ssnNum'))) {
      adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig('SearchCustomerUsingTaxId');
      url = adapterConfig.ServiceURL__c + '?';
      if (params.containsKey('ssnNum')) {
        url = url + 'CIKeySSN=' + FISCCCommonHelper.encrypt((String) params.get('ssnNum'));
        firstParam = true;
      }
    } else if (params.containsKey('phnNum') && String.isNotBlank((String) params.get('phnNum'))) {
      params.put('phnNum', parsePhoneNumber((String) params.get('phnNum')));
      adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig('SearchCustomerUsingPhnNbr');
      url = adapterConfig.ServiceURL__c + '?';
      if (params.containsKey('phnNum')) {
        url = url + 'CIKeyPhNbr=' + FISCCCommonHelper.encrypt((String) params.get('phnNum'));
        firstParam = true;
      }
    } else if (params.containsKey('acctNum') && String.isNotBlank((String) params.get('acctNum'))) {
      adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig('SearchCustomerUsingAccount');
      url = adapterConfig.ServiceURL__c;
      url = url.replace('{ApplCde}', 'DP');
      url = url.replace('{RltAcctNbr}', FISCCCommonHelper.encrypt((String) params.get('acctNum')));
      firstParam = true;
    }

    if (params.containsKey('searchType') && !params.containsKey('acctNum')) {
      url = firstParam ? url + '&' : url;
      url = url + 'CISearchTyp=' + (String) params.get('searchType');
      firstParam = true;
    }

    if (params.containsKey('custType') && !params.containsKey('acctNum')) {
      url = firstParam ? url + '&' : url;
      url = url + 'CICustTypInd=' + (String) params.get('custType');
      firstParam = true;
    }

    if (
      params.containsKey('startSearchCISNumber') &&
      (String.isNotBlank((String) params.get('startSearchCISNumber')) || '0' != (String) params.get('startSearchCISNumber')) &&
      !params.containsKey('acctNum')
    ) {
      url = firstParam ? url + '&' : url;
      url = url + 'CICustNbrToStrtSearch=' + FISCCCommonHelper.encrypt((String) params.get('startSearchCISNumber'));
      firstParam = true;
    }
    adapterConfig.ServiceURL__c = url;
    return adapterConfig;
  }

  public static String parsePhoneNumber(String phnNumber) {
    phnNumber = phnNumber.replace('(', '');
    phnNumber = phnNumber.replace(')', '');
    phnNumber = phnNumber.replace('-', '');
    phnNumber = phnNumber.replace(' ', '');
    return phnNumber;
  }

  public static CZMDMIndividualSearchResponse parseIndResp(Object resp) {
    CZMDMIndividualSearchResponse response = new CZMDMIndividualSearchResponse();
    if (resp == null || !(resp instanceof FISCCCustomerSearchResponse)) {
      return response;
    }
    FISCCCustomerSearchResponse custResp = (FISCCCustomerSearchResponse) resp;
    if (custResp.entity == null || custResp.entity.customersLst == null || custResp.entity.customersLst.isEmpty()) {
      response.status = 'failure';
      return response;
    }
    if (custResp.entity.searchControlData != null && custResp.entity.searchControlData.CIMoreToBeReturnedInd == 'Y') {
      response.nextCISStartNumber = custResp.entity.searchControlData.CICustNbrToStrtSearch;
    } else {
      response.nextCISStartNumber = '0';
    }
    for (FISCCCustomerDTO custDto : custResp.entity.customersLst) {
      CZMDMIndividualSearchResponse.IndInfo indInfo = new CZMDMIndividualSearchResponse.IndInfo();
      indInfo.firstName = custDto.ElmntFrstNme;
      indInfo.lastName = custDto.ElmntLstNme;
      indInfo.SSN = custDto.CICustTaxNbr;
      indInfo.addressLine1 = custDto.CICurStdAddr1Txt;
      indInfo.city = custDto.ElmntCity;
      indInfo.state = custDto.ElmntState;
      if (custDto.ElmntZip != null && custDto.ElmntZip.length() > 5) {
        indInfo.zip4Cd = custDto.ElmntZip.substring(0, 4);
        indInfo.zip5Cd = custDto.ElmntZip.substring(4, custDto.ElmntZip.length());
      } else {
        indInfo.zip5Cd = custDto.ElmntZip;
      }

      if (custDto.CIPrmyPhNbr != null) {
        indInfo.phoneNumber = custDto.CIPrmyPhNbr;
      } else if (custDto.ScndyPhn != null) {
        indInfo.phoneNumber = custDto.ScndyPhn;
      }
      indInfo.mdmPartyId = custDto.CICustRtnNbr;
      response.individualInfoLst.add(indInfo);
    }
    response.status = 'success';
    return response;
  }

  public static CZMDMIndividualSearchResponse parseIndAccountRelatedResp(Object resp) {
    CZMDMIndividualSearchResponse response = new CZMDMIndividualSearchResponse();
    if (resp == null || !(resp instanceof FISCCGetAccountProfileResponse)) {
      return response;
    }
    FISCCGetAccountProfileResponse custResp = (FISCCGetAccountProfileResponse) resp;
    if (custResp.entity == null || custResp.entity.accountProf == null) {
      response.status = 'failure';
      return response;
    }

    response.nextCISStartNumber = '0';

    if (custResp.entity.accountProf.CIRecTypInd == null || custResp.entity.accountProf.CIRecTypInd != 'O') {
      CZMDMIndividualSearchResponse.IndInfo indPrimaryInfo = new CZMDMIndividualSearchResponse.IndInfo();
      indPrimaryInfo.firstName = custResp.entity.accountProf.CICurFrstNmeKeyFld2;
      indPrimaryInfo.lastName = custResp.entity.accountProf.CICurLstNmeKeyFld1;
      indPrimaryInfo.SSN = custResp.entity.accountProf.cICustTaxNbr;
      indPrimaryInfo.addressLine1 = custResp.entity.accountProf.CICurStdAddr1Txt;
      indPrimaryInfo.city = custResp.entity.accountProf.Cty;
      indPrimaryInfo.state = custResp.entity.accountProf.St;
      if (custResp.entity.accountProf.CIPrmyPhNbr != null) {
        indPrimaryInfo.phoneNumber = custResp.entity.accountProf.CIPrmyPhNbr;
      } else if (custResp.entity.accountProf.cIScndyPh != null) {
        indPrimaryInfo.phoneNumber = custResp.entity.accountProf.cIScndyPh;
      } else if (custResp.entity.accountProf.CIMobilePhNbr != null) {
        indPrimaryInfo.phoneNumber = custResp.entity.accountProf.CIMobilePhNbr;
      }
      indPrimaryInfo.mdmPartyId = custResp.entity.accountProf.CIPrimCustNbr;
      response.individualInfoLst.add(indPrimaryInfo);
    }
    if (custResp.entity.relatedCustomersLst != null && !custResp.entity.relatedCustomersLst.isEmpty()) {
      for (FISCCGetAccountProfileResponse.RelatedCustomer custDto : custResp.entity.relatedCustomersLst) {
        if (custDto.rltCIRecTypInd == null || custDto.rltCIRecTypInd != 'O') {
          CZMDMIndividualSearchResponse.IndInfo indInfo = new CZMDMIndividualSearchResponse.IndInfo();
          indInfo.firstName = custDto.RltCustCICurFrstNmeKeyFld2;
          indInfo.lastName = custDto.RltCustCICurLstNmeKeyFld1;
          indInfo.SSN = custDto.RltCustCICustTaxNbr;
          indInfo.addressLine1 = custDto.RltCustCICurStdAddr1Txt;
          indInfo.city = custDto.RltCustCty;
          indInfo.state = custDto.RltCustSt;
          if (custDto.RltCustZIP != null && custDto.RltCustZIP.length() > 5) {
            indInfo.zip4Cd = custDto.RltCustZIP.substring(0, 4);
            indInfo.zip5Cd = custDto.RltCustZIP.substring(4, custDto.RltCustZIP.length());
          } else {
            indInfo.zip5Cd = custDto.RltCustZIP;
          }

          if (custDto.RltCustCIPrmyPhNbr != null) {
            indInfo.phoneNumber = custDto.RltCustCIPrmyPhNbr;
          } else if (custDto.rltCustCIScndyPh != null) {
            indInfo.phoneNumber = custDto.rltCustCIScndyPh;
          }
          indInfo.mdmPartyId = custDto.RltCustCIRltApplNbr01;
          response.individualInfoLst.add(indInfo);
        }
      }
    }
    response.status = 'success';
    return response;
  }

  public static CZMDMBusinessCustSearchResponse parseOrgResp(Object resp) {
    CZMDMBusinessCustSearchResponse response = new CZMDMBusinessCustSearchResponse();
    if (resp == null || !(resp instanceof FISCCCustomerSearchResponse)) {
      return response;
    }
    FISCCCustomerSearchResponse custResp = (FISCCCustomerSearchResponse) resp;
    if (custResp.entity == null || custResp.entity.customersLst == null || custResp.entity.customersLst.isEmpty()) {
      response.status = 'failure';
      return response;
    }
    if (custResp.entity.CIMoreToBeReturnedInd == 'Y') {
      response.nextCISStartNumber = custResp.entity.CICustNbrToStrtSearch;
    } else {
      response.nextCISStartNumber = '0';
    }
    for (FISCCCustomerDTO custDto : custResp.entity.customersLst) {
      CZMDMBusinessCustSearchResponse.OrgInfo orgInfo = new CZMDMBusinessCustSearchResponse.OrgInfo();
      orgInfo.businessName = custDto.CICurStdNme01;
      orgInfo.SSN = custDto.CICustTaxNbr;
      orgInfo.addressLine1 = custDto.CICurStdAddr1Txt;
      orgInfo.city = custDto.ElmntCity;
      orgInfo.state = custDto.ElmntState;
      if (custDto.ElmntZip != null && custDto.ElmntZip.length() > 5) {
        orgInfo.zip4Cd = custDto.ElmntZip.substring(0, 4);
        orgInfo.zip5Cd = custDto.ElmntZip.substring(4, custDto.ElmntZip.length());
      } else {
        orgInfo.zip5Cd = custDto.ElmntZip;
      }

      if (custDto.CIPrmyPhNbr != null) {
        orgInfo.phoneNumber = custDto.CIPrmyPhNbr;
      } else if (custDto.ScndyPhn != null) {
        orgInfo.phoneNumber = custDto.ScndyPhn;
      }
      orgInfo.mdmPartyId = custDto.CICustRtnNbr;
      if (custDto.CITypOfBusCde != null) {
        CZTerafinaFisMapping__c orgTypeTfFisMap = CZWTFCHelperRepository.getTFndFISMapping('OrganizationType', custDto.CITypOfBusCde);
        orgInfo.BusinessType = orgTypeTfFisMap != null ? orgTypeTfFisMap.TerafinaValue__c : '';
      }
      response.organizationInfo.add(orgInfo);
    }
    response.status = 'success';
    return response;
  }

  public static CZMDMBusinessCustSearchResponse parseOrgAccountRelatedResp(Object resp) {
    CZMDMBusinessCustSearchResponse response = new CZMDMBusinessCustSearchResponse();
    if (resp == null || !(resp instanceof FISCCGetAccountProfileResponse)) {
      return response;
    }
    FISCCGetAccountProfileResponse custResp = (FISCCGetAccountProfileResponse) resp;
    if (custResp.entity == null || custResp.entity.accountProf == null) {
      response.status = 'failure';
      return response;
    }
    response.nextCISStartNumber = '0';
    if (custResp.entity.accountProf.CIRecTypInd == 'O') {
      CZMDMBusinessCustSearchResponse.OrgInfo orgPrimaryInfo = new CZMDMBusinessCustSearchResponse.OrgInfo();
      orgPrimaryInfo.businessName = custResp.entity.accountProf.CICurStdNme01;
      orgPrimaryInfo.SSN = custResp.entity.accountProf.CICustTaxNbr;
      orgPrimaryInfo.addressLine1 = custResp.entity.accountProf.CICurStdAddr1Txt;
      orgPrimaryInfo.city = custResp.entity.accountProf.Cty;
      orgPrimaryInfo.state = custResp.entity.accountProf.st;
      if (custResp.entity.accountProf.CIPrmyPhNbr != null) {
        orgPrimaryInfo.phoneNumber = custResp.entity.accountProf.CIPrmyPhNbr;
      } else if (custResp.entity.accountProf.cIScndyPh != null) {
        orgPrimaryInfo.phoneNumber = custResp.entity.accountProf.cIScndyPh;
      } else if (custResp.entity.accountProf.CIMobilePhNbr != null) {
        orgPrimaryInfo.phoneNumber = custResp.entity.accountProf.CIMobilePhNbr;
      }
      orgPrimaryInfo.mdmPartyId = custResp.entity.accountProf.CIPrimCustNbr;
      response.organizationInfo.add(orgPrimaryInfo);
    }
    if (custResp.entity.relatedCustomersLst != null && !custResp.entity.relatedCustomersLst.isEmpty()) {
      for (FISCCGetAccountProfileResponse.RelatedCustomer custDto : custResp.entity.relatedCustomersLst) {
        if (custDto.rltCIRecTypInd == 'O') {
          CZMDMBusinessCustSearchResponse.OrgInfo orgInfo = new CZMDMBusinessCustSearchResponse.OrgInfo();
          orgInfo.businessName = custDto.RltCustCICurStdNme01;
          orgInfo.SSN = custDto.RltCustCICustTaxNbr;
          orgInfo.addressLine1 = custDto.RltCustCICurStdAddr1Txt;
          orgInfo.city = custDto.RltCustCty;
          orgInfo.state = custDto.RltCustSt;
          if (custDto.RltCustZIP != null && custDto.RltCustZIP.length() > 5) {
            orgInfo.zip4Cd = custDto.RltCustZIP.substring(0, 4);
            orgInfo.zip5Cd = custDto.RltCustZIP.substring(4, custDto.RltCustZIP.length());
          } else {
            orgInfo.zip5Cd = custDto.RltCustZIP;
          }

          if (custDto.RltCustCIPrmyPhNbr != null) {
            orgInfo.phoneNumber = custDto.RltCustCIPrmyPhNbr;
          } else if (custDto.rltCustCIScndyPh != null) {
            orgInfo.phoneNumber = custDto.rltCustCIScndyPh;
          }
          orgInfo.mdmPartyId = custDto.RltCustCIRltApplNbr01;
          response.organizationInfo.add(orgInfo);
        }
      }
    }
    response.status = 'success';
    return response;
  }

  public static Object fetchApplicantFromFIS(Map<String, Object> params) {
    Object respCustInfo = null;
    Object respCustProf = null;
    Object respCustDD = null;
    Object respCustEmail = null;
    CZWTFCAuthResponse response = new CZWTFCAuthResponse();
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }

      FISCC_Adapter_Configs__mdt adapterConfigCustomerInfo;
      FISCC_Adapter_Configs__mdt adapterConfigCustomerAccProfile;
      FISCC_Adapter_Configs__mdt adapterConfigDueDiligence;
      FISCC_Adapter_Configs__mdt adapterConfigEmail;
      FISCCIntegrationLogService.setCharterConfig((String) params.get('brandCode'));
      if (String.isBlank(FISCCIntegrationLogService.auth)) {
        FISCCIntegrationLogService.auth = FISCCGetAccessTokenProvider.processGetAccessToken(FISCCIntegrationLogService.charterConfig);
      }

      adapterConfigCustomerInfo = fetchAdapterConfigCustInfo(params);
      respCustInfo = FISCCHostAdapter.processHostRequest(null, adapterConfigCustomerInfo, FISCCIntegrationLogService.charterConfig);

      adapterConfigCustomerAccProfile = fetchAdapterConfigCustProfile(params);
      respCustProf = FISCCHostAdapter.processHostRequest(null, adapterConfigCustomerAccProfile, FISCCIntegrationLogService.charterConfig);

      adapterConfigDueDiligence = fetchAdapterConfigCustDD(params);
      respCustDD = FISCCHostAdapter.processHostRequest(null, adapterConfigDueDiligence, FISCCIntegrationLogService.charterConfig);

      adapterConfigEmail = fetchAdapterConfigEmail(params);
      respCustEmail = FISCCHostAdapter.processHostRequest(null, adapterConfigEmail, FISCCIntegrationLogService.charterConfig);

      if (
        respCustInfo != null &&
        respCustProf != null &&
        respCustDD != null &&
        respCustEmail != null &&
        (String) params.get('custType') == 'I'
      ) {
        return parseIndDetailedResp(respCustInfo, respCustProf, respCustDD, respCustEmail, params);
      } else if (
        respCustInfo != null &&
        respCustProf != null &&
        respCustDD != null &&
        respCustEmail != null &&
        (String) params.get('custType') == 'O'
      ) {
        return parseOrgDetailedResp(respCustInfo, respCustProf, respCustDD, respCustEmail, params);
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in fetchIndApplicantFromFIS ' + ex.getStackTraceString());
    }
    response.status = 'failure';
    return response;
  }

  public static FISCC_Adapter_Configs__mdt fetchAdapterConfigCustInfo(Map<String, Object> params) {
    CZWTFCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.INDIVIDUAL, 'CustomerInfo', true);
    FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig('FetchCustomerInfo');

    adapterConfig.ServiceURL__c = adapterConfig.ServiceURL__c.replace(
      '{CIApplNbr}',
      FISCCCommonHelper.encrypt((String) params.get('custNbr'))
    );
    return adapterConfig;
  }

  public static FISCC_Adapter_Configs__mdt fetchAdapterConfigCustProfile(Map<String, Object> params) {
    CZWTFCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.INDIVIDUAL, 'CustomerProfile', true);
    FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig('FetchCustomerProfileWithAcc');

    adapterConfig.ServiceURL__c = adapterConfig.ServiceURL__c.replace(
      '{CIApplNbr}',
      FISCCCommonHelper.encrypt((String) params.get('custNbr'))
    );
    return adapterConfig;
  }

  public static FISCC_Adapter_Configs__mdt fetchAdapterConfigCustDD(Map<String, Object> params) {
    CZWTFCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.INDIVIDUAL, 'CustomerFetchDD', true);
    FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig('FetchDueDiligence');

    adapterConfig.ServiceURL__c = adapterConfig.ServiceURL__c.replace(
      '{CustNbr}',
      FISCCCommonHelper.encrypt((String) params.get('custNbr'))
    );
    return adapterConfig;
  }

  public static FISCC_Adapter_Configs__mdt fetchAdapterConfigEmail(Map<String, Object> params) {
    CZWTFCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.INDIVIDUAL, 'FetchEmailAddress', true);
    FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig('FetchEmailAddress');

    adapterConfig.ServiceURL__c = adapterConfig.ServiceURL__c.replace(
      '{custNbr}',
      FISCCCommonHelper.encrypt((String) params.get('custNbr'))
    );
    return adapterConfig;
  }

  public static CZMDMBusinessCustDetailsResponse parseOrgDetailedResp(
    Object respCustInfo,
    Object respCustProfile,
    Object respFetchDD,
    Object respCustEmail,
    Map<String, Object> params
  ) {
    CZMDMBusinessCustDetailsResponse response = new CZMDMBusinessCustDetailsResponse();
    if (
      respCustInfo == null ||
      !(respCustInfo instanceof FISCCGetCustomerProfileResponse) ||
      respCustProfile == null ||
      !(respCustProfile instanceof FISCCCustomerAccProfileResponse)
    ) {
      return response;
    }

    FISCCGetCustomerProfileResponse responseCustInfo = (FISCCGetCustomerProfileResponse) respCustInfo;
    FISCCCustomerAccProfileResponse responseCustProfile = (FISCCCustomerAccProfileResponse) respCustProfile;

    if (respFetchDD != null && respFetchDD instanceof FISCCFetchDueDiligenceRespDTO) {
      FISCCFetchDueDiligenceRespDTO responseFetchDD = (FISCCFetchDueDiligenceRespDTO) respFetchDD;
      if (responseFetchDD != null && responseFetchDD.Entity != null && responseFetchDD.Entity.dueDiligenceDemographics != null) {
        response.businessInfo.BusinessDescription = responseFetchDD.Entity.dueDiligenceDemographics.descBus;
      }
      response.type = responseFetchDD.Entity.dueDiligenceDemographics.CustType;
    }
    if (responseCustInfo != null && responseCustInfo.entity.customer != null) {
      response.businessInfo.BusinessName = responseCustInfo.entity.customer.CICurStdNme01;
      if (responseCustInfo.entity.customer.CITypOfBusCde != null) {
        response.businessInfo.BusinessType = CZWTFCAuthenticationService.fetchOrgType(responseCustInfo.entity.customer.CITypOfBusCde);
      }

      response.businessInfo.CharterCode = (String) params.get('brandCode');
      response.businessInfo.CISNumber = ((String) params.get('custNbr')).leftPad(11, '0');

      response.businessInfo.EstablishDate = responseCustInfo.entity.customer.CISncDte;

      response.businessInfo.AddressLineOne = responseCustInfo.entity.customer.CICurStdAddr1Txt;
      if (responseCustInfo.entity.customer.CICurStdAddr2Cde != null && responseCustInfo.entity.customer.CICurStdAddr2Cde == 'A') {
        response.businessInfo.AddressLineTwo = responseCustInfo.entity.customer.cICurStdAddr2Txt;
      }
      if (responseCustInfo.entity.customer.CIPrmyPhNbr != null) {
        response.businessInfo.PrimaryPhone = responseCustInfo.entity.customer.CIPrmyPhNbr;
      }
      if (responseCustInfo.entity.customer.CIScndyPh != null) {
        response.businessInfo.SecondaryPhone = responseCustInfo.entity.customer.CIScndyPh;
      }
      response.businessInfo.City = responseCustInfo.entity.customer.Cty;
      response.businessInfo.StateCode = responseCustInfo.entity.customer.St;
      response.businessInfo.ZipCode = responseCustInfo.entity.customer.ZIP;
      response.businessInfo.TaxId = responseCustInfo.entity.customer.CICustTaxNbr;
      if (
        responseCustInfo.entity.customer.CICustTaxCde != null &&
        FISCCIntegrationConstants.BUSINESS_NATIONAL_IDENTITY_MDM_TO_TF_MAP.containsKey(responseCustInfo.entity.customer.CICustTaxCde)
      ) {
        response.businessInfo.TaxIdType = FISCCIntegrationConstants.BUSINESS_NATIONAL_IDENTITY_MDM_TO_TF_MAP.get(
          responseCustInfo.entity.customer.CICustTaxCde
        );
      }
      response.businessInfo.SSN = responseCustInfo.entity.customer.CICustTaxNbr;
      response.businessInfo.NAICSCode = responseCustInfo.entity.customer.CINaicsCde;

      response.businessInfo.SecretWord = responseCustInfo.entity.customer.CIPPwdQuestion;
      response.businessInfo.SecretHint = responseCustInfo.entity.customer.CIPPwd;
      if (responseCustInfo.entity.customer.CIPrmyOffcrNbr != null && responseCustInfo.entity.customer.CIPrmyOffcrNbr != '0') {
        response.businessInfo.PrimaryOficerCode = responseCustInfo.entity.customer.CIPrmyOffcrNbr;
      }

      if (responseCustInfo.entity.customer.CIScndyOffcrNbr != null && responseCustInfo.entity.customer.CIScndyOffcrNbr != '0') {
        response.businessInfo.SecondaryOfficerCode = responseCustInfo.entity.customer.CIScndyOffcrNbr;
      }
      response.businessInfo.CostCenter = responseCustInfo.entity.customer.CICstCntrNbr;
      if (responseCustInfo.entity.customer.CIBrnchNbr != null && responseCustInfo.entity.customer.CIBrnchNbr != '0') {
        String brnchCode = responseCustInfo.entity.customer.CIBrnchNbr;
        tffa__Location__c locObj = CZWTFCHelperRepository.fetchLocationByCode((String) params.get('brandCode') + brnchCode.leftPad(4, '0'));
        if (locObj != null) {
          response.businessInfo.LocationCode = locObj.Id;
        }
      }

      CZMDMBusinessCustDetailsResponse.IdentificationDetails identityDetailsResp = new CZMDMBusinessCustDetailsResponse.IdentificationDetails();
      identityDetailsResp.IdentificationNumber = responseCustInfo.entity.customer.CIPIDNbr1;
      if (responseCustInfo.entity.customer.CIPIDTyp1 != null && responseCustInfo.entity.customer.CIPIDTyp1 != '0') {
        String identityType = responseCustInfo.entity.customer.CIPIDTyp1;
        CZTerafinaFisMapping__c identityMap = CZWTFCHelperRepository.getTFndFISMapping('IdentificationType', identityType);
        if (identityMap != null) {
          identityDetailsResp.IdentificationType = identityMap.TerafinaValue__c;
        }
      }
      identityDetailsResp.IssuingStateCode = responseCustInfo.entity.customer.CIPIDIssLoc1;
      if (responseCustInfo.entity.customer.CIPIDIssDte1 != null) {
        identityDetailsResp.IssueDate = CZWTFCAuthenticationService.validateDate(responseCustInfo.entity.customer.CIPIDIssDte1);
      }

      if (responseCustInfo.entity.customer.CIPIDExpDte1 != null) {
        identityDetailsResp.ExpirationDate = CZWTFCAuthenticationService.validateDate(responseCustInfo.entity.customer.CIPIDExpDte1);
      }
      response.identificationDetails.add(identityDetailsResp);

      if (respCustEmail != null && respCustEmail instanceof CZFetchEmailAddressResponseDTO) {
        CZFetchEmailAddressResponseDTO respEmail = (CZFetchEmailAddressResponseDTO) respCustEmail;
        if (respEmail != null && respEmail.entity.emailaddressesLst != null && !respEmail.entity.emailaddressesLst.isEmpty()) {
          response.businessInfo.EmailId = respEmail.entity.emailaddressesLst[0].EmailAddr;
        }
      }

      if (
        responseCustProfile != null &&
        responseCustProfile.entity.relatedAccountsLst != null &&
        !responseCustProfile.entity.relatedAccountsLst.isEmpty()
      ) {
        for (FISCCCustomerAccProfileResponse.RelatedAccount relatedAcc : responseCustProfile.entity.relatedAccountsLst) {
          CZMDMBusinessCustDetailsResponse.AccountList acc = new CZMDMBusinessCustDetailsResponse.AccountList();
          acc.AccountNumber = relatedAcc.DPAcctNbr;
          if (
            CZWTFCAuthenticationService.wintrustEnvConfig != null &&
            CZWTFCAuthenticationService.wintrustEnvConfig.IsTestEnv__c &&
            relatedAcc.CIRltBnkNbr1 == '889'
          ) {
            acc.CharterCode = (String) params.get('brandCode');
          } else {
            acc.CharterCode = relatedAcc.CIRltBnkNbr1;
          }

          acc.AccountCreationDate = relatedAcc.CIRltEffDte;
          acc.AccountCategory = relatedAcc.CIRltApplCde1;
          acc.ProductCode = relatedAcc.DPAcctTyp;
          acc.ProductName = relatedAcc.DPStmtMrktNme;
          acc.AccountType = relatedAcc.CIRltApplCde1 + '|' + relatedAcc.DPCategory;
          acc.RelationshipCode = relatedAcc.CIEnt2ToEnt1RltCde.leftPad(3, '0');
          if (CZWTFCAuthenticationService.applicantRoleMap != null && CZWTFCAuthenticationService.brandNameMap != null) {
            acc.relationshipName = CZWTFCAuthenticationService.applicantRoleMap.containsKey(acc.RelationshipCode)
              ? CZWTFCAuthenticationService.applicantRoleMap.get(acc.RelationshipCode)
              : '';
            acc.CharterName = CZWTFCAuthenticationService.brandNameMap.containsKey(acc.CharterCode)
              ? CZWTFCAuthenticationService.brandNameMap.get(acc.CharterCode)
              : '';
          }
          response.accountList.add(acc);
        }
        response.isSuccess = true;
      }
    }

    return response;
  }

  public static CZWTFCAuthResponse parseIndDetailedResp(
    Object respCustInfo,
    Object respCustProfile,
    Object respFetchDD,
    Object respCustEmail,
    Map<String, Object> params
  ) {
    CZWTFCAuthResponse response = new CZWTFCAuthResponse();
    if (
      respCustInfo == null ||
      !(respCustInfo instanceof FISCCGetCustomerProfileResponse) ||
      respCustProfile == null ||
      !(respCustProfile instanceof FISCCCustomerAccProfileResponse)
    ) {
      return response;
    }

    FISCCGetCustomerProfileResponse responseCustInfo = (FISCCGetCustomerProfileResponse) respCustInfo;
    FISCCCustomerAccProfileResponse responseCustProfile = (FISCCCustomerAccProfileResponse) respCustProfile;

    if (responseCustInfo != null && responseCustInfo.entity.customer != null) {
      if (responseCustInfo.entity.customer.CIFrstNmeMidInitl != null) {
        response = parseIndName(response, responseCustInfo.entity.customer.CIFrstNmeMidInitl);
      }

      response.custInfo.LastName = responseCustInfo.entity.customer.CISrnme;
      response.custInfo.AddressLineOne = responseCustInfo.entity.customer.CICurStdAddr1Txt;
      if (responseCustInfo.entity.customer.CICurStdAddr2Cde != null && responseCustInfo.entity.customer.CICurStdAddr2Cde == 'A') {
        response.custInfo.AddressLineTwo = responseCustInfo.entity.customer.cICurStdAddr2Txt;
      }
      if (responseCustInfo.entity.customer.CIPrmyPhNbr != null) {
        response.custInfo.PrimaryPhone = responseCustInfo.entity.customer.CIPrmyPhNbr;
      }
      if (responseCustInfo.entity.customer.CIScndyPh != null) {
        response.custInfo.SecondaryPhone = responseCustInfo.entity.customer.CIScndyPh;
      }
      response.custInfo.CharterCode = (String) params.get('brandCode');
      response.custInfo.CISNumber = ((String) params.get('custNbr')).leftPad(11, '0');
      response.custInfo.CISStartDate = responseCustInfo.entity.customer.CISncDte;
      response.custInfo.City = responseCustInfo.entity.customer.Cty;
      response.custInfo.State = responseCustInfo.entity.customer.St;
      response.custInfo.ZipCode = responseCustInfo.entity.customer.ZIP;
      if (responseCustInfo.entity.customer.CtryCde != null) {
        CZTerafinaFisMapping__c addressTfFisMap = CZWTFCHelperRepository.getTFndFISMapping(
          'AddressCountry',
          responseCustInfo.entity.customer.CtryCde
        );
        response.custInfo.Country = addressTfFisMap != null ? addressTfFisMap.TerafinaValue__c : '';
      }
      response.custInfo.TaxId = responseCustInfo.entity.customer.CICustTaxNbr;
      if (
        responseCustInfo.entity.customer.CICustTaxCde != null &&
        FISCCIntegrationConstants.BUSINESS_NATIONAL_IDENTITY_MDM_TO_TF_MAP.containsKey(responseCustInfo.entity.customer.CICustTaxCde)
      ) {
        response.custInfo.TaxIdType = FISCCIntegrationConstants.BUSINESS_NATIONAL_IDENTITY_MDM_TO_TF_MAP.get(
          responseCustInfo.entity.customer.CICustTaxCde
        );
      }

      response.custInfo.SSN = responseCustInfo.entity.customer.CICustTaxNbr;
      response.custInfo.EmployeeName = responseCustInfo.entity.customer.CICustEmpltSchl;
      response.custInfo.SecretWord = responseCustInfo.entity.customer.CIPPwdQuestion;
      response.custInfo.SecretHint = responseCustInfo.entity.customer.CIPPwd;
      if (responseCustInfo.entity.customer.CIPrmyOffcrNbr != null && responseCustInfo.entity.customer.CIPrmyOffcrNbr != '0') {
        response.custInfo.PrimaryOficerCode = responseCustInfo.entity.customer.CIPrmyOffcrNbr;
      }

      if (responseCustInfo.entity.customer.CIScndyOffcrNbr != null && responseCustInfo.entity.customer.CIScndyOffcrNbr != '0') {
        response.custInfo.SecondaryOfficerCode = responseCustInfo.entity.customer.CIScndyOffcrNbr;
      }
      response.custInfo.CostCenter = responseCustInfo.entity.customer.CICstCntrNbr;
      if (responseCustInfo.entity.customer.CIBrnchNbr != null && responseCustInfo.entity.customer.CIBrnchNbr != '0') {
        String brnchCode = responseCustInfo.entity.customer.CIBrnchNbr;
        tffa__Location__c locObj = CZWTFCHelperRepository.fetchLocationByCode((String) params.get('brandCode') + brnchCode.leftPad(4, '0'));
        if (locObj != null) {
          response.custInfo.LocationCode = locObj.Id;
        }
      }
      if (responseCustInfo.entity.customer.CICurNmeSfxCde != null) {
        String suffixcode = responseCustInfo.entity.customer.CICurNmeSfxCde;
        CZTerafinaFisMapping__c suffixMap = CZWTFCHelperRepository.getTFndFISMapping('Suffix', suffixcode);
        if (suffixMap != null) {
          response.custInfo.Suffix = suffixMap.TerafinaValue__c;
        }
      }
      CZWTFCAuthResponse.IdentificationDetails identityDetailsResp = new CZWTFCAuthResponse.IdentificationDetails();
      identityDetailsResp.IdentificationNumber = responseCustInfo.entity.customer.CIPIDNbr1;
      if (responseCustInfo.entity.customer.CIPIDTyp1 != null && responseCustInfo.entity.customer.CIPIDTyp1 != '0') {
        String identityType = responseCustInfo.entity.customer.CIPIDTyp1;
        CZTerafinaFisMapping__c identityMap = CZWTFCHelperRepository.getTFndFISMapping('IdentificationType', identityType);
        if (identityMap != null) {
          identityDetailsResp.IdentificationType = identityMap.TerafinaValue__c;
        }
      }
      identityDetailsResp.IssuingStateCode = responseCustInfo.entity.customer.CIPIDIssLoc1;
      if (responseCustInfo.entity.customer.CIPIDIssDte1 != null) {
        identityDetailsResp.IssueDate = CZWTFCAuthenticationService.validateDate(responseCustInfo.entity.customer.CIPIDIssDte1);
      }

      if (responseCustInfo.entity.customer.CIPIDExpDte1 != null) {
        identityDetailsResp.ExpirationDate = CZWTFCAuthenticationService.validateDate(responseCustInfo.entity.customer.CIPIDExpDte1);
      }

      response.custInfo.identificationDetails.add(identityDetailsResp);

      if (respFetchDD != null && respFetchDD instanceof FISCCFetchDueDiligenceRespDTO) {
        FISCCFetchDueDiligenceRespDTO responseFetchDD = (FISCCFetchDueDiligenceRespDTO) respFetchDD;

        if (responseFetchDD != null && responseFetchDD.Entity != null && responseFetchDD.Entity.dueDiligenceDemographics != null) {
          response.custInfo.Title = responseFetchDD.Entity.dueDiligenceDemographics.Title;
          response.custInfo.OccupationCode = responseCustInfo.entity.customer.CIOccpnCde;
          if (responseFetchDD.Entity.dueDiligenceDemographics.fullTime == 'R') {
            response.custInfo.EmploymentStatusCode = 'RETIRED';
          } else if (responseFetchDD.Entity.dueDiligenceDemographics.fullTime == 'U') {
            response.custInfo.EmploymentStatusCode = 'UNEMPLOYED';
          }

          if (
            responseFetchDD.Entity.dueDiligenceDemographics.RsdntPrsn != null &&
            responseFetchDD.Entity.dueDiligenceDemographics.RsdntPrsn == 'Y'
          ) {
            response.custInfo.Citizenship = CZWTFCConstants.RESIDENT;
          } else {
            if (
              responseCustInfo.entity.customer.CtryCde != null &&
              (responseCustInfo.entity.customer.CtryCde == 'USA' ||
              responseCustInfo.entity.customer.CtryCde == 'US')
            ) {
              response.custInfo.Citizenship = CZWTFCConstants.CITIZEN;
            } else {
              response.custInfo.Citizenship = CZWTFCConstants.NONRESIDENT;
            }
          }
        }
        response.type = responseFetchDD.Entity.dueDiligenceDemographics.CustType;
      }
      if (respCustEmail != null && respCustEmail instanceof CZFetchEmailAddressResponseDTO) {
        CZFetchEmailAddressResponseDTO respEmail = (CZFetchEmailAddressResponseDTO) respCustEmail;
        if (respEmail != null && respEmail.entity.emailaddressesLst != null && !respEmail.entity.emailaddressesLst.isEmpty()) {
          response.custInfo.EmailId = respEmail.entity.emailaddressesLst[0].EmailAddr;
        }
      }
      if (
        responseCustProfile != null &&
        responseCustProfile.entity.relatedAccountsLst != null &&
        !responseCustProfile.entity.relatedAccountsLst.isEmpty()
      ) {
        response.custInfo.DateOfBirth = responseCustProfile.entity.custProfile.CIBirthdate;
        for (FISCCCustomerAccProfileResponse.RelatedAccount relatedAcc : responseCustProfile.entity.relatedAccountsLst) {
          CZWTFCAuthResponse.AccountList acc = new CZWTFCAuthResponse.AccountList();
          acc.AccountNumber = relatedAcc.DPAcctNbr;
          if (
            CZWTFCAuthenticationService.wintrustEnvConfig != null &&
            CZWTFCAuthenticationService.wintrustEnvConfig.IsTestEnv__c &&
            relatedAcc.CIRltBnkNbr1 == '889'
          ) {
            acc.CharterCode = (String) params.get('brandCode');
          } else {
            acc.CharterCode = relatedAcc.CIRltBnkNbr1;
          }

          acc.AccountCreationDate = relatedAcc.CIRltEffDte;
          acc.AccountCategory = relatedAcc.CIRltApplCde1;
          acc.ProductCode = relatedAcc.DPAcctTyp;
          acc.ProductName = relatedAcc.DPStmtMrktNme;
          acc.AccountType = relatedAcc.CIRltApplCde1 + '|' + relatedAcc.DPCategory;
          acc.RelationshipCode = relatedAcc.CIEnt2ToEnt1RltCde.leftPad(3, '0');
          if (CZWTFCAuthenticationService.applicantRoleMap != null && CZWTFCAuthenticationService.brandNameMap != null) {
            acc.relationshipName = CZWTFCAuthenticationService.applicantRoleMap.containsKey(acc.RelationshipCode)
              ? CZWTFCAuthenticationService.applicantRoleMap.get(acc.RelationshipCode)
              : '';
            acc.CharterName = CZWTFCAuthenticationService.brandNameMap.containsKey(acc.CharterCode)
              ? CZWTFCAuthenticationService.brandNameMap.get(acc.CharterCode)
              : '';
          }
          response.accountList.add(acc);
        }
        response.status = 'success';
      }
    }
    return response;
  }

  public static CZWTFCAuthResponse parseIndName(CZWTFCAuthResponse resp, String name) {
    List<String> indName = name.split(' ');
    String firstname = '';
    String middlename = '';
    if (indName != null && !indName.isEmpty()) {
      if (indName.size() == 1) {
        resp.custInfo.FirstName = indName[0];
        return resp;
      }
      for (Integer i = 0; i < indName.size() - 1; i++) {
        if (String.isBlank(firstname)) {
          firstname = firstname + indName[i];
        } else {
          firstname = firstname + ' ' + indName[i];
        }
      }
      if (indName.size() > 1) {
        middlename = indName[indName.size() - 1];
      }
    }
    resp.custInfo.FirstName = firstname;
    resp.custInfo.MiddleName = middlename;
    return resp;
  }
}