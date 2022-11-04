public with sharing class FISCCCustToCustRelnRequestDTO extends FISCCRequestBaseDTO {
  public FISCCCustToCustRelnRequestDTO() {
    this.ccMaintainedCust = new CCMaintainedCustomer();
    this.customerRelnship = new List<CustomerRelnship>();
  }
  public CCMaintainedCustomer ccMaintainedCust;
  public List<CustomerRelnship> customerRelnship;

  public class CCMaintainedCustomer {
    public String CustNbr;
  }

  public class CustomerRelnship {
    public String RltCustNbr;
    public String EffDte;
    public String ExpDte;
    public String E1toE2Cde;
    public String E2toE1Cde;
    public String RltPercentOwner;
    public String RltBeneOwnr;
    public String RltBeneTitle;
    public String PriPercentOwner;
    public String PriBeneOwnr;
    public String PriBeneTitle;
  }
}