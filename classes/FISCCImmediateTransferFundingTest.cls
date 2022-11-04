@isTest
public class FISCCImmediateTransferFundingTest {
  @isTest
  static void testImmediateTransfer() {
    String respStr = '{"Entity":{"immediate-transfers":{"FMLogTyp":"L","TxnSecurityInd":3,"FMTrsfrFromDPId":0,"FMTrsfrWithholdingTranAmt":0,"FMTrsfrToAcct":8666856,"FMTrsfrFromHSACde":0,"FMOvrideInfo":" ","FMTrsfrToHSACde":0,"FMTrsfrFromSys":"DP","FMTrsfrAmt":100,"FMTrsfrToDPId":0,"FMTrsfrFromRaCde":0,"FMTrsfrToSys":"DP","FMTrsfrDte":"2021-11-16","FMTrsfrCstCntrDr":8114,"FMTrsfrToRaCde":0,"FMTrsfrOfstCr":2006512,"FMTrsfrFromAcct":2095086,"FMTrsfrOfstDr":2006512,"FMTrsfrCstCntrCr":8114,"FMTrsfrWithholdingRaCde":0}},"Metadata":{"MsgLst":[{"Type":"Informational Message","Text":"Success","Severity":"Info","Code":"0"},{"Type":"Informational Message","Text":"DPOD043-TRANSACTION AMOUNT EXCEEDS ACCOUNTS CURRENT BALANCE.","Severity":"Info","Code":"D600043"},{"Type":"Informational Message","Text":"DPOD047-NO SIGNATURE CARD ON FILE.","Severity":"Info","Code":"D600047"},{"Type":"Informational Message","Text":"DPOD052-USER DEFINED STATUS CODE 2","Severity":"Info","Code":"D600052"},{"Type":"Informational Message","Text":"TRANSFER             PROCESSED      BY OVERRIDE      FINAL LOGGED","Severity":"Info","Code":"FM0"}]}}';
    tffa__Product__c product = CZWTFCTestDataRepository.createCheckingProduct();

    tffa__Submission__c sub = new tffa__Submission__c(tffa__Status__c = 'SUBMITTED', tffa__Brand__c = '380');
    insert sub;
    tffa__Application__c app = new tffa__Application__c(
      tffa__Submission__c = sub.Id,
      tffa__AccountNumber__c = '8666856',
      tffa__Product__c = product.id
    );
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
    FISCCIntegrationLogService.setSubmissionObj(sub.Id);
    FISCCIntegrationLogService.setPartyObjs();
    FISCCIntegrationLogService.setIntegrationLog(sub.Id);
    FISCCIntegrationLogService.setApplicationObjs();
    FISCCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.ACCOUNT_OPENING);
    CZWTFCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.APPROVAL_CCCOMPLETE, app.Id, false);
    FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig('ImmediateTransfer');
    FISCC_Charter_Config__mdt charterConfig = FISCCIntegrationLogRepository.findCharterConfigByBrandCode(sub.tffa__Brand__c);

    FISCCDODepositOnlineImmediateTransDTO reqDTO = new FISCCDODepositOnlineImmediateTransDTO();
    FISCCImmediateTransResponseDTO respDTO = new FISCCImmediateTransResponseDTO();
    FISCCImmediateTransResponseBuilder respBuilder = new FISCCImmediateTransResponseBuilder();
    respBuilder.build(respStr, adapterConfig, charterConfig);
    respBuilder.parseResponse(respDTO, adapterConfig, charterConfig);
    FISCCApplicationFundingProvider.processFunding(CZWTFCApplicationRepository.findApplicationById(app.Id));
    Test.startTest();

    Test.setMock(HttpCalloutMock.class, new FISCCImmediateTfrMockClass());
    FISCCImmediateTransferExtension.parseImmediateTransResponse(new FISCCImmediateTransResponseDTO());
    FISCCImmediateTransferExtension.parseImmediateTransResponse('test');
    FISCCImmediateTransferExtension.parseImmediateTransResponse(null);
    Object resp = FISCCImmediateTransferExtension.InvokeApiCall(
      CZWTFCApplicationRepository.findApplicationById(app.Id),
      adapterConfig,
      charterConfig
    );
    System.assertNotEquals(resp, null);
    Test.stopTest();
  }
  @isTest
  private static void testRespBuilderFailure() {
    Test.startTest();
    FISCCImmediateTransResponseBuilder idaR = new FISCCImmediateTransResponseBuilder();
    FISCCImmediateTransResponseBuilder.testException = true;
    try {
      idaR.build('', new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception e) {
      System.assertNotEquals(e.getMessage(), null);
    }
    try {
      idaR.parseResponse(null, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception e) {
      System.assertNotEquals(e.getMessage(), null);
    }
    Test.stopTest();
  }
}