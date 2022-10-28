public with sharing class CZWTFCConstants {
  public static final String ACCOUNT_OPENED = 'ACCOUNT_OPENED';
  public static final String FUNDED = 'FUNDED';
  public static final String DECLINED = 'DECLINED';
  public static final String APPROVED = 'APPROVED';
  public static final String ABANDONED = 'ABANDONED';
  public static final String CANCELLED = 'CANCELLED';
  public static final String SAVED = 'SAVED';
  public static final String COUNTER_OFFER = 'COUNTER_OFFER';
  public static final String REVIEW = 'REVIEW';
  public static final String FAILED = 'FAILED';
  public static final Map<String, String> SUFFIX_MAP = new Map<String, String>{
    'SR' => 'Sr',
    'sr' => 'Sr',
    'SR.' => 'Sr',
    'sr.' => 'Sr',
    'Sr.' => 'Sr',
    'JR' => 'Jr',
    'jr' => 'Jr'
  };

  public static final String PROCESS_STATUS_FAILURE = 'FAILURE';
  public static final String PROCESS_STATUS_NOT_APPLICABLE = 'NA';
  public static final String PROCESS_STATUS_PENDING = 'PENDING';
  public static final String PROCESS_STATUS_SUCCESS = 'SUCCESS';
  public static final String PROCESS_STATUS_IN_PROGRESS = 'IN_PROGRESS';

  public static final String FILE_TRANSFER_SUCCESS = 'Success';
  public static final String FILE_TRANSFER_FAILURE = 'Failure';

  public static final String ADDON_STATUS_FAILED = 'FAILED';
  public static final String ADDON_STATUS_COMPLETED = 'COMPLETED';

  public static final String ACCOUNT_NOT_FOUND = 'ACCOUNT DETAILS NOT FOUND';

  public static final String SUBMITTED = 'SUBMITTED';

  public static final String DIGITAL = 'DIGITAL';
  public static final String BRANCH = 'BRANCH';

  public static final String FUNDING_TYPE_ACH = 'ACH';
  public static final String FUNDING_TYPE_BRANCH = 'CASH';
  public static final String FUNDING_TYPE_WIRE = 'WIRE';
  public static final String DEBIT_CARD = 'DEBIT_CARD';

  public static final String NO_ACCOUNT_DETAILS = 'We were unable to retrieve your account information. Please click Verify Account and Search for a different financial institution. If you don’t have a secondary relationship, please save your application and visit one of our branches.';

  public static final List<String> CC_TRANS_DEL_APP_STATUS = new List<String>{ 'CANCELLED', 'EXPIRED', 'DECLINED' };

  public static final String CC_TRANS_DEL_FUND_TYPE = 'DEBIT_CARD';

  public static final String APPROVAL = 'APPROVAL';

  public static final String REVERSED = 'REVERSED';
  public static final String REVERSAL_FAILED = 'REVERSAL_FAILED';
  public static final String REVERSAL_NOT_REQ = 'REVERSAL_NOT_REQ';

  public static final List<String> CCDEL_FUND_STATUS = new List<String>{ 'REVERSAL_FAILED', 'IN_PROGRESS' };

  public static Map<String, string> disclosureLabelMap = new Map<String, String>{
    'TAXPAYER_DISCLOSURE_POINT_2' => '2. I am not subject to backup withholding because: (a) I am exempt from backup withholding, or (b) I have not been notified by the Internal Revenue Service (IRS) that I am subject to backup withholding as a result of a failure to report all interest or dividends, or (c) the IRS has notified me that I am no longer subject to backup withholding (Notice: if you are subject to backup withholding please visit a branch in order to continue your application), and'
  };

  public static Map<String, string> disclosureNameMap = new Map<String, String>{
    'Submission_ReviewAndSubmit' => 'Tax Identification',
    'Application_Funding' => 'EFT Consent Agreement',
    'AccountDetails_OD' => 'OD Protection Disclosure'
  };
  public static final String NON_TIERED = 'NT';

  public static final String INTERNAL_TRANSFER = 'INTERNAL_TRANSFER';
  public static final String INTERNAL_TRANSFER_SOURCE = 'INTERNAL_TRANSFER_SOURCE';
  public static final String INTERNAL_TRANSFER_DESTINATION = 'INTERNAL_TRANSFER_DESTINATION';

  public static final String ANNUAL_PERCENTAGE_YIELD = 'Annual percentage yield';
  public static final String PERCENTAGE = '%';
  public static final String DOLLAR = '$';
  public static final String LINE_BRK = ';<br/>';

  public static final String CITIZEN = 'Citizen';
  public static final String RESIDENT = 'Resident';
  public static final String NONRESIDENT = 'NonResident';
  public static final String CERTIFICATE = 'CERTIFICATE';
  public static final String BUSINESS_CERTIFICATE = 'BUSINESS_CERTIFICATE';
  public static final String IRA = 'IRA';
  public static final String HSA = 'HSA';
  public static final String CHECKING = 'CHECKING';
  public static final String MONEY_MARKET = 'MONEY_MARKET';
  public static final String SAVINGS = 'SAVINGS';

  public static String INTERNAL_TRANSFER_CD = 'INTERNAL_TRANSFER_CD';
  public static String ACH_FUND_DESC_ONE = 'Acct Fund ACH';
  public static String DEBIT_CARD_DESC_ONE = 'Acct Fund Dbt Card';
  public static String CD_SAME_CHARTER_DESC = 'Acct Fund Trnsfr';

  public static string REINITIATE_DOCUSIGN = 'reinitiate';

  public static string STARTER_CHECK = 'STARTER_CHECK';
  public static Integer STARTER_CHECK_START_NUMBER = 501;
  public static Integer STARTER_CHECK_COUNT = 6;

  public static final String BANK_BOX = 'BANK_BOX';
  public static final String PRINT_INVOICE = 'PRINT_INVOICE';
  public static final String WAIVE_FEE = 'WAIVE_FEE';
  public static final String DOCUSIGN = 'DOCUSIGN';
  public static final String COMPLETED = 'Completed';
  public static final String SCHEDULE2 = 'Schedule2';
  public static final String SCHEDULE1 = 'Schedule1';
  public static final String SIGNCARDADDENDUMBUS_CODE = 'SIGNCARDADDENDUMBUS';
  public static final String SIGNCARDADDENDUMCUS_CODE = 'SIGNCARDADDENDUMCUS';

  public static final String CHARTER_BRANCH_NOT_SELECTED_ERROR_MESSAGE = 'Please Select a Charter and Branch, then Press Save to Continue';

  public static final String INVALID_LOCATION = 'Please Select a Valid Branch';

  public static final String SIGNING_COMPLETED = 'SIGNING_COMPLETED';

  public static final String FUNDING_TYPE_CHECK = 'CHECK';
}