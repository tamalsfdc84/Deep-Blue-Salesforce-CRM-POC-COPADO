public with sharing class FISCCMultiKeywordsRequestDTO extends FISCCRequestBaseDTO {
  public List<Keywords> keywordsLst;
  public FISCCMultiKeywordsRequestDTO() {
    this.keywordsLst = new List<Keywords>();
  }

  public class Keywords {
    public String DPKywrdCde;
    public String DPKywrdVal;
    public String DPKywrdSegId;
    public Integer DPTxnCde;
  }
}