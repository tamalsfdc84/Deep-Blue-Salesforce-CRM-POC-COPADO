@isTest
private class CZWTFCACHRepositoryTest {
  @isTest
  public static void testCreate() {
    Test.startTest();
    ContentFolderMember folderMember = CZWTFCACHRepository.findContentFolderMember('569847123');
    List<ContentVersion> contentVersion = new List<ContentVersion>();
    CZWTFCACHRepository.insertItem(contentVersion);
    List<UploadFileHistory__c> achFiles = new List<UploadFileHistory__c>();
    CZWTFCACHRepository.insertAchFIle(achFiles);
    List<ContentDocumentLink> contentDocLink = new List<ContentDocumentLink>();
    CZWTFCACHRepository.insertDocumentLink(contentDocLink);
    List<ContentFolderMember> contentFolderName = new List<ContentFolderMember>();
    CZWTFCACHRepository.updateFolderMember(contentFolderName);
    CZWTFCACHRepository.updateAchFiles(achFiles);
    List<ContentFolderMember> cfmember = new List<ContentFolderMember>();
    cfmember = CZWTFCACHRepository.save(cfmember);
    String str = 'str';
    ContentVersion cl = CZWTFCACHRepository.findContentVersion(str);
    ContentWorkspace cw = CZWTFCACHRepository.findContentWorkspace(str);
    ContentFolder cf = CZWTFCACHRepository.findContentFolder(str);
    achFiles = CZWTFCACHRepository.fetchACHNachaFileTransferResults();
    List<SObject> applications = CZWTFCACHRepository.getFundingRequestsForACHFileGeneration('100');
    List<SObject> fundingRequests = CZWTFCACHRepository.getFundingRequestsForACHFileGenerationBatch();
    List<ContentVersion> cvList = CZWTFCACHRepository.getContentVersion();
    List<ACHConfigurations__mdt> achMetadataList =  CZWTFCACHRepository.getMetaData('100');
    Test.stopTest();
  }
}