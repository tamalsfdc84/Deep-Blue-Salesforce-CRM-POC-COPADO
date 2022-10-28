/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class DNBFirmographicsDTO {
    global DNBFirmographicsDTO() {

    }
global class AccountantDetails extends tffa.DNBFirmographicsDTO.BaseDTO {
    global List<tffa.DNBFirmographicsDTO.IndividualNameType> AccountantName;
    global List<tffa.DNBFirmographicsDTO.AccountantOpinion> AccountantOpinion;
    global AccountantDetails() {

    }
}
global class AccountantOpinion extends tffa.DNBFirmographicsDTO.BaseDTO {
    global String Text;
    global AccountantOpinion() {

    }
}
global class ActivitiesAndOperations extends tffa.DNBFirmographicsDTO.BaseDTO {
    global tffa.DNBFirmographicsDTO.ExportDetailsType ExportDetails;
    global tffa.DNBFirmographicsDTO.ImportDetailsType ImportDetails;
    global List<tffa.DNBFirmographicsDTO.LineOfBusinessDetailsType> LineOfBusinessDetails;
    global List<String> OperationsText;
    global String PrimarySICCategoryValue;
    global tffa.DNBFirmographicsDTO.SubjectIsAgentDetailsType SubjectIsAgentDetails;
    global ActivitiesAndOperations() {

    }
}
global class AirportConcessionDisadvantagedBusinessEnterpriseDetail extends tffa.DNBFirmographicsDTO.BaseDTO {
    global tffa.DNBFirmographicsDTO.DNBDateType CertificationExpirationDate;
    global String CertificationReferenceIdentifier;
    global tffa.DNBFirmographicsDTO.DNBDateType CertificationStartDate;
    global tffa.DNBFirmographicsDTO.DataProviderDetailForAirportConcession DataProviderDetail;
    global tffa.DNBFirmographicsDTO.DNBDateType DNBReceivedDate;
    global AirportConcessionDisadvantagedBusinessEnterpriseDetail() {

    }
}
global class AmountType extends tffa.DNBFirmographicsDTO.BaseDTO {
    global String CurrencyISOAlpha3Code;
    global String ReliabilityText;
    global String UnitOfSize;
    global Decimal Value;
    global AmountType() {

    }
}
global class ArchiveDetail extends tffa.DNBFirmographicsDTO.BaseDTO {
    global Boolean ArchiveProductOptOutIndicator;
    global Boolean ExtendArchivePeriodIndicator;
    global Long PortfolioAssetContainerID;
    global ArchiveDetail() {

    }
}
global class Assessment extends tffa.DNBFirmographicsDTO.BaseDTO {
    global List<tffa.DNBFirmographicsDTO.CommercialCreditScoreType> CommercialCreditScore;
    global tffa.DNBFirmographicsDTO.DNBDecodedStringType HistoryRatingText;
    global Integer MarketingSegmentationClusterValue;
    global Integer ProofOfRightCount;
    global tffa.DNBFirmographicsDTO.USPatriotActComplianceRiskScore USPatriotActComplianceRiskScore;
    global Assessment() {

    }
}
global class AssetArticleSummary extends tffa.DNBFirmographicsDTO.BaseDTO {
    global Integer AssetArticleQuantity;
    global tffa.DNBFirmographicsDTO.DNBDecodedStringType AssetClassText;
    global tffa.DNBFirmographicsDTO.DNBDecodedStringType AssetTypeText;
    global AssetArticleSummary() {

    }
}
global virtual class Association extends tffa.DNBFirmographicsDTO.BaseDTO {
    global Association() {

    }
}
global class Bank extends tffa.DNBFirmographicsDTO.BaseDTO {
    global tffa.DNBFirmographicsDTO.OrganizationName OrganizationName;
    global Bank() {

    }
}
global class Banking extends tffa.DNBFirmographicsDTO.BaseDTO {
    global List<tffa.DNBFirmographicsDTO.Bank> Bank;
    global Banking() {

    }
}
global virtual class BaseAddressType extends tffa.DNBFirmographicsDTO.SimpleAddress {
    global List<tffa.DNBFirmographicsDTO.SubjectAddressUsageTenureDetail> AddressUsageTenureDetail;
    global String CountryGroupName;
    global String CountryOfficialName;
    global String CountyOfficialName;
    global Integer CountyWorldBaseCode;
    global tffa.DNBFirmographicsDTO.DNBDecodedStringType GeographicalPrecisionText;
    global Decimal LatitudeMeasurement;
    global Decimal LongitudeMeasurement;
    global List<String> MetropolitanStatisticalAreaUSCensusCode;
    global String MinorTownName;
    global String PostalCode;
    global List<tffa.DNBFirmographicsDTO.PremisesDetail> PremisesDetail;
    global List<tffa.DNBFirmographicsDTO.PremisesUsageDetail> PremisesUsageDetail;
    global Integer PrimaryTownWorldBaseCode;
    global String TerritoryAbbreviatedName;
    global String TerritoryName;
    global String TerritoryOfficialName;
    global Integer TerritoryWorldBaseCode;
    global Boolean UndeliverableIndicator;
    global BaseAddressType() {

    }
}
global class BaseBalanceSheetType extends tffa.DNBFirmographicsDTO.BaseDTO {
    global tffa.DNBFirmographicsDTO.Liabilities Liabilities;
    global tffa.DNBFirmographicsDTO.FinancialAmountType TotalAssetsAmount;
    global BaseBalanceSheetType() {

    }
}
global abstract class BaseDTO extends tffa.AbstractDTO {
    global BaseDTO() {

    }
}
global class BaseProfitAndLossStatementType extends tffa.DNBFirmographicsDTO.BaseDTO {
    global List<tffa.DNBFirmographicsDTO.StatementItem> StatementItem;
    global BaseProfitAndLossStatementType() {

    }
}
global class BusinessTrading extends tffa.DNBFirmographicsDTO.BaseDTO {
    global tffa.DNBFirmographicsDTO.Purchaser Purchaser;
    global BusinessTrading() {

    }
}
global class CertifiedSmallBusinessDetail extends tffa.DNBFirmographicsDTO.BaseDTO {
    global tffa.DNBFirmographicsDTO.DNBDateType CertificationExpirationDate;
    global String CertificationReferenceIdentifier;
    global tffa.DNBFirmographicsDTO.DNBDateType CertificationStartDate;
    global tffa.DNBFirmographicsDTO.DataProviderDetail DataProviderDetail;
    global tffa.DNBFirmographicsDTO.DNBDateType DNBReceivedDate;
    global CertifiedSmallBusinessDetail() {

    }
}
global class CommercialCreditScoreType extends tffa.DNBFirmographicsDTO.ScoreType {
    global CommercialCreditScoreType() {

    }
}
global class ComparedToFinancialStatementHeaderForGrowthRate extends tffa.DNBFirmographicsDTO.BaseDTO {
    global tffa.DNBFirmographicsDTO.DNBDateType FinancialStatementFromDate;
    global tffa.DNBFirmographicsDTO.DNBDateType FinancialStatementToDate;
    global tffa.DNBFirmographicsDTO.DNBDecodedStringType TimePeriodText;
    global ComparedToFinancialStatementHeaderForGrowthRate() {

    }
}
global class Compensation extends tffa.DNBFirmographicsDTO.BaseDTO {
    global tffa.DNBFirmographicsDTO.DNBDateType CompensationDate;
    global List<tffa.DNBFirmographicsDTO.CompensationDetail> CompensationDetail;
    global Compensation() {

    }
}
global class CompensationDetail extends tffa.DNBFirmographicsDTO.BaseDTO {
    global tffa.DNBFirmographicsDTO.AmountType CompensationAmount;
    global tffa.DNBFirmographicsDTO.DNBDecodedStringType CompensationTypeText;
    global CompensationDetail() {

    }
}
global class Competitor extends tffa.DNBFirmographicsDTO.BaseDTO {
    global Long IndividualEmployeeQuantity;
    global tffa.DNBFirmographicsDTO.AmountType IssuedShareCapitalAmount;
    global List<tffa.DNBFirmographicsDTO.OrganizationPrimaryNameType> OrganizationPrimaryName;
    global List<tffa.DNBFirmographicsDTO.AmountType> SalesRevenueAmount;
    global Competitor() {

    }
}
global class Competitors extends tffa.DNBFirmographicsDTO.BaseDTO {
    global List<tffa.DNBFirmographicsDTO.Competitor> Competitor;
    global Competitors() {

    }
}
global class CurrentManagementResponsibility extends tffa.DNBFirmographicsDTO.BaseDTO {
    global Integer DisplaySequence;
    global tffa.DNBFirmographicsDTO.ManagementResponsibilityText ManagementResponsibilityText;
    global tffa.DNBFirmographicsDTO.DNBDateType StartDate;
    global CurrentManagementResponsibility() {

    }
}
global class CurrentPaydexScoreType extends tffa.DNBFirmographicsDTO.BaseDTO {
    global List<tffa.DNBFirmographicsDTO.PaydexScoreType> GlobalPaydex;
    global List<tffa.DNBFirmographicsDTO.PaydexScoreType> TwentyFourMonthsPaydex;
    global CurrentPaydexScoreType() {

    }
}
global class DNBDateType extends tffa.DNBFirmographicsDTO.BaseDTO {
    global Integer DatePrecisionDNBCodeTableNumber;
    global Integer DatePrecisionDNBCodeValue;
    global String DatePrecisionText;
    global String Value;
    global DNBDateType() {

    }
}
global class DNBDecodedStringType extends tffa.DNBFirmographicsDTO.BaseDTO {
    global Integer DNBCodeTableNumber;
    global Integer DNBCodeValue;
    global String Value;
    global DNBDecodedStringType() {

    }
}
global class DNBStringType extends tffa.DNBFirmographicsDTO.BaseDTO {
    global Integer LanguageCode;
    global String Value;
    global String WritingScriptISOAlpha4Code;
    global DNBStringType() {

    }
}
global virtual class DNBStringType256 extends tffa.DNBFirmographicsDTO.BaseDTO {
    global Integer LanguageCode;
    global String Value;
    global String WritingScriptISOAlpha4Code;
    global DNBStringType256() {

    }
}
global class DataProviderDetail extends tffa.DNBFirmographicsDTO.BaseDTO {
    global Boolean CertifyingIndicator;
    global tffa.DNBFirmographicsDTO.DNBDecodedStringType DataProviderTypeText;
    global String DiversityDNBDataProviderName;
    global Boolean VerifyingIndicator;
    global DataProviderDetail() {

    }
}
global class DataProviderDetailForAirportConcession extends tffa.DNBFirmographicsDTO.BaseDTO {
    global Boolean CertifyingIndicator;
    global tffa.DNBFirmographicsDTO.DNBDecodedStringType DataProviderTypeText;
    global String DiversityDNBDataProviderName;
    global tffa.DNBFirmographicsDTO.LocationDetailForAirportConcession Location;
    global Boolean VerifyingIndicator;
    global DataProviderDetailForAirportConcession() {

    }
}
global class DebarmentsInformation extends tffa.DNBFirmographicsDTO.BaseDTO {
    global tffa.DNBFirmographicsDTO.DebarmentsSummaryType DebarmentsSummary;
    global DebarmentsInformation() {

    }
}
global class DebarmentsSummaryType extends tffa.DNBFirmographicsDTO.LegalEventSummaryType {
    global DebarmentsSummaryType() {

    }
}
global class EmployeeCategoryDetails extends tffa.DNBFirmographicsDTO.BaseDTO {
    global tffa.DNBFirmographicsDTO.DNBDecodedStringType EmployeeBasisText;
    global EmployeeCategoryDetails() {

    }
}
global class EmployeeDetailsType extends tffa.DNBFirmographicsDTO.BaseDTO {
    global List<tffa.DNBFirmographicsDTO.EmployeeCategoryDetails> EmployeeCategoryDetails;
    global tffa.DNBFirmographicsDTO.DNBDateType EmployeeFiguresDate;
    global tffa.DNBFirmographicsDTO.DNBDecodedStringType ReliabilityText;
    global Long TotalEmployeeQuantity;
    global EmployeeDetailsType() {

    }
}
global class EmployeeFigures extends tffa.DNBFirmographicsDTO.BaseDTO {
    global tffa.DNBFirmographicsDTO.EmployeeDetailsType ConsolidatedEmployeeDetails;
    global List<tffa.DNBFirmographicsDTO.EmployeeDetailsType> ConsolidatedEmployeeDetailsHistory;
    global tffa.DNBFirmographicsDTO.EmployeeDetailsType GroupEmployeeDetails;
    global tffa.DNBFirmographicsDTO.EmployeeDetailsType IndividualEntityEmployeeDetails;
    global List<tffa.DNBFirmographicsDTO.EmployeeDetailsType> IndividualEntityEmployeeDetailsHistory;
    global EmployeeFigures() {

    }
}
global class EmploymentBiography extends tffa.DNBFirmographicsDTO.BaseDTO {
    global String EmploymentBiographyText;
    global String NonSpecificSourceText;
    global EmploymentBiography() {

    }
}
global class Events extends tffa.DNBFirmographicsDTO.BaseDTO {
    global Boolean FinancialOrLegalOrSpecialEventsIndicator;
    global tffa.DNBFirmographicsDTO.FinancingEvents FinancingEvents;
    global tffa.DNBFirmographicsDTO.LegalEvents LegalEvents;
    global Boolean OperationalSpecialEventsIndicator;
    global Boolean OtherSpecialEventsIndicator;
    global tffa.DNBFirmographicsDTO.PublicFilingHeaderType PublicFilingHeader;
    global tffa.DNBFirmographicsDTO.SignificantEvents SignificantEvents;
    global Events() {

    }
}
global class ExportDetailsType extends tffa.DNBFirmographicsDTO.BaseDTO {
    global Boolean ExportIndicator;
    global ExportDetailsType() {

    }
}
global virtual class FamilyTreeAssociation extends tffa.DNBFirmographicsDTO.Association {
    global FamilyTreeAssociation() {

    }
}
global class FamilyTreeMemberRole extends tffa.DNBFirmographicsDTO.Role {
    global tffa.DNBFirmographicsDTO.DNBDecodedStringType FamilyTreeMemberRoleText;
    global FamilyTreeMemberRole() {

    }
}
global class Financial extends tffa.DNBFirmographicsDTO.BaseDTO {
    global List<tffa.DNBFirmographicsDTO.FinancialStatement> FinancialStatement;
    global List<tffa.DNBFirmographicsDTO.GrowthRates> GrowthRates;
    global List<tffa.DNBFirmographicsDTO.KeyFinancialFiguresOverview> KeyFinancialFiguresOverview;
    global Financial() {

    }
}
global class FinancialAmountType extends tffa.DNBFirmographicsDTO.BaseDTO {
    global String CurrencyISOAlpha3Code;
    global Integer DNBCodeTableNumber;
    global Integer DNBCodeValue;
    global String ExternalCodingSchemeTypeText;
    global String ExternalCodingSchemeValue;
    global String ReliabilityText;
    global String UnitOfSize;
    global Decimal Value;
    global FinancialAmountType() {

    }
}
global class FinancialAssetArticle extends tffa.DNBFirmographicsDTO.BaseDTO {
    global List<tffa.DNBFirmographicsDTO.AssetArticleSummary> AssetArticleSummary;
    global FinancialAssetArticle() {

    }
}
global class FinancialRatioCategory extends tffa.DNBFirmographicsDTO.BaseDTO {
    global List<tffa.DNBFirmographicsDTO.FinancialRatioItem> FinancialRatioItem;
    global FinancialRatioCategory() {

    }
}
global class FinancialRatioItem extends tffa.DNBFirmographicsDTO.BaseDTO {
    global tffa.DNBFirmographicsDTO.DNBDecodedStringType ItemDescriptionText;
    global Decimal ItemRatio;
    global FinancialRatioItem() {

    }
}
global class FinancialRatios extends tffa.DNBFirmographicsDTO.BaseDTO {
    global List<tffa.DNBFirmographicsDTO.FinancialRatioCategory> FinancialRatioCategory;
    global FinancialRatios() {

    }
}
global class FinancialStatement extends tffa.DNBFirmographicsDTO.BaseDTO {
    global List<tffa.DNBFirmographicsDTO.AccountantDetails> AccountantDetails;
    global tffa.DNBFirmographicsDTO.BaseBalanceSheetType BalanceSheet;
    global tffa.DNBFirmographicsDTO.FinancialRatios FinancialRatios;
    global tffa.DNBFirmographicsDTO.BaseProfitAndLossStatementType ProfitAndLossStatement;
    global tffa.DNBFirmographicsDTO.StatementHeaderDetails StatementHeaderDetails;
    global FinancialStatement() {

    }
}
global class FinancialStatementHeaderGrowthRate extends tffa.DNBFirmographicsDTO.BaseDTO {
    global tffa.DNBFirmographicsDTO.DNBDateType FinancialStatementFromDate;
    global tffa.DNBFirmographicsDTO.DNBDateType FinancialStatementToDate;
    global tffa.DNBFirmographicsDTO.DNBDecodedStringType TimePeriodText;
    global FinancialStatementHeaderGrowthRate() {

    }
}
global class FinancingEvents extends tffa.DNBFirmographicsDTO.BaseDTO {
    global Boolean SecuredFilingsIndicator;
    global FinancingEvents() {

    }
}
global class FormerOrganizationPrimaryNameType extends tffa.DNBFirmographicsDTO.OrganizationPrimaryNameType {
    global tffa.DNBFirmographicsDTO.DNBDateType EndDate;
    global tffa.DNBFirmographicsDTO.DNBDateType EndedByDate;
    global FormerOrganizationPrimaryNameType() {

    }
}
global class FullName extends tffa.DNBFirmographicsDTO.BaseDTO {
    global String FormatText;
    global String Value;
    global FullName() {

    }
}
global class GrowthRateItem extends tffa.DNBFirmographicsDTO.BaseDTO {
    global tffa.DNBFirmographicsDTO.DNBDecodedStringType ItemDescriptionText;
    global Decimal ItemRate;
    global GrowthRateItem() {

    }
}
global class GrowthRates extends tffa.DNBFirmographicsDTO.BaseDTO {
    global tffa.DNBFirmographicsDTO.ComparedToFinancialStatementHeaderForGrowthRate ComparedToFinancialStatementHeader;
    global tffa.DNBFirmographicsDTO.DNBDateType ComparisonFromDate;
    global tffa.DNBFirmographicsDTO.DNBDateType ComparisonToDate;
    global tffa.DNBFirmographicsDTO.FinancialStatementHeaderGrowthRate FinancialStatementHeader;
    global List<tffa.DNBFirmographicsDTO.GrowthRateItem> GrowthRateItem;
    global GrowthRates() {

    }
}
global class ImportDetailsType extends tffa.DNBFirmographicsDTO.BaseDTO {
    global Boolean ImportIndicator;
    global ImportDetailsType() {

    }
}
global class IndividualNameType extends tffa.DNBFirmographicsDTO.SubjectName {
    global String FirstName;
    global tffa.DNBFirmographicsDTO.FullName FullName;
    global String LastName;
    global String MiddleName;
    global List<tffa.DNBFirmographicsDTO.NamePrefix> NamePrefix;
    global List<tffa.DNBFirmographicsDTO.NameSuffix> NameSuffix;
    global IndividualNameType() {

    }
}
global class IndustryCode extends tffa.DNBFirmographicsDTO.BaseDTO {
    global List<tffa.DNBFirmographicsDTO.IndustryCodeType> IndustryCode;
    global IndustryCode() {

    }
}
global class IndustryCodeDescriptionType extends tffa.DNBFirmographicsDTO.DNBStringType256 {
    global Integer IndustryCodeDescriptionLengthCode;
    global IndustryCodeDescriptionType() {

    }
}
global class IndustryCodeType extends tffa.DNBFirmographicsDTO.PrimaryIndustryCodeType {
    global Integer DisplaySequence;
    global IndustryCodeType() {

    }
}
global class InquiryDetail extends tffa.DNBFirmographicsDTO.BaseDTO {
    global String CountryISOAlpha2Code;
    global String DUNSNumber;
    global InquiryDetail() {

    }
}
global class InquiryReferenceDetail extends tffa.DNBFirmographicsDTO.BaseDTO {
    global String CustomerBillingEndorsementText;
    global List<String> CustomerReferenceText;
    global InquiryReferenceDetail() {

    }
}
global class JobTitle extends tffa.DNBFirmographicsDTO.BaseDTO {
    global tffa.DNBFirmographicsDTO.DNBStringType JobTitleText;
    global JobTitle() {

    }
}
global class KeyFinancialFiguresOverview extends tffa.DNBFirmographicsDTO.BaseDTO {
    global Integer EmployeeQuantity;
    global Decimal EmployeeQuantityGrowthRate;
    global tffa.DNBFirmographicsDTO.DNBDecodedStringType EmployeeQuantityReliabilityText;
    global List<tffa.DNBFirmographicsDTO.AmountType> ProfitOrLossAmount;
    global Decimal ProfitOrLossGrowthRate;
    global List<tffa.DNBFirmographicsDTO.AmountType> SalesRevenueAmount;
    global Decimal SalesTurnoverGrowthRate;
    global tffa.DNBFirmographicsDTO.StatementHeaderDetails StatementHeaderDetails;
    global KeyFinancialFiguresOverview() {

    }
}
global virtual class LegalEventSummaryType extends tffa.DNBFirmographicsDTO.BaseDTO {
    global Integer TotalFilingCount;
    global LegalEventSummaryType() {

    }
}
global class LegalEvents extends tffa.DNBFirmographicsDTO.BaseDTO {
    global Boolean ClaimsIndicator;
    global Boolean CriminalProceedingsIndicator;
    global tffa.DNBFirmographicsDTO.DebarmentsInformation DebarmentsInformation;
    global Boolean FinancialEmbarrassmentIndicator;
    global Boolean SuitsAndOrJudgmentsIndicator;
    global LegalEvents() {

    }
}
global class LegalFormDetailsType extends tffa.DNBFirmographicsDTO.BaseDTO {
    global tffa.DNBFirmographicsDTO.DNBDecodedStringType LegalFormText;
    global tffa.DNBFirmographicsDTO.Location RegistrationLocation;
    global LegalFormDetailsType() {

    }
}
global class Liabilities extends tffa.DNBFirmographicsDTO.BaseDTO {
    global tffa.DNBFirmographicsDTO.FinancialAmountType TotalEquityAmount;
    global Liabilities() {

    }
}
global class LineOfBusinessDetailsType extends tffa.DNBFirmographicsDTO.BaseDTO {
    global tffa.DNBFirmographicsDTO.DNBStringType LineOfBusinessDescription;
    global LineOfBusinessDetailsType() {

    }
}
global class Linkage extends tffa.DNBFirmographicsDTO.BaseDTO {
    global tffa.DNBFirmographicsDTO.ParentAssociation DomesticUltimateOrganization;
    global Integer FamilyTreeHierarchyLevel;
    global tffa.DNBFirmographicsDTO.ParentAssociation GlobalUltimateOrganization;
    global tffa.DNBFirmographicsDTO.ParentAssociation HeadquartersOrganization;
    global tffa.DNBFirmographicsDTO.LinkageSummary LinkageSummary;
    global tffa.DNBFirmographicsDTO.DNBDateType LinkageUpdateDate;
    global tffa.DNBFirmographicsDTO.Shareholder ParentOrganization;
    global Linkage() {

    }
}
global class LinkageSummary extends tffa.DNBFirmographicsDTO.BaseDTO {
    global Integer GlobalUltimateFamilyTreeLinkageCount;
    global LinkageSummary() {

    }
}
global class Location extends tffa.DNBFirmographicsDTO.BaseDTO {
    global List<tffa.DNBFirmographicsDTO.MailAddressType> MailingAddress;
    global List<tffa.DNBFirmographicsDTO.PrimaryAddressType> PrimaryAddress;
    global Location() {

    }
}
global class LocationDetailForAirportConcession extends tffa.DNBFirmographicsDTO.BaseDTO {
    global String CountryISOAlpha2Code;
    global String TerritoryAbbreviatedName;
    global LocationDetailForAirportConcession() {

    }
}
global class MailAddressType extends tffa.DNBFirmographicsDTO.BaseAddressType {
    global Integer CountryWorldBaseCode;
    global String PostalRouteNumber;
    global tffa.DNBFirmographicsDTO.DNBDecodedStringType PostalRouteTypeText;
    global MailAddressType() {

    }
}
global class Management extends tffa.DNBFirmographicsDTO.Association {
    global tffa.DNBFirmographicsDTO.Compensation CurrentCompensation;
    global List<tffa.DNBFirmographicsDTO.CurrentManagementResponsibility> CurrentManagementResponsibility;
    global List<tffa.DNBFirmographicsDTO.EmploymentBiography> EmploymentBiography;
    global tffa.DNBFirmographicsDTO.DNBDecodedStringType GenderText;
    global List<tffa.DNBFirmographicsDTO.JobTitle> JobTitle;
    global String PrincipalAge;
    global List<tffa.DNBFirmographicsDTO.PrincipalIdentificationNumberType> PrincipalIdentificationNumberDetail;
    global tffa.DNBFirmographicsDTO.SubjectName PrincipalName;
    global Management() {

    }
}
global class ManagementResponsibilityText extends tffa.DNBFirmographicsDTO.BaseDTO {
    global String ManagementResponsibilityCode;
    global String Value;
    global ManagementResponsibilityText() {

    }
}
global virtual class Message extends tffa.DNBFirmographicsDTO.BaseDTO {
    global Message() {

    }
}
global class MinorityOwnedDetails extends tffa.DNBFirmographicsDTO.SocioEconomicReferenceDetailType {
    global List<tffa.DNBFirmographicsDTO.OwnershipEthnicityType> OwnershipEthnicity;
    global MinorityOwnedDetails() {

    }
}
global class NamePrefix extends tffa.DNBFirmographicsDTO.BaseDTO {
    global String NamePrefixText;
    global NamePrefix() {

    }
}
global class NameSuffix extends tffa.DNBFirmographicsDTO.BaseDTO {
    global String NameSuffixText;
    global NameSuffix() {

    }
}
global class OperatingStatusComment extends tffa.DNBFirmographicsDTO.BaseDTO {
    global String OperatingStatusFreeFormComment;
    global OperatingStatusComment() {

    }
}
global class OrderProductRequest extends tffa.DNBFirmographicsDTO.Request {
    global tffa.DNBFirmographicsDTO.OrderProductRequestDetail OrderProductRequestDetail;
    global OrderProductRequest() {

    }
}
global class OrderProductRequestDetail extends tffa.DNBFirmographicsDTO.BaseDTO {
    global tffa.DNBFirmographicsDTO.ArchiveDetail ArchiveDetail;
    global tffa.DNBFirmographicsDTO.InquiryDetail InquiryDetail;
    global tffa.DNBFirmographicsDTO.InquiryReferenceDetail InquiryReferenceDetail;
    global tffa.DNBFirmographicsDTO.ProductSpecification ProductSpecification;
    global OrderProductRequestDetail() {

    }
}
global class OrderProductResponse extends tffa.DNBFirmographicsDTO.Response {
    global tffa.DNBFirmographicsDTO.OrderProductResponseDetail OrderProductResponseDetail;
    global OrderProductResponse() {

    }
}
global class OrderProductResponseDetail extends tffa.DNBFirmographicsDTO.BaseDTO {
    global tffa.DNBFirmographicsDTO.ProductResponseInquiryDetail InquiryDetail;
    global tffa.DNBFirmographicsDTO.InquiryReferenceDetail InquiryReferenceDetail;
    global tffa.DNBFirmographicsDTO.Product Product;
    global OrderProductResponseDetail() {

    }
}
global class Organization extends tffa.DNBFirmographicsDTO.Subject {
    global tffa.DNBFirmographicsDTO.ActivitiesAndOperations ActivitiesAndOperations;
    global tffa.DNBFirmographicsDTO.Assessment Assessment;
    global tffa.DNBFirmographicsDTO.BusinessTrading BusinessTrading;
    global tffa.DNBFirmographicsDTO.Competitors Competitors;
    global tffa.DNBFirmographicsDTO.EmployeeFigures EmployeeFigures;
    global tffa.DNBFirmographicsDTO.IndustryCode IndustryCode;
    global tffa.DNBFirmographicsDTO.Linkage Linkage;
    global tffa.DNBFirmographicsDTO.OrganizationDetail OrganizationDetail;
    global tffa.DNBFirmographicsDTO.OrganizationName OrganizationName;
    global tffa.DNBFirmographicsDTO.PrincipalsAndManagement PrincipalsAndManagement;
    global tffa.DNBFirmographicsDTO.RegisteredDetail RegisteredDetail;
    global tffa.DNBFirmographicsDTO.SocioEconomicIdentification SocioEconomicIdentification;
    global tffa.DNBFirmographicsDTO.OrganizationThirdPartyAssessment ThirdPartyAssessment;
    global Organization() {

    }
}
global class OrganizationDetail extends tffa.DNBFirmographicsDTO.BaseDTO {
    global Boolean BoneyardOrganizationIndicator;
    global tffa.DNBFirmographicsDTO.DNBDateType ControlOwnershipDate;
    global tffa.DNBFirmographicsDTO.DNBDecodedStringType ControlOwnershipTypeText;
    global List<tffa.DNBFirmographicsDTO.FamilyTreeMemberRole> FamilyTreeMemberRole;
    global tffa.DNBFirmographicsDTO.DNBDecodedStringType FranchiseOperationTypeText;
    global List<tffa.DNBFirmographicsDTO.OperatingStatusComment> OperatingStatusComment;
    global tffa.DNBFirmographicsDTO.DNBDecodedStringType OperatingStatusText;
    global String OrganizationStartYear;
    global Boolean OutofBusinessIndicator;
    global Boolean StandaloneOrganizationIndicator;
    global OrganizationDetail() {

    }
}
global virtual class OrganizationIdentificationNumberSimpleType extends tffa.DNBFirmographicsDTO.BaseDTO {
    global Integer DNBCodeTableNumber;
    global Integer DNBCodeValue;
    global String OrganizationIdentificationNumber;
    global String TypeText;
    global OrganizationIdentificationNumberSimpleType() {

    }
}
global class OrganizationIdentificationNumberType extends tffa.DNBFirmographicsDTO.OrganizationIdentificationNumberSimpleType {
    global String AssignmentMethodText;
    global Integer DisplaySequence;
    global String FilingOrganizationName;
    global Boolean PreferredOrganizationIdentificationNumberIndicator;
    global String RegistrationIssuerDUNSNumber;
    global String RegistrationIssuerName;
    global tffa.DNBFirmographicsDTO.Location RegistrationLocation;
    global tffa.DNBFirmographicsDTO.DNBDateType StartDate;
    global OrganizationIdentificationNumberType() {

    }
}
global class OrganizationName extends tffa.DNBFirmographicsDTO.SubjectName {
    global List<tffa.DNBFirmographicsDTO.FormerOrganizationPrimaryNameType> FormerOrganizationPrimaryName;
    global List<tffa.DNBFirmographicsDTO.OrganizationPrimaryNameType> OrganizationPrimaryName;
    global List<tffa.DNBFirmographicsDTO.OrganizationNameBaseType> TradeStyleName;
    global OrganizationName() {

    }
}
global virtual class OrganizationNameBaseType extends tffa.DNBFirmographicsDTO.BaseDTO {
    global Integer DisplaySequence;
    global tffa.DNBFirmographicsDTO.DNBStringType256 OrganizationName;
    global OrganizationNameBaseType() {

    }
}
global virtual class OrganizationPrimaryNameType extends tffa.DNBFirmographicsDTO.OrganizationNameBaseType {
    global Boolean RegisteredNameIndicator;
    global OrganizationPrimaryNameType() {

    }
}
global class OrganizationThirdPartyAssessment extends tffa.DNBFirmographicsDTO.BaseDTO {
    global List<tffa.DNBFirmographicsDTO.ThirdPartyAssessment> ThirdPartyAssessment;
    global OrganizationThirdPartyAssessment() {

    }
}
global virtual class Ownership extends tffa.DNBFirmographicsDTO.Association {
    global String CountryISOAlpha2Code;
    global String DUNSNumber;
    global List<tffa.DNBFirmographicsDTO.OrganizationPrimaryNameType> OrganizationPrimaryName;
    global List<tffa.DNBFirmographicsDTO.PrimaryAddressType> PrimaryAddress;
    global Ownership() {

    }
}
global class OwnershipEthnicityType extends tffa.DNBFirmographicsDTO.BaseDTO {
    global tffa.DNBFirmographicsDTO.DNBDecodedStringType EthnicityTypeText;
    global OwnershipEthnicityType() {

    }
}
global class ParentAssociation extends tffa.DNBFirmographicsDTO.FamilyTreeAssociation {
    global String CountryISOAlpha2Code;
    global String DUNSNumber;
    global List<tffa.DNBFirmographicsDTO.OrganizationPrimaryNameType> OrganizationPrimaryName;
    global List<tffa.DNBFirmographicsDTO.PrimaryAddressType> PrimaryAddress;
    global ParentAssociation() {

    }
}
global class PaydexScoreType extends tffa.DNBFirmographicsDTO.BaseDTO {
    global Integer PaydexScore;
    global Long TotalPaymentExperiencesUsedCount;
    global PaydexScoreType() {

    }
}
global class PoliticalDistrict extends tffa.DNBFirmographicsDTO.BaseDTO {
    global String PoliticalDistrictText;
    global PoliticalDistrict() {

    }
}
global class PremisesDetail extends tffa.DNBFirmographicsDTO.BaseDTO {
    global Decimal PremisesAreaMeasurement;
    global tffa.DNBFirmographicsDTO.DNBDecodedStringType PremisesAreaMeasurementReliabilityText;
    global tffa.DNBFirmographicsDTO.DNBDecodedStringType PremisesAreaMeasurementUnitText;
    global PremisesDetail() {

    }
}
global class PremisesUsageDetail extends tffa.DNBFirmographicsDTO.BaseDTO {
    global List<tffa.DNBFirmographicsDTO.PremisesUsageFunctionDetail> PremisesUsageFunctionDetail;
    global tffa.DNBFirmographicsDTO.DNBDecodedStringType PremisesUsageTypeText;
    global PremisesUsageDetail() {

    }
}
global class PremisesUsageFunctionDetail extends tffa.DNBFirmographicsDTO.BaseDTO {
    global tffa.DNBFirmographicsDTO.DNBDecodedStringType PremisesFunctionText;
    global PremisesUsageFunctionDetail() {

    }
}
global class PrimaryAddressType extends tffa.DNBFirmographicsDTO.BaseAddressType {
    global String CountryFIPSCode;
    global Integer CountryWorldBaseCode;
    global Integer CountyFIPSCode;
    global Integer CountyPopulationRankNumber;
    global Integer EconomicAreaOfInfluenceCode;
    global String MetropolitanStatisticalAreaFIPSCode;
    global List<tffa.DNBFirmographicsDTO.PoliticalDistrict> PoliticalDistrict;
    global Boolean RegisteredAddressIndicator;
    global Boolean ResidentialAddressIndicator;
    global Integer TerritoryFIPSCode;
    global PrimaryAddressType() {

    }
}
global virtual class PrimaryIndustryCodeType extends tffa.DNBFirmographicsDTO.BaseDTO {
    global Integer DNBCodeTableNumber;
    global Integer DNBCodeValue;
    global String IndustryCode;
    global List<tffa.DNBFirmographicsDTO.IndustryCodeDescriptionType> IndustryCodeDescription;
    global Decimal SalesPercentage;
    global String TypeText;
    global PrimaryIndustryCodeType() {

    }
}
global class PrincipalIdentificationNumberType extends tffa.DNBFirmographicsDTO.BaseDTO {
    global Integer DNBCodeTableNumber;
    global Integer DNBCodeValue;
    global String PrincipalIdentificationNumber;
    global String TypeText;
    global PrincipalIdentificationNumberType() {

    }
}
global class PrincipalsAndManagement extends tffa.DNBFirmographicsDTO.BaseDTO {
    global List<tffa.DNBFirmographicsDTO.Management> CurrentPrincipal;
    global tffa.DNBFirmographicsDTO.Management MostSeniorPrincipal;
    global PrincipalsAndManagement() {

    }
}
global class Product extends tffa.DNBFirmographicsDTO.BaseDTO {
    global tffa.DNBFirmographicsDTO.ResponseArchiveDetail ArchiveDetail;
    global String CopyrightNoticeText;
    global String DNBProductID;
    global tffa.DNBFirmographicsDTO.DNBDecodedStringType InDateStatusText;
    global Integer LanguageCode;
    global tffa.DNBFirmographicsDTO.Organization Organization;
    global List<tffa.DNBFirmographicsDTO.DNBDecodedStringType> SubjectScopeText;
    global Product() {

    }
}
global class ProductResponseInquiryDetail extends tffa.DNBFirmographicsDTO.BaseDTO {
    global String CountryISOAlpha2Code;
    global String DUNSNumber;
    global ProductResponseInquiryDetail() {

    }
}
global class ProductSpecification extends tffa.DNBFirmographicsDTO.BaseDTO {
    global Integer CharacterSetPreferenceCode;
    global String DNBProductID;
    global Integer LanguagePreferenceCode;
    global Integer OrderReasonCode;
    global Boolean ReturnOnlyInDateDataIndicator;
    global Boolean ReturnTransferredToDUNSIndicator;
    global Boolean TradeUpIndicator;
    global ProductSpecification() {

    }
}
global class PublicFilingHeaderType extends tffa.DNBFirmographicsDTO.BaseDTO {
    global String DisclaimerText;
    global PublicFilingHeaderType() {

    }
}
global class Purchaser extends tffa.DNBFirmographicsDTO.BaseDTO {
    global tffa.DNBFirmographicsDTO.CurrentPaydexScoreType CurrentPaydexScore;
    global List<tffa.DNBFirmographicsDTO.PurchaserDerivedData> PurchaserDerivedData;
    global Purchaser() {

    }
}
global class PurchaserDerivedData extends tffa.DNBFirmographicsDTO.BaseDTO {
    global tffa.DNBFirmographicsDTO.PurchaserDerivedDataCoveragePayments GlobalDataCoveragePayments;
    global tffa.DNBFirmographicsDTO.DNBDateType TradeDataYearMonth;
    global tffa.DNBFirmographicsDTO.PurchaserDerivedDataCoveragePayments TwentyFourMonthsDataCoveragePayments;
    global PurchaserDerivedData() {

    }
}
global class PurchaserDerivedDataCoveragePayments extends tffa.DNBFirmographicsDTO.BaseDTO {
    global List<tffa.DNBFirmographicsDTO.PurchaserDerivedPaymentPeriodSummary> PaymentPeriodSummary;
    global PurchaserDerivedDataCoveragePayments() {

    }
}
global class PurchaserDerivedPaymentPeriodSummary extends tffa.DNBFirmographicsDTO.BaseDTO {
    global tffa.DNBFirmographicsDTO.PurchaserDerivedPaymentsWithHighCredit PaymentsWithHighCredit;
    global String SummaryPeriod;
    global PurchaserDerivedPaymentPeriodSummary() {

    }
}
global class PurchaserDerivedPaymentsWithHighCredit extends tffa.DNBFirmographicsDTO.BaseDTO {
    global tffa.DNBFirmographicsDTO.AmountType AverageHighCreditAmount;
    global tffa.DNBFirmographicsDTO.AmountType HighCreditMaximumAmount;
    global PurchaserDerivedPaymentsWithHighCredit() {

    }
}
global class RegisteredDetail extends tffa.DNBFirmographicsDTO.BaseDTO {
    global String IncorporationYear;
    global tffa.DNBFirmographicsDTO.AmountType IssuedShareCapitalAmount;
    global tffa.DNBFirmographicsDTO.LegalFormDetailsType LegalFormDetails;
    global List<tffa.DNBFirmographicsDTO.OrganizationIdentificationNumberType> OrganizationIdentificationNumberDetail;
    global List<tffa.DNBFirmographicsDTO.ShareCapitalDetailsType> ShareCapitalDetails;
    global List<tffa.DNBFirmographicsDTO.StockExchangeDetails> StockExchangeDetails;
    global RegisteredDetail() {

    }
}
global virtual class Request extends tffa.DNBFirmographicsDTO.Message {
    global tffa.DNBFirmographicsDTO.RequestTransactionDetail TransactionDetail;
    global Request() {

    }
}
global class RequestTransactionDetail extends tffa.DNBFirmographicsDTO.BaseDTO {
    global String ApplicationTransactionID;
    global String SubmittingOfficeID;
    global Datetime TransactionTimestamp;
    global RequestTransactionDetail() {

    }
}
global virtual class Response extends tffa.DNBFirmographicsDTO.Message {
    global tffa.DNBFirmographicsDTO.ResponseTransactionDetail TransactionDetail;
    global tffa.DNBFirmographicsDTO.TransactionResult TransactionResult;
    global Response() {

    }
}
global class ResponseArchiveDetail extends tffa.DNBFirmographicsDTO.BaseDTO {
    global Long PortfolioAssetContainerID;
    global Long PortfolioAssetID;
    global ResponseArchiveDetail() {

    }
}
global class ResponseTransactionDetail extends tffa.DNBFirmographicsDTO.BaseDTO {
    global String ApplicationTransactionID;
    global String ServiceTransactionID;
    global Datetime TransactionTimestamp;
    global ResponseTransactionDetail() {

    }
}
global class ResultMessage extends tffa.DNBFirmographicsDTO.BaseDTO {
    global String ResultDescription;
    global ResultMessage() {

    }
}
global virtual class Role extends tffa.DNBFirmographicsDTO.BaseDTO {
    global Role() {

    }
}
global virtual class ScoreType extends tffa.DNBFirmographicsDTO.BaseDTO {
    global tffa.DNBFirmographicsDTO.DNBDecodedStringType MarketingRiskClassText;
    global ScoreType() {

    }
}
global class ShareCapitalDetailsType extends tffa.DNBFirmographicsDTO.BaseDTO {
    global tffa.DNBFirmographicsDTO.AmountType CapitalAmount;
    global Integer DNBCodeTableNumber;
    global Integer DNBCodeValue;
    global tffa.DNBFirmographicsDTO.DNBDateType StartDate;
    global String TypeText;
    global ShareCapitalDetailsType() {

    }
}
global class Shareholder extends tffa.DNBFirmographicsDTO.Ownership {
    global Shareholder() {

    }
}
global class SignificantEvents extends tffa.DNBFirmographicsDTO.BaseDTO {
    global Boolean DisasterSpecialEventsIndicator;
    global SignificantEvents() {

    }
}
global virtual class SimpleAddress extends tffa.DNBFirmographicsDTO.BaseDTO {
    global String CountryISOAlpha2Code;
    global String PrimaryTownName;
    global List<tffa.DNBFirmographicsDTO.StreetAddressLine> StreetAddressLine;
    global SimpleAddress() {

    }
}
global class SmallDisadvantagedBusinessDetail extends tffa.DNBFirmographicsDTO.BaseDTO {
    global tffa.DNBFirmographicsDTO.DNBDateType CertificationExpirationDate;
    global String CertificationReferenceIdentifier;
    global tffa.DNBFirmographicsDTO.DNBDateType CertificationStartDate;
    global tffa.DNBFirmographicsDTO.DataProviderDetail DataProviderDetail;
    global tffa.DNBFirmographicsDTO.DNBDateType DNBReceivedDate;
    global SmallDisadvantagedBusinessDetail() {

    }
}
global class SocialMediaDetail extends tffa.DNBFirmographicsDTO.BaseDTO {
    global tffa.DNBFirmographicsDTO.DNBDecodedStringType SocialMediaPlatformName;
    global String WebPageURL;
    global SocialMediaDetail() {

    }
}
global class SocioEconomicIdentification extends tffa.DNBFirmographicsDTO.BaseDTO {
    global List<tffa.DNBFirmographicsDTO.AirportConcessionDisadvantagedBusinessEnterpriseDetail> AirportConcessionDisadvantagedBusinessEnterpriseDetail;
    global Boolean AirportConcessionDisadvantagedBusinessEnterpriseIndicator;
    global List<tffa.DNBFirmographicsDTO.SocioEconomicReferenceDetailType> AlaskanNativeCorporationDetails;
    global Boolean AlaskanNativeCorporationIndicator;
    global List<tffa.DNBFirmographicsDTO.SocioEconomicReferenceDetailType> AlternativeSexualOrientationDetails;
    global Boolean AlternativeSexualOrientationIndicator;
    global List<tffa.DNBFirmographicsDTO.CertifiedSmallBusinessDetail> CertifiedSmallBusinessDetail;
    global Boolean CertifiedSmallBusinessIndicator;
    global List<tffa.DNBFirmographicsDTO.SocioEconomicReferenceDetailType> DisabledOwnedDetail;
    global Boolean DisabledOwnedIndicator;
    global List<tffa.DNBFirmographicsDTO.SocioEconomicReferenceDetailType> DisabledVeteranBusinessEnterpriseDetail;
    global Boolean DisabledVeteranBusinessEnterpriseIndicator;
    global List<tffa.DNBFirmographicsDTO.SocioEconomicReferenceDetailType> DisadvantagedBusinessEnterpriseDetail;
    global Boolean DisadvantagedBusinessEnterpriseIndicator;
    global List<tffa.DNBFirmographicsDTO.SocioEconomicReferenceDetailType> DisadvantagedVeteranEnterpriseDetail;
    global Boolean DisadvantagedVeteranEnterpriseIndicator;
    global List<tffa.DNBFirmographicsDTO.SocioEconomicReferenceDetailType> EightACertifiedBusinessDetails;
    global Boolean EightACertifiedBusinessIndicator;
    global List<tffa.DNBFirmographicsDTO.SocioEconomicReferenceDetailType> FemaleOwnedBusinessEnterpriseDetail;
    global Boolean FemaleOwnedBusinessEnterpriseIndicator;
    global List<tffa.DNBFirmographicsDTO.SocioEconomicReferenceDetailType> FemaleOwnedDetail;
    global Boolean FemaleOwnedIndicator;
    global List<tffa.DNBFirmographicsDTO.SocioEconomicReferenceDetailType> FemaleOwnedSmallBusinessDetails;
    global Boolean FemaleOwnedSmallBusinessIndicator;
    global List<tffa.DNBFirmographicsDTO.SocioEconomicReferenceDetailType> HistoricallyUnderutilizedDetails;
    global Boolean HistoricallyUnderutilizedIndicator;
    global List<tffa.DNBFirmographicsDTO.SocioEconomicReferenceDetailType> HUBZoneCertifiedBusinessDetails;
    global Boolean HUBZoneCertifiedBusinessIndicator;
    global Boolean LaborSurplusAreaIndicator;
    global List<tffa.DNBFirmographicsDTO.SocioEconomicReferenceDetailType> LocalDisadvantagedBusinessEnterpriseDetails;
    global Boolean LocalDisadvantagedBusinessEnterpriseIndicator;
    global List<tffa.DNBFirmographicsDTO.SocioEconomicReferenceDetailType> MinorityBusinessEnterpriseDetail;
    global Boolean MinorityBusinessEnterpriseIndicator;
    global Boolean MinorityCollegeIndicator;
    global List<tffa.DNBFirmographicsDTO.MinorityOwnedDetails> MinorityOwnedDetails;
    global Boolean MinorityOwnedIndicator;
    global List<tffa.DNBFirmographicsDTO.OwnershipEthnicityType> OwnershipEthnicity;
    global List<tffa.DNBFirmographicsDTO.SocioEconomicReferenceDetailType> ServiceDisabledVeteranOwnedDetail;
    global Boolean ServiceDisabledVeteranOwnedIndicator;
    global Boolean SmallBusinessIndicator;
    global List<tffa.DNBFirmographicsDTO.SmallDisadvantagedBusinessDetail> SmallDisadvantagedBusinessDetail;
    global Boolean SmallDisadvantagedBusinessIndicator;
    global List<tffa.DNBFirmographicsDTO.SocioEconomicReferenceDetailType> VeteranBusinessEnterpriseDetail;
    global Boolean VeteranBusinessEnterpriseIndicator;
    global List<tffa.DNBFirmographicsDTO.SocioEconomicReferenceDetailType> VeteranOwnedDetail;
    global Boolean VeteranOwnedIndicator;
    global List<tffa.DNBFirmographicsDTO.SocioEconomicReferenceDetailType> VietnamVeteranOwnedDetail;
    global Boolean VietnamVeteranOwnedIndicator;
    global SocioEconomicIdentification() {

    }
}
global virtual class SocioEconomicReferenceDetailType extends tffa.DNBFirmographicsDTO.BaseDTO {
    global tffa.DNBFirmographicsDTO.DNBDateType CertificationExpirationDate;
    global String CertificationReferenceIdentifier;
    global tffa.DNBFirmographicsDTO.DNBDateType CertificationStartDate;
    global tffa.DNBFirmographicsDTO.DataProviderDetail DataProviderDetail;
    global tffa.DNBFirmographicsDTO.DNBDateType DNBReceivedDate;
    global SocioEconomicReferenceDetailType() {

    }
}
global class StatementHeaderDetails extends tffa.DNBFirmographicsDTO.StatementHeaderType {
    global StatementHeaderDetails() {

    }
}
global virtual class StatementHeaderType extends tffa.DNBFirmographicsDTO.BaseDTO {
    global String CurrencyISOAlpha3Code;
    global String FinancialPeriodDuration;
    global tffa.DNBFirmographicsDTO.DNBDateType FinancialStatementToDate;
    global tffa.DNBFirmographicsDTO.DNBDecodedStringType TimePeriodText;
    global tffa.DNBFirmographicsDTO.DNBDecodedStringType UnitOfSizeText;
    global StatementHeaderType() {

    }
}
global class StatementItem extends tffa.DNBFirmographicsDTO.BaseDTO {
    global Integer DisplaySequence;
    global Integer DNBCodeTableNumber;
    global Integer DNBCodeValue;
    global String ExternalCodingSchemeTypeText;
    global String ExternalCodingSchemeValue;
    global tffa.DNBFirmographicsDTO.AmountType ItemAmount;
    global tffa.DNBFirmographicsDTO.DNBStringType256 ItemDescriptionText;
    global Integer ParentDNBCodeValue;
    global StatementItem() {

    }
}
global class StockExchangeDetails extends tffa.DNBFirmographicsDTO.BaseDTO {
    global String CountryISOAlpha2Code;
    global Boolean PrimaryStockExchangeIndicator;
    global tffa.DNBFirmographicsDTO.DNBDecodedStringType StockExchangeName;
    global String StockExchangeTickerName;
    global StockExchangeDetails() {

    }
}
global class StreetAddressLine extends tffa.DNBFirmographicsDTO.BaseDTO {
    global Integer DisplaySequence;
    global String LineText;
    global StreetAddressLine() {

    }
}
global virtual class Subject extends tffa.DNBFirmographicsDTO.BaseDTO {
    global tffa.DNBFirmographicsDTO.Banking Banking;
    global tffa.DNBFirmographicsDTO.Events Events;
    global tffa.DNBFirmographicsDTO.Financial Financial;
    global tffa.DNBFirmographicsDTO.FinancialAssetArticle FinancialAssetArticle;
    global tffa.DNBFirmographicsDTO.Location Location;
    global tffa.DNBFirmographicsDTO.SubjectHeader SubjectHeader;
    global tffa.DNBFirmographicsDTO.Telecommunication Telecommunication;
    global Subject() {

    }
}
global class SubjectAddressUsageTenureDetail extends tffa.DNBFirmographicsDTO.BaseDTO {
    global tffa.DNBFirmographicsDTO.DNBDecodedStringType TenureTypeText;
    global SubjectAddressUsageTenureDetail() {

    }
}
global class SubjectHandling extends tffa.DNBFirmographicsDTO.BaseDTO {
    global tffa.DNBFirmographicsDTO.DNBDecodedStringType SubjectHandlingText;
    global SubjectHandling() {

    }
}
global class SubjectHeader extends tffa.DNBFirmographicsDTO.BaseDTO {
    global String DUNSNumber;
    global tffa.DNBFirmographicsDTO.DNBDateType DUNSSelfRequestDate;
    global Boolean DUNSSelfRequestIndicator;
    global String FullReportDate;
    global tffa.DNBFirmographicsDTO.DNBDateType LastUpdateDate;
    global Boolean MarketabilityIndicator;
    global List<tffa.DNBFirmographicsDTO.DNBDecodedStringType> NonMarketableReasonText;
    global String OrganizationSummaryText;
    global List<tffa.DNBFirmographicsDTO.SubjectHandling> SubjectHandling;
    global Integer TotalContinuousInquiriesCount;
    global Integer TotalInquiriesCount;
    global List<tffa.DNBFirmographicsDTO.TransferDUNSNumberRegistration> TransferDUNSNumberRegistration;
    global SubjectHeader() {

    }
}
global class SubjectIsAgentDetailsType extends tffa.DNBFirmographicsDTO.BaseDTO {
    global Boolean AgentIndicator;
    global SubjectIsAgentDetailsType() {

    }
}
global virtual class SubjectName extends tffa.DNBFirmographicsDTO.BaseDTO {
    global SubjectName() {

    }
}
global class Telecommunication extends tffa.DNBFirmographicsDTO.BaseDTO {
    global List<tffa.DNBFirmographicsDTO.TelecommunicationNumberType> FacsimileNumber;
    global List<tffa.DNBFirmographicsDTO.SocialMediaDetail> SocialMediaDetail;
    global List<tffa.DNBFirmographicsDTO.TelecommunicationNumberType> TelephoneNumber;
    global List<tffa.DNBFirmographicsDTO.WebPageAddressType> WebPageAddress;
    global Telecommunication() {

    }
}
global virtual class TelecommunicationNumberSimpleType extends tffa.DNBFirmographicsDTO.BaseDTO {
    global String InternationalDialingCode;
    global String TelecommunicationNumber;
    global TelecommunicationNumberSimpleType() {

    }
}
global class TelecommunicationNumberType extends tffa.DNBFirmographicsDTO.TelecommunicationNumberSimpleType {
    global Boolean UnreachableIndicator;
    global TelecommunicationNumberType() {

    }
}
global class ThirdPartyAssessment extends tffa.DNBFirmographicsDTO.BaseDTO {
    global String AssessmentTypeValue;
    global String AssessmentValue;
    global ThirdPartyAssessment() {

    }
}
global class TransactionResult extends tffa.DNBFirmographicsDTO.BaseDTO {
    global String ResultID;
    global List<tffa.DNBFirmographicsDTO.ResultMessage> ResultMessage;
    global String ResultText;
    global String SeverityText;
    global TransactionResult() {

    }
}
global class TransferDUNSNumberRegistration extends tffa.DNBFirmographicsDTO.BaseDTO {
    global tffa.DNBFirmographicsDTO.DNBDateType TransferDate;
    global List<tffa.DNBFirmographicsDTO.DNBDecodedStringType> TransferReasonText;
    global String TransferredFromDUNSNumber;
    global String TransferredToDUNSNumber;
    global TransferDUNSNumberRegistration() {

    }
}
global class USPatriotActComplianceRiskScore extends tffa.DNBFirmographicsDTO.BaseDTO {
    global String ComplianceRiskClassIndex;
    global Integer ComplianceRiskIndex;
    global USPatriotActComplianceRiskScore() {

    }
}
global class WebPageAddressType extends tffa.DNBFirmographicsDTO.BaseDTO {
    global String TelecommunicationAddress;
    global WebPageAddressType() {

    }
}
}
