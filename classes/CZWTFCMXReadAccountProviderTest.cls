@isTest
public with sharing class CZWTFCMXReadAccountProviderTest {
  @isTest
  static void testReadAccountNbr() {
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCMXReadAccountProviderMockClass('testSuccess'));
    try {
      Map<String, String> params = new Map<String, String>();
      params.put('accountGUID', 'ACT-a2f81705-47bc-4e5b-8506-df76921248c3');
      params.put('sessionToken', '123456');

      CZWTFCMXReadMemberAccountProvider.fetchMemberAccountDetails(params);
      CZWTFCMXServiceConfiguration.getMXConfig();
    } catch (Exception e) {
      tffa.Logger.debug('Inside exception');
    }

    try {
      CZWTFCMXReadMemberAccountServiceProvider.testException = true;
      CZWTFCMXReadMemberAccountServiceProvider.invokeAPI(new Map<String, String>());
    } catch (Exception ex) {
    }

    try {
      CZWTFCMXReadMemberAccountService.testException = true;
      CZWTFCMXReadMemberAccountService.execute(new Map<String, String>());
    } catch (Exception ex) {
    }

    try {
      CZWTFCMXReadMemberAccountService.parseResponse('');
    } catch (Exception ex) {
    }

    try {
      CZWTFCMXReadMemberAccountProvider.testException = true;
      CZWTFCMXReadMemberAccountProvider.fetchMemberAccountDetails(new Map<String, String>());
    } catch (Exception ex) {
    }

    try {
      CZWTFCMXReadMemberAccountRespDTO.parse('');
    } catch (Exception ex) {
    }

    Test.stopTest();
  }
}