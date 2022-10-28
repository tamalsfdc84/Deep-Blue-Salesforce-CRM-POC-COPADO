@isTest
public with sharing class CZWTFCMXCheckVerStatusProviderTest {
  @isTest
  static void testFetchAccounts() {
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCMXCheckVerStatusProviderMockClass('testSuccess'));
    try {
      Map<String, String> params = new Map<String, String>();
      params.put(
        'sessionToken',
        'VVNSLWY4OWQyMzlhLTI5Y2UtNGM1MC1iYzgxLTlkMDZlMjE0NmQ0N3w3ZTk0ZmViMTEwMThlNTllMGExODJhM2I0YmRmNWZhMWQ2Y2UzZmQ3ZmYwMWVjODk3MjhmOWQ4NDcwY2E5NjZlOWU4Y2EzODA1NjMxOWE4OWM5OTU5ZDIzYzEzN2IzYjNiZWE5NzNmMmM1NTAwNmMyY2UyYTQ3ZTc3YjRkOGZkZmFlZGZlYzU3NmUxMDg0NDdiNDAwMzVhMzc5NjAyNjU4fDlGUkpxbGhwTlRSZ1JOT1dnSHZITjNFZUE1Vk1hWFJ5WEk2YjV0WXpIY3M='
      );

      CZWTFCMXCheckVerificationStatusProvider.checkVerificationStatus(params);
    } catch (Exception e) {
      tffa.Logger.debug('Inside exception');
    }

    //Test verification service provider error block
    try {
      CZWTFCMXCheckVerificationServiceProvider.invokeAPI(new Map<String, String>());
      CZWTFCMXCheckVerificationServiceProvider.testException = true;
      CZWTFCMXCheckVerificationServiceProvider.invokeAPI(new Map<String, String>());
    } catch (Exception ex) {
    }

    //Test verification status adapter error block
    try {
      CZWTFCMXCheckVerificationStatusAdapter.testException = true;
      CZWTFCMXCheckVerificationStatusAdapter.execute(new Map<String, String>());
    } catch (Exception exc) {
    }

    //Test CZWTFCMXCheckVerificationStatusProvider adapter error block
    try {
      CZWTFCMXCheckVerificationStatusProvider.testException = true;
      CZWTFCMXCheckVerificationStatusProvider.checkVerificationStatus(new Map<String, String>());
    } catch (Exception excp) {
    }

    //Test CZWTFCMXCheckVerificationStatusService adapter error block
    try {
      CZWTFCMXCheckVerificationStatusService.testException = true;
      CZWTFCMXCheckVerificationStatusService.execute(new Map<String, String>());
    } catch (Exception excp) {
    }

    Test.stopTest();
  }
}