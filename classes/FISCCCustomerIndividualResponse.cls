public with sharing class FISCCCustomerIndividualResponse extends FISCCResponseBaseDTO {
  public FISCCCustomerDTO customerLst;
  public FISCCCustomerIndividualResponse() {
    this.customerLst = new FISCCCustomerDTO();
  }
}