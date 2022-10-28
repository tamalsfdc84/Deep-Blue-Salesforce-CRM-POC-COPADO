public with sharing class FISCCDOCustomerIndividualRequest extends FISCCDepositOriginationRequestBaseDTO {
  public FISCCDOCustomerIndividualRequest() {
    this.customer = new FISCCCustomerDTO();
  }
  public FISCCCustomerDTO customer;
}