public with sharing class FISCCDeficitTransferRequest extends FISCCRequestBaseDTO {
  public FISCCDeficitTransferRequest() {
    this.defTransfer = new deficitTransferNew();
    this.deficitTransferSenderLst = new List<deficitTransferSender>();
  }

  public deficitTransferNew defTransfer;
  public List<deficitTransferSender> deficitTransferSenderLst;

  public class deficitTransferNew {
    public String FMDPSysReceivingAcctNbr;
    public String RcvAcctSysCde;
    public String FMCustNme;
    public String FMDfctTrsfrSeqNbr;
    public String FMBalTyp;
    public Integer FMTrsfrIncmt;
    public String FMMinTrsfrTyp;
  }

  public class deficitTransferSender {
    public String FMOrd;
    public String FMAcctNbr;
    public String FMSysCde;
  }
}