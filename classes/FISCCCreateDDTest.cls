@isTest
public with sharing class FISCCCreateDDTest {
  @isTest
  public static void testcaseone() {
    tffa__Brand__c brandObj = new tffa__Brand__c();
    brandObj.Name = '118';
    brandObj.tffa__Code__c = '118';
    brandObj.Name = 'test';
    brandObj.EmailPhone__c = 'test';
    brandObj.EmailHeaderLogoUrl__c = 'test';
    brandObj.Address__c = 'test';
    brandObj.City__c = 'test';
    brandObj.State__c = 'test';
    brandObj.Zip__c = 'test';
    brandObj.tffa__InfoUrl__c = 'test';
    brandObj.tffa__ContactEmail__c = 'test';
    insert brandObj;
    tffa__Submission__c sub = new tffa__Submission__c(tffa__Status__c = 'SUBMITTED', tffa__Brand__c = '118');
    insert sub;
    tffa__Application__c app = new tffa__Application__c(tffa__Submission__c = sub.Id, tffa__AccountNumber__c = '8666856');
    insert app;
    tffa__FundingRequest__c fundingReq = new tffa__FundingRequest__c();
    fundingReq.Name = '';
    fundingReq.tffa__Status__c = 'IN_PROGRESS';
    fundingReq.tffa__Type__c = CZWTFCConstants.INTERNAL_TRANSFER;
    fundingReq.CZSourceAccountBrand__c = '380';
    fundingReq.tffa__Amount__c = 100;
    fundingReq.tffa__AccountNumber__c = '2095086';
    fundingReq.tffa__LinkedApplication__c = app.Id;
    insert fundingReq;

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
    insert jointParty;

    tffa__Employment__c objEmployment = new tffa__Employment__c();
    objEmployment.tffa__Party__c = jointParty.id;
    objEmployment.tffa__EmployerName__c = 'Emp Name';
    objEmployment.tffa__Type__c = 'FULLTIME';
    objEmployment.OccupationType__c = '003';
    objEmployment.tffa__Title__c = '003';
    objEmployment.Name = '003';
    insert objEmployment;

    tffa.SObjectAssembler asm = new tffa.SObjectAssembler(jointParty);
    asm.addChildObject('Employments__r', objEmployment);
    tffa__Party__c p1 = (tffa__Party__c) asm.assemble();

    tffa__Party__c jointParty1 = new tffa__Party__c();
    jointParty1.tffa__IsExistingCustomer__c = false;
    jointParty1.tffa__BirthDate__c = Date.valueOf('1981-02-02');
    jointParty1.tffa__Citizenship__c = 'Citizen';
    jointParty1.tffa__DoNotCall__c = false;
    jointParty1.tffa__DoNotEmail__c = false;
    jointParty1.tffa__DoNotText__c = false;
    jointParty1.tffa__NationalIdentifierValue__c = '123412341';
    jointParty1.tffa__PrimaryEmail__c = 'a@a.c';
    jointParty1.tffa__BrandCode__c = '118';
    jointParty1.tffa__FirstName__c = 'John';
    jointParty1.tffa__LastName__c = 'May';
    jointParty1.tffa__QualiFileStatus__c = 'PASSED';
    jointParty1.tffa__IDVStatus__c = 'PASSED';
    jointParty1.tffa__IDAStatus__c = 'PASSED';
    jointParty1.tffa__CDDStatus__c = 'PASSED';
    jointParty1.tffa__OFACStatus__c = 'PASSED';
    jointParty1.tffa__Type__c = 'INDIVIDUAL';
    insert jointParty1;

    tffa__Employment__c objEmployment1 = new tffa__Employment__c();
    objEmployment1.tffa__Party__c = jointParty1.id;
    objEmployment1.tffa__EmployerName__c = 'Emp Name';
    objEmployment1.tffa__Type__c = 'STUDENT';
    objEmployment1.OccupationType__c = '003';
    objEmployment1.tffa__Title__c = '003';
    objEmployment1.Name = '003';
    insert objEmployment1;

    tffa.SObjectAssembler asm1 = new tffa.SObjectAssembler(jointParty);
    asm1.addChildObject('Employments__r', objEmployment1);
    tffa__Party__c p2 = (tffa__Party__c) asm1.assemble();

    tffa__Party__c jointParty2 = new tffa__Party__c();
    jointParty2.tffa__IsExistingCustomer__c = false;
    jointParty2.tffa__BirthDate__c = Date.valueOf('1981-02-02');
    jointParty2.tffa__Citizenship__c = 'Citizen';
    jointParty2.tffa__DoNotCall__c = false;
    jointParty2.tffa__DoNotEmail__c = false;
    jointParty2.tffa__DoNotText__c = false;
    jointParty2.tffa__NationalIdentifierValue__c = '123412341';
    jointParty2.tffa__PrimaryEmail__c = 'a@a.c';
    jointParty2.tffa__BrandCode__c = '118';
    jointParty2.tffa__FirstName__c = 'John';
    jointParty2.tffa__LastName__c = 'May';
    jointParty2.tffa__QualiFileStatus__c = 'PASSED';
    jointParty2.tffa__IDVStatus__c = 'PASSED';
    jointParty2.tffa__IDAStatus__c = 'PASSED';
    jointParty2.tffa__CDDStatus__c = 'PASSED';
    jointParty2.tffa__OFACStatus__c = 'PASSED';
    jointParty2.tffa__Type__c = 'INDIVIDUAL';
    jointParty2.tffa__IsExistingCustomer__c = true;
    insert jointParty2;

    tffa__Party__c jointParty3 = new tffa__Party__c();
    jointParty3.IsAuthenticatedCustomer__c = true;
    jointParty3.IsEmailIdMissing__c = true;
    jointParty3.IsDobMissing__c = true;
    jointParty3.tffa__BirthDate__c = Date.valueOf('1981-02-02');
    jointParty3.tffa__Citizenship__c = 'Citizen';
    jointParty3.tffa__DoNotCall__c = false;
    jointParty3.tffa__DoNotEmail__c = false;
    jointParty3.tffa__DoNotText__c = false;
    jointParty3.tffa__NationalIdentifierValue__c = '123412341';
    jointParty3.tffa__PrimaryEmail__c = 'a@a.c';
    jointParty3.tffa__BrandCode__c = '118';
    jointParty3.tffa__FirstName__c = 'John';
    jointParty3.tffa__LastName__c = 'May';
    jointParty3.tffa__QualiFileStatus__c = 'PASSED';
    jointParty3.tffa__IDVStatus__c = 'PASSED';
    jointParty3.tffa__IDAStatus__c = 'PASSED';
    jointParty3.tffa__CDDStatus__c = 'PASSED';
    jointParty3.tffa__OFACStatus__c = 'PASSED';
    jointParty3.tffa__Type__c = 'INDIVIDUAL';
    jointParty3.tffa__IsExistingCustomer__c = true;
    jointParty3.tffa__PrimaryPhone__c = '12345678901';
    jointParty3.CellPhoneNumber__c = '12345678921';
    jointParty3.tffa__SecondaryPhone__c = '12345678906';
    insert jointParty3;

    List<tffa__Party__c> partyList = new List<tffa__Party__c>();
    partyList.add(p1);
    partyList.add(p2);
    partyList.add(jointParty2);

    String resp = '{"Entity":{"due-diligence-demographics":{"OccpnDesc":26,"CustNbr":"00000063254","FullTime":"U","InqUpdtInd":"U"},"incoming-countriesLst":[],"outgoing-countriesLst":[]},"Metadata":{"MsgLst":[{"Type":"Informational Message","Text":"Success","Severity":"Info","Code":"0"}]}}';
    tffa__Submission__c subone = new tffa__Submission__c(tffa__Brand__c = '118');
    FISCCIntegrationLogService.setSubmissionObj(sub.Id);

    FISCCIntegrationLogService.setIntegrationLog(sub.Id);

    FISCCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.UPDATED_CUSTOMER_INFORMATION_FLOW);
    FISCCUpdateCustInfoProvider.updateCustInfo(partyList);
    Test.startTest();

    //create due diligence request
    try {
      FISCCCreateDueDiligenceExtension.generateRequest(jointParty);
      FISCCCreateDueDiligenceExtension.generateRequest(jointParty1);
    } catch (Exception ex) {
    }

    //create due diligence response
    try {
      FISCCCreateDueDiligenceExtension.parseCreateDDResponse(new FISCCCreateDDResponseDTO());
    } catch (Exception ee) {
    }

    //update customer info req and response methods
    try {
      FISCCDepositOriginationExtension.customerInfoUpdateReq(jointParty3);
      FISCCDepositOriginationExtension.parseCustInfoUpdateResp(new Map<Id, Boolean>());
    } catch (Exception exp) {
    }

    //update customer info method
    try {
      FISCCDepositOriginationExtension.sendCustInfo(jointParty3);
    } catch (Exception exp) {
    }

    FISCCCreateDDResponseBuilder tstBuild = new FISCCCreateDDResponseBuilder();
    try {
      tstBuild.build(resp, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception ee) {
    }

    try {
      tstBuild.parseResponse(new FISCCCreateDDResponseDTO(), new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception ee) {
    }

    Test.stopTest();
  }

  @isTest
  public static void testCasetwo() {
    Test.startTest();

    FISCCCreateDDResponseBuilder.testException = true;
    FISCCCreateDDResponseBuilder tstBuild = new FISCCCreateDDResponseBuilder();
    try {
      tstBuild.build('', new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception ex) {
    }

    try {
      tstBuild.parseResponse(null, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception ex) {
    }

    FISCCCreateDueDiligenceExtension.testException = true;
    try {
      FISCCCreateDueDiligenceExtension.generateRequest(null);
    } catch (Exception ex) {
    }

    try {
      FISCCCreateDueDiligenceExtension.parseCreateDDResponse(new FISCCCreateDDResponseDTO());
    } catch (Exception ee) {
    }

    Test.stopTest();
  }
}