public with sharing class FISCCUpdateCustInfoProvider {
  public static boolean isBatchSource = false;
  public static boolean updateCustInfo(List<tffa__Party__c> partyObjList) {
    Object result = null;
    Boolean isSuccess = true;
    String strDeveloperName = 'CreateDueDiligence';
    Boolean isIntegrationLogSet = false;

    // try{
    List<tffa__Party__c> partyUpdatedList = new List<tffa__Party__c>();
    FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig(strDeveloperName);
    FISCC_Charter_Config__mdt charterConfig = FISCCIntegrationLogService.charterConfig;
    //null check auth
    if (String.isBlank(FISCCIntegrationLogService.auth)) {
      FISCCIntegrationLogService.auth = FISCCGetAccessTokenProvider.processGetAccessToken(charterConfig);
    }
    for (tffa__Party__c partyObj : partyObjList) {
      boolean partySuccess = true;
      if (
        partyObj.IsAuthenticatedCustomer__c &&
        partyObj.tffa__IsExistingCustomer__c &&
        (partyObj.IsEmailIdMissing__c || partyObj.IsPhoneNumberMissing__c)
      ) {
        boolean dueDiligencefailed = false;
        if (!partySuccess) {
          dueDiligencefailed = true;
        }
        if (!isIntegrationLogSet) {
          FISCCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.UPDATED_CUSTOMER_INFORMATION_FLOW);
          isIntegrationLogSet = true;
        }
        partySuccess = FISCCDepositOriginationProvider.updateCustomerInformation(partyObj);
        if (dueDiligencefailed) {
          partySuccess = false;
        }
      }

      if (!partySuccess) {
        isSuccess = false;
      }
    }
    if (isIntegrationLogSet) {
      if (isSuccess) {
        FISCCIntegrationLogService.setLogOk(FISCCIntegrationConstants.UPDATED_CUSTOMER_INFORMATION_COMPLETED);
      } else {
        FISCCIntegrationLogService.setLogFailed(FISCCIntegrationConstants.UPDATED_CUSTOMER_INFORMATION_FAILURE);
      }
    }
    return isSuccess;
  }

  public static void updateBranchCustomerInformation(List<tffa__Party__c> partyLst) {
    if (String.isBlank(FISCCIntegrationLogService.auth)) {
      FISCCIntegrationLogService.auth = FISCCGetAccessTokenProvider.processGetAccessToken(FISCCIntegrationLogService.charterConfig);
    }
    tffa.Logger.debug('In updateCustomerInformation');
    FISCCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.CUSTOMER_INFORMATION);
    for (tffa__Party__c partyObj : partyLst) {
      if (partyObj.tffa__IsExistingCustomer__c) {
        if (!FISCCSubmissionExecutor.withinGovernorLimits() && !isBatchSource) {
          FISCCIntegrationLogService.submissionObj.CZRetryAccountOpening__c = true;
          return;
        }
        String partyInfoupdate = CZWTFCIntegrationLogService.setCurrentLogItem(partyObj.Name, 'Information', false);
        if (FISCCIntegrationLogService.isLogItemNewOrFailed(partyInfoupdate)) {
          try {
            FISCCRequestBaseDTO fisccRequestBaseDTO;
            FISCCDepositOriginationRequest objFISCCDepositOriginationRequest = new FISCCDepositOriginationRequest();
            List<FISCCDepositOriginationRequestBaseDTO> lstFISCCDepositOriginationRequestBaseDTO = generateUpdateDORequest(partyObj);

            objFISCCDepositOriginationRequest.DepositOriginationLst = lstFISCCDepositOriginationRequestBaseDTO;
            tffa.logger.debug('updateCustomerInformation DO Req ==>' + objFISCCDepositOriginationRequest.DepositOriginationLst);
            fisccRequestBaseDTO = objFISCCDepositOriginationRequest;
            FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig(
              FISCCIntegrationConstants.DeveloperName_Deposit_Originate
            );
            Object result = FISCCHostAdapter.processHostRequest(
              fisccRequestBaseDTO,
              adapterConfig,
              FISCCIntegrationLogService.charterConfig
            );

            boolean isDoAPISuccess = parseUpdateCustomerDOResponse(result);

            if (isDoAPISuccess) {
              FISCCIntegrationLogService.setLogItemOk('SUCCESS');
            } else {
              FISCCIntegrationLogService.setLogItemFailed('FAILURE');
            }
          } catch (Exception ex) {
            tffa.Logger.debug('Exception in Updating cust info in DO Call ' + ex.getLineNumber() + ' ' + ex.getMessage());
            FISCCIntegrationLogService.setLogItemFailed('FAILURE');
          }
        }

        String partyNameUpdate = CZWTFCIntegrationLogService.setCurrentLogItem(partyObj.Name, 'Name/AddressUpdate', false);
        if (FISCCIntegrationLogService.isLogItemNewOrFailed(partyNameUpdate)) {
          try {
            FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig('CustNameAddressUpdate');
            FISCCRequestBaseDTO customerAddress = generateNameAddressUpdateReq(partyObj);
            adapterConfig.ServiceURL__c = adapterConfig.ServiceURL__c.replace(
              '{custNbr}',
              FISCCCommonHelper.encrypt(partyObj.Customer_Number__c)
            );
            Object result = FISCCHostAdapter.processHostRequest(customerAddress, adapterConfig, FISCCIntegrationLogService.charterConfig);

            boolean isSuccess = parseUpdateCustomerNameAddressResponse(result);
            if (isSuccess) {
              FISCCIntegrationLogService.setLogItemOk('SUCCESS');
            } else {
              FISCCIntegrationLogService.setLogItemFailed('FAILURE');
            }
          } catch (Exception ex) {
            tffa.Logger.debug('Exception in Updating cust info in DO Call  ' + ex.getLineNumber() + ' ' + ex.getMessage());
            FISCCIntegrationLogService.setLogItemFailed('FAILURE');
          }
        }
        if (FISCCIntegrationLogService.isLogItemOk(partyNameUpdate) && FISCCIntegrationLogService.isLogItemOk(partyInfoupdate)) {
          partyObj.CZCustomerUpdated__c = true;
        }
      }
    }

    if (!CZWTFCCommonHelper.checkInternationalPhnCreated(partyLst)) {
      FISCCDemographicsProvider.processIntPhoneNbr(partyLst);
    }

    if (!FISCCSubmissionExecutor.withinGovernorLimits() && !isBatchSource) {
      FISCCIntegrationLogService.submissionObj.CZRetryAccountOpening__c = true;
      return;
    }

    // //Update Org relnship
    for (tffa__Party__c partyObj : partyLst) {
      if (partyObj.tffa__IsExistingCustomer__c && partyObj.tffa__Type__c == FISCCIntegrationConstants.ORGANIZATION) {
        updateCustToCustRelnship(partyObj);
      }
    }
  }

  /**
   * Generate DO Request
   *  1.Delete Phone Numbers - Home,Work and Cell
   *  2.Delete Primary Email Address.
   *  3.Add Phone Numbers - Home,Work and Cell
   *  4.Add Email Address
   *  5.Update Due diligence Informartion
   *  6.Update Demographics Information
   */
  public static List<FISCCDepositOriginationRequestBaseDTO> generateUpdateDORequest(tffa__Party__c partyObj) {
    List<FISCCDepositOriginationRequestBaseDTO> lstFISCCDepositOriginationRequestBaseDTO = new List<FISCCDepositOriginationRequestBaseDTO>();

    FISCCDepositOriginationRequestBaseDTO objFISCCDepositOriginationRequestBaseDTO;

    lstFISCCDepositOriginationRequestBaseDTO.addAll(FISCCUpdateCustomerInfoExtension.generatePhnEmailDelReq(partyObj));

    lstFISCCDepositOriginationRequestBaseDTO.addAll(FISCCUpdateCustomerInfoExtension.generatePhoneEmailUpdateReq(partyObj));

    lstFISCCDepositOriginationRequestBaseDTO.add(FISCCUpdateCustomerInfoExtension.genUpdateCustomerDueDiligenceReq(partyObj));

    lstFISCCDepositOriginationRequestBaseDTO.add(FISCCUpdateCustomerInfoExtension.genUpdateCustomerDemographicsReq(partyObj));
    return lstFISCCDepositOriginationRequestBaseDTO;
  }

  public static FISCCRequestBaseDTO generateNameAddressUpdateReq(tffa__Party__c partyObj) {
    tffa.Logger.debug('In generateNameAddressUpdateReq ' + partyObj.Name);
    FISCCRequestBaseDTO reqDto;
    FISCCCustNameAddressRequest customerAddress = FISCCUpdateCustomerInfoExtension.generateNameAddressUpdateRequest(partyObj);
    reqDto = customerAddress;
    tffa.Logger.debug('In Request Generated for Name and Address Update  ' + reqDto);
    return reqDto;
  }

  public static tffa__Party__c fetchContactEffDate(tffa__Party__c partyObj) {
    tffa.Logger.debug('In fetchContactEffDate');

    FISCC_Adapter_Configs__mdt adapterConfig;

    if (String.isBlank(FISCCIntegrationLogService.auth)) {
      FISCCIntegrationLogService.auth = FISCCGetAccessTokenProvider.processGetAccessToken(FISCCIntegrationLogService.charterConfig);
    }

    FISCCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.FIS_FETCH_PHONE_NBR, partyObj.Name, false);
    adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig('FetchPhoneNbr');
    partyObj = FISCCFetchContactInfoExtension.fetchContactInfo(partyObj, adapterConfig);

    FISCCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.FIS_FETCH_EMAIL_ADDR, partyObj.Name, false);
    adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig('FetchEmailAddress');
    partyObj = FISCCFetchContactInfoExtension.fetchContactInfo(partyObj, adapterConfig);
    return partyObj;
  }

  public static tffa__Party__c FetchCustomerInfo(tffa__Party__c partyObj) {
    FISCC_Adapter_Configs__mdt adapterConfig;

    if (String.isBlank(FISCCIntegrationLogService.auth)) {
      FISCCIntegrationLogService.auth = FISCCGetAccessTokenProvider.processGetAccessToken(FISCCIntegrationLogService.charterConfig);
    }
    FISCCIntegrationLogService.setCurrentLogItem('FetchCustomerInfo', partyObj.Name, false);
    adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig('FetchCustomerInfo');
    partyObj = FISCCFetchContactInfoExtension.getProfile(partyObj, adapterConfig);
    return partyObj;
  }

  public static boolean parseUpdateCustomerDOResponse(Object response) {
    tffa.Logger.debug('parseUpdateCustomerDOResponse ' + response);

    if (response instanceof FISCCDepositOriginationEntityResponse) {
      return true;
    }
    return false;
  }

  public static boolean parseUpdateCustomerNameAddressResponse(Object response) {
    tffa.Logger.debug('parseUpdateCustomerNameAddressResponse ' + response);

    if (response instanceof FISCCCustNameAddressResponseDTO) {
      return true;
    } else if (response instanceof Map<String, object>) {
      Map<String, object> responseMap = (Map<String, object>) response;
      if (responseMap.containsKey('Status')) {
        String statusCode = (String) responseMap.get('Status');
        if (statusCode.contains('CI00243')) {
          return true;
        }
      }
    }

    return false;
  }

  public static void updateCustToCustRelnship(tffa__Party__c partyObj) {
    tffa.Logger.debug('In updateCustToCustRelnship');
    List<CZInquireCustRelnResponseDTO.CustToCustRelnDataList> deleteRelnList = new List<CZInquireCustRelnResponseDTO.CustToCustRelnDataList>();
    List<Id> addRelnList = new List<Id>();
    List<String> checkedCustomersList = new List<String>();
    //Inquire the Party Org
    Map<String, CZInquireCustRelnResponseDTO.CustToCustRelnDataList> responseMap = fetchCustRelatedLst(partyObj);

    for (tffa__PartyPartyXref__c partyPartyObj : partyObj.tffa__PartyXrefs__r) {
      String custNumber = '';

      if (FISCCIntegrationLogService.partyObjMap.containsKey(partyPartyObj.tffa__RelatedParty__c)) {
        custNumber = FISCCIntegrationLogService.partyObjMap.get(partyPartyObj.tffa__RelatedParty__c).Customer_Number__c;
      }

      if (responseMap.containsKey(custNumber)) {
        CZInquireCustRelnResponseDTO.CustToCustRelnDataList relatedCust = responseMap.get(custNumber);

        if (
          relatedCust.E1toE2Cde == partyPartyObj.tffa__RelationCode__r.tffa__Value__c &&
          relatedCust.E2toE1Cde == partyPartyObj.tffa__RelationCode__r.CZToRelnCode__c &&
          relatedCust.RltBeneTitle != null &&
          relatedCust.RltBeneTitle.equalsIgnoreCase(partyPartyObj.tffa__Title__c) &&
          relatedCust.RltPercentOwner == partyPartyObj.tffa__OwnershipPercentage__c
        ) {
          tffa.Logger.debug('No Change in the related party');
        } else {
          deleteRelnList.add(relatedCust);
          addRelnList.add(partyPartyObj.tffa__RelatedParty__c);
        }
        checkedCustomersList.add(custNumber);
      } else {
        addRelnList.add(partyPartyObj.tffa__RelatedParty__c);
      }
    }
    for (CZInquireCustRelnResponseDTO.CustToCustRelnDataList relatedLst : responseMap.values()) {
      if (!checkedCustomersList.contains(relatedLst.RltCustNbr)) {
        deleteRelnList.add(relatedLst);
      }
    }

    boolean deletedCustReln = deleteCustReln(deleteRelnList, partyObj.Customer_Number__c);
    if (deletedCustReln && !addRelnList.isEmpty()) {
      addCustomerRelations(addRelnList, partyObj);
    }
  }

  public static boolean addCustomerRelations(List<String> relnList, tffa__Party__c partyObj) {
    tffa.Logger.debug('In addCustomerRelations');
    FISCC_Adapter_Configs__mdt adapterConfig;
    Boolean isSuccess = true;
    try {
      if (String.isBlank(FISCCIntegrationLogService.auth)) {
        FISCCIntegrationLogService.auth = FISCCGetAccessTokenProvider.processGetAccessToken(FISCCIntegrationLogService.charterConfig);
      }

      adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig(FISCCIntegrationConstants.CUST_TO_CUST_RELN_ADAPTERCONFIG);

      do {
        FISCCIntegrationLogService.setCurrentLogItem('Add Cust Reln', partyObj.Customer_Number__c, true);
        Integer relnAdded = 0;

        //Generate Req
        List<Id> customerToCustomerRelnCreated = new List<Id>();
        FISCCCustToCustRelnRequestDTO reqDto = new FISCCCustToCustRelnRequestDTO();
        reqDto.ccMaintainedCust.CustNbr = partyObj.Customer_Number__c;
        for (tffa__PartyPartyXref__c partyPartyObj : partyObj.tffa__PartyXrefs__r) {
          if (relnAdded < 10 && relnList.contains(partyPartyObj.tffa__RelatedParty__c) && !partyPartyObj.CZFisRelnshipCreated__c) {
            FISCCCustToCustRelnRequestDTO.CustomerRelnship relnDto = new FISCCCustToCustRelnRequestDTO.CustomerRelnship();

            relnDto.E1toE2Cde = partyPartyObj.tffa__RelationCode__r.tffa__Value__c;
            relnDto.E2toE1Cde = partyPartyObj.tffa__RelationCode__r.CZToRelnCode__c;
            relnDto.RltBeneTitle = partyPartyObj.tffa__Title__c;
            relnDto.RltPercentOwner = partyPartyObj.tffa__OwnershipPercentage__c != null
              ? String.valueOf(partyPartyObj.tffa__OwnershipPercentage__c)
              : null;
            if (FISCCIntegrationLogService.partyObjMap.containsKey(partyPartyObj.tffa__RelatedParty__c)) {
              relnDto.RltCustNbr = FISCCIntegrationLogService.partyObjMap.get(partyPartyObj.tffa__RelatedParty__c).Customer_Number__c;
            }
            customerToCustomerRelnCreated.add(partyPartyObj.Id);
            reqDto.customerRelnship.add(relnDto);
            relnAdded++;
          }
        }
        FISCCRequestBaseDTO fisccRequestBaseDTO = reqDto;
        //Call the API
        Object result = FISCCHostAdapter.processHostRequest(fisccRequestBaseDTO, adapterConfig, FISCCIntegrationLogService.charterConfig);

        if (parseRelnResponse(result, partyObj, customerToCustomerRelnCreated)) {
          FISCCIntegrationLogService.setLogOk(FISCCIntegrationConstants.LOG_ITEM_STATUS_SUCCESS);
        } else {
          FISCCIntegrationLogService.setLogFailed(FISCCIntegrationConstants.LOG_ITEM_STATUS_FAILURE);
        }
      } while (false && customerRelnCreationPending(partyObj, relnList));
    } catch (Exception ex) {
      tffa.Logger.error('Exception in addCustomerRelations ' + ex.getStackTraceString());
      FISCCIntegrationLogService.setLogFailed(FISCCIntegrationConstants.LOG_ITEM_STATUS_FAILURE);
    }
    return true;
  }

  public static boolean parseRelnResponse(Object response, tffa__Party__c party, List<Id> customerToCustomerRelnCreated) {
    try {
      if (response instanceof FISCCCustToCustRelnDTO) {
        FISCCCustToCustRelnDTO custToCustResp = (FISCCCustToCustRelnDTO) response;
        tffa.Logger.debug('parseRelnResponse1111--> ' + FISCCIntegrationLogService.partyObjMap.get(party.Id).tffa__PartyXrefs__r);
        tffa.Logger.debug('customerToCustomerRelnCreated--> ' + customerToCustomerRelnCreated);

        for (tffa__PartyPartyXref__c partyPartyObj : FISCCIntegrationLogService.partyObjMap.get(party.Id).tffa__PartyXrefs__r) {
          if (customerToCustomerRelnCreated.contains(partyPartyObj.Id)) {
            tffa.Logger.debug('Contains workeddd');
            partyPartyObj.CZFisRelnshipCreated__c = true;
          }
        }
        tffa.Logger.debug('parseRelnResponse1111--> ' + FISCCIntegrationLogService.partyObjMap.get(party.Id).tffa__PartyXrefs__r);
        return true;
      } else {
        return false;
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in parseRelnResponse ' + ex.getStackTraceString());
      return false;
    }
  }

  public static boolean deleteCustReln(List<CZInquireCustRelnResponseDTO.CustToCustRelnDataList> relationList, String custNumber) {
    tffa.Logger.debug('deleteCustReln');
    FISCC_Adapter_Configs__mdt adapterConfig;
    Boolean isSuccess = true;
    if (String.isBlank(FISCCIntegrationLogService.auth)) {
      FISCCIntegrationLogService.auth = FISCCGetAccessTokenProvider.processGetAccessToken(FISCCIntegrationLogService.charterConfig);
    }

    for (CZInquireCustRelnResponseDTO.CustToCustRelnDataList relatedCust : relationList) {
      if (isSuccess) {
        try {
          FISCCIntegrationLogService.setCurrentLogItem('Delete Cust Reln', relatedCust.RltCustNbr, false);
          adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig('DeleteCustomerReln');
          if (!Test.isRunningTest()) {
            adapterConfig.ServiceURL__c = adapterConfig.ServiceURL__c.replace('{CustNbr}', FISCCCommonHelper.encrypt(custNumber));

            adapterConfig.ServiceURL__c = adapterConfig.ServiceURL__c.replace(
              '{RltCustNbr}',
              FISCCCommonHelper.encrypt(relatedCust.RltCustNbr)
            );
          }
          adapterConfig.ServiceURL__c = adapterConfig.ServiceURL__c.replace('{EffDte}', relatedCust.EffDte);
          adapterConfig.ServiceURL__c = adapterConfig.ServiceURL__c.replace('{E1toE2Cde}', relatedCust.E1toE2Cde);
          adapterConfig.ServiceURL__c = adapterConfig.ServiceURL__c.replace('{E2toE1Cde}', relatedCust.E2toE1Cde);
          Object result = FISCCHostAdapter.processHostRequest(null, adapterConfig, FISCCIntegrationLogService.charterConfig);
          if (result != null) {
            isSuccess = parseDeleteRelnResponse(result);
          } else {
            FISCCIntegrationLogService.setLogFailed(FISCCIntegrationConstants.LOG_ITEM_STATUS_FAILURE);
            isSuccess = false;
          }
        } catch (Exception ex) {
          tffa.Logger.error('Exception in deleteCustReln ' + ex.getStackTraceString());
          FISCCIntegrationLogService.setLogFailed(FISCCIntegrationConstants.LOG_ITEM_STATUS_FAILURE);
        }
      }
    }
    return isSuccess;
  }

  public static boolean parseDeleteRelnResponse(Object response) {
    try {
      if (response instanceof FISCCCustToCustRelnDTO) {
        FISCCIntegrationLogService.setLogOk(FISCCIntegrationConstants.LOG_ITEM_STATUS_SUCCESS);
        return true;
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in parseDeleteRelnResponse ' + ex.getStackTraceString());
    }
    FISCCIntegrationLogService.setLogFailed(FISCCIntegrationConstants.LOG_ITEM_STATUS_FAILURE);
    return false;
  }

  public static Map<String, CZInquireCustRelnResponseDTO.CustToCustRelnDataList> fetchCustRelatedLst(tffa__Party__c partyObj) {
    FISCC_Adapter_Configs__mdt adapterConfig;
    List<CZInquireCustRelnResponseDTO.CustToCustRelnDataList> custRelations = new List<CZInquireCustRelnResponseDTO.CustToCustRelnDataList>();
    Map<String, CZInquireCustRelnResponseDTO.CustToCustRelnDataList> responseMap = new Map<String, CZInquireCustRelnResponseDTO.CustToCustRelnDataList>();
    if (String.isBlank(FISCCIntegrationLogService.auth)) {
      FISCCIntegrationLogService.auth = FISCCGetAccessTokenProvider.processGetAccessToken(FISCCIntegrationLogService.charterConfig);
    }
    FISCCIntegrationLogService.setCurrentLogItem('InquireCustomerReln', partyObj.Name, false);
    adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig('InquireCustomerReln');

    try {
      if (!Test.isRunningTest()) {
        adapterConfig.ServiceURL__c = adapterConfig.ServiceURL__c.replace(
          '{CustNbr}',
          FISCCCommonHelper.encrypt(partyObj.Customer_Number__c)
        );
      }
      Object result = FISCCHostAdapter.processHostRequest(null, adapterConfig, FISCCIntegrationLogService.charterConfig);
      if (result != null) {
        responseMap = parseInquireRelnResponse(result);
      } else {
        return null;
      }
    } catch (Exception ex) {
      FISCCIntegrationLogService.setLogFailed(FISCCIntegrationConstants.LOG_ITEM_STATUS_FAILURE);
      tffa.Logger.error('Exception in fetchCustRelatedLst ' + ex.getStackTraceString() + ' ' + ex.getLineNumber());
    }
    FISCCIntegrationLogService.setLogOk(FISCCIntegrationConstants.LOG_ITEM_STATUS_SUCCESS);
    return responseMap;
  }

  public static Map<String, CZInquireCustRelnResponseDTO.CustToCustRelnDataList> parseInquireRelnResponse(Object response) {
    tffa.Logger.debug('In parseInquireRelnResponse');
    Map<String, CZInquireCustRelnResponseDTO.CustToCustRelnDataList> responseMap = new Map<String, CZInquireCustRelnResponseDTO.CustToCustRelnDataList>();
    CZInquireCustRelnResponseDTO resp = new CZInquireCustRelnResponseDTO();
    if (response instanceof CZInquireCustRelnResponseDTO) {
      resp = (CZInquireCustRelnResponseDTO) response;
    } else {
      return responseMap;
    }
    for (CZInquireCustRelnResponseDTO.CustToCustRelnDataList relnData : resp.entity.custToCustRelnDataLst) {
      responseMap.put(relnData.RltCustNbr, relnData);
    }
    tffa.Logger.debug('In parseInquireRelnResponse Resp: ' + responseMap);
    return responseMap;
  }

  public static boolean customerRelnCreationPending(tffa__Party__c partyObj, List<String> relnList) {
    for (String partyId : relnList) {
      for (tffa__PartyPartyXref__c partyXref : partyObj.tffa__PartyXrefs__r) {
        if (partyId == partyXref.tffa__RelatedParty__c && !partyXref.CZFisRelnshipCreated__c) {
          if (Test.isRunningTest()) {
            return false;
          }
          return true;
        }
      }
    }
    return false;
  }
}