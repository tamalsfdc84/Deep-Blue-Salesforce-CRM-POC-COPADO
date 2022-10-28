public with sharing class FISCCDebitCardAccRelResponseDTO extends FISCCTransactionResponseBaseDTO {
  public Entity entity;
  public FISCCDebitCardAccRelResponseDTO() {
    this.entity = new Entity();
  }

  public class Entity {
    public accounts accounts;
    public Entity() {
      this.accounts = new accounts();
    }
  }

  public class accounts {
    public String BnkNbr;
    public String NmeAddrLne01;
    public String NmeAddrLne03;
    public String AcctNbr;
    public String NmeAddrLne02;
    public String ApplCde;
    public String CIRmrkOrigSrcInd;
    public String CIRmrkEffTme;
    public String RmrkEffDte;
    public String CINmeAddrLneCde01;
    public String CIRltApplNbr01;
    public String RmrkPermTempInd;
    public String CIRmrkPrcsTme;
    public String CINmeAddrLneCde03;
    public String CINmeAddrLneCde02;
    public String PriSecRltCde01;
    public String RmrkExpDte;
    public String RmrkLne01;
    public String CIEnt1ToEnt2RltCde;
  }

  public static FISCCDebitCardAccRelResponseDTO parse(String json) {
    return (FISCCDebitCardAccRelResponseDTO) System.JSON.deserialize(json, FISCCDebitCardAccRelResponseDTO.class);
  }
}