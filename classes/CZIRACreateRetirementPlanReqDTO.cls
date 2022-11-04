public with sharing class CZIRACreateRetirementPlanReqDTO extends FISCCRequestBaseDTO{
  public CZWTFCIRAPlanDetailsResponse.PlanData plansDetail;
  public List<CZWTFCIRAPlanDetailsResponse.planAccountData> planAccountData;

  public CZIRACreateRetirementPlanReqDTO() {
    this.plansDetail = new CZWTFCIRAPlanDetailsResponse.PlanData();
    this.planAccountData = new List<CZWTFCIRAPlanDetailsResponse.planAccountData>();
  }
  
}