public inherited sharing class FISCCApplicationConstants {
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
  public static final Integer APPLICATION_PROCESSING_COMPLETED = 0;
  public static final Integer IN_PROGRESS_APPLICATION = 1;
  public static final Integer ACC_OPENING_FAILED_CODE = 10;
  public static final Integer HOLD_FAILED_CODE = 11;
  public static final Integer DEBIT_ISSUANCE_FAILED_CODE = 12;
  public static final Integer ESTMT_REGN_FAILED_CODE = 13;

  public static Map<String, String> requestStrFilterArg = new Map<String, String>{
    'RequestType' => '__type',
    'dummyPhoneNumber' => 'Number'
  };
}