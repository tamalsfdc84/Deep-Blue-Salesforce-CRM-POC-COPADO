public with sharing class FISCCCreateAliasResponseDTO extends FISCCTransactionResponseBaseDTO {
  public FISCCCreateAliasResponseDTO() {
    this.Entity = new Entity();
  }
  public Entity Entity;
  public class Entity {
    public AliasNew customerAliasNew;
    public Entity() {
      this.customerAliasNew = new AliasNew();
    }
  }
  public class AliasNew {
    public string AlNme;
    public string NmeAddrCustTyp;
    public string CustNbr;
    public string NmeAddrStandOvrideInd;
    public string AlSeqNbr;
    public string AlPrcsTme;
  }
}