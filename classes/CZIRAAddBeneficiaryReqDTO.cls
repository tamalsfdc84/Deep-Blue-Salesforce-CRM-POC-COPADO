public with sharing class CZIRAAddBeneficiaryReqDTO extends FISCCRequestBaseDTO {

    public CZIRAAddBeneficiaryReqDTO(){
      this.planBeneficiary = new PlanBeneficiary();
      this.planBeneficiariesDataLst = new List<PlanBeneficiariesDataLst>();
    }

    public PlanBeneficiary planBeneficiary;
    public List<PlanBeneficiariesDataLst> planBeneficiariesDataLst;

    public class PlanBeneficiary{
      public String PlnNbr;
    }

    public class PlanBeneficiariesDataLst{
      public String Nme;
      public String TaxId;
      public String TxpyrNbr;
      public String SpseNonSpseInd;
      public String PrmyCntgInd;
      public String Perc;
      public String Birthdate;
      public String Phn;
    }
}