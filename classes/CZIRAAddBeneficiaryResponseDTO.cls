public with sharing class CZIRAAddBeneficiaryResponseDTO extends FISCCTransactionResponseBaseDTO {
  public Entity entity;
  public CZIRAAddBeneficiaryResponseDTO() {
    this.entity = new Entity();
  }

  public class Entity {
    public RetirementPlan retirementPlan;
    public Entity() {
      this.retirementPlan = new RetirementPlan();
    }
  }

  public class RetirementPlan {
    public String PlnNbr;
  }
}