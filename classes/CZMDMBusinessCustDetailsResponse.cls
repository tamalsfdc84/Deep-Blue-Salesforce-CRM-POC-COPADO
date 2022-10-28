public with sharing class CZMDMBusinessCustDetailsResponse {
  public CZMDMBusinessCustDetailsResponse() {
    this.businessInfo = new BusinessInformation();
    this.accountList = new List<AccountList>();
    this.cisLst = new List<CustomerCiISRecord>();
    this.identificationDetails = new List<IdentificationDetails>();
    this.ownerList = new List<OwnerList>();
  }

  public boolean isSuccess;
  public String globalCustomerId;
  public BusinessInformation businessInfo;
  public List<AccountList> accountList;
  public List<CustomerCiISRecord> cisLst;
  public List<IdentificationDetails> identificationDetails;
  public List<OwnerList> ownerList;
  public String type;

  public class BusinessInformation {
    public String BusinessName;
    public String BusinessType;
    public String BusinessDescription;
    public String EstablishDate;
    public Boolean IsPublicTradedCompany;
    public String AddressLineOne;
    public String AddressLineTwo;
    public String City;
    public String StateCode;
    public String ZipCode;
    public String EmailId;
    public String SSN;
    public String TaxId;
    public String TaxIdType;
    public String NAICSCode;
    public String PrimaryPhone;
    public String SecondaryPhone;
    public String CellPhoneNo;
    public String InternationalPhoneNo;
    public String CISNumber;
    public String CharterCode;
    public String CISStartDate;
    public String PrimaryOficerCode;
    public String SecondaryOfficerCode;
    public String SecretWord;
    public String SecretHint;
    public String CostCenter;
    public String LocationCode;
    public Boolean IsExistingCustomer;
    public Boolean IsCrossCharterCustomer;
  }

  public class AccountList {
    public String AccountNumber;
    public String CharterCode;
    public String AccountCreationDate;
    public String AccountCategory;
    public String ProductCode;
    public String ProductName;
    public String AccountType;
    public String RelationshipCode;
    public String CharterName;
    public String relationshipName;
    public String AccountStatus;
    public String mdmPartyId;
  }

  public class IdentificationDetails {
    public String IdentificationType;
    public String IdentificationNumber;
    public String IssuingStateCode;
    public String ExpirationDate;
    public String IssueDate;
  }

  public class CustomerCiISRecord {
    public String cisNbr;
    public String charterName;
    public String cisStartDate;
    public String primaryOfrNbr;
    public String SecretWord;
    public String SecretHint;
  }

  public class OwnerList {
    public String globalCustomerId;
    public String TaxIdType;
    public String SSN;
    public String RelationshipName;
    public String RelationshipCode;
    public String OwnershipPercentage;
    public String charterName;
    public String EmailId;
    public String cisNbr;
    public String Title;
    public String OwnerPrimaryPhone;
    public String OwnerSecondaryPhone;
    public String OwnerCellPhoneNo;
    public String OwnerName;
  }
}