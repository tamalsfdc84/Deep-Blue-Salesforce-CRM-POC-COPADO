public with sharing class CZWTFCPurgeSubmissionHelper {
  @TestVisible
  private static boolean calledFromTestCls = false;

  public static List<tffa__Submission__c> getPurgeSub() {
    WintrustEnvConfig__mdt wintrustEnvConfig = CZWTFCHelperRepository.fetchWintrustEnvConfig();

    Date currentDate = system.today();
    Integer dateToAdd = Integer.valueOf(wintrustEnvConfig.PurgeSubmission__c) * -1;
    Date updatedDate = currentDate.addDays(dateToAdd); // sub

    List<String> subsToDelete = new List<String>();
    List<String> subIdList = CZWTFCSubmissionRepository.getPurgeSubIds();
    if (Test.isRunningTest() && calledFromTestCls) {
      List<tffa__Submission__c> subTest = CZWTFCSubmissionRepository.findtestSubmission();
      subIdList.add(subTest[0].Id);
    }

    List<tffa__Submission__c> subAppList = new List<tffa__Submission__c>();

    if (subIdList != null && !subIdList.isEmpty()) {
      subAppList = CZWTFCSubmissionRepository.findSubmissionAndAppByIds(subIdList);
      if (subAppList != null && !subAppList.isEmpty()) {
        for (tffa__Submission__c sub : subAppList) {
          boolean canBeDeleted = true;
          if (sub.tffa__Applications__r != null && !sub.tffa__Applications__r.isEmpty()) {
            for (tffa__Application__c app : sub.tffa__Applications__r) {
              if (app.Lastmodifieddate > updatedDate) {
                canBeDeleted = false;
              }
            }
          }
          if (canBeDeleted) {
            subsToDelete.add(sub.Id);
          }
        }
      }
    }

    return CZWTFCSubmissionRepository.findSubmissionForPurge(subsToDelete);
  }

  public static void deletePartyAndItsChildObj(tffa__Submission__c sub) {
    List<IntegrationLog__c> integrationLogList = new List<IntegrationLog__c>();
    List<IntegrationLogItem__c> integrationLogItemList = new List<IntegrationLogItem__c>();
    List<tffa__Party__c> partyList = new List<tffa__Party__c>();
    List<tffa__PartyAddressXref__c> partyAddressList = new List<tffa__PartyAddressXref__c>();
    List<tffa__Address__C> addressList = new List<tffa__Address__C>();
    List<tffa__Identification__c> identificationList = new List<tffa__Identification__c>();
    List<tffa__Employment__c> employemntList = new List<tffa__Employment__c>();
    List<tffa__Stipulation__c> stipulationList = new List<tffa__Stipulation__c>();
    List<tffa__AdditionalPreference__c> additionalPrefList = new List<tffa__AdditionalPreference__c>();

    List<String> partyIdList = new List<String>();

    List<String> idList = new List<String>();
    idList.add(sub.Id);

    if (sub.tffa__PartyXrefs__r != null && !sub.tffa__PartyXrefs__r.isEmpty()) {
      for (tffa__SubmissionPartyXref__c subParty : sub.tffa__PartyXrefs__r) {
        partyIdList.add(subParty.tffa__Party__c);
      }
    }

    integrationLogList = FISCCIntegrationLogRepository.findLogsBySubmissionId(sub.Id);
    if (integrationLogList != null) {
      for (IntegrationLog__c intLog : integrationLogList) {
        if (intLog.IntegrationLogs__r != null) {
          integrationLogItemList.addAll(intLog.IntegrationLogs__r);
        }
      }
    }

    List<tffa__Party__c> partyObjList = FISCCIntegrationLogRepository.findPartydWithChildObjects(partyIdList);

    if (partyObjList != null && !partyObjList.isEmpty()) {
      for (tffa__Party__c partyObj : partyObjList) {
        //partyObj
        partyList.add(partyObj);
        idList.add(partyObj.Id);

        //party address
        if (partyObj.tffa__AddressXrefs__r != null && !partyObj.tffa__AddressXrefs__r.isEmpty()) {
          for (tffa__PartyAddressXref__c partyAdd : partyObj.tffa__AddressXrefs__r) {
            partyAddressList.add(partyAdd);
            if (partyAdd.tffa__Address__r != null) {
              addressList.add(partyAdd.tffa__Address__r);
            }
          }
        }

        //identification
        if (partyObj.tffa__Identifications__r != null && !partyObj.tffa__Identifications__r.isEmpty()) {
          identificationList.addAll(partyObj.tffa__Identifications__r);
        }

        // Employment
        if (partyObj.tffa__Employments__r != null && !partyObj.tffa__Employments__r.isEmpty()) {
          for (tffa__Employment__c emp : partyObj.tffa__Employments__r) {
            employemntList.add(emp);
            if (emp.tffa__Address__r != null) {
              addressList.add(emp.tffa__Address__r);
            }
          }
        }

        List<tffa__Stipulation__c> tempStipulationList = new List<tffa__Stipulation__c>();
        List<tffa__AdditionalPreference__c> tempAdditionalPrefList = new List<tffa__AdditionalPreference__c>();

        //stipulation  find
        tempStipulationList = CZWTFCHelperRepository.findStipByParty(partyObj.Id);
        stipulationList.addAll(tempStipulationList);

        //additional Pref
        tempAdditionalPrefList = CZWTFCHelperRepository.findAdditionalPrefByParty(partyObj.Id);
        additionalPrefList.addAll(tempAdditionalPrefList);
      }
    }

    if (integrationLogItemList != null && !integrationLogItemList.isEmpty()) {
      CZWTFCHelperRepository.removeIntegrationItemLogs(integrationLogItemList);
    }
    if (integrationLogList != null && !integrationLogList.isEmpty()) {
      CZWTFCHelperRepository.removeIntegrationLogs(integrationLogList);
    }
    if (partyAddressList != null && !partyAddressList.isEmpty()) {
      CZWTFCHelperRepository.removePartyAddress(partyAddressList);
    }
    if (employemntList != null && !employemntList.isEmpty()) {
      CZWTFCHelperRepository.removeEmployment(employemntList);
    }
    if (stipulationList != null && !stipulationList.isEmpty()) {
      CZWTFCHelperRepository.removeStip(stipulationList);
    }
    if (additionalPrefList != null && !additionalPrefList.isEmpty()) {
      CZWTFCHelperRepository.removeAddPref(additionalPrefList);
    }
    if (identificationList != null && !identificationList.isEmpty()) {
      CZWTFCHelperRepository.removeIdentification(identificationList);
    }
    if (addressList != null && !addressList.isEmpty()) {
      CZWTFCHelperRepository.removeAddress(addressList);
    }
    if (partyList != null && !partyList.isEmpty()) {
      CZWTFCHelperRepository.removeParty(partyList);
    }
    CZWTFCSubmissionRepository.remove(new List<tffa__Submission__c>{ sub });

    List<String> cdIdList = CZWTFCHelperRepository.fetchContentDocumentId(idList);

    if (cdIdList != null && !cdIdList.isEmpty()) {
      CZWTFCHelperRepository.deleteContentDocumentById(cdIdList);
    }
  }
}