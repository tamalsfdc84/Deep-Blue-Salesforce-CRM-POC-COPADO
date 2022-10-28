public inherited sharing class CZWTFCFileTransferResultDTO {
  public CZWTFCFileTransferResultDTO() {
  }

  public List<UploadFileHistory__c> files { get; set; }
  public List<ContentVersion> cvList { get; set; }
}