public with sharing class FISCCDOCustomerDTO extends FISCCDepositOriginationRequestBaseDTO {
  public FISCCDOCustomerDTO() {
    this.customer = new FISCCCustomerDTO();
  }
  public FISCCCustomerDTO customer;
  public String SvcID;
}