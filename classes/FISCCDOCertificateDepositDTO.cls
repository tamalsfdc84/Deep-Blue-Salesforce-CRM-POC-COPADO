public with sharing class FISCCDOCertificateDepositDTO extends FISCCRequestBaseDTO {
  public FISCCDOCertificateDepositDTO() {
    this.account = new Account();
  }

  public Account account;

  public class Account {
    public String DPAcctNbrNewCD;
    public String DPTDTxnTyp;
    public String DPTDIssAmt;
    public String DPTDTerm;
    public String DPTDTermInd;
    public String DPTDIntPln;
    public Integer DPTDGLAcctNbrOfst;
    public Integer DPTDGLCstCntrOfst;
    public String DLTNCOvrideErrLvlInd;
    public String DPTDCurIntRte;
    public String DPTDIntFreqInd;
    public String DPTDIntFreq;
    public String TmeLvlIntExtTypCde;
    public String TmeLvlIntExtTrsfrAbaNbr;
    public String DPTDIntTrsfrToAcct;
    public String DPTDPmtMeth;
    public Integer DPRetAcctTxnCde;
    public String DPTDOpenAPY;
  }
}