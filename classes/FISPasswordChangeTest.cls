@isTest
public inherited sharing class FISPasswordChangeTest {
  @isTest
  public static void batchTest() {
    PasswordSequence__c passSeqObj = new PasswordSequence__c();
    passSeqObj.Name = 'test1';
    passSeqObj.SequenceNbr__c = 9;
    insert passSeqObj;

    FISIBSAuthConfig__c fisAuth1 = new FISIBSAuthConfig__c();
    fisAuth1.BrandCode__c = '121';
    fisAuth1.Name = 'test1';
    fisAuth1.IsActive__c = false;
    fisAuth1.UserId__c = '1234';
    fisAuth1.LastUpdatedDate__c = Date.newInstance(2016, 12, 9);
    insert fisAuth1;

    FISIBSAuthConfig__c fisAuth2 = new FISIBSAuthConfig__c();
    fisAuth2.BrandCode__c = '122';
    fisAuth2.Name = 'test2';
    fisAuth2.IsActive__c = false;
    fisAuth2.UserId__c = '1234';
    fisAuth2.LastUpdatedDate__c = Date.newInstance(2016, 12, 9);
    insert fisAuth2;

    FISIBSAuthConfig__c fisAuth3 = new FISIBSAuthConfig__c();
    fisAuth3.BrandCode__c = '121';
    fisAuth3.Name = 'test1';
    fisAuth3.IsActive__c = true;
    fisAuth3.UserId__c = '12345';
    insert fisAuth3;

    FISIBSAuthConfig__c fisAuth4 = new FISIBSAuthConfig__c();
    fisAuth4.BrandCode__c = '122';
    fisAuth4.Name = 'test1';
    fisAuth4.IsActive__c = true;
    fisAuth4.UserId__c = '12345';
    insert fisAuth4;

    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new FISPasswordChangeMockClass());
    Database.executeBatch(new FISCCPasswordChangeBatch());
    Test.stopTest();
  }

  @isTest
  public static void repoTest() {
    PasswordSequence__c passSeqObj = new PasswordSequence__c();
    passSeqObj.Name = 'test1';
    passSeqObj.SequenceNbr__c = 2;
    insert passSeqObj;

    FISIBSAuthConfig__c fisAuth1 = new FISIBSAuthConfig__c();
    fisAuth1.BrandCode__c = '121';
    fisAuth1.Name = 'test1';
    fisAuth1.IsActive__c = false;
    fisAuth1.UserId__c = '1234';
    fisAuth1.LastUpdatedDate__c = Date.newInstance(2016, 12, 9);
    insert fisAuth1;

    FISIBSAuthConfig__c fisAuth2 = new FISIBSAuthConfig__c();
    fisAuth2.BrandCode__c = '122';
    fisAuth2.Name = 'test2';
    fisAuth2.IsActive__c = false;
    fisAuth2.UserId__c = '1234';
    fisAuth2.LastUpdatedDate__c = Date.newInstance(2016, 12, 9);
    insert fisAuth2;

    FISIBSAuthConfig__c fisAuth3 = new FISIBSAuthConfig__c();
    fisAuth3.BrandCode__c = '121';
    fisAuth3.Name = 'test1';
    fisAuth3.IsActive__c = true;
    fisAuth3.UserId__c = '12345';
    insert fisAuth3;

    FISIBSAuthConfig__c fisAuth4 = new FISIBSAuthConfig__c();
    fisAuth4.BrandCode__c = '122';
    fisAuth4.Name = 'test1';
    fisAuth4.IsActive__c = true;
    fisAuth4.UserId__c = '12345';
    insert fisAuth4;

    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new FISPasswordChangeMockClass());
    FISCCPasswordChangeProvider.processPasswordChange(fisAuth4, '1234');
    FISCCIntegrationLogRepository.findSeqNbrforPassChange();
    FISCCIntegrationLogRepository.updateSeqNbr();

    FISCCIntegrationLogRepository.findAuthByBrandandActiveState('121', true);
    FISCCIntegrationLogRepository.saveFisAuthConfig(new List<FISIBSAuthConfig__c>{ fisAuth2 });
    FISCCIntegrationLogRepository.findFisAuthforPassChange();
    FISCCPasswordChangeBatch.encodePassword('1232', '233443');
    Test.stopTest();
  }

  @isTest
  public static void exceptionBlockTest() {
    PasswordSequence__c passSeqObj = new PasswordSequence__c();
    passSeqObj.Name = 'test1';
    passSeqObj.SequenceNbr__c = 2;
    insert passSeqObj;

    FISIBSAuthConfig__c fisAuth1 = new FISIBSAuthConfig__c();
    fisAuth1.BrandCode__c = '121';
    fisAuth1.Name = 'test1';
    fisAuth1.IsActive__c = false;
    fisAuth1.UserId__c = '1234';
    fisAuth1.LastUpdatedDate__c = Date.newInstance(2016, 12, 9);
    insert fisAuth1;

    FISIBSAuthConfig__c fisAuth2 = new FISIBSAuthConfig__c();
    fisAuth2.BrandCode__c = '122';
    fisAuth2.Name = 'test2';
    fisAuth2.IsActive__c = false;
    fisAuth2.UserId__c = '1234';
    fisAuth2.LastUpdatedDate__c = Date.newInstance(2016, 12, 9);
    insert fisAuth2;

    FISIBSAuthConfig__c fisAuth3 = new FISIBSAuthConfig__c();
    fisAuth3.BrandCode__c = '121';
    fisAuth3.Name = 'test1';
    fisAuth3.IsActive__c = true;
    fisAuth3.UserId__c = '12345';
    insert fisAuth3;

    FISIBSAuthConfig__c fisAuth4 = new FISIBSAuthConfig__c();
    fisAuth4.BrandCode__c = '122';
    fisAuth4.Name = 'test1';
    fisAuth4.IsActive__c = true;
    fisAuth4.UserId__c = '12345';
    insert fisAuth4;

    Test.startTest();

    try {
      Map<String, Object> mp = new Map<String, Object>();
      mp.put('StatusMessage', 'qwerrttyyuuio');
      FISCCPasswordChangeExtension.parsePassChangeResp(fisAuth4, mp);
    } catch (Exception ex) {
    }

    try {
      FISCCPasswordChangeProvider.testException = true;
      FISCCPasswordChangeProvider.processPasswordChange(fisAuth4, '12234');
    } catch (Exception ex) {
    }

    try {
      FISCCPasswordChangeExtension.testException = true;
      FISCCPasswordChangeExtension.generateRequest('qwwq');
    } catch (Exception ex1) {
    }

    try {
      FISCCPasswordChangeExtension.testException = true;
      FISCCPasswordChangeExtension.parsePassChangeResp(fisAuth4, null);
    } catch (Exception ex2) {
    }
    Test.stopTest();
  }

  @isTest
  public static void passwordExtensionTest() {
    PasswordSequence__c passSeqObj = new PasswordSequence__c();
    passSeqObj.Name = 'test1';
    passSeqObj.SequenceNbr__c = 2;
    insert passSeqObj;

    FISIBSAuthConfig__c fisAuth1 = new FISIBSAuthConfig__c();
    fisAuth1.BrandCode__c = '121';
    fisAuth1.Name = 'test1';
    fisAuth1.IsActive__c = false;
    fisAuth1.UserId__c = '1234';
    fisAuth1.LastUpdatedDate__c = Date.newInstance(2016, 12, 9);
    insert fisAuth1;

    FISIBSAuthConfig__c fisAuth2 = new FISIBSAuthConfig__c();
    fisAuth2.BrandCode__c = '122';
    fisAuth2.Name = 'test2';
    fisAuth2.IsActive__c = false;
    fisAuth2.UserId__c = '1234';
    fisAuth2.LastUpdatedDate__c = Date.newInstance(2016, 12, 9);
    insert fisAuth2;

    FISIBSAuthConfig__c fisAuth3 = new FISIBSAuthConfig__c();
    fisAuth3.BrandCode__c = '121';
    fisAuth3.Name = 'test1';
    fisAuth3.IsActive__c = true;
    fisAuth3.UserId__c = '12345';
    insert fisAuth3;

    FISIBSAuthConfig__c fisAuth4 = new FISIBSAuthConfig__c();
    fisAuth4.BrandCode__c = '122';
    fisAuth4.Name = 'test1';
    fisAuth4.IsActive__c = true;
    fisAuth4.UserId__c = '12345';
    insert fisAuth4;

    String strDeveloperName = 'PasswordChange';
    FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig(strDeveloperName);

    FISCC_Charter_Config__mdt charterConfig = FISCCIntegrationLogRepository.findCharterConfigByBrandCode('118');

    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new FISPasswordChangeMockClass());
    FISCCPasswordChangeExtension.invokeApiCall(fisAuth4, '1223435', adapterConfig, charterConfig);
    Test.stopTest();
  }

  @isTest
  public static void respBuilderTest() {
    String validResponse = '{"Entity":{"racf-password":{"NewPwd":"********"}},"Metadata":{"MsgLst":[{"Type":"Informational Message","Text":"Success","Severity":"Info","Code":"0"},{"Type":"Informational Message","Text":"00000-OK","Severity":"Info","Code":"SZ00000"}]}}';

    Test.startTest();
    FISCCPassChangeResponseBuilder passResp = new FISCCPassChangeResponseBuilder();
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
    FISCCPassChangeResponseBuilder passResp = new FISCCPassChangeResponseBuilder();
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

  @isTest
  public static void logRepoTest() {
    Test.startTest();
    FISCCPassChangeResponse passresp = new FISCCPassChangeResponse();
    FISCCIntegrationLogRepository.updateSeqNbr();

    Test.stopTest();
  }
}