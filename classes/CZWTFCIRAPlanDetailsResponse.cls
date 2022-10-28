public with sharing class CZWTFCIRAPlanDetailsResponse extends FISCCTransactionResponseBaseDTO {
  public PlanData planData;
  public List<PlanAccountData> planAccountData;

  public CZWTFCIRAPlanDetailsResponse() {
    this.planData = new PlanData();
    this.planAccountData = new List<PlanAccountData>();
  }

  public class PlanData {
    public String PlnNbr;
    public String CustNme;
    public string PlnBnfcyPln;
    public string CurBal;
    public string TaxNbr;
    public string PlnTyp;
    public string PlnTypNme;
    public string RePlnBrnch;
    public string REPlnCstCntr;
    public string PrmyOffcrNbr;
    public string OpenYr;
    public string CustomersDteOfBrth;
    public string HmPhOnAcct;
    public STring PrevPlnNbr;
    public String DecdTin;
    public String REDPAddr;
    public String PlnEmplrIRSPln;
    public String PlnStmtMailingCde;
    public String PlnNotcMailingAddr;
    public String PlnNotcMailingCde;
    public String AltMailingAddr;
    public String AltMailingCde;
    public String REPlnChecksMailingAddr;
    public String PlnDferIncmInd;
    public String PrevActnCde;
    public String PlnTs;
    public String StmtMthd;
    public String NoticeDelivy;
  }

  public class planAccountData {
    public String PlnIndvAcctNbr;
    public String PlnIndvDPCat;
    public String PlnIndvCurBal;
    public String PlnIndvFMV;
  }
}