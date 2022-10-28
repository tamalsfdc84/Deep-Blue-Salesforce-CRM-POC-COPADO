public with sharing class CZFetchPhoneNbrResponseDTO extends FISCCTransactionResponseBaseDTO {
  public Entity entity;
  public CZFetchPhoneNbrResponseDTO() {
    this.entity = new Entity();
  }

  public class Entity {
    public List<PhnNbrDetails> custPhoneNumberLst;
    public Entity() {
      this.custPhoneNumberLst = new List<PhnNbrDetails>();
    }
  }

  public class PhnNbrDetails {
    public String ResnCde;
    public String EffDte;
    public String LocalNbr;
    public String AreaCde;
  }
}