public with sharing class FISCCDeleteAliasResponseDTO extends FISCCTransactionResponseBaseDTO {
  public FISCCDeleteAliasResponseDTO() {
    this.Entity = new Entity();
  }

  public Entity Entity;
  public class Entity {
    public DeleteAlias deleteCustomerAlias;
    public Entity() {
      this.deleteCustomerAlias = new DeleteAlias();
    }
  }
  public class DeleteAlias {
    public string CustNbr;
    public string NmeAddrCustTyp;
    public string AlNme;
    public string NmeAddrStandOvrideInd;
    public string AlSeqNbr;
    public string AlPrcsTme;
  }
}