public inherited sharing class FISCCDepositOriginationExtension {
  public String ErrorMessage;

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
     objFISCCDOCustomerDTO.customer = objFISCCCustomerDTO;*/
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
          /* Get the index of next new customer*/
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

      tffa.Logger.debug('uuuuuuppppppdate ' + FISCCIntegrationLogService.partyObjs);
      result = true;
    } catch (Exception ex) {
      tffa.Logger.error('Exception in createCustomerAccountRelationRequest : ' + ex.getMessage() + ex.getStackTraceString());

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
      List<FISCCDepositOriginationRequestBaseDTO> lstFISCCDepositOriginationRequestBaseDTO = customerInfoUpdateReq(partyObj);
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

  public static List<FISCCDepositOriginationRequestBaseDTO> customerInfoUpdateReq(tffa__Party__c partyObj) {
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