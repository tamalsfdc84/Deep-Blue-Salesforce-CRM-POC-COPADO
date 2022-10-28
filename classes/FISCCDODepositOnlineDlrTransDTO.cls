public with sharing class FISCCDODepositOnlineDlrTransDTO extends FISCCRequestBaseDTO {
  public FISCCDODepositOnlineDlrTransDTO() {
    this.depositOnlineDollarTrans = new DepositOnlineDollarTrans();
  }

  public DepositOnlineDollarTrans depositOnlineDollarTrans;
  public class DepositOnlineDollarTrans {
    public String DPAcctNbr;
    public String DPLogTyp;
    public Integer DPTxnCde;
    public Decimal DPDolrTxnAmt;
    public Integer DPGLAcctNbr;
    public Integer DPGLCstCntr;
    public String AutoOvrideInd;
    public String DPTxnTrlrDesc1;
    public String DPTxnTrlrDesc2;
    public String DPTxnTrlrDesc3;
    public String DPOvrideInfo;
    public String TxnSecurityInd;
  }
}