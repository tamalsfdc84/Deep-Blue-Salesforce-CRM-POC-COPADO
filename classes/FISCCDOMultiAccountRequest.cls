public with sharing class FISCCDOMultiAccountRequest extends FISCCDepositOriginationRequestBaseDTO {
  public FISCCDOMultiAccountRequest() {
    this.debitCardMultipleAccount = new FISCCMultiAccDebitCardCreationRequestDTO();
  }
  public FISCCMultiAccDebitCardCreationRequestDTO debitCardMultipleAccount;
}