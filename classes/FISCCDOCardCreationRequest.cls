public with sharing class FISCCDOCardCreationRequest extends FISCCDepositOriginationRequestBaseDTO {
  public FISCCDOCardCreationRequest() {
    this.cardNew = new FISCCDebitCardCreationRequestDTO();
  }
  public FISCCDebitCardCreationRequestDTO cardNew;
}