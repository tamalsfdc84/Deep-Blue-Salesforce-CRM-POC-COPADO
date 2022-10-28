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
      .selectChildObject('PartyXrefs__r')
      .selectFields()
      .selectObject('tffa__Party__r')
      .selectFields()
      .build()
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
      .whereClause('tffa__Status__c', 'IN:attr5')
      .opAnd()
      .whereClause('AccPrefRetryCount__c', '<:attr6') //5
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
        FISCCIntegrationConstants.ACCT_OPEN_STATUS_LIST,
        wintrustEnvConfig.BatchRetryCount__c
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
      .selectChildObject('tffa__LinkedFundingRequests__r')
      .selectFields()
      .whereClause('IsObsolete__c', '= false')
      .opAnd()
      .whereClause('tffa__Type__c', '= :attr1')
      .opAnd()
      .whereClause('tffa__IsDeleted__c', '= false')
      .withLimit(1)
      .build()
      .whereClause('tffa__Status__c', 'IN:attr2')
      .opAnd()
      .whereClause('tffa__KYCDecisionOutcome__c', '=:attr3')
      .opAnd()
      .groupStart()
      .whereClause('AccountOpeningStatus__c', '=: attr4')
      .opOr()
      .groupStart()
      .whereClause('AccountOpeningStatus__c', '!=: attr5')
      .opAnd()
      .whereClause('LastModifiedDate', '<= :attr6')
      .groupEnd()
      .groupEnd()
      .opAnd()
      .whereClause('AcctOpenRetryCount__c', '<=:attr7')
      .build()
      .toQuery();

    List<tffa__Application__c> applications = (List<tffa__Application__c>) doQuery(
      q,
      new List<Object>{
        CZWTFCConstants.FUNDING_TYPE_ACH,
        FISCCIntegrationConstants.FAILED_APP_STATUS,
        FISCCIntegrationConstants.KYC_APPROVED_STATUS,
        CZWTFCConstants.PROCESS_STATUS_FAILURE,
        CZWTFCConstants.PROCESS_STATUS_SUCCESS,
        updatedCurrentDate,
        wintrustEnvConfig.BatchRetryCount__c
      }
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
      .whereClause('tffa__AccountNumber__c', '!= null')
      .opAnd()
      .whereClause('MDMUploadRetryCount__c', ' < :attr2')
      .build()
      .toQuery();

    WintrustEnvConfig__mdt wintrustEnvConfig = CZWTFCHelperRepository.fetchWintrustEnvConfig();

    List<tffa__Application__c> applications = (List<tffa__Application__c>) doQuery(
      q,
      new List<Object>{ CZWTFCConstants.PROCESS_STATUS_SUCCESS, wintrustEnvConfig.BatchRetryCount__c }
    );

    return applications.isEmpty() ? new List<tffa__Application__c>() : applications;
  }

  global static List<tffa__ApplicationPartyXref__c> findApplicationPartyById(String applicationId) {
    String q = new tffa.QueryBuilder(tffa__ApplicationPartyXref__c.SObjectType)
      .selectFields()
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
      .build()
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
}