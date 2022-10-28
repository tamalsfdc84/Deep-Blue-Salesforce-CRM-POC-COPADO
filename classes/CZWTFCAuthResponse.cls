public with sharing class CZWTFCAuthResponse {
  public CZWTFCAuthResponse() {
    this.custInfo = new CustomerInformation();
    this.accountList = new List<AccountList>();
    this.cisLst = new List<CustomerCiISRecord>();
  }

  public boolean isSuccess;
  public String status;
  public String globalCustomerId;
  public CustomerInformation custInfo;
  public List<AccountList> accountList;
  public List<CustomerCiISRecord> cisLst;
  public String type;

  public class CustomerInformation {
    public CustomerInformation() {
      this.identificationDetails = new List<IdentificationDetails>();
    }
    public String FirstName;
    public String MiddleName;
    public String LastName;
    public String AddressLineOne;
    public String AddressLineTwo;
    public String City;
    public String State;
    public String ZipCode;
    public String Country;
    public String PrimaryPhone;
    public String SecondaryPhone;
    public String CellPhoneNo;
    public String EmailId;
    public String DateOfBirth;
    public String SSN;
    public String Citizenship;
    public String EmploymentStatusCode;
    public String OccupationCode;
    public String Title;
    public String EmployeeName;
    public String CISNumber;
    public String CharterCode;
    public String CISStartDate;
    public List<IdentificationDetails> identificationDetails;
    public boolean IsExceptionPlanRequired;
    public boolean IsDobMissing;
    public boolean IsPhoneNumberMissing;
    public boolean IsEmailIdMissing;
    public boolean IsExistingCustomer;
    public boolean IsCrossCharterCustomer;
    public boolean IsKYCRequired;
    public String Suffix;
    public boolean IsOLBEnrolled;
    public String SecretWord;
    public String SecretHint;
    public String PrimaryOficerCode;
    public String SecondaryOfficerCode;
    public String CostCenter;
    public String LocationCode;
    public Boolean IsEmployee;
    public Boolean IsFounder;
    public Boolean HasPlatinumMembership;
    public Boolean HasJuniorMembership;
    public String TaxIdType;
    public String TaxId;
  }

  public class AccountList {
    public String AccountNumber;
    public String CharterCode;
    public String AccountCreationDate;
    public String AccountCategory;
    public String ProductCode;
    public String ProductName;
    public String AccountType;
    public String OwnershipCode;
    public String RelationshipCode;
    public String AccountBalance;
    public String CharterName;
    public String relationshipName;
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
  }
}