public with sharing class FISCCCustAccRelnResponseDTO extends FISCCTransactionResponseBaseDTO {
  public FISCCCustAccRelnResponseDTO() {
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
    public String E1ToE2RlCd;
    public String E2ToE1RlCd;
  }
}