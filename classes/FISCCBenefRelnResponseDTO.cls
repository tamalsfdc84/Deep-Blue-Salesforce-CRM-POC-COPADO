public inherited sharing class FISCCBenefRelnResponseDTO extends FISCCTransactionResponseBaseDTO {
  public FISCCBenefRelnResponseDTO() {
    this.Entity = new Entity();
  }

  public class Entity {
    public Entity() {
      this.caMaintainAcc = new CaMaintainedAccount();
      this.caAccRelnList = new List<CustomerAccountRelnList>();
    }

    public CaMaintainedAccount caMaintainAcc;
    public List<CustomerAccountRelnList> caAccRelnList;
  }
  public Entity Entity;

  public class CaMaintainedAccount {
    public String ApCd1;
    public String ApNbr1;
  }

  public class CustomerAccountRelnList {
    public String AcNbr2;
    public Integer E1ToE2RlCd;
    public Integer E2ToE1RlCd;
  }
}