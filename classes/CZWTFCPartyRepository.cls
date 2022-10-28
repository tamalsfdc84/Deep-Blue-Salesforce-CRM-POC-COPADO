global with sharing class CZWTFCPartyRepository extends tffa.AbstractRepository {
  /*
   * @descrption used to get tffa__Party__c in list according to Party id
   * @params partyID
   * @return List<tffa__Party__c>
   */
  public static tffa__Party__c fetchPartyById(String id) {
    String q = new tffa.QueryBuilder(tffa__Party__c.SObjectType).selectFields().whereClause('Id', '=:attr1').build().toQuery();

    List<tffa__Party__c> partyList = doQuery(q, new List<Object>{ id });

    return partyList.isEmpty() ? null : partyList[0];
  }

  /**
   * Fetches a party entity by id along with all child relationships
   */
  public static tffa__Party__c findByIdWithChildObjects(String id) {
    String q = new tffa.QueryBuilder(tffa__Party__c.SObjectType)
      .selectFields() /** */
      .selectChildObject('tffa__AddressXrefs__r') /** */
      .selectFields() /** */ /** */
      .selectObject('tffa__Address__r') /** */ /** */
      .selectFields() /** */ /** */
      .build() /** */
      .build() /** */ /** */ /** */
      .selectChildObject('Identifications__r') /** */ /** */ /** */
      .selectFields() /** */ /** */ /** */
      .build() /** */ /** */ /** */ /** */
      .selectChildObject('tffa__DueDiligences__r') /** */ /** */ /** */ /** */
      .selectFields() /** */ /** */ /** */ /** */
      .build()
      .selectChildObject('tffa__Employments__r') /** */ /** */ /** */ /** */
      .selectFields() /** */ /** */ /** */ /** */
      .build()
      .selectChildObject('tffa__AdditionalPreferences__r') /** */ /** */ /** */ /** */
      .selectFields() /** */ /** */ /** */ /** */
      .build()
      .selectChildObject('tffa__Applications__r') /** */ /** */ /** */ /** */
      .selectFields() /** */ /** */ /** */ /** */
      .build()
      .whereClause('Id', '=:attr1')
      .withLimit(1)
      .build()
      .toQuery();

    List<tffa__Party__c> party = (List<tffa__Party__c>) doQuery(q, new List<Object>{ id });
    return party.isEmpty() ? null : party[0];
  }

  /**
   * Fetches a party entity by id along with all child relationships without dd
   */
  public static tffa__Party__c findByIdWithChildObjs(String id) {
    String q = new tffa.QueryBuilder(tffa__Party__c.SObjectType)
      .selectFields() /** */
      .selectChildObject('tffa__AddressXrefs__r') /** */
      .selectFields() /** */ /** */
      .selectObject('tffa__Address__r') /** */ /** */
      .selectFields() /** */ /** */
      .build() /** */
      .build() /** */ /** */ /** */
      .selectChildObject('Identifications__r') /** */ /** */ /** */
      .selectFields() /** */ /** */ /** */
      .build() /** */ /** */ /** */ /** */
      .selectChildObject('tffa__Employments__r') /** */ /** */ /** */ /** */
      .selectFields() /** */ /** */ /** */ /** */
      .build()
      .selectChildObject('tffa__AdditionalPreferences__r') /** */ /** */ /** */ /** */
      .selectFields() /** */ /** */ /** */ /** */
      .build()
      .whereClause('Id', '=:attr1')
      .withLimit(1)
      .build()
      .toQuery();

    List<tffa__Party__c> party = (List<tffa__Party__c>) doQuery(q, new List<Object>{ id });
    return party.isEmpty() ? null : party[0];
  }

  public static List<tffa__Party__c> save(List<tffa__Party__c> entities) {
    return (List<tffa__Party__c>) doUpsert(entities);
  }

  public static List<tffa__AdditionalPreference__c> saveAddPreferences(List<tffa__AdditionalPreference__c> entities) {
    return (List<tffa__AdditionalPreference__c>) doUpsert(entities);
  }

  /**
   * Fetches MXConfiguration__mdt corresponding to the API
   */
  public static MXConfiguration__mdt fetchMxParams(String mxServiceMapper) {
    String q = new tffa.QueryBuilder(MXConfiguration__mdt.SObjectType)
      .selectFields()
      .whereClause('DeveloperName', '= :attr1')
      .build()
      .toQuery();
    //List<MXConfiguration__mdt> result = Database.query(q);
    List<MXConfiguration__mdt> result = (List<MXConfiguration__mdt>) doQuery(q, new List<Object>{ mxServiceMapper });
    return result.isEmpty() ? new MXConfiguration__mdt() : result[0];
  }

  public static List<tffa__Party__c> findAllPartiesByIds(List<String> ids) {
    String q = new tffa.QueryBuilder(tffa__Party__c.SObjectType)
      .selectFields()
      .selectChildObject('tffa__AddressXrefs__r') /** */
      .selectFields() /** */ /** */
      .selectObject('tffa__Address__r') /** */ /** */
      .selectFields() /** */ /** */
      .build() /** */
      .whereClause('tffa__Type__c', '= :attr1')
      .build()
      .whereClause('Id', 'In :attr2')
      .build()
      .toQuery();
    return doQuery(q, new List<Object>{ 'HOME', ids });
  }

  public static Map<String, tffa__Party__c> findAllPartiesWithChildByIds(tffa__Submission__c sub) {
    List<String> ids = new List<String>();
    Map<String, tffa__Party__c> partyMap = new Map<String, tffa__Party__c>();
    for (tffa__SubmissionPartyXref__c subP : sub.tffa__PartyXrefs__r) {
      ids.add(subP.tffa__Party__c);
    }

    if (!ids.isEmpty()) {
      String q = new tffa.QueryBuilder(tffa__Party__c.SObjectType)
        .selectFields()
        .selectChildObject('tffa__AddressXrefs__r') /** */
        .selectFields() /** */ /** */
        .selectObject('tffa__Address__r') /** */ /** */
        .selectFields() /** */ /** */
        .build() /** */
        .build() /** */ /** */ /** */
        .selectChildObject('Identifications__r') /** */ /** */ /** */
        .selectFields() /** */ /** */ /** */
        .build() /** */ /** */ /** */ /** */
        .selectChildObject('tffa__DueDiligences__r') /** */ /** */ /** */ /** */
        .selectFields() /** */ /** */ /** */ /** */
        .build()
        .selectChildObject('tffa__AdditionalPreferences__r') /** */ /** */ /** */ /** */
        .selectFields() /** */ /** */ /** */ /** */
        .build()
        .whereClause('Id', 'In :attr1')
        .build()
        .toQuery();

      List<tffa__Party__c> partyList = doQuery(q, new List<Object>{ ids });
      if (partyList != null && !partyList.isEmpty()) {
        for (tffa__Party__c partyObj : partyList) {
          partyMap.put(partyObj.Id, partyObj);
        }
      }
    }
    return partyMap;
  }

  /**
   *
   */
  public static List<tffa__Party__c> findPartyObj(String emailAddress, String lastName, String last3SSN) {
    String q = new tffa.QueryBuilder(tffa__Party__c.SObjectType)
      .selectFields()
      .whereClause('tffa__PrimaryEmail__c', '=:attr1')
      .opAnd()
      .whereClause('tffa__LastName__c', '=:attr2')
      .opAnd()
      .whereClause('tffa__LastnNationalIdentifierValue__c', '=:attr3')
      .build()
      .toQuery();
    //return Database.query(q);
    return (List<tffa__Party__c>) doQuery(q, new List<Object>{ emailAddress, lastName, last3SSN });
  }

  /**
   *
   */
  public static List<tffa__Party__c> findPartyObject(String emailAddress, String lastName, String last3SSN, String brand) {
    String q = new tffa.QueryBuilder(tffa__Party__c.SObjectType)
      .selectFields()
      .whereClause('tffa__PrimaryEmail__c', '=:attr1')
      .opAnd()
      .whereClause('tffa__LastName__c', '=:attr2')
      .opAnd()
      .whereClause('tffa__LastnNationalIdentifierValue__c', '=:attr3')
      .opAnd()
      .whereClause('tffa__BrandCode__c', '=:attr4')
      .build()
      .toQuery();
    //return Database.query(q);
    return (List<tffa__Party__c>) doQuery(q, new List<Object>{ emailAddress, lastName, last3SSN, brand });
  }

  public static tffa__Employment__c findEmploymentByPartyID(String id) {
    String q = new tffa.QueryBuilder(tffa__Employment__c.SObjectType)
      .selectFields()
      .whereClause('tffa__Party__c', '=:attr1')
      .build()
      .toQuery();
    List<tffa__Employment__c> empList = (List<tffa__Employment__c>) doQuery(q, new List<Object>{ id });
    return empList.isEmpty() ? null : empList[0];
  }

  public static List<tffa__SubmissionPartyXref__c> saveSubPartyXref(List<tffa__SubmissionPartyXref__c> entities) {
    return (List<tffa__SubmissionPartyXref__c>) doUpsert(entities);
  }

  public static tffa__Party__c findByIdWithOLBAddPref(String id) {
    String q = new tffa.QueryBuilder(tffa__Party__c.SObjectType)
      .selectFields()
      .selectChildObject('tffa__AdditionalPreferences__r')
      .selectFields()
      .whereClause('tffa__AddOnServiceType__c', '=:attr1')
      .build()
      .whereClause('Id', '=:attr2')
      .withLimit(1)
      .build()
      .toQuery();
    List<tffa__Party__c> party = (List<tffa__Party__c>) doQuery(q, new List<Object>{ FISCCIntegrationConstants.ADDON_OLB_TYPE, id });
    return party.isEmpty() ? null : party[0];
  }

  public static tffa__SubmissionPartyXref__c findSubPartyById(String id) {
    List<String> queryParams = new List<String>();
    queryParams.add(id);
    String q = new tffa.QueryBuilder(tffa__SubmissionPartyXref__c.SObjectType)
      .selectFields()
      .whereClause('tffa__Party__c', '=:attr1')
      .build()
      .toQuery();

    List<tffa__SubmissionPartyXref__c> submissionJointPartyXref = doQuery(q, queryParams);

    return submissionJointPartyXref.isEmpty() ? null : submissionJointPartyXref[0];
  }

  public static tffa__AdditionalPreference__c findAdditionalPreferenceByPartyIdAndCode(String id, String code) {
    String q = new tffa.QueryBuilder(tffa__AdditionalPreference__c.SObjectType)
      .selectFields()
      .whereClause('tffa__Code__c', '=:attr1')
      .opAnd()
      .whereClause('tffa__Party__c', '=:attr2')
      .build()
      .toQuery();
    List<tffa__AdditionalPreference__c> additionalPreference = (List<tffa__AdditionalPreference__c>) doQuery(
      q,
      new List<Object>{ code, id }
    );
    return additionalPreference.isEmpty() ? null : additionalPreference[0];
  }

  public static List<tffa__Party__c> fetchPartyByMDMUploadStatus(String status) {
    String q = new tffa.QueryBuilder(tffa__Party__c.SObjectType)
      .selectFields()
      .selectChildObject('tffa__Submissions__r')
      .selectFields()
      .build()
      .whereClause('MDMUploadStatus__c', '=:attr1')
      .opAnd()
      .whereClause('MDMUploadRetryCount__c', ' < :attr2')
      .build()
      .toQuery();

    WintrustEnvConfig__mdt wintrustEnvConfig = CZWTFCHelperRepository.fetchWintrustEnvConfig();

    List<tffa__Party__c> partyList = doQuery(q, new List<Object>{ status, wintrustEnvConfig.BatchRetryCount__c });

    return partyList.isEmpty() ? new List<tffa__Party__c>() : partyList;
  }

  public static List<tffa__Party__c> fetchPartyByIds(Set<String> ids) {
    String q = new tffa.QueryBuilder(tffa__Party__c.SObjectType).selectFields().whereClause('Id', ' IN :attr1').build().toQuery();

    List<tffa__Party__c> partyList = doQuery(q, new List<Object>{ ids });

    return partyList.isEmpty() ? new List<tffa__Party__c>() : partyList;
  }

  /**
   * Fetches parties by ids.
   */
  public static List<tffa__Party__c> findByIdWithAddressType(Set<String> ids, Set<String> addressTypes) {
    String q = new tffa.QueryBuilder(tffa__Party__c.SObjectType)
      .selectFields()
      .selectChildObject('AddressXrefs__r')
      .selectFields()
      .selectObject('Address__r')
      .selectFields()
      .build()
      .whereClause('Type__c', 'in :attr2')
      .build()
      .whereClause('Id', 'in :attr1')
      .withLimit(ids.size())
      .build()
      .toQuery();
    return doQuery(q, new List<Object>{ ids, addressTypes });
  }
}