@SuppressWarnings('PMD.ExcessiveClassLength,PMD.ExcessivePublicCount,PMD.VariableNamingConventions, PMD.TooManyFields')
public with sharing class FISIDVResponseDTO extends FISCCTransactionResponseBaseDTO {
  public FISIDVResponseDTO() {
    this.consumer = new Consumer();
  }

  // public class PersonReply {
  public String birthDt;
  public Boolean chexOk;
  public Integer chexResultId;
  public String cityNm;
  public String compositePhoneNbr;
  public Consumer consumer;
  public String countryNm;
  public String errorTxt;
  public String firstNm;
  public String governmentNbr;
  public String identificationStateCd;
  public String identificationStateNbr;
  public String lastNm;
  public String middleNm;
  public String postalPlusFourCd;
  public String stateCd;
  public String streetAddressTxt;
  public String transactionTrackingId;
  public String userdefinedTransactionTxt;
  public String locationId;
  public String industryMarketTypeCd;
  public String txtReport;

  public class Consumer {
    public Consumer() {
      this.chexsystemsResponse = new ChexSystemsResponse();
      this.identityManagerResponse = new IDMResponse();
      this.ofacResponse = new OfacResponse();
      this.qualifileResponse = new QualiFileResponse();
      this.complianceInfo = new ComplianceInfo();
    }

    public ChexSystemsResponse chexsystemsResponse;
    public String errorCd;
    public String errorTxt;
    public IDMResponse identityManagerResponse;
    public OfacResponse ofacResponse;
    public QualiFileResponse qualifileResponse;
    public ComplianceInfo complianceInfo;
  }

  public class ChexSystemsResponse {
    public ChexSystemsResponse() {
      this.SSNValidation = new SSNValidation();
      this.closureInformation = new ClosureInformation();
      this.consumerPreviousInquiry = new ConsumerPreviousInquiry();
      this.dlVerification = new DLVerification();
      this.driversLicenseValidation = new DriversLicenseValidation();
      this.retailInformation = new RetailInformation();
      this.purchasedDebtInfo = new PurchasedDebtInfo();
    }

    public SSNValidation SSNValidation;
    public ClosureInformation closureInformation;
    public String consumerDebitEducationCompletionDt;
    public ConsumerPreviousInquiry consumerPreviousInquiry;
    public DLVerification dlVerification;
    public DriversLicenseValidation driversLicenseValidation;
    public String driversLicenseProductCd;
    public String errorInformation;
    public String errorCd;
    public String errorTxt;
    public String fraudFinderResponseTxt;
    public String inquiryTrackingId;
    public String noDriversLicenseProductCd;
    public String numberInquiryCustomersTotalQty;
    public String pleaseCallCd;
    public String previousInquiryTotalQty;
    public String previousInquiriesNotFoundCd;
    public String previousInquiriesQty;
    public RetailInformation retailInformation;
    public PurchasedDebtInfo purchasedDebtInfo;
    public String checkPrintingActivityFlag;
  }

  public class SSNValidation {
    public String invalidGovernmentNumberTxt;
    public String validGovernmentNumberTxt;
  }

  public class DriversLicenseValidation {
    public String invalidDriversLicenseTxt;
    public String validDriversLicenseTxt;
  }

  public class ClosureInformation {
    public ClosureInformation() {
      this.reportedClosure = new List<ReportedClosure>();
    }
    public String closureNotFoundCd;
    public String consumerDisputeQty;
    public String paidClosureQty;
    public List<ReportedClosure> reportedClosure;
    public Integer totalClosures;
    public String unpaidClosureQty;
    public String soldClosuresQty;
    public String partiallyPaidClosuresQty;
  }

  public class ReportedClosure {
    public ReportedClosure() {
      this.closureReason1 = new closureReason1();
      this.closureReason2 = new ClosureReason2();
      this.closureReason3 = new ClosureReason3();
      this.reportingCustomer = new ReportingCustomer();
    }

    public ClosureReason1 closureReason1;
    public ClosureReason2 closureReason2;
    public ClosureReason3 closureReason3;
    public String collectionAmountTxt;
    public String collectionPaidCd;
    public String collectionsPaymentRecordedDt;
    public String consumerDisputeCd;
    public String consumerDisputeTxt;
    public String identityTheftCd;
    public String identityTheftTxt;
    public String originalChargeOffAmt;
    public String reportedCityNm;
    public String reportedDt;
    public String reportedFirstNm;
    public String reportedGovernmentNbr;
    public String reportedLastNm;
    public String reportedMiddleNm;
    public String reportedPostalPlusFourCd;
    public String reportedStateCd;
    public String reportedStreetAddressTxt;
    public ReportingCustomer reportingCustomer;
    public String settlementPaidCd;
    public String settlementPaidDt;
    public String settlementPaidTxt;
    public String totalCollectionAmt;
    public String closureConsumerStatRefId;
  }

  public class ClosureReason1 {
    public String closureReasonCategoryCd;
    public String closureReasonCategoryTxt;
    public String closureReasonCd;
    public String closureReasonTxt;
  }

  public class ClosureReason2 {
    public String closureReasonCategoryCd;
    public String closureReasonCategoryTxt;
    public String closureReasonCd;
    public String closureReasonTxt;
  }

  public class ClosureReason3 {
    public String closureReasonCategoryCd;
    public String closureReasonCategoryTxt;
    public String closureReasonCd;
    public String closureReasonTxt;
  }

  public class ReportingCustomer {
    public String customerBranchCityNm;
    public String customerBranchNm;
    public String customerBranchPostalPlusFourCd;
    public String customerBranchStateCd;
    public String customerBranchStreetAddressTxt;
    public String customerNm;
  }

  public class ConsumerPreviousInquiry {
    public ConsumerPreviousInquiry() {
      this.consumerPreviousInquiryDetails = new List<ConsumerPreviousInquiryDetails>();
    }
    public List<ConsumerPreviousInquiryDetails> consumerPreviousInquiryDetails;
    public String numberInquiryCustomersTotalQty;
    public String previousInquiriesNotFoundCd;
    public String previousInquiryTotalQty;
  }

  public class ConsumerPreviousInquiryDetails {
    public ConsumerPreviousInquiryDetails() {
      this.consumerInquiryCustomer = new ConsumerInquiryCustomer();
    }
    public ConsumerInquiryCustomer consumerInquiryCustomer;
    public String inquiryDt;
    public String previousInquiryCityNm;
    public String previousInquiryFirstNm;
    public String previousInquiryGovernmentNbr;
    public String previousInquiryID;
    public String previousInquiryLastNm;
    public String previousInquiryMiddleNm;
    public String previousInquiryPostalPlusFourCd;
    public String previousInquiryStateCd;
    public String previousInquiryStreetAddressTxt;
    public String previousInquiryConsumerStatRefId;
  }

  public class ConsumerInquiryCustomer {
    public String inquiryCustBranchCityNm;
    public String inquiryCustBranchName;
    public String inquiryCustBranchPostalPlusFourCd;
    public String inquiryCustBranchStateCd;
    public String inquiryCustBranchStreetAddress;
    public String inquiryCustNm;
  }

  public class DLVerification {
    public String driversLicenseNotFoundTxt;
    public String reportedDriversLicenseBirthDt;
    public String reportedDriversLicenseNm;
  }

  public class RetailInformation {
    public String unpaidRetailItemsFoundTxt;
    public String unpaidRetailItemsNotFoundTxt;
  }

  public class PurchasedDebtInfo {
    public PurchasedDebtInfo() {
      this.purchasedDebtDetail = new List<PurchasedDebtDetail>();
    }
    public String purchasedDebtNotFoundCd;
    public String purchasedDebtTotal;
    public String purchasedDebtDisputedQty;
    public String purchasedDebtUnpaidQty;
    public String purchasedDebtPaidQty;
    public String purchaseddebtPartiallyPaidQty;
    public String purchasedDebtSoldQty;
    public List<PurchasedDebtDetail> purchasedDebtDetail;
  }

  public class PurchasedDebtDetail {
    public String datePurchased;
    public String purchasedReportedBy;
    public String purchasedChargeOffAmount;
  }

  public class OfacResponse {
    public OfacResponse() {
      this.ofacHitResponse = new List<OfacHitResponse>();
      this.ofacLogIds = new OfacLogIDs();
      this.ofacValidationsResult = new OfacValidationsResult();
    }
    public String accountNumber;
    public String comments;
    public List<OfacHitResponse> ofacHitResponse;
    public OfacLogIDs ofacLogIds;
    public OfacValidationsResult ofacValidationsResult;
    public String verifier;
    public String verifyDate;
    public String totalOfacHitsQty;
    public String ofacHitInformationalMsgTxt;
  }

  public class OfacHitResponse {
    public String callSign;
    public String flag;
    public String fromList;
    public String grt;
    public String name;
    public String owner;
    public String program;
    public String remarks;
    public String title;
    public String tonnage;
    public String vesselType;
  }

  public class OfacLogIDs {
    public String batchId;
    public String custId;
    public String oid;
    public Integer sarrepid;
  }

  public class OfacValidationsResult {
    public Boolean ofacHit;
  }

  public class IDMResponse {
    public IDMResponse() {
      this.altInformation = new IDMAltInformation();
      this.logids = new IDMLogIDs();
      this.ssnValidation = new IDMSSNValidation();
      this.validationsResult = new IDMValidationsResult();
    }
    public String accountNumber;
    public String actions;
    public IDMAltInformation altInformation;
    public String comments;
    public String errorInformation;
    public IDMLogIDs logids;
    public IDMSSNValidation ssnValidation;
    public IDMValidationsResult validationsResult;
    public String verifier;
    public String verifyDate;
    public String errorCd;
  }

  public class IDMAltInformation {
    public String altAddress1;
    public String alt1AddressLine1;
    public String alt1AddressLine2;
    public String alt1City;
    public String alt1State;
    public String alt1PostalCd;
    public String altAddress2;
    public String alt2AddressLine1;
    public String alt2AddressLine2;
    public String alt2City;
    public String alt2State;
    public String alt2PostalCd;
    public String altAddress3;
    public String alt3AddressLine1;
    public String alt3AddressLine2;
    public String alt3City;
    public String alt3State;
    public String alt3PostalCd;
    public String altDob1;
    public String altDob2;
    public String altDob3;
    public String altDriversLicenseno1;
    public String altDriversLicenseno2;
    public String altdriversLicenseno3;
    public String altHomePhone1;
    public String altHomePhone2;
    public String altHomePhone3;
    public String altName1;
    public String altName2;
    public String altName3;
  }

  public class IDMLogIDs {
    public String batchId;
    public String chexReportId;
    public String custId;
    public String equifaxDecisionRepId;
    public String ofacLogId;
    public String oid;
    public Integer sarrepid;
  }

  public class IDMSSNValidation {
    public String ssnBeginIssueDate;
    public String ssnEndIssueDate;
    public String ssnIssueState;
  }

  public class IDMValidationsResult {
    public Boolean addressCheckOk;
    public Boolean afterSSNDate;
    public Boolean dobCheckOk;
    public Boolean driversLicenseCheckOk;
    public Boolean idCheckHadMatchingRecords;
    public Boolean idCheckOk;
    public Boolean isDeceased;
    public Boolean minorYes;
    public Boolean nameCheckOk;
    public Boolean ofacHit;
    public Boolean telephoneCheckOk;
    public Boolean ssnCheckOk;

    /**
     * It serializes FIS ID verification response object into json string
     * @param  IDMValidationsResult
     * @return string json response string
     */
    public string serialize(IDMValidationsResult i) {
      return JSON.serialize(i);
    }
  }

  public class QualiFileResponse {
    public QualiFileResponse() {
      this.accountActionInfo = new AccountActionInfo();
      this.creditBureauInfo = new CreditBureauInfo();
      this.crossSellInformation = new CrossSellInformation();
      this.qualifileInformation = new QualiFileInformation();
      this.referenceInformation = new ReferenceInformation();
      this.debitAttributesSummaryDetails = new DebitAttributesSummaryDetails();
      this.secondaryCreditBureauInfo = new SecondaryCreditBureauInfo();
      this.creditHeaderInfo = new CreditHeaderInfo();
      this.productStrategyCd = new ProductStrategyCd();
      this.prospectChexInfo = new ProspectChexInfo();
    }

    public AccountActionInfo accountActionInfo;
    public CreditBureauInfo creditBureauInfo;
    public CrossSellInformation crossSellInformation;
    public QualiFileInformation qualifileInformation;
    public String qualifileNotPerformedCd;
    public ReferenceInformation referenceInformation;
    public String errorCd;
    public String errorInformation;
    public String errorTxt;
    public DebitAttributesSummaryDetails debitAttributesSummaryDetails;
    public SecondaryCreditBureauInfo secondaryCreditBureauInfo;
    public CreditHeaderInfo creditHeaderInfo;
    public ProductStrategyCd productStrategyCd;
    public ProspectChexInfo prospectChexInfo;
  }

  public class CreditHeaderInfo {
    public String creditHeaderNameScore;
    public String creditHeaderAddressScore;
    public String creditHeaderSSNScore;
    public String creditHeaderDOBScore;
  }

  public class ProductStrategyCd {
    public String productStrategyCd1;
    public String productStrategyCd2;
    public String productStrategyCd3;
    public String productStrategyCd4;
    public String productStrategyCd5;
    public String productStrategyCd6;
    public String productStrategyCd7;
    public String productStrategyCd8;
    public String productStrategyCd9;
    public String productStrategyCd10;
  }

  public class ProspectChexInfo {
    public String prospectChexScore;
    public String prospectChexReasonCd1;
    public String prospectChexReasonCd2;
    public String prospectChexReasonCd3;
    public String prospectChexReasonCd4;
  }

  public class AccountActionInfo {
    public String accountAcceptanceTxt;
    public String accountActionTxt1;
    public String accountActionTxt10;
    public String accountActionTxt2;
    public String accountActionTxt3;
    public String accountActionTxt4;
    public String accountActionTxt5;
    public String accountActionTxt6;
    public String accountActionTxt7;
    public String accountActionTxt8;
    public String accountActionTxt9;
  }

  public class CreditBureauInfo {
    public String creditBureauReasonCd1;
    public String creditBureauReasonCd2;
    public String creditBureauReasonCd3;
    public String creditBureauReasonCd4;
    public String creditBureauReasonCd5;
    public String creditBureauScoreNbr;
  }

  public class CrossSellInformation {
    public CrossSellInformation() {
      this.productOffer1 = new ProductOffer1();
      this.productOffer2 = new ProductOffer2();
      this.productOffer3 = new ProductOffer3();
      this.productOffer4 = new ProductOffer4();
      this.productOffer5 = new ProductOffer5();
      this.productOffer6 = new ProductOffer6();
      this.productOffer7 = new ProductOffer7();
      this.productOffer8 = new ProductOffer8();
      this.productOffer9 = new ProductOffer9();
      this.productOffer10 = new ProductOffer10();
    }
    public ProductOffer1 productOffer1;
    public ProductOffer2 productOffer2;
    public ProductOffer3 productOffer3;
    public ProductOffer4 productOffer4;
    public ProductOffer5 productOffer5;
    public ProductOffer6 productOffer6;
    public ProductOffer7 productOffer7;
    public ProductOffer8 productOffer8;
    public ProductOffer9 productOffer9;
    public ProductOffer10 productOffer10;
  }

  public class ProductOffer1 {
    public String productOfferLimitAmt;
    public String productOfferTxt;
    public String productOfferRatePct;
  }

  public class ProductOffer2 {
    public String productOfferLimitAmt;
    public String productOfferTxt;
    public String productOfferRatePct;
  }

  public class ProductOffer3 {
    public String productOfferLimitAmt;
    public String productOfferTxt;
    public String productOfferRatePct;
  }

  public class ProductOffer4 {
    public String productOfferLimitAmt;
    public String productOfferTxt;
    public String productOfferRatePct;
  }

  public class ProductOffer5 {
    public String productOfferLimitAmt;
    public String productOfferTxt;
    public String productOfferRatePct;
  }

  public class ProductOffer6 {
    public String productOfferLimitAmt;
    public String productOfferTxt;
    public String productOfferRatePct;
  }

  public class ProductOffer7 {
    public String productOfferLimitAmt;
    public String productOfferTxt;
    public String productOfferRatePct;
  }

  public class ProductOffer8 {
    public String productOfferLimitAmt;
    public String productOfferTxt;
    public String productOfferRatePct;
  }

  public class ProductOffer9 {
    public String productOfferLimitAmt;
    public String productOfferTxt;
    public String productOfferRatePct;
  }

  public class ProductOffer10 {
    public String productOfferLimitAmt;
    public String productOfferTxt;
    public String productOfferRatePct;
  }

  public class QualiFileInformation {
    public QualiFileInformation() {
      this.qualifileReason1 = new QualiFileReason1();
      this.qualifileReason2 = new QualiFileReason2();
      this.qualifileReason3 = new QualiFileReason3();
      this.qualifileReason4 = new QualiFileReason4();
      this.qualifileReason5 = new QualiFileReason5();
    }
    public QualiFileReason1 qualifileReason1;
    public QualiFileReason2 qualifileReason2;
    public QualiFileReason3 qualifileReason3;
    public QualiFileReason4 qualifileReason4;
    public QualiFileReason5 qualifileReason5;
    public String scoreNbr;
  }

  public class QualiFileReason1 {
    public String reasonCd;
    public String reasonTxt;
  }

  public class QualiFileReason2 {
    public String reasonCd;
    public String reasonTxt;
  }

  public class QualiFileReason3 {
    public String reasonCd;
    public String reasonTxt;
  }

  public class QualiFileReason4 {
    public String reasonCd;
    public String reasonTxt;
  }

  public class QualiFileReason5 {
    public String reasonCd;
    public String reasonTxt;
  }

  public class ReferenceInformation {
    public String consumerDetailReferenceNbr;
    public String creditBureauId;
    public String creditBureauReferenceNbr;
    public String householdClusterCategoryCd;
    public String zipClusterCategoryCd;
  }

  public class DebitAttributesSummaryDetails {
    public DebitAttributesSummaryDetails() {
      this.closureAttributeCounts = new ClosureAttributeCounts();
    }
    public String previousInquiryAttributeCounts;
    public String checkOrderAttributeCounts;
    public String retailItemsAttributeCounts;
    public ClosureAttributeCounts closureAttributeCounts;
  }

  public class closureAttributeCounts {
    public String nbrClosuresPast30Days;
    public String nbrClosuresPast60Days;
    public String nbrClosuresPast90Days;
    public String nbrClosuresPast180Days;
    public String nbrClosuresPastOneYr;
    public String nbrClosuresPast2Yrs;
    public String nbrClosuresPast3Yrs;
    public String nbrClosuresPast4Yrs;
    public String nbrClosuresPast5Yrs;
    public String fraudClosureFlagPast5Yrs;
    public String nbrDaysSinceMostRecentClosurePast5Yrs;
    public String nbrDaysSinceFirstClosurePast5Yrs;
    public String averageNbrDaysBetweenClosuresPast5Yrs;
    public String consumerDisputeQtyPast5Yrs;
    public String consumerDisputeResolvedQtyPast5Yrs;
  }

  public class SecondaryCreditBureauInfo {
    public String secondaryCreditBureauReasonCd1;
    public String secondaryCreditBureauReasonCd2;
    public String secondaryCreditBureauReasonCd3;
    public String secondaryCreditBureauReasonCd4;
    public String secondaryCreditBureauReasonCd5;
    public String secondaryCreditBureauScoreNbr;
  }

  public class ComplianceInfo {
    public ComplianceInfo() {
      this.debitBureauComplianceInfo = new DebitBureauComplianceInfo();
      //this.creditBureauComplianceInfo = new CreditBureauComplianceInfo();
      //this.prospectChexComplianceInfo = new ProspectChexComplianceInfo();
    }
    public DebitBureauComplianceInfo debitBureauComplianceInfo;
    //public CreditBureauComplianceInfo creditBureauComplianceInfo;
    //public ProspectChexComplianceInfo prospectChexComplianceInfo;
  }

  public class DebitBureauComplianceInfo {
    /*public DebitBureauComplianceInfo() {
      this.debitConsumerStat = new List<DebitConsumerStat>();
    }
    public List<DebitConsumerStat> debitConsumerStat;
    public String debitTotalNbrOfStats;*/
    public String debitFreezeMessage;
    //public String debitIdTheftDetailTxt;
  }

  public class DebitConsumerStat {
    public String debitConsumerStatRefId;
    public String debitConsumerStatTxt;
  }

  public class CreditBureauComplianceInfo {
    public String creditConsumerStatTxt;
    public String creditAddressMatchResult;
    public String creditFCRA;
    public String creditFreezeMessageTxt;
    public String creditIdTheftMsg;
    public String creditIdTheftDetailTxt;
    public String creditStatusTxt;
  }

  public class ProspectChexComplianceInfo {
    public String prospectChexAddressMatchResult;
    public String prospectChexFCRA;
    public String prospectChexStatusTxt;
  }

}