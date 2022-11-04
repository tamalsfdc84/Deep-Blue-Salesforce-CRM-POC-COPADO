@isTest
private class CZNachaFilesTransferServiceTest {
  @isTest
  public static void testCreate() {
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCNachaFTMockClass(200));
    List<ContentVersion> cvList = new List<ContentVersion>();
    ContentVersion cv = new ContentVersion();
    CZWTFCFileTransferResultDTO ojb = new CZWTFCFileTransferResultDTO();
    UploadFileHistory__c oo = new UploadFileHistory__c();
    oo.BrandCode__c = '158';
    oo.SerialNumber__c = '1';
    oo.FileTransferRetryCount__c = 1;
    oo.DocumentId__c = '0691h000001OOWSAA4';
    cv.Title = 'Hello world';
    cv.ContentDocumentId = '0691h000001OOWSAA4';
    cv.PathOnClient = 'TRFACH_RY01A11801111999103039_001.ach';
    cv.VersionData = Blob.valueOf('Nacha file transfer token response data!!!');
    cvList.add(cv);
    Map<String, UploadFileHistory__c> fileMap = new Map<String, UploadFileHistory__c>();
    fileMap.put(cv.ContentDocumentId, oo);
    ojb = CZMulesoftFileTransferService.transferFiles(cvList, fileMap);
    System.assertNotEquals(ojb, null);
    Test.stopTest();
  }

  @isTest
  public static void testCreate1() {
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCNachaFTMockClass(500));
    List<ContentVersion> cvList = new List<ContentVersion>();
    ContentVersion cv = new ContentVersion();
    CZWTFCFileTransferResultDTO ojb = new CZWTFCFileTransferResultDTO();
    UploadFileHistory__c oo = new UploadFileHistory__c();
    oo.BrandCode__c = '158';
    oo.SerialNumber__c = '1';
    oo.FileTransferRetryCount__c = 1;
    oo.DocumentId__c = '0691h000001OOWSAA4';
    cv.Title = 'Hello world';
    cv.ContentDocumentId = '0691h000001OOWSAA4';
    cv.PathOnClient = 'TRFACH_RY01A11801111999103039_001.ach';
    cv.VersionData = Blob.valueOf('Nacha file transfer token response data!!!');
    cvList.add(cv);
    Map<String, UploadFileHistory__c> fileMap = new Map<String, UploadFileHistory__c>();
    fileMap.put(cv.ContentDocumentId, oo);
    ojb = CZMulesoftFileTransferService.transferFiles(cvList, fileMap);
    System.assertNotEquals(ojb, null);
    Test.stopTest();
  }

  @isTest
  public static void testCreate2() {
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCNachaFTMockClass(1));
    List<ContentVersion> cvList = new List<ContentVersion>();
    ContentVersion cv = new ContentVersion();
    CZWTFCFileTransferResultDTO ojb = new CZWTFCFileTransferResultDTO();
    UploadFileHistory__c oo = new UploadFileHistory__c();
    oo.BrandCode__c = '158';
    oo.SerialNumber__c = '1';
    oo.FileTransferRetryCount__c = 1;
    oo.DocumentId__c = '0691h000001OOWSAA4';
    cv.Title = 'Hello world';
    cv.ContentDocumentId = '0691h000001OOWSAA4';
    cv.PathOnClient = 'TRFACH_RY01A11801111999103039_001.ach';
    cv.VersionData = Blob.valueOf('Nacha file transfer token response data!!!');
    cvList.add(cv);
    Map<String, UploadFileHistory__c> fileMap = new Map<String, UploadFileHistory__c>();
    fileMap.put(cv.ContentDocumentId, oo);
    ojb = CZMulesoftFileTransferService.transferFiles(cvList, fileMap);
    System.assertNotEquals(ojb, null);
    Test.stopTest();
  }
}