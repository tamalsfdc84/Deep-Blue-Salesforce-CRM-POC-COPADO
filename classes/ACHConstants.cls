public with sharing class ACHConstants {
  public static final String FILE_HEADER_RECORD_TYPE_CODE = '1';
  public static final String BATCH_HEADER_RECORD_TYPE_CODE = '5';
  public static final String ENTRY_DETAIL_RECORD_TYPE_CODE = '6';
  public static final String ADDENDA_RECORD_TYPE_CODE = '7';
  public static final String BATCH_CONTROL_RECORD_TYPE_CODE = '8';
  public static final String FILE_CONTROL_RECORD_TYPE_CODE = '9';

  //Funding Status
  public static final String FUNDING_IN_PROGRESS = 'IN_PROGRESS';
  public static final String FUNDING_HOLD_APPLIED = 'HOLD_APPLIED';

  //Constants for ACHFileHeaderRecord fields
  public static final String FIELD_PRIORITY_CODE = '01';
  public static final String FIELD_RECORD_SIZE = '094';
  public static final String FIELD_BLOCKING_FACTOR = '10';
  public static final String FIELD_FORMAT_CODE = '1';
  public static final String FIELD_REF_CODE = 'FUNDING';

  //Constants for ACHBatchHeaderRecord fields
  public static final String FIELD_SETTLEMENT_DATE = '   '; // 3 blank spaces
  public static final String FIELD_ORIGINATOR_STATUSCODE = '1';
  public static final String FIELD_SERVICECODE_DEBITS = '225';
  public static final String FIELD_SERVICECODE_CREDIT = '220';
  public static final String FIELD_SERVICECODE_MIXEDTXNS = '200';
  public static final String FIELD_ENTRY_CLASS_CODE = 'WEB';
  //public static final String FIELD_ACH_ENTRY_CLASS_DESC = String.isNotBlank(achConfigs.ACH_Description__c) ? achConfigs.ACH_Description__c : 'FUNDING';
  //public static final String FIELD_SDV_ENTRY_CLASS_DESC = String.isNotBlank(achConfigs.SDV_Description__c) ? achConfigs.SDV_Description__c : 'VALIDATION';
  public static final String FIELD_ORIG_STATUS_CODE = '1';
  public static final Integer ADDITIONAL_DAYS_FOR_EFFECTIVE_DATE = 0;

  //Constants for ACHEntryDetailRecords
  public static final String FIELD_PAYMENTTYPECODE = 'S'; //S indicates single entry payment
  public static final String FIELD_ADDEDNDA_RECORD_INDICATOR = '0'; // set to 0 if addenda rec not present else 1

  public static final String TXN_CODE_CHECKING_CREDIT = '22';
  public static final String TXN_CODE_CHECKING_DEBIT = '27';

  public static final String TXN_CODE_SAVINGS_CREDIT = '32';
  public static final String TXN_CODE_SAVINGS_DEBIT = '37';

  //Constants for ACHAddendaRecords
  //Addenda code type 05 used for CCD, CTX and PPD standard entry classes.
  //The Addenda information contains additional payment related information.
  public static final String ADDENDA_CODE_TYPE_CDD_PDD_CTX = '05';

  public static final Integer RECORD_SIZE = 94;
  public static final String PADSTR_ALPHANUMFIELD = ' ';
  public static final String PADSTR_NUMFIELD = '0';
  public static final String ACH_NEWLINE_CHAR = '\r\n';
  public static final String ACH_EOF_CHAR = '\r'; // IF EOF character is not required set it to ''

  public static final String FUNDING_ACCOUNT_TYPE_SAVINGS = 'SAVINGS';
  public static final String FUNDING_ACCOUNT_TYPE_CHECKINGS = 'CHECKING';
  public static final String TXN_TYPE_DEBIT = 'D';
  public static final String TXN_TYPE_CREDIT = 'C';

  public static final String STATUS_APP_ACH_INITIAL_STATE = 'I';
  public static final String STATUS_APP_ACH_PICKED_FOR_PROCESS = 'P';
  public static final String STATUS_APP_ACH_SUCCESS = 'S';

  public static final String ACH_FILETYPE_DEBIT = 'D';
  public static final String ACH_FILETYPE_CREDIT = 'C';

  public static final String MSG_NO_REC_PRESENT = 'File does not contain any record';

  public static final String FILE_TYPE_SDV = 'SDV';
  public static final String FUNDED = 'FUNDED';
  public static final String FILE_TYPE_ACH = 'ACH';
  public static final Integer NUMBER_OF_DAYS = 3;
  public static final String DATE_FORMAT_EEEE = 'EEEE';

  public static final String SUNDAY = 'Sunday';

  public static final String SATURDAY = 'Saturday';
  public static final Map<String, String> TXN_CODEMAP = new Map<String, String>{
    FUNDING_ACCOUNT_TYPE_SAVINGS +
    '_' +
    TXN_TYPE_DEBIT => TXN_CODE_SAVINGS_DEBIT,
    FUNDING_ACCOUNT_TYPE_SAVINGS +
    '_' +
    TXN_TYPE_CREDIT => TXN_CODE_SAVINGS_CREDIT,
    FUNDING_ACCOUNT_TYPE_CHECKINGS +
    '_' +
    TXN_TYPE_DEBIT => TXN_CODE_CHECKING_DEBIT,
    FUNDING_ACCOUNT_TYPE_CHECKINGS +
    '_' +
    TXN_TYPE_CREDIT => TXN_CODE_CHECKING_CREDIT
  };

  public static final List<String> TXN_CODES_DEBIT = new List<String>{ TXN_CODE_CHECKING_DEBIT, TXN_CODE_SAVINGS_DEBIT };
  public static final List<String> TXN_CODES_CREDIT = new List<String>{ TXN_CODE_CHECKING_CREDIT, TXN_CODE_SAVINGS_CREDIT };

  public static final String SDV_URLPARAM = 'sdvId=';
  public static final String SDV_URLPARAM_ENCODING = 'UTF-8';

  public static final Integer MAX_SDV_COUNT = 3;
}