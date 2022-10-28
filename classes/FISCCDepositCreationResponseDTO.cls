public with sharing class FISCCDepositCreationResponseDTO extends FISCCTransactionResponseBaseDTO {
  public Entity entity;
  public FISCCDepositCreationResponseDTO() {
    this.entity = new Entity();
  }

  public class Entity {
    public Entity() {
      this.newCertificateDeposit = new newCertificateDeposit();
    }
    public newCertificateDeposit newCertificateDeposit;
  }

  public class newCertificateDeposit {
    public Integer DPTDId;
  }

  public class Account {
    public String DPAcctNbr;
    public String DPTDTxnTyp;
    public String DPTDIssAmt;
    public String DPTDTerm;
    public String DPTDTermInd;
    public String DPTDIntPln;
    public Integer DPTDGLAcctNbrOfst;
    public Integer DPTDGLCstCntrOfst;
    public String AutoOvrideInd;
  }
}