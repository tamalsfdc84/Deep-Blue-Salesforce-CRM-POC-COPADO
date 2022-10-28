public with sharing class FISCCDOGenerateDepositAccNumberRequest extends FISCCDepositOriginationRequestBaseDTO {
  public FISCCDOGenerateDepositAccNumberRequest() {
    this.depositAccountNumber = new FISCCGenerateDepositAccNumberDTO();
  }
  public FISCCGenerateDepositAccNumberDTO depositAccountNumber;
}