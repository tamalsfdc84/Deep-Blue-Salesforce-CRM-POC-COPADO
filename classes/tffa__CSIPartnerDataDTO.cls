/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class CSIPartnerDataDTO {
    global List<tffa.CSIPartnerDataDTO.Account> accounts;
    global Integer activityType;
    global tffa.CSIPartnerDataDTO.AdverseAction adverseAction;
    global tffa.CSIPartnerDataDTO.Applicant applicants;
    global String applicationDate;
    global List<tffa.CSIPartnerDataDTO.Contact> contacts;
    global String digitalSignatureProvider;
    global tffa.CSIPartnerDataDTO.FinancialInstitution financialInstitution;
    global String governingLawState;
    global String institutionID;
    global Boolean isCIVDocumentRequired;
    global Boolean isCommunityProperty;
    global Boolean isElectronicDisclosures;
    global Boolean isEnablingMultipleAccountsFunctionality;
    global Boolean isMaskingPersonallyIdentifiableInformation;
    global String maintenanceEffectiveDate;
    global String notaryVenueState;
    global Integer overdraftServicesDecisionType;
    global String partnerID;
    global tffa.CSIPartnerDataDTO.TFAPlan tfaPlan;
    global String transactionDate;
    global CSIPartnerDataDTO() {

    }
    global static Map<String,Object> deserializeAsMap(String jsonString) {
        return null;
    }
    global static tffa.CSIPartnerDataDTO parse(String json) {
        return null;
    }
global class ATMDebitCard {
    global Integer cardholderStatus;
    global String cardNumber;
    global Integer cardStatus;
    global List<tffa.CSIPartnerDataDTO.LinkedAccount> linkedAccounts;
    global Integer type;
    global ATMDebitCard() {

    }
}
global class Account {
    global String accountNumber;
    global List<tffa.CSIPartnerDataDTO.AuthorizedSigner> authorizedSigners;
    global List<tffa.CSIPartnerDataDTO.Beneficiary> beneficiaries;
    global List<tffa.CSIPartnerDataDTO.BusinessSigner> businessSigners;
    global Integer compoundingFrequency;
    global Integer creditingFrequency;
    global List<String> custodians;
    global Double depositAmount;
    global String discountOrPremiumTimePeriod;
    global Integer discountOrPremiumType;
    global String earlyWithdrawalPenaltyAmount;
    global Integer earlyWithdrawalPenaltyTerm;
    global Integer earlyWithdrawalPenaltyTermType;
    global Integer earlyWithdrawalPenaltyType;
    global List<tffa.CSIPartnerDataDTO.Fiduciary> fiduciaries;
    global String firstAdditionalAccountTitle;
    global String firstSubstituteAccountTitle;
    global String ID;
    global String interestCreditedAccountDescription;
    global String interestCreditedAccountNumber;
    global Integer interestPaymentMethod;
    global Boolean isNotAutoRenewable;
    global tffa.CSIPartnerDataDTO.LockBox lockBox;
    global String maturityDate;
    global tffa.CSIPartnerDataDTO.NightDepository nightDepository;
    global Integer overdraftServicesDecisionType;
    global List<String> owners;
    global Integer ownershipStructure;
    global Integer ownershipType;
    global String primaryOwnerID;
    global String productCode;
    global String productDescription;
    global List<tffa.CSIPartnerDataDTO.Rate> rates;
    global Integer rateStructure;
    global Integer rateType;
    global tffa.CSIPartnerDataDTO.SafeDepositBox safeDepositBox;
    global String secondAdditionalAccountTitle;
    global String secondSubstituteAccountTitle;
    global tffa.CSIPartnerDataDTO.StatementMailingAddress statementMailingAddress;
    global List<tffa.CSIPartnerDataDTO.SuccessorCustodian> successorCustodians;
    global Integer term;
    global Integer termDescriptionType;
    global Integer termInMonths;
    global Integer tieredRateCalculationMethod;
    global Integer type;
    global Account() {

    }
}
global class Address {
    global String city;
    global String country;
    global Boolean isMainAccountAddress;
    global String postalCode;
    global String primaryAddressLine;
    global String secondaryAddressLine;
    global String state;
    global Address() {

    }
}
global class AdverseAction {
    global List<tffa.CSIPartnerDataDTO.AdverseActionReasons> adverseActionReasons;
    global List<String> deniedApplicants;
    global AdverseAction() {

    }
}
global class AdverseActionReasons {
    global String otherDescription;
    global Integer type;
    global AdverseActionReasons() {

    }
}
global class Applicant {
    global List<tffa.CSIPartnerDataDTO.Business> businesses;
    global List<tffa.CSIPartnerDataDTO.Individual> individuals;
    global Applicant() {

    }
}
global class AuthorizedSigner {
    global String ID;
    global Boolean isDurable;
    global String signerRelationship;
    global Integer statusType;
    global AuthorizedSigner() {

    }
}
global class Beneficiary {
    global String ID;
    global String sharePercentage;
    global Integer type;
    global Beneficiary() {

    }
}
global class Business {
    global tffa.CSIPartnerDataDTO.Address address;
    global String dba;
    global Integer documentationOnFileType;
    global String email;
    global Integer entityType;
    global String establishedCity;
    global String establishedDate;
    global String establishedState;
    global String governingBodyMeetingDate;
    global String ID;
    global Boolean isEngagesInInternetGambling;
    global Boolean isNonProfit;
    global Boolean isRevocable;
    global Boolean isTrustTINanEIN;
    global String name;
    global String natureOfBusiness;
    global Integer numberOfSignersRequired;
    global List<tffa.CSIPartnerDataDTO.ParentCompany> parentCompanies;
    global Integer priorResolutionType;
    global String resolutionCompletionDate;
    global String resolutionEffectiveDate;
    global List<tffa.CSIPartnerDataDTO.Signer> signers;
    global String tin;
    global Integer tinStatus;
    global List<tffa.CSIPartnerDataDTO.TrustPower> trustPowers;
    global Integer trustType;
    global Business() {

    }
}
global class BusinessSigner {
    global String ID;
    global BusinessSigner() {

    }
}
global class ConsumerReportingAgency {
    global tffa.CSIPartnerDataDTO.Address address;
    global Integer creditScoreValue;
    global List<String> keyFactors;
    global Integer lowerRangeValue;
    global String name;
    global String phone;
    global String reportDate;
    global Integer upperRangeValue;
    global ConsumerReportingAgency() {

    }
}
global class Contact {
    global tffa.CSIPartnerDataDTO.Address address;
    global String businessName;
    global String dob;
    global String email;
    global String entityType;
    global String firstName;
    global String ID;
    global Boolean isSigningForAccountMaintenance;
    global String lastName;
    global Long tin;
    global String title;
    global String uniqueIdentifierDescription;
    global Contact() {

    }
}
global class Contribution {
    global Integer allocatedValue;
    global Integer allocationPercent;
    global Integer allocationPercentOrAmountType;
    global Double amount;
    global String contributionAccountNumber;
    global String contributionDate;
    global String investmentDescription;
    global Boolean isCurrentYear;
    global Integer type;
    global Contribution() {

    }
}
global class DecisionOfficer {
    global String name;
    global String title;
    global DecisionOfficer() {

    }
}
global class Deputy {
    global String ID;
    global Integer statusType;
    global Deputy() {

    }
}
global class DocumentPreparer {
    global String name;
    global String title;
    global DocumentPreparer() {

    }
}
global class DocumentSigner {
    global String email;
    global String name;
    global String title;
    global DocumentSigner() {

    }
}
global class ESABeneficiary {
    global String ID;
    global Integer statusType;
    global ESABeneficiary() {

    }
}
global class ESAResponsibleIndividual {
    global String ID;
    global Integer statusType;
    global Integer type;
    global ESAResponsibleIndividual() {

    }
}
global class Employer {
    global tffa.CSIPartnerDataDTO.Address address;
    global String jobTitle;
    global String lengthOfEmploymentMonths;
    global String name;
    global Employer() {

    }
}
global class Fiduciary {
    global String ID;
    global Integer statusType;
    global Fiduciary() {

    }
}
global class FinancialInstitution {
    global tffa.CSIPartnerDataDTO.Address address;
    global tffa.CSIPartnerDataDTO.DecisionOfficer decisionOfficer;
    global tffa.CSIPartnerDataDTO.DocumentPreparer documentPreparer;
    global tffa.CSIPartnerDataDTO.DocumentSigner documentSigner;
    global String name;
    global tffa.CSIPartnerDataDTO.OpeningBranch openingBranch;
    global FinancialInstitution() {

    }
}
global class Hold {
    global Double amount;
    global Double depositAmount;
    global String itemDepositDate;
    global String itemDescription;
    global Integer itemHoldNumberOfDays;
    global Integer reason;
    global Hold() {

    }
}
global class Identification {
    global String description;
    global String expirationDate;
    global String identificationNumber;
    global String issueDate;
    global String issuer;
    global Identification() {

    }
}
global class Individual {
    global tffa.CSIPartnerDataDTO.Address address;
    global tffa.CSIPartnerDataDTO.ATMDebitCard ATMDebitCard;
    global List<String> attorneysInFact;
    global List<String> beneficiaries;
    global String capacityDescription;
    global List<tffa.CSIPartnerDataDTO.ConsumerReportingAgency> consumerReportingAgencies;
    global String countryOfCitizenship;
    global String dateOfBirth;
    global String dateOfDeath;
    global String digitalSignatureUniqueID;
    global String email;
    global List<tffa.CSIPartnerDataDTO.Employer> employers;
    global String firstName;
    global String ID;
    global List<tffa.CSIPartnerDataDTO.Identification> identifications;
    global Boolean isMinor;
    global Boolean isMinorAccountAuthorizedSigner;
    global Boolean isOFACVerified;
    global Boolean isPowerOfAttorneyDurable;
    global Boolean isSigningForAccountMaintenance;
    global String lastName;
    global Integer maritalStatus;
    global String middleName;
    global List<tffa.CSIPartnerDataDTO.OtherInformationSource> otherInformationSources;
    global List<tffa.CSIPartnerDataDTO.Phone> phones;
    global tffa.CSIPartnerDataDTO.Address physicalAddress;
    global List<tffa.CSIPartnerDataDTO.PreviousAddress> previousAddresses;
    global List<tffa.CSIPartnerDataDTO.Employer> previousEmployers;
    global String spouseID;
    global String ssn;
    global String suffixName;
    global Integer tinStatus;
    global String uniqueIdentifierDescription;
    global Individual() {

    }
}
global class Institution {
    global Integer abaRoutingNumber;
    global String city;
    global Boolean isUsingFinancialInstitutionAsDebitedInstitution;
    global String name;
    global String postalCode;
    global String primaryAddressLine;
    global String state;
    global Institution() {

    }
}
global class LinkedAccount {
    global String accountNumber;
    global String ID;
    global Integer type;
    global LinkedAccount() {

    }
}
global class LockBox {
    global Integer status;
    global LockBox() {

    }
}
global class NightDepository {
    global String accountNumber;
    global Integer numberOfKeysIssued;
    global Integer status;
    global NightDepository() {

    }
}
global class OpeningBranch {
    global tffa.CSIPartnerDataDTO.Address address;
    global String code;
    global String name;
    global String phone;
    global OpeningBranch() {

    }
}
global class OtherInformationSource {
    global tffa.CSIPartnerDataDTO.Address address;
    global String descriptionOfAdverseInformationProvided;
    global String name;
    global OtherInformationSource() {

    }
}
global class ParentCompany {
    global String capacityDescription;
    global String ID;
    global ParentCompany() {

    }
}
global class Phone {
    global String phoneNumber;
    global Integer type;
    global Phone() {

    }
}
global class PreviousAddress {
    global String city;
    global String country;
    global Integer durationAtAddressInMonths;
    global String postalCode;
    global String primaryAddressLine;
    global String state;
    global PreviousAddress() {

    }
}
global class Rate {
    global Double apy;
    global Double discountOrPremiumRate;
    global String effectiveTimePeriod;
    global Double highBalance;
    global Double interestRate;
    global Double lowApy;
    global Double lowBalance;
    global Rate() {

    }
}
global class SafeDepositBox {
    global List<String> appointees;
    global List<tffa.CSIPartnerDataDTO.Deputy> deputies;
    global Integer numberOfKeys;
    global Integer numberOfRequiredRentersToAccess;
    global String size;
    global SafeDepositBox() {

    }
}
global class Signer {
    global tffa.CSIPartnerDataDTO.Address address;
    global tffa.CSIPartnerDataDTO.ATMDebitCard ATMDebitCard;
    global String capacityDescription;
    global String dateOfBirth;
    global String email;
    global String firstName;
    global String ID;
    global Boolean isAuthorizedToRevokeTrust;
    global Boolean isBeneficialOwner;
    global Boolean isBeneficialOwnerCertifier;
    global Boolean isBeneficialOwnerManager;
    global Boolean isDocumentSigner;
    global Boolean isRemovedTrustee;
    global Boolean isResolutionCertifier;
    global Boolean isResolutionSigner;
    global Boolean isSuccessorTrustee;
    global Boolean isTINCertifier;
    global Boolean isTrustBeneficiary;
    global Boolean isTrustCreator;
    global Boolean isTrustee;
    global String lastName;
    global String middleName;
    global tffa.CSIPartnerDataDTO.Address physicalAddress;
    global String ssn;
    global String suffixName;
    global Integer tinStatus;
    global Signer() {

    }
}
global class StatementMailingAddress {
    global String city;
    global String country;
    global String postalCode;
    global String primaryAddressLine;
    global String state;
    global StatementMailingAddress() {

    }
}
global class SuccessorCustodian {
    global String ID;
    global Integer statusType;
    global SuccessorCustodian() {

    }
}
global class TFAPlan {
    global Integer activityType;
    global List<tffa.CSIPartnerDataDTO.Beneficiary> beneficiaries;
    global List<tffa.CSIPartnerDataDTO.Contribution> contributions;
    global List<tffa.CSIPartnerDataDTO.ESABeneficiary> esaBeneficiaries;
    global List<tffa.CSIPartnerDataDTO.ESAResponsibleIndividual> esaResponsibleIndividuals;
    global Boolean isInheritedIRA;
    global Boolean isOwnerSubjectToRMD;
    global Boolean isStandaloneTFAPlanWithoutDepositAccount;
    global String owner;
    global String planNumber;
    global Integer requestorType;
    global Integer transactionType;
    global Integer type;
    global TFAPlan() {

    }
}
global class TrustPower {
    global Integer type;
    global TrustPower() {

    }
}
}
