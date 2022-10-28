public with sharing class FISCCDOCreateNewDepositAccRequest extends FISCCDepositOriginationRequestBaseDTO {
  public FISCCDOCreateNewDepositAccRequest() {
    this.depositAccount = new FISCCCreateNewDepositAccDTO();
  }
  public FISCCCreateNewDepositAccDTO depositAccount;
}