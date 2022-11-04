public with sharing class FISCCIntegrationConstants {
  public static final String INVALID_SUBMISSION = 'Invalid Submission';
  public static final String INVALID_SUBMISSION_FUNDING = 'Invalid Submission level funding';
  public static final Boolean ISOBSOLETE_FALSE = false;
  public static final String INVALID_APPLICATION = 'Invalid Application';

  //Log  Items Status
  public static final String LOG_ITEM_STATUS_SUCCESS = 'Success';
  public static final String LOG_ITEM_STATUS_FAILURE = 'Failure';
  public static String DIGITAL = 'DIGITAL';
  public static final String CREATE_CUSTOMER_FLOW = 'Create Customer FLOW';
  public static final String CREATE_CUSTOMER_STARTED = 'Create Customer Started';
  public static final String CREATE_CUSTOMER_FAILED = 'Create Customer Failed';
  public static final String CREATE_CUSTOMER_COMPLETED = 'Create Customer Completed';

  public static final String CUSTOMER_EMAIL_FLOW = 'Customer Email FLOW';
  public static final String CUSTOMER_EMAIL_STARTED = 'Customer Email Started';
  public static final String CUSTOMER_EMAIL_FAILED = 'Customer Email Failed';
  public static final String CUSTOMER_EMAIL_COMPLETED = 'Customer Email Completed';

  public static final String CUSTOMER_SEARCHTAXNBR_FLOW = 'Customer SearchTaxnbr FLOW';
  public static final String CUSTOMER_SEARCHTAXNBR_STARTED = 'Customer SearchTaxnbr Started';
  public static final String CUSTOMER_SEARCHTAXNBR_FAILED = 'Customer SearchTaxnbr Failed';
  public static final String CUSTOMER_SEARCHTAXNBR_COMPLETED = 'Customer SearchTaxnbr Completed';

  public static final String ACCOUNT_OPENING = 'Account Opening';
  public static final String DEPOSIT_ORIGINATOR_STARTED = 'Account Opening Started';
  public static final String DEPOSIT_ORIGINATOR_FAILED = 'Account Opening Failed';
  public static final String APPLICATION_PROCESSING_FAILED = 'Application Processing Failed';
  public static final String DEPOSIT_ORIGINATOR_COMPLETED = 'Account Opening Completed';
  public static final String DEPOSIT_ORIGINATOR = 'DepositOriginator';
  public static final String DEPOSIT_ORIGINATOR_CUSTOMER_CREATION = 'Customer Creation';
  public static final String DEPOSIT_ORIGINATOR_INDIVIDUAL_DEMOGRAPHICS = 'Individual Demographics';
  public static final String DEPOSIT_ORIGINATOR_ORG_CREATION = 'Orgainization Creation';
  public static final String CUST_TO_CUST_CREATION_RELN = 'Orgainization and Owner Reln';
  public static final String CUST_TO_CUST_CREATION_RELN_SUCCESS = 'Orgainization and Owner Reln Success';
  public static final String CUST_TO_CUST_CREATION_RELN_FAILURE = 'Orgainization and Owner Reln Failure';
  public static final String DEPOSIT_ORIGINATOR_CUSTOMER_CREATION_SUCCESS = 'Customer Creation Success';
  public static final String DEPOSIT_ORIGINATOR_CUSTOMER_CREATION_FAILURE = 'Customer Creation Failure';
  public static final String CUSTOMER_ACCOUNT_RELATIONSHIP = 'Customer Account Relationship';
  public static final String CUSTOMER_ACCOUNT_RELATIONSHIP_SUCCESS = 'Customer Account Relationship Success';
  public static final String CUSTOMER_ACCOUNT_RELATIONSHIP_FAILURE = 'Customer Account Relationship Failure';

  public static final String ACCOUNT_FUNDING = 'Account Funding';
  public static final String ACCOUNT_FUNDING_DEBITCARD = 'Account Funding DebitCard';
  public static final String ACCOUNT_FUNDING_STARTED = 'Account Funding Success';
  public static final String ACCOUNT_FUNDING_FAILED = 'Account Funding Failed';
  public static final String ACCOUNT_FUNDING_COMPLETED = 'Account Funding Completed';

  public static final String Brand_Code = 'BA-889';
  public static final String LOG_HOST_REQUEST = 'LOG_HOST_REQUEST';
  public static final String LOG_HOST_RESPONSE = 'LOG_HOST_RESPONSE';
  public static final String SEARCH_CUSTOMER_TAXBR = 'SearchCustomerTaxbr';
  public static String authorization;
  public static final String COMPLETE_HOST_RESPONSE = 'COMPLETE_HOST_RESPONSE';
  public static final String CREATE_CUSTOMER = 'CreateCustomer';
  public static final String CUSTOMER_SEARCHTAXNBR = 'CustomerSearchTaxnbr';
  public static final String CUSTOMER_EMAIL = 'CustomerEmail';
  public static final String ACCESS_TOKEN = 'AccessToken';
  public static final String RESEND_CODE = 'PRI';
  public static final String Deposit_Originate_FirstJoint_Customer = 'DepositOriginateFirstJointCustomer';
  public static final String Deposit_Originate_SecondJoint_Customer = 'DepositOriginateSecondJointCustomer';
  public static final String Deposit_Originate_ThirdJoint_Customer = 'DepositOriginateThirdJointCustomer';
  public static final String Deposit_Originate_FourthJoint_Customer = 'DepositOriginateFourthJointCustomer';
  public static final String Deposit_Originate_FifthJoint_Customer = 'DepositOriginateFifthJointCustomer';

  public static final String Deposit_Originate_Primary_Customer = 'DepositOriginatePrimaryCustomer';
  public static final String Deposit_Originate_Email = 'DepositOriginateEmail';

  public static final String Deposit_Originate_Deposit_Account = 'DepositOriginateDepositAccount';
  public static final String Deposit_Originate_Deposit_Addresses = 'DepositOriginateDepositAddresses';
  public static final String Deposit_Originate_Customer_Accounts = 'DepositOriginateCustomerAccounts';
  public static final String DeveloperName_Deposit_Originate = 'DepositOrigination';

  public static Map<String, string> mapOfHyphenValues = new Map<String, String>{
    'DepositOriginationLst' => 'Deposit-OriginationLst',
    'customerEmail' => 'customer-email',
    'emailAddressLst' => 'email-addressLst',
    'emailaddressesLst' => 'email-addressesLst',
    'depositAccountNumber' => 'deposit-account_number',
    'depositAccount' => 'deposit-account',
    'queryParamCustomerReln' => 'query-parameters-customer-customer-relationships',
    'custToCustRelnDataLst' => 'customer-customer-relationships-dataLst',
    'depositAddresses' => 'deposit-addresses',
    'customerAccounts' => 'customer-accounts',
    'depositOnlineDollarTrans' => 'deposit-online-dollar-transaction',
    'depositOnlineDollarTransResp' => 'online-dollar-transaction',
    'certificateDeposit' => 'deposit-new-certificate-of-deposit',
    'newCertificateDeposit' => 'new-certificate-of-deposit',
    'cardNumber' => 'card-number',
    'cardNew' => 'card-new',
    'CardsCardholderAddress' => 'cards-cardholder-address',
    'caMaintainAcc' => 'ca-maintained-account',
    'caAccRelnList' => 'customer-account-relationshipsLst',
    'racfpass' => 'racf-password',
    'deficitTransferSenderLst' => 'deficit-transfers-sendersLst',
    'defTransfer' => 'deficit-transfers-new',
    'immediatetransfers' => 'immediate-transfers',
    'immediatetransfers' => 'immediate-transfers',
    'individualDemographics' => 'individual-demographics',
    'custPhoneNumber' => 'phone-numbers',
    'phoneNumLst' => 'phone-numbersLst',
    'accnbr' => 'account_number',
    'multipleAaccountsParameters' => 'multiple-accounts-parameters',
    'multipleAccountsNewLst' => 'multiple-accounts-newLst',
    'officerDetailsLts' => 'officers-listLst',
    'controlData' => 'query-parameters-officers-list',
    'dueDiligenceDemographics' => 'due-diligence-demographics',
    'dueDiligenceReq' => 'due-diligence',
    'debitCardMultipleAccount' => 'card-multiple-accounts-new',
    'debitCardmultipleAccountsNewLst' => 'multiple-accounts-newLst',
    'pinlessCardData' => 'reissue-pinless-card-data',
    'customerAliasNew' => 'customer-alias-new',
    'branchesDetail' => 'branches-detail',
    'sdbControlData' => 'query-parameters-vacant-boxes',
    'sdbVacantBox' => 'vacant-boxesLst',
    'boxOwnerNew' => 'box-owner-new',
    'boxDeputies' => 'box-deputies',
    'customerOrg' => 'customers-organizations',
    'customerRelnship' => 'customer-customer-relationshipsLst',
    'customerData' => 'customer-data',
    'incomingCountry' => 'incoming-countries',
    'outgoingCountry' => 'outgoing-countries',
    'existingPlanList' => 'customer-plan-dataLst',
    'planBeneficiariesDataLst' => 'plan-beneficiaries-dataLst',
    'retirementPlan' => 'plans-data',
    'planBeneficiary' => 'plan-beneficiaries',
    'incomingCountries' => 'incoming-countriesLst',
    'outgoingCountries' => 'outgoing-countriesLst',
    'controlData' => 'processing-schedules-weekdays',
    'holidayList' => 'processing-schedules-holidaysLst',
    'customerAddress' => 'customers-addresses',
    'fetchCustomerAlias' => 'customers-aliasesLst',
    'organizationDemographics' => 'organization-demographics',
    'accountProf' => 'account-profile',
    'relatedAccountsLst' => 'related-accountsLst',
    'relatedCustomersLst' => 'related-customersLst',
    'custProfile' => 'customer-profile',
    'searchControlData' => 'control-data',
    'plansDetail' => 'plans-detail',
    'planAccountData' => 'plans-accounts-dataLst'
  };

  public static final String SVCID_DueDiligence = 'CI214';
  public static final String SVCID_CustomerEmail = 'CI044';
  public static final String SVCID_CreateCustomer = 'CI007';
  public static final String SVCID_CreateOrg = 'CI008';
  public static final String SVCID_MBPASS = 'MBPASS';
  public static final String SVCID_DepositAccountNumber = 'DLANG';
  public static final String SVCID_NewDepositAccount = 'DLNEW';
  public static final String SVCID_DepositNameAddress = 'DLNAM';
  public static final String SVCID_CustomerAccount = 'CI009';
  public static final String SVCID_DLDLR = 'DLDLR';
  public static final String SVCID_CertDeposit = 'DLTNC';
  public static final String SVCID_CardCreation = 'CB100';
  public static final String SVCID_CardMultiAccount = 'CB110';
  public static final String SVCID_SDBAddOwner = 'SBM2A';
  public static final String SVCID_SDBAddDeputy = 'SBM5A';

  public static final String REMARK_IDENTITY = 'S';
  public static final Integer REMARK_MONTHS_TO_ADD = 6;
  public static final String ACCOUNT_OPENED_ONLINE = 'Account Opened Online';
  public static final String AddDelInd = 'A';
  public static final String GenDPApplID = 'DP';
  public static final String GenSDBApplID = 'SB';
  public static final String DUMMY_ACCT_NUMBER = '9999999999';
  public static final Integer FULL_NAME_LENGTH = 40;
  public static final Integer CUST_NAME_LENGTH = 26;
  public static final Integer CUST_NAME_LENGTH_1 = 24;
  public static final String MINOR_UTMA = '- Minor Utma';
  public static final String CUSTODIAN = '- Custodian';
  public static final String DPFedTaxId = 'S';
  public static final String DPFedWithholdingInd = '4';
  public static final String SAVINGS_STAT_CODES = '2';
  public static final String CHECKING_STAT_CODES = '2A';
  public static final String STATUS_CODE_A = 'A';
  public static final String STATUS_CODE_2 = '2';
  public static final Integer NEW_ACCOUNT_EXCEPTION_PLAN_CODE = 100;
  public static final Integer DPNmeAndAddrTyp = 1;
  public static final String DPCIRqstInd = 'Y';
  public static final String MBPASS_DUMMY_CUSTOMER_NUMBER = '99999999999';
  public static final String CINmeAddrLneCde01 = 'N';
  public static final String PrimaryApplicant = 'P';
  public static final String SecondaryApplicant = 'S';
  public static final String SOLE_OWNER = 'SOLE_OWNER';
  public static final String SOLE_OWNER_RELN_CODE = '000';
  public static final String CustodianProduct_PrimaryRelation = 'UTMA';
  public static final String CustodianProduct_JointRelation = 'CUSTODIAN';
  public static final String JOINT_RELATION = 'JOINT_OR';
  public static final String DPLogTyp = 'L';
  public static final Integer DPTxnCde = 629;
  public static final String DPTDTxnTyp = 'N';
  public static final String DLDR_TXN_OPERATOR_OVERRIDE = '2';
  public static final String DLDR_OVERRIDE_CODES = '2052';
  public static final String DPTDTermInd = 'MONTH';

  public static String ErrorMessage = '';
  public static final String FUNDING_HOLD_FAILED = 'Funding Hold Failed';
  public static final String FUNDING_HOLD_COMP = 'Funding Hold Completed';
  public static final String ADD_BENEFICIARY = 'Add Beneficiaries';
  public static final String ADD_BENEFICIARY_FAILURE = 'Add Beneficiaries Failure';
  public static final String ADD_BENEFICIARY_COMPLETED = 'Add Beneficiaries Completed';
  public static final String ADD_BENEFICIARY_FLOW = 'Add Beneficiaries';
  public static final String CREATE_CUSTOMER_DUE_DILIGENCE = 'Create Customer Due Diligence';
  public static final String CREATE_CUSTOMER_DUE_DILIGENCE_FLOW = 'Create Customer Due Diligence';
  public static final String CREATE_CUSTOMER_DUE_DILIGENCE_FAILURE = 'Create Customer Due Diligence Failure';
  public static final String CREATE_CUSTOMER_DUE_DILIGENCE_SUCCESS = 'Create Customer Due Diligence Success';
  public static final String CREATE_CUSTOMER_DUE_DILIGENCE_COMPLETED = 'Create Customer Due Diligence Completed';

  public static final String checkingAndSavingFundMBPass = 'DepositOnlineDollarTransaction';
  public static final String certificateFundMBPass = 'DepositNewCertificateOfDeposit';

  public static final String IRA_ENQUIRY = 'IRA';
  public static final String HSA_ENQUIRY = 'HSA';
  public static final String IRA_EXISTING_PLAN = 'Get Existing IRA Plan';
  public static final String IRA_PLAN_DETAILS = 'Fetch Plan Details';
  public static final String IRA_BENEFICIARY = 'Fetch IRA Beneficiary';
  public static final String IRA_CREATE_PLAN = 'Create Retirement Plan';
  public static final String IRA_UPDATE_PLAN = 'Update Retirement Plan';
  public static final String IRA_NEW_BENEFICIARY = 'Create IRA Beneficiary';
  public static final String HSA_NEW_BENEFICIARY = 'Create HSA Beneficiary';

  public static final String APP_PROCESS = 'Application Processing API: ';

  public static final String FUNDINGHOLD = 'Funding Hold';
  public static final String LOANHOLD = 'Loan Hold';
  public static final Boolean DEFAULT_TRUE = true;

  public static final String DBT_TYPE = 'DEBIT_CARD';
  public static final String ESTMT_TYPE = 'ESTATEMENTS';
  public static final String ADDON_OLB_TYPE = 'ONLINE_BANKING';
  public static final List<String> ADDON_SERVICE_PENDING_STATUS_LIST = new List<String>{ 'PENDING', 'FAILURE' };
  public static final List<String> ACCT_OPEN_STATUS_LIST = new List<String>{ 'ACCOUNT_OPENED', 'FUNDED' };
  public static final String DEBIT_CARDNO_GEN_SUCCESS = 'Debit Card No generation Success';
  public static final String DEBIT_CARDNO_GEN_FAILURE = 'Debit Card No generation Failed';
  public static final String DEBIT_CARDNO_GEN = 'Debit Card Number Generation - ';
  public static final String DEBIT_CARD_CREATION = 'Debit Card Creation - ';
  public static final String MULTI_ACCOUNT_DEBIT_CARD_CREATION = 'Multiple Account Debit Card Creation - ';
  public static final String DEBIT_CARD_CREATION_SUCCESS = 'Debit Card Creation Success';
  public static final String DEBIT_CARD_CREATION_FAILURE = 'Debit Card Creation Failed';
  public static final String DEBIT_CARD_ACCRELATION = 'Debit Card Relationship - ';
  public static final String DEBIT_CARD_ACCRELATION_SUCCESS = 'Debit Card Customer to Account Relation Success';
  public static final String DEBIT_CARD_ACCRELATION_FAILURE = 'Debit Card Customer to Account Relation Failed';
  public static final String DEBIT_CARD_DEMOGRAPHICS = 'DEBIT_CARD_DEMOGRAPHICS';
  public static final String DEBIT_CARD_DEMOGRAPHICS_SUCCESS = 'Debit Card customer demographics Success';
  public static final String DEBIT_CARD_DEMOGRAPHICS_FAILURE = 'Debit Card customer demographics Failed';
  public static final String DEBIT_CARD_ISSUE = 'Debit Card Issuance - ';
  public static final String DEBIT_CARD_SUCCESS = 'Card Base Integration Success';
  public static final String DEBIT_CARD_FAILURE = 'Card Base Integration Failure';
  public static final String ESTMT_REG = 'ESTMT_REGISTRATION';
  public static final String ESTMT_REG_SUCCESS = 'E-Statement Registration Success';
  public static final String ESTMT_REG_FAILED = 'E-Statement Registration Failed';
  //public static final Integer BATCH_RETRY_COUNT = 5;
  public static final List<String> FAILED_APP_STATUS = new List<String>{ 'FUNDED', 'APPROVED', 'ACCOUNT_OPENED' };
  public static final String KYC_APPROVED_STATUS = 'APPROVED';
  public static final String ACHFUNDHOLD_FAIL_STATUS = 'FAILURE';
  public static final String PENDING_MANUAL_VERIFICATION = 'PENDING_MANUAL_VERIFICATION';
  public static final String DCARDNOGEN_API_NAME = 'Debit Card No generation';
  public static final String DCARDCREATION_API_NAME = 'Debit Card Creation';
  public static final String MULTI_ACC_DCARDCREATION_API_NAME = 'Multiple Account Debit Card Creation';
  public static final String DCARDACCRELATION_API_NAME = 'Debit Card Customer to Account Relation';
  public static final String DCARDCUSTDEMOGRAPHICS_API_NAME = 'Debit Card Customer Demographics';
  public static final String CEB_ENROLLMENT = 'CEB Enrollment-';
  public static final String SEARCH_CUSTOMER = 'Search Customer';
  public static final String CHEX_SYSTEMS = 'ChexSystem';
  public static final String FETCH_OOW_QUESTIONS = 'Fetch OOW Questions ';
  public static final String VERIFY_OOW_QUESTIONS = 'Verify OOW Questions ';
  public static final String DO_IDV_VERIFICATION = 'Do IDV Verification ';
  public static final String FETCH_OOW_QUESTIONS_SUCCESS = 'Fetch OOW Questions Success';
  public static final String VERIFY_OOW_QUESTIONS_SUCCESS = 'Verify OOW Questions Success';
  public static final String DO_IDV_VERIFICATION_SUCCESS = 'Do IDV Verification Success';
  public static final String FETCH_OOW_QUESTIONS_FAILURE = 'Fetch OOW Questions Failure';
  public static final String VERIFY_OOW_QUESTIONS_FAILURE = 'Verify OOW Questions Failure';
  public static final String DO_IDV_VERIFICATION_FAILURE = 'Do IDV Verification Failure';
  public static final String CEB_ENROLLMENT_SUCCESS = 'CEB Enrollment Success';
  public static final String CEB_ENROLLMENT_FAILURE = 'CEB Enrollment Failed';
  public static final String CUSTOMER_API_INQUIRES = 'API Inquires';
  public static final String OLB_CHECK = 'OLB Enrolment Check';
  public static final String TXN_SEC_IND = '2';
  public static final String DP_OVERRIDE_INFO = '2047052';
  public static final String CUSTOMER_VALIDATION = 'Customer Validation';
  public static final String CUSTOMER_AUTH = 'MDM-Customer Authentication';
  public static final String CUSTOMER = 'Customer';
  public static final String MDM_FETCH_CUST_INFO = 'MDM - Fetch Customer Information';

  //MX
  public static final String MXINTEGRATION = 'MX Integration';
  public static final String MX = 'MX';
  public static final String CREATEUSER = 'Create User';
  public static final String GENERATEURL = 'Generate Url';
  public static final String GETAPITOKEN = 'Get Api Token';
  public static final String GETSESSIONTOKEN = 'Get Session Token';
  public static final String CHECKVERIFICATIONSTATUS = 'Verification Status';
  public static final String FETCHIAVACCOUNTS = 'Fetch IAV Account';
  public static final String READIAVACCOUNTS = 'Read IAV Account';
  public static final String FETCHMICRODEPOSITACCOUNTS = 'Fetch MicroDeposit Account';

  public static final Integer FM_TRANSFER_INCREMENT = 100;
  public static final String FMBALANCETYPE = 'H';
  public static final String FM_MIN_TRANSFER_TYPE = 'M';
  public static final String FM_DEFICIT_TRANSFER_SEQ_NBR = '001';
  public static final String RECEIVING_ACC_SYS_CODE = 'DP';
  public static final String FM_ORDER_B = '01';
  public static final String FM_SYSTEM_CODE = 'DP';

  public static final String ELAVONPREAUTH = 'Elavon PreAuth';
  public static final String ELAVON = 'Elavon';
  public static final String SESSION_TOKEN = 'Session Token';
  public static final String CCDELETE = 'ccdelete';
  public static final String APPROVAL_CCCOMPLETE = 'Elavon Approval-CCComplete';
  public static final String OD_FOR_STANDARD_ADDON_TYPE = 'OD_PROTECTION_STANDARD';
  public static final Integer OD_FOR_STANDARD_ADDON_EXCPPLNNBR = 915;

  public static final String OD_DEFICIT_TRANSFER = 'OD DEFICIT TRANSFER';
  public static final String OD_DEFICIT_TRANSFER_SUCCESS = 'OD Deficit Transfer Success';
  public static final String OD_DEFICIT_TRANSFER_FAILURE = 'OD Deficit Transfer Failure';

  public static final String OD_DEFICIT_TRANSFER_TYPE = 'OVERDRAFT_PROTECTION';
  public static final String OD_ATM_TRANSFER_TYPE = 'OD_PROTECTION_ATM';
  public static final String OD_ATM_TRANSFER = 'OD PROTECTION ATM';
  public static final String OD_ATM_Y = 'OD_PROTECTION_ATM_Y';
  public static final String OD_ATM_N = 'OD_PROTECTION_ATM_N';
  public static final String OD_PROTECTION_ATM_SUCCESS = 'OD Protection ATM Success';
  public static final String OD_PROTECTION_ATM_FAILURE = 'OD Protection ATM Failure';

  public static final String INTERNAL_SOURCE_FUNDING = 'Internal Source Funding';
  public static final String INTERNAL_DESTINATION_FUNDING = 'Internal Destination Funding';

  //MDM
  public static final String CREATE_ACCOUNT_MDM = 'MDM - Account Upload';
  public static final String CREATE_CUSTOMER_MDM = 'MDM - Customer Upload';
  public static final String UPDATE_CUSTOMER_MDM = 'MDM - Customer Update';
  public static final String IMMEDIATE_TRANSFER = 'Immediate Transfer';
  public static final String MDM_DATE_FORMAT = 'yyyy-MM-dd';

  public static final String REGISTER_ONLINE_BANKING = 'Register Online Banking';
  public static final String REGISTER_ONLINE_BANKING_COMPLETED = ' OLB Registration Completed';
  public static final String REGISTER_ONLINE_BANKING_FAILED = ' OLB Registration Failed';

  public static final String UPDATED_CUSTOMER_INFORMATION = 'Update Customer Information';
  public static final String UPDATED_CUSTOMER_INFORMATION_FLOW = 'Update Customer Information';
  public static final String UPDATED_CUSTOMER_INFORMATION_FAILURE = 'Update Customer Information Failure';
  public static final String UPDATED_CUSTOMER_INFORMATION_SUCCESS = 'Update Customer Information Success';
  public static final String UPDATED_CUSTOMER_INFORMATION_COMPLETED = 'Update Customer Information Completed';
  public static final String INDIVIDUAL_DEMOGRAPHICS = 'CI017';
  public static final String ORGANIZATION_DEMOGRAPHICS = 'CI037';
  public static final Integer EMBOSSED_NAME_LENGTH = 26;
  public static final String EMPLOYMENT_TYPE = 'EmploymentType';
  public static final String IDENTITY_TYPE = 'IdentificationType';
  public static final Integer MAX_ALLOWED_FILE_SIZE = 10 * 1024 * 1024;

  public static final String DEBIT_CARD_EXPEDITE = 'Debit Card Expedite';
  public static final String DEBIT_CARD_DO_SUCCESS = 'Debit Card DO Success';
  public static final String DEBIT_CARD_DO_FAILURE = 'Debit Card DO Failed';
  public static final String DEBIT_CARD_DO = 'DEBIT_CARD_DO';
  public static final String DEBIT_CARD_EXPEDITE_SUCCESS = 'Debit Card Expedite Delivery Success';
  public static final String DEBIT_CARD_EXPEDITE_FAILURE = 'Debit Card Expedite Delivery Failed';

  public static final String DCARDDEPOSITE_ORIGINATION_API_NAME = 'Deposite Origination';
  public static final String DCARDEXPEDITEDELIVERY_API_NAME = 'Debit Card Expedite Delivery';

  public static Map<String, string> empCodeMDMToTF = new Map<String, String>{
    'P' => 'PARTTIME',
    'F' => 'FULLTIME',
    'R' => 'RETIRED',
    'U' => 'UNEMPLOYED'
  };

  public static Map<String, string> occCodeMDMToTF = new Map<String, String>{
    '8' => '027',
    'A' => '027',
    'B' => '027',
    'D' => '027',
    'E' => '027',
    'F' => '027',
    'H' => '026',
    'M' => '027',
    'O' => '027',
    'P' => '027',
    'R' => '027',
    'S' => '023',
    'U' => '027',
    'X' => '027'
  };

  public static Integer DLR_TRANSACTION_RETRY = 3;
  public static Integer IMMEDIATE_TRANSFER_RETRY = 3;

  public static Map<String, String> IDENTITY_MDM_TO_TF_MAP = new Map<String, String>{
    'DL' => 'DL',
    'GC' => 'GreenCard',
    'ST' => 'StateID',
    'PPT' => 'Passport',
    'FPPT' => 'ForeignPassport',
    'STDNT' => 'StudentID',
    'MNR' => 'Minor',
    'MTR' => 'Matricula',
    'USIMV' => 'UsImmigrationVisa',
    'ED' => 'Elderly/Disabled',
    'TRBL' => 'TribalID',
    'PW' => 'PhotoWorkID',
    'VR' => 'VoterRegistration',
    'MCC' => 'MajorCreditCard',
    'SSI' => 'SelectiveServiceID',
    'IC' => 'InsuranceCard',
    'TPVR' => '3rdPartyReport',
    'FI20' => 'ForeignExStud'
  };

  public static Map<String, String> NATIONAL_IDENTITY_MDM_TO_TF_MAP = new Map<String, String>{
    'S' => 'SSN',
    'T' => 'TIN',
    'F' => 'FOR',
    'N' => 'NONE'
  };
  public static Map<String, String> BUSINESS_NATIONAL_IDENTITY_MDM_TO_TF_MAP = new Map<String, String>{
    'S' => 'SSN',
    'T' => 'TIN',
    'F' => 'EIN',
    'N' => 'NONE'
  };

  public static String SUFFIX = 'Suffix';

  public static String ACCOUNT_NBR_GENERATION = 'Account Number Generation';
  public static String ACCOUNT_NBR_GENERATION_SUCCESS = 'Account Number Generation Success';
  public static String ACCOUNT_NBR_GENERATION_FAILURE = 'Account Number Generation Failure';
  public static String ACCOUNT_NBR_GENERATION_COMPLETED = 'Account Number Generation Completed';
  //FISCCIntegrationConstants
  public static Integer HTTP_CALLOUT_LIMIT_APP_CREATION = 90;
  public static Integer DO_APPLICANT_LIMIT = 6;
  public static Integer CUSTOMER_CREATION_LIMIT = 20;
  public static Integer CUSTOMER_RELN_LIMIT = 10;
  public static String CUST_ACC_PRIMARY_RELN = '901';
  public static String CUST_ACC_SECONDARY_RELN = '902';
  public static String BENEF_RELN_CODE = '411';

  public static String CUST_RELN_ADAPTERCONFIG = 'CustomerAccountReln';

  public static String ALIAS = 'Alias';
  public static String FETCH_ALIAS = 'Fetch Customer Alias';
  public static String DELETE_ALIAS = 'Delete Customer Alias';
  public static String CUSTOMER_ALIAS = 'Customer Alias';
  public static String CUSTOMER_INFORMATION = 'Update Customer Information';
  public static String ALIAS_API_CALL_SUCCESS = 'SUCCESS';
  public static String ALIAS_API_CALL_FAILURE = 'FAILURE';

  public static List<String> SAFE_DEPOSIT_PROD_CATEGORY = new List<String>{ 'SAFE_DEPOSIT_BOX', 'BUSINESS_SAFE_DEPOSIT_BOX' };
  public static List<String> CERTIFICATE_PROD_CATEGORY = new List<String>{ 'CERTIFICATE', 'BUSINESS_CERTIFICATE' };
  public static List<String> CONSUMER_PROD_CATEGORY = new List<String>{
    'CHECKING',
    'SAVINGS',
    'CERTIFICATE',
    'CREDIT_CARD',
    'MORTGAGE',
    'IRA',
    'HSA',
    'MONEY_MARKET'
  };
  public static List<String> BUSINESS_PROD_CATEGORY = new List<String>{
    'BUSINESS_CHECKING',
    'BUSINESS_SAVINGS',
    'BUSINESS_CERTIFICATE',
    'BUSINESS_CREDIT_CARD',
    'BUSINESS_IRA',
    'BUSINESS_MONEY_MARKET'
  };

  public static String IRA_PRODUCT_CATEGORY = 'IRA';
  public static String HSA_PRODUCT_CATEGORY = 'HSA';
  public static List<String> FIS_BENEFICIARY_RESTRICTED_CATEGORY = new List<String>{ 'HSA', 'IRA' };

  public static String BRANCH = 'BRANCH';

  public static final String SVCID_IndividualDemographics = 'CI017';
  public static final String CREATE_BUSINESS_ENTITY = 'Create Business and Owners';
  public static final String CREATE_BUSINESS_ENTITY_RELN = 'Create Business and Owners Reln';
  public static final String ORGANIZATION = 'ORGANIZATION';
  public static final String INDIVIDUAL = 'INDIVIDUAL';
  public static final String CUST_TO_CUST_RELN_ADAPTERCONFIG = 'CustToCustReln';
  public static final String DEPUTY = 'DEP';

  public static final String INT_PHN_NBR = 'International Phone Number';
  public static final String CUST = 'Customer';

  public static final String MDM_SEARCH_INQUIRY = 'MDM - Customer Search';
  public static final String FIS_SEARCH_INQUIRY = 'FIS - Customer Search';
  public static final String FIS_CUSTOMER_FETCH = 'FIS - Customer Fetch';
  public static final String CUSTOMER_SEARCH = 'Customer Search';
  public static final Integer INDIVIDUAL_INQUIRY_PAGE_SIZE = 10;
  public static final Integer INDIVIDUAL_INQUIRY_MAX_RECORDS = 1000;
  public static final String STARTER_CHECK = 'STARTER CHECK';

  public static final String MDM_IND_CUSTOMER_INQUIRY = 'MDM Individual Customer Inquiry';
  public static final String MDM_BUSINESS_CUSTOMER_INQUIRY = 'MDM Business Customer Inquiry';
  public static final String BUSINESS_CUSTOMER_INQUIRY = 'Business Customer Inquiry';
  public static final Integer BUSINESS_CUSTOMER_INQUIRY_PAGE_SIZE = 10;
  public static final Integer BUSINESS_CUSTOMER_INQUIRY_MAX_RECORDS = 1000;

  public static final String BUSINESS_CUSTOMER_DETAILS_INQUIRY = 'Business Customer Details Inquiry';

  public static final String FIS_FETCH_PHONE_NBR = 'FIS-FetchPhoneNbr';
  public static final String FIS_FETCH_EMAIL_ADDR = 'FIS-FetchEmailAddress';
  public static final String FIS_KEYWORD_API = 'MultiKeywords API';

  public static Map<String, string> STATUSCODE_KEYWORD_MAP = new Map<String, String>{
    'A' => 'PWAEXP',
    'T' => 'PWTEXP',
    'Y' => 'PWYEXP',
    'F' => 'SPFEXP',
    'G' => 'SPGEXP',
    'H' => 'SPHEXP',
    'E' => 'STEEXP',
    'I' => 'STIEXP',
    'J' => 'STJEXP',
    'K' => 'STKEXP',
    'L' => 'STLEXP',
    'M' => 'STMEXP',
    'Q' => 'STQEXP',
    'R' => 'STREXP',
    'S' => 'STSEXP',
    'U' => 'STUEXP',
    'V' => 'STVEXP',
    'W' => 'STWEXP',
    'X' => 'STXEXP',
    '0' => 'ST0EXP',
    '1' => 'ST1EXP',
    '2' => 'ST2EXP',
    '3' => 'ST3EXP',
    '4' => 'ST4EXP',
    '5' => 'ST5EXP',
    '6' => 'ST6EXP',
    '7' => 'ST7EXP',
    '8' => 'ST8EXP',
    '9' => 'ST9EXP'
  };

  public static final String PARTY_UPDATE_COMPLETED = 'COMPLETED';
  public static final String PARTY_UPDATE_REQUIRED = 'REQUIRED';
  public static final String PARTY_UPDATE_FAILED = 'FAILED';
  public static final String IOLTA = 'IOLTA';
  public static final String IBRETA = 'IBRETA';
  public static final String TAX_ID_TYPE_F = 'F';
  public static final String IOLTA_IBRETA_TRANSFERACCOUNT = 'IOLTAIBRETATransferAccount';

  public static String FETCH_DUE_DILIGENCE_DEMOGRAPHICS = 'Fetch Due Diligence Demographics';

  public static Map<String, string> INTEREST_FREQ = new Map<String, String>{ 'MONTHLY' => 'M', 'DAILY' => 'D', 'ANNUALLY' => 'C' };

  public static Map<String, string> INTEREST_PAYOUT = new Map<String, String>{
    'COMPOUND' => 'A',
    'ACH' => 'X',
    'INTERNAL_TRANSFER' => 'T'
  };

  public static String ALLOWED_PURPOSE_DEBIT_CARD = 'DEBIT_CARD';

  public static String CDD_QUESTION_ACH_LABEL = 'Will this account send or receive ACH transactions?';
  public static String CDD_QUESTION_ACH_CODE = 'ACHTransactions';
  public static String CDD_QUESTION_ISMSB_LABEL = 'Does this business qualify as a Money Service Business (MSB)';
  public static String CDD_QUESTION_ISMSB_CODE = 'ISMSB';
  public static String TEST_BANK_CARD_BINCODE = '99519841';

  public static Map<String, String> SDB_BILLING_CODE_MAP = new Map<String, String>{
    'AUTO_DEBIT' => 'A',
    'BANK_BOX' => 'B',
    'PRINT_INVOICE' => 'I',
    'WAIVE_FEE' => 'W'
  };

  public static String APY_ACCOUNTOPENING_INFO = 'APY and Account opening info';
  public static String APY_INFO = 'APY_INFO';
  public static String ACCOUNT_OPENING_INFO = 'ACCOUNT_OPENING_INFO';

  public static Map<String, String> ORG_IDENTIFICATION_MAP = new Map<String, String>{
    'ASSUMED_NAME_CERT' => 'ANC',
    'ARTICLES_OF_INCORPORATION' => 'AI',
    'ARTICLES_OF_ORGANIZATION' => 'AO',
    'CERT_OF_LIMITED_PARTNERSHIP' => 'CLP'
  };

  public static String CHECK_ORDER = 'CHECK_ORDER';
  public static String ACCOUNT_PREF_LOG = 'Account Preference ';
}