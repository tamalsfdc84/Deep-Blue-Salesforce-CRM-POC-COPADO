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
  public static final String DEPOSIT_ORIGINATOR_COMPLETED = 'Account Opening Completed';
  public static final String DEPOSIT_ORIGINATOR = 'DepositOriginator';

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
    'dueDiligenceDemographics' => 'due-diligence-demographics',
    'racfpass' => 'racf-password',
    'deficitTransferSenderLst' => 'deficit-transfers-sendersLst',
    'defTransfer' => 'deficit-transfers-new',
    'FCMUploadDate' => 'date',
    'immediatetransfers' => 'immediate-transfers',
    'immediatetransfers' => 'immediate-transfers',
    'individualDemographics' => 'individual-demographics',
    'custPhoneNumber' => 'phone-numbers',
    'phoneNumLst' => 'phone-numbersLst'
  };

  public static final String SVCID_CustomerEmail = 'CI044';
  public static final String SVCID_CreateCustomer = 'CI007';
  public static final String SVCID_MBPASS = 'MBPASS';
  public static final String SVCID_DepositAccountNumber = 'DLANG';
  public static final String SVCID_NewDepositAccount = 'DLNEW';
  public static final String SVCID_DepositNameAddress = 'DLNAM';
  public static final String SVCID_CustomerAccount = 'CI009';
  public static final String SVCID_DLDLR = 'DLDLR';
  public static final String SVCID_CertDeposit = 'DLTNC';

  public static final String REMARK_IDENTITY = 'S';
  public static final Integer REMARK_MONTHS_TO_ADD = 6;
  public static final String ACCOUNT_OPENED_ONLINE = 'Account Opened Online';
  public static final String AddDelInd = 'A';
  public static final String GenDPApplID = 'DP';
  public static final String DUMMY_ACCT_NUMBER = '9999999999';
  public static final Integer FULL_NAME_LENGTH = 40;
  public static final Integer CUST_NAME_LENGTH = 26;
  public static final String MINOR_UTMA = '- Minor Utma';
  public static final String CUSTODIAN = '- Custodian';
  public static final String DPFedTaxId = 'S';
  public static final String DPFedWithholdingInd = '4';
  public static final String SAVINGS_STAT_CODES = '2';
  public static final String CHECKING_STAT_CODES = '2A';
  public static final Integer NEW_ACCOUNT_EXCEPTION_PLAN_CODE = 100;
  public static final Integer DPNmeAndAddrTyp = 1;
  public static final String DPCIRqstInd = 'Y';
  public static final String MBPASS_DUMMY_CUSTOMER_NUMBER = '99999999999';
  public static final String CINmeAddrLneCde01 = 'N';
  public static final String PrimaryApplicant = 'P';
  public static final String SecondaryApplicant = 'S';
  public static final String SOLE_OWNER = '000';
  public static final String CustodianProduct_PrimaryRelation = '403';
  public static final String CustodianProduct_JointRelation = '404';
  public static final String JOINT_RELATION = '022';
  public static final String DPLogTyp = 'L';
  public static final Integer DPTxnCde = 629;
  public static final String DPTDTxnTyp = 'N';
  public static final String DLDR_TXN_OPERATOR_OVERRIDE = '2';
  public static final String DLDR_OVERRIDE_CODES = '2052';
  public static final String DPTDTermInd = 'M';

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

  public static final String FUNDINGHOLD = 'Funding Hold';
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
  public static final String CUSTOMER = 'Customer';

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
  public static final Integer EMBOSSED_NAME_LENGTH = 26;
  public static final String EMPLOYMENT_TYPE = 'EmploymentType';
  public static final String IDENTITY_TYPE = 'IdentificationType';
  public static final Integer MAX_ALLOWED_FILE_SIZE = 10 * 1024 * 1024;

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
    'ST' => 'StateID'
  };
  public static String SUFFIX = 'Suffix';
}