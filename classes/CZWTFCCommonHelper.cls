public inherited sharing class CZWTFCCommonHelper {
  public static String[] to19 = new List<string>{
    'zero',
    'one',
    'two',
    'three',
    'four',
    'five',
    'six',
    'seven',
    'eight',
    'nine',
    'ten',
    'eleven',
    'twelve',
    'thirteen',
    'fourteen',
    'fifteen',
    'sixteen',
    'seventeen',
    'eighteen',
    'nineteen'
  };
  public static String[] tens = new List<string>{ 'twenty', 'thirty', 'forty', 'fifty', 'sixty', 'seventy', 'eighty', 'ninety' };
  public static String[] denom = new List<string>{
    '',
    'thousand',
    'million',
    'billion',
    'trillion',
    'quadrillion',
    'quintillion',
    's!xtillion',
    'septillion',
    'octillion',
    'nonillion',
    'decillion',
    'undecillion',
    'duodecillion',
    'tredecillion',
    'quattuordecillion',
    's!xdecillion',
    'septendecillion',
    'octodecillion',
    'novemdecillion',
    'vigintillion'
  };

  public static tffa__Party__c getPrimaryParty(tffa__Submission__c subObj, List<tffa__party__c> partyObjList) {
    for (tffa__SubmissionPartyXref__c subPartyXref : subObj.tffa__PartyXrefs__r) {
      if (subPartyXref.tffa__Primary__c) {
        for (tffa__Party__c partyObj : partyObjList) {
          if ((subPartyXref.tffa__Party__c).equals(partyObj.Id)) {
            return partyObj;
          }
        }
      }
    }
    return partyObjList[0];
  }

  public static String formatPhoneNumber(String phone) {
    return phone.replace('+1', '');
  }

  public static String getFormattedFullName(String firstName, String middleName, String lastName, String suffix, Integer maxLength) {
    String strFullName = firstName + ' ' + (String.isEmpty(middleName) ? '' : middleName + ' ') + lastName;
    if (!String.isBlank(suffix)) {
      maxLength = maxLength - suffix.length() - 1;
    }

    if (strFullName.length() > maxLength) {
      strFullName = firstName + ' ' + (String.isEmpty(middleName) ? '' : middleName.left(1) + ' ') + lastName;
    }
    if (strFullName.length() > maxLength) {
      strFullName = firstName + ' ' + lastName;
    }
    if (strFullName.length() > maxLength) {
      strFullName = firstName.left(1) + ' ' + (String.isEmpty(middleName) ? '' : middleName.left(1) + ' ') + lastName;
    }
    if (strFullName.length() > maxLength) {
      strFullName = firstName + ' ' + (String.isEmpty(middleName) ? '' : middleName.left(1) + ' ') + lastName.left(1);
    }
    if (strFullName.length() > maxLength) {
      strFullName = (firstName + ' ' + (String.isEmpty(middleName) ? '' : middleName + ' ') + lastName).substring(0, maxLength);
    }
    if (!String.isBlank(suffix)) {
      strFullName = strFullName + ' ' + suffix;
    }
    return strFullName;
  }

  public static String trimString(String value, Integer length) {
    if (String.isNotBlank(value) && value.length() > length) {
      return value.substring(0, length);
    } else {
      return value;
    }
  }

  public static String generateUUID() {
    Blob b = Crypto.GenerateAESKey(128);
    String hexCode = EncodingUtil.ConvertTohex(b);
    String uuid =
      hexCode.SubString(0, 8) +
      '-' +
      hexCode.SubString(8, 12) +
      '-' +
      hexCode.SubString(12, 16) +
      '-' +
      hexCode.SubString(16, 20) +
      '-' +
      hexCode.substring(20);
    return uuid;
  }

  public static String getIdentificationLabel(String value) {
    List<Schema.PicklistEntry> picklistEntries = Schema.SObjectType.tffa__Identification__c.fields.tffa__Type__c.getPicklistValues();

    if (picklistEntries != null) {
      for (Schema.PicklistEntry ple : picklistEntries) {
        if ((ple.getValue()).equalsIgnoreCase(value)) {
          return ple.getLabel();
        }
      }
    }
    return '';
  }

  public static String getIdentificationIssueCountryLabel(String value) {
    List<Schema.PicklistEntry> picklistEntries = Schema.SObjectType.tffa__Identification__c.fields.tffa__IssuingCountry__c.getPicklistValues();

    if (picklistEntries != null) {
      for (Schema.PicklistEntry ple : picklistEntries) {
        if ((ple.getValue()).equalsIgnoreCase(value)) {
          return ple.getLabel();
        }
      }
    }
    return '';
  }

  /**
   * Returns matched party
   */
  public static tffa__Party__c fetchParty(tffa__ApplicationPartyXref__c appPartyObj, List<tffa__Party__c> partyLst) {
    for (tffa__Party__c partyObj : partyLst) {
      if (appPartyObj.tffa__Party__c == partyObj.Id) {
        return partyObj;
      }
    }
    return null;
  }

  /**
   * returns tffa__Address__c
   */
  public static tffa__Address__c getPartyAddressByType(List<tffa__PartyAddressXref__c> partyAddressLst, String addressType) {
    for (tffa__PartyAddressXref__c partyAdd : partyAddressLst) {
      if (partyAdd.tffa__Type__c == addressType) {
        return partyAdd.tffa__Address__r;
      }
    }
    return null;
  }

  public static tffa__Party__c getAppPrimaryParty(tffa__Application__c appObj, List<tffa__party__c> partyObjList) {
    for (tffa__ApplicationPartyXref__c appPartyXref : appObj.tffa__PartyXrefs__r) {
      if (appPartyXref.tffa__Primary__c) {
        for (tffa__Party__c partyObj : partyObjList) {
          if ((appPartyXref.tffa__Party__c).equals(partyObj.Id)) {
            return partyObj;
          }
        }
      }
    }
    for (tffa__ApplicationPartyXref__c appPartyXref : appObj.tffa__PartyXrefs__r) {
      if (appPartyXref.tffa__Primary__c) {
        for (tffa__Party__c partyObj : FISCCIntegrationLogService.partyObjMap.values()) {
          if ((appPartyXref.tffa__Party__c).equals(partyObj.Id)) {
            return partyObj;
          }
        }
      }
    }
    return partyObjList[0];
  }

  /**
   * To Check if all cust and benef are created in FIS IBS
   */
  public static boolean checkCustomerCreationCompleted(tffa__Application__c appObj) {
    tffa.Logger.debug('In checkCustomerCreationCompleted Id: ' + appObj.Id + ' Name: ' + appObj.Name);
    try {
      for (tffa__ApplicationPartyXref__c appPartyXrefObj : appObj.tffa__PartyXrefs__r) {
        if (FISCCIntegrationLogService.partyObjMap.containsKey(appPartyXrefObj.tffa__Party__c)) {
          if (String.isBlank(FISCCIntegrationLogService.partyObjMap.get(appPartyXrefObj.tffa__Party__c).Customer_Number__c)) {
            return false;
          }
        }
      }
      for (tffa__Beneficiary__c benef : appObj.tffa__Beneficiaries__r) {
        if (
          !FISCCIntegrationConstants.FIS_BENEFICIARY_RESTRICTED_CATEGORY.contains(appObj.tffa__ProductCategory__c) &&
          String.isBlank(benef.Customer_Number__c)
        ) {
          return false;
        }
      }
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in checkCustomerCreationCompleted ' + ex.getLineNumber() + ' ' + ex.getMessage());
      return false;
    }
    return true;
  }

  /**
   * To Check if all cust and benef reln are created in FIS IBS
   */
  public static boolean checkCustomerAccRelnCompleted(tffa__Application__c appObj) {
    tffa.Logger.debug('In checkCustomerAccRelnCompleted Id: ' + appObj.Id + ' Name: ' + appObj.Name);
    try {
      for (tffa__ApplicationPartyXref__c appPartyXrefObj : appObj.tffa__PartyXrefs__r) {
        if (!appPartyXrefObj.CZFisRelnshipCreated__c) {
          return false;
        }
      }
      for (tffa__Beneficiary__c benef : appObj.tffa__Beneficiaries__r) {
        if (
          !FISCCIntegrationConstants.FIS_BENEFICIARY_RESTRICTED_CATEGORY.contains(appObj.tffa__ProductCategory__c) &&
          !benef.CZFisRelnshipCreated__c
        ) {
          return false;
        }
      }
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in checkCustomerAccRelnCompleted ' + ex.getLineNumber() + ' ' + ex.getMessage());
      return false;
    }
    return true;
  }

  /**
   * To Check if acc nbr needs to be created in FIS IBS.
   */
  public static boolean checkAcctNbrCreationCompleted(List<tffa__Application__c> appObjLst) {
    tffa.Logger.debug('In checkAcctNbrCreationCompleted');
    try {
      for (tffa__Application__c appObj : appObjLst) {
        if (
          String.isBlank(appObj.tffa__AccountNumber__c) &&
          appObj.tffa__KYCDecisionOutcome__c != 'DECLINED' &&
          !FISCCIntegrationConstants.SAFE_DEPOSIT_PROD_CATEGORY.contains(appObj.tffa__ProductCategory__c) &&
          FISCCIntegrationConstants.ALLOWED_PURPOSE_DEBIT_CARD != appObj.tffa__AccountPurpose__c
        ) {
          return false;
        }
      }
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in checkCustomerCreationCompleted ' + ex.getLineNumber() + ' ' + ex.getMessage());
      return false;
    }
    return true;
  }

  public static String getOccupationLabel(String value) {
    List<Schema.PicklistEntry> picklistEntries = Schema.SObjectType.tffa__Employment__c.fields.OccupationType__c.getPicklistValues();

    if (picklistEntries != null) {
      for (Schema.PicklistEntry ple : picklistEntries) {
        if ((ple.getValue()).equalsIgnoreCase(value)) {
          return ple.getLabel();
        }
      }
    }
    return '';
  }

  public static boolean checkAliasCreated(Map<Id, tffa__Party__c> partyLst) {
    tffa.Logger.debug('Check if Alias Creation in IBS in completed for all parties');
    for (tffa__Party__c partyObj : partyLst.values()) {
      if (
        !partyObj.tffa__IsExistingCustomer__c &&
        String.isNotBlank(partyObj.Customer_Number__c) &&
        !partyObj.CZAllAliasCreated__c &&
        partyObj.CZPartyAliases__r != null &&
        !partyObj.CZPartyAliases__r.isEmpty()
      ) {
        return false;
      }
    }
    return true;
  }

  public static boolean checkInternationalPhnCreated(List<tffa__Party__c> partyList) {
    tffa.Logger.debug('Check if international phn nbrs are created in IBS in completed');
    boolean flag = true;
    for (tffa__Party__c partyObj : partyList) {
      if (
        String.isNotBlank(partyObj.CZInternationalPhoneNumber__c) &&
        !partyObj.CZIntPhnNbrCreated__c &&
        partyObj.tffa__Type__c == 'INDIVIDUAL' &&
        String.isNotBlank(partyObj.Customer_Number__c)
      ) {
        flag = false;
      } else if (!partyObj.CZIntPhnNbrCreated__c && String.isBlank(partyObj.CZInternationalPhoneNumber__c)) {
        partyObj.CZIntPhnNbrCreated__c = true;
      }
    }
    return flag;
  }

  public static boolean checkBusinessAndOwnerCreated(Map<Id, tffa__Party__c> partyMp, boolean checkBusiness, boolean checkOwner) {
    tffa.Logger.debug('Check if Business Creation and Owner in IBS in completed');
    for (tffa__Party__c partyObj : partyMp.values()) {
      if (partyObj.tffa__Type__c == FISCCIntegrationConstants.ORGANIZATION) {
        if (checkBusiness && String.isBlank(partyObj.Customer_Number__c)) {
          return false;
        }
        if (checkOwner && partyObj.tffa__PartyXrefs__r != null && !partyObj.tffa__PartyXrefs__r.isEmpty()) {
          for (tffa__PartyPartyXref__c partyPartyObj : partyObj.tffa__PartyXrefs__r) {
            if (
              partyMp.containsKey(partyPartyObj.tffa__RelatedParty__c) &&
              String.isBlank(partyMp.get(partyPartyObj.tffa__RelatedParty__c).Customer_Number__c)
            ) {
              return false;
            }
          }
        }
      }
    }
    return true;
  }

  public static tffa__Party__c fetchBusinessParty(List<tffa__Party__c> partyLst) {
    tffa.Logger.debug('Check if Alias Creation in IBS in completed for all parties');
    for (tffa__Party__c partyObj : partyLst) {
      if (partyObj.tffa__Type__c == FISCCIntegrationConstants.ORGANIZATION) {
        return partyObj;
      }
    }
    return null;
  }

  public static boolean checkMailingAddPresent(tffa__Party__c partyObj) {
    if (partyObj.tffa__AddressXrefs__r.size() > 1) {
      return true;
    }
    return false;
  }

  public static boolean checkCustToCustRelnCreated(Map<Id, tffa__Party__c> partyLst) {
    tffa.Logger.debug('Check if Business Creation and Owner reln in IBS in completed');
    for (tffa__Party__c partyObj : partyLst.values()) {
      if (partyObj.tffa__Type__c == FISCCIntegrationConstants.ORGANIZATION && !partyObj.tffa__IsExistingCustomer__c) {
        if (!partyObj.CZOwnerRelnCompleted__c && partyObj.tffa__PartyXrefs__r != null && !partyObj.tffa__PartyXrefs__r.isEmpty()) {
          return false;
        }
      }
    }
    return true;
  }

  public static Boolean requiresEmailNotification(tffa__EventConfiguration__mdt config) {
    return config.tffa__EmailTemplateAlt__c != null;
  }

  public static tffa.NotificationDTO createEmailNotification(tffa__EventConfiguration__mdt cfg) {
    tffa.NotificationDTO notif = new tffa.NotificationDTO();
    notif.template = cfg.tffa__EmailTemplateAlt__c;
    notif.orgWideEmailAddress = cfg.tffa__DefaultSenderEmailAddressAlt__c;
    notif.saveEmailAsActivity = cfg.tffa__SaveEmailAsActivity__c;
    if (String.isNotBlank(cfg.tffa__DefaultCCEmailAddress__c)) {
      notif.addCCEmailRecipient(cfg.tffa__DefaultCCEmailAddress__c);
    }
    if (String.isNotBlank(cfg.tffa__DefaultBCCEmailAddress__c)) {
      notif.addBCCEmailRecipient(cfg.tffa__DefaultBCCEmailAddress__c);
    }
    if (String.isNotBlank(cfg.tffa__DefaultReceiverEmailAddress__c)) {
      notif.addEmailRecipient(cfg.tffa__DefaultReceiverEmailAddress__c);
    }
    // if (String.isNotBlank(cfg.DefaultReplyToEmailAddress__c)) {
    //   notif.replyToEmailAddress = cfg.DefaultReplyToEmailAddress__c;
    // }
    return notif;
  }

  public static Boolean isUserId(Id id) {
    return id != null && id.getSObjectType() == User.sObjectType; // Dereferenced_Field False Positive: User cannot be null
  }

  public static Boolean requiresAppNotification(tffa__EventConfiguration__mdt config) {
    return config.tffa__AppNotificationTemplate__c != null;
  }

  public static tffa.NotificationDTO createAppNotification(tffa__EventConfiguration__mdt cfg) {
    tffa.NotificationDTO notif = new tffa.NotificationDTO();
    notif.template = cfg.tffa__AppNotificationTemplate__c;
    // notif.type = cfg.tffa__AppNotificationType__c;
    return notif;
  }

  /**
   * @description convert number to words
   * @param Long number
   * @return String
   */
  public static String numberToWord(String amount) {
    try {
      return getNumberInWords(Long.valueOf(amount));
    } catch (Exception e) {
      tffa.Logger.debug('Exception in numberToWords ' + e.getStackTraceString() + e.getMessage() + e.getLineNumber());
    }
    return '';
  }

  public static String getNumberInWords(Long val) {
    if (val < 100) {
      return convertNumberLessThen100(val.intValue());
    }
    if (val < 1000) {
      return convertNumberLessThen1000(val.intValue());
    }
    for (integer v = 0; v < denom.size(); v++) {
      Integer didx = v - 1;
      Integer dval = (Integer) Math.pow(1000, v);
      if (dval > val) {
        Integer mod = (Integer) Math.pow(1000, didx);
        Integer l = (Integer) val / mod;
        Integer r = (Integer) val - (l * mod);
        String ret = convertNumberLessThen1000(l) + ' ' + denom[didx];
        if (r > 0) {
          ret += ' ' + getNumberInWords(r);
        }
        return ret;
      }
    }
    return 'Should never get here, bottomed out in english_number';
  }

  // convert a value < 100 to English.
  public static String convertNumberLessThen100(integer val) {
    if (val < 20) {
      return to19[val];
    }
    if (val == 100) {
      return 'One Hundred';
    }
    for (integer v = 0; v < tens.size(); v++) {
      String dcap = tens[v];
      integer dval = 20 + 10 * v;
      if (dval + 10 > val) {
        if (Math.Mod(val, 10) != 0)
          return dcap + ' ' + to19[Math.Mod(val, 10)];
        return dcap;
      }
    }
    return 'Should never get here, less than 100 failure';
  }

  // convert a value < 1000 to english, special cased because it is the level that kicks
  // off the < 100 special case. The rest are more general. This also allows you to
  // get strings in the form of "forty-five hundred" if called directly.
  public static String convertNumberLessThen1000(integer val) {
    String word = '';
    integer rem = val / 100;
    integer mod = Math.mod(val, 100);
    if (rem > 0) {
      word = to19[rem] + ' hundred';
      if (mod > 0) {
        word += ' ';
      }
    }
    if (mod > 0) {
      word += convertNumberLessThen100(mod);
    }
    return word;
  }

  public static Boolean isCertificateProduct(tffa__Application__c application) {
    if (application.tffa__Product__r == null) {
      return false;
    }

    if (application.tffa__Product__r.tffa__Category__c == null) {
      return false;
    }

    if (
      application.tffa__Product__r.tffa__Category__c.contains(CZWTFCConstants.CERTIFICATE) ||
      (application.tffa__Product__r.tffa__AllowedInvestmentAccountType__c != null &&
      application.tffa__Product__r.tffa__AllowedInvestmentAccountType__c.contains(CZWTFCConstants.CERTIFICATE))
    ) {
      return true;
    }
    return false;
  }

  public static String getTaxIdType(String type) {
    if (type == 'SSN') {
      return 'S';
    } else if (type == 'TIN') {
      return 'T';
    } else if (type == 'FOR' || type == 'EIN') {
      return 'F';
    } else if (type == 'NONE') {
      return 'N';
    }

    return '';
  }

  // Method used to capitalize the first letter
  public static String formatName(String name) {
    String result = '';
    if (name != null && name != '') {
      for (String iter : name.split('[ ]+')) {
        if (iter != null && iter != '') {
          if (iter.length() > 1) {
            result += iter.substring(0, 1).toUpperCase() + iter.substring(1, iter.length()) + ' ';
          } else {
            result += iter.substring(0, 1).toUpperCase() + ' ';
          }
        }
      }
      result = result.substring(0, result.length() - 1);
    }
    return result;
  }

  public static String formatToCamelCase(String name) {
    String result = '';

    if (name == null) {
      return result;
    }

    for (String iter : name.split('[ ]+')) {
      if (iter != null && iter != '') {
        result += iter.substring(0, 1).toUpperCase() + iter.substring(1, iter.length()).toLowercase() + ' ';
      }
    }
    return result;
  }

  public static String formatAmount(Decimal amount) {
    if (amount == null) {
      return '0.00';
    }

    List<String> args = new List<String>{ '0', 'number', '###,###,##0.00' };
    String formatedAmount = String.format(amount.format(), args);

    String[] part = formatedAmount.split('\\.');
    if (part.size() == 1) {
      formatedAmount = formatedAmount + '.00';
    }

    if(part.size() > 1){
      String part2 = part[1];
      if(part2.length() == 1){
      formatedAmount = formatedAmount + '0';
      }
    }

    return formatedAmount;
  }

  // MM/dd/yyyy
  public static String formatDate(Date inputDate) {
    Datetime inputDateTime = Datetime.newInstance(inputDate, Time.newInstance(0, 0, 0, 0));

    return inputDateTime.format(CZDocusignConstants.DOCUMENT_STANDARD_DATE_FORMAT);
  }

  public static String formatDate(Date inputDate, String formatString) {
    if (formatString.equals(FISCCIntegrationConstants.MDM_DATE_FORMAT)) {
      return inputDate.year() +
        '-' +
        String.valueOf(inputDate.month()).leftPad(2, '0') +
        '-' +
        String.valueOf(inputDate.day()).leftPad(2, '0');
    } else if (formatString.equals('MM-dd')) {
      return String.valueOf(inputDate.month()).leftPad(2, '0') + '-' + String.valueOf(inputDate.day()).leftPad(2, '0');
    } else {
      return inputDate.format();
    }
  }

  public static String fetchTermUnitSuffix(Decimal termUnit) {
    if (termUnit != 1) {
      return 's';
    }

    return '';
  }
}