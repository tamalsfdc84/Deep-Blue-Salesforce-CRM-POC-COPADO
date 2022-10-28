public with sharing class FISCCMultiKeywordsResponseDTO extends FISCCTransactionResponseBaseDTO {
  public Entity entity;
  public FISCCMultiKeywordsResponseDTO() {
    this.entity = new Entity();
  }

  public class Entity {
    public List<Keywords> keywordsLst;
    public Entity() {
      this.keywordsLst = new List<Keywords>();
    }
  }

  public class Keywords {
    public String DPKywrdCde;
    public String DPOrgNbr;
    public String DPKywrdOldVal;
    public String DPAcctNbr;
    public String DPKywrdVal;
    public String DPKywrdAlertMsg;
    public String DPOrgNme;
    public String DPKywrdNewLitTxt;
    public String DPKywrdOldLitTxt;
  }

  public static FISCCMultiKeywordsResponseDTO parse(String json) {
    return (FISCCMultiKeywordsResponseDTO) System.JSON.deserialize(json, FISCCMultiKeywordsResponseDTO.class);
  }
}