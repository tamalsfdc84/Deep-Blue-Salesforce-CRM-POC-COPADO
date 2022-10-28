public inherited sharing class FISCCExpediteCardDeliveryRequestDTO extends FISCCRequestBaseDTO {
  public PinlessCardData pinlessCardData;
  public FISCCExpediteCardDeliveryRequestDTO() {
    this.pinlessCardData = new PinlessCardData();
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
    public Integer ExpedCardFeeInd;
    public String WaiveReissCrdFee;
    public Integer ReissCrdWaiveReason;
    public Integer NewPrefix;
    public Integer ProdID;
    public Integer UseReissCrdStk;
  }
}