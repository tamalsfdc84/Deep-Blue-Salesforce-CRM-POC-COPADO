public with sharing class FISCCDebitCardCreationResponseDTO extends FISCCTransactionResponseBaseDTO {
  public Entity entity;
  public FISCCDebitCardCreationResponseDTO() {
    this.entity = new Entity();
  }

  public class Entity {
    public CardNew cardNew;
    public Entity() {
      this.cardNew = new CardNew();
    }
  }

  public class CardNew {
    public String CBExpDte;
    public String OptInSrcInd;
    public String CBCrdAddrFIConfigInd;
    public String CBCtyNme;
    public String CBCrdStatCde;
    public String CBInstnNbr;
    public String CBPrmyDdaAcctNbr;
    public String CBPrmySsn;
    public String CBCrdNmeLne1;
    public String CBZIP;
    public String CBShrtNmeLst;
    public String CBShrtNmeFrst;
    public String CBBrnchNbr;
    public String CBCrdPrfxNbr;
    public String CBStrAddrLne1;
    public String CustNbr;
    public String CBCrdNbr;
    public String CBStAbbr;
    public String NmeEmbossOnCard;
    public String CtryCde;
    public String OptlLneEmbossOnCard;
  }

  public static FISCCDebitCardCreationResponseDTO parse(String json) {
    return (FISCCDebitCardCreationResponseDTO) System.JSON.deserialize(json, FISCCDebitCardCreationResponseDTO.class);
  }
}