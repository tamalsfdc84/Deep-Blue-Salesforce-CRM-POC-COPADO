public with sharing class CZIRARetirementPlanResponseDTO extends FISCCTransactionResponseBaseDTO {
  public Entity entity;
  public CZIRARetirementPlanResponseDTO() {
    this.entity = new Entity();
  }

  public class Entity {
    public PlansDetail plansDetail;
    public Entity() {
      this.plansDetail = new PlansDetail();
    }
  }

  public class PlansDetail{
    public String TaxNbr;
    public Integer PlnTyp;
    public Integer RePlnBrnch;
    public Integer REPlnCstCntr;
    public Integer PrmyOffcrNbr;
    public String PlnBnfcyPln;
    public String DecdTin;
  }
}