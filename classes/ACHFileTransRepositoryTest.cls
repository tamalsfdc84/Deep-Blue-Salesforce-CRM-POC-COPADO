@isTest
private class ACHFileTransRepositoryTest {
  @isTest
  public static void testCreate() {
    Test.startTest();
    List<Id> docIds1 = new List<Id>();
    List<String> docIds = new List<String>();
    list<UploadFileHistory__c> entities = new List<UploadFileHistory__c>();
    List<ContentVersion> contentVerList = ACHFileTransRepository.findCVByDocId(docIds1);
    List<Document> documents1 = ACHFileTransRepository.findDocById(docIds);
    List<UploadFileHistory__c> documents2 = ACHFileTransRepository.save(entities);

    Test.stopTest();
  }

  @isTest
  public static void testgetFundingRequestAchfetch(){
      Test.startTest();
      CZWTFCACHRepository.getFundingRequestsForACHFileGeneration('1234');
      Test.stopTest();
  }
}