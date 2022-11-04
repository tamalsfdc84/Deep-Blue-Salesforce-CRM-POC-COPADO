public with sharing class FISCCCreateAliasRequestDTO extends FISCCRequestBaseDTO {
  public FISCCCreateAliasRequestDTO() {
    this.customerAliasNew = new AliasNew();
  }
  public AliasNew customerAliasNew;
  public class AliasNew {
    public string AlNme;
    public string NmeAddrCustTyp;
    public string CustNbr;
    public string NmeAddrStandOvrideInd;
    public string AlSeqNbr;
    public string AlPrcsTme;
  }
}