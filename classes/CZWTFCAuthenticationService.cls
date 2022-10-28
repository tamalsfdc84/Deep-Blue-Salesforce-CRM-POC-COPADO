public with sharing class CZWTFCAuthenticationService {
  @TestVisible
  private static boolean testException = false;

  private static WintrustEnvConfig__mdt wintrustEnvConfig = CZWTFCHelperRepository.fetchWintrustEnvConfig();

  private static Map<String, String> brandNameMap = CZWTFCBrandRepository.fetchBrandCodeAndName();

  public static String brandCode = '';
  public static CZWTFCAuthResponse verifyUser(Map<String, String> params) {
    tffa.Logger.debug('In CZWTFCAuthenticationService verifyUser ' + params);
    String method = params.get('method');
    params.put('type', getLoginType(method));
    String authType = params.get('authType');
    String apiMethod;
    if (authType.equalsIgnoreCase('ind-3')) {
      apiMethod = 'Search';
    } else {
      apiMethod = 'Authentication';
    }
    brandCode = params.get('brandCode');
    if (!params.containsKey('D3Login')) {
      FISCCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.CUSTOMER, apiMethod, true);
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
            FISCCIntegrationLogService.setLogItemOk(params.get('type'));
          }
        } else {
          response.status = 'failure';
          if (!params.containsKey('D3Login')) {
            FISCCIntegrationLogService.setLogItemFailed(params.get('type'));
          }
        }
      }
    } catch (Exception ex) {
      response.status = 'failure';
      if (!params.containsKey('D3Login')) {
        FISCCIntegrationLogService.setLogItemFailed(params.get('type'));
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
    resp.custInfo.Suffix = apiResponseDTO.customerInfo.suffix;
    if (apiResponseDTO.customerInfo.country != null) {
      CZTerafinaFisMapping__c addressTfFisMap = CZWTFCHelperRepository.getTFndFISMapping(
        'AddressCountry',
        apiResponseDTO.customerInfo.country
      );
      resp.custInfo.Country = addressTfFisMap != null ? addressTfFisMap.TerafinaValue__c : '';
    }

    if (String.isNotBlank(apiResponseDTO.customerInfo.primPhNmb)) {
      resp.custInfo.HomePhoneNo = processPhnNbr(apiResponseDTO.customerInfo.primPhNmb);
    }

    if (String.isNotBlank(apiResponseDTO.customerInfo.scndryPhNmb)) {
      resp.custInfo.OfficePhoneNo = processPhnNbr(apiResponseDTO.customerInfo.scndryPhNmb);
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
      occCode = FISCCCreateDueDiligenceExtension.getOccupationLabel(respOcc);
      if (
        homeMakerLst.contains(respOcc) && (resp.custInfo.EmploymentStatusCode == null || resp.custInfo.EmploymentStatusCode == 'UNEMPLOYED')
      ) {
        resp.custInfo.EmploymentStatusCode = 'HOMEMAKER';
        resp.custInfo.OccupationCode = null;
      } else if (
        studentLst.contains(respOcc) && (resp.custInfo.EmploymentStatusCode == null || resp.custInfo.EmploymentStatusCode == 'UNEMPLOYED')
      ) {
        resp.custInfo.EmploymentStatusCode = 'STUDENT';
        resp.custInfo.OccupationCode = null;
      } else {
        resp.custInfo.OccupationCode = String.isNotBlank(occCode) ? respOcc : '027';
        if (String.isBlank(resp.custInfo.EmploymentStatusCode)) {
          resp.custInfo.EmploymentStatusCode = 'FULLTIME';
        }
      }
    }

    resp.custInfo.Title = apiResponseDTO.customerInfo.emplyTitle;
    resp.custInfo.EmployeeName = apiResponseDTO.customerInfo.emplyNme;

    //Set missing Flag
    if (
      String.isBlank(resp.custInfo.HomePhoneNo) &&
      String.isBlank(resp.custInfo.OfficePhoneNo) &&
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
            tffa.Logger.error('Error in Parsing issue date : '+ ex.getMessage() + ex.getStackTraceString());
            identityDetailObj.IssueDate = null;
          }

          try {
            identityDetailObj.ExpirationDate = idtObj.expDte != null ? validateDate(idtObj.expDte) : null;
          } catch (Exception exp) {
            tffa.Logger.error('Error in Parsing Exp date: '+ exp.getMessage() + exp.getStackTraceString());
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
          resp.custInfo.IsExistingCustomer = true;
        }
      }
      if (String.isBlank(resp.custInfo.CISNumber)) {
        resp.custInfo.IsCrossCharterCustomer = true;
      }
    }
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

  @TestVisible
  private static String validateDate(String dateStr) {
    try {
      Date startDate = Date.valueOf('1700-01-01T00:00:00Z GMT');
      Date endDate = Date.valueOf('4000-12-31T00:00:00Z GMT');
      Date dateValue = Date.valueOf(dateStr);
      if (startDate < dateValue && dateValue < endDate) {
        return String.valueOf(Date.valueOf(dateStr));
      }
    } catch (Exception ex) {
      tffa.Logger.error('Error in Parsing dateStr :'+ dateStr + ' - '+ ex.getMessage());
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
}