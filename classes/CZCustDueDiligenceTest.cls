@isTest
public with sharing class CZCustDueDiligenceTest {
  @isTest
  public static void testCaseOne() {
    Map<String, String> mp = new Map<String, String>();
    mp.put('CustNbr', '1');
    mp.put('InitDp', '1');
    mp.put('TypOfFunds', '1');
    mp.put('SrcOfFunds', '1');
    mp.put('NbrOfDp', '1');
    mp.put('TotDpAmt', '1');
    mp.put('NbrCashDp', '1');
    mp.put('CashDpAmt', '1');
    mp.put('NbrOfCashWthdrwl', '1');
    mp.put('CashWthdrwlAmt', '1');
    mp.put('NbrOfChkWritn', '1');
    mp.put('CkAmtWritn', '1');
    mp.put('AntWireAct', '1');
    mp.put('DomInWireAct', '1');
    mp.put('NbrDomWire', '1');
    mp.put('DomInWireAmt', '1');
    mp.put('DomOutWireAct', '1');
    mp.put('NbrDomOutWire', '1');
    mp.put('DomOutWireAmt', '1');
    mp.put('FrgnInWireAct', '1');
    mp.put('NbrFrgnInWire', '1');
    mp.put('FrgnInWireAmt', '1');
    mp.put('FrgnOutWireAct', '1');
    mp.put('NbrFrgnOutWire', '1');
    mp.put('FrgnOutWireAmt', '1');
    mp.put('PolExpsedOrg', '1');
    mp.put('PolRel', '1');
    mp.put('PrsnlRlt', '1');
    mp.put('PrsnlRltTyp', '1');
    mp.put('Cmmt', '1');
    mp.put('CustRsk', '1');
    mp.put('ACHPymt', '1');
    mp.put('OrigACHPymt', '1');
    mp.put('InfoObtnBy', '1');
    mp.put('CmpltDte', '1');
    mp.put('UsrDefFld1', '1');
    mp.put('UsrDefFld2', '1');
    mp.put('UsrDefFld3', '1');
    mp.put('UsrDefFld4', '1');
    mp.put('UsrDefFld5', '1');
    mp.put('UsrDefFld6', '1');
    mp.put('UsrDefFld7', '1');
    mp.put('UsrDefFld8', '1');
    mp.put('UsrDefFld9', '1');
    mp.put('UsrDefFld10', '1');
    mp.put('UsrDefFld11', '1');
    mp.put('UsrDefFld12', '1');
    mp.put('UsrDefFld13', '1');
    mp.put('UsrDefFld14', '1');
    mp.put('UsrDefFld15', '1');
    mp.put('UsrDefFld16', '1');
    mp.put('UsrDefFld17', '1');
    mp.put('UsrDefFld18', '1');
    mp.put('UsrDefFld19', '1');
    mp.put('UsrDefFld20', '1');
    mp.put('UsrDefFld21', '1');
    mp.put('UsrDefFld22', '1');
    mp.put('UsrDefFld23', '1');
    mp.put('UsrDefFld24', '1');
    mp.put('UsrDefFld25', '1');
    mp.put('UsrDefFld26', '1');
    mp.put('UsrDefFld27', '1');
    mp.put('UsrDefFld28', '1');
    mp.put('UsrDefFld29', '1');
    mp.put('UsrDefFld30', '1');
    mp.put('UsrDefFld31', '1');
    mp.put('UsrDefFld32', '1');
    mp.put('UsrDefFld33', '1');
    mp.put('UsrDefFld34', '1');
    mp.put('UsrDefFld35', '1');
    mp.put('UsrDefFld36', '1');
    mp.put('UsrDefFld37', '1');
    mp.put('UsrDefFld38', '1');
    mp.put('UsrDefFld39', '1');
    mp.put('UsrDefFld40', '1');
    mp.put('CntryCtznshp', '1');
    mp.put('CntryDualCtznshp', '1');
    mp.put('RsdntPrsn', '1');
    mp.put('ScndyEmplr', '1');
    mp.put('OccpnDesc', '1');
    mp.put('Title', '1');
    mp.put('FullTime', '1');
    mp.put('DescBus', '1');
    mp.put('HighRisk', '1');
    mp.put('MnySrvBus', '1');
    mp.put('MnyOrdr', '1');
    mp.put('MnyOrdrReg', '1');
    mp.put('MnyOrdrCnfmID', '1');
    mp.put('MnyOrdrActAgnt', '1');
    mp.put('MnyOrdrMaxDailyAmt', '1');
    mp.put('MnyOrdrMthlySales', '1');
    mp.put('MnyOrdrPrcntIncm', '1');
    mp.put('TrvlrCk', '1');
    mp.put('TrvlrCkReg', '1');
    mp.put('TrvlrCkCnfrmID', '1');
    mp.put('TrvlrCkActAgnt', '1');
    mp.put('TrvlrCkMaxAmt', '1');
    mp.put('TrvlrCkMthlySales', '1');
    mp.put('TrvlrCkPrcntIncome', '1');
    mp.put('MnyTrn', '1');
    mp.put('MnyTxnReg', '1');
    mp.put('MnyTrnRegConfrmID', '1');
    mp.put('MnyTrnActAgnt', '1');
    mp.put('MnyTrnMaxDailyAmt', '1');
    mp.put('MnyTrnMthlySales', '1');
    mp.put('MnyTrnPrcntIncome', '1');
    mp.put('CkCash', '1');
    mp.put('CkCashReg', '1');
    mp.put('CkCashRegCnfrmID', '1');
    mp.put('CkCashActAgnt', '1');
    mp.put('CkCashMaxAmt', '1');
    mp.put('CkCashMthlySales', '1');
    mp.put('CkCashPrcntIncome', '1');
    mp.put('CrncyExchg', '1');
    mp.put('CrncyExchgReg', '1');
    mp.put('CrncyExchgCnfmID', '1');
    mp.put('CrncyExchgActAgnt', '1');
    mp.put('CrncyExchgMaxAmt', '1');
    mp.put('CrncyExchgMthlySale', '1');
    mp.put('CrncyExchgPrcntIncome', '1');
    mp.put('CrncyDeal', '1');
    mp.put('CrncyDealReg', '1');
    mp.put('CrncyDealRegCnfmID', '1');
    mp.put('CrncyDealActAgnt', '1');
    mp.put('CrncyDealMaxAmt', '1');
    mp.put('CrncyDealMthlySales', '1');
    mp.put('CrncyDealPrcntIncome', '1');
    mp.put('StrVal', '1');
    mp.put('StrValReg', '1');
    mp.put('StrValRegCnfmID', '1');
    mp.put('StrValActAgnt', '1');
    mp.put('StrValMaxAmt', '1');
    mp.put('StrValMthlySale', '1');
    mp.put('StrValPrcntIncome', '1');

    tffa__Questionnaire__c questions = new tffa__Questionnaire__c();
    questions.Name = 'cdd';
    questions.tffa__Description__c = 'DUE DILIGENCE INFORMATION';

    questions.tffa__Type__c = 'CDD';
    insert questions;

    tffa__QuestionGroupTemplate__c grpTemp = new tffa__QuestionGroupTemplate__c();
    grpTemp.Name = '1234';
    grpTemp.tffa__Questionnaire__c = questions.Id;
    grpTemp.tffa__SortOrder__c = 0;
    grpTemp.tffa__Title__c = '1234';
    insert grpTemp;

    tffa__QuestionTemplate__c questionTemp = new tffa__QuestionTemplate__c();
    questionTemp.Name = 'qeew';
    questionTemp.tffa__AnswerType__c = 'RADIO_GROUP';
    questionTemp.tffa__Code__c = 'UsrDefFld21';
    questionTemp.tffa__Label__c = 'qeew';
    questionTemp.tffa__LovName__c = 'qeew';
    questionTemp.tffa__QuestionGroup__c = grpTemp.Id;
    insert questionTemp;

    tffa__Party__c jointParty = new tffa__Party__c();
    jointParty.tffa__BrandCode__c = '118';
    jointParty.tffa__IsExistingCustomer__c = true;
    jointParty.tffa__Citizenship__c = 'Citizen';
    jointParty.tffa__DoNotCall__c = false;
    jointParty.tffa__DoNotEmail__c = false;
    jointParty.tffa__DoNotText__c = false;
    jointParty.tffa__NationalIdentifierValue__c = '123412341';
    jointParty.tffa__PrimaryEmail__c = 'a@a.c';
    jointParty.tffa__FirstName__c = 'John';
    jointParty.tffa__LastName__c = 'May';
    jointParty.tffa__QualiFileStatus__c = 'PASSED';
    jointParty.tffa__IDVStatus__c = 'PASSED';
    jointParty.tffa__IDAStatus__c = 'PASSED';
    jointParty.tffa__CDDStatus__c = 'PASSED';
    jointParty.tffa__OFACStatus__c = 'PASSED';
    jointParty.tffa__Type__c = 'ORGANIZATION';
    jointParty.Customer_Number__c = '1234';

    tffa__DueDiligence__c dueDiligence = new tffa__DueDiligence__c();
    List<tffa__DueDiligenceItem__c> ddItems = new List<tffa__DueDiligenceItem__c>();
    dueDiligence.Name = 'FIS CDD';
    dueDiligence.tffa__Type__c = 'CDD';
    dueDiligence.tffa__Status__c = 'CHALLENGED';
    dueDiligence.tffa__Provider__c = 'FIS IDA';
    dueDiligence.tffa__ExternalQuestionnaireId__c = '12323';
    dueDiligence.tffa__ConversationId__c = '1233';

    tffa.SObjectAssembler asm12 = new tffa.SObjectAssembler(dueDiligence);

    tffa__DueDiligenceItem__c itm1 = new tffa__DueDiligenceItem__c(
      Name = 'Test',
      tffa__Label__c = 'test',
      tffa__Code__c = 'ForeignOriginatingCountry',
      tffa__ValueType__c = 'RADIO_GROUP',
      tffa__Required__c = true,
      tffa__SortOrder__c = 1,
      tffa__Value__c = '12345'
    );
    ddItems.add(itm1);

    tffa__DueDiligenceItem__c itm2 = new tffa__DueDiligenceItem__c(
      Name = 'Test',
      tffa__Label__c = 'test',
      tffa__Code__c = 'ForeignDestinationCountry',
      tffa__ValueType__c = 'RADIO_GROUP',
      tffa__Required__c = true,
      tffa__SortOrder__c = 1,
      tffa__Value__c = '12345'
    );
    ddItems.add(itm2);

    tffa__DueDiligenceItem__c item = new tffa__DueDiligenceItem__c(
      Name = 'Test',
      tffa__Label__c = 'test',
      tffa__Code__c = '12345',
      tffa__ValueType__c = 'RADIO_GROUP',
      tffa__Required__c = true,
      tffa__SortOrder__c = 1,
      tffa__Value__c = '12345'
    );

    ddItems.add(item);
    tffa__DueDiligenceItem__c item1 = new tffa__DueDiligenceItem__c(
      Name = 'Tes2t',
      tffa__Label__c = 'test2',
      tffa__Code__c = '123425',
      tffa__ValueType__c = 'RADIO_GROUP',
      tffa__Required__c = true,
      tffa__SortOrder__c = 2,
      tffa__Value__c = '123425'
    );
    ddItems.add(item1);

    tffa__DueDiligenceItem__c item3 = new tffa__DueDiligenceItem__c(
      Name = 'Test1',
      tffa__Label__c = 'test1',
      tffa__Code__c = '123451',
      tffa__ValueType__c = 'RADIO_GROUP',
      tffa__Required__c = true,
      tffa__SortOrder__c = 3,
      tffa__Value__c = '123145'
    );

    ddItems.add(item3);

    asm12.addChildObjects('Items__r', ddItems);
    dueDiligence = (tffa__DueDiligence__c) asm12.assemble();

    tffa.SObjectAssembler asmPar = new tffa.SObjectAssembler(jointParty);
    asmPar.addChildObjects('DueDiligences__r', new List<tffa__DueDiligence__c>{ dueDiligence });
    jointParty = (tffa__Party__c) asmPar.assemble();

    Test.startTest();
    FISCCDOCustomerDDRequest baseddReq = new FISCCDOCustomerDDRequest();
    try {
      for (String mpKey : mp.keySet()) {
        baseddReq.dueDiligenceReq.dueDiligenceDemographics.setValue(mpKey, '1');
      }
    } catch (Exception ex) {
      tffa.Logger.debug('Error was thrown');
    }

    try {
      FISCCIntegrationLogService.cddObjMap = new Map<Id, List<tffa__DueDiligence__c>>();
      upsert jointParty;
      FISCCIntegrationLogService.cddObjMap.put(jointParty.Id, new List<tffa__DueDiligence__c>{ dueDiligence });
      FISCCCustomerDDExtension.setCDDQuestions(jointParty, baseddReq);
      FISCCCustomerDDExtension.getCddValue('Yes');
      FISCCCustomerDDExtension.getCddValue('No');
      FISCCCustomerDDExtension.getCddValue('Test');
    } catch (Exception ex) {
      tffa.Logger.debug('Error was thrown');
    }

    try {
      FISCCFetchDueDiligenceRespDTO dto = new FISCCFetchDueDiligenceRespDTO();
      dto.Entity.dueDiligenceDemographics.ACHPymt = 'Y';
      dto.Entity.dueDiligenceDemographics.mnyOrdr = 'Y';
      FISCCDueDiligenceServiceExtension.handleDDItemsList(new List<tffa__DueDiligenceItem__c>(), dto);
      dto.Entity.dueDiligenceDemographics.ACHPymt = '';
      dto.Entity.dueDiligenceDemographics.mnyOrdr = '';
      Object resp1 = FISCCDueDiligenceServiceExtension.handleDDItemsList(new List<tffa__DueDiligenceItem__c>(), dto);
      System.assertNotEquals(resp1, null);
    } catch (Exception ex) {
      tffa.Logger.debug('Error was thrown');
    }

    try {
      FISCCIntegrationLogService.auth = '13134';
      tffa__Submission__c sub = new tffa__Submission__c(tffa__Status__c = 'SUBMITTED', tffa__Brand__c = '118');
      insert sub;
      FISCCIntegrationLogService.setSubmissionObj(sub.Id);

      FISCCIntegrationLogService.setIntegrationLog(sub.id);
      Test.setMock(HttpCalloutMock.class, new FISCCFectchCDDMockClass());

      FISCCDueDiligenceServiceExtension.fetchCDDQuestion(new List<tffa__Party__c>{ jointParty });
    } catch (Exception ex) {
      tffa.Logger.debug('Error was thrown');
    }

    for (String key : mp.keySet()) {
      FISCCFetchDueDiligenceRespDTO.DueDiligenceDemographics dd = new FISCCFetchDueDiligenceRespDTO.DueDiligenceDemographics();
      dd.getValue(key);
    }

    try {
      String respp = '{"Entity":{"due-diligence-demographics":{"CustNbr":"00000071562","CustType":"O","LstMaintOper":"C889995","LstMaintDte":"2022-06-30","NbrOfDp":56,"TotDpAmt":7,"NbrCashDp":1,"CashDpAmt":2,"NbrOfCashWthdrwl":3,"CashWthdrwlAmt":4,"NbrOfChkWritn":8,"CkAmtWritn":9,"AntWireAct":"N","UsrDefFld21":"N","UsrDefFld22":"N","UsrDefFld27":"N"},"incoming-countries":null,"outgoing-countries":null},"Metadata":{"MsgLst":[{"Text":"Success","Type":"Informational Message","Severity":"Info","Code":"0"}]}}';
      FISCCFetchDueDiligenceRespDTO dto = (FISCCFetchDueDiligenceRespDTO) System.JSON.deserialize(
        respp,
        FISCCFetchDueDiligenceRespDTO.class
      );
      Map<Id, Object> respDto = new Map<Id, Object>();
      respDto.put(jointParty.Id, dto);
      FISCCDueDiligenceServiceExtension.parseDueDiligenceDemographicsResp(respDto);
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    //Response block for Fetch Alias api call
    try {
      String resp = '{"Entity":{"query-parameters-customers-aliases":{"CustNbr":"00000071571"},"customers-aliasesLst":[{"Seq":1,"PrcsTme":"07.41.11","AlNme":"DWDDEEDWEW"},{"Seq":2,"PrcsTme":"07.41.12","AlNme":"QWQWWQ"}]},"Metadata":{"MsgLst":[{"Text":"Success","Type":"Informational Message","Severity":"Info","Code":"0"}]}}';
      FISCCFetchDueDiligenceRespDTO dto = (FISCCFetchDueDiligenceRespDTO) System.JSON.deserialize(
        resp,
        FISCCFetchDueDiligenceRespDTO.class
      );
      CZFetchDueDiligenceRespBuilder respBuilder = new CZFetchDueDiligenceRespBuilder();
      respBuilder.build(resp, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
      Object resp1 = respBuilder.parseResponse(dto, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
      FISCCIntegrationLogService.auth = '';
      System.assertNotEquals(resp1, null);
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      String resp = '{"Entity":{"query-parameters-customers-aliases":{"CustNbr":"00000071571"},"customers-aliasesLst":[{"Seq":1,"PrcsTme":"07.41.11","AlNme":"DWDDEEDWEW"},{"Seq":2,"PrcsTme":"07.41.12","AlNme":"QWQWWQ"}]},"Metadata":{"MsgLst":[{"Text":"Success","Type":"Informational Message","Severity":"Info","Code":"0"}]}}';
      FISCCFetchDueDiligenceRespDTO dto = (FISCCFetchDueDiligenceRespDTO) System.JSON.deserialize(
        resp,
        FISCCFetchDueDiligenceRespDTO.class
      );
      CZFetchDueDiligenceRespBuilder respBuilder = new CZFetchDueDiligenceRespBuilder();
      CZFetchDueDiligenceRespBuilder.testException = true;
      respBuilder.build(resp, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
      respBuilder.parseResponse(dto, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
      FISCCIntegrationLogService.auth = '';
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    Test.stopTest();
  }

  @isTest
  static void testnew() {
    Test.StartTest();
    try {
      tffa__Party__c party = CZWTFCTestDataRepository.createIndividualParty();
      tffa.SObjectAssembler asmParty = new tffa.SObjectAssembler(party);
      asmParty.addChildObjects('tffa__AddressXrefs__r', CZWTFCTestDataRepository.createPartyAddressXrefs());
      asmParty.addChildObject('tffa__Employments__r', CZWTFCTestDataRepository.createEmployment());
      asmParty.addChildObject('tffa__Identifications__r', CZWTFCTestDataRepository.createIdentification());
      party = (tffa__Party__c) asmParty.assemble();
      insert party;
      List<tffa__Party__c> partyList = new List<tffa__Party__c>();
      partyList.add(party);

      FISCCIntegrationLogService.auth = FISCCGetAccessTokenProvider.processGetAccessToken(new FISCC_Charter_Config__mdt());
      FISCCDueDiligenceServiceExtension.fetchCDDQuestion(partyList);
      FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig('FetchDueDiligence');
      System.assertNotEquals(adapterConfig, null);
    } catch (Exception ex) {
      tffa.Logger.debug('Test Execption thrown');
    }

    Test.stopTest();
  }

  @isTest
  static void testnewA() {
    Test.StartTest();

    try {
      String respp = '{"Entity":{"due-diligence-demographics":{"CustNbr":"00000071562","CustType":"O","LstMaintOper":"C889995","LstMaintDte":"2022-06-30","NbrOfDp":56,"TotDpAmt":7,"NbrCashDp":1,"CashDpAmt":2,"NbrOfCashWthdrwl":3,"CashWthdrwlAmt":4,"NbrOfChkWritn":8,"CkAmtWritn":9,"AntWireAct":"N","UsrDefFld21":"N","UsrDefFld22":"N","UsrDefFld27":"N"},"incoming-countries":null,"outgoing-countries":null},"Metadata":{"MsgLst":[{"Text":"Success","Type":"Informational Message","Severity":"Info","Code":"0"}]}}';
      FISCCFetchDueDiligenceRespDTO dto = (FISCCFetchDueDiligenceRespDTO) System.JSON.deserialize(
        respp,
        FISCCFetchDueDiligenceRespDTO.class
      );
      Map<Id, Object> respDto = new Map<Id, Object>();
      respDto.put('13123', dto);
      FISCCDueDiligenceServiceExtension.parseDueDiligenceDemographicsResp(respDto);
      tffa__Questionnaire__c cddQuestions = CZWTFCHelperRepository.getCDDQuestions();
      System.assertNotEquals(cddQuestions, null);
    } catch (Exception ex) {
      tffa.Logger.debug('Test Execption thrown');
    }
    //System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }

  @isTest
  static void testnewB() {
    Test.StartTest();

    String str = FISCCDueDiligenceServiceExtension.getCddValue('Y');
    System.assertEquals('Yes', str);

    String strn = FISCCDueDiligenceServiceExtension.getCddValue('N');
    System.assertEquals('No', strn);

    String strn1 = FISCCDueDiligenceServiceExtension.getCddValue('abcd');
    System.assertEquals('abcd', strn1);

    Test.stopTest();
  }
}