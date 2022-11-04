public with sharing class CZWTFCDocusingResult {
  public CZWTFCDocusingResult() {
    draftURLs = new List<String>();
    envelopeIDs = new List<String>();
  }
  public String envelopeId;
  public String url = '';
  public String msg;
  public Boolean displayPopUp;
  public String contentDocId;
  public List<String> draftURLs;
  public List<String> envelopeIDs;
  public String status = 'Success';
}