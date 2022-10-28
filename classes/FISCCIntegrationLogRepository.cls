public with sharing class FISCCIntegrationLogRepository extends tffa.AbstractRepository {
  public static tffa__Submission__c findSubmissionById(String submissionId) {
    String q = new tffa.QueryBuilder(tffa__Submission__c.SObjectType)
      .selectFields()
      .selectObject('tffa__BrandEntity__r')
      .selectFields()
      .build()
      .selectChildObject('tffa__Applications__r')
      .selectFields()
      .build()
      .selectChildObject('tffa__PartyXrefs__r') //Used child relationship name(tffa__SubmissionPartyXref__c)
      .selectFields()
      .selectObject('tffa__Party__r')
      .selectFields()
      .build()
      .orderBy('tffa__Primary__c', true) //.orderBy('ID')
      .build()
      .whereClause('Id', '=:attr1')
      .withLimit(1)
      .build()
      .toQuery();
    List<tffa__Submission__c> l = doQuery(q, new List<Object>{ submissionId });
    return l.isEmpty() ? null : l[0];
  }
  //Get Party Details with child objects
  public static List<tffa__Party__c> findPartydWithChildObjects(list<Id> partyIds) {
    String q = new tffa.QueryBuilder(tffa__Party__c.SObjectType)
      .selectFields() /** */
      .selectChildObject('tffa__AddressXrefs__r') /** */
      .selectFields() /** */ /** */
      .selectObject('tffa__Address__r') /** */ /** */
      .selectFields() /** */ /** */
      .build() /** */
      .build() /** */
      .selectChildObject('Identifications__r') /** */
      .selectFields() /** */
      .build() /** */
      .selectChildObject('tffa__Identifications__r') /** */
      .selectFields() /** */
      .build() /** */
      .selectChildObject('tffa__AdditionalPreferences__r') /** */ /** */ /** */ /** */
      .selectFields() /** */ /** */ /** */ /** */
      .build()
      .selectChildObject('tffa__Submissions__r') /** */
      .selectFields() /** */
      .build() /** */
      .selectChildObject('CZPartyAliases__r') /** */
      .selectFields() /** */
      .build() /** */
      .selectChildObject('tffa__PartyXrefs__r') /** */
      .selectFields() /** */
      .selectObject('tffa__RelationCode__r') /** */ /** */
      .selectFields() /** */ /** */
      .build() /** */
      .build()
      .selectChildObject('tffa__Applications__r') /** */
      .selectFields() /** */
      .build() /** */
      .selectChildObject('tffa__Employments__r') /** */
      .selectFields()
      .selectObject('tffa__Address__r')
      .selectFields()
      .build()
      .whereClause('tffa__IsDeleted__c', '= false')
      .build()
      .selectObject('CZLocation__r') /** */
      .selectFields() /** */
      .build()
      .selectChildObject('tffa__DueDiligences__r')
      .selectFields()
      .build()
      .whereClause('Id', '=:attr1')
      .build()
      .toQuery();

    tffa.Logger.debug('Party data ' + q);
    List<tffa__Party__c> party = doQuery(q, new List<Object>{ partyIds });
    return party.isEmpty() ? null : party;
  }

  public static List<tffa__DueDiligence__c> getCDDList(List<Id> partyId) {
    String q = new tffa.QueryBuilder(tffa__DueDiligence__c.SObjectType)
      .selectFields()
      .whereClause('tffa__Type__c', '=:attr1')
      .opAnd()
      .whereClause('tffa__Party__c', 'In :attr2')
      .selectChildObject('tffa__Items__r')
      .selectFields()
      .build()
      .build()
      .toQuery();
    return doQuery(q, new List<Object>{ 'CDD', partyId });
  }

  //Get Account Details with child objects
  public static List<tffa__Application__c> findApplicationWithChildObjects(list<tffa__Application__c> applicationObjs) {
    List<Id> appIds = new List<Id>();
    for (tffa__Application__c appObject : applicationObjs) {
      appIds.add(appObject.Id);
    }
    Boolean isObsolete = FISCCIntegrationConstants.ISOBSOLETE_FALSE;
    String q = new tffa.QueryBuilder(tffa__Application__c.SObjectType)
      .selectFields()
      .selectObject('tffa__Submission__r')
      .selectFields()
      .withLimit(1)
      .build()
      .selectObject('tffa__Product__r')
      .selectFields()
      .withLimit(1)
      .build()
      .selectChildObject('CZMaxsafeAllocationDetailses__r') /** */
      .selectFields() /** */
      .build() /** */
      .selectChildObject('tffa__PartyXrefs__r')
      .selectFields()
      .selectObject('tffa__ApplicantRole__r')
      .selectFields()
      .build()
      .selectObject('tffa__Party__r')
      .selectFields()
      .build()
      .orderBy('tffa__Primary__c', true)
      .build()
      .selectChildObject('tffa__AccountPreferences__r')
      .selectFields()
      .selectObject('tffa__Application__r')
      .selectFields()
      .build()
      .selectObject('PriSavingApplicationId__r')
      .selectFields()
      .build()
      .selectObject('SecDDAApplicationId__r')
      .selectFields()
      .build()
      .selectObject('SecSavingApplicationId__r')
      .selectFields()
      .build()
      .selectObject('tffa__Address__r')
      .selectFields()
      .build()
      .whereClause('tffa__AddOnServiceType__c', 'IN :attr1')
      .build()
      .selectChildObject('tffa__LinkedFundingRequests__r')
      .selectFields()
      .whereClause('IsObsolete__c', '= false')
      .opAnd()
      .whereClause('tffa__Type__c', 'IN :attr2')
      .opAnd()
      .whereClause('tffa__IsDeleted__c', '= false')
      .withLimit(1)
      .build()
      .selectChildObject('tffa__LinkedEligibilities__r')
      .selectFields()
      .build()
      .selectObject('tffa__Location__r')
      .selectFields()
      .selectObject('tffa__Address__r')
      .selectFields()
      .build()
      .build()
      .selectChildObject('tffa__Beneficiaries__r')
      .selectFields()
      .selectObject('tffa__Address__r')
      .selectFields()
      .build()
      .selectObject('tffa__RelationCode__r')
      .selectFields()
      .build()
      .selectObject('CZParty__r')
      .selectFields()
      .build()
      .build()
      .selectObject('CZLocation__r') /** */
      .selectFields() /** */
      .build()
      .selectObject('tffa__Address__r')
      .selectFields()
      .build()
      //.whereClause('tffa__KYCDecisionOutcome__c', '=:KYCDECISION_OUTCOME_VALUES')
      //.opAnd()
      .whereClause('Id', '=:attr3')
      .build()
      .toQuery();
    //tffa.Logger.debug('Application Query :- ' + q);
    List<tffa__Application__c> l = doQuery(
      q,
      new List<Object>{
        new List<String>{
          FISCCIntegrationConstants.OD_FOR_STANDARD_ADDON_TYPE,
          FISCCIntegrationConstants.CHECK_ORDER,
          FISCCIntegrationConstants.DBT_TYPE
        },
        new List<String>{
          CZWTFCConstants.FUNDING_TYPE_ACH,
          CZWTFCConstants.DEBIT_CARD,
          CZWTFCConstants.INTERNAL_TRANSFER,
          CZWTFCConstants.BANK_BOX,
          CZWTFCConstants.PRINT_INVOICE,
          CZWTFCConstants.WAIVE_FEE,
          CZWTFCConstants.FUNDING_TYPE_CHECK,
          CZWTFCConstants.FUNDING_TYPE_WIRE
        },
        appIds
      }
    );
    return l.isEmpty() ? null : l;
  }
  // Get Brand Details with child object
  public static List<tffa__Brand__c> findBrandWithChildObjects(list<Id> brandIds) {
    String q = new tffa.QueryBuilder(tffa__Brand__c.SObjectType)
      .selectFields() /** */
      .selectChildObject('tffa__AgentDetails__r') /** */
      .selectFields() /** */ /** */
      .build()
      .selectChildObject('tffa__ApplicationFacts__r') /** */ /** */
      .selectFields() /** */ /** */
      .build() /** */
      .selectChildObject('tffa__Locations__r') /** */
      .selectFields() /** */
      .build()
      .selectChildObject('tffa__Submissions__r') /** */
      .selectFields()
      .build()
      .whereClause('Id', '=:attr1')
      .build()
      .toQuery();

    tffa.Logger.debug('Brand data ' + q);
    List<tffa__Brand__c> brand = doQuery(q, new List<Object>{ brandIds });
    return brand.isEmpty() ? null : brand;
  }

  public static List<tffa__Brand__c> findBrandwithBrandCode(String strBrandCode) {
    List<String> fieldNamesLocation = new List<String>{
      'id',
      'DefaultLocation__c',
      'DefaultLocation__r.FISBranchCode__c',
      'DefaultLocation__r.CostCenter__c'
    };
    String q = new tffa.QueryBuilder(tffa__Brand__c.SObjectType)
      .selectFields() /** */
      .selectChildObject('tffa__AgentDetails__r') /** */
      .selectFields() /** */ /** */
      .build()
      .selectChildObject('tffa__ApplicationFacts__r') /** */ /** */
      .selectFields() /** */ /** */
      .build() /** */
      .selectObject('DefaultLocation__r') /** */
      .selectFields() /** */
      .build()
      .selectChildObject('tffa__Submissions__r') /** */
      .selectFields()
      .build()
      .whereClause('tffa__Code__c', '=:attr1')
      .build()
      .toQuery();

    tffa.Logger.debug('Brand data ' + q);
    // tffa.Logger.debug('Brand data:: ' + q);
    List<tffa__Brand__c> brand = doQuery(q, new List<Object>{ strBrandCode });
    // tffa.Logger.debug('brand::: ' + brand);
    return brand.isEmpty() ? null : brand;
  }

  public static List<tffa__Location__c> findLocationByLocationIDs(List<String> lstLocationIds) {
    String query = new tffa.QueryBuilder(tffa__Location__c.SObjectType).selectFields().whereClause('ID', ' in :attr1').build().toQuery();

    // tffa.Logger.debug('query::: ' + query);
    return doQuery(query, new List<Object>{ lstLocationIds });
  }

  public static List<tffa__Location__c> findLocationByBrandAndBranch(String brandCode, String branchCode) {
    String locationCode = brandCode + branchCode.leftpad(4, '0');
    String query = new tffa.QueryBuilder(tffa__Location__c.SObjectType)
      .selectFields()
      .whereClause('tffa__Code__c', ' = :attr1')
      .build()
      .toQuery();

    // tffa.Logger.debug('query::: ' + query);
    return doQuery(query, new List<Object>{ locationCode });
  }

  public static Map<String, tffa__Location__c> fetchLocationMapByBrand(String brandCode) {
    Map<String, tffa__Location__c> mp = new Map<String, tffa__Location__c>();
    String locationCode = brandCode + '%';
    String query = new tffa.QueryBuilder(tffa__Location__c.SObjectType)
      .selectFields()
      .whereClause('tffa__Code__c', ' like :attr1')
      .build()
      .toQuery();

    // tffa.Logger.debug('query::: ' + query);
    List<tffa__Location__c> locList = doQuery(query, new List<Object>{ locationCode });
    if (!locList.isEmpty()) {
      for (tffa__Location__c loc : locList) {
        mp.put(loc.FISBranchCode__c, loc);
      }
    }
    return mp;
  }

  public static Map<String, tffa__Location__c> fetchLocationMapByBrandId(String brandId) {
    Map<String, tffa__Location__c> mp = new Map<String, tffa__Location__c>();
    List<String> brandLocationId = new List<String>();

    String query = new tffa.QueryBuilder(tffa__BrandLocation__c.SObjectType)
      .selectFields()
      .whereClause('tffa__Brand__c', ' = :attr1')
      .build()
      .toQuery();

    List<tffa__BrandLocation__c> brandLocList = doQuery(query, new List<Object>{ brandId });
    if (!brandLocList.isEmpty()) {
      for (tffa__BrandLocation__c brandLoc : brandLocList) {
        brandLocationId.add(brandLoc.tffa__Location__c);
      }
    }

    String query_1 = new tffa.QueryBuilder(tffa__Location__c.SObjectType).selectFields().whereClause('Id', ' In :attr1').build().toQuery();

    List<tffa__Location__c> locList = doQuery(query_1, new List<Object>{ brandLocationId });
    if (!locList.isEmpty()) {
      for (tffa__Location__c loc : locList) {
        mp.put(loc.FISBranchCode__c, loc);
      }
    }
    return mp;
  }

  public static FISCC_Adapter_Configs__mdt findAdapterConfig(String strDeveloperName) {
    String query = new tffa.QueryBuilder(FISCC_Adapter_Configs__mdt.SObjectType)
      .selectFields()
      .whereClause('DeveloperName', ' = :attr1')
      .build()
      .toQuery();

    List<FISCC_Adapter_Configs__mdt> l = doQuery(query, new List<Object>{ strDeveloperName });

    return l.isEmpty() ? null : l[0];
  }

  public static FISCC_Charter_Config__mdt findCharterConfig(String strBrandCode) {
    String query = new tffa.QueryBuilder(FISCC_Charter_Config__mdt.SObjectType)
      .selectFields()
      .whereClause('OrganizationId__c', ' = :attr1')
      .build()
      .toQuery();

    List<FISCC_Charter_Config__mdt> l = doQuery(query, new List<Object>{ strBrandCode });
    return l.isEmpty() ? null : l[0];
  }

  public static FISCC_Charter_Config__mdt findCharterConfigByBrandCode(String strBrandCode) {
    String query = new tffa.QueryBuilder(FISCC_Charter_Config__mdt.SObjectType)
      .selectFields()
      .whereClause('Brand__c', ' = :attr1')
      .build()
      .toQuery();

    List<FISCC_Charter_Config__mdt> l = doQuery(query, new List<Object>{ strBrandCode });

    return l.isEmpty() ? null : l[0];
  }

  public static List<tffa__ApplicationPartyXref__c> findApplicationPartyXrefWithId(String strApplicationPartyXrefId) {
    //List<String> fieldNamesLocation = new List<String> { 'Id', 'tffa__Location__c'};//,'tffa__Location__r.Id', 'tffa__Location__r.Name', 'tffa__Location__r.CostCenter__c' };
    List<String> fieldNamesLocation = new List<String>{
      'id',
      'DefaultLocation__c',
      'DefaultLocation__r.FISBranchCode__c',
      'DefaultLocation__r.CostCenter__c'
    };
    String q = new tffa.QueryBuilder(tffa__ApplicationPartyXref__c.SObjectType)
      .selectFields() /** */
      .selectObject('tffa__Application__r') /** */
      .selectFields() /** */
      .selectObject('tffa__Product__r') /** */
      .selectFields() /** */
      .build()
      .selectObject('tffa__Submission__r') /** */
      .selectFields() /** */
      .selectObject('tffa__BrandEntity__r') /** */
      .selectFields() /** */
      .selectObject('DefaultLocation__r') /** */
      .selectFields() /** */
      .build()
      .build()
      .selectObject('tffa__Location__r') /** */
      .selectFields() /** */
      .build()
      .build()
      .build()
      .whereClause('Id', '=:attr1')
      .build()
      .toQuery();

    tffa.Logger.debug('ApplicationPartyXref ' + q);
    //tffa.Logger.debug('ApplicationPartyXref:: ' + q);
    List<tffa__ApplicationPartyXref__c> applicationPartyXref = doQuery(q, new List<Object>{ strApplicationPartyXrefId });
    //tffa.Logger.debug('ApplicationPartyXref::: ' + ApplicationPartyXref);
    return applicationPartyXref.isEmpty() ? null : applicationPartyXref;
  }
  public static List<IntegrationLog__c> findLogsBySubmissionId(String parentId) {
    String q = new tffa.QueryBuilder(IntegrationLog__c.SObjectType)
      .selectFields()
      .selectChildObject('IntegrationLogs__r')
      .selectFields()
      .withLimit(15)
      .build()
      .whereClause('Submission__c', '=:attr1')
      .build()
      .toQuery();

    return doQuery(q, new List<Object>{ parentId });
  }
  public static List<IntegrationLog__c> findLogsBySubmissionAndFlowName(String parentId, List<String> flowNames) {
    String q = new tffa.QueryBuilder(IntegrationLog__c.SObjectType)
      .selectFields()
      .selectChildObject('IntegrationLogs__r')
      .selectFields()
      .build()
      .whereClause('Submission__c', '=:attr1')
      .opAnd()
      .whereClause('FlowName__c', 'IN :attr2')
      .build()
      .toQuery();

    return doQuery(q, new List<Object>{ parentId, flowNames });
  }

  public static List<FISIBSAuthConfig__c> findFisAuthforPassChange() {
    WintrustEnvConfig__mdt wintrustEnvConfig = CZWTFCHelperRepository.fetchWintrustEnvConfig();

    Date currentDate = system.today();
    Integer daysToAdd = Integer.valueOf(wintrustEnvConfig.FISPasswordExpireDays__c) * -1;
    Date updatedDate = currentDate.addDays(daysToAdd);

    String q = new tffa.QueryBuilder(FISIBSAuthConfig__c.SObjectType)
      .selectFields()
      .whereClause('IsActive__c', '=:attr1')
      .opAnd()
      .whereClause('LastUpdatedDate__c', '<=:attr2')
      .build()
      .toQuery();

    List<FISIBSAuthConfig__c> fisAuthConfigList = doQuery(q, new List<Object>{ false, updatedDate });

    return fisAuthConfigList.isEmpty() ? new List<FISIBSAuthConfig__c>() : fisAuthConfigList;
  }

  public static List<FISIBSAuthConfig__c> findFisAuthforPassChangeForTest() {
    String q = new tffa.QueryBuilder(FISIBSAuthConfig__c.SObjectType)
      .selectFields()
      .whereClause('IsActive__c', '=:attr1')
      .build()
      .toQuery();

    List<FISIBSAuthConfig__c> fisAuthConfigList = doQuery(q, new List<Object>{ false });

    return fisAuthConfigList.isEmpty() ? new List<FISIBSAuthConfig__c>() : fisAuthConfigList;
  }

  public static FISIBSAuthConfig__c findAuthByBrandandActiveState(String brandCode, Boolean isActive) {
    String q = new tffa.QueryBuilder(FISIBSAuthConfig__c.SObjectType)
      .selectFields()
      .whereClause('BrandCode__c', '=:attr1')
      .opAnd()
      .whereClause('IsActive__c', '=:attr2')
      .build()
      .toQuery();

    List<FISIBSAuthConfig__c> fisAuthConfigList = doQuery(q, new List<Object>{ brandCode, isActive });

    return fisAuthConfigList.isEmpty() ? null : fisAuthConfigList[0];
  }

  public static List<FISIBSAuthConfig__c> saveFisAuthConfig(List<FISIBSAuthConfig__c> entities) {
    return (List<FISIBSAuthConfig__c>) doUpsert(entities);
  }

  public static Decimal findSeqNbrforPassChange() {
    String q = new tffa.QueryBuilder(PasswordSequence__c.SObjectType).selectFields().build().toQuery();

    List<PasswordSequence__c> passwordSequenceList = doQuery(q, new List<Object>{});

    return passwordSequenceList.isEmpty() ? null : passwordSequenceList[0].SequenceNbr__c;
  }

  public static void updateSeqNbr() {
    String q = new tffa.QueryBuilder(PasswordSequence__c.SObjectType).selectFields().build().toQuery();

    List<PasswordSequence__c> passwordSequenceList = doQuery(q, new List<Object>{});

    if (!passwordSequenceList.isEmpty()) {
      tffa.Logger.debug('Seq no. ' + passwordSequenceList[0].SequenceNbr__c);
      if (Integer.valueOf(passwordSequenceList[0].SequenceNbr__c) == 90) {
        passwordSequenceList[0].SequenceNbr__c = 65;
      } else {
        passwordSequenceList[0].SequenceNbr__c += 1;
      }
      doUpsert(passwordSequenceList);
    } else {
      tffa.Logger.debug('PasswordSequence__c not found.Seq nbr update failed');
    }
  }

  public static FundingAccountDetails__mdt findFundingAccDetails(String fundingType, String brandCode) {
    String query = new tffa.QueryBuilder(FundingAccountDetails__mdt.SObjectType)
      .selectFields()
      .whereClause('FundingType__c', ' = :attr1')
      .OpAnd()
      .whereClause('BrandCode__c', ' = :attr2')
      .build()
      .toQuery();

    List<FundingAccountDetails__mdt> l = doQuery(query, new List<Object>{ fundingType, brandCode });

    return l.isEmpty() ? null : l[0];
  }

  public static List<Id> findAddOnServiceChecklistIdsByFacts(String factsName, Map<String, Object> factsMap) {
    List<Id> checkListIds = new List<Id>();
    String q = new tffa.QueryBuilder(tffa__AddOnServiceMatrix__c.SObjectType)
      .selectFields()
      .whereWithFacts(factsName, factsMap)
      .orderBy('tffa__SortOrder__c')
      .build()
      .toQuery();

    List<tffa__AddOnServiceMatrix__c> resp = (List<tffa__AddOnServiceMatrix__c>) doQuery(q, new List<Object>{});
    if (resp != null && !resp.isEmpty()) {
      for (tffa__AddOnServiceMatrix__c addOnServiceMat : resp) {
        checkListIds.add(addOnServiceMat.tffa__Checklist__c);
      }
    }
    return checkListIds;
  }

  public static List<tffa__AddOnServiceItem__c> findAddOnServiceItem(List<Id> checkListIds, String serviceType) {
    String q = new tffa.QueryBuilder(tffa__AddOnServiceItem__c.SObjectType)
      .selectFields()
      .selectObject('tffa__Checklist__r')
      .selectFields()
      .whereClause('Id', 'In :attr1')
      .build()
      .selectObject('tffa__Service__r')
      .selectFields()
      .whereClause('tffa__Type__c', '=:attr2')
      .build()
      .build()
      .toQuery();

    List<tffa__AddOnServiceItem__c> resp = (List<tffa__AddOnServiceItem__c>) doQuery(q, new List<Object>{ checkListIds, serviceType });
    return resp.isEmpty() ? new List<tffa__AddOnServiceItem__c>() : resp;
  }

  public static List<tffa__ApplicantRole__c> findAllApplicantRole() {
    String q = new tffa.QueryBuilder(tffa__ApplicantRole__c.SObjectType).selectFields().build().toQuery();

    List<tffa__ApplicantRole__c> resp = (List<tffa__ApplicantRole__c>) doQuery(q, new List<Object>{});
    return resp.isEmpty() ? new List<tffa__ApplicantRole__c>() : resp;
  }

  public static Map<String, tffa__FundingRequest__c> getSDBFundingDetails(List<tffa__Application__c> appList) {
    List<Id> appIds = new List<Id>();
    for (tffa__Application__c app : appList) {
      if (app.tffa__ProductCategory__c == 'SAFE_DEPOSIT_BOX' || app.tffa__ProductCategory__c == 'BUSINESS_SAFE_DEPOSIT_BOX') {
        appIds.add(app.Id);
      }
    }
    Map<String, tffa__FundingRequest__c> mp = new Map<String, tffa__FundingRequest__c>();
    String query = new tffa.QueryBuilder(tffa__FundingRequest__c.SObjectType)
      .selectFields()
      .whereClause('tffa__LinkedApplication__c', 'In :attr1')
      .opAnd()
      .whereClause('tffa__Type__c', '= :attr2')
      .build()
      .toQuery();

    List<tffa__FundingRequest__c> resp = (List<tffa__FundingRequest__c>) doQuery(query, new List<Object>{ appIds, 'INTERNAL_TRANSFER' });
    if (resp != null && !resp.isEmpty()) {
      for (tffa__FundingRequest__c fundReq : resp) {
        mp.put(fundReq.tffa__LinkedApplication__c + '_' + fundReq.tffa__Purpose__c, fundReq);
      }
    }
    return mp;
  }
}