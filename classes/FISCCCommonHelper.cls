public inherited sharing class FISCCCommonHelper {
  public static void setFISBranchAndCostCenter(List<tffa__Application__c> appList, List<tffa__Party__c> partyList) {
    try {
      tffa__Submission__c sub = appList[0].tffa__submission__r;
      tffa__Brand__c brandObj = FISCCIntegrationLogRepository.findBrandwithBrandCode(sub.tffa__Brand__c).get(0);
      String costCenterBranch = brandObj.DefaultLocation__r.FISBranchCode__c;
      Boolean isURLFISBranchPresent = false;
      String partyCostCenter;
      String partyBranch;
      if (String.isNotBlank(sub.FISBranchCode__c)) {
        partyBranch = sub.FISBranchCode__c;
        List<tffa__Location__c> locationList = FISCCIntegrationLogRepository.findLocationByBrandAndBranch(
          sub.tffa__Brand__c,
          sub.FISBranchCode__c
        );
        if (locationList != null && locationList.size() > 0) {
          partyCostCenter = locationList.get(0).CostCenter__c;
          isURLFISBranchPresent = true;
        }
      }
      if (!isURLFISBranchPresent) {
        partyBranch = brandObj.DefaultLocation__r.FISBranchCode__c;
        partyCostCenter = brandObj.DefaultLocation__r.CostCenter__c;
      }

      for (tffa__Party__c party : partyList) {
        if (!party.tffa__IsExistingCustomer__c) {
          party.FISBranchCode__c = partyBranch;
          party.CostCenter__c = partyCostCenter;
        }
      }

      for (tffa__Application__c app : appList) {
        try {
          if (app.tffa__Product__r != null && String.isNotBlank(app.tffa__Product__r.DefaultFISBranchCode__c)) {
            app.FISBranchCode__c = app.tffa__Product__r.DefaultFISBranchCode__c;

            if (
              app.tffa__Product__r.UseDefaultBranchCostCenter__c ||
              (!app.tffa__Product__r.UseDefaultBranchCostCenter__c && !isURLFISBranchPresent)
            ) {
              costCenterBranch = app.tffa__Product__r.DefaultFISBranchCode__c;
            } else if (isURLFISBranchPresent) {
              costCenterBranch = sub.FISBranchCode__c;
            }
          } else if (isURLFISBranchPresent) {
            //--- Branch code is in Submission Only
            app.FISBranchCode__c = sub.FISBranchCode__c;
            costCenterBranch = sub.FISBranchCode__c;
          } else {
            //--- Pick the default branch code from Brand/Charter
            app.FISBranchCode__c = brandObj.DefaultLocation__r.FISBranchCode__c;
          }
          List<tffa__Location__c> location = FISCCIntegrationLogRepository.findLocationByBrandAndBranch(
            sub.tffa__Brand__c,
            costCenterBranch
          );
          if (location != null && location.size() > 0) {
            app.CostCenter__c = location.get(0).CostCenter__c;
          } else {
            app.CostCenter__c = brandObj.DefaultLocation__r.CostCenter__c;
          }
        } catch (Exception ex) {
          tffa.Logger.debug(
            'Exception in FISCCCommonHelper.setBranchCodeAndCostCenter for application  :::' +
            app.Id +
            ' ' +
            ex.getMessage() +
            ex.getStackTraceString()
          );
          app.FISBranchCode__c = brandObj.DefaultLocation__r.FISBranchCode__c;
          app.CostCenter__c = brandObj.DefaultLocation__r.CostCenter__c;
        }
      }
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in FISCCCommonHelper.setBranchCodeAndCostCenter   :::' + ex.getMessage() + ex.getStackTraceString());
      throw ex;
    }
  }

  public static String encrypt(String value) {
    Blob encryptionKey = EncodingUtil.base64Decode(FISCCIntegrationLogService.charterConfig.EncryptionKey__c);
    Blob initializationVector = Blob.valueOf('123' + String.valueOf(System.currentTimeMillis()));
    String encodedInitializationVector = base64UrlEncode(initializationVector);
    Blob encryptedBlob = Crypto.encrypt('AES256', encryptionKey, initializationVector, Blob.valueOf(value));
    String encryptedValue = encodedInitializationVector + '.' + base64UrlEncode(encryptedBlob);
    return encryptedValue;
  }

  public static String base64UrlEncode(Blob value) {
    String encodedValue = EncodingUtil.base64Encode(value).replace('+', '-').replace('/', '_');
    while (true) {
      if (encodedValue.endsWith('=')) {
        encodedValue = encodedValue.removeEnd('=');
      } else {
        break;
      }
    }
    return encodedValue;
  }

  public static boolean validateStandardODAddOn(tffa__Application__c application) {
    tffa__AccountPreference__c accPref = new tffa__AccountPreference__c();
    List<tffa__AccountPreference__c> accPrefList = new List<tffa__AccountPreference__c>();

    /* 
      Fetch account preferences from application and check if OD_FOR_STANDARD_TRANSACTIONS Add On is present
      If yes, check tffa__Enabled__c flag
        If true -> Opted for OD_FOR_STANDARD_TRANSACTIONS Add On
        If false -> Opted out of OD_FOR_STANDARD_TRANSACTIONS Add On
    */
    accPrefList = application.tffa__AccountPreferences__r;
    for (Integer i = 0; i < accPrefList.size(); i++) {
      accPref = accPrefList.get(i);
      if (FISCCIntegrationConstants.OD_FOR_STANDARD_ADDON_TYPE.equals(accPref.tffa__AddOnServiceType__c)) {
        if (accPref.tffa__Enabled__c) {
          return false;
        } else {
          return true;
        }
      }
    }

    /*
      If OD_FOR_STANDARD_TRANSACTIONS Add On is not present in account preferences, resolve Add On check list based on application id
      If OD_FOR_STANDARD_TRANSACTIONS Add On is present in checklist, customer has opted out of the add on service
    */
    //Map<String, Object> facts = new Map<String, Object>();
    //facts.put('Application__c', application.id);

    List<tffa__AddOnServiceItem__c> addOnServiceItemList = FISCCIntegrationLogRepository.findAddOnServiceItem(
      application.tffa__Product__c,
      FISCCIntegrationConstants.OD_FOR_STANDARD_ADDON_TYPE
    );
    if (!addOnServiceItemList.isEmpty()) {
      return true;
    }
    return false;
  }
}