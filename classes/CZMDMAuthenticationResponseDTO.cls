public with sharing class CZMDMAuthenticationResponseDTO extends CZMDMResponseBaseDTO {
  public CZMDMAuthenticationResponseDTO() {
    this.customerInfo = new CustomerInfo();
    this.customerRcdLst = new List<CustomerRcdLst>();
    this.acctLst = new List<AcctLst>();
  }

  public String status;
  public String prtyId;
  public CustomerInfo customerInfo;
  public List<CustomerRcdLst> customerRcdLst;
  public List<AcctLst> acctLst;

  public class IdtfrLst {
    public String idtfrTypCd;
    public String idtfrNmb;
    public String issueStateCd;
    public String expDte;
    public String issueDte;
  }

  public class CustomerInfo {
    public CustomerInfo() {
      this.idtfrLst = new List<IdtfrLst>();
    }
    public String frstNme;
    public String mdlNme;
    public String lstNme;
    public String addrsLn1;
    public String addrsLn2;
    public String city;
    public String stateCd;
    public String zipCd;
    public String country;
    public String primPhNmb;
    public String scndryPhNmb;
    public String mblPhNmb;
    public String psnlEmailId;
    public String birthDte;
    public List<IdtfrLst> idtfrLst;
    public String ssnNmb;
    public String ctzshp;
    public String occpCd;
    public String emplyStatCd;
    public String emplyTitle;
    public String emplyNme;
    public String suffix;
    public String isEmp;
    public String platMemSt;
    public String taxIdType;
    public String taxId;
    public String jrSvrsMbrshpFlag;
  }

  public class CustomerRcdLst {
    public String cisNmb;
    public String chrtrCd;
    public String cisStrtDte;
    public String primOffcrCd;
    public String scndyOffcrNbr;
    public String pwdValue;
    public String pwdQuestion;
    public String costCntr;
    public String brnchCd;
    public String isFounder;
  }

  public class AcctLst {
    public String acctNmb;
    public String chrtrCd;
    public String acctCreationDte;
    public String acctCtgry;
    public String pdtCd;
    public String pdtNm;
    public String acctTyp;
    public String acctstatus;
    public String ownrshpCd;
    public String rltnshpCd;
  }
}