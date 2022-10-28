public with sharing class ACHContentHelper {
  /**
    This method will upload the file to content document 
    and wll return the id of content version
     */
  public String uploadFile(Blob blobData, String fileName, String folderName, String documentLinkId) {
    ContentVersion contVerFile = new ContentVersion();
    String documentId = null;
    try {
      contVerFile.VersionData = blobData;
      contVerFile.ContentLocation = 'S';
      contVerFile.Title = fileName;
      contVerFile.PathOnClient = filename;
      CZWTFCApplicationRepository.saveSingle(contVerFile);
      ContentVersion contVerFileforDoc = CZWTFCApplicationRepository.getContent(contVerFile.id);
      documentId = contVerFileforDoc.ContentDocumentId;
      tffa.Logger.debug('documentLinkId' + documentLinkId);
      if (documentLinkId != null) {
        ContentWorkspace ws = CZWTFCApplicationRepository.getContentWorkSpace('FilesForApplication');
        ContentFolder cf = CZWTFCApplicationRepository.getContentFolder(documentLinkId);
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = documentId;
        cdl.Visibility = 'AllUsers';
        cdl.LinkedEntityId = ws.id;
        cdl.ShareType = 'I';
        CZWTFCApplicationRepository.saveSingle(cdl);
        ContentFolderMember updateFolderMember = CZWTFCApplicationRepository.getContentFolderMember(documentId);
        updateFolderMember.ParentContentFolderId = cf.id;
        CZWTFCApplicationRepository.saveSingle(updateFolderMember);
      }
    } catch (Exception ex) {
      tffa.Logger.debug('ACHContentHelper : Failed while uploading a file');
      tffa.Logger.debug('Exception is :' + ex);
    }
    return documentId;
  }
}