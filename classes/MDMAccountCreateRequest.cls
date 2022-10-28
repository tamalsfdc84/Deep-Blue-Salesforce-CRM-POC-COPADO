public with sharing class MDMAccountCreateRequest {
  public MDMAccountCreateRequest() {
    this.key = new Key();
    this.offcrRowid = new OffcrRowid();
    this.statCd = new StatCd();
    this.bnkCd = new BnkCd();
    this.brnchCd = new BrnchCd();
    this.prodCtgry = new ProdCtgry();
    this.prodType = new ProdType();
    this.prodSubType = new ProdSubType();
    this.preference = new Preference();
    this.partyRelationship = new PartyRelationship();
    this.Addresses = new Addresses();
    this.DebitCard =  new DebitCard();
  }

  public String rowidObject;
  public Key key;
  public String acctNo;
  public String costCntrNo;
  public String statChngDt;
  public String closeDt;
  public String boClassCode;
  public String openDt;
  public OffcrRowid offcrRowid;
  public StatCd statCd;
  public BnkCd bnkCd;
  public BrnchCd brnchCd;
  public ProdCtgry prodCtgry;
  public ProdType prodType;
  public ProdSubType prodSubType;
  public Preference Preference;
  public PartyRelationship PartyRelationship;
  public Addresses Addresses;
  public DebitCard DebitCard;

  public class Key {
    public String sourceKey;
  }

  public class OffcrRowid {
    public String offcrCd;
  }

  public class StatCd {
    public String lkpCd;
  }

  public class BnkCd {
    public String locCd;
  }

  public class BrnchCd {
    public String locCd;
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

  public class Preference {
    public Preference() {
      this.item = new List<PreferenceItem>();
    }
    public List<PreferenceItem> item;
  }

  public class PreferenceItem {
    public PreferenceItem() {
      this.prefTypCd = new PrefTypCd();
      this.statCd = new StatCd();
      this.prefVl = new PrefVl();
    }

    public PrefTypCd prefTypCd;
    public PrefVl prefVl;
    public StatCd statCd;
  }

  public class PrefVl {
    public String lkpCd;
  }

  public class PrefTypCd {
    public String prefTypCd;
  }

  public class PartyRelationship {
    public PartyRelationship() {
      this.item = new List<PartyRelationshipItem>();
    }

    public List<PartyRelationshipItem> item;
  }

  public class PartyRelationshipItem {
    public PartyRelationshipItem() {
      this.statCd = new StatCd();
      this.Party = new Party();
    }

    public String relRoleCd;
    public String relTypeCode;
    public String primCustAcctFlag;
    public String hierarchyCode;
    public String endDt;
    public String strtDt;
    public statCd statCd;
    public Party Party;
  }

  public class Party {
    public Party() {
      this.key = new key();
    }

    public String rowidObject;
    public key key;
    public String ptyTypCd;
  }

  public class Addresses {
    public Addresses() {
      this.item = new List<AddressesItem>();
    }
    public List<AddressesItem> item;
  }

  public class AddressesItem {
    public AddressesItem() {
      this.addrTypCd = new AddrTypCd();
      this.relTypCd = new RelTypCd();
      this.Address = new Address();
    }

    public AddrTypCd addrTypCd;
    public RelTypCd relTypCd;
    public Address Address;
  }

  public class AddrTypCd {
    public String addrTypCd;
  }

  public class RelTypCd {
    public String lkpCd;
  }

  public class Address {
    public Address() {
      this.cntryCd = new CntryCd();
    }

    public String addrLine1Tx;
    public String addrLine2Tx;
    public String cityNm;
    public String stateCd;
    public String zip5Cd;
    public String zip4Cd;
    public CntryCd cntryCd;
  }

  public class CntryCd {
    public String ctryCd;
  }

  public class DebitCard {
    public DebitCard(){
      this.item = new List<DebitCardItem>();
    }
    public List<DebitCardItem> item;
  }

  public class DebitCardItem {
    public DebitCardItem(){
      this.statCd = new StatCd();
      this.CardHolder = new CardHolder();
    }
    public String relTypeCode;
    public String hierarchyCode;
    public String strtDt;
    public String endDt;
    public StatCd statCd;
    public CardHolder CardHolder;
  }

  public class CardHolder{
    public CardHolder(){
      this.prodCtgry = new ProdCtgry();
      this.prodType = new ProdType();
      this.Customer = new Customer();
    }
    public String boClassCode;
    public String fiBnkNo;
    public String openDt;
    public String crdNo;
    public String endDt;
    public ProdCtgry prodCtgry;
    public ProdType prodType;
    public Customer Customer;
  }

  public class Customer{
    public Customer(){
      this.key = new Key();
    }
    public Key key;
    public String ptyTypCd;
  }
}