public with sharing class CZFCMContentVersionDTO {

  public CZFCMContentVersionDTO() {
    this.PathOnClient = '';
    this.FileExtension = '';
    this.ContentVersionId = '';
    this.Title = '';
    this.PartyId = '';
    this.DisclosureCode = '';
    this.URL = '';
    this.DeveoperName = '';
  }

  public String PathOnClient;
  public String FileExtension;
  public String ContentVersionId;
  public String Title;
  public String PartyId;
  public String DisclosureCode;
  public String URL;
  public String DeveoperName;
  public Id ContentDocumentId;
  public Integer contentSize;

}