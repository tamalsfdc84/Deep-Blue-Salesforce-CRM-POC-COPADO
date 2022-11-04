public with sharing class CZWTFCFetchSDBTaxRateResponseDTO extends FISCCTransactionResponseBaseDTO {
  public Entity entity;
  public CZWTFCFetchSDBTaxRateResponseDTO() {
    this.Entity = new Entity();
  }

  public class Entity {
    public BranchesDetail branchesDetail;
    public Entity() {
      this.branchesDetail = new BranchesDetail();
    }
  }
  public class BranchesDetail {
    public String SafeDPBoxSalesTaxPct;
  }
}