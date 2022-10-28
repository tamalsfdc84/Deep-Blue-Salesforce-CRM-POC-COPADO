public with sharing class FISCCDollarTransResponseDTO extends FISCCTransactionResponseBaseDTO {
  public Entity entity;
  public FISCCDollarTransResponseDTO() {
    this.entity = new Entity();
  }

  public class Entity {
    public DepositOnlineDollarTrans depositOnlineDollarTransResp;
    public Entity() {
      this.depositOnlineDollarTransResp = new DepositOnlineDollarTrans();
    }
  }
  public class DepositOnlineDollarTrans {
    public String DPAcctNbr;
    public String DPLogTyp;
    public Integer DPTxnCde;
    public Decimal DPDolrTxnAmt;
    public Integer DPGLAcctNbr;
    public Integer DPGLCstCntr;
    public String AutoOvrideInd;
    public String DPOvrideInfo;
    public Integer TxnSecurityInd;
  }
}