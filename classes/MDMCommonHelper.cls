public with sharing class MDMCommonHelper {
  public static final Boolean IS_SANDBOX = tffa__EnvironmentConfiguration__c.getOrgDefaults().tffa__IsSandbox__c;
  public static final String TEST_BANK_CODE = '889';

  public static String getBrandCode(String brandCode) {
    if (IS_SANDBOX)
      return TEST_BANK_CODE;
    else
      return brandCode;
  }

  public static String getProductTypeCode(tffa__Product__c product) {
    if (product.tffa__Category__c == 'CERTIFICATE') {
      return 'C';
    } else if (product.tffa__Category__c == 'CHECKING' && product.IsNowProduct__c) {
      return 'N';
    } else if (product.tffa__Category__c == 'CHECKING') {
      return 'D';
    } else if (product.tffa__Category__c == 'SAVINGS' && product.IsMoneyMarketProduct__c) {
      return 'M';
    } else if (product.tffa__Category__c == 'SAVINGS') {
      return 'S';
    }
    return '';
  }
}