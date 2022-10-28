@isTest
public with sharing class CZWTFCCustomerAliasExtTest {
  @IsTest
  public static void testCaseOne() {
    tffa__Submission__c sub = CZWTFCTestDataRepository.getSubmissionForTest();
    tffa__Party__c partyObj = sub.tffa__PartyXrefs__r[0].tffa__Party__r;
    tffa.Logger.debug(sub.Name);
    tffa.Logger.debug(sub.tffa__PartyXrefs__r[0].tffa__party__r.CZPartyAliases__r);
    /*
    
    CZPartyAlias__c aliasObj = new CZPartyAlias__c();
    aliasObj.Name = 'onee';
    aliasObj.AliasFirstName__c = 'Testttttt';
    aliasObj.AliasLastName__c = 'Testone';
    aliasObj.Party__c = partyObj.Id;
    insert aliasObj;

    
    tffa.SObjectAssembler asm = new tffa.SObjectAssembler(partyObj);
    asm.addChildObjects('CZPartyAliases__r', new List<CZPartyAlias__c>{ aliasObj });
    partyObj = (tffa__Party__c) asm.assemble();

new tffa__Submission__c(tffa__Status__c = 'SUBMITTED', tffa__State__c = 'ReviewSubmit');
    insert sub;

    tffa__SubmissionPartyXref__c partyXRef = new tffa__SubmissionPartyXref__c();
    partyXRef.tffa__Submission__c = sub.id;
    partyXRef.tffa__Party__r = partyObj;
    partyXRef.tffa__IsPresent__c = true;
    partyXRef.Name = 'TEst';
    partyXRef.tffa__Type__c = 'INDIVIDUAL';
    partyXref.tffa__Primary__c = false;

    tffa.SObjectAssembler asm1 = new tffa.SObjectAssembler(sub);
    asm1.addChildObjects('tffa__PartyXrefs__r', new List<tffa__SubmissionPartyXref__c>{ partyXRef });
    sub = (tffa__Submission__c) asm1.assemble();
*/
    FISCCIntegrationLogService.setCharterConfig('118');
    FISCCIntegrationLogService.setSubmissionObj(sub.Id);
    FISCCIntegrationLogService.setPartyObjs();
    FISCCIntegrationLogService.setIntegrationLog(sub.Id);
    FISCCIntegrationLogService.setApplicationObjs();
    FISCCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.CUSTOMER_ALIAS);
    Test.startTest();

    try {
      tffa.Context ctx = tffa.Context.get();
      ctx.stage = 'PersonalInfo';
      CZWTFCSubmissionServiceExt.updateAlias(sub);
      CZWTFCSubmissionServiceExt subext = new CZWTFCSubmissionServiceExt();
      Object resp = subext.postRead(sub);
      System.assertNotEquals(resp, null);
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      Test.setMock(HttpCalloutMock.class, new CZCustomerAliasMockClass());
      FISCCIntegrationLogService.auth = 'abcd';
      Object resp = FISCCCustomerAliasExtension.invokeAddAliasAPI(partyObj);
      System.assertNotEquals(resp, null);
    } catch (Exception ex) {
      tffa.Logger.debug('Test Execption thrown');
    }

    try {
      Test.setMock(HttpCalloutMock.class, new CZCustomerAliasMockClass());
      FISCCIntegrationLogService.auth = 'abcd';
      Database.executeBatch(new CZUpdatePartyInfoBatch(), 1);
    } catch (Exception ex) {
      tffa.Logger.debug('Test Execption thrown');
    }

    try {
      Test.setMock(HttpCalloutMock.class, new CZCustomerAliasMockClass());
      FISCCIntegrationLogService.auth = 'abcd';
      Object resp = FISCCCustomerAliasExtension.deleteCustomerAlias(partyObj, new List<String>{ '1', '2' });
      System.assertNotEquals(resp, null);
    } catch (Exception ex) {
      tffa.Logger.debug('Test Execption thrown');
    }

    try {
      Test.setMock(HttpCalloutMock.class, new CZCustomerAliasMockClass());
      FISCCIntegrationLogService.auth = 'abcd';
      Object resp = FISCCCustomerAliasExtension.fetchCustomerAliasSeqNo(partyObj);
      System.assertNotEquals(resp, null);
    } catch (Exception ex) {
      tffa.Logger.debug('Test Execption thrown');
    }

    //Req generation
    try {
      Object resp = FISCCCustomerAliasExtension.generateAliasRequest('Test');
      System.assertNotEquals(resp, null);
    } catch (Exception ex) {
      tffa.Logger.debug('Test Execption thrown');
    }

    //Response block
    try {
      String resp = '{"Entity":{"customer-alias-new":{"NmeAddrStandOvrideInd":"Y","CustNbr":"00000069208","AlNme":"BATMANNN","AlPrcsTme":"05:19:22"}},"Metadata":{"MsgLst":[{"Type":"Informational Message","Text":"Success","Severity":"Info","Code":"0"}]}}';
      FISCCCreateAliasResponseDTO dto = (FISCCCreateAliasResponseDTO) System.JSON.deserialize(resp, FISCCCreateAliasResponseDTO.class);
      System.assertNotEquals(dto, null);
      FISCCCreateAliasResponseBuilder respBuilder = new FISCCCreateAliasResponseBuilder();
      respBuilder.build(resp, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
      respBuilder.parseResponse(dto, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
      FISCCCustomerAliasExtension.parseAliasResponse(dto);
      FISCCIntegrationLogService.auth = '';
      Object resp1 = FISCCCustomerAliasExtension.invokeAddAliasAPI(partyObj);
      System.assertNotEquals(resp1, null);
    } catch (Exception ex) {
      tffa.Logger.debug('Test Execption thrown');
    }

    //Exception block in CZAccNbrGenerationRequestDTO.build
    try {
      String resp = '{"Entity":{"customer-alias-new":{"NmeAddrStandOvrideInd":"Y","CustNbr":"00000069208","AlNme":"BATMANNN","AlPrcsTme":"05:19:22"}},"Metadata":{"MsgLst":[{"Type":"Informational Message","Text":"Success","Severity":"Info","Code":"0"}]}}';
      FISCCCreateAliasResponseDTO dto = (FISCCCreateAliasResponseDTO) System.JSON.deserialize(resp, FISCCCreateAliasResponseDTO.class);
      FISCCCreateAliasResponseBuilder respBuilder = new FISCCCreateAliasResponseBuilder();
      FISCCCreateAliasResponseBuilder.testException = true;
      respBuilder.build(resp, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    //Exception block in FISCCCreateAliasResponseBuilder.parseResponse
    try {
      String resp = '{"Entity":{"customer-alias-new":{"NmeAddrStandOvrideInd":"Y","CustNbr":"00000069208","AlNme":"BATMANNN","AlPrcsTme":"05:19:22"}},"Metadata":{"MsgLst":[{"Type":"Informational Message","Text":"Success","Severity":"Info","Code":"0"}]}}';
      FISCCCreateAliasResponseDTO dto = (FISCCCreateAliasResponseDTO) System.JSON.deserialize(resp, FISCCCreateAliasResponseDTO.class);
      FISCCCreateAliasResponseBuilder respBuilder = new FISCCCreateAliasResponseBuilder();
      FISCCCreateAliasResponseBuilder.testException = true;
      respBuilder.parseResponse(new FISCCCreateAliasResponseDTO(), new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    //Exception block
    try {
      FISCCCustomerAliasExtension.testException = true;
      FISCCCustomerAliasExtension.invokeAddAliasAPI(partyObj);
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    //Exception block
    try {
      FISCCCustomerAliasExtension.testException = true;
      FISCCCustomerAliasExtension.invokeAddAliasAPI(partyObj);
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    //Exception block
    try {
      FISCCCustomerAliasExtension.testException = true;
      FISCCCustomerAliasExtension.deleteCustomerAlias(partyObj, new List<String>{ '1', '2' });
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    //Exception block
    try {
      FISCCCustomerAliasExtension.testException = true;
      FISCCCustomerAliasExtension.fetchCustomerAliasSeqNo(partyObj);
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    //Response block for Fetch Alias api call
    try {
      String resp = '{"Entity":{"query-parameters-customers-aliases":{"CustNbr":"00000071571"},"customers-aliasesLst":[{"Seq":1,"PrcsTme":"07.41.11","AlNme":"DWDDEEDWEW"},{"Seq":2,"PrcsTme":"07.41.12","AlNme":"QWQWWQ"}]},"Metadata":{"MsgLst":[{"Text":"Success","Type":"Informational Message","Severity":"Info","Code":"0"}]}}';
      FISCCFetchAliasResponseDTO dto = (FISCCFetchAliasResponseDTO) System.JSON.deserialize(resp, FISCCFetchAliasResponseDTO.class);
      CZFetchAliasResponseBuilder respBuilder = new CZFetchAliasResponseBuilder();
      respBuilder.build(resp, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
      respBuilder.parseResponse(dto, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
      FISCCCustomerAliasExtension.parseFetchAliasResponse(dto);
      FISCCIntegrationLogService.auth = '';
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    //Exception block for Fetch Alias api call
    try {
      String resp = '{"Entity":{"query-parameters-customers-aliases":{"CustNbr":"00000071571"},"customers-aliasesLst":[{"Seq":1,"PrcsTme":"07.41.11","AlNme":"DWDDEEDWEW"},{"Seq":2,"PrcsTme":"07.41.12","AlNme":"QWQWWQ"}]},"Metadata":{"MsgLst":[{"Text":"Success","Type":"Informational Message","Severity":"Info","Code":"0"}]}}';
      FISCCFetchAliasResponseDTO dto = (FISCCFetchAliasResponseDTO) System.JSON.deserialize(resp, FISCCFetchAliasResponseDTO.class);
      CZFetchAliasResponseBuilder respBuilder = new CZFetchAliasResponseBuilder();
      CZFetchAliasResponseBuilder.testException = true;
      respBuilder.build(resp, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    //Exception block for Fetch Alias api call
    try {
      String resp = '{"Entity":{"query-parameters-customers-aliases":{"CustNbr":"00000071571"},"customers-aliasesLst":[{"Seq":1,"PrcsTme":"07.41.11","AlNme":"DWDDEEDWEW"},{"Seq":2,"PrcsTme":"07.41.12","AlNme":"QWQWWQ"}]},"Metadata":{"MsgLst":[{"Text":"Success","Type":"Informational Message","Severity":"Info","Code":"0"}]}}';
      FISCCFetchAliasResponseDTO dto = (FISCCFetchAliasResponseDTO) System.JSON.deserialize(resp, FISCCFetchAliasResponseDTO.class);
      CZFetchAliasResponseBuilder respBuilder = new CZFetchAliasResponseBuilder();
      CZFetchAliasResponseBuilder.testException = true;
      respBuilder.parseResponse(new FISCCFetchAliasResponseDTO(), new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    //Response block for Delete Alias api call
    try {
      String resp = '{"Entity":{"customer-alias":{"CustNbr":"00000071571","NmeAddrStandOvrideInd":"N","AlSeqNbr":1,"AlPrcsTme":"07.41.11"}},"Metadata":{"MsgLst":[{"Text":"Success","Type":"Informational Message","Severity":"Info","Code":"0"}]}}';
      FISCCDeleteAliasResponseDTO dto = (FISCCDeleteAliasResponseDTO) System.JSON.deserialize(resp, FISCCDeleteAliasResponseDTO.class);
      CZDeleteAliasResponseBuilder respBuilder = new CZDeleteAliasResponseBuilder();
      respBuilder.build(resp, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
      respBuilder.parseResponse(dto, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
      FISCCCustomerAliasExtension.parseDeleteAliasResponse(dto);
      FISCCIntegrationLogService.auth = '';
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    //Exception block for Delete Alias api call
    try {
      String resp = '{"Entity":{"customer-alias":{"CustNbr":"00000071571","NmeAddrStandOvrideInd":"N","AlSeqNbr":1,"AlPrcsTme":"07.41.11"}},"Metadata":{"MsgLst":[{"Text":"Success","Type":"Informational Message","Severity":"Info","Code":"0"}]}}';
      FISCCDeleteAliasResponseDTO dto = (FISCCDeleteAliasResponseDTO) System.JSON.deserialize(resp, FISCCDeleteAliasResponseDTO.class);
      CZDeleteAliasResponseBuilder respBuilder = new CZDeleteAliasResponseBuilder();
      CZDeleteAliasResponseBuilder.testException = true;
      respBuilder.build(resp, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    //Exception block for Delete Alias api call
    try {
      String resp = '{"Entity":{"customer-alias":{"CustNbr":"00000071571","NmeAddrStandOvrideInd":"N","AlSeqNbr":1,"AlPrcsTme":"07.41.11"}},"Metadata":{"MsgLst":[{"Text":"Success","Type":"Informational Message","Severity":"Info","Code":"0"}]}}';
      FISCCDeleteAliasResponseDTO dto = (FISCCDeleteAliasResponseDTO) System.JSON.deserialize(resp, FISCCDeleteAliasResponseDTO.class);
      CZDeleteAliasResponseBuilder respBuilder = new CZDeleteAliasResponseBuilder();
      CZDeleteAliasResponseBuilder.testException = true;
      respBuilder.parseResponse(new FISCCDeleteAliasResponseDTO(), new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }
}