/**
 * Repository class for Submission
 */
public inherited sharing class CZWTFCSubmissionRepository extends tffa.AbstractRepository {
  /**
   * Fetches a submission entity by id.
   */
  public static tffa__Submission__c findOne(String id) {
    String q = new tffa.QueryBuilder(tffa__Submission__c.SObjectType)
      .selectFields()
      .selectChildObject('tffa__Applications__r')
      .selectFields()
      .build()
      .selectChildObject('PartyXrefs__r')
      .selectFields()
      .build()
      .whereClause('Id', '=:attr1')
      .withLimit(1)
      .build()
      .toQuery();
    return (tffa__Submission__c) doQueryOne(q, new List<Object>{ id });
  }

  public static List<tffa__Submission__c> findByPartyRoleAndId(String role, List<String> ids) {
    String q = new tffa.QueryBuilder(tffa__Submission__c.SObjectType)
      .selectFields()
      .selectChildObject('PartyXrefs__r') /** */
      .selectFields()
      .selectObject('Party__r')
      .selectFields()
      .build() /** */
      .whereClause('Role__c', '= :attr1')
      .build() /** */
      .selectChildObject('Applications__r')
      .selectFields()
      .build()
      .whereClause('Id', 'in :attr2')
      .build()
      .toQuery();
    return doQuery(q, new List<Object>{ role, ids });
  }

  public static List<tffa__Submission__c> save(List<tffa__Submission__c> entities) {
    return (List<tffa__Submission__c>) doUpsert(entities);
  }

  public static List<tffa__Submission__c> findSubmissionAndAppByIds(List<String> subIds) {
    String query = new tffa.QueryBuilder(tffa__Submission__c.SObjectType)
      .selectFields()
      .selectChildObject('tffa__FundingRequests__r')
      .selectFields()
      .build()
      .selectChildObject('tffa__Applications__r')
      .selectFields()
      .build()
      .whereClause('Id', 'In :attr1')
      .build()
      .toQuery();

    List<tffa__Submission__c> l = (List<tffa__Submission__c>) doQuery(query, new List<Object>{ subIds });
    return l.isEmpty() ? null : l;
  }

  public static List<String> getPurgeSubIds() {
    WintrustEnvConfig__mdt wintrustEnvConfig = CZWTFCHelperRepository.fetchWintrustEnvConfig();

    Date currentDate = system.today();
    Integer dateToAdd = Integer.valueOf(wintrustEnvConfig.PurgeSubmission__c) * -1;
    Date updatedDate = currentDate.addDays(dateToAdd);
    List<String> subIdList = new List<String>();

    String q = new tffa.QueryBuilder(tffa__Application__c.SObjectType)
      .selectFields()
      .whereClause('LastModifiedDate', '< :attr1')
      .build()
      .toQuery();

    List<tffa__Application__c> applicationList = doQuery(q, new List<Object>{ updatedDate });

    if (applicationList != null && !applicationList.isEmpty()) {
      for (tffa__Application__c app : applicationList) {
        subIdList.add(app.tffa__Submission__c);
      }
    }
    return subIdList;
  }

  /**
   * Fetches a submission entity by id.
   */
  public static List<tffa__Submission__c> findtestSubmission() {
    String q = new tffa.QueryBuilder(tffa__Submission__c.SObjectType)
      .selectFields()
      .selectChildObject('Applications__r')
      .selectFields()
      .build()
      .selectChildObject('tffa__FundingRequests__r')
      .selectFields()
      .build()
      .selectChildObject('PartyXrefs__r')
      .selectFields()
      .build()
      .selectChildObject('tffa__Disclosures__r')
      .selectFields()
      .build()
      .build()
      .toQuery();
    return (List<tffa__Submission__c>) doQuery(q, new List<Object>{});
  }

  public static void remove(List<tffa__Submission__c> entities) {
    doDelete(entities);
  }

  public static List<tffa__Submission__c> readAll() {
    String q = new tffa.QueryBuilder(tffa__Submission__c.SObjectType).selectFields().build().toQuery();
    return doQuery(q, null);
  }

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
      .selectObject('CZLocation__r')
      .selectFields() /** */
      .build()
      .build()
      .orderBy('tffa__Primary__c', true) //.orderBy('ID')
      .build()
      .whereClause('Id', '=:attr1')
      .build()
      .toQuery();
    //List<tffa__Submission__c> l = Database.query(q);
    List<tffa__Submission__c> l = (List<tffa__Submission__c>) doQuery(q, new List<Object>{ submissionId });
    return l.isEmpty() ? null : l[0];
  }

  /**
   * @description Get submission record by ID
   * @param String submissionId
   * @return tffa__Submission__c
   */
  public static tffa__Submission__c findSubmissionByIdwithSortOrder(String submissionId) {
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
      .selectObject('CZLocation__r')
      .selectFields() /** */
      .build()
      .build()
      .orderBy('tffa__SortOrder__c')
      .build()
      .whereClause('Id', '=:attr1')
      .build()
      .toQuery();
    //List<tffa__Submission__c> l = Database.query(q);
    List<tffa__Submission__c> l = (List<tffa__Submission__c>) doQuery(q, new List<Object>{ submissionId });
    return l.isEmpty() ? null : l[0];
  }

  public static void deleteRecords(List<sObject> entities) {
    doDelete(entities);
  }

  public static List<tffa__Disclosure__c> getReviewSubmitDisclosures(Id submissionId) {
    String query = new tffa.QueryBuilder(tffa__Disclosure__c.SObjectType)
      .selectFields()
      .whereClause('tffa__Submission__c', '=: attr1')
      .opAnd()
      .groupStart()
      .whereClause('tffa__Type__c', '=: attr2')
      .opOR()
      .whereClause('tffa__Type__c', '=: attr3')
      .opOR()
      .whereClause('tffa__Type__c', '=: attr4')
      .groupEnd()
      .opAnd()
      .whereClause('tffa__EventName__c', '=: attr5')
      .opAnd()
      .whereClause('tffa__Accepted__c', '= false')
      .orderBy('tffa__SortOrder__c')
      .build()
      .toQuery();
    List<tffa__Disclosure__c> submissionDisclosures = doQuery(
      query,
      new List<Object>{ submissionId, 'INTERNAL_CONTENT', 'TEXT', 'DOCUSIGN', 'Submission_ReviewAndSubmit' }
    );
    return submissionDisclosures;
  }

  public static List<tffa__Disclosure__c> getAppAccOpenedDisclosures(Id submissionId) {
    String query = new tffa.QueryBuilder(tffa__Disclosure__c.SObjectType)
      .selectFields()
      .whereClause('tffa__Submission__c', '=: attr1')
      .opAnd()
      .groupStart()
      .whereClause('tffa__Type__c', '=: attr2')
      .opOR()
      .whereClause('tffa__Type__c', '=: attr3')
      .opOR()
      .whereClause('tffa__Type__c', '=: attr4')
      .groupEnd()
      .opAnd()
      .whereClause('tffa__EventName__c', '=: attr5')
      .opAnd()
      .whereClause('tffa__Accepted__c', '= false')
      .orderBy('tffa__SortOrder__c')
      .includeInactive()
      .build()
      .toQuery();
    List<tffa__Disclosure__c> submissionDisclosures = doQuery(
      query,
      new List<Object>{ submissionId, 'INTERNAL_CONTENT', 'TEXT', 'DOCUSIGN', 'Application_DocumentGeneration' }
    );
    return submissionDisclosures;
  }

  public static tffa__Submission__c findSubmissionAndChildObjById(String subId) {
    String query = new tffa.QueryBuilder(tffa__Submission__c.SObjectType)
      .selectFields()
      .selectChildObject('tffa__Applications__r')
      .selectFields()
      .build()
      .selectChildObject('tffa__PartyXrefs__r')
      .selectFields() /** */
      .selectObject('tffa__Party__r')
      .selectFields() /** */
      .build()
      .build()
      .whereClause('Id', '= :attr1')
      .build()
      .toQuery();

    List<tffa__Submission__c> l = (List<tffa__Submission__c>) doQuery(query, new List<Object>{ subId });
    return l.isEmpty() ? null : l[0];
  }

  public static List<tffa__SubmissionPartyXref__c> findSubmissionByParty(List<id> ids) {
    String q = new tffa.QueryBuilder(tffa__SubmissionPartyXref__c.SObjectType)
      .selectFields()
      .whereClause('tffa__Party__c', '=:attr1')
      .build()
      .toQuery();
    List<tffa__SubmissionPartyXref__c> l = doQuery(q, new List<Object>{ ids });
    return l.isEmpty() ? null : l;
  }

  /**
   * @description Get submission record by ID
   * @param String submissionId
   * @return tffa__Submission__c
   */
  public static List<tffa__Submission__c> findSubmissionByIds(List<String> submissionId) {
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
      .whereClause('Id', 'In :attr1')
      //.withLimit(5)
      .build()
      .toQuery();
    //List<tffa__Submission__c> l = Database.query(q);
    List<tffa__Submission__c> l = (List<tffa__Submission__c>) doQuery(q, new List<Object>{ submissionId });
    return l.isEmpty() ? null : l;
  }

  /**
   * @description Get submission record by ID for retry batch
   * @param String submissionId
   * @return tffa__Submission__c
   */
  public static List<tffa__Submission__c> findSubByIds(List<String> submissionId) {
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
      .whereClause('Id', 'In :attr1')
      .opAnd()
      .whereClause('tffa__Status__c', '= :attr2')
      .build()
      .toQuery();
    //List<tffa__Submission__c> l = Database.query(q);
    List<tffa__Submission__c> l = (List<tffa__Submission__c>) doQuery(q, new List<Object>{ submissionId, CZWTFCConstants.SUBMITTED });
    return l.isEmpty() ? null : l;
  }

  /**
   * @description Get submission record by ID
   * @param String submissionId
   * @return tffa__Submission__c
   */
  public static tffa__Submission__c findSubWithProdById(Id id) {
    List<tffa__SubmissionPartyXref__c> subPartyList = CZWTFCSubmissionRepository.findSubmissionByParty(new List<id>{ id });

    if (subPartyList != null) {
      String q = new tffa.QueryBuilder(tffa__Submission__c.SObjectType)
        .selectFields()
        .selectChildObject('tffa__FundingRequests__r')
        .selectFields()
        .build()
        .selectChildObject('tffa__Applications__r')
        .selectFields()
        .selectObject('tffa__Product__r')
        .selectFields()
        .build()
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
      List<tffa__Submission__c> subList = doQuery(q, new List<Object>{ subPartyList[0].tffa__Submission__c });
      return subList.isEmpty() ? null : subList[0];
    }
    return null;
  }
  public static List<tffa__Submission__c> findSubmissionForPurge(List<String> subIds) {
    WintrustEnvConfig__mdt wintrustEnvConfig = CZWTFCHelperRepository.fetchWintrustEnvConfig();

    Date currentDate = system.today();
    Integer daysToAdd = Integer.valueOf(wintrustEnvConfig.PurgeSubmission__c) * -1;
    Date updatedDate = currentDate.addDays(daysToAdd);

    String query = new tffa.QueryBuilder(tffa__Submission__c.SObjectType)
      .selectFields()
      .selectChildObject('tffa__PartyXrefs__r')
      .selectFields() /** */
      .selectObject('tffa__Party__r')
      .selectFields() /** */
      .build()
      .build()
      .selectChildObject('tffa__Applications__r')
      .selectFields()
      .build()
      .whereClause('Id', 'In :attr1')
      .opAnd()
      .whereClause('LastModifiedDate', '< :attr2')
      .build()
      .toQuery();

    List<tffa__Submission__c> subList = doQuery(query, new List<Object>{ subIds, updatedDate });
    return subList.isEmpty() ? null : subList;
  }

  public static List<tffa__Submission__c> getExpiredAndCancelSubmission() {
    WintrustEnvConfig__mdt wintrustEnvConfig = CZWTFCHelperRepository.fetchWintrustEnvConfig();

    List<String> statusList = new List<String>{ 'EXPIRED', 'CANCELLED' };

    Date currentDate = system.today();
    Integer daysToAdd = Integer.valueOf(wintrustEnvConfig.PurgeExpiredAndCancelSub__c) * -1;
    Date updatedDate = currentDate.addDays(daysToAdd);

    String query = new tffa.QueryBuilder(tffa__Submission__c.SObjectType)
      .selectFields()
      .selectChildObject('tffa__PartyXrefs__r')
      .selectFields() /** */
      .selectObject('tffa__Party__r')
      .selectFields() /** */
      .build()
      .build()
      .selectChildObject('tffa__Applications__r')
      .selectFields()
      .build()
      .whereClause('tffa__Status__c', 'In :attr1')
      .opAnd()
      .whereClause('LastModifiedDate', '< :attr2')
      .build()
      .toQuery();

    List<tffa__Submission__c> subList = doQuery(query, new List<Object>{ statusList, updatedDate });
    return subList.isEmpty() ? null : subList;
  }

  /**
   * Fetches submission party relationship for the given submission and party
   */
  public static tffa__SubmissionPartyXref__c findbySubmissionAndParty(String subId, String partyId) {
    String q = new tffa.QueryBuilder(tffa__SubmissionPartyXref__c.SObjectType)
      .selectFields()
      .whereClause('Submission__c', '=:attr1')
      .opAnd()
      .whereClause('Party__c', '=:attr2')
      .build()
      .toQuery();
    //List<tffa__SubmissionPartyXref__c> l = Database.query(q);
    List<tffa__SubmissionPartyXref__c> l = (List<tffa__SubmissionPartyXref__c>) doQuery(q, new List<Object>{ subId, partyId });
    return l.isEmpty() ? null : l[0];
  }

  public static List<tffa__Submission__c> fetchSubForCCDelete() {
    WintrustEnvConfig__mdt wintrustEnvConfig = CZWTFCHelperRepository.fetchWintrustEnvConfig();
    List<tffa__Submission__c> resp = new List<tffa__Submission__c>();
    String query = new tffa.QueryBuilder(tffa__FundingRequest__c.SObjectType)
      .selectFields()
      .selectObject('tffa__Submission__r')
      .selectFields() /** */
      .build()
      .whereClause('tffa__Type__c', '=:attr1') //DEBIT_CARD
      .opAnd()
      .whereClause('tffa__Status__c', 'In :attr2')
      .opAnd()
      .whereClause('ReversalRetryCount__c', '<: attr3')
      .build()
      .toQuery();

    List<tffa__FundingRequest__c> fundReqLst = (List<tffa__FundingRequest__c>) doQuery(
      query,
      new List<Object>{ CZWTFCConstants.DEBIT_CARD, CZWTFCConstants.CCDEL_FUND_STATUS, wintrustEnvConfig.BatchRetryCount__c }
    );

    if (fundReqLst != null && !fundReqLst.isEmpty()) {
      Set<String> subLst = new Set<String>();
      for (tffa__FundingRequest__c fundObj : fundReqLst) {
        subLst.add(fundObj.tffa__Submission__c);
      }

      if (subLst != null && !subLst.isEmpty()) {
        String q = new tffa.QueryBuilder(tffa__Submission__c.SObjectType)
          .selectFields()
          .selectChildObject('tffa__FundingRequests__r')
          .selectFields()
          .build()
          .selectChildObject('tffa__Applications__r')
          .selectFields()
          .whereClause('tffa__Status__c', 'In :attr1')
          .build()
          .whereClause('Id', 'In :attr2')
          .build()
          .toQuery();
        resp = (List<tffa__Submission__c>) doQuery(q, new List<Object>{ CZWTFCConstants.CC_TRANS_DEL_APP_STATUS, subLst });
      }
    }
    return resp.isEmpty() ? new List<tffa__Submission__c>() : resp;
  }

  public static List<tffa__Submission__c> findSubmissionAndDisclosure() {
    String query = new tffa.QueryBuilder(tffa__Submission__c.SObjectType)
      .selectFields()
      .selectChildObject('tffa__Disclosures__r')
      .selectFields()
      .whereClause('tffa__Accepted__c', '= :attr1')
      .OpAnd()
      .whereClause('tffa__Type__c', '= :attr2')
      .orderBy('tffa__SortOrder__c')
      .build()
      .whereClause('DisclosureConverted__c', '= :attr3')
      .OpAnd()
      .whereClause('tffa__Status__c', '= :attr4')
      .withLimit(5000)
      .build()
      .toQuery();

    List<tffa__Submission__c> l = (List<tffa__Submission__c>) doQuery(
      query,
      new List<Object>{ true, 'TEXT', false, CZWTFCConstants.SUBMITTED }
    );
    return l.isEmpty() ? new List<tffa__Submission__c>() : l;
  }

  public static List<tffa__Disclosure__c> getAccountDetailsOdDisclosures(Id submissionId) {
    String query = new tffa.QueryBuilder(tffa__Disclosure__c.SObjectType)
      .selectFields()
      .whereClause('tffa__Submission__c', '=: attr1')
      .opAnd()
      .whereClause('tffa__EventName__c', '=: attr2')
      .build()
      .toQuery();
    List<tffa__Disclosure__c> submissionDisclosures = doQuery(query, new List<Object>{ submissionId, 'AccountDetails_OD' });
    return submissionDisclosures;
  }

  /**
   * Used by IDVServiceProvider
   */
  public static tffa__Submission__c fetchDataForIDVServiceProvider(String id) {
    String q = new tffa.QueryBuilder(tffa__Submission__c.SObjectType)
      .selectFields()
      .selectChildObject('Applications__r')
      .selectFields(new List<String>{ 'ProductCategory__c' })
      .build()
      .selectChildObject('PartyXrefs__r')
      .selectFields()
      .whereClause('Role__c', '= :attr2')
      .build()
      .whereClause('Id', '= :attr1')
      .withLimit(1)
      .build()
      .toQuery();
    return (tffa__Submission__c) doQueryOne(q, new List<Object>{ id, 'APPLICANT' });
  }

  /**
   * Fetches a submission entity by id.
   */
  public static tffa__Submission__c fetchSubmissionbyId(String id) {
    String q = new tffa.QueryBuilder(tffa__Submission__c.SObjectType)
      .selectFields()
      .whereClause('Id', '=:attr1')
      .withLimit(1)
      .build()
      .toQuery();
    return (tffa__Submission__c) doQueryOne(q, new List<Object>{ id });
  }

  public static List<tffa__Submission__c> fetchSubmissionswithDisc() {
    String q = new tffa.QueryBuilder(tffa__Submission__c.SObjectType)
      .selectFields()
      .selectChildObject('tffa__Disclosures__r')
      .selectFields()
      .whereClause('tffa__Type__c', '=:attr1')
      .build()
      .whereClause('CZDocusignDownloadStatus__c', '!= :attr2')
      .opAnd()
      .whereClause('CZSigningStatus__c', '= :attr3')
      .opAnd()
      .whereClause('tffa__Status__c', '= :attr4')
      .opAnd()
      .whereClause('CZDocusignDownloadRetryCount__c', ' < :attr5')
      .build()
      .toQuery();
    List<tffa__Submission__c> submissionWithDisclosures = doQuery(
      q,
      new List<Object>{
        CZWTFCConstants.DOCUSIGN,
        CZWTFCConstants.COMPLETED,
        CZWTFCConstants.SIGNING_COMPLETED,
        CZWTFCConstants.SUBMITTED,
        10
      }
    );
    return submissionWithDisclosures;
  }

  public static List<tffa__Submission__c> fetchSubmissionswithDiscById(List<Id> ids) {
    String q = new tffa.QueryBuilder(tffa__Submission__c.SObjectType)
      .selectFields()
      .selectChildObject('tffa__Disclosures__r')
      .selectFields()
      .whereClause('tffa__Type__c', '=:attr1')
      .build()
      .whereClause('Id', 'In :attr2')
      .build()
      .toQuery();
    List<tffa__Submission__c> submissionWithDisclosures = doQuery(q, new List<Object>{ CZWTFCConstants.DOCUSIGN, ids });
    return submissionWithDisclosures;
  }

  public static List<tffa__Submission__c> fetchSubmissionssForFCM(Integer retryCount, List<String> fcmStatusLst) {
    String q = new tffa.QueryBuilder(tffa__Submission__c.SObjectType)
      .selectFields()
      .selectChildObject('tffa__Applications__r')
      .selectFields()
      .build()
      .whereClause('tffa__Status__c', '=:attr1')
      .opAnd()
      .whereClause('FCMUploadRetryCount__c', ' < :attr2')
      .opAnd()
      .whereClause('FCMUploadStatus__c', 'NOT IN :attr3')
      .build()
      .toQuery();
    return (List<tffa__Submission__c>) doQuery(q, new List<Object>{ CZWTFCConstants.SUBMITTED, retryCount, fcmStatusLst });
  }

  public static Map<String, List<tffa__Disclosure__c>> fetchEnvsByEnvIds(List<tffa__Disclosure__c> discList) {
    Set<Id> envIds = new Set<Id>();
    for (tffa__Disclosure__c d : discList) {
      envIds.add(d.tffa__Envelope__c);
    }
    Map<String, List<tffa__Disclosure__c>> envMap = new Map<String, List<tffa__Disclosure__c>>();
    String q = new tffa.QueryBuilder(tffa__DisclosureEnvelope__c.SObjectType)
      .selectFields()
      .selectChildObject('tffa__Disclosures__r')
      .selectFields()
      .build()
      .whereClause('Id', 'In :attr1')
      .build()
      .toQuery();
    List<tffa__DisclosureEnvelope__c> result = doQuery(q, new List<Object>{ envIds });
    if (!result.isEmpty()) {
      for (tffa__DisclosureEnvelope__c envObj : result) {
        envMap.put(envObj.tffa__ExternalId__c, envObj.tffa__Disclosures__r);
      }
    }
    return envMap;
  }

  /**
   * @description Get submission record by ID
   * @param String submissionId
   * @return tffa__Submission__c
   */
  public static tffa__Submission__c findSubmissionByIdForDocusign(String submissionId) {
    String q = new tffa.QueryBuilder(tffa__Submission__c.SObjectType)
      .selectFields()
      .selectChildObject('tffa__PartyXrefs__r')
      .selectFields() /** */
      .selectObject('tffa__Party__r')
      .selectFields() /** */
      .selectObject('CZLocation__r')
      .selectFields() /** */
      .build()
      .build()
      .orderBy('tffa__Primary__c', true) //.orderBy('ID')
      .build()
      .whereClause('Id', '=:attr1')
      .build()
      .toQuery();
    //List<tffa__Submission__c> l = Database.query(q);
    List<tffa__Submission__c> l = (List<tffa__Submission__c>) doQuery(q, new List<Object>{ submissionId });
    return l.isEmpty() ? null : l[0];
  }
}