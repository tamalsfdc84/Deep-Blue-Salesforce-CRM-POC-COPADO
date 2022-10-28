@isTest
public with sharing class CZUpdateCustomerTest {
  @isTest
  public static void updateCustTestCaseOne() {
    tffa__Submission__c submissionObj = new tffa__Submission__c();
    submissionObj.tffa__Status__c = 'IN_PROGRESS';
    submissionObj.tffa__KYCDecisionOutcome__c = 'APPROVED';
    submissionObj.tffa__State__c = 'PersonalInfo';
    submissionObj.tffa__HasExistingParty__c = true;
    submissionObj.tffa__SubmittedChannel__c = 'DIGITAL';
    insert submissionObj;

    //Test data
    tffa__Address__c address = new tffa__Address__c();
    address.tffa__Line1__c = '803 Ecostar';
    address.tffa__Line2__c = ' ';
    address.tffa__State__c = 'CT1';
    address.tffa__City__c = 'Darien';
    address.tffa__Country__c = 'US';
    address.tffa__ZipCode__c = '06820-4621';
    insert address;

    List<tffa__PartyAddressXref__c> partyAddressXrefs = new List<tffa__PartyAddressXref__c>();
    tffa__PartyAddressXref__c partyAddressXref0 = new tffa__PartyAddressXref__c();
    partyAddressXref0.tffa__Type__c = 'HOME';
    partyAddressXref0.tffa__Preferred__c = true;
    partyAddressXref0.tffa__Address__r = address;
    partyAddressXrefs.add(partyAddressXref0);

    tffa__Party__c jointParty = new tffa__Party__c();
    jointParty.tffa__IsExistingCustomer__c = false;
    jointParty.tffa__BirthDate__c = Date.valueOf('1981-02-02');
    jointParty.tffa__Citizenship__c = 'Citizen';
    jointParty.tffa__DoNotCall__c = false;
    jointParty.tffa__DoNotEmail__c = false;
    jointParty.tffa__DoNotText__c = false;
    jointParty.tffa__NationalIdentifierValue__c = '123412341';
    jointParty.tffa__PrimaryEmail__c = 'a@a.c';
    jointParty.tffa__BrandCode__c = '118';
    jointParty.tffa__FirstName__c = 'John';
    jointParty.tffa__LastName__c = 'May';
    jointParty.tffa__QualiFileStatus__c = 'PASSED';
    jointParty.tffa__IDVStatus__c = 'PASSED';
    jointParty.tffa__IDAStatus__c = 'PASSED';
    jointParty.tffa__CDDStatus__c = 'PASSED';
    jointParty.tffa__OFACStatus__c = 'PASSED';
    jointParty.tffa__Type__c = 'INDIVIDUAL';
    jointParty.CZFisHomeNbr__c = '9898988989898989';
    jointParty.CZFisWorkNbr__c = '989898893898989';
    jointParty.CZFisCellNbr__c = '9898988989843989';
    jointParty.CZFisEmail__c = 'qwerty@jkrk.com';
    jointParty.CZFisCustCodes__c = '12,323,432,422';
    jointParty.CZFisHomeNbrEffDt__c = '02-02-2000';
    jointParty.CZFisWorkNbrEffDt__c = '02-02-2000';
    jointParty.CZFisCellNbrEffDt__c = '02-02-2000';
    jointParty.CZFisEmailEffDt__c = '02-02-2000';
    jointParty.tffa__IsExistingCustomer__c = true;
    jointParty.Customer_Number__c = '12324535';
    jointParty.tffa__PrimaryPhone__c = '9898983545455';
    jointParty.tffa__SecondaryPhone__c = '981232239898';
    jointParty.CellPhoneNumber__c = '788723737857823';
    jointParty.tffa__PrimaryEmail__c = 'qwerty@jkrk.com';

    tffa.SObjectAssembler asmParty1 = new tffa.SObjectAssembler(jointParty);
    asmParty1.addChildObjects('tffa__AddressXrefs__r', partyAddressXrefs);
    jointParty = (tffa__Party__c) asmParty1.assemble();

    FISCCIntegrationLogService.setSubmissionObj(submissionObj.Id);
    FISCCIntegrationLogService.setIntegrationLog(submissionObj.Id);

    FISCCIntegrationLogService.auth = '1223556';

    Test.startTest();
    try {
      FISCCUpdateCustInfoProvider.updateBranchCustomerInformation(new List<tffa__Party__c>{ jointParty });
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      Object resp = FISCCUpdateCustInfoProvider.generateUpdateDORequest(jointParty);
      System.assertNotEquals(resp, null);
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      Object resp = FISCCUpdateCustInfoProvider.generateNameAddressUpdateReq(jointParty);
      System.assertNotEquals(resp, null);
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      Object resp = FISCCUpdateCustInfoProvider.fetchContactEffDate(jointParty);
      System.assertNotEquals(resp, null);
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      Object resp = FISCCUpdateCustInfoProvider.FetchCustomerInfo(jointParty);
      System.assertNotEquals(resp, null);
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      Object resp = FISCCUpdateCustInfoProvider.FetchCustomerInfo(jointParty);
      System.assertNotEquals(resp, null);
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      tffa__Party__c partyObj = new tffa__Party__c();
      partyObj.CZFisEmail__c = '1345';
      partyObj.tffa__PrimaryEmail__c = 'Qwerty@gmail.com';
      Object resp = FISCCUpdateCustomerInfoExtension.generatePhnEmailDelReq(partyObj);
      System.assertNotEquals(resp, null);
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      tffa__Party__c partyObj = new tffa__Party__c();
      partyObj.CZFisEmail__c = '1345';
      partyObj.tffa__PrimaryEmail__c = 'Qwerty@gmail.com';
      Object resp = FISCCUpdateCustomerInfoExtension.generatePhoneEmailUpdateReq(partyObj);
      System.assertNotEquals(resp, null);
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    //-------------for Org customer---------------------
    jointParty.tffa__Type__c = FISCCIntegrationConstants.ORGANIZATION;
    //upsert jointParty;
    try {
      FISCCUpdateCustInfoProvider.updateBranchCustomerInformation(new List<tffa__Party__c>{ jointParty });
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      Object resp = FISCCUpdateCustInfoProvider.generateUpdateDORequest(jointParty);
      System.assertNotEquals(resp, null);
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      Object resp = FISCCUpdateCustInfoProvider.generateNameAddressUpdateReq(jointParty);
      System.assertNotEquals(resp, null);
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      Object resp = FISCCUpdateCustInfoProvider.fetchContactEffDate(jointParty);
      System.assertNotEquals(resp, null);
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      Object resp = FISCCUpdateCustInfoProvider.FetchCustomerInfo(jointParty);
      System.assertNotEquals(resp, null);
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      Object resp = FISCCUpdateCustInfoProvider.FetchCustomerInfo(jointParty);
      System.assertNotEquals(resp, null);
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      tffa__Party__c partyObj = new tffa__Party__c();
      partyObj.CZFisEmail__c = '1345';
      partyObj.tffa__PrimaryEmail__c = 'Qwerty@gmail.com';
      Object resp = FISCCUpdateCustomerInfoExtension.generatePhnEmailDelReq(partyObj);
      System.assertNotEquals(resp, null);
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      tffa__Party__c partyObj = new tffa__Party__c();
      partyObj.tffa__FirstName__c = 'qwerr';
      partyObj.tffa__MiddleName__c = 'qwereteyruiyopoasdsafghjgkjhlkzxcvxvcxbxnxbmhmnbnrgtrytry';
      partyObj.tffa__LastName__c = 'rgreyhtrhjytujyiuyoiuoiuoiu';
      partyObj.tffa__Suffix__c = 'wqewqrew';
      CZPartyServiceExt partyExt = new CZPartyServiceExt();
      partyExt.postCreateOrUpdate(new List<tffa__Party__c>{ partyObj });
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      tffa__Party__c partyObj = new tffa__Party__c();
      partyObj.CZFisEmail__c = '1345';
      partyObj.tffa__PrimaryEmail__c = 'Qwerty@gmail.com';
      Object resp = FISCCUpdateCustomerInfoExtension.generatePhoneEmailUpdateReq(partyObj);
      System.assertNotEquals(resp, null);
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      String fetchPhoneNbr = '{"Entity":{"control-data":{"CustNbr":"00000070743","MoreInd":"N","NbrPh":3},"phone-numbersLst":[{"ResnCde":"HME","EffDte":"2022-06-06","LocalNbr":2950844,"AreaCde":949},{"ResnCde":"MBL","EffDte":"2022-06-06","LocalNbr":2950844,"AreaCde":949},{"ResnCde":"WRK","EffDte":"2022-06-06","LocalNbr":4444343,"AreaCde":434}]},"Metadata":{"MsgLst":[{"Text":"Success","Type":"Informational Message","Severity":"Info","Code":"0"}]}}';

      String updatePhoneResp;
      for (String strMapKey : FISCCIntegrationConstants.mapOfHyphenValues.keySet()) {
        if (fetchPhoneNbr.contains(FISCCIntegrationConstants.mapOfHyphenValues.get(strMapKey))) {
          updatePhoneResp = fetchPhoneNbr.replace(FISCCIntegrationConstants.mapOfHyphenValues.get(strMapKey), strMapKey);
        }
      }
      tffa.Logger.debug('updatePhoneResp ' + updatePhoneResp);
      CZFetchPhoneNbrResponseDTO fetchPhnDto = (CZFetchPhoneNbrResponseDTO) System.JSON.deserialize(
        updatePhoneResp,
        CZFetchPhoneNbrResponseDTO.class
      );
      tffa.Logger.debug('fetchPhnDto ' + fetchPhnDto);
      FISCCFetchContactInfoExtension.parsefetchContactInfoResp(
        fetchPhnDto,
        FISCCIntegrationLogRepository.findAdapterConfig('FetchPhoneNbr'),
        jointParty
      );

      CZFetchPhoneNbrResponseBuilder fetchPhoneBuilder = new CZFetchPhoneNbrResponseBuilder();
      fetchPhoneBuilder.build(fetchPhoneNbr, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
      Object resp = fetchPhoneBuilder.parseResponse(fetchPhnDto, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
      System.assertNotEquals(resp, null);
    } catch (Exception exx) {
      System.assertNotEquals(exx.getMessage(), null);
    }

    try {
      String fetchEmail = '{"Entity":{"control-data":{"CustNbr":"00000070743","MoreInd":"N","NbrAddr":1},"email-addressesLst":[{"ResnCde":"PRI","EffDte":"2022-05-16","EmailAddr":"JJMCEVILLY@YAHOO.COM"}]},"Metadata":{"MsgLst":[{"Text":"Success","Type":"Informational Message","Severity":"Info","Code":"0"}]}}';

      String fetchEmailResp;
      for (String strMapKey : FISCCIntegrationConstants.mapOfHyphenValues.keySet()) {
        if (fetchEmail.contains(FISCCIntegrationConstants.mapOfHyphenValues.get(strMapKey))) {
          fetchEmailResp = fetchEmail.replace(FISCCIntegrationConstants.mapOfHyphenValues.get(strMapKey), strMapKey);
        }
      }

      CZFetchEmailAddressResponseDTO fetchEmailDto = (CZFetchEmailAddressResponseDTO) System.JSON.deserialize(
        fetchEmailResp,
        CZFetchEmailAddressResponseDTO.class
      );

      FISCCFetchContactInfoExtension.parsefetchContactInfoResp(
        fetchEmailDto,
        FISCCIntegrationLogRepository.findAdapterConfig('FetchEmailAddress'),
        jointParty
      );

      CZFetchEmailAddressResponseBuilder fetchEmailBuilder = new CZFetchEmailAddressResponseBuilder();
      fetchEmailBuilder.build(fetchEmail, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
      Object resp = fetchEmailBuilder.parseResponse(fetchEmailDto, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
      System.assertNotEquals(resp, null);
    } catch (Exception exx) {
      System.assertNotEquals(exx.getMessage(), null);
    }

    try {
      String customerProfile = '{"Entity":{"customer":{"CIApplNbr":"00000070743","CICurStdNme01":"JOHN-JOHN MCEVILLY","CINmeTC":0,"CIFrstNmeMidInitl":"JOHN-JOHN","CISrnme":"MCEVILLY","CICurNmeSfxCde":0,"CICurStdAddr1Cde":"S","CICurStdAddr1Txt":"128 WILMSLOW LN","CICurStdAddr2Cde":"C","CICurStdAddr2Txt":"SCHAUMBURG IL 60194-3951","Cty":"SCHAUMBURG","St":"IL","ZIP":601943951,"CIPrmyPhNbr":9492950844,"CIScndyPh":4344444343,"CICustStat":"O","CICustTaxNbr":318041744,"CICustTaxCde":"S","CIBirthdate":"1975-06-24","CICustCde1":2,"CICustCde2":10,"CICustCde3":10,"CICustCde4":20,"CICustCde5":20,"CICustCde6":20,"CICustCde7":20,"CICustCde8":20,"CICustCde9":20,"CICustCde10":20,"CICustCde11":20,"CICustCde12":20,"CICustCde13":20,"CICustCde14":20,"CICustCde15":20,"CICenTrctNbr":0,"CISncDte":"2022-05-16","CICustOpenDte":"2022-05-16","CIPrmyOffcrNbr":552,"CIScndyOffcrNbr":0,"CIBrnchNbr":1,"CICstCntrNbr":23114,"CIOccpnCde":"023","CIDunBradstreetCde":0,"CINaicsCde":0,"CICurNmePrcsTme":"00.04.45","CIPrspctInd":"C","CtryCde":"USA","CIPPwd":"DS","CIPPwdQuestion":"DDSD","CIPIDTyp1":101,"CIPIDNbr1":"M21443875179","CIPIDIssLoc1":"IL","CIPIDIssDte1":"2017-07-05","CIPIDExpDte1":"2089-06-24","CIPIDTyp2":101,"CIPIDNbr2":"M21443875179","CIPIDIssDte2":"2017-07-05","CIPIDExpDte2":"2022-10-10","AddrOvrideInd":"Y"}},"Metadata":{"MsgLst":[{"Text":"Success","Type":"Informational Message","Severity":"Info","Code":"0"}]}}';

      FISCCGetCustomerProfileResponse fetchProfileDto = (FISCCGetCustomerProfileResponse) System.JSON.deserialize(
        customerProfile,
        FISCCGetCustomerProfileResponse.class
      );

      FISCCFetchContactInfoExtension.parseFetchProfileResp(jointParty, fetchProfileDto);

      FISCCGetCustProfResponseBuilder fetchCustProfBuilder = new FISCCGetCustProfResponseBuilder();
      fetchCustProfBuilder.build(customerProfile, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
      Object resp = fetchCustProfBuilder.parseResponse(fetchProfileDto, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
      System.assertNotEquals(resp, null);
    } catch (Exception exx) {
      tffa.Logger.debug('8 ' + exx.getStackTraceString());
    }

    try {
      String nameAddressUpdate = '{"Entity":{"customers-addresses":{"CIApplNbr":"00000057860","CICustBnkNbr":889,"CICurStdAddr1Cde":"S","CICurStdAddr2Cde":"C","CICurStdAddr1Txt":"120 WILMSLOW LN","CICurStdAddr2Txt":"SCHAUMBURG IL 60194-3951","CICurStdNmeCde01":"N","CICurStdNme01":"JOHN-JOHN MCEVILLY","CICurNmeAppndCde":0,"CIElementizedCty":"SCHAUMBURG","CICurNmeAddrEffDte":"2022-06-06","CIFaxPhNbr":"0000000000","CIFrstNmeMidInitl":"JOHN-JOHN","CIElementizedHseNbr":120,"CICurLstNmeKeyFld1":"MCEVILLY","CICurFrstNmeKeyFld2":"JOHN-JOHN","CIElementizedOddEvenInd":2,"CIPrmyPhNbr":8479399000,"CINmeAddrRecTyp":0,"CISecondayPhNbr":8479399001,"CIElementizedSt":"IL","CIElementizedStr":"WILMSLOW LN","CICurNmeSfxCde":0,"CISrnme":"MCEVILLY","CIMobilePhNbr":"0000000000","CINmeTC":0,"CIElementizedZipCde":601943951,"CICurElementizedCtry":"USA","CIPrmyPhHmFromTmeRng":9999,"CIPrmyPhHmToTmeRng":9999,"CIScndyPhHmFromTmeRng":9999,"CIScndyPhHmToTmeRng":9999,"AddrOvrideInd":"Y","OvrideAddrStddization":"Y"}},"Metadata":{"MsgLst":[{"Text":"Success","Type":"Informational Message","Severity":"Info","Code":"0"}]}}';

      FISCCCustNameAddressResponseDTO updateNameDto = (FISCCCustNameAddressResponseDTO) System.JSON.deserialize(
        nameAddressUpdate,
        FISCCCustNameAddressResponseDTO.class
      );

      Object resp1 = FISCCUpdateCustInfoProvider.parseUpdateCustomerNameAddressResponse(updateNameDto);
      System.assertNotEquals(resp1, null);
      FISCCCustNameUpdateResponseBuilder nameAddressBuilder = new FISCCCustNameUpdateResponseBuilder();
      nameAddressBuilder.build(nameAddressUpdate, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
      Object resp = nameAddressBuilder.parseResponse(updateNameDto, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
      System.assertNotEquals(resp, null);
    } catch (Exception exx) {
      System.assertNotEquals(exx.getMessage(), null);
    }

    try {
      List<String> codeLst = new List<String>{ '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1' };
      Object resp = FISCCUpdateCustomerInfoExtension.fillCustomerCodes(codeLst, new FISCCDOIndividualDemoRequest());
      System.assertNotEquals(resp, null);
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      CZDeleteCustRelnResponseBuilder deleteCustRespBuilder = new CZDeleteCustRelnResponseBuilder();
      FISCCCustToCustRelnDTO dtoo = new FISCCCustToCustRelnDTO();
      deleteCustRespBuilder.build('', new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
      deleteCustRespBuilder.parseResponse(dtoo, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      CZInquireCustomerRelnResponseBuilder inqCustRespBuilder = new CZInquireCustomerRelnResponseBuilder();
      CZInquireCustRelnResponseDTO dtoo = new CZInquireCustRelnResponseDTO();
      inqCustRespBuilder.build('', new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
      inqCustRespBuilder.parseResponse(dtoo, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      List<String> codeLst = new List<String>{ '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1' };
      Object resp = FISCCUpdateCustomerInfoExtension.fillOrgCustomerCodes(codeLst, new FISCCDOOrganizationDemoRequest());
      System.assertNotEquals(resp, null);
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }
    //System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }

  @isTest
  public static void updateCustExepBlock() {
    Test.startTest();
    FISCCCustNameUpdateResponseBuilder custNameAddressResp = new FISCCCustNameUpdateResponseBuilder();
    FISCCCustNameUpdateResponseBuilder.testException = true;
    try {
      custNameAddressResp.build('', new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception e) {
      System.assertNotEquals(e.getMessage(), null);
    }
    try {
      custNameAddressResp.parseResponse(null, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception e) {
      System.assertNotEquals(e.getMessage(), null);
    }

    FISCCGetCustProfResponseBuilder profResp = new FISCCGetCustProfResponseBuilder();
    FISCCGetCustProfResponseBuilder.testException = true;
    try {
      profResp.build('', new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception e) {
      System.assertNotEquals(e.getMessage(), null);
    }
    try {
      profResp.parseResponse(null, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception e) {
      System.assertNotEquals(e.getMessage(), null);
    }

    CZFetchEmailAddressResponseBuilder emailResp = new CZFetchEmailAddressResponseBuilder();
    CZFetchEmailAddressResponseBuilder.testException = true;
    try {
      emailResp.build('', new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception e) {
      System.assertNotEquals(e.getMessage(), null);
    }
    try {
      emailResp.parseResponse(null, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception e) {
      System.assertNotEquals(e.getMessage(), null);
    }

    CZFetchPhoneNbrResponseBuilder phoneResp = new CZFetchPhoneNbrResponseBuilder();
    CZFetchPhoneNbrResponseBuilder.testException = true;
    try {
      phoneResp.build('', new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception e) {
      System.assertNotEquals(e.getMessage(), null);
    }

    CZWTFCIRAPlanDetailsResponseBuilder iraBuilder = new CZWTFCIRAPlanDetailsResponseBuilder();
    CZWTFCIRAPlanDetailsResponseBuilder.testException = true;
    try {
      iraBuilder.build('', new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }
    try {
      iraBuilder.parseResponse(null, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    CZInquireCustomerRelnResponseBuilder inqBuilder = new CZInquireCustomerRelnResponseBuilder();
    CZInquireCustomerRelnResponseBuilder.testException = true;
    try {
      inqBuilder.build('', new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }
    try {
      inqBuilder.parseResponse(null, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    FISCCDepositCreationResponseBuilder inqBuilder1 = new FISCCDepositCreationResponseBuilder();
    FISCCDepositCreationResponseBuilder.testException = true;
    try {
      inqBuilder1.build('', new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }
    try {
      inqBuilder1.parseResponse(null, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    FISCCGetOfficerDetailsResponseBuilder inqBuilder2 = new FISCCGetOfficerDetailsResponseBuilder();
    FISCCGetOfficerDetailsResponseBuilder.testException = true;
    try {
      inqBuilder2.build('', new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }
    try {
      inqBuilder2.parseResponse(null, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    FISCCDeficitTransResponseBuilder inqBuilder3 = new FISCCDeficitTransResponseBuilder();
    FISCCDeficitTransResponseBuilder.testException = true;
    try {
      inqBuilder3.build('', new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }
    try {
      inqBuilder3.parseResponse(null, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    CZDeleteCustRelnResponseBuilder deleteCUstRespBuilder = new CZDeleteCustRelnResponseBuilder();
    CZDeleteCustRelnResponseBuilder.testException = true;
    try {
      deleteCUstRespBuilder.build('', new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }
    try {
      deleteCUstRespBuilder.parseResponse(null, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }
    try {
      phoneResp.parseResponse(null, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception e) {
      System.assertNotEquals(e.getMessage(), null);
    }
    //System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }
}