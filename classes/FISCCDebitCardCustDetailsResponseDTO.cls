public with sharing class FISCCDebitCardCustDetailsResponseDTO extends FISCCTransactionResponseBaseDTO {
  public Entity entity;
  public FISCCDebitCardCustDetailsResponseDTO() {
    this.entity = new Entity();
  }

  public class Entity {
    public CardsCardholderAddress CardsCardholderAddress;
    public Entity() {
      this.CardsCardholderAddress = new CardsCardholderAddress();
    }
  }

  public class CardsCardholderAddress {
    public String Email;
    public String PrmyHmPh;
    public String InstnNbr;
    public String CrdNbr;
    public String CrdStatCde;
  }

  public static FISCCDebitCardCustDetailsResponseDTO parse(String json) {
    return (FISCCDebitCardCustDetailsResponseDTO) System.JSON.deserialize(json, FISCCDebitCardCustDetailsResponseDTO.class);
  }
}