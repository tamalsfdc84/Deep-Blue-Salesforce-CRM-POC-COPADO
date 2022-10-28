public with sharing class CZFetchEmailAddressResponseDTO extends FISCCTransactionResponseBaseDTO {
  public Entity entity;
  public CZFetchEmailAddressResponseDTO() {
    this.entity = new Entity();
  }

  public class Entity {
    public List<EmailAddDetails> emailaddressesLst;
    public Entity() {
      this.emailaddressesLst = new List<EmailAddDetails>();
    }
  }

  public class EmailAddDetails {
    public String ResnCde;
    public String EffDte;
    public String EmailAddr;
  }
}