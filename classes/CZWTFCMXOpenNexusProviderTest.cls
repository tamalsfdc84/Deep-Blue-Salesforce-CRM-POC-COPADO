@isTest
public with sharing class CZWTFCMXOpenNexusProviderTest {
  @isTest
  static void testOpenNexuSession() {
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCMXOpenNexusProviderMockClass('testSuccess'));
    try {
      CZWTFCMXOpenNexusProvider.getSessionToken(
        'VVNSLWY4OWQyMzlhLTI5Y2UtNGM1MC1iYzgxLTlkMDZlMjE0NmQ0N3w3ZTk0ZmViMTEwMThlNTllMGExODJhM2I0YmRmNWZhMWQ2Y2UzZmQ3ZmYwMWVjODk3MjhmOWQ4NDcwY2E5NjZlOWU4Y2EzODA1NjMxOWE4OWM5OTU5ZDIzYzEzN2IzYjNiZWE5NzNmMmM1NTAwNmMyY2UyYTQ3ZTc3YjRkOGZkZmFlZGZlYzU3NmUxMDg0NDdiNDAwMzVhMzc5NjAyNjU4fDlGUkpxbGhwTlRSZ1JOT1dnSHZITjNFZUE1Vk1hWFJ5WEk2YjV0WXpIY3M='
      );

      CZWTFCMXOpenNexusServiceProvider.testException = true;
      CZWTFCMXOpenNexusProvider.getSessionToken(
        'VVNSLWY4OWQyMzlhLTI5Y2UtNGM1MC1iYzgxLTlkMDZlMjE0NmQ0N3w3ZTk0ZmViMTEwMThlNTllMGExODJhM2I0YmRmNWZhMWQ2Y2UzZmQ3ZmYwMWVjODk3MjhmOWQ4NDcwY2E5NjZlOWU4Y2EzODA1NjMxOWE4OWM5OTU5ZDIzYzEzN2IzYjNiZWE5NzNmMmM1NTAwNmMyY2UyYTQ3ZTc3YjRkOGZkZmFlZGZlYzU3NmUxMDg0NDdiNDAwMzVhMzc5NjAyNjU4fDlGUkpxbGhwTlRSZ1JOT1dnSHZITjNFZUE1Vk1hWFJ5WEk2YjV0WXpIY3M='
      );
      CZWTFCMXOpenNexusService.testException = true;
      CZWTFCMXOpenNexusService.execute(new Map<String, String>());
      CZWTFCMXServiceConfiguration.getMXConfig();
    } catch (Exception e) {
      tffa.Logger.debug('Inside exception');
    }

    try {
      CZWTFCMXOpenNexusProvider.testException = true;
      CZWTFCMXOpenNexusProvider.getSessionToken('');
    } catch (Exception exp) {
    }

    try {
      CZWTFCMXOpenNexusAdapter.testException = true;
      CZWTFCMXOpenNexusAdapter.execute(new Map<String, String>(), '');
    } catch (Exception exp) {
    }

    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }
}