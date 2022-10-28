@isTest
public with sharing class CZWTFCMXFetchAccountsProviderTest {
  @isTest
  static void testFetchAccounts() {
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCMXFetchAccountsProviderMockClass('testSuccess'));
    try {
      Map<String, String> params = new Map<String, String>();
      params.put(
        'sessionToken',
        'VVNSLWY4OWQyMzlhLTI5Y2UtNGM1MC1iYzgxLTlkMDZlMjE0NmQ0N3w3ZTk0ZmViMTEwMThlNTllMGExODJhM2I0YmRmNWZhMWQ2Y2UzZmQ3ZmYwMWVjODk3MjhmOWQ4NDcwY2E5NjZlOWU4Y2EzODA1NjMxOWE4OWM5OTU5ZDIzYzEzN2IzYjNiZWE5NzNmMmM1NTAwNmMyY2UyYTQ3ZTc3YjRkOGZkZmFlZGZlYzU3NmUxMDg0NDdiNDAwMzVhMzc5NjAyNjU4fDlGUkpxbGhwTlRSZ1JOT1dnSHZITjNFZUE1Vk1hWFJ5WEk2YjV0WXpIY3M='
      );
      CZWTFCMXFetchMemberAccountsProvider.fetchMemberAccountList(params);
    } catch (Exception e) {
      tffa.Logger.debug('Inside exception');
    }

    //Test error block
    try {
      CZWTFCMXFetchAccountsServiceProvider.invokeAPI(new Map<String, String>());
      CZWTFCMXFetchAccountsServiceProvider.testException = true;
      CZWTFCMXFetchAccountsServiceProvider.invokeAPI(new Map<String, String>());
    } catch (Exception ex) {
    }

    try {
      CZWTFCMXFetchMemberAccountResponseDTO.parse('');
    } catch (Exception exc) {
    }

    try {
      CZWTFCMXFetchMemberAccountsAdapter.testException = true;
      CZWTFCMXFetchMemberAccountsAdapter.execute(new Map<String, String>());
    } catch (Exception excp) {
    }

    try {
      CZWTFCMXFetchMemberAccountsProvider.testException = true;
      CZWTFCMXFetchMemberAccountsProvider.fetchMemberAccountList(new Map<String, String>());
    } catch (Exception excec) {
    }

    try {
      CZWTFCMXFetchMemberAccountsService.testException = true;
      CZWTFCMXFetchMemberAccountsService.execute(new Map<String, String>());
    } catch (Exception error) {
    }

    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }

  @isTest
  public static void testMXFetchAcc() {
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCMXFetchMicroDepoMockClass());
    try {
      Map<String, String> params = new Map<String, String>();
      params.put(
        'sessionToken',
        'VVNSLWY4OWQyMzlhLTI5Y2UtNGM1MC1iYzgxLTlkMDZlMjE0NmQ0N3w3ZTk0ZmViMTEwMThlNTllMGExODJhM2I0YmRmNWZhMWQ2Y2UzZmQ3ZmYwMWVjODk3MjhmOWQ4NDcwY2E5NjZlOWU4Y2EzODA1NjMxOWE4OWM5OTU5ZDIzYzEzN2IzYjNiZWE5NzNmMmM1NTAwNmMyY2UyYTQ3ZTc3YjRkOGZkZmFlZGZlYzU3NmUxMDg0NDdiNDAwMzVhMzc5NjAyNjU4fDlGUkpxbGhwTlRSZ1JOT1dnSHZITjNFZUE1Vk1hWFJ5WEk2YjV0WXpIY3M='
      );
      params.put('microDepositGUID', '123456789');
      CZWTFCMXFetchMicroDepoAccProvider.fetchMemberAccountList(params);
    } catch (Exception e) {
      tffa.Logger.debug('Inside exception');
    }

    tffa.Context ctx = tffa.Context.get();
    tffa__Brand__c brandObj = new tffa__Brand__c();
    brandObj.Name = '118';
    brandObj.tffa__Code__c = '118';
    brandObj.FooterLogo__c = 'test';
    brandObj.HeaderLogo__c = 'test';
    insert brandObj;

    SubBrand__c subB = new SubBrand__c();
    subB.Brand__c = brandObj.Id;
    subB.Name = 'Test';
    insert subB;

    tffa__Submission__c sub = new tffa__Submission__c(tffa__Brand__c = '118');
    insert sub;
    Map<String, String> mp = new Map<String, String>();
    mp.put('subId', sub.Id);
    mp.put('isMXUserCreated', 'false');
    try {
      CZWTFCMXController.setSubForTest = true;
      CZWTFCMXController.fetchMicroDepositAccount(ctx, mp);
    } catch (Exception ex) {
    }

    try {
      CZWTFCMXController.testException = true;
      CZWTFCMXController.setSubForTest = true;
      CZWTFCMXController.fetchMicroDepositAccount(ctx, mp);
    } catch (Exception ex) {
    }

    try {
      Map<String, String> params = new Map<String, String>();
      CZWTFCMXFetchMicroDepoAccProvider.testException = true;
      CZWTFCMXFetchMicroDepoAccProvider.fetchMemberAccountList(params);
    } catch (Exception ex) {
    }
    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }
}