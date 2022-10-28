public with sharing class FISCCDOCustomerAccountRelationRequest extends FISCCDepositOriginationRequestBaseDTO {
  public FISCCDOCustomerAccountRelationRequest() {
    this.customerAccounts = new FISCCCustomerAccountRelationDTO();
  }
  public FISCCCustomerAccountRelationDTO customerAccounts;
}