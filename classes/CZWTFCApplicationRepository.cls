global with sharing class CZWTFCApplicationRepository extends tffa.AbstractRepository {
  /**
   * @description Get submission record by ID
   * @param String submissionId
   * @return tffa__Submission__c
   */
  public static tffa__Submission__c findSubmissionById(String submissionId) {
    String q = new tffa.QueryBuilder(tffa__Submission__c.SObjectType)
      .selectFields()
      .selectChildObject('tffa__FundingRequests__r')
      .selectFields()
      .build()
      .selectChildObject('tffa__Applications__r')
      .selectFields()
      .build()
      .selectChildObject('tffa__PartyXrefs__r')
      .selectFields() /** */
      .selectObject('tffa__Party__r')
      .selectFields() /** */
      .build()
      .orderBy('tffa__Primary__c', true) //.orderBy('ID')
      .build()
      .whereClause('Id', '=:attr1')
      .build()
      .toQuery();
    //List<tffa__Submission__c> subList = Database.query(q);
    List<tffa__Submission__c> subList = doQuery(q, new List<Object>{ submissionId });
    return subList.isEmpty() ? null : subList[0];
  }
  /**
   * Persists (creates if new, updates if existing) the entities in the data store.
   * @param entities
   */
  public static List<tffa__Application__c> save(List<tffa__Application__c> entities) {
    return (List<tffa__Application__c>) doUpsert(entities);
  }

  /**
   * Persists (creates if new, updates if existing) the entities in the data store.
   * @param entities
   */
  public static List<tffa__Submission__c> save(List<tffa__Submission__c> entities) {
    return (List<tffa__Submission__c>) doUpsert(entities);
  }

  /**
   * Fetches an application record with all fields by submission id.
   */
  global static List<tffa__ApplicationPartyXref__c> findAppXrefByAppIds(List<String> selectedApplicationIds) {
    Boolean isPrimary = true;
    String q = new tffa.QueryBuilder(tffa__ApplicationPartyXref__c.SObjectType)
      .selectFields()
      .whereClause('tffa__Primary__c', '= :attr1')
      .opAnd()
      .whereClause('tffa__Application__c', 'in :attr2')
      .build()
      .toQuery();

    List<tffa__ApplicationPartyXref__c> listApplication = doQuery(q, new List<Object>{ isPrimary, selectedApplicationIds });
    return listApplication.isEmpty() ? null : listApplication;
  }

  public static List<TFEntries__c> getTfentries() {
    List<String> queryParams = new List<String>();
    String q = new tffa.QueryBuilder(TFEntries__c.SObjectType).selectFields().build().toQuery();
    List<TFEntries__c> l = doQuery(q, queryParams);
    return l.isEmpty() ? null : l;
  }

  public static ContentVersion getContent(String Id) {
    List<String> queryParam = new List<String>();
    queryParam.add(Id);
    String q = new tffa.QueryBuilder(ContentVersion.SObjectType).selectFields().whereClause('Id', '=:attr1').build().toQuery();
    List<ContentVersion> l = doQuery(q, queryParam);
    return l.isEmpty() ? null : l[0];
  }

  public static ContentWorkspace getContentWorkSpace(String folderName) {
    List<String> queryParam = new List<String>();
    queryParam.add(folderName);
    String q = new tffa.QueryBuilder(ContentWorkspace.SObjectType).selectFields().whereClause('Name', '=:attr1').build().toQuery();
    List<ContentWorkspace> l = doQuery(q, queryParam);
    return l.isEmpty() ? null : l[0];
  }

  public static ContentFolder getContentFolder(String folderName) {
    List<String> queryParam = new List<String>();
    queryParam.add(folderName);
    String q = new tffa.QueryBuilder(ContentFolder.SObjectType)
      .selectFields()
      .whereClause('Name', '=:attr1')
      .withLimit(1)
      .build()
      .toQuery();
    List<ContentFolder> l = doQuery(q, queryParam);
    return l.isEmpty() ? null : l[0];
  }

  public static ContentFolderMember getContentFolderMember(String documentId) {
    List<String> queryParam = new List<String>();
    queryParam.add(documentId);
    String q = new tffa.QueryBuilder(ContentFolderMember.SObjectType)
      .selectFields()
      .whereClause('ChildRecordId', '=:attr1')
      .withLimit(1)
      .build()
      .toQuery();
    List<ContentFolderMember> l = doQuery(q, queryParam);
    return l.isEmpty() ? null : l[0];
  }

  public static List<TFEntries__c> save(List<TFEntries__c> entities) {
    return (List<TFEntries__c>) doUpsert(entities);
  }

  public static TFEntries__c saveSingle(TFEntries__c entities) {
    List<TFEntries__c> listEnt = new List<TFEntries__c>();
    listEnt.add(entities);
    listEnt = save(listEnt);
    return listEnt[0];
  }

  public static List<UploadFileHistory__c> save(List<UploadFileHistory__c> entities) {
    return (List<UploadFileHistory__c>) doUpsert(entities);
  }

  public static UploadFileHistory__c saveSingle(UploadFileHistory__c entities) {
    List<UploadFileHistory__c> listEnt = new List<UploadFileHistory__c>();
    listEnt.add(entities);
    listEnt = save(listEnt);
    return listEnt[0];
  }

  public static List<ContentVersion> save(List<ContentVersion> entities) {
    return (List<ContentVersion>) doUpsert(entities);
  }

  public static ContentVersion saveSingle(ContentVersion entities) {
    List<ContentVersion> listEnt = new List<ContentVersion>();
    listEnt.add(entities);
    listEnt = save(listEnt);
    return listEnt[0];
  }

  public static List<ContentDocumentLink> save(List<ContentDocumentLink> entities) {
    return (List<ContentDocumentLink>) doUpsert(entities);
  }

  public static ContentDocumentLink saveSingle(ContentDocumentLink entities) {
    List<ContentDocumentLink> listEnt = new List<ContentDocumentLink>();
    listEnt.add(entities);
    listEnt = save(listEnt);
    return listEnt[0];
  }

  public static List<ContentFolderMember> save(List<ContentFolderMember> entities) {
    return (List<ContentFolderMember>) doUpsert(entities);
  }

  public static ContentFolderMember saveSingle(ContentFolderMember entities) {
    List<ContentFolderMember> listEnt = new List<ContentFolderMember>();
    listEnt.add(entities);
    listEnt = save(listEnt);
    return listEnt[0];
  }

  public static List<tffa__AccountPreference__c> save(List<tffa__AccountPreference__c> entities) {
    return (List<tffa__AccountPreference__c>) doUpsert(entities);
  }

  /**
   * Fetches an Application record by id.
   */
  // global static tffa__Application__c findApplicationWithId(String appId) {
  //   String q = new tffa.QueryBuilder(tffa__Application__c.SObjectType).selectFields().whereClause('Id', '=:attr1').build().toQuery();
  //   List<tffa__Application__c> apps = doQuery(q, new List<Object>{ appId });
  //   return apps.isEmpty() ? null : apps[0];
  // }
  /**
   * Fetches an application record with all fields by submission id.
   */
  public static tffa__Application__c findApplicationById(String appId) {
    String q = new tffa.QueryBuilder(tffa__Application__c.SObjectType)
      .selectFields()
      .selectChildObject('tffa__LinkedFundingRequests__r')
      .selectFields() /** */
      .whereClause('IsObsolete__c', '= false')
      .build()
      .selectObject('tffa__Submission__r')
      .selectFields()
      .selectObject('tffa__BrandEntity__r')
      .selectFields()
      .build()
      .build()
      .selectChildObject('PartyXrefs__r')
      .selectFields()
      .selectObject('tffa__Party__r')
      .selectFields()
      .build()
      .build()
      .selectObject('tffa__Address__r')
      .selectFields()
      .build()
      .selectObject('CZLocation__r') /** */
      .selectFields() /** */
      .build()
      .selectObject('tffa__Product__r')
      .selectFields()
      .build()
      .whereClause('Id', '=:attr1')
      .build()
      .toQuery();

    List<tffa__Application__c> application = doQuery(q, new List<Object>{ appId });
    return application.isEmpty() ? null : application[0];
  }

  /**
   * Fetches an application record with all fields by submission id.
   */
  public static List<tffa__Application__c> findApplicationWithChildObjsBySubId(tffa__Submission__c sub) {
    List<String> appIds = new List<String>();

    if (sub.tffa__Applications__r != null && sub.tffa__Applications__r.size() > 0) {
      for (tffa__Application__c appObj : sub.tffa__Applications__r) {
        appIds.add(appObj.Id);
      }
    } else {
      return null;
    }

    String q = new tffa.QueryBuilder(tffa__Application__c.SObjectType)
      .selectFields()
      .selectChildObject('tffa__LinkedFundingRequests__r')
      .selectFields() /** */
      .whereClause('IsObsolete__c', '= false')
      .build()
      .whereClause('Id', 'In :attr1')
      .build()
      .toQuery();

    List<tffa__Application__c> application = doQuery(q, new List<Object>{ appIds });
    return application.isEmpty() ? null : application;
  }

  public static List<tffa__Application__c> findAppwithChildsforCB() {
    WintrustEnvConfig__mdt wintrustEnvConfig = CZWTFCHelperRepository.fetchWintrustEnvConfig();

    String q = new tffa.QueryBuilder(tffa__Application__c.SObjectType)
      .selectFields()
      .selectChildObject('tffa__AccountPreferences__r')
      .selectFields()
      .selectObject('PriSavingApplicationId__r')
      .selectFields()
      .build()
      .selectObject('tffa__Address__r')
      .selectFields()
      .build()
      .selectObject('SecDDAApplicationId__r')
      .selectFields()
      .build()
      .selectObject('SecSavingApplicationId__r')
      .selectFields()
      .build()
      .whereClause('tffa__AddOnServiceType__c', 'IN:attr1')
      .opAnd()
      .whereClause('tffa__Enabled__c', '=:attr2')
      .build()
      .selectObject('tffa__Product__r')
      .selectFields()
      .build()
      .whereClause('DebitCardIssuanceStatus__c', 'IN:attr3')
      .opAnd()
      .whereClause('DebitCardIssueRetryCount__c', '<:attr4')
      .opAnd()
      .whereClause('tffa__Status__c', 'IN:attr5')
      .build()
      .toQuery();
    List<tffa__Application__c> l = doQuery(
      q,
      new List<Object>{
        new List<String>{ FISCCIntegrationConstants.DBT_TYPE },
        true,
        FISCCIntegrationConstants.ADDON_SERVICE_PENDING_STATUS_LIST,
        wintrustEnvConfig.BatchRetryCount__c,
        FISCCIntegrationConstants.ACCT_OPEN_STATUS_LIST
      }
    );
    return l.isEmpty() ? new List<tffa__Application__c>() : l;
  }

  public static List<tffa__Application__c> findAppwithChildsForAccountPref() {
    WintrustEnvConfig__mdt wintrustEnvConfig = CZWTFCHelperRepository.fetchWintrustEnvConfig();

    String q = new tffa.QueryBuilder(tffa__Application__c.SObjectType)
      .selectFields()
      .selectObject('tffa__Product__r')
      .selectFields()
      .build()
      .selectChildObject('tffa__AccountPreferences__r')
      .selectFields()
      .whereClause('tffa__AddOnServiceType__c', 'In :attr1')
      .opAnd()
      .whereClause('tffa__Enabled__c', '=:attr2')
      .opAnd()
      .whereClause('tffa__Status__c', '!=:attr3')
      .build()
      .selectChildObject('PartyXrefs__r')
      .selectFields()
      .selectObject('tffa__Party__r')
      .selectFields()
      .build()
      .build()
      .whereClause('AccountPreference__c', 'IN:attr4')
      .opAnd()
      .whereClause('AccPrefRetryCount__c', '<:attr5') //5
      .opAnd()
      .whereClause('tffa__Status__c', 'IN :attr6')
      .build()
      .toQuery();

    List<tffa__Application__c> applications = (List<tffa__Application__c>) doQuery(
      q,
      new List<Object>{
        new List<String>{
          FISCCIntegrationConstants.ESTMT_TYPE,
          FISCCIntegrationConstants.OD_DEFICIT_TRANSFER_TYPE,
          FISCCIntegrationConstants.OD_ATM_TRANSFER_TYPE
        }, //add OD
        true,
        CZWTFCConstants.ADDON_STATUS_COMPLETED,
        FISCCIntegrationConstants.ADDON_SERVICE_PENDING_STATUS_LIST,
        wintrustEnvConfig.BatchRetryCount__c,
        FISCCIntegrationConstants.ACCT_OPEN_STATUS_LIST
      }
    );
    return applications.isEmpty() ? new List<tffa__Application__c>() : applications;
  }

  public static List<tffa__Application__c> findAppforFailedAppBatch() {
    Datetime currentDate = DateTime.now();

    Datetime updatedCurrentDate = currentDate.addHours(-1);

    WintrustEnvConfig__mdt wintrustEnvConfig = CZWTFCHelperRepository.fetchWintrustEnvConfig();

    String q = new tffa.QueryBuilder(tffa__Application__c.SObjectType)
      .selectFields()
      .selectObject('tffa__Submission__r')
      .selectFields()
      .build()
      .selectChildObject('tffa__LinkedFundingRequests__r')
      .selectFields()
      .whereClause('IsObsolete__c', '= false')
      .opAnd()
      .whereClause('tffa__Type__c', '= :attr1')
      .opAnd()
      .whereClause('tffa__IsDeleted__c', '= false')
      .withLimit(1)
      .build()
      .whereClause('AccountOpeningStatus__c', '=: attr2')
      .opAnd()
      .whereClause('AcctOpenRetryCount__c', '<=:attr3')
      .build()
      .toQuery();

    List<tffa__Application__c> applications = (List<tffa__Application__c>) doQuery(
      q,
      new List<Object>{ CZWTFCConstants.FUNDING_TYPE_ACH, CZWTFCConstants.PROCESS_STATUS_FAILURE, wintrustEnvConfig.BatchRetryCount__c }
    );
    return applications.isEmpty() ? new List<tffa__Application__c>() : applications;
  }

  /* batch query to find apps for which routing and mail events are pending because of governor limits
   */
  public static List<tffa__Application__c> findAppsToRoute() {
    String q = new tffa.QueryBuilder(tffa__Application__c.SObjectType)
      .selectFields()
      .whereClause('IsRoutingRequired__c', '=:attr1')
      .build()
      .toQuery();

    List<tffa__Application__c> applications = (List<tffa__Application__c>) doQuery(q, new List<Object>{ true });
    return applications.isEmpty() ? new List<tffa__Application__c>() : applications;
  }

  public static tffa__Application__c findAppById(String appId) {
    String q = new tffa.QueryBuilder(tffa__Application__c.SObjectType).selectFields().whereClause('Id', '=:attr1').build().toQuery();
    List<tffa__Application__c> application = doQuery(q, new List<Object>{ appId });
    return application.isEmpty() ? null : application[0];
  }

  public static List<tffa__Application__c> findApplicationByMDMStatus() {
    String q = new tffa.QueryBuilder(tffa__Application__c.SObjectType)
      .selectFields()
      .selectObject('tffa__Product__r')
      .selectFields()
      .build()
      .whereClause('MDMUploadStatus__c', '!=: attr1')
      .opAnd()
      .groupStart()
      .whereClause('tffa__AccountNumber__c', '!= null')
      .opOR()
      .whereClause('tffa__DepositBoxAccountNumber__c', '!= null')
      .groupEnd()
      .opAnd()
      .whereClause('MDMUploadRetryCount__c', ' < :attr2')
      .opAnd()
      .groupStart()
      .whereClause('tffa__Status__c', '= :attr3')
      .opOR()
      .whereClause('AccountOpeningStatus__c', ' = :attr4')
      .groupEnd()
      .build()
      .toQuery();

    WintrustEnvConfig__mdt wintrustEnvConfig = CZWTFCHelperRepository.fetchWintrustEnvConfig();

    List<tffa__Application__c> applications = (List<tffa__Application__c>) doQuery(
      q,
      new List<Object>{
        CZWTFCConstants.PROCESS_STATUS_SUCCESS,
        wintrustEnvConfig.BatchRetryCount__c,
        'DECLINED',
        CZWTFCConstants.PROCESS_STATUS_SUCCESS
      }
    );

    return applications.isEmpty() ? new List<tffa__Application__c>() : applications;
  }

  global static List<tffa__ApplicationPartyXref__c> findApplicationPartyById(String applicationId) {
    String q = new tffa.QueryBuilder(tffa__ApplicationPartyXref__c.SObjectType)
      .selectFields()
      .selectObject('tffa__ApplicantRole__r')
      .selectFields()
      .build()
      .selectObject('tffa__Party__r')
      .selectFields()
      .build()
      .whereClause('tffa__Application__c', ' =:attr1')
      .build()
      .toQuery();

    List<tffa__ApplicationPartyXref__c> listApplication = doQuery(q, new List<Object>{ applicationId });
    return listApplication.isEmpty() ? new List<tffa__ApplicationPartyXref__c>() : listApplication;
  }

  global static tffa__ApplicationPartyXref__c findApplicationPartyByPartyId(String partyId, String applicationId) {
    String q = new tffa.QueryBuilder(tffa__ApplicationPartyXref__c.SObjectType)
      .selectFields()
      .selectObject('tffa__ApplicantRole__r')
      .selectFields()
      .build()
      .selectObject('tffa__Party__r')
      .selectFields()
      .build()
      .whereClause('tffa__Party__c', ' =:attr1')
      .opAnd()
      .whereClause('tffa__Application__c', ' =:attr2')
      .build()
      .toQuery();

    List<tffa__ApplicationPartyXref__c> listApplication = doQuery(q, new List<Object>{ partyId, applicationId });
    return listApplication.isEmpty() ? new tffa__ApplicationPartyXref__c() : listApplication[0];
  }

  /**
   *
   * Fetches an account preference record by Application id And Code.
   */
  public static List<tffa__AccountPreference__c> findAccountPrefByAppIdAndCode(tffa__Application__c app, String code) {
    String q = new tffa.QueryBuilder(tffa__AccountPreference__c.SObjectType)
      .selectFields()
      .whereClause('tffa__Application__c', ' =:attr1')
      .opAnd()
      .whereClause('tffa__Code__c', ' =:attr2')
      .build()
      .toQuery();
    return (List<tffa__AccountPreference__c>) doQuery(q, new List<Object>{ app.Id, code });
  }

  /**
   *
   */
  public static List<tffa__Application__c> fetchApplicationsForFCM(
    List<String> statusesLst,
    Integer retryCount,
    List<String> fcmStatusLst
  ) {
    String query = new tffa.QueryBuilder(tffa__Application__c.SObjectType)
      .selectFields()
      .selectObject('tffa__Product__r')
      .selectFields()
      .build()
      .selectObject('tffa__Submission__r')
      .selectFields(new List<String>{ 'Id', 'DisclosureConverted__c' })
      .build()
      .whereClause('tffa__Status__c', ' IN :attr1')
      .opAnd()
      .whereClause('FCMUploadRetryCount__c', ' < :attr2')
      .opAnd()
      .whereClause('FCMUploadStatus__c', 'NOT IN :attr3')
      .build()
      .toQuery();

    List<tffa__Application__c> listApplication = doQuery(query, new List<Object>{ statusesLst, retryCount, fcmStatusLst });
    return listApplication.isEmpty() ? new List<tffa__Application__c>() : listApplication;
  }

  public static List<tffa__Application__c> getApplicationByCheck() {
    String q = new tffa.QueryBuilder(tffa__Application__c.SObjectType)
      .selectFields()
      .selectObject('tffa__Product__r')
      .selectFields()
      .build()
      .whereClause('AccountOpeningStatus__c', '=: attr1')
      .opAnd()
      .whereClause('tffa__AccountNumber__c', ' != null')
      .build()
      .toQuery();

    return doQuery(q, new List<Object>{ CZWTFCConstants.PROCESS_STATUS_SUCCESS });
  }

  /**
   * Fetches an application record with all fields by submission id.
   */
  public static List<tffa__Application__c> findApplicationsByIds(list<tffa__Application__c> applicationObjs) {
    List<Id> appIds = new List<Id>();
    for (tffa__Application__c appObject : applicationObjs) {
      appIds.add(appObject.Id);
    }
    String q = new tffa.QueryBuilder(tffa__Application__c.SObjectType)
      .selectFields()
      .selectChildObject('tffa__AccountPreferences__r')
      .selectFields()
      .build()
      .selectChildObject('tffa__Beneficiaries__r')
      .selectFields()
      .selectObject('tffa__Address__r')
      .selectFields()
      .build()
      .selectObject('tffa__RelationCode__r')
      .selectFields()
      .build()
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
      .selectChildObject('tffa__LinkedFundingRequests__r')
      .selectFields() /** */
      .whereClause('IsObsolete__c', '= false')
      .build()
      .selectChildObject('CZMaxsafeAllocationDetailses__r')
      .selectFields()
      .build()
      .selectObject('tffa__Submission__r')
      .selectFields()
      .withLimit(1)
      .build()
      .selectObject('tffa__Product__r')
      .selectFields()
      .withLimit(1)
      .build()
      .selectObject('tffa__Address__r')
      .selectFields()
      .build()
      .selectChildObject('PartyXrefs__r')
      .selectFields()
      .selectObject('tffa__Party__r')
      .selectFields()
      .build()
      .build()
      .whereClause('Id', 'in :attr1')
      .build()
      .toQuery();

    List<tffa__Application__c> applications = doQuery(q, new List<Object>{ appIds });
    return applications.isEmpty() ? null : applications;
  }

  /**
   * Fetches an application record with all fields by submission id.
   */
  public static List<tffa__Application__c> findApplicationsByIdsForDocusign(Id subId) {
    List<Id> appIds = new List<Id>();

    String q = new tffa.QueryBuilder(tffa__Application__c.SObjectType)
      .selectFields()
      .selectChildObject('tffa__AccountPreferences__r')
      .selectFields()
      .build()
      .selectChildObject('tffa__Beneficiaries__r')
      .selectFields()
      .selectObject('tffa__Address__r')
      .selectFields()
      .build()
      .selectObject('tffa__RelationCode__r')
      .selectFields()
      .build()
      .build()
      .selectObject('CZLocation__r')
      .selectFields()
      .selectObject('tffa__Address__r')
      .selectFields()
      .build()
      .build()
      // .selectChildObject('tffa__LinkedEligibilities__r')
      // .selectFields()
      // .build()
      // .selectObject('tffa__Location__r')
      // .selectFields()
      // .selectObject('tffa__Address__r')
      // .selectFields()
      // .build()
      // .build()
      // .selectChildObject('tffa__LinkedFundingRequests__r')
      // .selectFields() /** */
      // .whereClause('IsObsolete__c', '= false')
      // .build()
      .selectChildObject('CZMaxsafeAllocationDetailses__r')
      .selectFields()
      .build()
      // .selectObject('tffa__Submission__r')
      // .selectFields()
      // .withLimit(1)
      // .build()
      .selectObject('tffa__Product__r')
      .selectFields()
      .withLimit(1)
      .build()
      .selectObject('tffa__Address__r')
      .selectFields()
      .build()
      .selectChildObject('PartyXrefs__r')
      .selectFields()
      .selectObject('tffa__Party__r')
      .selectFields()
      .build()
      .build()
      .whereClause('tffa__Submission__c', '= :attr1')
      .build()
      .toQuery();

    List<tffa__Application__c> applications = doQuery(q, new List<Object>{ subId });
    return applications.isEmpty() ? null : applications;
  }

  /**
   * Fetches an application record with all fields by submission id.
   */
  public static List<tffa__Application__c> findApplicationsByIdsForBranchKYC(list<tffa__Application__c> applicationObjs) {
    List<Id> appIds = new List<Id>();
    for (tffa__Application__c appObject : applicationObjs) {
      appIds.add(appObject.Id);
    }
    String q = new tffa.QueryBuilder(tffa__Application__c.SObjectType)
      .selectFields()
      .selectObject('tffa__Product__r')
      .selectFields()
      .withLimit(1)
      .build()
      .whereClause('Id', 'in :attr1')
      .build()
      .toQuery();

    List<tffa__Application__c> applications = doQuery(q, new List<Object>{ appIds });
    return applications.isEmpty() ? null : applications;
  }

  public static tffa__Application__c findApplicationForTest() {
    String q = new tffa.QueryBuilder(tffa__Application__c.SObjectType).selectFields().build().toQuery();

    List<tffa__Application__c> application = doQuery(q, new List<Object>{});
    return application.isEmpty() ? null : application[0];
  }

  public static List<tffa__Application__c> findBySubmissionId(String submissionId) {
    String q = new tffa.QueryBuilder(tffa__Application__c.SObjectType)
      .selectFields()
      .selectChildObject('tffa__AccountPreferences__r')
      .selectFields()
      .build()
      .whereClause('tffa__Submission__c', '= :attr1')
      .build()
      .toQuery();
    return doQuery(q, new List<Object>{ submissionId });
  }

  //Get Account Details with child objects with all funding Requests
  public static List<tffa__Application__c> findAppsWithChildObjects(list<tffa__Application__c> applicationObjs) {
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
      .build()
      .selectChildObject('tffa__LinkedFundingRequests__r')
      .selectFields()
      .whereClause('IsObsolete__c', '= false')
      .opAnd()
      .whereClause('tffa__Type__c', 'IN :attr1')
      .opAnd()
      .whereClause('tffa__IsDeleted__c', '= false')
      .build()
      .selectChildObject('tffa__Beneficiaries__r')
      .selectFields()
      .selectObject('tffa__Address__r')
      .selectFields()
      .build()
      .build()
      .selectObject('CZLocation__r') /** */
      .selectFields() /** */
      .build()
      //.whereClause('tffa__KYCDecisionOutcome__c', '=:KYCDECISION_OUTCOME_VALUES')
      //.opAnd()
      .whereClause('Id', '=:attr2')
      .build()
      .toQuery();
    //tffa.Logger.debug('Application Query :- ' + q);
    List<tffa__Application__c> l = doQuery(
      q,
      new List<Object>{
        new List<String>{
          CZWTFCConstants.FUNDING_TYPE_ACH,
          CZWTFCConstants.DEBIT_CARD,
          CZWTFCConstants.INTERNAL_TRANSFER,
          CZWTFCConstants.BANK_BOX,
          CZWTFCConstants.PRINT_INVOICE,
          CZWTFCConstants.WAIVE_FEE
        },
        appIds
      }
    );
    return l.isEmpty() ? null : l;
  }

  public static void updateAccountPurpose(String appId, String accountPurpose) {
    String q = new tffa.QueryBuilder(tffa__Application__c.SObjectType)
      .selectFields(new List<String>{ 'Id', 'tffa__AccountPurpose__c' })
      .whereClause('Id', '=:attr1')
      .build()
      .toQuery();

    List<tffa__Application__c> applications = doQuery(q, new List<Object>{ appId });

    if (!applications.isEmpty()) {
      applications[0].tffa__AccountPurpose__c = accountPurpose;
      save(applications);
    }
  }

  public static Map<String, tffa__Application__c> findAllMaxsafeAllocationsByIds(list<tffa__Application__c> applicationObjs) {
    Map<String, tffa__Application__c> applicationMap = new Map<String, tffa__Application__c>();
    List<Id> appIds = new List<Id>();
    for (tffa__Application__c appObject : applicationObjs) {
      appIds.add(appObject.Id);
    }

    String q = new tffa.QueryBuilder(tffa__Application__c.SObjectType)
      .selectFields()
      .selectChildObject('CZMaxsafeAllocationDetailses__r')
      .selectFields()
      .build()
      .whereClause('Id', 'in :attr1')
      .build()
      .toQuery();

    if (Test.isRunningTest()) {
      q = new tffa.QueryBuilder(tffa__Application__c.SObjectType).selectFields().build().toQuery();
    }

    List<tffa__Application__c> applicationList = doQuery(q, new List<Object>{ appIds });
    if (applicationList != null && !applicationList.isEmpty()) {
      for (tffa__Application__c appObj : applicationList) {
        applicationMap.put(appObj.Id, appObj);
      }
    }

    return applicationMap;
  }
}