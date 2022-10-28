public with sharing class CZHSAAddBeneficiaryResponseDTO extends FISCCTransactionResponseBaseDTO {
  public Entity entity;
  public CZHSAAddBeneficiaryResponseDTO() {
    this.entity = new Entity();
  }

  public class Entity {
    public String ApplCde;
    public String AcctNum;
    public List<BeneficiaryLst> beneficiaryLst;
    public List<StatusLst> statusLst;
    public Entity() {
      this.beneficiaryLst = new List<BeneficiaryLst>();
      this.statusLst = new List<StatusLst>();
    }
  }

  public class StatusLst {
    public String StatusCde;
    public String StatusMsg;
  }

  public class BeneficiaryLst {
    public String CustNum;
  }
}