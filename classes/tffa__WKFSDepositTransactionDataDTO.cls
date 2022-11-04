/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class WKFSDepositTransactionDataDTO {
    global tffa.WKFSDepositTransactionDataDTO.Txn Txn;
    global WKFSDepositTransactionDataDTO() {

    }
    global static Map<String,Object> deserializeAsMap(String jsonString) {
        return null;
    }
    global static tffa.WKFSDepositTransactionDataDTO parse(String json) {
        return null;
    }
global class Account {
    global String AccountAgreementDate;
    global String AccountAgreementID;
    global String AccountIdentifier;
    global String AccountOpeningPreventRenewalInd;
    global String AccountPurposeType;
    global String AccountTitle;
    global String AccountType;
    global String AccountTypeDesc;
    global String AccountTypeOtherDesc;
    global String AlternateAccountAddressForeignInd;
    global String AlternateAddressCity;
    global String AlternateAddressPostalCode;
    global String AlternateAddressState;
    global String AlternateStreetAddress;
    global String AlternateStreetAddress2;
    global String APYRate;
    global String BalanceComputationType;
    global tffa.WKFSDepositTransactionDataDTO.Beneficiaries Beneficiaries;
    global String CertificateDate;
    global String CertificateOfDepositCertificateIdentifier;
    global String CertificateOfDepositCertificateType;
    global String CompoundingFrequencyType;
    global String CurrentBalanceAmount;
    global String DepositLimitationType;
    global String DisclosureTexasMultiplePartyAccountSelectionInd;
    global String DisclosureType;
    global String EarningsDetailType;
    global String EarningsType;
    global tffa.WKFSDepositTransactionDataDTO.Fees Fees;
    global String FormAdditionalPowersAuthorizedSignerAccountOKInd;
    global String FormApplicationForIRSIndividualTaxpayerIdentificationNumberW7Ind;
    global String FormIRSW9RequestForTaxpayerIdentificationNumberAndCertificationInd;
    global String FormNewAccountApplicationDesignateBeneficiariesInd;
    global String FormW9InstructionsInd;
    global String FormWireTransferInd;
    global tffa.WKFSDepositTransactionDataDTO.Holders Holders;
    global String HSAAccountIdentifier;
    global String HSAAccountInd;
    global String InitialDepositAmount;
    global String InitialDepositSourceType;
    global String InitialDepositSourceTypeOtherDesc;
    global String InitialInterestRate;
    global String InitialRateInd;
    global String InterestPaymentAccountDesc;
    global String InterestPaymentAccountIdentifier;
    global String InterestPaymentFrequencyType;
    global String InterestPaymentProcedureType;
    global String InterestRate;
    global String InterestRateType;
    global String InternalUseDesc;
    global String IRAAccountIdentifier;
    global String IRAAccountInd;
    global String MaturityDate;
    global String MinimumBalanceRequirementsInd;
    global String OverdraftConsentInd;
    global String OwnershipType;
    global String OwnershipTypeOtherDesc;
    global String PayOnDeathType;
    global String PeriodicStatementChecksInd;
    global String ProductDesc;
    global String RateDetailType;
    global String RegEOptInHolderIDRef;
    global String RenewalMaturityDate;
    global String RenewalType;
    global String SafeDepositBoxAgentsRequiredNumber;
    global String SafeDepositBoxAnnualRentAmount;
    global String SafeDepositBoxBillingAccountIdentifier;
    global String SafeDepositBoxBillingFrequencyTypeOtherDesc;
    global String SafeDepositBoxBillingPeriodicFrequencyType;
    global String SafeDepositBoxBillingType;
    global String SafeDepositBoxInitialLeaseTermsDesc;
    global String SafeDepositBoxKeysDesc;
    global String SafeDepositBoxLeaseBoxNumber;
    global String SafeDepositBoxLeaseDeputyAgentDurableInd;
    global String SafeDepositBoxLeaseDeputyAgentSpouseDurableInd;
    global String SafeDepositBoxLeaseFeesStatementInd;
    global String SafeDepositBoxLeaseType;
    global String SafeDepositBoxLeaseTypeOtherDesc;
    global String SafeDepositBoxLesseesRequiredNumber;
    global String SafeDepositBoxSecurityDepositAmount;
    global String SafeDepositBoxSizeDesc;
    global String SafeDepositBoxSpecificLeaseTermsDesc;
    global tffa.WKFSDepositTransactionDataDTO.ServicesRequested ServicesRequested;
    global String SubAccountType;
    global String TemporaryInd;
    global String TermDesc;
    global String TerminologyCertificateType;
    global String TrustAgreementDate;
    global String WithdrawalRequiredSignaturesNumber;
    global Account() {

    }
}
global class Accounts {
    global List<tffa.WKFSDepositTransactionDataDTO.Account> Account;
    global Accounts() {

    }
}
global class Agent extends tffa.WKFSDepositTransactionDataDTO.DenialNotice {
    global String AccountAddressInd;
    global String AccountsLimitDesc;
    global String AgentID;
    global String AlternateSignatureDesc;
    global String BirthDate;
    global tffa.WKFSDepositTransactionDataDTO.CustomData CustomData;
    global String DurabilityType;
    global String EmailAddress;
    global String EmployerCity;
    global String EmployerName;
    global String EmployerState;
    global String FirstName;
    global String FormPowerOfAttorneyInd;
    global String FormPowerOfAttorneyNoticePABorrowMoneyInd;
    global String FormPowerOfAttorneyNoticePADepositTransactionsInd;
    global String FormPowerOfAttorneyNoticePAPersonalPropertyInd;
    global tffa.WKFSDepositTransactionDataDTO.IdentificationItems IdentificationItems;
    global String LastName;
    global String MailingAddressCity;
    global String MailingAddressDifferentInd;
    global String MailingAddressPostalCode;
    global String MailingAddressState;
    global String MailingStreetAddress;
    global String MailingStreetAddress2;
    global String MiddleName;
    global String PermanentAddressCity;
    global String PermanentAddressPostalCode;
    global String PermanentAddressState;
    global String PermanentStreetAddress;
    global String PermanentStreetAddress2;
    global tffa.WKFSDepositTransactionDataDTO.Phones Phones;
    global String PowerOfAttorneyAgreementID;
    global String RelationshipDesc;
    global String SignInstitutionRepresentativeInd;
    global String SSN;
    global String Suffix;
    global Agent() {

    }
}
global class BeneficialOwner {
    global String AlternateLine1MailingAddress;
    global String AlternateLine1PermanentAddress;
    global String AlternateLine2MailingAddress;
    global String AlternateLine2PermanentAddress;
    global String AlternateLine3MailingAddress;
    global String AlternateLine3PermanentAddress;
    global String AlternateLine4MailingAddress;
    global String AlternateLine4PermanentAddress;
    global String AlternateLine5MailingAddress;
    global String AlternateLine5PermanentAddress;
    global String BeneficialOwnerID;
    global String BeneficialOwnershipPercent;
    global String BirthDate;
    global String EmailAddress;
    global String FormCertificationOfBeneficialOwnersCertifyingSignerInd;
    global String FormCertificationOfBeneficialOwnersControlIndividualInd;
    global String FormCertificationOfBeneficialOwnersQualifyingOwnerInd;
    global tffa.WKFSDepositTransactionDataDTO.IdentificationItems IdentificationItems;
    global String MailingAddressForeignInd;
    global String Name;
    global String NonUSPersonInd;
    global String PermanentAddressCity;
    global String PermanentAddressForeignInd;
    global String PermanentAddressPostalCode;
    global String PermanentAddressState;
    global String PermanentStreetAddress;
    global String PermanentStreetAddress2;
    global String SSN;
    global String Title;
    global BeneficialOwner() {

    }
}
global class BeneficialOwners {
    global List<tffa.WKFSDepositTransactionDataDTO.BeneficialOwner> BeneficialOwner;
    global BeneficialOwners() {

    }
}
global class Beneficiaries {
    global List<tffa.WKFSDepositTransactionDataDTO.Beneficiary> Beneficiary;
    global Beneficiaries() {

    }
}
global class Beneficiary {
    global String AllocationPercent;
    global String AlternateLine1MailingAddress;
    global String AlternateLine1PermanentAddress;
    global String AlternateLine2MailingAddress;
    global String AlternateLine2PermanentAddress;
    global String AlternateLine3PermanentAddress;
    global String AlternateLine4PermanentAddress;
    global String AlternateLine5PermanentAddress;
    global String BirthDate;
    global String BusinessName;
    global String DateOfBirth;
    global String DaytimePhoneNumber;
    global String EIN;
    global String EmailAddress;
    global String EntityType;
    global String FirstName;
    global String ID;
    global String LastName;
    global String MailingAddressCity;
    global String MailingAddressForeignInd;
    global String MailingAddressPostalCode;
    global String MailingAddressState;
    global String MailingStreetAddress;
    global String MailingStreetAddress2;
    global String MiddleName;
    global String PartyType;
    global String PermanentAddressCity;
    global String PermanentAddressPostalCode;
    global String PermanentAddressState;
    global String PermanentStreetAddress;
    global String PermanentStreetAddress2;
    global String RelationshipToOwnerDesc;
    global tffa.WKFSDepositTransactionDataDTO.Signers Signers;
    global String SSN;
    global String SuffixName;
    global String Type;
    global Beneficiary() {

    }
}
global class BusinessCardPolicies {
    global List<tffa.WKFSDepositTransactionDataDTO.BusinessCardPolicy> BusinessCardPolicy;
    global BusinessCardPolicies() {

    }
}
global class BusinessCardPolicy {
    global String NameDesc;
    global BusinessCardPolicy() {

    }
}
global class CESAResponsibleParties {
    global List<tffa.WKFSDepositTransactionDataDTO.CESAResponsibleParty> CESAResponsibleParty;
    global CESAResponsibleParties() {

    }
}
global class CESAResponsibleParty {
    global String BeneficiaryRelationshipType;
    global String BeneficiaryRelationshipTypeOtherDesc;
    global String BirthDate;
    global tffa.WKFSDepositTransactionDataDTO.CustomData CustomData;
    global String DaytimePhoneNumber;
    global String EmailAddress;
    global String EmployerCity;
    global String EmployerName;
    global String EmployerState;
    global String FirstName;
    global String ID;
    global tffa.WKFSDepositTransactionDataDTO.IdentificationItems IdentificationItems;
    global String LastName;
    global String MailingAddressCity;
    global String MailingAddressPostalCode;
    global String MailingAddressState;
    global String MailingStreetAddress;
    global String MailingStreetAddress2;
    global String MarriedInd;
    global String MiddleName;
    global String PartyType;
    global String PermanentAddressCity;
    global String PermanentAddressForeignInd;
    global String PermanentAddressPostalCode;
    global String PermanentAddressState;
    global String PermanentStreetAddress;
    global String PermanentStreetAddress2;
    global tffa.WKFSDepositTransactionDataDTO.Phones Phones;
    global String SSN;
    global String SuccessorAlternateLine1MailingAddress;
    global String SuccessorAlternateLine1PermanentAddress;
    global String SuccessorAlternateLine2MailingAddress;
    global String SuccessorAlternateLine2PermanentAddress;
    global String SuccessorBeneficiaryRelationshipType;
    global String SuccessorBeneficiaryRelationshipTypeOtherDes;
    global String SuccessorBirthDate;
    global String SuccessorDaytimePhoneNumber;
    global String SuccessorMailingAddressCity;
    global String SuccessorMailingAddressForeignInd;
    global String SuccessorMailingAddressPostalCode;
    global String SuccessorMailingAddressState;
    global String SuccessorMailingStreetAddress;
    global String SuccessorMailingStreetAddress2;
    global String SuccessorName;
    global String SuccessorPartyID;
    global String SuccessorPermanentAddressCity;
    global String SuccessorPermanentAddressForeignInd;
    global String SuccessorPermanentAddressPostalCode;
    global String SuccessorPermanentAddressState;
    global String SuccessorPermanentStreetAddress;
    global String SuccessorPermanentStreetAddress2;
    global String SuccessorSSN;
    global String Suffix;
    global CESAResponsibleParty() {

    }
}
global class Contribution {
    global String Amount;
    global String CESAContributionType;
    global String ContributionDate;
    global String DepositBasisAmount;
    global String DepositEarningsAmount;
    global String HSAContributionType;
    global String InitialContributionDate;
    global tffa.WKFSDepositTransactionDataDTO.Investments Investments;
    global String RolloverEligibleContributionInd;
    global String RolloverOnePer12MonthRuleInd;
    global String RolloverWithin60DaysOfDistributionInd;
    global String RothBeneficiaryIRAContributionType;
    global String RothConversionSourceType;
    global String RothIRAContributionType;
    global String SimpleIRAContributionType;
    global String TaxYear;
    global String TraditionalBeneficiaryIRAContributionType;
    global String TraditionalIRAContributionType;
    global String TraditionalRolloverSourceType;
    global String TransferToHSASourceType;
    global Contribution() {

    }
}
global class Contributions {
    global List<tffa.WKFSDepositTransactionDataDTO.Contribution> Contribution;
    global Contributions() {

    }
}
global class CreditBureau {
    global tffa.WKFSDepositTransactionDataDTO.CreditScores CreditScores;
    global String Type;
    global String TypeOtherDesc;
    global CreditBureau() {

    }
}
global class CreditBureaus {
    global List<tffa.WKFSDepositTransactionDataDTO.CreditBureau> CreditBureau;
    global CreditBureaus() {

    }
}
global class CreditScore {
    global String CreditScoreDate;
    global String KeyFactorsDesc;
    global String RembrandtIDRef;
    global String ScoreNumber;
    global CreditScore() {

    }
}
global class CreditScores {
    global List<tffa.WKFSDepositTransactionDataDTO.CreditScore> CreditScore;
    global CreditScores() {

    }
}
global class CustomData {
    global List<tffa.WKFSDepositTransactionDataDTO.Data> Data;
    global CustomData() {

    }
}
global class Data {
    global String CustomDataDesc;
    global String CustomDataValue;
    global Data() {

    }
}
global abstract class DenialNotice {
    global String DenialNoticeAffiliateInd;
    global String DenialNoticeConsumerReportingAgencyInd;
    global String DenialNoticeDate;
    global String DenialNoticeMissingInformationDesc;
    global String DenialNoticeMissingInformationProvidedByDate;
    global String DenialNoticePartialApprovalDesc;
    global String DenialNoticePartialRejectionDesc;
    global String DenialNoticeReasonOtherDesc;
    global String DenialNoticeRegardingDesc;
    global String DenialNoticeType;
    global String DenialNoticeTypeOtherDesc;
    global String FormW7ITINApplicationType;
    global DenialNotice() {

    }
}
global class Deposit {
    global tffa.WKFSDepositTransactionDataDTO.Accounts Accounts;
    global String AutomaticTransferInd;
    global tffa.WKFSDepositTransactionDataDTO.BusinessCardPolicies BusinessCardPolicies;
    global tffa.WKFSDepositTransactionDataDTO.ElectronicProcedureDisclosures ElectronicProcedureDisclosures;
    global tffa.WKFSDepositTransactionDataDTO.IRAPlans IRAPlans;
    global String TransactionDate;
    global Deposit() {

    }
}
global class ElectronicProcedureDisclosure {
    global String ElectronicProcedureType;
    global ElectronicProcedureDisclosure() {

    }
}
global class ElectronicProcedureDisclosures {
    global List<tffa.WKFSDepositTransactionDataDTO.ElectronicProcedureDisclosure> ElectronicProcedureDisclosure;
    global ElectronicProcedureDisclosures() {

    }
}
global class Fee {
    global String AmountDesc;
    global String FeeAmount;
    global String FeeDesc;
    global String FeeName;
    global String FeeNameType;
    global String FeeNameTypeOtherDesc;
    global String OverdraftFeeAmount;
    global String OverdraftFeeType;
    global Fee() {

    }
}
global class Fees {
    global List<tffa.WKFSDepositTransactionDataDTO.Fee> Fee;
    global Fees() {

    }
}
global class GuardianNominee {
    global String AddressCity;
    global String AddressPostalCode;
    global String AddressState;
    global String AddressStreetAddress1;
    global String AddressStreetAddress2;
    global String EmailAddress;
    global String FirstName;
    global String LastName;
    global String MiddleName;
    global String NomineeType;
    global tffa.WKFSDepositTransactionDataDTO.Phones Phones;
    global String Suffix;
    global GuardianNominee() {

    }
}
global class GuardianNominees {
    global List<tffa.WKFSDepositTransactionDataDTO.GuardianNominee> GuardianNominee;
    global GuardianNominees() {

    }
}
global class Holder extends tffa.WKFSDepositTransactionDataDTO.DenialNotice {
    global String AccountAddressInd;
    global String AgentIsSpouseInd;
    global String AlternateLine1BusinessAddress;
    global String AlternateLine1MailingAddress;
    global String AlternateLine1PermanentAddress;
    global String AlternateLine2BusinessAddress;
    global String AlternateLine2MailingAddress;
    global String AlternateLine2PermanentAddress;
    global String AlternateLine3BusinessAddress;
    global String AlternateLine3MailingAddress;
    global String AlternateLine3PermanentAddress;
    global String AlternateLine4BusinessAddress;
    global String AlternateLine4MailingAddress;
    global String AlternateLine4PermanentAddress;
    global String AlternateLine5BusinessAddress;
    global String AlternateLine5MailingAddress;
    global String AlternateLine5PermanentAddress;
    global String AuthorizationDate;
    global String AuthorizationFormRequestedInd;
    global String AuthorizationOmitLendingPowersInd;
    global Integer AuthorizationPowersGranted;
    global Integer AuthorizationPowersGrantedBorrowMoneySignaturesNumber;
    global Integer AuthorizationPowersGrantedDelegateAgentsSignaturesNumber;
    global Integer AuthorizationPowersGrantedElectronicOrPreauthorizedTransfersSignaturesNumber;
    global Integer AuthorizationPowersGrantedOpenAccountSignaturesNumber;
    global String AuthorizationPowersGrantedOtherDesc;
    global Integer AuthorizationPowersGrantedOtherSignaturesNumber;
    global Integer AuthorizationPowersGrantedOtherSupportingAgreementsSignaturesNumber;
    global Integer AuthorizationPowersGrantedSafeDepositLeaseSignaturesNumber;
    global Integer AuthorizationPowersGrantedSecurityInterestSignaturesNumber;
    global Integer AuthorizationPowersGrantedWireAgreementsSignaturesNumber;
    global Integer AuthorizationPowersGrantedWriteChecksWithdrawSignaturesNumber;
    global String AuthorizationPowersSecurityInterestSpecificDebtsDesc;
    global String AuthorizationPowersSecurityInterestType;
    global String AuthorizationSpecialLimitationsDesc;
    global String AuthorizationSpecialLimitationSpecifiedRelationshipAccountsDesc;
    global String AuthorizedSignerAdditionalPowersInd;
    global String BackupWithholdingExemptInd;
    global String BackupWithholdingNotApplicableInd;
    global String BackupWithholdingTaxIdentifierCorrectInd;
    global String BackupWithholdingTaxPayerIdentificationNumberAppliedForInd;
    global String BackupWithholdingTaxPayerIdentificationNumberInd;
    global tffa.WKFSDepositTransactionDataDTO.BeneficialOwners BeneficialOwners;
    global String BeneficiariesNamesDesc;
    global String BirthDate;
    global String BusinessAddressCity;
    global String BusinessAddressForeignInd;
    global String BusinessAddressPostalCode;
    global String BusinessAddressState;
    global String BusinessDesc;
    global String BusinessName;
    global String BusinessStreetAddress;
    global String BusinessTrustInd;
    global String CitizenshipCountryDesc;
    global String CriminalCheckOffenseInd;
    global tffa.WKFSDepositTransactionDataDTO.CustomData CustomData;
    global String CustomerID;
    global String DBAName;
    global String EIN;
    global String EmailAddress;
    global String EmployerCity;
    global String EmployerName;
    global String EmployerPostalCode;
    global String EmployerState;
    global String EmployerStreetAddress;
    global String EntityType;
    global String EntityTypeOtherDesc;
    global String EstablishedCountryDesc;
    global String EstablishedDate;
    global String EstablishedState;
    global String FirstName;
    global String ForeignAddressCity;
    global String ForeignAddressCountry;
    global String ForeignAddressPostalCode;
    global String ForeignAddressStateDesc;
    global String ForeignStreetAddress;
    global String ForeignStreetAddress2;
    global String ForeignTaxIdentifier;
    global String FormCertificationOfBeneficialOwnersNoQualifyingOwnersInd;
    global String FormCertificationOfBeneficialOwnersNotApplicableType;
    global String FormW9TaxClassificationType;
    global String GenderType;
    global String globallyTradedInd;
    global tffa.WKFSDepositTransactionDataDTO.GuardianNominees GuardianNominees;
    global String ID;
    global tffa.WKFSDepositTransactionDataDTO.IdentificationItems IdentificationItems;
    global String IncorporatedAssociationOrCooperativeInd;
    global String InternetGamblingCertificationInd;
    global String LanguageType;
    global String LastName;
    global String LegalEntityIdentifier;
    global String MailingAddressCity;
    global String MailingAddressCountry;
    global String MailingAddressDifferentInd;
    global String MailingAddressForeignInd;
    global String MailingAddressPostalCode;
    global String MailingAddressState;
    global String MailingStreetAddress;
    global String MailingStreetAddress2;
    global String MiddleName;
    global String NonProfitInd;
    global String NonUSOwnerInd;
    global String PartyType;
    global String PermanentAddressCity;
    global String PermanentAddressForeignInd;
    global String PermanentAddressPostalCode;
    global String PermanentAddressState;
    global String PermanentStreetAddress;
    global String PermanentStreetAddress2;
    global String PersonalAgentInd;
    global tffa.WKFSDepositTransactionDataDTO.Phones Phones;
    global tffa.WKFSDepositTransactionDataDTO.PowerOfAttorneyAgents PowerOfAttorneyAgents;
    global String PowerOfAttorneyDate;
    global String PowerOfAttorneySuccessor1EmailAddress;
    global String PowerOfAttorneySuccessor1FullAddress;
    global String PowerOfAttorneySuccessor1FullName;
    global String PowerOfAttorneySuccessor1ID;
    global String PowerOfAttorneySuccessor1PhoneDesc;
    global String PowerOfAttorneySuccessor2EmailAddress;
    global String PowerOfAttorneySuccessor2FullAddress;
    global String PowerOfAttorneySuccessor2FullName;
    global String PowerOfAttorneySuccessor2ID;
    global String PowerOfAttorneySuccessor2PhoneDesc;
    global String PreviousFinancialInstitutionDesc;
    global String ProvideBeneficiariesNamesInd;
    global String PubliclyTradedInd;
    global String RelationshipDesc;
    global String SafeDepositBoxLeaseDeputyAgentInd;
    global String SafeDepositBoxLeaseRelationshipDesc;
    global String SeparateCertificationInd;
    global tffa.WKFSDepositTransactionDataDTO.Signers Signers;
    global String SpouseEmailAddress;
    global String SpouseID;
    global String SpouseName;
    global String SSN;
    global tffa.WKFSDepositTransactionDataDTO.SuccessorTrustees SuccessorTrustees;
    global String Suffix;
    global String Title;
    global tffa.WKFSDepositTransactionDataDTO.Trustees Trustees;
    global String TrustGrantorName;
    global String TrustRevocableInd;
    global Holder() {

    }
}
global class Holders {
    global List<tffa.WKFSDepositTransactionDataDTO.Holder> Holder;
    global Holders() {

    }
}
global class IRAPlan {
    global tffa.WKFSDepositTransactionDataDTO.Beneficiaries Beneficiaries;
    global tffa.WKFSDepositTransactionDataDTO.CESAResponsibleParties CESAResponsibleParties;
    global tffa.WKFSDepositTransactionDataDTO.Contributions Contributions;
    global String DecedentBeneficiaryDeathDate;
    global String DecedentsBirthDate;
    global String DecedentsDeathDate;
    global String DecedentsDeathPriorToRequiredBeginningDateInd;
    global String DecedentsFirstName;
    global String DecedentsLastName;
    global String DecedentsMiddleName;
    global String DecedentSpouseInd;
    global String DecedentsSSN;
    global String DecedentsSuffix;
    global String DepositInvestmentOnlyInd;
    global String EmployerBusinessName;
    global String EmployerDaytimePhoneNumber;
    global String EmployerEIN;
    global String EmployerEmailAddress;
    global String EmployerEntityType;
    global String EmployerFirstName;
    global String EmployerID;
    global String EmployerLastName;
    global String EmployerMailingAddressCity;
    global String EmployerMailingAddressPostalCode;
    global String EmployerMailingAddressState;
    global String EmployerMailingStreetAddress;
    global String EmployerMailingStreetAddress2;
    global String EmployerMiddleName;
    global String EmployerPartyType;
    global String EmployerPlanAdministratorDaytimePhoneNumber;
    global String EmployerPlanAdministratorID;
    global String EmployerPlanAdministratorMailingAddressCity;
    global String EmployerPlanAdministratorMailingAddressPostalCode;
    global String EmployerPlanAdministratorMailingAddressState;
    global String EmployerPlanAdministratorMailingStreetAddress;
    global String EmployerPlanAdministratorMailingStreetAddress2;
    global String EmployerPlanAdministratorName;
    global String EmployerPlanName;
    global String EmployerPlanSEPIncludesAllResidentAliensInd;
    global String EmployerPlanSEPIncludesCollectiveBargainingInd;
    global String EmployerPlanSEPIncludesCompensationUnder450Ind;
    global String EmployerPlanSEPRequiredFinancialInstitutionInd;
    global String EmployerPlanSEPRequirementAge;
    global String EmployerPlanSEPServiceYears;
    global String EmployerSignerAlternateSignatureDesc;
    global String EmployerSignerEmailAddress;
    global String EmployerSignerID;
    global String EmployerSignerName;
    global String EmployerSignerTitle;
    global String EmployerSSN;
    global String EmployerSuffix;
    global String ExistingPlanInd;
    global String FormCESADesignationOfSuccessorResponsibleIndividualInd;
    global String HealthInsurancePlanCoverageType;
    global String Identifier;
    global String InitialContributionDate;
    global tffa.WKFSDepositTransactionDataDTO.Owners Owners;
    global tffa.WKFSDepositTransactionDataDTO.Requests Requests;
    global String SelfDirectedInd;
    global String SpousalConsentInd;
    global String Type;
    global IRAPlan() {

    }
}
global class IRAPlans {
    global List<tffa.WKFSDepositTransactionDataDTO.IRAPlan> IRAPlan;
    global IRAPlans() {

    }
}
global class IdentificationItem {
    global String IdentificationExpirationDate;
    global String IdentificationIssuedDate;
    global String IdentificationNumberVerifiedDate;
    global String IdentificationType;
    global String IdentificationTypeOtherDesc;
    global String Identifier;
    global String IssuedByType;
    global String IssuedByTypeOtherDesc;
    global IdentificationItem() {

    }
}
global class IdentificationItems {
    global List<tffa.WKFSDepositTransactionDataDTO.IdentificationItem> IdentificationItem;
    global IdentificationItems() {

    }
}
global class Investment {
    global String Amount;
    global String DeliveryFormType;
    global String Identifier;
    global String InvestmentDesc;
    global String NonDepositInvestmentIndicator;
    global String RequestDate;
    global Investment() {

    }
}
global class Investments {
    global List<tffa.WKFSDepositTransactionDataDTO.Investment> Investment;
    global Investments() {

    }
}
global class Owner {
    global String AlternateLine1MailingAddress;
    global String AlternateLine1PermanentAddress;
    global String AlternateLine2MailingAddress;
    global String AlternateLine2PermanentAddress;
    global tffa.WKFSDepositTransactionDataDTO.BeneficialOwners BeneficialOwners;
    global String BirthDate;
    global String BusinessName;
    global String BusinessTrustInd;
    global tffa.WKFSDepositTransactionDataDTO.CustomData CustomData;
    global String DaytimePhoneNumber;
    global String DesignatedBeneficiaryBecomeResponsibleIndividualInd;
    global String EmailAddress;
    global String EmployerCity;
    global String EmployerName;
    global String EmployerState;
    global String EntityType;
    global String FirstName;
    global String FormCertificationOfBeneficialOwnersNoQualifyingOwnersInd;
    global String FormCertificationOfBeneficialOwnersNotApplicableType;
    global String globallyTradedInd;
    global String ID;
    global tffa.WKFSDepositTransactionDataDTO.IdentificationItems IdentificationItems;
    global String IncorporatedAssociationOrCooperativeInd;
    global String InitialContributionYearAgeNumber;
    global String LastName;
    global String MailingAddressCity;
    global String MailingAddressPostalCode;
    global String MailingAddressState;
    global String MailingStreetAddress;
    global String MailingStreetAddress2;
    global String MarriedInd;
    global String MiddleName;
    global String NonProfitInd;
    global String NonUSOwnerInd;
    global String NonUSPersonInd;
    global String PartyType;
    global String PermanentAddressCity;
    global String PermanentAddressPostalCode;
    global String PermanentAddressState;
    global String PermanentStreetAddress;
    global String PermanentStreetAddress2;
    global tffa.WKFSDepositTransactionDataDTO.Phones Phones;
    global String PubliclyTradedInd;
    global tffa.WKFSDepositTransactionDataDTO.Signers Signers;
    global String SpouseEmailAddress;
    global String SpouseID;
    global String SpouseName;
    global String SSN;
    global Owner() {

    }
}
global class Owners {
    global List<tffa.WKFSDepositTransactionDataDTO.Owner> Owner;
    global Owners() {

    }
}
global class Phone {
    global String Description;
    global String PhoneNumber;
    global String PrimaryPhoneInd;
    global Phone() {

    }
}
global class Phones {
    global List<tffa.WKFSDepositTransactionDataDTO.Phone> Phone;
    global Phones() {

    }
}
global class PowerOfAttorneyAgents {
    global List<tffa.WKFSDepositTransactionDataDTO.Agent> Agent;
    global PowerOfAttorneyAgents() {

    }
}
global class Request {
    global String ContributionPlusEarningsAmount;
    global String DeliveryPayableDesc;
    global tffa.WKFSDepositTransactionDataDTO.Investments Investments;
    global String PaymentAmountType;
    global String PaymentType;
    global String PaymentTypeOtherDesc;
    global String RequestType;
    global String TransferorAccountIdentifier;
    global String TransferorDaytimePhoneNumber;
    global String TransferorFullName;
    global String TransferorMailingAddressCity;
    global String TransferorMailingAddressPostalCode;
    global String TransferorMailingAddressState;
    global String TransferorMailingStreetAddress;
    global String TransferToHSASourceType;
    global Request() {

    }
}
global class Requests {
    global List<tffa.WKFSDepositTransactionDataDTO.Request> Request;
    global Requests() {

    }
}
global class ServiceRequested {
    global String CardsRequestedNumber;
    global String CardUpdateServiceCardholderOptOutInd;
    global String CardUpdateServiceOptOutOtherRequiredInformationDesc;
    global String HolderIdRefs;
    global String SignerIDRefs;
    global String Type;
    global String TypeOtherDesc;
    global ServiceRequested() {

    }
}
global class ServicesRequested {
    global List<tffa.WKFSDepositTransactionDataDTO.ServiceRequested> ServiceRequested;
    global ServicesRequested() {

    }
}
global class Signer extends tffa.WKFSDepositTransactionDataDTO.DenialNotice {
    global String AccountAddressInd;
    global String AlternateLine1MailingAddress;
    global String AlternateLine1PermanentAddress;
    global String AlternateLine2MailingAddress;
    global String AlternateLine2PermanentAddress;
    global String AlternateLine3MailingAddress;
    global String AlternateLine3PermanentAddress;
    global String AlternateLine4MailingAddress;
    global String AlternateLine4PermanentAddress;
    global String AlternateLine5MailingAddress;
    global String AlternateLine5PermanentAddress;
    global String AuthorizationAttestSignatureInd;
    global String AuthorizationPowersGrantedAcknowledgeReceiptOfFundsInd;
    global String AuthorizationPowersGrantedAmendAgreementsInd;
    global String AuthorizationPowersGrantedBorrowMoneyInd;
    global String AuthorizationPowersGrantedDelegateAdditionalAgentsInd;
    global String AuthorizationPowersGrantedElectronicOrPreauthorizedTransfersInd;
    global String AuthorizationPowersGrantedEndorseChecksInd;
    global String AuthorizationPowersGrantedOpenAccountInd;
    global String AuthorizationPowersGrantedOtherInd;
    global String AuthorizationPowersGrantedOtherSupportingAgreementsInd;
    global String AuthorizationPowersGrantedSafeDepositLeaseInd;
    global String AuthorizationPowersGrantedWireAgreementsInd;
    global String AuthorizationPowersGrantedWriteChecksWithdrawInd;
    global String AuthorizationPowersNoneOmitFromAgentListInd;
    global String AuthorizationPowersSecurityInterestInd;
    global String AuthorizationSignerInd;
    global String BeneficialOwnershipPercent;
    global String BirthDate;
    global tffa.WKFSDepositTransactionDataDTO.CustomData CustomData;
    global String EmailAddress;
    global String EmployeeReferenceInd;
    global String EmployerCity;
    global String EmployerName;
    global String EmployerPostalCode;
    global String EmployerState;
    global String EmployerStreetAddress;
    global String FormCertificationOfBeneficialOwnersCertifyingSignerInd;
    global String FormCertificationOfBeneficialOwnersControlIndividualInd;
    global String FormCertificationOfBeneficialOwnersNoQualifyingOwnersInd;
    global String FormCertificationOfBeneficialOwnersQualifyingOwnerInd;
    global tffa.WKFSDepositTransactionDataDTO.IdentificationItems IdentificationItems;
    global String MailingAddressCity;
    global String MailingAddressDifferentInd;
    global String MailingAddressForeignInd;
    global String MailingAddressPostalCode;
    global String MailingAddressState;
    global String MailingStreetAddress;
    global String MailingStreetAddress2;
    global String Name;
    global String NonUSPersonInd;
    global String PermanentAddressCity;
    global String PermanentAddressForeignInd;
    global String PermanentAddressPostalCode;
    global String PermanentAddressState;
    global String PermanentStreetAddress;
    global String PermanentStreetAddress2;
    global tffa.WKFSDepositTransactionDataDTO.Phones Phones;
    global String PreviousFinancialInstitutionDesc;
    global String RelationshipDesc;
    global String Selected;
    global String SignerID;
    global String SSN;
    global String SupressSignatureInd;
    global String TINCertifierInd;
    global String Title;
    global Signer() {

    }
}
global class Signers {
    global List<tffa.WKFSDepositTransactionDataDTO.Signer> Signer;
    global Signers() {

    }
}
global class SuccessorTrustee {
    global String AddressDesc;
    global String Name;
    global SuccessorTrustee() {

    }
}
global class SuccessorTrustees {
    global List<tffa.WKFSDepositTransactionDataDTO.SuccessorTrustee> SuccessorTrustee;
    global SuccessorTrustees() {

    }
}
global class Trustee {
    global String EmailAddress;
    global String ID;
    global String TINCertifierInd;
    global String TrusteeName;
    global Trustee() {

    }
}
global class Trustees {
    global List<tffa.WKFSDepositTransactionDataDTO.Trustee> Trustee;
    global Trustees() {

    }
}
global class Txn {
    global tffa.WKFSDepositTransactionDataDTO.CreditBureaus CreditBureaus;
    global tffa.WKFSDepositTransactionDataDTO.Deposit Deposit;
    global String ExecutionCity;
    global String ExecutionCounty;
    global String ExecutionState;
    global String OrgJurisdiction;
    global String OrgLegalName;
    global String ResponsiblePartyEmailAddress;
    global String ResponsiblePartyPhoneDesc;
    global String ResponsiblePartyUserName;
    global String ResponsiblePartyUserRembrandtID;
    global String ResponsiblePartyUserTitle;
    global String WitnessAddressCity;
    global String WitnessAddressPostalCode;
    global String WitnessAddressState;
    global String WitnessEmailAddress;
    global String WitnessFullName;
    global String WitnessID;
    global String WitnessPhoneNumber;
    global String WitnessStreetAddress;
    global String WitnessStreetAddress2;
    global Txn() {

    }
}
}
