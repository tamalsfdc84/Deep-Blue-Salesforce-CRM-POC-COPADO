public inherited sharing class FISCCBenefRelnRequestDTO extends FISCCRequestBaseDTO {
  public FISCCBenefRelnRequestDTO() {
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
    public Integer E1ToE2RlCd;
    public Integer E2ToE1RlCd;
  }
}