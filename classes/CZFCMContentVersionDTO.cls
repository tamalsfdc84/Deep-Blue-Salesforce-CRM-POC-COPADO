public with sharing class CZFCMContentVersionDTO {

  public CZFCMContentVersionDTO() {
    this.PathOnClient = '';
    this.FileExtension = '';
    this.ContentVersionId = '';
    this.Title = '';
    this.PartyId = '';
    this.ApplicationId = '';
    this.DocumentCode = '';
    this.EntityId = '';
    this.URL = '';
    this.DeveloperName = '';
  }

  public String PathOnClient;
  public String FileExtension;
  public String ContentVersionId;
  public String Title;
  public String PartyId;
  public String ApplicationId;
  public String DocumentCode;
  public String EntityId;
  public String URL;
  public String DeveloperName;
  public Id ContentDocumentId;
  public Integer contentSize;

}