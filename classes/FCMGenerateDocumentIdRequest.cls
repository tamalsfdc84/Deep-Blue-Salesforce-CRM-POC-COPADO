public with sharing class FCMGenerateDocumentIdRequest extends FISCCRequestBaseDTO {
  public FCMGenerateDocumentIdRequest() {
    this.accountlist = new List<Accounts>();
    this.Fieldlist = new List<Fields>();
  }

  public List<Accounts> accountlist;
  public String dtype;
  public String FCMUploadDate;
  public String ftype;
  public String docdescription;
  public List<Fields> Fieldlist;

  public class Accounts {
    public String account;
    public String application;
  }

  public class Fields {
    public String name;
    public String value;
  }
 
}