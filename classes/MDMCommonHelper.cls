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
    if (
      product.tffa__Category__c == 'CERTIFICATE' ||
      product.tffa__Category__c == 'BUSINESS_CERTIFICATE' ||
      (String.isNotBlank(product.tffa__AllowedInvestmentAccountType__c) &&
      product.tffa__AllowedInvestmentAccountType__c.contains('CERTIFICATE'))
    ) {
      return 'C';
    } else if (product.IsNowProduct__c || product.tffa__Category__c == 'HSA') {
      return 'N';
    } else if (product.tffa__Category__c == 'CHECKING' || product.tffa__Category__c == 'BUSINESS_CHECKING') {
      return 'D';
    } else if (
      product.tffa__Category__c == 'MONEY_MARKET' ||
      product.tffa__Category__c == 'BUSINESS_MONEY_MARKET' ||
      (String.isNotBlank(product.tffa__AllowedInvestmentAccountType__c) &&
      product.tffa__AllowedInvestmentAccountType__c.contains('MONEY_MARKET'))
    ) {
      return 'M';
    } else if (
      product.tffa__Category__c == 'SAVINGS' ||
      product.tffa__Category__c == 'BUSINESS_SAVINGS' ||
      (String.isNotBlank(product.tffa__AllowedInvestmentAccountType__c) &&
      product.tffa__AllowedInvestmentAccountType__c.contains('SAVINGS'))
    ) {
      return 'S';
    }
    return '';
  }

  public static String getaddressType(String type) {
    return 'PRIM';
  }

  public static String getEmploymentType(String type) {
    if (type == 'FULLTIME' || type == 'SALARIED' || type == 'SELF_EMPLOYED' || type == 'MILITARY') {
      return 'F'; //Full Time
    } else if (type == 'PARTTIME') {
      return 'P'; //Part Time
    } else if (type == 'RETIRED') {
      return 'R'; // Retired
    } else if (type == 'UNEMPLOYED' || type == 'STUDENT' || type == 'HOMEMAKER') {
      return 'U'; // Unemployed
    } else if (type == 'CONTRACTOR') {
      return 'T'; // Temp Employment
    }

    return 'U';
  }

  public static String getTaxIdType(String type) {
    if (type == 'SSN') {
      return 'S';
    } else if (type == 'TIN') {
      return 'T';
    } else if (type == 'EIN') {
      return 'F';
    } else if (type == 'NONE' || type == 'FOR') {
      return 'N';
    }

    return 'N';
  }

  public static String getMDMIdentificationType(String tfIdentityType) {
    Set<String> mdmIdentityTypeSet = FISCCIntegrationConstants.IDENTITY_MDM_TO_TF_MAP.keySet();
    for (String mdmIdentityType : mdmIdentityTypeSet) {
      if (FISCCIntegrationConstants.IDENTITY_MDM_TO_TF_MAP.get(mdmIdentityType) == tfIdentityType) {
        return mdmIdentityType;
      }
    }
    return '';
  }
}