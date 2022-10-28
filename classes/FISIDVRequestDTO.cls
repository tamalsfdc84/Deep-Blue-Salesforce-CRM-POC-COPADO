public inherited sharing class FISIDVRequestDTO extends FISCCRequestBaseDTO {
  public FISIDVRequestDTO() {
    this.custIdent = new CustIdentification();
    this.personQry = new PersonQuery();
  }

  public CustIdentification custIdent;
  public PersonQuery personQry;
  /**
   * CustIdentification Request Object
   */
  public class CustIdentification {
    public String acquirerid; ///not valid value
    public String chexsystemsversionnbr = '';
    public String customerid;

    public Boolean includechexsystems = false;
    public Boolean includeidentitymanager;

    public Boolean includeofac;

    public Boolean includequalifile;
    public String inquiryid;
    public String locationid;

    public String qualifileversionnbr;
    public Boolean staging;
    public String strategytypeid;
    public Boolean aqr;
    public String instancecd;
    public String userdefinedtransactiontxt;
    public Integer reportdatatype;
    public String industrymarketcode;
  }
  /**
   * PersonQuery Request Object
   * The PersonQuery allows someone to choose which Attributes are to be checked to identify the person/consumer
   */
  public class PersonQuery {
    public String birthdt;
    public String citynm;
    public String compositephonenbr;
    public String countrynm;
    public String firstnm;
    public String governmentnbr;
    public String identificationstatecd;
    public String identificationstatenbr;
    public String lastnm;
    public String middlenm;
    public String postalplusfourcd;
    public String statecd;
    public String streetaddresstxt;
    public String depositAmt;
    public String prevAddressMonthsNbr;
    public String prevAddressYearsNbr;
    public String prevCityNm;
    public String prevCountryCd;
    public String prevPostalPlusFourCd;
    public String prevStateCd;
    public String prevStreetAddressTxt;
    public String userdefinedrecordtxt;
  }
}