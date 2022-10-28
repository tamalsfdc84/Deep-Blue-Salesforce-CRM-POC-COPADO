@isTest
public with sharing class FISDeficitTransferTest {
  @isTest
  public static void batchTest() {
    Map<String, String> mp = new Map<String, String>();
    mp.put('accNbr', '2633958');
    mp.put('senderAccNbr', '1022032');
    mp.put('custName', 'Debit sa');

    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new FISDeficitTransferMockClass());
    FISCCDeficitTransferProvider.transferFundInstructions(mp, '118');
    Test.stopTest();
  }

  @isTest
  public static void repoTest() {
    Map<String, String> mp = new Map<String, String>();
    mp.put('accNbr', '2633958');
    mp.put('senderAccNbr', '1022032');
    mp.put('custName', 'Debit sa');

    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new FISPasswordChangeMockClass());
    String strDeveloperName = 'DeficitFundTransfer';
    FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig(strDeveloperName);

    FISCC_Charter_Config__mdt charterConfig = FISCCIntegrationLogRepository.findCharterConfigByBrandCode('118');
    FISCCDeficitTransferExtension.invokeApiCall(mp, adapterConfig, charterConfig);
    Test.stopTest();
  }

  @isTest
  public static void exceptionBlockTest() {
    Map<String, String> mp = new Map<String, String>();
    mp.put('accNbr', '2633958');
    mp.put('senderAccNbr', '1022032');
    mp.put('custName', 'Debit sa');
    Test.startTest();
    try {
      FISCCDeficitTransferProvider.testException = true;
      FISCCDeficitTransferProvider.transferFundInstructions(mp, '118');
    } catch (Exception ex) {
    }

    try {
      FISCCDeficitTransferExtension.testException = true;
      FISCCDeficitTransferExtension.generateRequest('', '', '');
    } catch (Exception ex1) {
    }

    try {
      FISCCDeficitTransferExtension.testException = true;
      FISCCDeficitTransferExtension.parseDeficitTransResp(null);
    } catch (Exception ex2) {
    }
    Test.stopTest();
  }

  @isTest
  public static void respBuilderTest() {
    String validResponse = '{"Entity":{"deficit-transfers-new":{"FMDfctTrsfrSeqNbr":"001","FMMaintainedBal":0,"FMThrshldBal":0,"FMItmByItmTrsfr":"N","FMEndDte":"9999-12-31","FMStrtDte":"2021-10-13","FMDPSysReceivingAcctNbr":"00000000000004303445","RcvAcctSysCde":"DP","CalcPassMultBal":"N","FMTrsfrIncmt":0,"FMMinTrsfrAmt":0,"FMMinTrsfrTyp":"N","FMBalTyp":"A"},"deficit-transfers-sendersLst":[{"FMOverdrawBalTyp":"L","FMNotc":"N","FMOrd":1,"FMNoteNbrOrDPId":"0000000000","FMNotcServChrgTyp":"N","FMAcctNbr":1022032,"FMOverdrawInd":"A","FMFmsTyp":"000","FMSysCde":"DP","FMDfctTrsfrAvailBalToTeller":"N"}]},"Metadata":{"MsgLst":[{"Type":"Informational Message","Text":"Success","Severity":"Info","Code":"0"}]}}';

    Test.startTest();
    FISCCDeficitTransResponseBuilder passResp = new FISCCDeficitTransResponseBuilder();
    try {
      passResp.build(validResponse, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception e) {
    }
    try {
      passResp.parseResponse(null, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception e) {
    }
    Test.stopTest();
  }

  @isTest
  public static void respBuilderExpTest() {
    Test.startTest();
    FISCCDeficitTransResponseBuilder passResp = new FISCCDeficitTransResponseBuilder();
    FISCCPassChangeResponseBuilder.testException = true;
    try {
      passResp.build('', new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception e) {
    }
    try {
      passResp.parseResponse(null, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    } catch (Exception e) {
    }
    Test.stopTest();
  }
}