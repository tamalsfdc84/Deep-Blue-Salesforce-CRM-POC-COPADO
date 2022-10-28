public with sharing class FISCCDepositOriginationResponse {
  public FISCCDepositOriginationResponse() {
    this.customer = new FISCCCustomerDTO();
    this.mbpassLst = new List<FISCCMBPassDTO>();
    this.customeremail = new FISCCCustomerEmail();
    this.depositAccountNumber = new FISCCGenerateDepositAccNumberDTO();
    this.depositAddresses = new FISCCDepositNameAddressDTO();
    this.customerAccounts = new FISCCCustomerAccountRelationDTO();
    this.depositOnlineDollarTrans = new FISCCDODepositOnlineDlrTransDTO();
    this.certificateDeposit = new FISCCDOCertificateDepositDTO();
  }
  public String SvcID;
  public FISCCCustomerDTO customer;
  List<FISCCMBPassDTO> mbpassLst;
  public FISCCCustomerEmail customeremail;
  public FISCCCreatePhoneNumberDTO custPhoneNumber;
  public FISCCIndividualDemographicsDTO individualDemographics;
  public FISCCGenerateDepositAccNumberDTO depositAccountNumber;
  public FISCCCreateNewDepositAccDTO depositAccount;
  public FISCCDepositNameAddressDTO depositAddresses;
  public FISCCCustomerAccountRelationDTO customerAccounts;
  public FISCCDODepositOnlineDlrTransDTO depositOnlineDollarTrans;
  public FISCCDOCertificateDepositDTO certificateDeposit;

  public class FISCCCustomerEmail {
    public FISCCCustomerEmail() {
      this.emailAddressesLst = new List<FISCCCreateEmailAddressesDTO>();
    }
    public String CustNbr;
    public List<FISCCCreateEmailAddressesDTO> emailAddressesLst;
  }
}