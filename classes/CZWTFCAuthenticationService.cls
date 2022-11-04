public with sharing class CZWTFCAuthenticationService {
  @TestVisible
  private static boolean testException = false;

  public static WintrustEnvConfig__mdt wintrustEnvConfig = CZWTFCHelperRepository.fetchWintrustEnvConfig();

  public static Map<String, String> brandNameMap = CZWTFCBrandRepository.fetchBrandCodeAndName();

  public static Map<String, String> applicantRoleMap = CZWTFCHelperRepository.fetchApplicantRoleMap();

  public static String brandCode = '';
  public static CZWTFCAuthResponse verifyUser(Map<String, String> params) {
    tffa.Logger.debug('In CZWTFCAuthenticationService verifyUser ' + params);

    if (params.containsKey('isDebitCardProductSelected') && params.get('isDebitCardProductSelected') == 'Y') {
      return fetchIndFromFIS(params);
    }
    String method = params.get('method');
    params.put('type', getLoginType(method));
    String authType = params.get('authType');
    String apiMethod;
    if (authType.equalsIgnoreCase('ind-1')) {
      apiMethod = 'Account Based Authentication';
    } else if (authType.equalsIgnoreCase('ind-2')) {
      apiMethod = 'Card Based Authentication';
    } else if (authType.equalsIgnoreCase('ind-3')) {
      apiMethod = 'Existing Customer Check';
    } else if (authType.equalsIgnoreCase('ind-4')) {
      apiMethod = 'Fetch Individual customer';
    }
    brandCode = params.get('brandCode');
    if (!params.containsKey('D3Login')) {
      CZWTFCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.CUSTOMER, apiMethod, true);
    }
    MuleSoft_Adapter_Config__mdt adapterConfig = CZWTFCHelperRepository.fetchMulesoftAdapterConfig('CustomerValidation');
    adapterConfig.VerificationScenario__c = authType;
    if (method == 'LOAN_ACCOUNT') {
      adapterConfig.ProdCategory__c = 'LN';
    } else if (method == 'DP_ACCOUNT') {
      adapterConfig.ProdCategory__c = 'DP';
    }

    CZMDMAuthenticationRequest mdmAuthReq = generateRespDTO(params, authType);
    CZWTFCAuthResponse response = new CZWTFCAuthResponse();
    CZMDMAuthenticationResponseDTO authResp;
    //auth token and API call
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      if (!Test.isRunningTest()) {
        CZMulesoftAdapter.auth = CZWTFCMulesoftOAuthProvider.getAuthHeader();
      }
      String strReq = System.JSON.serialize(mdmAuthReq, true);
      if (params.containsKey('D3Login')) {
        adapterConfig.LogRequest__c = false;
        adapterConfig.LogResponse__c = false;
      }
      Object resp = CZMulesoftAdapter.invokeAPI(strReq, adapterConfig);
      if (resp != null) {
        authResp = (CZMDMAuthenticationResponseDTO) resp;
        if (authResp.status.equalsIgnoreCase('success')) {
          response = parseResponse(response, authResp);
          if (!params.containsKey('D3Login')) {
            CZWTFCIntegrationLogService.setLogItemOk(params.get('type'));
          }
        } else {
          response.status = 'failure';
          if (!params.containsKey('D3Login')) {
            CZWTFCIntegrationLogService.setLogItemFailed(params.get('type'));
          }
        }
      }
    } catch (Exception ex) {
      response.status = 'failure';
      if (!params.containsKey('D3Login')) {
        CZWTFCIntegrationLogService.setLogItemFailed(params.get('type'));
      }
      tffa.Logger.error('Exep in CZWTFCAuthenticationService ' + ex.getMessage() + ' ' + ex.getStackTraceString());
    }

    /**
     * Check is OLB Enrolled
     */
    try {
      if (authResp != null && authResp.status == 'success' && authType == 'ind-1' || authType == 'ind-2') {
        CZWTFCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.OLB_CHECK, authResp.customerInfo.frstNme, true);
        if (CZWTFCOLBEnrollmentCheckService.checkIfOLBIsEnrolled(authResp.prtyId)) {
          response.custInfo.IsOLBEnrolled = true;
        }
        CZWTFCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.OLB_CHECK);
      }
    } catch (Exception ex) {
      CZWTFCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.OLB_CHECK);
      tffa.Logger.error('Exep in CZWTFCAuthenticationService olb check ' + ex.getMessage() + ' ' + ex.getStackTraceString());
    }
    return response;
  }

  public static CZMDMAuthenticationRequest generateRespDTO(Map<String, String> params, String authType) {
    CZMDMAuthenticationRequest authReq = new CZMDMAuthenticationRequest();
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      String method = params.get('method');
      if (authType.equalsIgnoreCase('ind-1')) {
        authReq.frstNme = params.get('frstNme');
        authReq.lstNme = params.get('lstNme');
        authReq.birthDte = params.get('birthDte');
        authReq.ssnNmb = params.get('ssnNmb');

        if (params.get('acctNmb') != null) {
          String accNumbr = params.get('acctNmb');
          if (accNumbr.contains('-')) {
            List<String> accNbrSplitLst = accNumbr.split('-');
            authReq.acctNmb = accNbrSplitLst[0].leftPad(11, '0');
            if (accNbrSplitLst.size() > 1) {
              authReq.acctNmb = authReq.acctNmb + '-' + accNbrSplitLst[1];
            }
          } else {
            authReq.acctNmb = params.get('acctNmb').leftPad(11, '0');
          }
        }

        if (method == 'DP_ACCOUNT') {
          authReq.lstDepAmt = Decimal.valueOf(params.get('amnt'));
        } else if (method == 'LOAN_ACCOUNT') {
          authReq.lstPayAmt = Decimal.valueOf(params.get('amnt'));
        }
      } else if (authType.equalsIgnoreCase('ind-2')) {
        authReq.frstNme = params.get('frstNme');
        authReq.lstNme = params.get('lstNme');
        authReq.ssnNmb = params.get('ssnNmb');
        authReq.debitCrdCvv = params.get('debitCrdCvv');
        authReq.debitCrdlast4 = params.get('debitCrdlast4');
        authReq.debitCrdPin = params.get('debitCrdPin');
      } else if (authType.equalsIgnoreCase('ind-3')) {
        authReq.lstNme = params.get('lstNme');
        authReq.ssnNmb = params.get('ssnNmb');
      } else if (authType.equalsIgnoreCase('ind-4')) {
        authReq.mdmPartyId = params.get('mdmPartyId');
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in CZMDMAuthenticationRequest ' + ex.getMessage() + ' ' + ex.getStackTraceString());
    }
    return authReq;
  }

  public static CZWTFCAuthResponse parseResponse(CZWTFCAuthResponse resp, CZMDMAuthenticationResponseDTO apiResponseDTO) {
    tffa.Logger.debug('Parse Response Auth Flow ' + apiResponseDTO);
    List<String> accountTypeExceptionReqLst = new List<String>{ 'DP|D', 'DP|N' };
    Set<String> accountTypesKYCReq = new Set<String>{ 'DP|D', 'DP|N', 'DP|S', 'DP|M' };
    resp.custInfo.IsExceptionPlanRequired = true;
    resp.custInfo.IsCrossCharterCustomer = false;
    resp.custInfo.IsExistingCustomer = false;
    resp.custInfo.IsKYCRequired = true;
    resp.status = apiResponseDTO.status;
    resp.isSuccess = true;
    resp.globalCustomerId = apiResponseDTO.prtyId;
    resp.custInfo.FirstName = apiResponseDTO.customerInfo.frstNme;
    resp.custInfo.MiddleName = apiResponseDTO.customerInfo.mdlNme;
    resp.custInfo.LastName = apiResponseDTO.customerInfo.lstNme;
    resp.custInfo.AddressLineOne = apiResponseDTO.customerInfo.addrsLn1;
    resp.custInfo.AddressLineTwo = apiResponseDTO.customerInfo.addrsLn2;
    resp.custInfo.City = apiResponseDTO.customerInfo.city;
    resp.custInfo.State = apiResponseDTO.customerInfo.stateCd;
    resp.custInfo.ZipCode = apiResponseDTO.customerInfo.zipCd;
    if (CZWTFCConstants.SUFFIX_MAP.containsKey(apiResponseDTO.customerInfo.suffix))
      resp.custInfo.Suffix = CZWTFCConstants.SUFFIX_MAP.get(apiResponseDTO.customerInfo.suffix);
    else
      resp.custInfo.Suffix = apiResponseDTO.customerInfo.suffix;

    if (apiResponseDTO.customerInfo.country != null) {
      CZTerafinaFisMapping__c addressTfFisMap = CZWTFCHelperRepository.getTFndFISMapping(
        'AddressCountry',
        apiResponseDTO.customerInfo.country
      );
      resp.custInfo.Country = addressTfFisMap != null ? addressTfFisMap.TerafinaValue__c : '';
    }

    if (String.isNotBlank(apiResponseDTO.customerInfo.primPhNmb)) {
      resp.custInfo.PrimaryPhone = processPhnNbr(apiResponseDTO.customerInfo.primPhNmb);
    }

    if (String.isNotBlank(apiResponseDTO.customerInfo.scndryPhNmb)) {
      resp.custInfo.SecondaryPhone = processPhnNbr(apiResponseDTO.customerInfo.scndryPhNmb);
    }
    if (String.isNotBlank(apiResponseDTO.customerInfo.mblPhNmb)) {
      resp.custInfo.CellPhoneNo = processPhnNbr(apiResponseDTO.customerInfo.mblPhNmb);
    }

    resp.custInfo.EmailId = apiResponseDTO.customerInfo.psnlEmailId;

    if (apiResponseDTO.customerInfo.birthDte != null) {
      try {
        resp.custInfo.DateOfBirth = validateDate(apiResponseDTO.customerInfo.birthDte);
      } catch (Exception ex) {
        tffa.Logger.error('Exception in DOB for Auth Customer');
      }
    }

    resp.custInfo.SSN = apiResponseDTO.customerInfo.ssnNmb;
    if (
      apiResponseDTO.customerInfo.taxIdType != null &&
      FISCCIntegrationConstants.NATIONAL_IDENTITY_MDM_TO_TF_MAP.containsKey(apiResponseDTO.customerInfo.taxIdType)
    ) {
      resp.custInfo.TaxId = apiResponseDTO.customerInfo.taxId;
      resp.custInfo.TaxIdType = FISCCIntegrationConstants.NATIONAL_IDENTITY_MDM_TO_TF_MAP.get(apiResponseDTO.customerInfo.taxIdType);
    }

    if (apiResponseDTO.customerInfo.ctzshp == 'Y') {
      resp.custInfo.Citizenship = CZWTFCConstants.CITIZEN;
    } else {
      if (resp.custInfo.Country != null && (resp.custInfo.Country == 'USA' || resp.custInfo.Country == 'US')) {
        resp.custInfo.Citizenship = CZWTFCConstants.RESIDENT;
      } else {
        resp.custInfo.Citizenship = CZWTFCConstants.NONRESIDENT;
      }
    }
    String empCode = '';
    if (apiResponseDTO.customerInfo.emplyStatCd != null) {
      CZTerafinaFisMapping__c empMap = CZWTFCHelperRepository.getTFndFISMapping('EmploymentType', apiResponseDTO.customerInfo.emplyStatCd);

      resp.custInfo.EmploymentStatusCode = empMap != null ? empMap.TerafinaValue__c : null;
    }

    List<String> homeMakerLst = new List<String>{ '026', '26', 'H', 'h' };
    List<String> studentLst = new List<String>{ '023', '23', 'S', 's' };
    String occCode = '';
    if (apiResponseDTO.customerInfo.occpCd != null) {
      String respOcc = apiResponseDTO.customerInfo.occpCd;
      respOcc = respOcc.leftPad(3, '0');
      occCode = CZWTFCCommonHelper.getOccupationLabel(respOcc);
      if (
        (homeMakerLst.contains(respOcc) || homeMakerLst.contains(apiResponseDTO.customerInfo.occpCd)) &&
        (resp.custInfo.EmploymentStatusCode == null ||
        resp.custInfo.EmploymentStatusCode == 'UNEMPLOYED' ||
        resp.custInfo.EmploymentStatusCode == 'U')
      ) {
        resp.custInfo.EmploymentStatusCode = 'HOMEMAKER';
        resp.custInfo.OccupationCode = '027';
      } else if (
        (studentLst.contains(apiResponseDTO.customerInfo.occpCd) || studentLst.contains(respOcc)) &&
        (resp.custInfo.EmploymentStatusCode == null ||
        resp.custInfo.EmploymentStatusCode == 'UNEMPLOYED' ||
        resp.custInfo.EmploymentStatusCode == 'U')
      ) {
        resp.custInfo.EmploymentStatusCode = 'STUDENT';
        resp.custInfo.OccupationCode = '023';
      } else if (String.isNotBlank(occCode)) {
        resp.custInfo.OccupationCode = respOcc;
        if (String.isBlank(resp.custInfo.EmploymentStatusCode)) {
          resp.custInfo.EmploymentStatusCode = 'FULLTIME';
        }
      }
    }

    resp.custInfo.Title = apiResponseDTO.customerInfo.emplyTitle;
    resp.custInfo.EmployeeName = apiResponseDTO.customerInfo.emplyNme;

    //Set missing Flag
    if (
      String.isBlank(resp.custInfo.PrimaryPhone) &&
      String.isBlank(resp.custInfo.SecondaryPhone) &&
      String.isBlank(resp.custInfo.CellPhoneNo)
    ) {
      resp.custInfo.IsPhoneNumberMissing = true;
    } else {
      resp.custInfo.IsPhoneNumberMissing = false;
    }

    if (String.isBlank(resp.custInfo.EmailId)) {
      resp.custInfo.IsEmailIdMissing = true;
    } else {
      resp.custInfo.IsEmailIdMissing = false;
    }

    if (resp.custInfo.DateOfBirth == null) {
      resp.custInfo.IsDobMissing = true;
    } else {
      resp.custInfo.IsDobMissing = false;
    }

    if (apiResponseDTO.customerInfo.platMemSt != null) {
      resp.custInfo.HasPlatinumMembership = apiResponseDTO.customerInfo.platMemSt == 'N' ? false : true;
    }

    if (apiResponseDTO.customerInfo.isEmp != null) {
      resp.custInfo.IsEmployee = apiResponseDTO.customerInfo.isEmp == 'N' ? false : true;
    }

    if (apiResponseDTO.customerInfo.jrSvrsMbrshpFlag != null) {
      resp.custInfo.HasJuniorMembership = apiResponseDTO.customerInfo.jrSvrsMbrshpFlag == 'N' ? false : true;
    }

    if (apiResponseDTO.customerInfo.idtfrLst != null && !apiResponseDTO.customerInfo.idtfrLst.isEmpty()) {
      for (CZMDMAuthenticationResponseDTO.IdtfrLst idtObj : apiResponseDTO.customerInfo.idtfrLst) {
        String idTypeCode = '';
        String identificationCode = '';
        if (idtObj.idtfrTypCd != null) {
          String identityType = FISCCIntegrationConstants.IDENTITY_MDM_TO_TF_MAP.containsKey(idtObj.idtfrTypCd)
            ? FISCCIntegrationConstants.IDENTITY_MDM_TO_TF_MAP.get(idtObj.idtfrTypCd)
            : null;
          if (identityType != null) {
            idTypeCode = CZWTFCCommonHelper.getIdentificationLabel(identityType);
            identificationCode = String.isNotBlank(idTypeCode) ? identityType : null;
          }
        }

        if (String.isNotBlank(identificationCode)) {
          CZWTFCAuthResponse.IdentificationDetails identityDetailObj = new CZWTFCAuthResponse.IdentificationDetails();
          identityDetailObj.IdentificationNumber = idtObj.idtfrNmb;
          identityDetailObj.IdentificationType = identificationCode;
          try {
            identityDetailObj.IssueDate = idtObj.issueDte != null ? validateDate(idtObj.issueDte) : null;
          } catch (Exception ex) {
            tffa.Logger.error('Error in Parsing issue date : ' + ex.getMessage() + ex.getStackTraceString());
            identityDetailObj.IssueDate = null;
          }

          try {
            identityDetailObj.ExpirationDate = idtObj.expDte != null ? validateDate(idtObj.expDte) : null;
          } catch (Exception exp) {
            tffa.Logger.error('Error in Parsing Exp date: ' + exp.getMessage() + exp.getStackTraceString());
            identityDetailObj.ExpirationDate = null;
          }

          identityDetailObj.IssuingStateCode = idtObj.issueStateCd;
          resp.custInfo.identificationDetails.add(identityDetailObj);
        }
      }
    }

    if (apiResponseDTO.customerRcdLst != null && !apiResponseDTO.customerRcdLst.isEmpty()) {
      for (CZMDMAuthenticationResponseDTO.CustomerRcdLst custObj : apiResponseDTO.customerRcdLst) {
        if (custObj.chrtrCd.equalsIgnoreCase(brandCode) || ((custObj.chrtrCd).equalsIgnoreCase('889') && wintrustEnvConfig.IsTestEnv__c)) {
          resp.custInfo.CISNumber = custObj.cisNmb.leftPad(11, '0');
          resp.custInfo.CharterCode = brandCode;
          resp.custInfo.CISStartDate = custObj.cisStrtDte;
          resp.custInfo.PrimaryOficerCode = custObj.primOffcrCd == '1000' ? '' : custObj.primOffcrCd;
          resp.custInfo.SecondaryOfficerCode = custObj.scndyOffcrNbr == '1000' ? '' : custObj.scndyOffcrNbr;
          resp.custInfo.SecretWord = custObj.pwdValue;
          resp.custInfo.SecretHint = custObj.pwdQuestion;
          resp.custInfo.CostCenter = custObj.costCntr;
          if (custObj.brnchCd != null) {
            tffa__Location__c locObj = CZWTFCHelperRepository.fetchLocationByCode(brandCode + custObj.brnchCd.leftPad(4, '0'));
            if (locObj != null) {
              resp.custInfo.LocationCode = locObj.Id;
            }
          }
          // resp.custInfo.LocationCode = 'a1F1h0000016NHqEAM'; //brandCode + custObj.brnchCd.leftPad(4, '0');
          resp.custInfo.IsExistingCustomer = true;
        }
        CZWTFCAuthResponse.CustomerCiISRecord cisRecord = new CZWTFCAuthResponse.CustomerCiISRecord();
        String cisbrand = custObj.chrtrCd;
        if (((cisbrand).equalsIgnoreCase('889') && wintrustEnvConfig.IsTestEnv__c)) {
          cisbrand = brandCode;
        }
        if (custObj.isFounder != null) {
          resp.custInfo.IsFounder = custObj.isFounder == 'Y' ? true : false;
        }
        cisRecord.charterName = brandNameMap.containsKey(cisbrand) ? brandNameMap.get(cisbrand) : '';
        cisRecord.cisNbr = custObj.cisNmb.leftPad(11, '0');
        cisRecord.cisStartDate = custObj.cisStrtDte;
        cisRecord.primaryOfrNbr = custObj.primOffcrCd;
        resp.cisLst.add(cisRecord); /* this is used for search only */
      }
      if (String.isBlank(resp.custInfo.CISNumber)) {
        resp.custInfo.IsCrossCharterCustomer = true;
      }
    }
    /*
    if (apiResponseDTO.passwordPhase != null && !apiResponseDTO.passwordPhase.isEmpty()) {
      for (CZMDMAuthenticationResponseDTO.PasswordHint passwordObj : apiResponseDTO.passwordPhase) {
        if (
          passwordObj.chrtrCd.equalsIgnoreCase(brandCode) ||
          ((passwordObj.chrtrCd).equalsIgnoreCase('889') && wintrustEnvConfig.IsTestEnv__c)
        ) {
          resp.custInfo.password = passwordObj.pwdQuestion;
          resp.custInfo.passwordHint = passwordObj.pwdValue;
        }
      }
    }
    */
    Date currentDate = Date.today();
    Date compareDate = currentDate.addDays(-30);
    if (apiResponseDTO.acctLst != null && !apiResponseDTO.acctLst.isEmpty()) {
      for (CZMDMAuthenticationResponseDTO.AcctLst acctObj : apiResponseDTO.acctLst) {
        if (acctObj.acctCtgry == 'DP' && acctObj.acctstatus != null && !acctObj.acctstatus.equalsIgnoreCase('Closed')) {
          CZWTFCAuthResponse.AccountList accDetailObj = new CZWTFCAuthResponse.AccountList();
          accDetailObj.AccountNumber = acctObj.acctNmb;
          accDetailObj.AccountCategory = acctObj.acctCtgry;
          accDetailObj.CharterCode = (acctObj.chrtrCd.equalsIgnoreCase('889') && wintrustEnvConfig.IsTestEnv__c)
            ? brandCode
            : acctObj.chrtrCd;
          accDetailObj.AccountCreationDate = acctObj.acctCreationDte;
          accDetailObj.ProductCode = acctObj.pdtCd;
          accDetailObj.ProductName = acctObj.pdtNm;
          accDetailObj.AccountType = acctObj.acctTyp;
          accDetailObj.OwnershipCode = acctObj.ownrshpCd;
          accDetailObj.RelationshipCode = acctObj.rltnshpCd;
          accDetailObj.mdmPartyId = apiResponseDTO.prtyId;
          accDetailObj.relationshipName = applicantRoleMap.containsKey(acctObj.rltnshpCd) ? applicantRoleMap.get(acctObj.rltnshpCd) : '';
          accDetailObj.CharterName = brandNameMap.containsKey(accDetailObj.CharterCode) ? brandNameMap.get(accDetailObj.CharterCode) : '';
          resp.accountList.add(accDetailObj);

          if (acctObj.acctCreationDte != null) {
            Date accDate = Date.valueOf(acctObj.acctCreationDte);
            if (compareDate > accDate && accountTypeExceptionReqLst.contains(acctObj.acctTyp)) {
              resp.custInfo.IsExceptionPlanRequired = false;
            }
            if (resp.custInfo.DateOfBirth != null) {
              Date custBirthDate = Date.valueOf(resp.custInfo.DateOfBirth);
              if (
                resp.custInfo.IsKYCRequired &&
                accDate != null &&
                ((custBirthDate.daysBetween(accDate) / 365) >= 18) &&
                accDetailObj.AccountType != null &&
                accountTypesKYCReq.contains(accDetailObj.AccountType)
              ) {
                resp.custInfo.IsKYCRequired = false;
              }
            }
          }
        }
      }
    }
    return resp;
  }
  public static String getLoginType(String method) {
    if (method == 'DP_ACCOUNT') {
      return 'Authentication Using DP_ACCOUNT';
    } else if (method == 'LOAN_ACCOUNT') {
      return 'Authentication Using LOAN_ACCOUNT';
    } else if (method == 'DEBIT_CARD') {
      return 'Authentication Using DEBIT_CARD';
    } else if (method == 'CUSTOMER_SEARCH') {
      return 'Customer Search';
    }
    return '';
  }

  public static String validateDate(String dateStr) {
    try {
      Date startDate = Date.valueOf('1700-01-01T00:00:00Z GMT');
      Date endDate = Date.valueOf('4000-12-31T00:00:00Z GMT');
      Date dateValue = Date.valueOf(dateStr);
      if (startDate < dateValue && dateValue < endDate) {
        return String.valueOf(Date.valueOf(dateStr));
      }
    } catch (Exception ex) {
      tffa.Logger.error('Error in Parsing dateStr :' + dateStr + ' - ' + ex.getMessage());
    }
    return null;
  }

  @TestVisible
  private static String processPhnNbr(String phnNbr) {
    String nbr = '';
    try {
      nbr = phnNbr.replaceAll('\\(', '');
      nbr = nbr.replaceAll('\\)', '');
      nbr = nbr.replaceAll(' ', '');
      nbr = nbr.replaceAll('\\-', '');
    } catch (Exception ex) {
      tffa.Logger.error('Exception in processPhnNbr ' + ex.getMessage());
      return phnNbr;
    }
    return nbr;
  }

  public static CZMDMIndividualSearchResponse searchIndividual(Map<String, Object> params) {
    tffa.Logger.debug('In Search Individual');

    if (params.containsKey('isDebitCardProductSelected') && (String) params.get('isDebitCardProductSelected') == 'Y') {
      return searchIndPartyInFIS(params);
    }

    CZMDMIndividualSearchResponse response = new CZMDMIndividualSearchResponse();
    try {
      MuleSoft_Adapter_Config__mdt adapterConfig = CZWTFCHelperRepository.fetchMulesoftAdapterConfig('CustomerSearch');
      if (!Test.isRunningTest()) {
        CZMulesoftAdapter.auth = CZWTFCMulesoftOAuthProvider.getAuthHeader();
      }
      tffa.Logger.debug('CZMulesoftAdapter.auth ' + CZMulesoftAdapter.auth);
      CZWTFCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.INDIVIDUAL, FISCCIntegrationConstants.CUSTOMER_SEARCH, true);

      Integer recordPage = params.containsKey('pageNumber') ? getfirstRecordValue(Integer.valueOf((Decimal) params.get('pageNumber'))) : 1;

      String url =
        adapterConfig.EndPoint__c +
        '?first_record=' +
        String.valueOf(recordPage) +
        '&page_size=' +
        String.valueOf(FISCCIntegrationConstants.INDIVIDUAL_INQUIRY_PAGE_SIZE);

      if (params.containsKey('frstNm') && String.isNotBlank((String) params.get('frstNm'))) {
        url += '&frstNm=' + EncodingUtil.URLENCODE((String) params.get('frstNm'), 'UTF-8');
      }

      if (params.containsKey('lstNm') && String.isNotBlank((String) params.get('lstNm'))) {
        url += '&lstNm=' + EncodingUtil.URLENCODE((String) params.get('lstNm'), 'UTF-8');
      }

      if (params.containsKey('ssnNum') && String.isNotBlank((String) params.get('ssnNum'))) {
        url += '&ssnNum=' + EncodingUtil.URLENCODE((String) params.get('ssnNum'), 'UTF-8');
      }

      if (params.containsKey('acctNum') && String.isNotBlank((String) params.get('acctNum'))) {
        url += '&acctNum=' + ((String) params.get('acctNum')).leftPad(11, '0');
      }
      if (params.containsKey('debitCrdNo') && String.isNotBlank((String) params.get('debitCrdNo'))) {
        url += '&debitCrdNo=' + (String) params.get('debitCrdNo');
      }

      if (params.containsKey('phnNum') && String.isNotBlank((String) params.get('phnNum'))) {
        url += '&phnNum=' + EncodingUtil.URLENCODE((String) params.get('phnNum'), 'UTF-8');
      }

      if (params.containsKey('birthDate') && String.isNotBlank((String) params.get('birthDate'))) {
        url += '&birthDate=' + (String) params.get('birthDate');
      }

      adapterConfig.EndPoint__c = url;

      Object resp = CZMulesoftAdapter.invokeAPI(null, adapterConfig);

      if (resp != null) {
        response = (CZMDMIndividualSearchResponse) parseIndSearchResp((CZMDMIndividualSearchResponseDTO) resp, recordPage);

        CZWTFCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.CUSTOMER_SEARCH);
      } else {
        response.status = 'failure';
        CZWTFCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.CUSTOMER_SEARCH);
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in searchIndividual ' + ex.getLineNumber() + ' ' + ex.getMessage());
    }
    return response;
  }

  public static CZMDMIndividualSearchResponse parseIndSearchResp(CZMDMIndividualSearchResponseDTO indRespDTO, Integer recordPage) {
    tffa.Logger.debug('In parseIndSearchResp');
    CZMDMIndividualSearchResponse response = new CZMDMIndividualSearchResponse();
    try {
      if (String.isNotBlank(indRespDTO.errorCode)) {
        response.status = 'failure';
      }
      response.status = 'success';
      response.firstRecord = indRespDTO.first_record;
      response.pageSize = indRespDTO.page_size;
      if (indRespDTO.total_record_count > FISCCIntegrationConstants.INDIVIDUAL_INQUIRY_MAX_RECORDS) {
        response.totalRecords = FISCCIntegrationConstants.INDIVIDUAL_INQUIRY_MAX_RECORDS;
      } else {
        response.totalRecords = indRespDTO.total_record_count;
      }

      response = calculateTotalRecordPages(response, recordPage);

      if (indRespDTO.individualInfo != null && !indRespDTO.individualInfo.isEmpty()) {
        for (CZMDMIndividualSearchResponseDTO.IndInfo indInfo : indRespDTO.individualInfo) {
          CZMDMIndividualSearchResponse.IndInfo indInfoData = new CZMDMIndividualSearchResponse.IndInfo();
          indInfoData.firstName = indInfo.frstNm;
          indInfoData.lastName = indInfo.lstNm;
          indInfoData.SSN = indInfo.ssnNum;
          indInfoData.addressLine1 = indInfo.address1;
          indInfoData.city = indInfo.cityNm;
          indInfoData.state = indInfo.stateCd;
          indInfoData.zip4Cd = indInfo.zip4Cd;
          indInfoData.zip5Cd = indInfo.zip5Cd;
          indInfoData.countryName = indInfo.cityNm;
          indInfoData.countryCode = indInfo.countryCd;
          if (String.isNotBlank(indInfo.phoneNum)) {
            indInfoData.phoneNumber = processPhnNbr(indInfo.phoneNum);
          }
          indInfoData.mdmPartyId = indInfo.mdmPartyId;
          response.individualInfoLst.add(indInfoData);
        }
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in parseIndSearchResp ' + ex.getLineNumber() + ' ' + ex.getMessage());
    }
    return response;
  }

  public static CZMDMIndividualSearchResponse searchIndPartyInFIS(Map<String, Object> params) {
    CZMDMIndividualSearchResponse resp = new CZMDMIndividualSearchResponse();
    params.put('custType', 'I');
    params.put('searchType', 'P');

    try {
      CZWTFCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.INDIVIDUAL, FISCCIntegrationConstants.CUSTOMER_SEARCH, true);
      Object response = FISCCCustomerSearchExtension.searchCustomer(params);

      if (response != null) {
        resp = (CZMDMIndividualSearchResponse) response;
        // if (params.containsKey('startSearchCISNumber') && '0' != (String) params.get('startSearchCISNumber')) {
        //   resp.previousCISStartNumber = (String) params.get('startSearchCISNumber');
        // } else {
        //   resp.previousCISStartNumber = '0';
        // }
      } else {
        resp.status = 'failure';
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in searchIndPartyInFIS ' + ex.getStackTraceString());
    }
    return resp;
  }

  public static CZMDMBusinessCustSearchResponse searchOrgPartyInFIS(Map<String, Object> params) {
    CZMDMBusinessCustSearchResponse resp = new CZMDMBusinessCustSearchResponse();
    params.put('custType', 'O');
    params.put('searchType', 'P');
    try {
      CZWTFCIntegrationLogService.setCurrentLogItem(
        FISCCIntegrationConstants.ORGANIZATION,
        FISCCIntegrationConstants.CUSTOMER_SEARCH,
        true
      );
      Object response = FISCCCustomerSearchExtension.searchCustomer(params);

      if (response != null) {
        resp = (CZMDMBusinessCustSearchResponse) response;
        // if (params.containsKey('nextCISStartNumber') && '0' != (String) params.get('nextCISStartNumber')) {
        //   resp.previousCISStartNumber = (String) params.get('nextCISStartNumber');
        // } else {
        //   resp.previousCISStartNumber = '0';
        // }
      } else {
        resp.status = 'failure';
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in searchOrgPartyInFIS ' + ex.getStackTraceString());
    }
    return resp;
  }

  public static Integer getfirstRecordValue(Integer pageNbr) {
    tffa.Logger.debug('In getfirstRecordValue');
    Integer firstRecord = 1;
    try {
      firstRecord = (pageNbr - 1) * FISCCIntegrationConstants.INDIVIDUAL_INQUIRY_PAGE_SIZE + 1;
    } catch (Exception ex) {
      tffa.Logger.error('Exception in getfirstRecordValue ' + ex.getLineNumber() + ' ' + ex.getMessage());
    }
    return firstRecord;
  }

  public static CZMDMIndividualSearchResponse calculateTotalRecordPages(CZMDMIndividualSearchResponse response, Integer recordPage) {
    tffa.Logger.debug('In calculateTotalRecordPages');
    try {
      if (response.totalRecords != null && response.totalRecords != 0) {
        response.totalPages = Integer.valueOf(Math.ceil(response.totalRecords / FISCCIntegrationConstants.INDIVIDUAL_INQUIRY_PAGE_SIZE));
      }
      response.pageNumber = Integer.valueOf(Math.ceil(recordPage / FISCCIntegrationConstants.INDIVIDUAL_INQUIRY_PAGE_SIZE)) + 1;
    } catch (Exception ex) {
      tffa.Logger.error('Exception in calculateTotalRecordPages ' + ex.getLineNumber() + ' ' + ex.getMessage());
    }
    return response;
  }

  public static CZMDMBusinessCustSearchResponse searchBusinessCustomers(Map<String, Object> params) {
    tffa.Logger.debug('In Search Business Customer');

    if (params.containsKey('isDebitCardProductSelected') && (String) params.get('isDebitCardProductSelected') == 'Y') {
      if (params.containsKey('taxId')) {
        params.put('ssnNum', params.get('taxId'));
      }
      if (params.containsKey('accountNum')) {
        params.put('acctNum', params.get('accountNum'));
      }
      if (params.containsKey('phoneNum')) {
        params.put('phnNum', params.get('phoneNum'));
      }
      return searchOrgPartyInFIS(params);
    }

    CZMDMBusinessCustSearchResponse response = new CZMDMBusinessCustSearchResponse();
    try {
      MuleSoft_Adapter_Config__mdt adapterConfig = CZWTFCHelperRepository.fetchMulesoftAdapterConfig('BusinessCustomerSearch');
      if (!Test.isRunningTest()) {
        CZMulesoftAdapter.auth = CZWTFCMulesoftOAuthProvider.getAuthHeader();
      }
      tffa.Logger.debug('CZMulesoftAdapter.auth ' + CZMulesoftAdapter.auth);
      CZWTFCIntegrationLogService.setCurrentLogItem(
        FISCCIntegrationConstants.ORGANIZATION,
        FISCCIntegrationConstants.CUSTOMER_SEARCH,
        true
      );

      Integer recordPage = params.containsKey('pageNumber')
        ? getOrgfirstRecordValue(Integer.valueOf((Decimal) params.get('pageNumber')))
        : 1;

      String url =
        adapterConfig.EndPoint__c +
        '?first_record=' +
        String.valueOf(recordPage) +
        '&page_size=' +
        String.valueOf(FISCCIntegrationConstants.BUSINESS_CUSTOMER_INQUIRY_PAGE_SIZE);

      if (params.containsKey('businessNm') && String.isNotBlank((String) params.get('businessNm'))) {
        url += '&businessNm=' + EncodingUtil.URLENCODE((String) params.get('businessNm'), 'UTF-8');
      }

      if (params.containsKey('taxId') && String.isNotBlank((String) params.get('taxId'))) {
        url += '&taxId=' + (String) params.get('taxId');
      }

      if (params.containsKey('accountNum') && String.isNotBlank((String) params.get('accountNum'))) {
        url += '&accountNum=' + ((String) params.get('accountNum')).leftPad(11, '0');
      }

      if (params.containsKey('debitCrdNo') && String.isNotBlank((String) params.get('debitCrdNo'))) {
        url += '&debitCrdNo=' + (String) params.get('debitCrdNo');
      }

      if (params.containsKey('phoneNum') && String.isNotBlank((String) params.get('phoneNum'))) {
        url += '&phoneNum=' + EncodingUtil.URLENCODE((String) params.get('phoneNum'), 'UTF-8');
      }

      adapterConfig.EndPoint__c = url;

      Object resp = CZMulesoftAdapter.invokeAPI(null, adapterConfig);

      if (resp != null) {
        response = (CZMDMBusinessCustSearchResponse) parseBusinessSearchResp((CZMDMBusinessCustSearchResponseDTO) resp, recordPage);
        response.status = 'success';
        CZWTFCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.CUSTOMER_SEARCH);
      } else {
        response.status = 'failure';
        CZWTFCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.CUSTOMER_SEARCH);
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in searchBusinessCustomers ' + ex.getLineNumber() + ' ' + ex.getMessage());
    }
    return response;
  }

  public static CZMDMBusinessCustSearchResponse parseBusinessSearchResp(CZMDMBusinessCustSearchResponseDTO orgRespDTO, Integer recordPage) {
    tffa.Logger.debug('In parseBusinessSearchResp');
    CZMDMBusinessCustSearchResponse response = new CZMDMBusinessCustSearchResponse();
    try {
      response.firstRecord = orgRespDTO.first_record;
      response.pageSize = orgRespDTO.page_size;
      if (orgRespDTO.total_record_count > FISCCIntegrationConstants.BUSINESS_CUSTOMER_INQUIRY_MAX_RECORDS) {
        response.totalRecords = FISCCIntegrationConstants.BUSINESS_CUSTOMER_INQUIRY_MAX_RECORDS;
      } else {
        response.totalRecords = orgRespDTO.total_record_count;
      }

      response = calculateOrgTotalRecordPages(response, recordPage);

      if (orgRespDTO.organizationInfo != null && !orgRespDTO.organizationInfo.isEmpty()) {
        for (CZMDMBusinessCustSearchResponseDTO.OrgInfo orgInfo : orgRespDTO.organizationInfo) {
          CZMDMBusinessCustSearchResponse.OrgInfo orgInfoData = new CZMDMBusinessCustSearchResponse.OrgInfo();
          orgInfoData.mdmPartyId = orgInfo.mdmPartyId;
          orgInfoData.businessName = orgInfo.orgNm;
          orgInfoData.SSN = orgInfo.taxId;
          orgInfoData.addressLine1 = orgInfo.address1;
          orgInfoData.city = orgInfo.city;
          orgInfoData.state = orgInfo.state;
          orgInfoData.countryName = orgInfo.countryNm;
          orgInfoData.countryCode = orgInfo.countryCd;
          orgInfoData.zip5Cd = orgInfo.zip5Cd;
          orgInfoData.BusinessType = fetchOrgType(orgInfo.busTyp);
          orgInfoData.BusinessDescription = orgInfo.busDesc;
          //orgInfoData.zip4Cd = orgInfo.zip4Cd;
          if (String.isNotBlank(orgInfo.phoneNumber)) {
            orgInfoData.phoneNumber = processPhnNbr(orgInfo.phoneNumber);
          }
          response.organizationInfo.add(orgInfoData);
        }
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in parseBusinessSearchResp ' + ex.getLineNumber() + ' ' + ex.getMessage());
    }
    return response;
  }

  public static Integer getOrgfirstRecordValue(Integer pageNbr) {
    tffa.Logger.debug('In getOrgfirstRecordValue');
    Integer firstRecord = 1;
    try {
      firstRecord = (pageNbr - 1) * FISCCIntegrationConstants.BUSINESS_CUSTOMER_INQUIRY_PAGE_SIZE + 1;
    } catch (Exception ex) {
      tffa.Logger.error('Exception in getOrgfirstRecordValue ' + ex.getLineNumber() + ' ' + ex.getMessage());
    }
    return firstRecord;
  }

  public static CZMDMBusinessCustSearchResponse calculateOrgTotalRecordPages(CZMDMBusinessCustSearchResponse response, Integer recordPage) {
    tffa.Logger.debug('In calculateOrgTotalRecordPages');
    try {
      if (response.totalRecords != null && response.totalRecords != 0) {
        response.totalPages = Integer.valueOf(
          Math.ceil(response.totalRecords / FISCCIntegrationConstants.BUSINESS_CUSTOMER_INQUIRY_PAGE_SIZE)
        );
      }
      response.pageNumber = Integer.valueOf(Math.ceil(recordPage / FISCCIntegrationConstants.BUSINESS_CUSTOMER_INQUIRY_PAGE_SIZE)) + 1;
    } catch (Exception ex) {
      tffa.Logger.error('Exception in calculateOrgTotalRecordPages ' + ex.getLineNumber() + ' ' + ex.getMessage());
    }
    return response;
  }

  public static CZMDMBusinessCustDetailsResponse fetchBusinessCustomerDetails(Map<String, Object> params) {
    tffa.Logger.debug('In Fetch Business Customer Details');

    if (params.containsKey('isDebitCardProductSelected') && params.get('isDebitCardProductSelected') == 'Y') {
      return fetchOrgFromFIS(params);
    }

    CZMDMBusinessCustDetailsResponse response = new CZMDMBusinessCustDetailsResponse();
    brandCode = String.valueOf(params.get('brandCode'));

    try {
      MuleSoft_Adapter_Config__mdt adapterConfig = CZWTFCHelperRepository.fetchMulesoftAdapterConfig('FetchBusinessCustomer');
      if (!Test.isRunningTest()) {
        CZMulesoftAdapter.auth = CZWTFCMulesoftOAuthProvider.getAuthHeader();
      }
      tffa.Logger.debug('CZMulesoftAdapter.auth ' + CZMulesoftAdapter.auth);
      CZWTFCIntegrationLogService.setCurrentLogItem(
        FISCCIntegrationConstants.CUSTOMER,
        FISCCIntegrationConstants.BUSINESS_CUSTOMER_DETAILS_INQUIRY,
        true
      );

      CZMDMBusinessCustDetailsRequestDTO requestDTO = new CZMDMBusinessCustDetailsRequestDTO();
      requestDTO.mdmPartyId = (String) params.get('mdmPartyId');

      String strReq = System.JSON.serialize(requestDTO, true);

      Object resp = CZMulesoftAdapter.invokeAPI(strReq, adapterConfig);

      if (resp != null) {
        CZMDMBusinessCustDetailsResponseDTO responseDTO = (CZMDMBusinessCustDetailsResponseDTO) resp;

        response = parseBusinessResponse(response, responseDTO);

        CZWTFCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.BUSINESS_CUSTOMER_DETAILS_INQUIRY);
      } else {
        CZWTFCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.BUSINESS_CUSTOMER_DETAILS_INQUIRY);
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in fetchBusinessCustomerDetails ' + ex.getLineNumber() + ' ' + ex.getMessage());
    }
    return response;
  }

  public static CZMDMBusinessCustDetailsResponse parseBusinessResponse(
    CZMDMBusinessCustDetailsResponse resp,
    CZMDMBusinessCustDetailsResponseDTO apiResponseDTO
  ) {
    tffa.Logger.debug('Inside parseBusinessResponse: ' + apiResponseDTO);
    resp.businessInfo.IsCrossCharterCustomer = false;
    resp.businessInfo.IsExistingCustomer = false;

    resp.isSuccess = true;
    resp.globalCustomerId = apiResponseDTO.rowidObject;

    resp.businessInfo.BusinessName = apiResponseDTO.orgNm;
    resp.businessInfo.BusinessType = fetchOrgType(apiResponseDTO.businessType);
    resp.businessInfo.BusinessDescription = apiResponseDTO.businessDescription;
    resp.businessInfo.EstablishDate = apiResponseDTO.busEstbDate;

    if (apiResponseDTO.custDueDlgnceFg != null) {
      resp.businessInfo.IsPublicTradedCompany = apiResponseDTO.custDueDlgnceFg == 'N' ? false : true;
    }

    if (apiResponseDTO.addresses != null) {
      resp.businessInfo.AddressLineOne = apiResponseDTO.addresses.addrLine1Tx;
      resp.businessInfo.AddressLineTwo = apiResponseDTO.addresses.addrLine2Tx;
      resp.businessInfo.City = apiResponseDTO.addresses.cityNm;
      resp.businessInfo.StateCode = apiResponseDTO.addresses.stateCd;
      resp.businessInfo.ZipCode = apiResponseDTO.addresses.zip5Cd;
      if (String.isNotBlank(apiResponseDTO.addresses.zip4Cd)) {
        resp.businessInfo.ZipCode = resp.businessInfo.ZipCode + '-' + apiResponseDTO.addresses.zip4Cd;
      }
    }

    if (FISCCIntegrationConstants.BUSINESS_NATIONAL_IDENTITY_MDM_TO_TF_MAP.containsKey(apiResponseDTO.taxIdType)) {
      resp.businessInfo.SSN = apiResponseDTO.taxId;
      resp.businessInfo.TaxId = apiResponseDTO.taxId;
      resp.businessInfo.TaxIdType = FISCCIntegrationConstants.BUSINESS_NATIONAL_IDENTITY_MDM_TO_TF_MAP.get(apiResponseDTO.taxIdType);
    }

    resp.businessInfo.EmailId = apiResponseDTO.EmailId;
    resp.businessInfo.NAICSCode = apiResponseDTO.naicsCd;

    if (apiResponseDTO.identifierLst != null && !apiResponseDTO.identifierLst.isEmpty()) {
      for (CZMDMBusinessCustDetailsResponseDTO.IdentifierLst idtObj : apiResponseDTO.identifierLst) {
        String idTypeCode = '';
        String identificationCode = '';
        if (String.isNotBlank(idtObj.idtfrTypCd)) {
          identificationCode = FISCCIntegrationConstants.NATIONAL_IDENTITY_MDM_TO_TF_MAP.containsKey(idtObj.idtfrTypCd)
            ? FISCCIntegrationConstants.NATIONAL_IDENTITY_MDM_TO_TF_MAP.get(idtObj.idtfrTypCd)
            : 'NONE';
        } else {
          identificationCode = 'NONE';
        }

        if (String.isNotBlank(identificationCode)) {
          CZMDMBusinessCustDetailsResponse.IdentificationDetails identityDetailObj = new CZMDMBusinessCustDetailsResponse.IdentificationDetails();
          identityDetailObj.IdentificationNumber = idtObj.idtfrNmb;
          identityDetailObj.IdentificationType = identificationCode;
          try {
            identityDetailObj.IssueDate = String.isNotBlank(idtObj.issueDte) ? validateDate(idtObj.issueDte) : null;
          } catch (Exception ex) {
            tffa.Logger.debug('Error in Parsing issue date');
            identityDetailObj.IssueDate = null;
          }

          try {
            identityDetailObj.ExpirationDate = String.isNotBlank(idtObj.expDte) ? validateDate(idtObj.expDte) : null;
          } catch (Exception exp) {
            tffa.Logger.debug('Error in Parsing Exp date');
            identityDetailObj.ExpirationDate = null;
          }

          identityDetailObj.IssuingStateCode = idtObj.issueStateCd;
          resp.identificationDetails.add(identityDetailObj);
        }
      }
    }

    if (apiResponseDTO.CisDetailLst != null && !apiResponseDTO.CisDetailLst.isEmpty()) {
      for (CZMDMBusinessCustDetailsResponseDTO.CisDetailLst custObj : apiResponseDTO.CisDetailLst) {
        if (custObj.chrtrCd.equalsIgnoreCase(brandCode) || ((custObj.chrtrCd).equalsIgnoreCase('889') && wintrustEnvConfig.IsTestEnv__c)) {
          resp.businessInfo.CISNumber = custObj.cisNmb.leftPad(11, '0');
          resp.businessInfo.CharterCode = brandCode;
          resp.businessInfo.CISStartDate = custObj.custSinceDt;
          resp.businessInfo.PrimaryOficerCode = custObj.offcrCd == '1000' ? '' : custObj.offcrCd;
          resp.businessInfo.SecondaryOfficerCode = custObj.CIScndyOffcrNbr == '1000' ? '' : custObj.CIScndyOffcrNbr;
          resp.businessInfo.SecretWord = custObj.secretWrd;
          resp.businessInfo.SecretHint = custObj.secretHnt;
          resp.businessInfo.CostCenter = custObj.costCntrNo;

          if (String.isNotBlank(custObj.brnchCd)) {
            tffa__Location__c locObj = CZWTFCHelperRepository.fetchLocationByCode(brandCode + custObj.brnchCd.leftPad(4, '0'));
            if (locObj != null) {
              resp.businessInfo.LocationCode = locObj.Id;
            }
          }

          resp.businessInfo.IsExistingCustomer = true;
        }

        CZMDMBusinessCustDetailsResponse.CustomerCiISRecord cisRecord = new CZMDMBusinessCustDetailsResponse.CustomerCiISRecord();
        String cisbrand = custObj.chrtrCd;
        if (((cisbrand).equalsIgnoreCase('889') && wintrustEnvConfig.IsTestEnv__c)) {
          cisbrand = brandCode;
        }
        cisRecord.charterName = brandNameMap.containsKey(cisbrand) ? brandNameMap.get(cisbrand) : '';
        cisRecord.cisNbr = custObj.cisNmb.leftPad(11, '0');
        cisRecord.cisStartDate = custObj.custSinceDt;
        cisRecord.primaryOfrNbr = custObj.offcrCd;
        cisRecord.SecretWord = custObj.secretWrd;
        cisRecord.SecretHint = custObj.secretHnt;
        resp.cisLst.add(cisRecord);
      }

      if (String.isBlank(resp.businessInfo.CISNumber)) {
        resp.businessInfo.IsCrossCharterCustomer = true;
      }
    }

    if (apiResponseDTO.acctLst != null && !apiResponseDTO.acctLst.isEmpty()) {
      for (CZMDMBusinessCustDetailsResponseDTO.AcctLst acctObj : apiResponseDTO.acctLst) {
        if (acctObj.acctCtgry == 'DP' && acctObj.acctstatus != null && !acctObj.acctstatus.equalsIgnoreCase('Closed')) {
          CZMDMBusinessCustDetailsResponse.AccountList accDetailObj = new CZMDMBusinessCustDetailsResponse.AccountList();
          accDetailObj.AccountNumber = acctObj.acctNmb;
          accDetailObj.AccountCategory = acctObj.acctCtgry;
          accDetailObj.CharterCode = (acctObj.chrtrCd.equalsIgnoreCase('889') && wintrustEnvConfig.IsTestEnv__c)
            ? brandCode
            : acctObj.chrtrCd;
          accDetailObj.AccountCreationDate = acctObj.acctCreationDte;
          accDetailObj.ProductCode = acctObj.pdtCd;
          accDetailObj.ProductName = acctObj.pdtNm;
          accDetailObj.AccountType = acctObj.acctTyp;
          accDetailObj.RelationshipCode = acctObj.rltnshpCd;
          accDetailObj.AccountStatus = acctObj.acctstatus;
          accDetailObj.relationshipName = applicantRoleMap.containsKey(acctObj.rltnshpCd) ? applicantRoleMap.get(acctObj.rltnshpCd) : '';
          accDetailObj.CharterName = brandNameMap.containsKey(accDetailObj.CharterCode) ? brandNameMap.get(accDetailObj.CharterCode) : '';
          accDetailObj.mdmPartyId = apiResponseDTO.rowidObject;
          resp.accountList.add(accDetailObj);
        }
      }
    }

    if (apiResponseDTO.ownerRcdLst != null && !apiResponseDTO.ownerRcdLst.isEmpty()) {
      Map<String, String> relationMap = fetchPartyRelationNameMap();
      for (CZMDMBusinessCustDetailsResponseDTO.OwnerRcdLst ownerObj : apiResponseDTO.ownerRcdLst) {
        CZMDMBusinessCustDetailsResponse.OwnerList ownerDetailObj = new CZMDMBusinessCustDetailsResponse.OwnerList();
        ownerDetailObj.globalCustomerId = ownerObj.rowidObject;
        ownerDetailObj.TaxIdType = FISCCIntegrationConstants.NATIONAL_IDENTITY_MDM_TO_TF_MAP.containsKey(ownerObj.taxIdType)
          ? FISCCIntegrationConstants.NATIONAL_IDENTITY_MDM_TO_TF_MAP.get(ownerObj.taxIdType)
          : 'NONE';
        ownerDetailObj.SSN = ownerObj.taxId;
        ownerDetailObj.OwnerName = ownerObj.ownrNm;
        ownerDetailObj.OwnershipPercentage = ownerObj.ownrPercent;
        ownerDetailObj.EmailId = ownerObj.EmailId;
        ownerDetailObj.Title = ownerObj.ownrTitl;
        ownerDetailObj.cisNbr = ownerObj.cISNmb != null ? ownerObj.cISNmb.leftPad(11, '0') : '';
        ownerDetailObj.CharterName = brandNameMap.containsKey(ownerObj.chrtrCd) ? brandNameMap.get(ownerObj.chrtrCd) : '';

        if (ownerObj.relCd != null) {
          ownerDetailObj.RelationshipName = relationMap.get(ownerObj.relCd);
          ownerDetailObj.RelationshipCode = ownerObj.relCd;
        }

        if (ownerObj.Communication != null) {
          for (CZMDMBusinessCustDetailsResponseDTO.PhNmb phone : ownerObj.Communication) {
            if (String.isNotBlank(phone.commcnTypCd)) {
              if (phone.commcnTypCd == 'PRI' || phone.commcnTypCd == 'HME') {
                ownerDetailObj.OwnerPrimaryPhone = processPhnNbr(phone.commcnVl);
              }

              if (phone.commcnTypCd == 'SEC' || phone.commcnTypCd == 'WRK') {
                ownerDetailObj.OwnerSecondaryPhone = processPhnNbr(phone.commcnVl);
              }

              if (phone.commcnTypCd == 'MBL') {
                ownerDetailObj.OwnerCellPhoneNo = processPhnNbr(phone.commcnVl);
              }
            }
          }
        }

        resp.ownerList.add(ownerDetailObj);
      }
    }

    if (apiResponseDTO.phNmb != null) {
      for (CZMDMBusinessCustDetailsResponseDTO.PhNmb phone : apiResponseDTO.phNmb) {
        if (String.isNotBlank(phone.commcnTypCd)) {
          if (phone.commcnTypCd == 'PRI' || phone.commcnTypCd == 'HME') {
            resp.businessInfo.PrimaryPhone = processPhnNbr(phone.commcnVl);
          }

          if (phone.commcnTypCd == 'SEC' || phone.commcnTypCd == 'WRK') {
            resp.businessInfo.SecondaryPhone = processPhnNbr(phone.commcnVl);
          }

          if (phone.commcnTypCd == 'MBL') {
            resp.businessInfo.CellPhoneNo = processPhnNbr(phone.commcnVl);
          }

          if (phone.commcnTypCd == 'ITL') {
            resp.businessInfo.InternationalPhoneNo = phone.commcnVl;
          }
        }
      }
    }

    return resp;
  }

  public static String fetchOrgType(String orgCode) {
    String orgType = '';
    for (CZTerafinaFisMapping__c organizationType : CZWTFCHelperRepository.getTFndFISMappingByType('OrganizationType')) {
      if (orgCode == organizationType.FisValue__c) {
        orgType = organizationType.TerafinaValue__c;
        break;
      }
    }

    return orgType;
  }

  public static Map<String, String> fetchPartyRelationNameMap() {
    Map<String, String> relationCodeMap = new Map<String, String>();
    for (tffa__PartyRelationCode__c partyRelation : CZWTFCHelperRepository.getPartyRelationCode()) {
      relationCodeMap.put(partyRelation.tffa__Value__c, partyRelation.Name);
    }

    return relationCodeMap;
  }

  public static CZCommonResponseDTO searchCustomer(Map<String, Object> params) {
    tffa.Logger.debug('In searchCustomer');

    CZCommonResponseDTO respDto = new CZCommonResponseDTO();

    try {
      respDto.isSuccess = true;
      String type = (String) params.get('partyType');
      String taxId = (String) params.get('taxId');
      if (type == 'IND') {
        CZWTFCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.MDM_IND_CUSTOMER_INQUIRY);
        params.put('ssnNum', taxId);
        CZMDMIndividualSearchResponse indSearchResp = searchIndividual(params);
        if (indSearchResp.individualInfoLst.isEmpty()) {
          respDto.isExisting = false;
        } else {
          respDto.isExisting = true;
        }
      } else if (type == 'ORG') {
        CZWTFCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.MDM_BUSINESS_CUSTOMER_INQUIRY);
        CZMDMBusinessCustSearchResponse orgSearchResp = searchBusinessCustomers(params);
        if (orgSearchResp.organizationInfo.isEmpty()) {
          respDto.isExisting = false;
        } else {
          respDto.isExisting = true;
        }
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exeption in searchCustomer ' + ex.getLineNumber() + ' ' + ex.getMessage());
      respDto.isSuccess = false;
    }
    return respDto;
  }

  public static CZWTFCAuthResponse fetchIndFromFIS(Map<String, Object> params) {
    tffa.Logger.debug('In fetchIndFromFIS ' + params);
    params.put('custType', 'I');
    CZWTFCAuthResponse resp = (CZWTFCAuthResponse) FISCCCustomerSearchExtension.fetchApplicantFromFIS(params);
    resp.custInfo.IsExistingCustomer = true;
    if (!Test.isRunningTest() && String.isNotBlank(resp.type) && resp.type == 'O') {
      throw new tffa.ApplicationException('THIS IS NOT A CUSTOMER TYPE OF INDIVIDUAL.');
    }
    return resp;
  }

  public static CZMDMBusinessCustDetailsResponse fetchOrgFromFIS(Map<String, Object> params) {
    tffa.Logger.debug('In fetchIndFromFIS ' + params);
    params.put('custType', 'O');
    CZMDMBusinessCustDetailsResponse resp = (CZMDMBusinessCustDetailsResponse) FISCCCustomerSearchExtension.fetchApplicantFromFIS(params);
    resp.businessInfo.IsExistingCustomer = true;
    if (!Test.isRunningTest() && String.isNotBlank(resp.type) && resp.type == 'I') {
      throw new tffa.ApplicationException('THIS IS NOT A CUSTOMER TYPE OF ORGANIZATION.');
    }
    return resp;
  }
}