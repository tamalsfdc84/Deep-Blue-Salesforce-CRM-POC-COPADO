public with sharing class FISCCDebitCardNoGenRequestDTO extends FISCCRequestBaseDTO {
  public CardNumber cardNumber;
  public FISCCDebitCardNoGenRequestDTO() {
    this.cardNumber = new CardNumber();
  }

  public class CardNumber {
    public String CBInstnNbr;
    public String CBCrdPrfxNbr;
  }
}