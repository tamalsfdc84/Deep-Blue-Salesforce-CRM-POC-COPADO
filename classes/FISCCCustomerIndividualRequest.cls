public with sharing class FISCCCustomerIndividualRequest extends FISCCRequestBaseDTO {
  public FISCCCustomerIndividualRequest() {
    this.customer = new FISCCCustomerDTO();
  }
  public FISCCCustomerDTO customer;
}