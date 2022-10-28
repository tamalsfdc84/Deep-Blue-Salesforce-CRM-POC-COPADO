public inherited sharing class CZWTFCCommonHelper {
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
}