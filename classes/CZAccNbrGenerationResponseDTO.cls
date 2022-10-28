public with sharing class CZAccNbrGenerationResponseDTO extends FISCCTransactionResponseBaseDTO {
  public Entity entity;
  public CZAccNbrGenerationResponseDTO() {
    this.entity = new Entity();
  }

  public class Entity {
    public AccountNbr accnbr;
    public Entity() {
      this.accnbr = new AccountNbr();
    }
  }

  public class AccountNbr {
    public String DPAcctBrnch;
    public String DPAcctTyp;
    public String GenDPAcctNbr;
  }
}