@SuppressWarnings('PMD.ExcessivePublicCount')
public with sharing class MDMCustomerCreateRequest {

  public MDMCustomerCreateRequest() {
      this.key = new Key();
      this.statCd = new StatCd();
      this.offcrRowid = new OffcrRowid();
      this.psptIn = new PsptIn();
      this.cntryCd = new CntryCd();
      this.bnkCd = new BnkCd();
      this.brnchCd = new BrnchCd();
      this.Details = new Details();
      this.Identifiers = new Identifiers();
      this.Communication = new Communication();
      this.Email = new Email();
      this.Addresses = new Addresses();
      this.AccountRelationship = new AccountRelationship();
    }

    public String rowidObject;
    public Key key;
    public String ptyTypCd;
    public String costCntrNo;
    public String endDt;
    public String strtDt;
    public String ptyNm;
    public String statChngDt;
    public StatCd statCd;
    public OffcrRowid offcrRowid;
    public PsptIn psptIn;
    public CntryCd cntryCd;
    public BnkCd bnkCd;
    public BrnchCd brnchCd;
    public Details Details;
    public Identifiers Identifiers;
    public Communication Communication;
    public Email Email;
    public Addresses Addresses;
    public AccountRelationship AccountRelationship;

  public class Key {
    public String sourceKey;
  }

  public class StatCd {
    public String lkpCd;
  }

  public class OffcrRowid {
    public String offcrCd;
  }

  public class PsptIn {
    public String lkpCd;
  }

  public class CntryCd {
    public String ctryCd;
  }

  public class BnkCd {
    public String locCd;
  }

  public class BrnchCd {
    public String locCd;
  }

  public class Details {
    public Details() {
      this.item = new List < DetailsItem > ();
    }

    public List < DetailsItem > item;
  }

  public class DetailsItem {
    public DetailsItem() {
      this.empIn = new EmpIn();
      this.ctznCd = new CtznCd();
      this.statCd = new StatCd();
      this.occpnCd = new OccpnCd();
    }

    public String lstNm;
    public String frstNm;
    public String birthDt;
    public EmpIn empIn;
    public CtznCd ctznCd;
    public StatCd statCd;
    public OccpnCd occpnCd;
    public String sfxVl;
    public String midNm;
  }

  public class EmpIn {
    public String lkpCd;
  }

  public class CtznCd {
    public String lkpCd;
  }

  public class OccpnCd {
    public String occpnCd;
  }

  public class Identifiers {
    public Identifiers() {
      this.item = new List < IdentifiersItem > ();
    }

    public List < IdentifiersItem > item;
  }

  public class IdentifiersItem {
    public IdentifiersItem() {
      this.idntyTypCd = new IdntyTypCd();
    }

    public String idntyCd;
    public IdntyTypCd idntyTypCd;
  }

  public class IdntyTypCd {
    public String idntyTypCd;
  }

  public class Communication {
    public Communication() {
      this.item = new List < CommunicationItem > ();
    }

    public List < CommunicationItem > item;
  }

  public class CommunicationItem {
    public CommunicationItem() {
      this.prefFg = new PrefFg();
      this.commcnTypCd = new CommcnTypCd();
    }

    public String commcnVl;
    public PrefFg prefFg;
    public CommcnTypCd commcnTypCd;
  }

  public class PrefFg {
    public String lkpCd;
  }

  public class CommcnTypCd {
    public String commcnTypCd;
  }

  public class Email {
    public Email() {
      this.item = new List < EmailItem > ();
    }

    public List < EmailItem > item;
  }

  public class EmailItem {
    public EmailItem() {
      this.emailTypCd = new EmailTypCd();
    }

    public String email;
    public EmailTypCd emailTypCd;
  }

  public class EmailTypCd {
    public String commcnTypCd;
  }

  public class Addresses {
    public Addresses() {
      this.item = new List < AddressesItem > ();
    }
    public List < AddressesItem > item;
  }

  public class AddressesItem {
    public AddressesItem() {
      this.primAddrIn = new PrimAddrIn();
      this.addrTypCd = new AddrTypCd();
      this.Address = new Address();
    }

    public PrimAddrIn primAddrIn;
    public AddrTypCd addrTypCd;
    public Address Address;
  }

  public class PrimAddrIn {
    public String lkpCd;
  }

  public class AddrTypCd {
    public String addrTypCd;
  }

  public class Address {
    public Address() {
      this.cntryCd = new CntryCd();
    }

    public String stateCd;
    public String cityNm;
    public String zip5Cd;
    public String zip4Cd;
    public String addrLine1Tx;
    public CntryCd cntryCd;
  }

  public class AccountRelationship {
    public AccountRelationship() {
      this.item = new List < AccountRelationshipItem > ();
    }

    public List < AccountRelationshipItem > item;
  }

  public class AccountRelationshipItem {
    public AccountRelationshipItem() {
      this.primCustAcctFg = new PrimCustAcctFg();
      this.statCd = new StatCd();
      this.Account = new Account();
    }

    public String relTypeCode;
    public String hierarchyCode;
    public String relRoleCd;
    public String endDt;
    public String strtDt;
    public PrimCustAcctFg primCustAcctFg;
    public StatCd statCd;
    public Account Account;
  }

  public class PrimCustAcctFg {
    public String lkpCd;
  }

  public class Account {
    public Account() {
      this.key = new Key();
      this.bnkCd = new BnkCd();
      this.brnchCd = new BrnchCd();
      this.prodCtgry = new ProdCtgry();
      this.statCd = new StatCd();
      this.prodType = new ProdType();
      this.prodSubType = new ProdSubType();
      this.AccountPreferences = new AccountPreferences();
    }

    public key key;
    public String acctNo;
    public String boClassCode;
    public String closeDate;
    public String openDate;
    public String statChngDt;
    public BnkCd bnkCd;
    public BrnchCd brnchCd;
    public ProdCtgry prodCtgry;
    public StatCd statCd;
    public ProdType prodType;
    public ProdSubType prodSubType;
    public AccountPreferences AccountPreferences;
  }

  public class ProdCtgry {
    public String prodCd;
  }

  public class ProdType {
    public String prodCd;
  }

  public class ProdSubType {
    public String prodCd;
  }

  public class AccountPreferences {
    public AccountPreferences() {
      this.item = new List < AccountPreferencesItem > ();
    }

    public List < AccountPreferencesItem > item;
  }

  public class AccountPreferencesItem{
    public AccountPreferencesItem() {
      this.prefTypCd = new PrefTypCd();
      this.prefVl = new PrefVl();
      this.statCd = new StatCd();
    }

    public PrefTypCd prefTypCd;
    public PrefVl prefVl;
    public StatCd statCd;
  }

  public class PrefTypCd {
    public String prefTypCd;
  }

  public class PrefVl {
    public String lkpCd;
  }

}