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
    public Preference(){
      this.item = new List < PreferenceItem >();
    }
    public List < PreferenceItem > item;
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

  public class PrefVl{
    public String lkpCd;
  }

  public class PrefTypCd {
    public String prefTypCd;
  }

  public class PartyRelationship{
    public PartyRelationship(){
      this.item = new List < PartyRelationshipItem >();
    }

    public List < PartyRelationshipItem > item;
  }

  public class PartyRelationshipItem{
    public PartyRelationshipItem(){
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

  public class Party{
    public Party(){
      this.key = new key();
    }

    public String rowidObject;
    public key key;
    public String ptyTypCd;
  }

}