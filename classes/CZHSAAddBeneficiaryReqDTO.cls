public with sharing class CZHSAAddBeneficiaryReqDTO extends FISCCRequestBaseDTO {

    public CZHSAAddBeneficiaryReqDTO(){
      this.acctInfo = new AccountInfo();
      this.beneficiaryInfo = new BeneficiaryInfo();
      this.MultiCustOverrideInd = '';
    }

    public AccountInfo acctInfo;
    public BeneficiaryInfo beneficiaryInfo;
    public String MultiCustOverrideInd;

    public class AccountInfo{
      public String ApplCde;
      public String AcctNum;
    }

    public class BeneficiaryInfo{
      public BeneficiaryInfo(){
        this.AddLst = new List<AddList>();
      }

      public List<AddList> AddLst; 
    }

    public class AddList{
      public AddList(){
        this.ExistingCust = new ExistingCust();
        this.NewCust = new NewCust();
      }

      public NewCust NewCust;
      public ExistingCust ExistingCust;
      public Decimal E1E2;
      public Decimal E2E1;
      public String EffDte;
      public Decimal RelaPercent;
    }

    public class ExistingCust{
      public Decimal CustNum;
    }

    public class NewCust{
      public String CustTyp;
      public String CustNme;
      public String Addr;
      public String CtyStZip;
      public String OvrdStandardized;
      public String OvrdAddrStandardized;
      public String Country;
      public String OvrdDupTaxNum;
      public String BrthDte;
      public String TaxId;
      public Decimal TaxNum;
      public Decimal Phone;
      public String BusTyp;
    }
}