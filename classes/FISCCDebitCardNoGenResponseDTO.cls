public with sharing class FISCCDebitCardNoGenResponseDTO extends FISCCTransactionResponseBaseDTO {
  public Entity entity;
  public FISCCDebitCardNoGenResponseDTO() {
    this.entity = new Entity();
  }

  public class Entity {
    public CardNumber cardNumber;
    public Entity() {
      this.cardNumber = new CardNumber();
    }
  }

  public class CardNumber {
    public String CBInstnNbr;
    public String CBCrdPrfxNbr;
    public String CBCrdNbr;
  }

  public static FISCCDebitCardNoGenResponseDTO parse(String json) {
    return (FISCCDebitCardNoGenResponseDTO) System.JSON.deserialize(json, FISCCDebitCardNoGenResponseDTO.class);
  }
}