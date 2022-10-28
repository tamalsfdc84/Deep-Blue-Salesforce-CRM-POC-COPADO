public with sharing class FISCCImmediateTransResponseDTO extends FISCCTransactionResponseBaseDTO {
  public Entity entity;
  public FISCCImmediateTransResponseDTO() {
    this.Entity = new Entity();
  }

  public class Entity {
    public ImmediateTransfers immediatetransfers;
    public Entity() {
      this.immediatetransfers = new ImmediateTransfers();
    }
  }
  public class ImmediateTransfers {
    public String FMLogTyp;
    public Integer TxnSecurityInd;
    public Integer FMTrsfrFromDPId;
    public String FMTrsfrWithholdingTranAmt;
    public String FMTrsfrToAcct;
    public Integer FMTrsfrFromHSACde;
    public String FMOvrideInfo;
    public Integer FMTrsfrToHSACde;
    public String FMTrsfrFromSys;
    public Decimal FMTrsfrAmt;
    public Integer FMTrsfrToDPId;
    public Integer FMTrsfrFromRaCde;
    public String FMTrsfrToSys;
    public String FMTrsfrDte;
    public Integer FMTrsfrCstCntrDr;
    public Integer FMTrsfrToRaCde;
    public String FMTrsfrOfstCr;
    public String FMTrsfrFromAcct;
    public String FMTrsfrOfstDr;
    public Integer FMTrsfrCstCntrCr;
    public Integer FMTrsfrWithholdingRaCde;
  }
}