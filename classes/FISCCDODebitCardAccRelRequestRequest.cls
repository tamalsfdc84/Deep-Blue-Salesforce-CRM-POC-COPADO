public with sharing class FISCCDODebitCardAccRelRequestRequest extends FISCCDepositOriginationRequestBaseDTO {
  public FISCCDODebitCardAccRelRequestRequest() {
    this.customerAccounts = new FISCCDebitCardAccRelRequestDTO();
  }
  public FISCCDebitCardAccRelRequestDTO customerAccounts;
}