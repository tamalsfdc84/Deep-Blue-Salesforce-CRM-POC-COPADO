public inherited sharing class FISCCExpediteCardDeliveryResponseDTO extends FISCCTransactionResponseBaseDTO {
  public Entity entity;
  public FISCCExpediteCardDeliveryResponseDTO() {
    this.entity = new Entity();
  }
  public class Entity {
    public PinlessCardData pinlessCardData;
    public Entity() {
      this.pinlessCardData = new PinlessCardData();
    }
  }
  public class PinlessCardData {
    public String CrdNbr;
    public String CBInstnNbr;
    public String CBReissueCardInd;
    public String ImageKey;
    public String CrdStckCode;
    public String ExpAddr1;
    public String ExpAddr2;
    public String ExpAddr3;
    public String ExpCountry;
    public String ExpedCardFeeInd;
    public String WaiveReissCrdFee;
    public String ReissCrdWaiveReason;
    public String NewPrefix;
    public String ProdID;
    public String UseReissCrdStk;
  }
}