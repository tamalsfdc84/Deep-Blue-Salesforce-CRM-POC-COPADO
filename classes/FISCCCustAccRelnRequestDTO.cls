public with sharing class FISCCCustAccRelnRequestDTO extends FISCCRequestBaseDTO {
  public FISCCCustAccRelnRequestDTO() {
    this.caMaintainAcc = new CaMaintainedAccount();
    this.caAccRelnList = new List<CustomerAccountRelnList>();
  }

  public CaMaintainedAccount caMaintainAcc;

  public List<CustomerAccountRelnList> caAccRelnList;

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