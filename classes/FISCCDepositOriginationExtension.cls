public inherited sharing class FISCCDepositOriginationExtension {
  /*
  public static List<FISCCDepositOriginationRequestBaseDTO> createDepositOriginationRequest(
    List<tffa__Party__c> partyObjs,
    tffa__Application__c tfApp,
    tffa__Submission__c subObj,
    FISCC_Charter_Config__mdt charterConfig,
    FISCC_Adapter_Configs__mdt adapterConfig
  ) {
    List<FISCCDepositOriginationRequestBaseDTO> lstFISCCDepositOriginationRequestBaseDTO = new List<FISCCDepositOriginationRequestBaseDTO>();

    String strDeveloperName = FISCCIntegrationConstants.DeveloperName_Deposit_Originate;
    String strBrandCode = FISCCIntegrationConstants.Brand_Code;
    String custAddKey = null;
    Integer totalParties = partyObjs.size();
    tffa.logger.debug('----------------------totalParties ==>' + totalParties);
    tffa.logger.debug('appObj in FISCCDepositOriginationExtension ==> ' + tfApp);
    Integer jointApplicantCounter = 1;
    FISCCDepositOriginationRequest objFISCCDepositOriginationRequest = new FISCCDepositOriginationRequest();

    FISCCDepositOriginationRequestBaseDTO objFISCCDepositOriginationRequestBaseDTO;

    tffa__Party__c primaryParty = CZWTFCCommonHelper.getPrimaryParty(subObj, partyObjs);

    for (tffa__Party__c tfParty : partyObjs) {
      Boolean isPrimary = primaryParty.Id.equals(tfParty.Id);
      tffa.logger.debug('isPrimary ==>' + isPrimary);
      tffa.logger.debug(
        jointApplicantCounter +
        'objFISCCDepositOriginationRequestBaseDTO1:::11' +
        objFISCCDepositOriginationRequestBaseDTO
      );

      tffa.logger.debug('tfParty.Customer_Number__c ==>' + tfParty.Customer_Number__c);
      if (String.isBlank(tfParty.Customer_Number__c)) {
        tffa.logger.debug('Inside cusotmer Number is Blank');
        objFISCCDepositOriginationRequestBaseDTO = (FISCCDepositOriginationRequestBaseDTO) createCustomerRequest(
          tfParty,
          subObj,
          adapterConfig,
          charterConfig
        );

        lstFISCCDepositOriginationRequestBaseDTO.add(objFISCCDepositOriginationRequestBaseDTO);
        if (isPrimary) {
          objFISCCDepositOriginationRequestBaseDTO = (FISCCDepositOriginationRequestBaseDTO) createMBPassForApplicant(
            FISCCIntegrationConstants.Deposit_Originate_Primary_Customer
          );
        } else {
          if (jointApplicantCounter == 1) {
            objFISCCDepositOriginationRequestBaseDTO = (FISCCDepositOriginationRequestBaseDTO) createMBPassForApplicant(
              FISCCIntegrationConstants.Deposit_Originate_FirstJoint_Customer
            );
          } else if (jointApplicantCounter == 2) {
            objFISCCDepositOriginationRequestBaseDTO = (FISCCDepositOriginationRequestBaseDTO) createMBPassForApplicant(
              FISCCIntegrationConstants.Deposit_Originate_SecondJoint_Customer
            );
          } else if (jointApplicantCounter == 3) {
            objFISCCDepositOriginationRequestBaseDTO = (FISCCDepositOriginationRequestBaseDTO) createMBPassForApplicant(
              FISCCIntegrationConstants.Deposit_Originate_ThirdJoint_Customer
            );
          }
        }
        lstFISCCDepositOriginationRequestBaseDTO.add(objFISCCDepositOriginationRequestBaseDTO);

        tffa.logger.debug(
          jointApplicantCounter +
          'lstFISCCDepositOriginationRequestBaseDTO:::55' +
          lstFISCCDepositOriginationRequestBaseDTO
        );

        objFISCCDepositOriginationRequestBaseDTO = (FISCCDepositOriginationRequestBaseDTO) createCustomerEmailRequest(
          new List<tffa__Party__c>{ tfParty },
          adapterConfig,
          charterConfig
        );
        lstFISCCDepositOriginationRequestBaseDTO.add(objFISCCDepositOriginationRequestBaseDTO);
      }
      if (!isPrimary) {
        jointApplicantCounter++;
      }
    }

    //add Date of Birth if updated for Auth User
    List<FISCCDepositOriginationRequestBaseDTO> dobUpdateDOBaseDTOLst = new List<FISCCDepositOriginationRequestBaseDTO>();
    dobUpdateDOBaseDTOLst = FISCCPartyDobUpdateExtension.generateRequest(partyObjs);
    if (dobUpdateDOBaseDTOLst != null && !dobUpdateDOBaseDTOLst.isEmpty()) {
      lstFISCCDepositOriginationRequestBaseDTO.addAll(dobUpdateDOBaseDTOLst);
    }

    //Add Beneficiary in Req
    if (tfApp != null && tfApp.tffa__Beneficiaries__r != null && !tfApp.tffa__Beneficiaries__r.isEmpty()) {
      for (tffa__Beneficiary__c benefObj : tfApp.tffa__Beneficiaries__r) {
        objFISCCDepositOriginationRequestBaseDTO = (FISCCDepositOriginationRequestBaseDTO) createBeneficiaryRequest(
          benefObj,
          subObj,
          tfApp,
          adapterConfig,
          charterConfig
        );
        lstFISCCDepositOriginationRequestBaseDTO.add(objFISCCDepositOriginationRequestBaseDTO);
      }
    }

    List<tffa__Application__c> lstApp = new List<tffa__Application__c>();
    lstApp.add(tfApp);
    objFISCCDepositOriginationRequestBaseDTO = (FISCCDepositOriginationRequestBaseDTO) createDepositAccountNumberRequest(
      subObj,
      tfApp,
      adapterConfig,
      charterConfig
    );
    lstFISCCDepositOriginationRequestBaseDTO.add(objFISCCDepositOriginationRequestBaseDTO);
    //add MBPASS
    objFISCCDepositOriginationRequestBaseDTO = (FISCCDepositOriginationRequestBaseDTO) createMBPassDepositAccountNumber(tfApp);
    lstFISCCDepositOriginationRequestBaseDTO.add(objFISCCDepositOriginationRequestBaseDTO);

    // add "deposit-account" in "Deposit-OriginationLst"
    objFISCCDepositOriginationRequestBaseDTO = (FISCCDepositOriginationRequestBaseDTO) createNewDepositAccountRequest(
      partyObjs,
      lstApp,
      adapterConfig,
      charterConfig
    );
    lstFISCCDepositOriginationRequestBaseDTO.add(objFISCCDepositOriginationRequestBaseDTO);
    // add "deposit-addresses" in "Deposit-OriginationLst"
    objFISCCDepositOriginationRequestBaseDTO = (FISCCDepositOriginationRequestBaseDTO) createDepositNameAddressRequest(
      partyObjs,
      lstApp,
      adapterConfig,
      charterConfig
    );
    lstFISCCDepositOriginationRequestBaseDTO.add(objFISCCDepositOriginationRequestBaseDTO);
    // add "customer-accounts" in "Deposit-OriginationLst"
    objFISCCDepositOriginationRequestBaseDTO = (FISCCDepositOriginationRequestBaseDTO) createCustomerAccountRelationRequest(
      partyObjs,
      lstApp,
      adapterConfig,
      charterConfig
    );
    lstFISCCDepositOriginationRequestBaseDTO.add(objFISCCDepositOriginationRequestBaseDTO);

    return lstFISCCDepositOriginationRequestBaseDTO;
  }

  public static boolean invokeDepositOriginationApiCall(
    List<tffa__Party__c> partyObjs,
    tffa__Application__c tfApp,
    tffa__Submission__c subObj
  ) {
    FISCCRequestBaseDTO fisccRequestBaseDTO;
    FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig(
      FISCCIntegrationConstants.DeveloperName_Deposit_Originate
    );
    List<FISCCDepositOriginationRequestBaseDTO> lstFISCCDepositOriginationRequestBaseDTO = FISCCDepositOriginationExtension.createDepositOriginationRequest(
      partyObjs,
      tfApp,
      subObj,
      FISCCIntegrationLogService.charterConfig,
      adapterConfig
    );

    String strDeveloperName = FISCCIntegrationConstants.DeveloperName_Deposit_Originate;
    String strBrandCode = FISCCIntegrationConstants.Brand_Code;
    FISCCDepositOriginationRequest objFISCCDepositOriginationRequest = new FISCCDepositOriginationRequest();
    tffa.logger.debug('lstFISCCDepositOriginationRequestBaseDTO.size()' + lstFISCCDepositOriginationRequestBaseDTO.size());
    tffa.logger.debug('lstFISCCDepositOriginationRequestBaseDTO in DO build Request ==>' + lstFISCCDepositOriginationRequestBaseDTO);
    objFISCCDepositOriginationRequest.DepositOriginationLst = lstFISCCDepositOriginationRequestBaseDTO;
    tffa.logger.debug(
      'objFISCCDepositOriginationRequest.DepositOriginationLst in DO build Request ==>' +
      objFISCCDepositOriginationRequest.DepositOriginationLst
    );

    tffa.logger.debug('objFISCCDepositOriginationRequest in DO build Request ==>' + objFISCCDepositOriginationRequest);
    fisccRequestBaseDTO = objFISCCDepositOriginationRequest;

    Object result = null;
    boolean isCreateCustomerSuccess = false;

    result = FISCCHostAdapter.processHostRequest(fisccRequestBaseDTO, adapterConfig, FISCCIntegrationLogService.charterConfig);

    tffa.logger.debug('result in DO==>' + result); //perOutPutResponse -- Entity

    if (isFISCCAPICallSuccess(result, partyObjs, new List<tffa__Application__c>{ tfApp })) {
      // --IntegrationLogService.setLogItemMessage
      FISCCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.DEPOSIT_ORIGINATOR);
      FISCCIntegrationLogService.setLogItemMessage('Deposit Origination Success ...!!!');
      isCreateCustomerSuccess = true;
    } else {
      // --IntegrationLogService.setLogItemMessage
      FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.DEPOSIT_ORIGINATOR);
      FISCCIntegrationLogService.setLogItemMessage(FISCCIntegrationConstants.ErrorMessage);
      isCreateCustomerSuccess = false;
    }

    return isCreateCustomerSuccess;
  }
  //call customerExtension to populate DTO
  public static FISCCDepositOriginationRequestBaseDTO createCustomerRequest(
    tffa__Party__c partyObj,
    tffa__Submission__c subObj,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    FISCCDOCustomerIndividualRequest objFISCCCustomerIndividualRequest = new FISCCDOCustomerIndividualRequest();

    objFISCCCustomerIndividualRequest.customer = FISCCCreateCustomerIndividualHelper.createCustomerRequest(
      partyObj,
      subObj,
      adapterConfig,
      charterConfig
    );

    objFISCCCustomerIndividualRequest.SvcID = FISCCIntegrationConstants.SVCID_CreateCustomer;

    tffa.logger.debug('objFISCCCustomerIndividualRequest FISCCDOCreateCustomerExtension ==> ' + objFISCCCustomerIndividualRequest);

    return objFISCCCustomerIndividualRequest;
  }
  //create MBPASS for Applicant
  public static FISCCDepositOriginationRequestBaseDTO createMBPassForApplicant(String mbPassDeveloperName) {
    MBPass__mdt mbPass;
    mbPass = MBPass__mdt.getInstance(FISCCIntegrationConstants.Deposit_Originate_Email);
    FISCCDOMBPassRequest objFISCCDOMBPassRequest = new FISCCDOMBPassRequest();
    FISCCMBPassDTO objFISCCMBPassDTO_Applicant = new FISCCMBPassDTO();
    FISCCDepositOriginationRequestBaseDTO objFISCCDepositOriginationRequestBaseDTO;
    // create MBPASS for email
    FISCCMBPassDTO objFISCCMBPassDTO = new FISCCMBPassDTO();
    objFISCCMBPassDTO.SrcDataTag = mbPass.srcDataTag__c;
    objFISCCMBPassDTO.DestServId = mbPass.destServId__c;
    objFISCCMBPassDTO.DestDataTag = mbPass.destDataTag__c;
    objFISCCMBPassDTO.TrimTyp = mbPass.trimTyp__c;
    objFISCCMBPassDTO.TrimSkip = Integer.valueOf(mbPass.trimSkip__c);
    objFISCCDOMBPassRequest.mbpassLst.add(objFISCCMBPassDTO);

    mbPass = MBPass__mdt.getInstance(mbPassDeveloperName);
    objFISCCMBPassDTO_Applicant.SrcDataTag = mbPass.srcDataTag__c;
    objFISCCMBPassDTO_Applicant.DestServId = mbPass.destServId__c;
    objFISCCMBPassDTO_Applicant.DestDataTag = mbPass.destDataTag__c;
    objFISCCMBPassDTO_Applicant.TrimTyp = mbPass.trimTyp__c;
    objFISCCMBPassDTO_Applicant.TrimSkip = Integer.valueOf(mbPass.trimSkip__c);
    objFISCCDOMBPassRequest.mbpassLst.add(objFISCCMBPassDTO_Applicant);
    objFISCCDepositOriginationRequestBaseDTO = objFISCCDOMBPassRequest;
    objFISCCDepositOriginationRequestBaseDTO.SvcID = FISCCIntegrationConstants.SVCID_MBPASS;
    return objFISCCDepositOriginationRequestBaseDTO;
  }

  public static FISCCDepositOriginationRequestBaseDTO createBeneficiaryRequest(
    tffa__Beneficiary__c benefObj,
    tffa__Submission__c submissionObj,
    tffa__Application__c appObj,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    tffa.logger.debug(' inside  FISCCDepositOriginationRequestBaseDTO createBeneficiaryRequest');
    FISCCDOCustomerIndividualRequest objFISCCCustomerIndividualRequest = new FISCCDOCustomerIndividualRequest();
    FISCCDepositOriginationRequestBaseDTO objFISCCDepositOriginationRequestBaseDTO = null;
    objFISCCCustomerIndividualRequest.customer = FISCCCreateBenefCustomerRequest.createBeneficiaryRequest(
      benefObj,
      submissionObj,
      appObj,
      adapterConfig,
      charterConfig
    );

    tffa.logger.debug('createBeneficiaryRequest objFISCCDepositOriginationRequestBaseDTO' + objFISCCDepositOriginationRequestBaseDTO);

    objFISCCCustomerIndividualRequest.SvcID = FISCCIntegrationConstants.SVCID_CreateCustomer;

    return objFISCCCustomerIndividualRequest;
  }

  // Email Address Request - CI044
  public static FISCCDepositOriginationRequestBaseDTO createCustomerEmailRequest(
    List<tffa__Party__c> partyObjs,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    tffa.logger.debug(' inside  FISCCDepositOriginationRequestBaseDTO createCustomerEmailRequest');
    FISCCDepositOriginationRequestBaseDTO objFISCCDepositOriginationRequestBaseDTO = null;
    objFISCCDepositOriginationRequestBaseDTO = FISCCDOCustomerEmailExtension.customerEmailRequest(partyObjs, adapterConfig, charterConfig);
    tffa.logger.debug('  createCustomerEmailRequest objFISCCDepositOriginationRequestBaseDTO' + objFISCCDepositOriginationRequestBaseDTO);

    objFISCCDepositOriginationRequestBaseDTO.SvcID = FISCCIntegrationConstants.SVCID_CustomerEmail;

    tffa.logger.debug(
      'objFISCCDepositOriginationRequestBaseDTO FISCCDOCreateCustomerExtension ==> ' + objFISCCDepositOriginationRequestBaseDTO
    );

    return objFISCCDepositOriginationRequestBaseDTO;
  }
  //DepositAccountNumber Request - DLANG
  public static FISCCDepositOriginationRequestBaseDTO createDepositAccountNumberRequest(
    tffa__Submission__c subObj,
    tffa__Application__c appObj,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    tffa.logger.debug(' inside  FISCCDepositOriginationRequestBaseDTO createCustomerEmailRequest');
    FISCCDOGenerateDepositAccNumberRequest objFISCCDOGenerateDepositAccNumberRequest = new FISCCDOGenerateDepositAccNumberRequest();
    objFISCCDOGenerateDepositAccNumberRequest.depositAccountNumber = FISCCDOGenerateDepositAccNumberExtension.createDepositAccountNumberRequest(
      subObj,
      appObj,
      adapterConfig,
      charterConfig
    );
    tffa.logger.debug('  createCustomerEmailRequest objFISCCDepositOriginationRequestBaseDTO' + objFISCCDOGenerateDepositAccNumberRequest);

    objFISCCDOGenerateDepositAccNumberRequest.SvcID = FISCCIntegrationConstants.SVCID_DepositAccountNumber;

    tffa.logger.debug(
      'objFISCCDepositOriginationRequestBaseDTO FISCCDOCreateCustomerExtension ==> ' + objFISCCDOGenerateDepositAccNumberRequest
    );

    return objFISCCDOGenerateDepositAccNumberRequest;
  }

  //create MBPASS after deposit-account
  public static FISCCDepositOriginationRequestBaseDTO createMBPassDepositAccountNumber(tffa__Application__c appObject) {
    String strAccountDeveloperName = FISCCIntegrationConstants.Deposit_Originate_Deposit_Account;
    MBPass__mdt mbPass;
    mbPass = MBPass__mdt.getInstance(strAccountDeveloperName);
    FISCCDOMBPassRequest objFISCCDOMBPassRequest = new FISCCDOMBPassRequest();

    FISCCDepositOriginationRequestBaseDTO objFISCCDepositOriginationRequestBaseDTO;
    // create MBPASS for deposit-account
    FISCCMBPassDTO objFISCCMBPassDTO_Account = new FISCCMBPassDTO();
    objFISCCMBPassDTO_Account.SrcDataTag = mbPass.srcDataTag__c;
    objFISCCMBPassDTO_Account.DestServId = mbPass.destServId__c;
    objFISCCMBPassDTO_Account.DestDataTag = mbPass.destDataTag__c;
    objFISCCMBPassDTO_Account.TrimTyp = mbPass.trimTyp__c;
    objFISCCMBPassDTO_Account.TrimSkip = Integer.valueOf(mbPass.trimSkip__c);
    objFISCCDOMBPassRequest.mbpassLst.add(objFISCCMBPassDTO_Account);

    //create MBPass for deposit-addresses
    FISCCMBPassDTO objFISCCMBPassDTO_addresses = new FISCCMBPassDTO();
    String strAddressesDeveloperName = FISCCIntegrationConstants.Deposit_Originate_Deposit_Addresses;
    mbPass = MBPass__mdt.getInstance(strAddressesDeveloperName);
    objFISCCMBPassDTO_addresses.SrcDataTag = mbPass.srcDataTag__c;
    objFISCCMBPassDTO_addresses.DestServId = mbPass.destServId__c;
    objFISCCMBPassDTO_addresses.DestDataTag = mbPass.destDataTag__c;
    objFISCCMBPassDTO_addresses.TrimTyp = mbPass.trimTyp__c;
    objFISCCMBPassDTO_addresses.TrimSkip = Integer.valueOf(mbPass.trimSkip__c);
    objFISCCDOMBPassRequest.mbpassLst.add(objFISCCMBPassDTO_addresses);

    //create MBPass for customer-Account Relationship
    FISCCMBPassDTO objFISCCMBPassDTO_custAccounts = new FISCCMBPassDTO();
    String strCustAccountsDeveloperName = FISCCIntegrationConstants.Deposit_Originate_Customer_Accounts;
    mbPass = MBPass__mdt.getInstance(strCustAccountsDeveloperName);
    objFISCCMBPassDTO_custAccounts.SrcDataTag = mbPass.srcDataTag__c;
    objFISCCMBPassDTO_custAccounts.DestServId = mbPass.destServId__c;
    objFISCCMBPassDTO_custAccounts.DestDataTag = mbPass.destDataTag__c;
    objFISCCMBPassDTO_custAccounts.TrimTyp = mbPass.trimTyp__c;
    objFISCCMBPassDTO_custAccounts.TrimSkip = Integer.valueOf(mbPass.trimSkip__c);
    objFISCCDOMBPassRequest.mbpassLst.add(objFISCCMBPassDTO_custAccounts);

    objFISCCDepositOriginationRequestBaseDTO = objFISCCDOMBPassRequest;
    objFISCCDepositOriginationRequestBaseDTO.SvcID = FISCCIntegrationConstants.SVCID_MBPASS;
    return objFISCCDepositOriginationRequestBaseDTO;
  }

  // New DepositAccount - DLNEW Request
  public static FISCCDepositOriginationRequestBaseDTO createNewDepositAccountRequest(
    List<tffa__Party__c> partyObjs,
    List<tffa__Application__c> appObjs,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    tffa.logger.debug(' inside  FISCCDepositOriginationRequestBaseDTO createNewDepositAccountRequest');
    FISCCDOCreateNewDepositAccRequest objFISCCDOCreateNewDepositAccRequest = new FISCCDOCreateNewDepositAccRequest();
    objFISCCDOCreateNewDepositAccRequest.depositAccount = FISCCDOCreateNewDepositAccExtension.createNewDepositAccountRequest(
      partyObjs,
      appObjs,
      adapterConfig,
      charterConfig
    );
    objFISCCDOCreateNewDepositAccRequest.SvcID = FISCCIntegrationConstants.SVCID_NewDepositAccount;

    tffa.logger.debug(
      'objFISCCDepositOriginationRequestBaseDTO FISCCDOCreateCustomerExtension ==> ' + objFISCCDOCreateNewDepositAccRequest
    );

    return objFISCCDOCreateNewDepositAccRequest;
  }

  //DepositNameAndAddress - DLNAM Request
  public static FISCCDepositOriginationRequestBaseDTO createDepositNameAddressRequest(
    List<tffa__Party__c> partyObjs,
    List<tffa__Application__c> appObjs,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    tffa.logger.debug(' inside  FISCCDepositOriginationRequestBaseDTO createDepositNameAddressRequest');
    FISCCDepositOriginationRequestBaseDTO objFISCCDepositOriginationRequestBaseDTO = null;
    objFISCCDepositOriginationRequestBaseDTO = FISCCDODepositNameAddressExtension.invokeDepositNameAddress(
      partyObjs,
      appObjs,
      adapterConfig,
      charterConfig
    );
    tffa.logger.debug(
      '  createDepositNameAddressRequest objFISCCDepositOriginationRequestBaseDTO' + objFISCCDepositOriginationRequestBaseDTO
    );

    objFISCCDepositOriginationRequestBaseDTO.SvcID = FISCCIntegrationConstants.SVCID_DepositNameAddress;
    //objFISCCDepositOriginationRequestBaseDTO = objFISCCDOCustomerDTO;

    tffa.logger.debug(
      'objFISCCDepositOriginationRequestBaseDTO createDepositNameAddressRequest ==> ' + objFISCCDepositOriginationRequestBaseDTO
    );

    return objFISCCDepositOriginationRequestBaseDTO;
  }

  //CustomerAccountRelation - CI009 Request
  public static FISCCDepositOriginationRequestBaseDTO createCustomerAccountRelationRequest(
    List<tffa__Party__c> partyObjs,
    List<tffa__Application__c> appObjs,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    tffa.logger.debug(' inside  FISCCDepositOriginationRequestBaseDTO createCustomerAccountRelationRequest');
    FISCCDepositOriginationRequestBaseDTO objFISCCDepositOriginationRequestBaseDTO = null;
    objFISCCDepositOriginationRequestBaseDTO = FISCCDOCustomerAccountRelationExtension.invokeCustomerAccountRelation(
      partyObjs,
      appObjs,
      adapterConfig,
      charterConfig
    );
    tffa.logger.debug(
      '  createCustomerAccountRelationRequest objFISCCDepositOriginationRequestBaseDTO' + objFISCCDepositOriginationRequestBaseDTO
    );
    /*FISCCDOCustomerDTO objFISCCDOCustomerDTO = new FISCCDOCustomerDTO();
     objFISCCDOCustomerDTO.customer = objFISCCCustomerDTO;
    objFISCCDepositOriginationRequestBaseDTO.SvcID = FISCCIntegrationConstants.SVCID_CustomerAccount;
    //objFISCCDepositOriginationRequestBaseDTO = objFISCCDOCustomerDTO;

    tffa.logger.debug(
      'objFISCCDepositOriginationRequestBaseDTO createDepositNameAddressRequest ==> ' + objFISCCDepositOriginationRequestBaseDTO
    );

    return objFISCCDepositOriginationRequestBaseDTO;
  }

  //update records back to Salesforce
  public static boolean isFISCCAPICallSuccess(Object response, List<tffa__Party__c> partyObjs, List<tffa__Application__c> appObjs) {
    tffa.logger.debug('ppppparty in apisuccess call ' + partyObjs);
    tffa.logger.debug('FISCCCreateCustomerExtension :response inside isFISCCAPICallSuccess ==>' + response);
    Boolean result = null;

    try {
      if (response == null || !(response instanceof FISCCDepositOriginationEntityResponse)) {
        // create applicationConstants class to set result
        result = false;
        return false;
      }
      FISCCDepositOriginationEntityResponse fisccDepositOriginationEntityResponse = (FISCCDepositOriginationEntityResponse) response;
      tffa.logger.debug('FISCCDepositOriginationEntityResponse ==> ' + fisccDepositOriginationEntityResponse);
      Integer partyCounter = 0;
      Integer counterApp = 0;
      Integer overallCounter = 0;
      Integer benefCounter = 0;
      tffa.logger.debug(
        ' fisccDepositOriginationEntityResponse.Entity.DepositOriginationLst.size() ==>' +
        fisccDepositOriginationEntityResponse.Entity.DepositOriginationLst.size()
      );
      for (
        FISCCDepositOriginationResponse fisccResponseDepositOrigination : fisccDepositOriginationEntityResponse.Entity.DepositOriginationLst
      ) {
        tffa.logger.debug('fisccResponseDepositOrigination ==> ' + fisccResponseDepositOrigination);
        if (fisccResponseDepositOrigination.SvcID.equalsIgnoreCase('CI007')) {
          // Get the index of next new customer
          while (partyObjs.size() > partyCounter && !(String.isBlank(partyObjs[partyCounter].Customer_Number__c))) {
            partyCounter++;
          }
          if ((partyObjs.size() > partyCounter) && String.isBlank(partyObjs[partyCounter].Customer_Number__c)) {
            partyObjs[partyCounter].Customer_Number__c = fisccResponseDepositOrigination.customer.CICustNbr;
            if (String.isNotBlank(fisccResponseDepositOrigination.customer.CISinceDte)) {
              partyObjs[partyCounter].tffa__OnboardingDate__c = date.valueOf(fisccResponseDepositOrigination.customer.CISinceDte);
            }
            tffa.logger.debug('DO partyObjs.Customer_Number__c ==>' + partyObjs[partyCounter].Customer_Number__c);
            partyCounter++;
          } else if (
            (partyObjs.size() <= partyCounter) &&
            appObjs[0].tffa__Beneficiaries__r != null &&
            !appObjs[0].tffa__Beneficiaries__r.isEmpty() &&
            (appObjs[0].tffa__Beneficiaries__r.size() > benefCounter)
          ) {
            tffa.Logger.debug('benefCtr' + benefCounter + 'CInbr' + fisccResponseDepositOrigination.customer.CICustNbr);
            appObjs[0].tffa__Beneficiaries__r[benefCounter].Customer_Number__c = fisccResponseDepositOrigination.customer.CICustNbr;
            benefCounter++;
          }
        }
        if (fisccResponseDepositOrigination.SvcID.equalsIgnoreCase('DLNEW')) {
          tffa.logger.debug(
            'fisccResponseDepositOrigination.depositAccount.AcctNbr ==>' + fisccResponseDepositOrigination.depositAccount.DPAcctNbrNewAcct
          );
          appObjs[0].CZAccountOpeningDate__c = DateTime.newInstance(System.today(), Time.newInstance(0, 0, 0, 0));
          String accountNbr = fisccResponseDepositOrigination.depositAccount.DPAcctNbrNewAcct;
          if (accountNbr != null) {
            appObjs[0].tffa__AccountNumber__c = accountNbr.leftPad(11, '0');
          }
          if (!appObjs[0].tffa__Status__c.equals(CZWTFCConstants.FUNDED))
            appObjs[0].tffa__Status__c = CZWTFCConstants.ACCOUNT_OPENED;
          tffa.logger.debug('Account Numnber updated ==>' + appObjs[0].tffa__AccountNumber__c);
        } else if (
          fisccResponseDepositOrigination.SvcID.equalsIgnoreCase('DLDLR') || fisccResponseDepositOrigination.SvcID.equalsIgnoreCase('DLTNC')
        ) {
          appObjs[0].tffa__Status__c = CZWTFCConstants.FUNDED;
          if (appObjs[0].tffa__LinkedFundingRequests__r != null && !appObjs[0].tffa__LinkedFundingRequests__r.isEmpty()) {
            appObjs[0].tffa__LinkedFundingRequests__r[0].IsCoreEntryComplete__c = true;
          }
        }
      }

      tffa.Logger.debug('uuuuuuppppppdate ' + FISCCIntegrationLogService.partyObjMap.values());
      result = true;
    } catch (Exception ex) {
      tffa.Logger.error('Exception in createCustomerAccountRelationRequest : ' + ex.getMessage() + ex.getStackTraceString());

      return false;
    }
    return result;
  }*/

  public static Map<Integer, Id> custCreationMap = new Map<Integer, Id>();
  public static List<Id> relnAdded = new List<Id>();
  public static List<Id> deputyId = new List<Id>();
  public static List<Id> doAddedPartylst = new List<Id>();

  public static boolean invokeDepositOriginationApiCall(
    List<tffa__Party__c> partyObjs,
    tffa__Application__c tfApp,
    tffa__Submission__c subObj
  ) {
    FISCCRequestBaseDTO fisccRequestBaseDTO;
    FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig(
      FISCCIntegrationConstants.DeveloperName_Deposit_Originate
    );
    List<FISCCDepositOriginationRequestBaseDTO> lstFISCCDepositOriginationRequestBaseDTO = FISCCDepositOriginationExtension.createDepositOriginationRequest(
      partyObjs,
      tfApp,
      subObj,
      FISCCIntegrationLogService.charterConfig,
      adapterConfig
    );

    //String strDeveloperName = FISCCIntegrationConstants.DeveloperName_Deposit_Originate;
    //String strBrandCode = FISCCIntegrationConstants.Brand_Code;
    FISCCDepositOriginationRequest objFISCCDepositOriginationRequest = new FISCCDepositOriginationRequest();
    objFISCCDepositOriginationRequest.DepositOriginationLst = lstFISCCDepositOriginationRequestBaseDTO;
    tffa.logger.debug(
      'objFISCCDepositOriginationRequest.DepositOriginationLst in DO build Request ==>' +
      objFISCCDepositOriginationRequest.DepositOriginationLst
    );
    fisccRequestBaseDTO = objFISCCDepositOriginationRequest;
    Object result = null;
    boolean isCreateCustomerSuccess = false;

    result = FISCCHostAdapter.processHostRequest(fisccRequestBaseDTO, adapterConfig, FISCCIntegrationLogService.charterConfig);

    tffa.logger.debug('result in DO==>' + result); //perOutPutResponse -- Entity

    if (isFISCCAPICallSuccess(result, partyObjs, tfApp)) {
      // --IntegrationLogService.setLogItemMessage
      FISCCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.DEPOSIT_ORIGINATOR);
      FISCCIntegrationLogService.setLogItemMessage('Deposit Origination Success ...!!!');
      isCreateCustomerSuccess = true;
    } else {
      if (FISCCIntegrationConstants.ErrorMessage.length() > 220) {
        tfApp.CZApplicationProcessingErrorMessage__c =
          FISCCIntegrationConstants.DEPOSIT_ORIGINATOR_FAILED +
          ' ' +
          FISCCIntegrationConstants.ErrorMessage.substring(0, 219);
      } else {
        tfApp.CZApplicationProcessingErrorMessage__c =
          FISCCIntegrationConstants.DEPOSIT_ORIGINATOR_FAILED +
          ' ' +
          FISCCIntegrationConstants.ErrorMessage;
      }

      FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.DEPOSIT_ORIGINATOR);
      FISCCIntegrationLogService.setLogItemMessage(FISCCIntegrationConstants.ErrorMessage);
      isCreateCustomerSuccess = false;
    }

    return isCreateCustomerSuccess;
  }

  public static boolean invokePendingApplicantCreation(
    List<tffa__Party__c> partyObjs,
    tffa__Application__c tfApp,
    tffa__Submission__c subObj
  ) {
    tffa.logger.debug('In invokePendingApplicantCreation');
    boolean isCreateCustomerSuccess = false;
    try {
      do {
        FISCCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.DEPOSIT_ORIGINATOR_CUSTOMER_CREATION, tfApp.Name, true);
        FISCCRequestBaseDTO fisccRequestBaseDTO;
        FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig(
          FISCCIntegrationConstants.DeveloperName_Deposit_Originate
        );
        List<FISCCDepositOriginationRequestBaseDTO> lstFISCCDepositOriginationRequestBaseDTO = FISCCDepositOriginationExtension.pendingApplicantCreationRequest(
          partyObjs,
          tfApp,
          subObj,
          FISCCIntegrationLogService.charterConfig,
          adapterConfig
        );

        FISCCDepositOriginationRequest objFISCCDepositOriginationRequest = new FISCCDepositOriginationRequest();
        objFISCCDepositOriginationRequest.DepositOriginationLst = lstFISCCDepositOriginationRequestBaseDTO;
        tffa.logger.debug(
          'objFISCCDepositOriginationRequest.DepositOriginationLst in pendingApplicantCreation DO build Request ==>' +
          objFISCCDepositOriginationRequest.DepositOriginationLst
        );
        fisccRequestBaseDTO = objFISCCDepositOriginationRequest;
        Object result = null;

        result = FISCCHostAdapter.processHostRequest(fisccRequestBaseDTO, adapterConfig, FISCCIntegrationLogService.charterConfig);

        if (checkApplicantCreationIsSuccess(result, partyObjs, tfApp)) {
          FISCCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.DEPOSIT_ORIGINATOR_CUSTOMER_CREATION);
          isCreateCustomerSuccess = true;
        } else {
          FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.DEPOSIT_ORIGINATOR_CUSTOMER_CREATION);
          isCreateCustomerSuccess = false;
          break;
        }

        tffa.logger.debug('result in DO==>' + result);
      } while (!CZWTFCCommonHelper.checkCustomerCreationCompleted(tfApp));
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in invokePendingApplicantCreation ' + ex.getLineNumber() + ' ' + ex.getMessage());
    }
    return isCreateCustomerSuccess;
  }

  public static boolean invokeDOBusinessCall(List<tffa__Party__c> partyObjs, tffa__Submission__c subObj) {
    tffa.Logger.debug('In invokeDOBusinessCall');
    boolean isCreateCustomerSuccess = false;
    try {
      do {
        custCreationMap.clear();
        FISCCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.DEPOSIT_ORIGINATOR_ORG_CREATION, 'Business/Owners', true);
        FISCCRequestBaseDTO fisccRequestBaseDTO;
        FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig(
          FISCCIntegrationConstants.DeveloperName_Deposit_Originate
        );
        List<FISCCDepositOriginationRequestBaseDTO> lstFISCCDepositOriginationRequestBaseDTO = createDORequestForBusiness(
          partyObjs,
          subObj,
          FISCCIntegrationLogService.charterConfig,
          adapterConfig
        );

        FISCCDepositOriginationRequest objFISCCDepositOriginationRequest = new FISCCDepositOriginationRequest();
        objFISCCDepositOriginationRequest.DepositOriginationLst = lstFISCCDepositOriginationRequestBaseDTO;
        tffa.logger.debug(
          'objFISCCDepositOriginationRequest.Create ORGANIZATION in invokeDOBusinessCall DO build Request ==>' +
          objFISCCDepositOriginationRequest.DepositOriginationLst
        );
        fisccRequestBaseDTO = objFISCCDepositOriginationRequest;
        Object result = null;

        result = FISCCHostAdapter.processHostRequest(fisccRequestBaseDTO, adapterConfig, FISCCIntegrationLogService.charterConfig);

        if (isBusAndOwnerCreationSuccess(result, partyObjs)) {
          FISCCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.DEPOSIT_ORIGINATOR_CUSTOMER_CREATION);
          isCreateCustomerSuccess = true;
        } else {
          FISCCCommonHelper.setErrormessageInSub();
          FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.DEPOSIT_ORIGINATOR_CUSTOMER_CREATION);
          isCreateCustomerSuccess = false;
          break;
        }
      } while (!CZWTFCCommonHelper.checkBusinessAndOwnerCreated(FISCCIntegrationLogService.partyObjMap, true, true));
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in invokePendingApplicantCreation ' + ex.getLineNumber() + ' ' + ex.getMessage());
    }
    return isCreateCustomerSuccess;
  }

  public static List<FISCCDepositOriginationRequestBaseDTO> createDORequestForBusiness(
    List<tffa__Party__c> partyObjs,
    tffa__Submission__c subObj,
    FISCC_Charter_Config__mdt charterConfig,
    FISCC_Adapter_Configs__mdt adapterConfig
  ) {
    List<FISCCDepositOriginationRequestBaseDTO> lstFISCCDepositOriginationRequestBaseDTO = new List<FISCCDepositOriginationRequestBaseDTO>();
    FISCCDepositOriginationRequestBaseDTO objFISCCDepositOriginationRequestBaseDTO;
    FISCCDepositOriginationRequest objFISCCDepositOriginationRequest = new FISCCDepositOriginationRequest();
    Integer partyCounter = 0;

    for (tffa__Party__c partyObj : partyObjs) {
      if (partyObj.tffa__Type__c == FISCCIntegrationConstants.ORGANIZATION && !doAddedPartylst.contains(partyObj.Id)) {
        if (String.isBlank(partyObj.Customer_Number__c)) {
          custCreationMap.put(partyCounter, partyObj.Id);
          doAddedPartylst.add(partyObj.Id);
          objFISCCDepositOriginationRequestBaseDTO = (FISCCDepositOriginationRequestBaseDTO) createOrganizationRequest(
            FISCCIntegrationLogService.partyObjMap.get(partyObj.Id),
            subObj,
            adapterConfig,
            charterConfig
          );
          lstFISCCDepositOriginationRequestBaseDTO.add(objFISCCDepositOriginationRequestBaseDTO);
          List<FISCCMBPassDTO> mbPassList = new List<FISCCMBPassDTO>();
          mbPassList = createMBPassForApplicantDDAndEmail();

          if (String.isBlank(partyObj.tffa__PrimaryEmail__c)) {
            mbPassList.remove(0);
          }

          FISCCDOMBPassRequest objFISCCDOMBPassRequest = new FISCCDOMBPassRequest();
          objFISCCDOMBPassRequest.mbpassLst.addAll(mbPassList);
          FISCCDepositOriginationRequestBaseDTO mbPassFISCCDepositOriginationRequestBaseDTO;
          mbPassFISCCDepositOriginationRequestBaseDTO = objFISCCDOMBPassRequest;
          mbPassFISCCDepositOriginationRequestBaseDTO.SvcID = FISCCIntegrationConstants.SVCID_MBPASS;
          lstFISCCDepositOriginationRequestBaseDTO.add(mbPassFISCCDepositOriginationRequestBaseDTO);

          //Email DTO
          if (String.isNotBlank(partyObj.tffa__PrimaryEmail__c)) {
            objFISCCDepositOriginationRequestBaseDTO = (FISCCDepositOriginationRequestBaseDTO) createCustomerEmailRequest(
              new List<tffa__Party__c>{ partyObj },
              adapterConfig,
              charterConfig
            );
            lstFISCCDepositOriginationRequestBaseDTO.add(objFISCCDepositOriginationRequestBaseDTO);
          }
          //DueDiligence DTO
          //if (CZWTFCCommonHelper.checkMailingAddPresent(partyObj)) {
          objFISCCDepositOriginationRequestBaseDTO = (FISCCDepositOriginationRequestBaseDTO) createDueDiligenceRequest(
            partyObj,
            adapterConfig,
            charterConfig
          );
          lstFISCCDepositOriginationRequestBaseDTO.add(objFISCCDepositOriginationRequestBaseDTO);
          //}
          partyCounter++;
        }
      }
    }

    //owners

    for (tffa__Party__c partyObj : partyObjs) {
      if (custCreationMap.size() < FISCCIntegrationConstants.CUSTOMER_CREATION_LIMIT) {
        if (
          partyObj.tffa__Type__c == FISCCIntegrationConstants.ORGANIZATION &&
          partyObj.tffa__PartyXrefs__r != null &&
          !partyObj.tffa__PartyXrefs__r.isEmpty()
        ) {
          for (tffa__PartyPartyXref__c partyPartyObj : partyObj.tffa__PartyXrefs__r) {
            if (custCreationMap.size() < FISCCIntegrationConstants.CUSTOMER_CREATION_LIMIT) {
              if (
                FISCCIntegrationLogService.partyObjMap.containsKey(partyPartyObj.tffa__RelatedParty__c) &&
                String.isBlank(FISCCIntegrationLogService.partyObjMap.get(partyPartyObj.tffa__RelatedParty__c).Customer_Number__c) &&
                !doAddedPartylst.contains(partyPartyObj.tffa__RelatedParty__c)
              ) {
                custCreationMap.put(partyCounter, FISCCIntegrationLogService.partyObjMap.get(partyPartyObj.tffa__RelatedParty__c).Id);
                doAddedPartylst.add(partyPartyObj.tffa__RelatedParty__c);
                objFISCCDepositOriginationRequestBaseDTO = (FISCCDepositOriginationRequestBaseDTO) createCustomerRequest(
                  FISCCIntegrationLogService.partyObjMap.get(partyPartyObj.tffa__RelatedParty__c),
                  subObj,
                  adapterConfig,
                  charterConfig
                );

                lstFISCCDepositOriginationRequestBaseDTO.add(objFISCCDepositOriginationRequestBaseDTO);
                List<FISCCMBPassDTO> mbPassList = new List<FISCCMBPassDTO>();
                mbPassList = createMBPassForApplicantDDAndEmail();

                if (String.isBlank(FISCCIntegrationLogService.partyObjMap.get(partyPartyObj.tffa__RelatedParty__c).tffa__PrimaryEmail__c)) {
                  mbPassList.remove(0);
                }

                FISCCDOMBPassRequest objFISCCDOMBPassRequest = new FISCCDOMBPassRequest();
                objFISCCDOMBPassRequest.mbpassLst.addAll(mbPassList);
                FISCCDepositOriginationRequestBaseDTO mbPassFISCCDepositOriginationRequestBaseDTO;
                mbPassFISCCDepositOriginationRequestBaseDTO = objFISCCDOMBPassRequest;
                mbPassFISCCDepositOriginationRequestBaseDTO.SvcID = FISCCIntegrationConstants.SVCID_MBPASS;
                lstFISCCDepositOriginationRequestBaseDTO.add(mbPassFISCCDepositOriginationRequestBaseDTO);

                //Email DTO
                if (
                  String.isNotBlank(FISCCIntegrationLogService.partyObjMap.get(partyPartyObj.tffa__RelatedParty__c).tffa__PrimaryEmail__c)
                ) {
                  objFISCCDepositOriginationRequestBaseDTO = (FISCCDepositOriginationRequestBaseDTO) createCustomerEmailRequest(
                    new List<tffa__Party__c>{ FISCCIntegrationLogService.partyObjMap.get(partyPartyObj.tffa__RelatedParty__c) },
                    adapterConfig,
                    charterConfig
                  );
                  lstFISCCDepositOriginationRequestBaseDTO.add(objFISCCDepositOriginationRequestBaseDTO);
                }
                //DueDiligence DTO
                objFISCCDepositOriginationRequestBaseDTO = (FISCCDepositOriginationRequestBaseDTO) createDueDiligenceRequest(
                  FISCCIntegrationLogService.partyObjMap.get(partyPartyObj.tffa__RelatedParty__c),
                  adapterConfig,
                  charterConfig
                );
                lstFISCCDepositOriginationRequestBaseDTO.add(objFISCCDepositOriginationRequestBaseDTO);

                partyCounter++;
              }
            } else {
              break;
            }
          }
        }
      } else {
        break;
      }
    }

    return lstFISCCDepositOriginationRequestBaseDTO;
  }

  public static List<FISCCDepositOriginationRequestBaseDTO> createDepositOriginationRequest(
    List<tffa__Party__c> partyObjs,
    tffa__Application__c tfApp,
    tffa__Submission__c subObj,
    FISCC_Charter_Config__mdt charterConfig,
    FISCC_Adapter_Configs__mdt adapterConfig
  ) {
    List<FISCCDepositOriginationRequestBaseDTO> lstFISCCDepositOriginationRequestBaseDTO = new List<FISCCDepositOriginationRequestBaseDTO>();

    Integer totalParties = partyObjs.size();
    tffa.logger.debug('totalParties ==>' + totalParties);
    tffa.logger.debug('appObj in FISCCDepositOriginationExtension ==> ' + tfApp);

    Integer jointApplicantCounter = 1;

    FISCCDepositOriginationRequest objFISCCDepositOriginationRequest = new FISCCDepositOriginationRequest();
    tffa__Party__c primaryParty = CZWTFCCommonHelper.getAppPrimaryParty(tfApp, partyObjs);
    FISCCIntegrationLogService.primaryPartyObj = primaryParty;
    FISCCDepositOriginationRequestBaseDTO objFISCCDepositOriginationRequestBaseDTO;
    Integer partyCounter = 0;
    for (tffa__ApplicationPartyXref__c appParty : tfApp.tffa__PartyXrefs__r) {
      //Fetch Party
      tffa__Party__c partyObj = FISCCIntegrationLogService.partyObjMap.containsKey(appParty.tffa__party__c)
        ? FISCCIntegrationLogService.partyObjMap.get(appParty.tffa__party__c)
        : null;
      if (
        custCreationMap.size() < FISCCIntegrationConstants.DO_APPLICANT_LIMIT &&
        !FISCCIntegrationConstants.DEPUTY.equalsIgnoreCase(appParty.tffa__ApplicantRole__r.tffa__Code__c)
      ) {
        //check Primary
        Boolean isPrimary = primaryParty.Id.equals(partyObj.Id);
        if (String.isBlank(partyObj.Customer_Number__c) && partyObj.tffa__Type__c == FISCCIntegrationConstants.INDIVIDUAL) {
          custCreationMap.put(partyCounter, partyObj.Id);

          objFISCCDepositOriginationRequestBaseDTO = (FISCCDepositOriginationRequestBaseDTO) createCustomerRequest(
            partyObj,
            subObj,
            adapterConfig,
            charterConfig
          );

          lstFISCCDepositOriginationRequestBaseDTO.add(objFISCCDepositOriginationRequestBaseDTO);
          List<FISCCMBPassDTO> mbPassList = new List<FISCCMBPassDTO>();
          mbPassList = createMBPassForApplicantDDAndEmail();
          //lstFISCCDepositOriginationRequestBaseDTO.add(objFISCCDepositOriginationRequestBaseDTO);
          if (String.isBlank(partyObj.tffa__PrimaryEmail__c)) {
            mbPassList.remove(0);
          }

          if (isPrimary) {
            mbPassList.addAll(createMBPassForApplicant(FISCCIntegrationConstants.Deposit_Originate_Primary_Customer));
          } else {
            if (jointApplicantCounter == 1) {
              mbPassList.addAll(createMBPassForApplicant(FISCCIntegrationConstants.Deposit_Originate_FirstJoint_Customer));
            } else if (jointApplicantCounter == 2) {
              mbPassList.addAll(createMBPassForApplicant(FISCCIntegrationConstants.Deposit_Originate_SecondJoint_Customer));
            } else if (jointApplicantCounter == 3) {
              mbPassList.addAll(createMBPassForApplicant(FISCCIntegrationConstants.Deposit_Originate_ThirdJoint_Customer));
            } else if (jointApplicantCounter == 4) {
              mbPassList.addAll(createMBPassForApplicant(FISCCIntegrationConstants.Deposit_Originate_FourthJoint_Customer));
            } else if (jointApplicantCounter == 5) {
              mbPassList.addAll(createMBPassForApplicant(FISCCIntegrationConstants.Deposit_Originate_FifthJoint_Customer));
            }
          }

          /**
           * MB Pass OBJ Creation for Email, DD and Customer-Acc Reln.
           */
          FISCCDOMBPassRequest objFISCCDOMBPassRequest = new FISCCDOMBPassRequest();
          objFISCCDOMBPassRequest.mbpassLst.addAll(mbPassList);
          FISCCDepositOriginationRequestBaseDTO mbPassFISCCDepositOriginationRequestBaseDTO;
          mbPassFISCCDepositOriginationRequestBaseDTO = objFISCCDOMBPassRequest;
          mbPassFISCCDepositOriginationRequestBaseDTO.SvcID = FISCCIntegrationConstants.SVCID_MBPASS;
          lstFISCCDepositOriginationRequestBaseDTO.add(mbPassFISCCDepositOriginationRequestBaseDTO);

          if (String.isNotBlank(partyObj.tffa__PrimaryEmail__c)) {
            //Email DTO
            objFISCCDepositOriginationRequestBaseDTO = (FISCCDepositOriginationRequestBaseDTO) createCustomerEmailRequest(
              new List<tffa__Party__c>{ partyObj },
              adapterConfig,
              charterConfig
            );
            lstFISCCDepositOriginationRequestBaseDTO.add(objFISCCDepositOriginationRequestBaseDTO);
          }

          //DueDiligence DTO
          objFISCCDepositOriginationRequestBaseDTO = (FISCCDepositOriginationRequestBaseDTO) createDueDiligenceRequest(
            partyObj,
            adapterConfig,
            charterConfig
          );
          lstFISCCDepositOriginationRequestBaseDTO.add(objFISCCDepositOriginationRequestBaseDTO);
          partyCounter++;
        }
        if (!isPrimary) {
          jointApplicantCounter++;
        }
      } else {
        break;
      }
    }

    //Add Beneficiary in Req
    if (
      tfApp != null &&
      tfApp.tffa__Beneficiaries__r != null &&
      !tfApp.tffa__Beneficiaries__r.isEmpty() &&
      custCreationMap.size() < FISCCIntegrationConstants.DO_APPLICANT_LIMIT &&
      !FISCCIntegrationConstants.IRA_PRODUCT_CATEGORY.equalsIgnoreCase(tfApp.tffa__Product__r.tffa__Category__c) &&
      !FISCCIntegrationConstants.HSA_PRODUCT_CATEGORY.equalsIgnoreCase(tfApp.tffa__Product__r.tffa__Category__c)
    ) {
      for (tffa__Beneficiary__c benefObj : tfApp.tffa__Beneficiaries__r) {
        if (custCreationMap.size() < FISCCIntegrationConstants.DO_APPLICANT_LIMIT) {
          if (
            benefObj.CZParty__c != null &&
            FISCCIntegrationLogService.partyObjMap.containsKey(benefObj.CZParty__c) &&
            String.isNotBlank(FISCCIntegrationLogService.partyObjMap.get(benefObj.CZParty__c).Customer_Number__c)
          ) {
            benefObj.Customer_Number__c = FISCCIntegrationLogService.partyObjMap.get(benefObj.CZParty__c).Customer_Number__c;
          } else if (benefObj.Customer_Number__c == null) {
            //Tracking Obj
            custCreationMap.put(partyCounter, benefObj.Id);

            objFISCCDepositOriginationRequestBaseDTO = (FISCCDepositOriginationRequestBaseDTO) createBeneficiaryRequest(
              benefObj,
              subObj,
              tfApp,
              adapterConfig,
              charterConfig
            );
            lstFISCCDepositOriginationRequestBaseDTO.add(objFISCCDepositOriginationRequestBaseDTO);
            partyCounter++;
          }
        } else {
          break;
        }
      }
    }

    List<tffa__Application__c> lstApp = new List<tffa__Application__c>();
    lstApp.add(tfApp);

    // DO Request generation for SDB
    if (FISCCIntegrationConstants.SAFE_DEPOSIT_PROD_CATEGORY.contains(tfApp.tffa__ProductCategory__c)) {
      // add "box-owner-new" in "Deposit-OriginationLst"
      objFISCCDepositOriginationRequestBaseDTO = FISCCDOAddSDBOwnerExtension.invokeDepositeBoxOwner(
        primaryParty,
        tfApp,
        adapterConfig,
        charterConfig
      );
      lstFISCCDepositOriginationRequestBaseDTO.add(objFISCCDepositOriginationRequestBaseDTO);

      // add "box-deputies" in "Deposit-OriginationLst"
      /*List<FISCCDepositOriginationRequestBaseDTO> requestList = FISCCDOAddSDBDeputyExtension.invokeDepositeBoxDeputy(
        tfApp,
        adapterConfig,
        charterConfig
      );
      lstFISCCDepositOriginationRequestBaseDTO.addAll(requestList);*/
    } else {
      // add "deposit-account" in "Deposit-OriginationLst"
      objFISCCDepositOriginationRequestBaseDTO = (FISCCDepositOriginationRequestBaseDTO) createNewDepositAccountRequest(
        partyObjs,
        lstApp,
        adapterConfig,
        charterConfig
      );
      lstFISCCDepositOriginationRequestBaseDTO.add(objFISCCDepositOriginationRequestBaseDTO);

      // add "deposit-addresses" in "Deposit-OriginationLst"
      objFISCCDepositOriginationRequestBaseDTO = (FISCCDepositOriginationRequestBaseDTO) createDepositNameAddressRequest(
        partyObjs,
        lstApp,
        adapterConfig,
        charterConfig
      );
      lstFISCCDepositOriginationRequestBaseDTO.add(objFISCCDepositOriginationRequestBaseDTO);
    }

    // add "customer-accounts" in "Deposit-OriginationLst"
    objFISCCDepositOriginationRequestBaseDTO = (FISCCDepositOriginationRequestBaseDTO) createCustomerAccountRelationRequest(
      partyObjs,
      lstApp,
      adapterConfig,
      charterConfig
    );
    lstFISCCDepositOriginationRequestBaseDTO.add(objFISCCDepositOriginationRequestBaseDTO);

    return lstFISCCDepositOriginationRequestBaseDTO;
  }

  //call customerExtension to populate DTO
  public static FISCCDepositOriginationRequestBaseDTO createCustomerRequest(
    tffa__Party__c partyObj,
    tffa__Submission__c subObj,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    FISCCDOCustomerIndividualRequest objFISCCCustomerIndividualRequest = new FISCCDOCustomerIndividualRequest();

    objFISCCCustomerIndividualRequest.customer = FISCCCreateCustomerIndividualHelper.createCustomerRequest(
      partyObj,
      subObj,
      adapterConfig,
      charterConfig
    );

    objFISCCCustomerIndividualRequest.SvcID = FISCCIntegrationConstants.SVCID_CreateCustomer;

    tffa.logger.debug('objFISCCCustomerIndividualRequest FISCCDOCreateCustomerExtension ==> ' + objFISCCCustomerIndividualRequest);

    return objFISCCCustomerIndividualRequest;
  }

  //call customerExtension to populate DTO
  public static FISCCDepositOriginationRequestBaseDTO createOrganizationRequest(
    tffa__Party__c partyObj,
    tffa__Submission__c subObj,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    FISCCDOCustomerOrganizationRequest objFISCCCustomerOrgRequest = new FISCCDOCustomerOrganizationRequest();

    objFISCCCustomerOrgRequest.customerOrg = FISCCCreateCustOrganizationHelper.createCustomerRequest(
      partyObj,
      subObj,
      adapterConfig,
      charterConfig
    );

    objFISCCCustomerOrgRequest.SvcID = FISCCIntegrationConstants.SVCID_CreateOrg;

    tffa.logger.debug('FISCCDOCustomerOrganizationRequest FISCCDOCreateCustomerExtension ==> ' + objFISCCCustomerOrgRequest);

    return objFISCCCustomerOrgRequest;
  }

  //create MBPASS for Applicant
  public static List<FISCCMBPassDTO> createMBPassForApplicant(String mbPassDeveloperName) {
    MBPass__mdt mbPass;
    FISCCDOMBPassRequest objFISCCDOMBPassRequest = new FISCCDOMBPassRequest();
    FISCCMBPassDTO objFISCCMBPassDTO_Applicant = new FISCCMBPassDTO();

    FISCCDepositOriginationRequestBaseDTO objFISCCDepositOriginationRequestBaseDTO;

    mbPass = MBPass__mdt.getInstance(mbPassDeveloperName);
    objFISCCMBPassDTO_Applicant.SrcDataTag = mbPass.srcDataTag__c;
    objFISCCMBPassDTO_Applicant.DestServId = mbPass.destServId__c;
    objFISCCMBPassDTO_Applicant.DestDataTag = mbPass.destDataTag__c;
    objFISCCMBPassDTO_Applicant.TrimTyp = mbPass.trimTyp__c;
    objFISCCMBPassDTO_Applicant.TrimSkip = Integer.valueOf(mbPass.trimSkip__c);
    objFISCCDOMBPassRequest.mbpassLst.add(objFISCCMBPassDTO_Applicant);
    // objFISCCDepositOriginationRequestBaseDTO = objFISCCDOMBPassRequest;
    //objFISCCDepositOriginationRequestBaseDTO.SvcID = FISCCIntegrationConstants.SVCID_MBPASS;

    return objFISCCDOMBPassRequest.mbpassLst;
  }

  //create MBPASS for Applicant
  public static List<FISCCMBPassDTO> createMBPassForApplicantDDAndEmail() {
    MBPass__mdt emailmbPass;
    MBPass__mdt dueDiligencembPass;

    FISCCDOMBPassRequest objFISCCDOMBPassRequest = new FISCCDOMBPassRequest();
    FISCCMBPassDTO objFISCCMBPassDTO_Applicant = new FISCCMBPassDTO();

    FISCCDepositOriginationRequestBaseDTO objFISCCDepositOriginationRequestBaseDTO;
    // create MBPASS for email
    emailmbPass = MBPass__mdt.getInstance(FISCCIntegrationConstants.Deposit_Originate_Email);
    FISCCMBPassDTO objFISCCMBPassDTO = new FISCCMBPassDTO();
    objFISCCMBPassDTO.SrcDataTag = emailmbPass.srcDataTag__c;
    objFISCCMBPassDTO.DestServId = emailmbPass.destServId__c;
    objFISCCMBPassDTO.DestDataTag = emailmbPass.destDataTag__c;
    objFISCCMBPassDTO.TrimTyp = emailmbPass.trimTyp__c;
    objFISCCMBPassDTO.TrimSkip = Integer.valueOf(emailmbPass.trimSkip__c);
    objFISCCDOMBPassRequest.mbpassLst.add(objFISCCMBPassDTO);

    // create MBPASS for Due-Diligence

    FISCCMBPassDTO objFISCCDDMBPassDTO = new FISCCMBPassDTO();
    dueDiligencembPass = MBPass__mdt.getInstance('DepositOriginateDueDiligence');
    objFISCCDDMBPassDTO.SrcDataTag = dueDiligencembPass.srcDataTag__c;
    objFISCCDDMBPassDTO.DestServId = dueDiligencembPass.destServId__c;
    objFISCCDDMBPassDTO.DestDataTag = dueDiligencembPass.destDataTag__c;
    objFISCCDDMBPassDTO.TrimTyp = dueDiligencembPass.trimTyp__c;
    objFISCCDDMBPassDTO.TrimSkip = Integer.valueOf(dueDiligencembPass.trimSkip__c);
    objFISCCDOMBPassRequest.mbpassLst.add(objFISCCDDMBPassDTO);
    // objFISCCDepositOriginationRequestBaseDTO = objFISCCDOMBPassRequest;
    // objFISCCDepositOriginationRequestBaseDTO.SvcID = FISCCIntegrationConstants.SVCID_MBPASS;
    return objFISCCDOMBPassRequest.mbpassLst;
  }

  // Email Address Request - CI044
  public static FISCCDepositOriginationRequestBaseDTO createCustomerEmailRequest(
    List<tffa__Party__c> partyObjs,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    tffa.logger.debug(' inside  FISCCDepositOriginationRequestBaseDTO createCustomerEmailRequest');
    FISCCDepositOriginationRequestBaseDTO objFISCCDepositOriginationRequestBaseDTO = null;
    objFISCCDepositOriginationRequestBaseDTO = FISCCDOCustomerEmailExtension.customerEmailRequest(partyObjs, adapterConfig, charterConfig);
    objFISCCDepositOriginationRequestBaseDTO.SvcID = FISCCIntegrationConstants.SVCID_CustomerEmail;

    tffa.logger.debug(
      'objFISCCDepositOriginationRequestBaseDTO FISCCDOCreateCustomerExtension ==> ' + objFISCCDepositOriginationRequestBaseDTO
    );

    return objFISCCDepositOriginationRequestBaseDTO;
  }

  // Due Diligence Request - CI214
  public static FISCCDepositOriginationRequestBaseDTO createDueDiligenceRequest(
    tffa__Party__c partyObj,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    tffa.logger.debug(' inside  FISCCDepositOriginationRequestBaseDTO createDueDiligenceRequest');
    FISCCDepositOriginationRequestBaseDTO objFISCCDepositOriginationRequestBaseDTO = null;
    objFISCCDepositOriginationRequestBaseDTO = FISCCCustomerDDExtension.generateCustomerDDRequest(partyObj, adapterConfig, charterConfig);
    objFISCCDepositOriginationRequestBaseDTO.SvcID = FISCCIntegrationConstants.SVCID_DueDiligence;

    tffa.logger.debug(
      'objFISCCDepositOriginationRequestBaseDTO FISCCDOCreateCustomerExtension ==> ' + objFISCCDepositOriginationRequestBaseDTO
    );

    return objFISCCDepositOriginationRequestBaseDTO;
  }

  //CI007
  public static FISCCDepositOriginationRequestBaseDTO createBeneficiaryRequest(
    tffa__Beneficiary__c benefObj,
    tffa__Submission__c submissionObj,
    tffa__Application__c appObj,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    tffa.logger.debug(' inside  FISCCDepositOriginationRequestBaseDTO createBeneficiaryRequest');
    FISCCDOCustomerIndividualRequest objFISCCCustomerIndividualRequest = new FISCCDOCustomerIndividualRequest();
    FISCCDepositOriginationRequestBaseDTO objFISCCDepositOriginationRequestBaseDTO = null;
    objFISCCCustomerIndividualRequest.customer = FISCCCreateBenefCustomerRequest.createBeneficiaryRequest(
      benefObj,
      submissionObj,
      appObj,
      adapterConfig,
      charterConfig
    );

    tffa.logger.debug('createBeneficiaryRequest objFISCCDepositOriginationRequestBaseDTO' + objFISCCDepositOriginationRequestBaseDTO);

    objFISCCCustomerIndividualRequest.SvcID = FISCCIntegrationConstants.SVCID_CreateCustomer;

    return objFISCCCustomerIndividualRequest;
  }

  // New DepositAccount - DLNEW Request
  public static FISCCDepositOriginationRequestBaseDTO createNewDepositAccountRequest(
    List<tffa__Party__c> partyObjs,
    List<tffa__Application__c> appObjs,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    tffa.logger.debug(' inside  FISCCDepositOriginationRequestBaseDTO createNewDepositAccountRequest');
    FISCCDOCreateNewDepositAccRequest objFISCCDOCreateNewDepositAccRequest = new FISCCDOCreateNewDepositAccRequest();
    objFISCCDOCreateNewDepositAccRequest.depositAccount = FISCCDOCreateNewDepositAccExtension.createNewDepositAccountRequest(
      partyObjs,
      appObjs,
      adapterConfig,
      charterConfig
    );
    objFISCCDOCreateNewDepositAccRequest.SvcID = FISCCIntegrationConstants.SVCID_NewDepositAccount;

    tffa.logger.debug(
      'objFISCCDepositOriginationRequestBaseDTO FISCCDOCreateCustomerExtension ==> ' + objFISCCDOCreateNewDepositAccRequest
    );

    return objFISCCDOCreateNewDepositAccRequest;
  }

  //DepositNameAndAddress - DLNAM Request
  public static FISCCDepositOriginationRequestBaseDTO createDepositNameAddressRequest(
    List<tffa__Party__c> partyObjs,
    List<tffa__Application__c> appObjs,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    tffa.logger.debug(' inside  FISCCDepositOriginationRequestBaseDTO createDepositNameAddressRequest');
    FISCCDepositOriginationRequestBaseDTO objFISCCDepositOriginationRequestBaseDTO = null;
    objFISCCDepositOriginationRequestBaseDTO = FISCCDODepositNameAddressExtension.invokeDepositNameAddress(
      partyObjs,
      appObjs,
      adapterConfig,
      charterConfig
    );
    objFISCCDepositOriginationRequestBaseDTO.SvcID = FISCCIntegrationConstants.SVCID_DepositNameAddress;
    tffa.logger.debug(
      '  createDepositNameAddressRequest objFISCCDepositOriginationRequestBaseDTO' + objFISCCDepositOriginationRequestBaseDTO
    );

    return objFISCCDepositOriginationRequestBaseDTO;
  }

  //CustomerAccountRelation - CI009 Request
  public static FISCCDepositOriginationRequestBaseDTO createCustomerAccountRelationRequest(
    List<tffa__Party__c> partyObjs,
    List<tffa__Application__c> appObjs,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    tffa.logger.debug(' inside  FISCCDepositOriginationRequestBaseDTO createCustomerAccountRelationRequest');
    FISCCDepositOriginationRequestBaseDTO objFISCCDepositOriginationRequestBaseDTO = null;
    objFISCCDepositOriginationRequestBaseDTO = FISCCDOCustomerAccountRelationExtension.invokeCustomerAccountRelation(
      partyObjs,
      appObjs,
      adapterConfig,
      charterConfig
    );
    tffa.logger.debug(
      '  createCustomerAccountRelationRequest objFISCCDepositOriginationRequestBaseDTO' + objFISCCDepositOriginationRequestBaseDTO
    );
    /*FISCCDOCustomerDTO objFISCCDOCustomerDTO = new FISCCDOCustomerDTO();
     objFISCCDOCustomerDTO.customer = objFISCCCustomerDTO;*/
    objFISCCDepositOriginationRequestBaseDTO.SvcID = FISCCIntegrationConstants.SVCID_CustomerAccount;
    //objFISCCDepositOriginationRequestBaseDTO = objFISCCDOCustomerDTO;

    tffa.logger.debug(
      'objFISCCDepositOriginationRequestBaseDTO createDepositNameAddressRequest ==> ' + objFISCCDepositOriginationRequestBaseDTO
    );

    return objFISCCDepositOriginationRequestBaseDTO;
  }

  //update records back to Salesforce
  public static boolean isFISCCAPICallSuccess(Object response, List<tffa__Party__c> partyObjs, tffa__Application__c appObj) {
    tffa.logger.debug('FISCCCreateCustomerExtension :response inside isFISCCAPICallSuccess ==>' + response);
    Boolean result = null;

    try {
      if (response == null || !(response instanceof FISCCDepositOriginationEntityResponse)) {
        return false;
      }
      FISCCDepositOriginationEntityResponse fisccDepositOriginationEntityResponse = (FISCCDepositOriginationEntityResponse) response;
      tffa.logger.debug('FISCCDepositOriginationEntityResponse ==> ' + fisccDepositOriginationEntityResponse);
      Integer partyCounter = 0;
      Integer counterApp = 0;
      Integer overallCounter = 0;
      Integer benefCounter = 0;
      tffa.logger.debug(
        ' fisccDepositOriginationEntityResponse.Entity.DepositOriginationLst.size() ==>' +
        fisccDepositOriginationEntityResponse.Entity.DepositOriginationLst.size()
      );
      for (
        FISCCDepositOriginationResponse fisccResponseDepositOrigination : fisccDepositOriginationEntityResponse.Entity.DepositOriginationLst
      ) {
        tffa.logger.debug('fisccResponseDepositOrigination ==> ' + fisccResponseDepositOrigination);
        if (fisccResponseDepositOrigination.SvcID.equalsIgnoreCase('CI007')) {
          Id ObjId = custCreationMap.get(partyCounter);
          boolean setCustNbr = false;
          for (Integer idx = 0; idx < appObj.tffa__PartyXrefs__r.size(); idx++) {
            if (appObj.tffa__PartyXrefs__r[idx].tffa__party__c == ObjId) {
              FISCCIntegrationLogService.partyObjMap.get(ObjId).Customer_Number__c = fisccResponseDepositOrigination.customer.CICustNbr;
              if (String.isNotBlank(fisccResponseDepositOrigination.customer.CISinceDte)) {
                FISCCIntegrationLogService.partyObjMap.get(ObjId).tffa__OnboardingDate__c = date.valueOf(
                  fisccResponseDepositOrigination.customer.CISinceDte
                );
              }
              setCustNbr = true;
              break;
            }
          }
          if (!setCustNbr) {
            for (Integer idx = 0; idx < appObj.tffa__Beneficiaries__r.size(); idx++) {
              if (appObj.tffa__Beneficiaries__r[idx].Id == ObjId) {
                appObj.tffa__Beneficiaries__r[idx].Customer_Number__c = fisccResponseDepositOrigination.customer.CICustNbr;
                break;
              }
            }
          }
          partyCounter++;
        }
        if (fisccResponseDepositOrigination.SvcID.equalsIgnoreCase('CI009')) {
          for (Id relnId : relnAdded) {
            for (Integer idx = 0; idx < appObj.tffa__PartyXrefs__r.size(); idx++) {
              if (appObj.tffa__PartyXrefs__r[idx].Id == relnId) {
                appObj.tffa__PartyXrefs__r[idx].CZFisRelnshipCreated__c = true;
              }
            }
          }
        }

        if (
          fisccResponseDepositOrigination.SvcID.equalsIgnoreCase('DLNEW') || fisccResponseDepositOrigination.SvcID.equalsIgnoreCase('SBM2A')
        ) {
          if (!appObj.tffa__Status__c.equals(CZWTFCConstants.FUNDED)) {
            appObj.tffa__Status__c = CZWTFCConstants.ACCOUNT_OPENED;
            appObj.CZAccountOpeningDate__c = Date.today();
          }
        }
      }

      tffa.Logger.debug('appObj ' + FISCCIntegrationLogService.applicationObjs);
      result = true;
    } catch (Exception ex) {
      tffa.Logger.error('Exception in createCustomerAccountRelationRequest : ' + ex.getMessage() + ex.getStackTraceString());

      return false;
    }
    /*if (result) {
      for (tffa__Application__c applicationObj : FISCCIntegrationLogService.applicationObjs) {
        if (appObj.id != applicationObj.Id) {
          for (tffa__ApplicationPartyXref__c appPartyXrefObj : appObj.tffa__PartyXrefs__r) {
            for (tffa__ApplicationPartyXref__c applicationPartyXrefObj : applicationObj.tffa__PartyXrefs__r) {
              if (appPartyXrefObj.tffa__Party__c == applicationPartyXrefObj.tffa__Party__c) {
                applicationPartyXrefObj.tffa__Party__r.Customer_Number__c = appPartyXrefObj.tffa__Party__r.Customer_Number__c;
                break;
              }
            }
          }
        }
      }
    }*/
    return result;
  }

  public static List<FISCCDepositOriginationRequestBaseDTO> pendingApplicantCreationRequest(
    List<tffa__Party__c> partyObjs,
    tffa__Application__c tfApp,
    tffa__Submission__c subObj,
    FISCC_Charter_Config__mdt charterConfig,
    FISCC_Adapter_Configs__mdt adapterConfig
  ) {
    Integer applicantCreationCounter = 0;
    tffa.Logger.debug('In customerCreationRequest ' + tfApp.Id);
    List<FISCCDepositOriginationRequestBaseDTO> lstFISCCDepositOriginationRequestBaseDTO = new List<FISCCDepositOriginationRequestBaseDTO>();
    // FISCCDepositOriginationRequest objFISCCDepositOriginationRequest = new FISCCDepositOriginationRequest();
    // objFISCCDepositOriginationRequest.DepositOriginationLst = lstFISCCDepositOriginationRequestBaseDTO;
    Object result = null;
    FISCCDepositOriginationRequestBaseDTO objFISCCDepositOriginationRequestBaseDTO;
    for (tffa__ApplicationPartyXref__c appParty : tfApp.tffa__PartyXrefs__r) {
      if (
        applicantCreationCounter < FISCCIntegrationConstants.CUSTOMER_CREATION_LIMIT &&
        !FISCCIntegrationConstants.DEPUTY.equalsIgnoreCase(appParty.tffa__ApplicantRole__r.tffa__Code__c)
      ) {
        //Fetch Party
        tffa__Party__c partyObj = FISCCIntegrationLogService.partyObjMap.get(appParty.tffa__Party__c);
        if (String.isBlank(partyObj.Customer_Number__c)) {
          custCreationMap.put(applicantCreationCounter, partyObj.Id);

          objFISCCDepositOriginationRequestBaseDTO = (FISCCDepositOriginationRequestBaseDTO) createCustomerRequest(
            partyObj,
            subObj,
            adapterConfig,
            charterConfig
          );

          lstFISCCDepositOriginationRequestBaseDTO.add(objFISCCDepositOriginationRequestBaseDTO);
          List<FISCCMBPassDTO> mbPassList = new List<FISCCMBPassDTO>();
          mbPassList = createMBPassForApplicantDDAndEmail();

          if (String.isBlank(partyObj.tffa__PrimaryEmail__c)) {
            mbPassList.remove(0);
          }

          /**
           * MB Pass OBJ Creation for Email, DD.
           */
          FISCCDOMBPassRequest objFISCCDOMBPassRequest = new FISCCDOMBPassRequest();
          objFISCCDOMBPassRequest.mbpassLst.addAll(mbPassList);
          FISCCDepositOriginationRequestBaseDTO mbPassFISCCDepositOriginationRequestBaseDTO;
          mbPassFISCCDepositOriginationRequestBaseDTO = objFISCCDOMBPassRequest;
          mbPassFISCCDepositOriginationRequestBaseDTO.SvcID = FISCCIntegrationConstants.SVCID_MBPASS;
          lstFISCCDepositOriginationRequestBaseDTO.add(mbPassFISCCDepositOriginationRequestBaseDTO);

          //Email DTO
          if (String.isNotBlank(partyObj.tffa__PrimaryEmail__c)) {
            objFISCCDepositOriginationRequestBaseDTO = (FISCCDepositOriginationRequestBaseDTO) createCustomerEmailRequest(
              new List<tffa__Party__c>{ partyObj },
              adapterConfig,
              charterConfig
            );
            lstFISCCDepositOriginationRequestBaseDTO.add(objFISCCDepositOriginationRequestBaseDTO);
          }
          //DueDiligence DTO
          objFISCCDepositOriginationRequestBaseDTO = (FISCCDepositOriginationRequestBaseDTO) createDueDiligenceRequest(
            partyObj,
            adapterConfig,
            charterConfig
          );
          lstFISCCDepositOriginationRequestBaseDTO.add(objFISCCDepositOriginationRequestBaseDTO);
          applicantCreationCounter++;
        }
      } else {
        break;
      }
    }

    //Add Beneficiary in Req
    if (
      tfApp != null &&
      tfApp.tffa__Beneficiaries__r != null &&
      !tfApp.tffa__Beneficiaries__r.isEmpty() &&
      applicantCreationCounter < FISCCIntegrationConstants.CUSTOMER_CREATION_LIMIT &&
      !FISCCIntegrationConstants.IRA_PRODUCT_CATEGORY.equalsIgnoreCase(tfApp.tffa__Product__r.tffa__Category__c) &&
      !FISCCIntegrationConstants.HSA_PRODUCT_CATEGORY.equalsIgnoreCase(tfApp.tffa__Product__r.tffa__Category__c)
    ) {
      for (tffa__Beneficiary__c benefObj : tfApp.tffa__Beneficiaries__r) {
        if (applicantCreationCounter < FISCCIntegrationConstants.CUSTOMER_CREATION_LIMIT) {
          if (
            benefObj.CZParty__c != null &&
            FISCCIntegrationLogService.partyObjMap.containsKey(benefObj.CZParty__c) &&
            String.isNotBlank(FISCCIntegrationLogService.partyObjMap.get(benefObj.CZParty__c).Customer_Number__c)
          ) {
            benefObj.Customer_Number__c = FISCCIntegrationLogService.partyObjMap.get(benefObj.CZParty__c).Customer_Number__c;
          } else if (benefObj.Customer_Number__c == null) {
            //Tracking Obj
            custCreationMap.put(applicantCreationCounter, benefObj.Id);
            objFISCCDepositOriginationRequestBaseDTO = (FISCCDepositOriginationRequestBaseDTO) createBeneficiaryRequest(
              benefObj,
              subObj,
              tfApp,
              adapterConfig,
              charterConfig
            );
            lstFISCCDepositOriginationRequestBaseDTO.add(objFISCCDepositOriginationRequestBaseDTO);
            applicantCreationCounter++;
          }
        } else {
          break;
        }
      }
    }
    return lstFISCCDepositOriginationRequestBaseDTO;
  }

  public static boolean checkApplicantCreationIsSuccess(Object response, List<tffa__Party__c> partyObjs, tffa__Application__c appObj) {
    tffa.logger.debug('FISCCCreateCustomerExtension :response inside isFISCCAPICallSuccess ==>' + response);
    Boolean result = null;

    try {
      if (response == null || !(response instanceof FISCCDepositOriginationEntityResponse)) {
        return false;
      }
      FISCCDepositOriginationEntityResponse fisccDepositOriginationEntityResponse = (FISCCDepositOriginationEntityResponse) response;
      //tffa.logger.debug('FISCCDepositOriginationEntityResponse ==> ' + fisccDepositOriginationEntityResponse);
      Integer partyCounter = 0;
      Integer counterApp = 0;
      Integer overallCounter = 0;
      Integer benefCounter = 0;
      tffa.logger.debug(
        ' fisccDepositOriginationEntityResponse.Entity.DepositOriginationLst.size() ==>' +
        fisccDepositOriginationEntityResponse.Entity.DepositOriginationLst.size()
      );
      for (
        FISCCDepositOriginationResponse fisccResponseDepositOrigination : fisccDepositOriginationEntityResponse.Entity.DepositOriginationLst
      ) {
        //tffa.logger.debug('fisccResponseDepositOrigination ==> ' + fisccResponseDepositOrigination);
        if (fisccResponseDepositOrigination.SvcID.equalsIgnoreCase('CI007')) {
          Id ObjId = custCreationMap.get(partyCounter);
          boolean setCustNbr = false;
          for (Integer idx = 0; idx < appObj.tffa__PartyXrefs__r.size(); idx++) {
            if (appObj.tffa__PartyXrefs__r[idx].tffa__party__c == ObjId) {
              FISCCIntegrationLogService.partyObjMap.get(ObjId).Customer_Number__c = fisccResponseDepositOrigination.customer.CICustNbr;
              if (String.isNotBlank(fisccResponseDepositOrigination.customer.CISinceDte)) {
                FISCCIntegrationLogService.partyObjMap.get(ObjId).tffa__OnboardingDate__c = date.valueOf(
                  fisccResponseDepositOrigination.customer.CISinceDte
                );
              }
              setCustNbr = true;
              break;
            }
          }
          if (!setCustNbr) {
            for (Integer idx = 0; idx < appObj.tffa__Beneficiaries__r.size(); idx++) {
              if (appObj.tffa__Beneficiaries__r[idx].Id == ObjId) {
                appObj.tffa__Beneficiaries__r[idx].Customer_Number__c = fisccResponseDepositOrigination.customer.CICustNbr;
                break;
              }
            }
          }
          partyCounter++;
        }
      }
      tffa.Logger.debug('appObj ' + FISCCIntegrationLogService.applicationObjs);
      result = true;
    } catch (Exception ex) {
      tffa.Logger.error('Exception in checkApplicantCreationIsSuccess : ' + ex.getMessage() + ex.getStackTraceString());

      return false;
    }

    /*if (result) {
      for (tffa__Application__c applicationObj : FISCCIntegrationLogService.applicationObjs) {
        if (appObj.id != applicationObj.Id) {
          for (tffa__ApplicationPartyXref__c appPartyXrefObj : appObj.tffa__PartyXrefs__r) {
            for (tffa__ApplicationPartyXref__c applicationPartyXrefObj : applicationObj.tffa__PartyXrefs__r) {
              if (appPartyXrefObj.tffa__Party__c == applicationPartyXrefObj.tffa__Party__c) {
                applicationPartyXrefObj.tffa__Party__r.Customer_Number__c = appPartyXrefObj.tffa__Party__r.Customer_Number__c;
                break;
              }
            }
          }
        }
      }
    }*/

    return result;
  }

  public static boolean isBusAndOwnerCreationSuccess(Object response, List<tffa__Party__c> partyObjs) {
    tffa.logger.debug('isBusAndOwnerCreationSuccess :response inside isFISCCAPICallSuccess ==>' + response);
    Boolean result = false;
    Integer partyCounter = 0;
    try {
      if (response == null || !(response instanceof FISCCDepositOriginationEntityResponse)) {
        return false;
      }

      FISCCDepositOriginationEntityResponse fisccDepositOriginationEntityResponse = (FISCCDepositOriginationEntityResponse) response;

      for (
        FISCCDepositOriginationResponse fisccResponseDepositOrigination : fisccDepositOriginationEntityResponse.Entity.DepositOriginationLst
      ) {
        if (fisccResponseDepositOrigination.SvcID.equalsIgnoreCase('CI008')) {
          Id ObjId = custCreationMap.get(partyCounter);
          for (Integer idx = 0; idx < partyObjs.size(); idx++) {
            if (partyObjs[idx].Id == ObjId) {
              FISCCIntegrationLogService.partyObjMap.get(ObjId).Customer_Number__c = fisccResponseDepositOrigination.customerOrg.CICustNbr;
              FISCCIntegrationLogService.partyObjMap.get(ObjId).CZBatchUpdateStatus__c = FISCCIntegrationConstants.PARTY_UPDATE_REQUIRED;
              if (String.isNotBlank(fisccResponseDepositOrigination.customerOrg.CISinceDte)) {
                FISCCIntegrationLogService.partyObjMap.get(ObjId).tffa__OnboardingDate__c = date.valueOf(
                  fisccResponseDepositOrigination.customerOrg.CISinceDte
                );
              }
              break;
            }
          }
          partyCounter++;
        }

        if (fisccResponseDepositOrigination.SvcID.equalsIgnoreCase('CI007')) {
          Id ObjId = custCreationMap.get(partyCounter);
          for (Integer idx = 0; idx < partyObjs.size(); idx++) {
            if (partyObjs[idx].Id == ObjId) {
              FISCCIntegrationLogService.partyObjMap.get(ObjId).Customer_Number__c = fisccResponseDepositOrigination.customer.CICustNbr;
              if (String.isNotBlank(fisccResponseDepositOrigination.customer.CISinceDte)) {
                FISCCIntegrationLogService.partyObjMap.get(ObjId).tffa__OnboardingDate__c = date.valueOf(
                  fisccResponseDepositOrigination.customer.CISinceDte
                );
              }
              break;
            }
          }
          partyCounter++;
        }
      }
      result = true;
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in isBusAndOwnerCreationSuccess : ' + ex.getMessage() + ex.getStackTraceString());
      return false;
    }
    return result;
  }

  public static boolean sendCustInfo(tffa__Party__c partyObj) {
    FISCCRequestBaseDTO fisccRequestBaseDTO;
    FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig(
      FISCCIntegrationConstants.DeveloperName_Deposit_Originate
    );
    try {
      FISCCDepositOriginationRequest reqObj = new FISCCDepositOriginationRequest();
      List<FISCCDepositOriginationRequestBaseDTO> lstFISCCDepositOriginationRequestBaseDTO = generatePhnEmailUpdateReq(partyObj);
      reqObj.DepositOriginationLst.addAll(lstFISCCDepositOriginationRequestBaseDTO);
      fisccRequestBaseDTO = reqObj;
      Object result = null;
      boolean isApiSuccess = false;

      result = FISCCHostAdapter.processHostRequest(fisccRequestBaseDTO, adapterConfig, FISCCIntegrationLogService.charterConfig);
      isApiSuccess = parseCustInfoUpdateResp(result);
      return isApiSuccess;
    } catch (Exception ex) {
      tffa.Logger.error('Exception in sendCustInfo ' + ex.getMessage() + ' ' + ex.getStackTraceString());
    }
    return false;
  }

  public static boolean parseCustInfoUpdateResp(Object response) {
    if (response != null && response instanceof FISCCDepositOriginationEntityResponse) {
      return true;
    } else {
      return false;
    }
  }

  public static List<FISCCDepositOriginationRequestBaseDTO> generatePhnEmailUpdateReq(tffa__Party__c partyObj) {
    List<FISCCDepositOriginationRequestBaseDTO> reqList = new List<FISCCDepositOriginationRequestBaseDTO>();
    if (partyObj.IsEmailIdMissing__c) {
      FISCCCreateEmailAddressesDTO objFISCCCreateEmailAddressesDTO = new FISCCCreateEmailAddressesDTO();
      List<FISCCCreateEmailAddressesDTO> lstFISCCCreateEmailAddressesDTO = new List<FISCCCreateEmailAddressesDTO>();
      FISCCDOCustomerEmailRequest objFISCCDOCustomerEmailRequest = new FISCCDOCustomerEmailRequest();
      objFISCCCreateEmailAddressesDTO.ResnCde = FISCCApplicationConstants.RESEND_CODE;
      objFISCCCreateEmailAddressesDTO.EmailAddr = partyObj.tffa__PrimaryEmail__c;
      objFISCCCreateEmailAddressesDTO.AddDelInd = FISCCIntegrationConstants.AddDelInd;
      lstFISCCCreateEmailAddressesDTO.add(objFISCCCreateEmailAddressesDTO);
      objFISCCDOCustomerEmailRequest.customerEmail.emailAddressLst = lstFISCCCreateEmailAddressesDTO;
      objFISCCDOCustomerEmailRequest.customerEmail.CustNbr = partyObj.Customer_Number__c;
      objFISCCDOCustomerEmailRequest.SvcID = FISCCIntegrationConstants.SVCID_CustomerEmail;
      reqList.add(objFISCCDOCustomerEmailRequest);
    }

    if (partyObj.IsPhoneNumberMissing__c) {
      FISCCCreatePhoneNumberDTO objprimaryPhneDTO = new FISCCCreatePhoneNumberDTO();
      FISCCCreatePhoneNumberDTO objWrkPhneDTO = new FISCCCreatePhoneNumberDTO();
      FISCCCreatePhoneNumberDTO objCellPhneDTO = new FISCCCreatePhoneNumberDTO();
      List<FISCCCreatePhoneNumberDTO> lstFISCCCreatePhoneNumberDTO = new List<FISCCCreatePhoneNumberDTO>();
      FISCCDOPhoneNumberRequest objFISCCDOPhoneNumberRequest = new FISCCDOPhoneNumberRequest();

      if (partyObj.tffa__PrimaryPhone__c != null) {
        String homePhne = (partyObj.tffa__PrimaryPhone__c).Substring(partyObj.tffa__PrimaryPhone__c.length() - 10);

        String areaCde = homePhne.substring(0, 3);
        String localNbr = homePhne.substring(3, 10);

        objprimaryPhneDTO.ResnCde = 'HME';
        objprimaryPhneDTO.AddDelInd = 'A';
        objprimaryPhneDTO.AreaCde = areaCde;
        objprimaryPhneDTO.LocalNbr = localNbr;
        lstFISCCCreatePhoneNumberDTO.add(objprimaryPhneDTO);
      }

      if (partyObj.tffa__SecondaryPhone__c != null) {
        String wrkPhne = (partyObj.tffa__SecondaryPhone__c).Substring(partyObj.tffa__SecondaryPhone__c.length() - 10);

        String areaCde = wrkPhne.substring(0, 3);
        String localNbr = wrkPhne.substring(3, 10);

        objWrkPhneDTO.ResnCde = 'WRK';
        objWrkPhneDTO.AddDelInd = 'A';
        objWrkPhneDTO.AreaCde = areaCde;
        objWrkPhneDTO.LocalNbr = localNbr;
        lstFISCCCreatePhoneNumberDTO.add(objWrkPhneDTO);
      }

      if (partyObj.CellPhoneNumber__c != null) {
        String cellPhne = (partyObj.CellPhoneNumber__c).Substring(partyObj.CellPhoneNumber__c.length() - 10);

        String areaCde = cellPhne.substring(0, 3);
        String localNbr = cellPhne.substring(3, 10);

        objCellPhneDTO.ResnCde = 'MBL';
        objCellPhneDTO.AddDelInd = 'A';
        objCellPhneDTO.AreaCde = areaCde;
        objCellPhneDTO.LocalNbr = localNbr;
        lstFISCCCreatePhoneNumberDTO.add(objCellPhneDTO);
      }

      objFISCCDOPhoneNumberRequest.custPhoneNumber.CustNbr = partyObj.Customer_Number__c;
      objFISCCDOPhoneNumberRequest.SvcID = 'CI051';
      objFISCCDOPhoneNumberRequest.custPhoneNumber.phoneNumLst = lstFISCCCreatePhoneNumberDTO;
      reqList.add(objFISCCDOPhoneNumberRequest);
    }
    return reqList;
  }
}