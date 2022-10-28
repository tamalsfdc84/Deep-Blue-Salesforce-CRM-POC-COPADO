public with sharing class FISCCDODepositOnlineImmediateTransDTO extends FISCCRequestBaseDTO {
  public FISCCDODepositOnlineImmediateTransDTO() {
    this.immediatetransfers = new DepositOnlineImmediateTrans();
  }
  public DepositOnlineImmediateTrans immediatetransfers;
  public class DepositOnlineImmediateTrans {
    public String FMTrsfrFromSys;
    public String FMTrsfrFromAcct;
    public String FMTrsfrToSys;
    public String FMTrsfrToAcct;
    public Decimal FMTrsfrAmt;
    public String AutoOvrideInd;
    public String FMLogTyp;
    public String FMOvrideInfo;
    public String TxnSecurityInd;
    public String FMTrsfrDte;
  }
}