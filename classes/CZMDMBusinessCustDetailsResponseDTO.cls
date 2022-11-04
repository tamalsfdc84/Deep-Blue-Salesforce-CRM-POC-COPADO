public with sharing class CZMDMBusinessCustDetailsResponseDTO extends CZMDMResponseBaseDTO {
  public CZMDMBusinessCustDetailsResponseDTO(){
  }

  public String rowidObject;
  public String orgNm;
  public String businessType; 
  public String businessDescription;
  public String busTypDesc;
  public String busEstbDate;
  public String custDueDlgnceFg;
  public String taxIdType;
  public String taxId;
  public Addresses addresses;
  public MailingAddress mailingAddress;
  public List<PhNmb> phNmb;
  public String naicsCd;
  public String emailId;
  public List<CisDetailLst> cisDetailLst;
  public List<AcctLst> acctLst;
  public List<OwnerRcdLst> ownerRcdLst;
  public List<IdentifierLst> identifierLst;

  public class AcctLst{
    public String acctNmb;
    public String chrtrCd;
    public String acctCreationDte;
    public String acctCtgry;
    public String pdtCd;
    public String pdtNm;
    public String acctTyp;
    public String acctstatus;
    public String rltnshpCd;
  }

  public class Addresses{
    public String addrLine1Tx;
    public String addrLine2Tx;
    public String cityNm;
    public String stateNm;
    public String stateCd;
    public String zip4Cd;
    public String zip5Cd;
  }

  public class CisDetailLst{
    public String cISNmb;
    public String chrtrCd;
    public String custSinceDt;
    public String brnchCd;
    public String costCntrNo;
    public String offcrCd; 
    public String CIScndyOffcrNbr;
    public String secretWrd;
    public String secretHnt;
  }

  public class IdentifierLst{
    public String idtfrTypCd;
    public String idtfrNmb;
    public String issueStateCd;
    public String expDte;
    public String issueDte;
  }

  public class MailingAddress{
    public String addrLine1Tx;
    public String addrLine2Tx;
    public String cityNm;
    public String stateNm;
    public String stateCd;
    public String zip4Cd;
    public String zip5Cd;
  }

  public class OwnerRcdLst{
    public String rowidObject;
    public String taxIdType;
    public String taxId;
    public String relCd; 
    public String ownrPercent; 
    public String chrtrCd;
    public String emailId;
    public String cISNmb;
    public String ownrTitl;
    public List<PhNmb> Communication;
    public String ownrNm;
  }

  public class PhNmb{
    public String commcnVl;
    public String commcnTypCd;
  }
}