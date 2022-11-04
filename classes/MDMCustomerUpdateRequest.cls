public with sharing class MDMCustomerUpdateRequest {
  public MDMCustomerUpdateRequest() {
    this.phoneNumbersLst = new List<PhoneNumber>();
    this.emailAddressesLst = new List<EmailAddress>();
  }

  public List<PhoneNumber> phoneNumbersLst;
  public List<EmailAddress> emailAddressesLst;

  public class PhoneNumber{
    public String resnCde;
    public String localNbr;
    public String areaCde;
    public String ctryCde;
  }

  public class EmailAddress{
    public String resnCde;
    public String emailAddr;
  }
}