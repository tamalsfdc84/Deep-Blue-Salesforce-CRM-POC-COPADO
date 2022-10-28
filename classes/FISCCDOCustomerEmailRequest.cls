public with sharing class FISCCDOCustomerEmailRequest extends FISCCDepositOriginationRequestBaseDTO {
  public FISCCDOCustomerEmailRequest() {
    this.customerEmail = new FISCCCustomerEmail();
  }
  public FISCCCustomerEmail customerEmail;
  public class FISCCCustomerEmail {
    public FISCCCustomerEmail() {
      this.emailAddressLst = new List<FISCCCreateEmailAddressesDTO>();
    }
    public String CustNbr;
    public List<FISCCCreateEmailAddressesDTO> emailAddressLst;
  }
}