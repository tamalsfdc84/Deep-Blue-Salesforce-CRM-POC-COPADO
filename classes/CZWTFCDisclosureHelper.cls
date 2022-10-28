public with sharing class CZWTFCDisclosureHelper {
  public static Map<String, List<String>> ROLE_MAP = new Map<String, List<String>>{
    'CONSUMER_SIGNER' => new List<String>{
      'SOLE_OWNER',
      'JOINT_OR',
      'CUSTODIAN',
      'TRUSTEE',
      'HSA_AUTHORIZED_SIGNER',
      'HSA_OWNER',
      'GRANTOR',
      'EXECUTOR',
      'GUARDIAN',
      'PERSONAL_REPRESENTATIVE',
      'ADMINISTRATOR',
      'CONSERVATOR',
      'REPRESENTATIVE_PAYEE',
      'DIGITAL_AUTH_SIGNER',
      'FIDUCIARY'
    },
    'BUSINESS_SIGNER' => new List<String>{ 'AUTHORIZED_SIGNER', 'TRUSTEE', 'LANDLORD', 'DIGITAL_AUTH_SIGNER', 'SOLEPROPRIETOR' },
    'BUSINESS_MAXSAFE_SIGNER' => new List<String>{ 'AUTHORIZED_SIGNER', 'TRUSTEE', 'LANDLORD', 'TENANT', 'POA', 'DIGITAL_AUTH_SIGNER', 'SOLEPROPRIETOR' },
    'BENEFICIAL_OWNER' => new List<String>{ 'Beneficial Owner', 'Beneficial Owner and Controlling Party' },
    'CONTROLLING_PARTY' => new List<String>{ 'Controlling Party', 'Beneficial Owner and Controlling Party' }
  };
  public static Set<String> NON_ELIGIBLE_OD_PRODUCT_CODES = new Set<String>{ '13', '874', '1', '2', '805' };

  public static List<List<tffa__Application__c>> getApplicationBucketsForParty(
    List<String> productCategoryList,
    Map<Id, tffa__Party__c> partyMap,
    List<tffa__Application__c> appList
  ) {
    List<List<tffa__Application__c>> applicationBuckets = new List<List<tffa__Application__c>>();
    for (tffa__Application__c app : appList) {
      if (!productCategoryList.contains(app.tffa__ProductCategory__c)) {
        continue;
      }
      Boolean appAdded = false;
      for (List<tffa__Application__c> appBucket : applicationBuckets) {
        if (hasSameResolution(appBucket.get(0), app)) {
          appBucket.add(app);
          appAdded = true;
          break;
        }
      }
      if (!appAdded) {
        List<tffa__Application__c> newList = new List<tffa__Application__c>();
        newList.add(app);
        applicationBuckets.add(newList);
      }
    }
    return applicationBuckets;
  }

  public static List<List<tffa__Application__c>> getEligibleApplicationBucketsByPrimaryParty(
    List<tffa__Application__c> appList,
    tffa__DisclosureMatrix__c dm,
    tffa__DisclosureItem__c di
  ) {
    List<List<tffa__Application__c>> applicationBuckets = new List<List<tffa__Application__c>>();
    for (tffa__Application__c app : appList) {
      if (isAppEligible(app, dm, di)) {
        Boolean appAdded = false;
        for (List<tffa__Application__c> appBucket : applicationBuckets) {
          if (getPrimaryParty(app).tffa__Party__c == getPrimaryParty(appBucket.get(0)).tffa__Party__c) {
            appBucket.add(app);
            appAdded = true;
            break;
          }
        }
        if (!appAdded) {
          List<tffa__Application__c> newList = new List<tffa__Application__c>();
          newList.add(app);
          applicationBuckets.add(newList);
        }
      }
    }
    return applicationBuckets;
  }
  public static boolean hasSameResolution(tffa__Application__c app1, tffa__Application__c app2) {
    if (
      app1.CZLocation__r != null && app2.CZLocation__r != null &&
      (app1.CZLocation__r.FISBranchCode__c == '898' &&
      app2.CZLocation__r.FISBranchCode__c != '898') ||
      (app1.CZLocation__r.FISBranchCode__c != '898' &&
      app2.CZLocation__r.FISBranchCode__c == '898')
    ) {
      return false; // MAXSAFE products should have separate resolution.
    }
    tffa__Party__c party1 = getPrimaryParty(app1).tffa__Party__r;
    tffa__Party__c party2 = getPrimaryParty(app2).tffa__Party__r;

    if (party1.tffa__Type__c == 'INDIVIDUAL' && party2.Id != party1.Id) {
      return false;
    } else if (party1.tffa__Type__c == 'ORGANIZATION' && party1.tffa__OrganizationType__c != party2.tffa__OrganizationType__c) {
      return false;
    }

    if (getCountOfPartyXref(app1, ROLE_MAP.get('BUSINESS_SIGNER')) != getCountOfPartyXref(app2, ROLE_MAP.get('BUSINESS_SIGNER'))) {
      return false;
    }

    for (tffa__ApplicationPartyXref__c appParty : app1.tffa__PartyXrefs__r) {
      if (ROLE_MAP.get('BUSINESS_SIGNER').contains(appParty.tffa__RoleCode__c)) {
        Boolean match = false;
        for (tffa__ApplicationPartyXref__c appParty2 : app2.tffa__PartyXrefs__r) {
          if (
            appParty.tffa__Party__c == appParty2.tffa__Party__c &&
            ROLE_MAP.get('BUSINESS_SIGNER').contains(appParty.tffa__RoleCode__c) &&
            ROLE_MAP.get('BUSINESS_SIGNER').contains(appParty2.tffa__RoleCode__c)
          ) {
            match = true;
            break;
          }
        }
        if (!match) {
          return false;
        }
      }
    }
    return true;
  }

  public static Integer getCountOfPartyXref(tffa__Application__c app, List<String> roleList) {
    Integer count = 0;
    for (tffa__ApplicationPartyXref__c appParty : app.tffa__PartyXrefs__r) {
      if (roleList.contains(appParty.tffa__RoleCode__c))
        count++;
    }
    return count;
  }

  public static tffa__ApplicationPartyXref__c getPrimaryParty(tffa__Application__c app) {
    Integer count = 0;
    for (tffa__ApplicationPartyXref__c appParty : app.tffa__PartyXrefs__r) {
      if (appParty.tffa__Primary__c)
        return appParty;
    }
    return null;
  }

  public static List<String> getPartyRole(String role) {
    List<String> roles = new List<String>();
    if ((role).contains(',')) {
      roles = role.split(',');
    } else {
      roles.add(role);
    }
    return roles;
  }

  public static String getParticipantRoleCode(String discParticiapantType, String roleCode) {
    if (ROLE_MAP.containsKey(discParticiapantType) && ROLE_MAP.get(discParticiapantType).contains(roleCode))
      return discParticiapantType;
    else
      return roleCode;
  }

  public static boolean isParticipantAlreadyAdded(
    List<tffa__DisclosureParticipant__c> participantLst,
    tffa__DisclosureParticipant__c participant
  ) {
    boolean partyPresent = false;
    for (tffa__DisclosureParticipant__c participantObj : participantLst) {
      if (
        participant.tffa__party__c == participantObj.tffa__party__c &&
        participant.tffa__RoleCode__c == participantObj.tffa__RoleCode__c
      ) {
        partyPresent = true;
        break;
      }
    }
    return partyPresent;
  }

  @TestVisible
  public static boolean isAppEligible(tffa__Application__c app, tffa__DisclosureMatrix__c dm, tffa__DisclosureItem__c di) {
    // tffa.Logger.debug('In isAppEligible');

    if (!checkFactContainsValue(app.tffa__ProductCode__c, dm.tffa__ProductCodeSet__c)) {
      return false;
    }

    if (!checkFactContainsValue(app.tffa__ProductCategory__c, dm.tffa__ProductCategorySet__c)) {
      return false;
    }

    if (!checkFactContainsValue(app.tffa__Brand__c, dm.tffa__BrandCodeSet__c)) {
      return false;
    }
    if (
      String.isNotBlank(dm.tffa__PromotionCodeSet__c) &&
      (String.isNotBlank(app.tffa__PromotionCode__c) || !dm.tffa__PromotionCodeSet__c.contains('NO-PROMO'))
    ) {
      if (!checkFactContainsValue(app.tffa__PromotionCode__c, dm.tffa__PromotionCodeSet__c)) {
        return false;
      }
    }
    if (!checkFactContainsValue(app.tffa__LocationCode__c, dm.tffa__LocationCodeSet__c)) {
      return false;
    }

    if (
      app.CZLocation__r != null &&
      app.CZLocation__r.tffa__Address__r != null &&
      !checkFactContainsValue(app.CZLocation__r.tffa__Address__r.tffa__State__c, dm.tffa__StateSet__c)
    ) {
      return false;
    }

    if (
      (CZDocusignConstants.TRADITIONAL_IRA_TEMPLATE.contains(di.tffa__Template__r.tffa__Code__c) &&
      CZWTFCConstants.IRA.equalsIgnoreCase(app.tffa__ProductCategory__c) &&
      !(app.tffa__InvestmentPlanType__c.equalsIgnoreCase('TRADITIONAL') || app.tffa__InvestmentPlanType__c.equalsIgnoreCase('SEP')))
    ) {
      return false;
    }

    if (
      (CZDocusignConstants.ROTH_IRA_TEMPLATE.contains(di.tffa__Template__r.tffa__Code__c) &&
      CZWTFCConstants.IRA.equalsIgnoreCase(app.tffa__ProductCategory__c) &&
      !(app.tffa__InvestmentPlanType__c.equalsIgnoreCase('CONTRIBUTION') || app.tffa__InvestmentPlanType__c.equalsIgnoreCase('CONVERSION')))
    ) {
      return false;
    }

    if (
      di.tffa__Template__r != null &&
      di.tffa__Template__r.tffa__Code__c.equalsIgnoreCase('IRAROLCONVELIGBLYCERT') &&
      CZWTFCConstants.IRA.equalsIgnoreCase(app.tffa__ProductCategory__c) &&
      !(app.tffa__InvestmentContributionType__c.equalsIgnoreCase('DIRECTROLLOVER') ||
      app.tffa__InvestmentContributionType__c.equalsIgnoreCase('ROLLOVER'))
    ) {
      return false;
    }

    if (
      (CZDocusignConstants.OD_LINE_OF_CREDIT_TEMPLATE.contains(di.tffa__Template__r.tffa__Code__c) && !isOverDraftLineofCreditEnabled(app))
    ) {
      return false;
    }

    if (
      di.tffa__Template__r != null &&
      di.tffa__Template__r.tffa__Code__c.equalsIgnoreCase('INHERITIRAAPPLICATION') &&
      !app.tffa__IsInheritedInvestmentPlan__c
    ) {
      return false;
    }

    if (
      di.tffa__Template__r != null &&
      di.tffa__Template__r.tffa__Code__c.equalsIgnoreCase('IRAAPPLICATION') &&
      app.tffa__IsInheritedInvestmentPlan__c
    ) {
      return false;
    }

    if (
      di.tffa__Template__r != null &&
      di.tffa__Template__r.tffa__Code__c.equalsIgnoreCase('OVRDRFTSTDPRACTICECONFRMATION') &&
      !isODStandardPracticeEnabled(app)
    ) {
      return false;
    }

    if (
      di.tffa__Template__r != null &&
      di.tffa__Template__r.tffa__Code__c.equalsIgnoreCase('OVRDRFTSERVICECONSNTFORMREG') &&
      !isOverDraftATMEnabled(app)
    ) {
      return false;
    }

    if (
      di.tffa__Template__r != null &&
      di.tffa__Template__r.tffa__Code__c.equalsIgnoreCase('DESGOFSUCCUSTODIAN') &&
      String.isBlank(app.CZSuccessorCustodian__c)
    ) {
      return false;
    }

    // If a customer is opening an additional account within an existing plan no need to create the IRA application form
    if (
      di.tffa__Template__r != null &&
      (di.tffa__Template__r.tffa__Code__c.equalsIgnoreCase('INHERITIRAAPPLICATION') ||
      di.tffa__Template__r.tffa__Code__c.equalsIgnoreCase('IRAAPPLICATION')) &&
      app.tffa__IsExistingInvestmentPlan__c
    ) {
      return false;
    }

    // FINANCIAL DISCLOSURE should be generated for new IRA plans
    if (
      di.tffa__Template__r != null &&
      di.tffa__Template__r.tffa__Code__c.equalsIgnoreCase('FINANCIALDISCLOSURE') &&
      app.tffa__IsExistingInvestmentPlan__c
    ) {
      return false;
    }

    return true;
  }

  public static boolean isODStandardPracticeEnabled(tffa__Application__c app) {
    if (NON_ELIGIBLE_OD_PRODUCT_CODES.contains(app.tffa__Product__r.tffa__Code__c)) {
      return false;
    }

    return true;
  }

  // If OD_FOR_STANDARD_TRANSACTIONS is enabled then its eligible
  public static boolean isOverDraftATMEnabled(tffa__Application__c app) {
    for (tffa__AccountPreference__c accountPreference : app.tffa__AccountPreferences__r) {
      if (accountPreference.tffa__Code__c == CZDocusignConstants.OD_FOR_STANDARD_TRANSACTIONS && accountPreference.tffa__Enabled__c) {
        return true;
      }
    }

    return false;
  }

  public static boolean isOverDraftLineofCreditEnabled(tffa__Application__c app) {
    for (tffa__AccountPreference__c accountPreference : app.tffa__AccountPreferences__r) {
      if (accountPreference.tffa__Code__c == CZDocusignConstants.OD_FOR_LINE_OF_CREDIT && accountPreference.tffa__Enabled__c) {
        return true;
      }
    }

    return false;
  }

  @TestVisible
  public static boolean isPartyEligible(
    tffa__Party__c party,
    tffa__DisclosureMatrix__c dm,
    tffa__DisclosureChecklist__c dc,
    tffa__DisclosureItem__c di,
    tffa__Submission__c sub
  ) {
    // tffa.Logger.debug('In isPartyEligible');

    if (!checkFactContainsValue(party.tffa__Type__c, dm.tffa__PartyType__c)) {
      return false;
    }

    if (!checkFactContainsValue(party.tffa__OrganizationType__c, dm.tffa__OrganizationTypeSet__c)) {
      return false;
    }

    if (
      di.tffa__Template__r != null &&
      di.tffa__Template__r.tffa__Code__c.equalsIgnoreCase('PLATINUMAPP') &&
      !isPlatinumMemberShipCustomer(party, dc)
    ) {
      return false;
    }

    if (
      (di.tffa__Template__r != null &&
      (di.tffa__Template__r.tffa__Code__c.equalsIgnoreCase('JNRSAVERFORM') ||
      di.tffa__Template__r.tffa__Code__c.equalsIgnoreCase('JUNIORSAVERCERTIFICATE'))) && !isJuniorSaverMember(party, dc)
    ) {
      return false;
    }

    if (
      di.tffa__Template__r != null &&
      di.tffa__Template__r.tffa__Code__c.equalsIgnoreCase('BENEFOWNERSHIPFORM') &&
      (party.CZIsCIPExempt__c || sub.tffa__Flow__c == 'consumer')
    ) {
      return false;
    }

    return true;
  }

  public static boolean isPlatinumMemberShipCustomer(tffa__Party__c partyObj, tffa__DisclosureChecklist__c dc) {
    for (tffa__AdditionalPreference__c additionalPreference : partyObj.tffa__AdditionalPreferences__r) {
      if (
        additionalPreference.tffa__Code__c == CZDocusignConstants.PLATINUM_ADVENTURE_MEMBERSHIP && additionalPreference.tffa__Enabled__c
      ) {
        return true;
      }
    }

    return false;
  }

  public static boolean isJuniorSaverMember(tffa__Party__c partyObj, tffa__DisclosureChecklist__c dc) {
    for (tffa__AdditionalPreference__c additionalPreference : partyObj.tffa__AdditionalPreferences__r) {
      if (additionalPreference.tffa__Code__c == CZDocusignConstants.JUNIOR_SAVER_MEMBERSHIP && additionalPreference.tffa__Enabled__c) {
        return true;
      }
    }

    return false;
  }

  public static boolean checkFactContainsValue(String value, String fact) {
    if ((String.isBlank(value) && String.isBlank(fact)) || String.isBlank(fact)) {
      return true;
    } else if (String.isBlank(value)) {
      return false;
    } else {
      if (fact.contains(';')) {
        List<String> valueList = new List<String>();
        valueList = fact.split(';');
        if (valueList.contains(value)) {
          return true;
        }
        return false;
      } else {
        if (fact.equalsIgnoreCase(value))
          return true;
        else
          return false;
      }
    }
  }

  @TestVisible
  public static void upsertParticipants(List<tffa__Disclosure__c> discLst, Map<Id, tffa__Party__c> partyMp) {
    tffa.Logger.debug('In upsertParticipants');
    List<tffa__DisclosureParticipant__c> discParticipantList = new List<tffa__DisclosureParticipant__c>();
    for (tffa__Disclosure__c disc : discLst) {
      for (tffa__DisclosureParticipant__c discParticipant : disc.tffa__DisclosureParticipants__r) {
        discParticipant.tffa__Disclosure__c = disc.Id;
        if (discParticipant.Name.length() > 79) {
          discParticipant.Name = discParticipant.Name.substring(0, 79);
        }
        if (partyMp.containsKey(discParticipant.tffa__party__c)) {
          discParticipant.tffa__Party__r = partyMp.get(discParticipant.tffa__party__c);
        }
        discParticipantList.add(discParticipant);
      }
    }
    CZWTFCHelperRepository.saveDisclosureParticipant(discParticipantList);
  }

  public static Map<Id, tffa__Party__c> generatePartyMap(List<tffa__Party__c> parties) {
    tffa.Logger.debug('In generatePartyMap');
    Map<Id, tffa__Party__c> mp = new Map<Id, tffa__Party__c>();
    for (tffa__Party__c p : parties) {
      mp.put(p.id, p);
    }
    return mp;
  }

  public static tffa__DisclosureParticipant__c createBranchUserParticipant() {
    User currentUser = tffa.UserService.getCurrentUser();

    tffa__DisclosureParticipant__c disclosureParticipantObj = new tffa__DisclosureParticipant__c();
    disclosureParticipantObj.Name = currentUser.Name;
    disclosureParticipantObj.tffa__User__c = currentUser.Id;
    disclosureParticipantObj.tffa__Type__c = 'USER';
    disclosureParticipantObj.tffa__RoleCode__c = 'BRANCHUSER';

    return disclosureParticipantObj;
  }

  public static List<List<tffa__Disclosure__c>> splitDisclosures(List<tffa__Disclosure__c> discList) {
    List<List<tffa__Disclosure__c>> discSplitList = new List<List<tffa__Disclosure__c>>();
    if (discList.size() > CZDocusignConstants.MAX_DOCS_IN_DOCUSIGN_ENVELOPE) {
      List<tffa__Disclosure__c> tempList = new List<tffa__Disclosure__c>();
      Integer index = 0;
      Integer count = 0;
      Integer size = discList.size();
      while (index < size) {
        if (discList[index].tffa__DisclosureParticipants__r != null && !discList[index].tffa__DisclosureParticipants__r.isEmpty()) {
          count++;
        }
        tempList.add(discList[index++]);

        // Split size reached, add to result and make new list
        if (count == CZDocusignConstants.MAX_DOCS_IN_DOCUSIGN_ENVELOPE) {
          discSplitList.add(tempList);
          tempList = new List<tffa__Disclosure__c>();
          count = 0;
        }
      }
      if (!tempList.isEmpty()) {
        discSplitList.add(tempList);
      }
    } else {
      discSplitList.add(discList);
    }
    return discSplitList;
  }

  public static List<tffa__Disclosure__c> splitAndCreateDisclosureSets(List<tffa__Disclosure__c> discObjList) {
    List<tffa__Disclosure__c> updatedDiscList = new List<tffa__Disclosure__c>();
    List<List<tffa__Disclosure__c>> listOfdiscList = splitDisclosures(discObjList);
    Integer discSet = 1;
    for (List<tffa__Disclosure__c> discList : listOfdiscList) {
      for (tffa__Disclosure__c disc : discList) {
        disc.CZDisclosureSet__c = discSet;
        updatedDiscList.add(disc);
      }
      discSet++;
    }
    updatedDiscList = CZWTFCHelperRepository.save(updatedDiscList);
    return updatedDiscList;
  }
}