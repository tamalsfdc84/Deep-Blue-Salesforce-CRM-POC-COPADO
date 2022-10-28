@isTest
private class CZNachaFileTransferBatchTest {
  @isTest
  public static void testCreate() {
    Test.startTest();

    try {
      Test.setMock(HttpCalloutMock.class, new CZWTFCNachaFTMockClass(200));
      CZNachaFileTransferBatch obj = new CZNachaFileTransferBatch();
      Database.BatchableContext batchableContext;
      tffa__Submission__c sub = new tffa__Submission__c(tffa__Brand__c = '100');
      insert sub;
      tffa__fundingrequest__c fund = new tffa__fundingrequest__c(tffa__Type__c='ACH',ACHReportGenerated__c= false,tffa__Status__c = 'ACH_FILE_GENERATED',tffa__Submission__c=sub.id);
      insert fund;
      UploadFileHistory__c file1 = new UploadFileHistory__c();
      file1.FileName__c = 'Mytestfile';
      file1.DocumentId__c = '0691h000001ONNPAA4';
      List<ContentVersion> cvList = new List<ContentVersion>();
      ContentVersion oo = new ContentVersion();
      ContentVersion o1 = new ContentVersion();
      oo.FileTransferStatus__c = 'Failure';
      o1.FileTransferStatus__c = 'Success';
      cvList.add(oo);
      cvList.add(o1);
      List<UploadFileHistory__c> files = new List<UploadFileHistory__c>();
      files.add(file1);
      List<UploadFileHistory__c> lst = obj.start(batchableContext);
      obj.execute(batchableContext, files);
      obj.sendEmail(cvList);
      obj.finish(batchableContext);
    } catch (Exception e) {
      tffa.Logger.error('Exception Nacha FT batch Test class:' + e.getStackTraceString());
    }
    Test.stopTest();
  }
}