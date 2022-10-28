public with sharing class FISCCDepositOriginationResponse {
  public FISCCDepositOriginationResponse() {
    this.customer = new FISCCCustomerDTO();
    this.customerOrg = new FISCCOrganizationDTO();
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
  public FISCCOrganizationDTO customerOrg;
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
  public Entity entity;

  public class FISCCCustomerEmail {
    public FISCCCustomerEmail() {
      this.emailAddressesLst = new List<FISCCCreateEmailAddressesDTO>();
    }
    public String CustNbr;
    public List<FISCCCreateEmailAddressesDTO> emailAddressesLst;
  }

  public class Entity {
    public Entity() {
      this.dueDiligenceReq = new FISCCDOCustomerDDResponse();
    }
    public FISCCDOCustomerDDResponse dueDiligenceReq;
  }
  public class FISCCDOCustomerDDResponse {
    public FISCCDOCustomerDDResponse() {
      this.dueDiligenceDemographics = new List<FISCCDODueDiligenceDTO>();
    }
    public List<FISCCDODueDiligenceDTO> dueDiligenceDemographics;
  }
}