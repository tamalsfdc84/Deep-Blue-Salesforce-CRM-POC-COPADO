@isTest
private class CZWTFCFileTransferResultDTOTest {
  @isTest
  public static void testCreate() {
    Test.startTest();
    List<UploadFileHistory__c> files1 = new List<UploadFileHistory__c>();
    List<ContentVersion> cvList1 = new List<ContentVersion>();
    new CZWTFCFileTransferResultDTO().files = files1;
    new CZWTFCFileTransferResultDTO().cvList = cvList1;
    System.assertNotEquals(files1, null);
    System.assertNotEquals(cvList1, null);
    Test.stopTest();
  }
}