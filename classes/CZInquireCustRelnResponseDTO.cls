public with sharing class CZInquireCustRelnResponseDTO extends FISCCTransactionResponseBaseDTO {
  public Entity entity;
  public CZInquireCustRelnResponseDTO() {
    this.entity = new Entity();
  }

  public class Entity {
    public QueryParameterCustReln queryParamCustomerReln;
    public List<CustToCustRelnDataList> custToCustRelnDataLst;
    public Entity() {
      this.queryParamCustomerReln = new QueryParameterCustReln();
      this.custToCustRelnDataLst = new List<CustToCustRelnDataList>();
    }
  }

  public class QueryParameterCustReln {
    public String CustNbr;
    public String CIEffRltInd;
    public String CICustEntityFilter;
    public String RepoCIRltApplCde1;
    public String RltCustNbr;
    public String RepoCIRltBnkNbr1;
    public String E1ToE2Cde;
    public String E2ToE1Cde;
    public String EffDte;
    public String CIMoreToBeReturnedInd;
    public String CINbrCustRltRtrn;
  }

  public class CustToCustRelnDataList {
    public String CIRltCusttApplCde;
    public String RltCustNbr;
    public String CIRltCustBnkNbr;
    public String EffDte;
    public String ExpDte;
    public String E1toE2Cde;
    public String E2toE1Cde;
    public Decimal RltPercentOwner;
    public String CIPrspctInd;
    public String CICurStdNme1;
    public String CIRltCustLstNme;
    public String CIRltCustFrstNme;
    public String RltBeneOwnr;
    public String RltBeneTitle;
    public String PriPercentOwner;
    public String PriBeneOwnr;
    public String PriBeneTitle;
  }
}