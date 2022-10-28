public with sharing class FISCCDebitCardCustDetailsRequestDTO extends FISCCRequestBaseDTO {
  public CardsCardholderAddress CardsCardholderAddress;
  public FISCCDebitCardCustDetailsRequestDTO() {
    this.CardsCardholderAddress = new CardsCardholderAddress();
  }

  public class CardsCardholderAddress {
    public String Email;
    public String PrmyHmPh;
  }
}