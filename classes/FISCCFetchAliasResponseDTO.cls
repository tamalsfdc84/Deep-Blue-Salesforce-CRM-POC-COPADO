public with sharing class FISCCFetchAliasResponseDTO extends FISCCTransactionResponseBaseDTO {
  public FISCCFetchAliasResponseDTO() {
    this.Entity = new Entity();
  }

  public Entity Entity;
  public class Entity {
    public List<AliasList> fetchCustomerAlias;
    public Entity() {
      this.fetchCustomerAlias = new List<AliasList>();
    }
  }
  public class AliasList {
    public string Seq;
    public string PrcsTme;
    public string AlNme;
  }
}