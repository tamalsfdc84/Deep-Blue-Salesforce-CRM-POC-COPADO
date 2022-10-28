public inherited sharing class FISCCCommonHelper {
  public static void setFISBranchPrimaryOffcrAndCostCenter(List<tffa__Application__c> appList, List<tffa__Party__c> partyList) {
    try {
      tffa__Submission__c sub = appList[0].tffa__submission__r;
      if (sub == null) {
        sub = FISCCIntegrationLogService.submissionObj;
      }
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
          if (sub.tffa__SubmittedChannel__c == FISCCIntegrationConstants.DIGITAL && locationList.get(0).CZAvailableInDigital__c) {
            partyCostCenter = locationList.get(0).CostCenter__c;
            isURLFISBranchPresent = true;
          } else if (sub.tffa__SubmittedChannel__c == FISCCIntegrationConstants.BRANCH) {
            partyCostCenter = locationList.get(0).CostCenter__c;
            isURLFISBranchPresent = true;
          }
        }
      }
      if (!isURLFISBranchPresent) {
        partyBranch = brandObj.DefaultLocation__r.FISBranchCode__c;
        partyCostCenter = brandObj.DefaultLocation__r.CostCenter__c;
      }

      for (tffa__Party__c party : partyList) {
        if (party.CZLocation__r != null) {
          party.FISBranchCode__c = party.CZLocation__r.FISBranchCode__c;
        }
        if (!party.tffa__IsExistingCustomer__c) {
          if (String.isBlank(party.FISBranchCode__c)) {
            party.FISBranchCode__c = partyBranch;
          }
          if (String.isBlank(party.CostCenter__c)) {
            party.CostCenter__c = partyCostCenter;
          }
        }
        if (
          FISCCIntegrationLogService.submissionObj.tffa__SubmittedChannel__c == FISCCIntegrationConstants.DIGITAL &&
          FISCCIntegrationLogService.brandObj != null
        ) {
          party.CZPrimaryOfficer__c = FISCCIntegrationLogService.brandObj.CIPrmyOffcrNbr__c;
        }
      }
      Map<String, tffa__Location__c> locMap = FISCCIntegrationLogRepository.fetchLocationMapByBrandId(brandObj.Id);
      for (tffa__Application__c app : appList) {
        try {
          if (app.CZLocation__r != null) {
            app.FISBranchCode__c = app.CZLocation__r.FISBranchCode__c;
          }
          if (String.isBlank(app.FISBranchCode__c)) {
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
          }
          if (String.isBlank(app.CostCenter__c) && locMap.containsKey(costCenterBranch)) {
            tffa__Location__c location = locMap.get(costCenterBranch);

            if (location != null) {
              app.CostCenter__c = location.CostCenter__c;
            } else {
              app.CostCenter__c = brandObj.DefaultLocation__r.CostCenter__c;
            }
          }
        } catch (Exception ex) {
          tffa.Logger.debug(
            'Exception in FISCCCommonHelper.setBranchCodeAndCostCenter for application  :::' +
            app.Id +
            ' ' +
            ex.getMessage() +
            ex.getStackTraceString()
          );
          if (String.isBlank(app.FISBranchCode__c)) {
            app.FISBranchCode__c = brandObj.DefaultLocation__r.FISBranchCode__c;
          }
          if (String.isBlank(app.CostCenter__c)) {
            app.CostCenter__c = brandObj.DefaultLocation__r.CostCenter__c;
          }
        }
      }
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in FISCCCommonHelper.setBranchCodeAndCostCenter   :::' + ex.getMessage() + ex.getStackTraceString());
      throw ex;
    }
  }

  public static void setAccountTitle(List<tffa__Application__c> appList) {
    for (tffa__Application__c appObj : appList) {
      tffa__Party__c primaryParty = FISCCIntegrationLogService.partyObjMap.get(appObj.tffa__PartyXrefs__r[0].tffa__Party__c);
      appObj.CZTitle1__c = CZWTFCCommonHelper.getFormattedFullName(
        primaryParty.tffa__FirstName__c,
        primaryParty.tffa__MiddleName__c,
        primaryParty.tffa__LastName__c,
        (appObj.tffa__Product__r.IsCustodianProduct__c)
          ? primaryParty.tffa__Suffix__c + FISCCIntegrationConstants.MINOR_UTMA
          : primaryParty.tffa__Suffix__c,
        FISCCIntegrationConstants.FULL_NAME_LENGTH
      );

      if (appObj.tffa__PartyXrefs__r.size() > 1) {
        tffa__Party__c jointParty = FISCCIntegrationLogService.partyObjMap.get(appObj.tffa__PartyXrefs__r[1].tffa__Party__c);
        appObj.CZTitle2__c = CZWTFCCommonHelper.getFormattedFullName(
          jointParty.tffa__FirstName__c,
          jointParty.tffa__MiddleName__c,
          jointParty.tffa__LastName__c,
          (appObj.tffa__Product__r.IsCustodianProduct__c)
            ? jointParty.tffa__Suffix__c + FISCCIntegrationConstants.CUSTODIAN
            : jointParty.tffa__Suffix__c,
          FISCCIntegrationConstants.FULL_NAME_LENGTH
        );
      }
      tffa__Address__c addressObj;
      if (primaryParty.tffa__AddressXrefs__r.size() > 1) {
        addressObj = CZWTFCCommonHelper.getPartyAddressByType(primaryParty.tffa__AddressXrefs__r, 'HOME');
      } else {
        addressObj = primaryParty.tffa__AddressXrefs__r[0].tffa__Address__r;
      }
      appObj.tffa__Address__r = addressObj;
    }
  }

  public static void setStatusCode(List<tffa__Application__c> appList) {
    for (tffa__Application__c appObj : appList) {
      if (
        'CHECKING'.equals(appObj.tffa__Product__r.tffa__Category__c) || 'MONEY_MARKET'.equals(appObj.tffa__Product__r.tffa__Category__c)
      ) {
        appObj.CZStatusCode1__c = FISCCIntegrationConstants.STATUS_CODE_2;
        appObj.CZStatusCode2__c = FISCCIntegrationConstants.STATUS_CODE_A;
      } else {
        appObj.CZStatusCode1__c = FISCCIntegrationConstants.STATUS_CODE_2;
      }
    }
  }

  public static boolean isBranchCertificatewithManualFunding(tffa__Submission__c sub, tffa__Application__c appObj) {
    if (sub.tffa__Channel__c == FISCCIntegrationConstants.BRANCH && CZWTFCCommonHelper.isCertificateProduct(appObj)) {
      if (
        appObj.tffa__LinkedFundingRequests__r[0].tffa__Type__c == CZWTFCConstants.FUNDING_TYPE_CHECK ||
        appObj.tffa__LinkedFundingRequests__r[0].tffa__Type__c == CZWTFCConstants.FUNDING_TYPE_WIRE
      ) {
        return true;
      }
    }
    return false;
  }

  public static boolean containsSDBProduct(List<tffa__Application__c> appList) {
    for (tffa__Application__c app : appList) {
      if (app.tffa__ProductCategory__c == 'SAFE_DEPOSIT_BOX' || app.tffa__ProductCategory__c == 'BUSINESS_SAFE_DEPOSIT_BOX') {
        return true;
      }
    }
    return false;
  }

  public static void setAccountRelnCodeAndAppLevelFields(List<tffa__Application__c> appList) {
    for (tffa__Application__c appObj : appList) {
      /**
       * Set Term Unit
       */
      if (CZWTFCCommonHelper.isCertificateProduct(appObj)) {
        appObj.tffa__TermUnit__c = FISCCIntegrationConstants.DPTDTermInd;
      }

      tffa__Product__c prod = appObj.tffa__Product__r;

      /**
       * For Primary Party
       */
      if (prod.IsCustodianProduct__c) {
        if (FISCCIntegrationLogService.applicantRoleMap.containsKey(FISCCIntegrationConstants.CustodianProduct_PrimaryRelation)) {
          appObj.tffa__PartyXrefs__r[0].tffa__ApplicantRole__c = FISCCIntegrationLogService.applicantRoleMap.get(
              FISCCIntegrationConstants.CustodianProduct_PrimaryRelation
            )
            .Id;
          appObj.tffa__PartyXrefs__r[0].tffa__ApplicantRole__r = FISCCIntegrationLogService.applicantRoleMap.get(
            FISCCIntegrationConstants.CustodianProduct_PrimaryRelation
          );
          appObj.tffa__PartyXrefs__r[0].tffa__RoleCode__c = FISCCIntegrationConstants.CustodianProduct_PrimaryRelation;
        }
      } else {
        if (appObj.tffa__PartyXrefs__r.size() > 1) {
          if (FISCCIntegrationLogService.applicantRoleMap.containsKey(FISCCIntegrationConstants.JOINT_RELATION)) {
            appObj.tffa__PartyXrefs__r[0].tffa__ApplicantRole__c = FISCCIntegrationLogService.applicantRoleMap.get(
                FISCCIntegrationConstants.JOINT_RELATION
              )
              .Id;
            appObj.tffa__PartyXrefs__r[0].tffa__ApplicantRole__r = FISCCIntegrationLogService.applicantRoleMap.get(
              FISCCIntegrationConstants.JOINT_RELATION
            );
            appObj.tffa__PartyXrefs__r[0].tffa__RoleCode__c = FISCCIntegrationConstants.JOINT_RELATION;
          }
        } else {
          if (FISCCIntegrationLogService.applicantRoleMap.containsKey(FISCCIntegrationConstants.SOLE_OWNER)) {
            appObj.tffa__PartyXrefs__r[0].tffa__ApplicantRole__c = FISCCIntegrationLogService.applicantRoleMap.get(
                FISCCIntegrationConstants.SOLE_OWNER
              )
              .Id;
            appObj.tffa__PartyXrefs__r[0].tffa__ApplicantRole__r = FISCCIntegrationLogService.applicantRoleMap.get(
              FISCCIntegrationConstants.SOLE_OWNER
            );
            appObj.tffa__PartyXrefs__r[0].tffa__RoleCode__c = FISCCIntegrationConstants.SOLE_OWNER;
          }
        }
      }

      if (appObj.tffa__PartyXrefs__r.size() > 1) {
        for (Integer idx = 1; idx < appObj.tffa__PartyXrefs__r.size(); idx++) {
          if (prod.IsCustodianProduct__c) {
            if (FISCCIntegrationLogService.applicantRoleMap.containsKey(FISCCIntegrationConstants.CustodianProduct_JointRelation)) {
              appObj.tffa__PartyXrefs__r[idx].tffa__ApplicantRole__c = FISCCIntegrationLogService.applicantRoleMap.get(
                  FISCCIntegrationConstants.CustodianProduct_JointRelation
                )
                .Id;
              appObj.tffa__PartyXrefs__r[idx].tffa__ApplicantRole__r = FISCCIntegrationLogService.applicantRoleMap.get(
                FISCCIntegrationConstants.CustodianProduct_JointRelation
              );
              appObj.tffa__PartyXrefs__r[idx].tffa__RoleCode__c = FISCCIntegrationConstants.CustodianProduct_JointRelation;
            }
          } else {
            if (FISCCIntegrationLogService.applicantRoleMap.containsKey(FISCCIntegrationConstants.JOINT_RELATION)) {
              appObj.tffa__PartyXrefs__r[idx].tffa__ApplicantRole__c = FISCCIntegrationLogService.applicantRoleMap.get(
                  FISCCIntegrationConstants.JOINT_RELATION
                )
                .Id;
              appObj.tffa__PartyXrefs__r[idx].tffa__ApplicantRole__r = FISCCIntegrationLogService.applicantRoleMap.get(
                FISCCIntegrationConstants.JOINT_RELATION
              );
              appObj.tffa__PartyXrefs__r[idx].tffa__RoleCode__c = FISCCIntegrationConstants.JOINT_RELATION;
            }
          }
        }
      }
    }
  }

  public static String encrypt(String value) {
    if (Test.isRunningTest()) {
      return '';
    }
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
    Map<String, Object> factsMap = new Map<String, Object>();
    factsMap.put('ProductCategory__c', application.tffa__ProductCategory__c);
    factsMap.put('ProductCode__c', application.tffa__ProductCode__c);
    factsMap.put('EntityType__c', 'APPLICATION');
    List<Id> checklistIds = FISCCIntegrationLogRepository.findAddOnServiceChecklistIdsByFacts('tffa__Facts', factsMap);
    if (checklistIds != null && !checklistIds.isEmpty()) {
      List<tffa__AddOnServiceItem__c> addOnServiceItemList = FISCCIntegrationLogRepository.findAddOnServiceItem(
        checklistIds,
        FISCCIntegrationConstants.OD_FOR_STANDARD_ADDON_TYPE
      );
      if (!addOnServiceItemList.isEmpty()) {
        return true;
      }
      return false;
    }
    return false;
  }

  public static FISCCDOIndividualDemoRequest setIdentityInfo(tffa__Party__c partyObj, FISCCDOIndividualDemoRequest requestDTO) {
    tffa.Logger.debug('In setIdentityInfo');
    tffa__Identification__c identificationObj = null;
    List<String> idTypes = new List<String>{ '104', '105', '107', '108' };

    if (partyObj != null && partyObj.tffa__Identifications__r != null && !partyObj.tffa__Identifications__r.isEmpty()) {
      identificationObj = partyObj.tffa__Identifications__r[0];
      if (identificationObj != null) {
        CZTerafinaFisMapping__c tfFisIdentityMap = CZTerafinaFisMapping__c.getValues(
          FISCCIntegrationConstants.IDENTITY_TYPE +
          '_' +
          identificationObj.tffa__Type__c
        );
        if (tfFisIdentityMap != null) {
          requestDTO.individualDemographics.CIPIDTyp1 = tfFisIdentityMap.FisValue__c;
        }
        requestDTO.individualDemographics.CIPIDNbr1 = identificationObj.tffa__IdentificationNumber__c;
        if (idTypes.contains(requestDTO.individualDemographics.CIPIDTyp1)) {
          requestDTO.individualDemographics.CIPIDIssLoc1 = identificationObj.tffa__IssuingCountry__c;
        } else {
          requestDTO.individualDemographics.CIPIDIssLoc1 = identificationObj.tffa__IssuingState__c;
        }

        requestDTO.individualDemographics.CIPIDIssDte1 = String.valueOf(identificationObj.tffa__IssueDate__c);
        if (identificationObj.tffa__ExpirationDate__c != null) {
          requestDTO.individualDemographics.CIPIDExpDte1 = String.valueOf(identificationObj.tffa__ExpirationDate__c);
        } else {
          requestDTO.individualDemographics.CIPIDExpDte1 = '';
        }
      }
      if (partyObj.tffa__Identifications__r.size() > 1) {
        tffa__Identification__c identificationObj2 = partyObj.tffa__Identifications__r[1];
        CZTerafinaFisMapping__c tfFisIdentityMap = CZTerafinaFisMapping__c.getValues(
          FISCCIntegrationConstants.IDENTITY_TYPE +
          '_' +
          identificationObj2.tffa__Type__c
        );
        if (tfFisIdentityMap != null) {
          requestDTO.individualDemographics.CIPIDTyp2 = tfFisIdentityMap.FisValue__c;
        }
        requestDTO.individualDemographics.CIPIDNbr2 = identificationObj2.tffa__IdentificationNumber__c;
        if (idTypes.contains(requestDTO.individualDemographics.CIPIDTyp1)) {
          requestDTO.individualDemographics.CIPIDIssLoc1 = identificationObj2.tffa__IssuingCountry__c;
        } else {
          requestDTO.individualDemographics.CIPIDIssLoc2 = identificationObj2.tffa__IssuingState__c;
        }
        requestDTO.individualDemographics.CIPIDIssDte2 = String.valueOf(identificationObj2.tffa__IssueDate__c);
        requestDTO.individualDemographics.CIPIDExpDte2 = String.valueOf(identificationObj2.tffa__ExpirationDate__c);
      }
    }
    return requestDTO;
  }

  public static List<String> getCustomerCustomCodes(tffa__Party__c partyObj) {
    List<String> codeLst = new List<String>();
    if (partyObj.tffa__IsEmployee__c) {
      codeLst.add('002');
    }
    if (isPlatinumMemberShipCustomer(partyObj)) {
      codeLst.add('030');
    }

    if (isJuniorSaverMember(partyObj)) {
      codeLst.add('018');
    }

    if (partyObj.CZIsFounder__c) {
      codeLst.add('001');
    }

    return codeLst;
  }

  public static boolean isPlatinumMemberShipCustomer(tffa__Party__c partyObj) {
    for (tffa__AdditionalPreference__c additionalPreference : partyObj.tffa__AdditionalPreferences__r) {
      if (
        additionalPreference.tffa__Code__c == CZDocusignConstants.PLATINUM_ADVENTURE_MEMBERSHIP && additionalPreference.tffa__Enabled__c
      ) {
        return true;
      }
    }

    return false;
  }

  public static boolean isJuniorSaverMember(tffa__Party__c partyObj) {
    for (tffa__AdditionalPreference__c additionalPreference : partyObj.tffa__AdditionalPreferences__r) {
      if (additionalPreference.tffa__Code__c == CZDocusignConstants.JUNIOR_SAVER_MEMBERSHIP && additionalPreference.tffa__Enabled__c) {
        return true;
      }
    }

    return false;
  }

  public static void setAccountAddress(List<String> accTitleLst, tffa__Address__c addressObj) {
    tffa.Logger.debug('In setAccountAddress');

    String titleOne = '';
    String titleTwo = '';
    if (String.isNotBlank(addressObj.tffa__Line1__c)) {
      titleOne = addressObj.tffa__Line1__c;
    }
    if (String.isNotBlank(addressObj.tffa__Line2__c)) {
      titleOne = titleOne + ' ' + addressObj.tffa__Line2__c;
    }

    if (String.isNotBlank(addressObj.tffa__City__c)) {
      titleTwo = addressObj.tffa__City__c;
    }

    if (String.isNotBlank(addressObj.tffa__State__c)) {
      titleTwo = titleTwo + ' ' + addressObj.tffa__State__c;
    }
    if (String.isNotBlank(addressObj.tffa__ZipCode__c)) {
      titleTwo = titleTwo + ' ' + addressObj.tffa__ZipCode__c;
    }
    titleOne = titleOne.length() > 40 ? titleOne.substring(0, 39) : titleOne;
    accTitleLst.add(titleOne);
    accTitleLst.add(titleTwo);
  }

  public static String fetchTermUnit(String termUnit) {
    if (termUnit == 'MONTH') {
      return 'M';
    } else if (termUnit == 'YEAR') {
      return 'Y';
    } else if (termUnit == 'DAY') {
      return 'D';
    }
    return '';
  }

  public static void setErrormessageInSub() {
    if (FISCCIntegrationLogService.submissionObj != null && String.isNotBlank(FISCCIntegrationConstants.ErrorMessage)) {
      if (FISCCIntegrationConstants.ErrorMessage.length() > 210) {
        FISCCIntegrationLogService.submissionObj.CZApplicationProcessingError__c =
          FISCCIntegrationConstants.APPLICATION_PROCESSING_FAILED +
          ' ' +
          FISCCIntegrationConstants.ErrorMessage.substring(0, 209);
      } else {
        FISCCIntegrationLogService.submissionObj.CZApplicationProcessingError__c =
          FISCCIntegrationConstants.APPLICATION_PROCESSING_FAILED +
          ' ' +
          FISCCIntegrationConstants.ErrorMessage;
      }
    }
  }

  public static Boolean isAPICallSuccess(List<FISCCMsgListDTO> msgList) {
    Boolean isScuccess = false;
    if (msgList != null && !msgList.isEmpty()) {
      if (('0').equalsIgnoreCase(msgList[0].Code) && ('Success').equalsIgnoreCase(msgList[0].Text)) {
        isScuccess = true;
      }
    }
    return isScuccess;
  }
}