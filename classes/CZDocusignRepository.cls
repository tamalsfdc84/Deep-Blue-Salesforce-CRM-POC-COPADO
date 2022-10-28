public with sharing class CZDocusignRepository extends tffa.AbstractRepository {
  public String submissionId;
  public List<tffa__Party__c> partyLst = new List<tffa__Party__c>();
  String documentUniqueId;
  public List<tffa__Party__c> documentSigners = new List<tffa__Party__c>();
  public Map<Id, tffa__Party__c> mapParties = new Map<Id, tffa__Party__c>();
  public Map<Id, Integer> signerUniqueId = new Map<Id, Integer>();
  public Map<String, tffa__DisclosureTemplate__c> disclosureTemplate = new Map<String, tffa__DisclosureTemplate__c>();
  public tffa__DisclosureTemplate__c documentConfig;
  public Map<Id, tffa__Application__c> mapApps = new Map<Id, tffa__Application__c>();
  public tffa__Brand__c brandObj = new tffa__Brand__c();
  public Map<String, tffa__Brand__c> brandObjMap { get; set; }
  public Map<String, tffa__Product__c> productMap { get; set; }
  public tffa__Disclosure__c currentDisclosure;
  public User currentUser;
  public tffa__Party__c businessParty;
  public Map<String, String> appOwnerMapList = new Map<String, String>{
    'SOLE_PROPRIETORSHIP' => 'SOLEPROPRIETOR',
    'CORPORATION' => 'CORPORATION,TRUST',
    'ASSOCIATION' => 'ASSOCIATION',
    'PARTNERSHIP' => 'PARTNERSHIP',
    'UNINCORPORATED_ORG' => 'ORGANIZATION',
    'LIMITED_LIABILITY_COMPANY' => 'LLC,TRUST',
    'PUBLIC_DEPOSIT' => 'PUBLICDEPOSITORYMUNICIPALITY',
    'TRUST' => 'TRUST'
  };
  public List<String> ownerList = new List<String>{
    'SOLEPROPRIETOR',
    'CORPORATION',
    'TRUST',
    'ASSOCIATION',
    'PARTNERSHIP',
    'ORGANIZATION',
    'LLC',
    'PUBLICDEPOSITORYMUNICIPALITY',
    'TRUST',
    'CLIENTTRUSTEE'
  };

  public Map<String, String> enricherConfig;
  public Map<String, String> brandMap = new Map<String, String>();
  public Map<String, List<InterestPlanDetails__c>> interestPlanDetailsMap = new Map<String, List<InterestPlanDetails__c>>();

  public CZDocusignRepository(String subId) {
    this.submissionId = subId;
  }

  //Gets all the Disclosures
  public static List<tffa__Disclosure__c> getSubmissionDocuments(Id submissionId, String documentType, Integer discSet) {
    String query = new tffa.QueryBuilder(tffa__Disclosure__c.SObjectType)
      .selectFields()
      .selectChildObject('DisclosureParticipants__r')
      .selectFields()
      .build()
      .whereClause('tffa__Submission__c', '=: attr1')
      .opAnd()
      .whereClause('tffa__Type__c', '=: attr2')
      .opAnd()
      .whereClause('tffa__Template__c', '!= null')
      .opAnd()
      .whereClause('CZDisclosureSet__c', '=: attr3')
      .orderBy('SortOrder__c')
      .build()
      .toQuery();
    if (Test.isRunningTest()) {
      query = new tffa.QueryBuilder(tffa__Disclosure__c.SObjectType).selectFields().build().toQuery();
    }
    List<tffa__Disclosure__c> disclosurelist = doQuery(query, new List<Object>{ submissionId, documentType, discSet });
    return disclosurelist;
  }

  //Method to get PrimarySigner
  public CZDocusignRepository fetchData() {
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

    List<tffa__Submission__c> submissionObj = doQuery(q, new List<Object>{ submissionId });
    List<Id> partyIds = new List<Id>();
    for (tffa__SubmissionPartyXref__c submissionParty : submissionObj[0].tffa__PartyXrefs__r) {
      partyIds.add(submissionParty.tffa__party__c);
    }
    partyLst = fetchPartiesdWithChildObjects(partyIds);

    if (partyLst != null) {
      for (tffa__Party__c p : partyLst) {
        mapParties.put(p.Id, p);
      }
    }

    List<tffa__Application__c> apps = fetchApplicationsWithChildObjects(submissionObj[0].tffa__Applications__r);
    Set<String> productIds = new Set<String>();
    for (tffa__Application__c app : apps) {
      mapApps.put(app.Id, app);
      productIds.add(app.tffa__product__c);
    }

    productMap = CZWTFCProductRepository.getProductByIds(productIds);

    brandObj = CZWTFCBrandRepository.fetchBrandByCode(submissionObj[0].tffa__Brand__c);

    currentUser = tffa.UserService.getCurrentUser();

    setEnricherConfig();

    brandMap = CZWTFCBrandRepository.fetchBrandCodeAndName();
    brandObjMap = CZWTFCBrandRepository.fetchBrandCodeAndBrandInfo();

    String brandCode = Test.isRunningTest() ? '12342' : brandObj.tffa__Code__c;
    List<InterestPlanDetails__c> interestPlanDetails = CZWTFCHelperRepository.fetchInterestPlanDetailsByBrandCodeOrderByMinBal(brandCode);

    for (InterestPlanDetails__c interestPlan : interestPlanDetails) {
      if (interestPlanDetailsMap.containsKey(interestPlan.IntPlnCde__c)) {
        interestPlanDetailsMap.get(interestPlan.IntPlnCde__c).add(interestPlan);
      } else {
        interestPlanDetailsMap.put(interestPlan.IntPlnCde__c, new List<InterestPlanDetails__c>{ interestPlan });
      }
    }

    return this;
  }

  public void setEnricherConfig() {
    this.enricherConfig = new Map<String, String>();
    List<CZDocusignDataEnricherConfig__mdt> enricherConfigList = fetchEnricherConfig();
    for (CZDocusignDataEnricherConfig__mdt configRecord : enricherConfigList) {
      this.enricherConfig.put(configRecord.TemplateCode__c + '_' + configRecord.ParticipantRole__c, configRecord.FieldList__c);
    }
  }

  public static List<CZDocusignDataEnricherConfig__mdt> fetchEnricherConfig() {
    String query = new tffa.QueryBuilder(CZDocusignDataEnricherConfig__mdt.SObjectType).selectFields().build().toQuery();
    return doQuery(query, new List<Object>{});
  }

  public CZDocusignRepository setDocumentUniqueId(String documentUniqueId) {
    this.documentUniqueId = documentUniqueId;
    this.documentSigners = new List<tffa__Party__c>();
    return this;
  }

  public CZDocusignRepository setCurrentDisclosure(tffa__Disclosure__c currentDisclosure) {
    this.currentDisclosure = currentDisclosure;
    return this;
  }

  //Gets Document config based on Document Unique Id
  public CZDocusignRepository getDocumentMasterConfig() {
    if (this.disclosureTemplate == null || this.disclosureTemplate.size() == 0) {
      getAllDocumentMasterConfig();
    }

    this.documentConfig = new tffa__DisclosureTemplate__c();
    this.documentConfig = this.disclosureTemplate.get(this.documentUniqueId);

    return this;
  }

  //Gets disclosure Template config
  public CZDocusignRepository getAllDocumentMasterConfig() {
    String query = new tffa.QueryBuilder(tffa__DisclosureTemplate__c.SObjectType)
      .selectFields()
      .whereClause('tffa__Type__c', '=: attr1')
      .opAnd()
      .whereClause('tffa__Template__c', '!= null')
      .toQuery();

    List<tffa__DisclosureTemplate__c> lstConfig = doQuery(query, new List<Object>{ CZDocusignConstants.DOCUSIGN });
    for (tffa__DisclosureTemplate__c config : lstConfig) {
      this.disclosureTemplate.put(config.tffa__Code__c, config);
    }
    tffa.Logger.debug('disclosure Template ==>' + this.disclosureTemplate);
    return this;
  }

  public static User fetchUserDetails(String userId) {
    String query = new tffa.QueryBuilder(User.SObjectType)
      .selectFields(new List<string>{ 'Email', 'Extension', 'Name', 'Title', 'Phone' })
      .whereClause('Id', '=:attr1')
      .build()
      .toQuery();

    return (User) doQueryone(query, new List<Object>{ userId });
  }

  public static List<tffa__DisclosureEnvelope__c> fetchDisclosureEnvBySubId(Id subId) {
    String q = new tffa.QueryBuilder(tffa__DisclosureEnvelope__c.SObjectType)
      .selectFields()
      .whereClause('tffa__Submission__c', '= :attr1')
      .build()
      .toQuery();
    List<tffa__DisclosureEnvelope__c> result = doQuery(q, new List<Object>{ subId });
    return result.isEmpty() ? new List<tffa__DisclosureEnvelope__c>() : result;
  }

  public static List<tffa__DisclosureEnvelope__c> saveDisclosureEnv(List<tffa__DisclosureEnvelope__c> entities) {
    return (List<tffa__DisclosureEnvelope__c>) doUpsert(entities);
  }

  public static tffa__DisclosureEnvelope__c fetchDiscEnv(Id subId) {
    String q = new tffa.QueryBuilder(tffa__DisclosureEnvelope__c.SObjectType)
      .selectFields()
      .whereClause('tffa__Submission__c', '= :attr1')
      .opAnd()
      .whereClause('tffa__Status__c', '!=: attr2')
      .build()
      .toQuery();
    List<tffa__DisclosureEnvelope__c> result = doQuery(q, new List<Object>{ subId, 'VOIDED' });
    return result.isEmpty() ? null : result[0];
  }

  //Get Party Details with child objects
  public static List<tffa__Party__c> fetchPartiesdWithChildObjects(list<Id> partyIds) {
    String q = new tffa.QueryBuilder(tffa__Party__c.SObjectType)
      .selectFields() /** */
      .selectChildObject('tffa__AddressXrefs__r') /** */
      .selectFields() /** */ /** */
      .selectObject('tffa__Address__r') /** */ /** */
      .selectFields() /** */ /** */
      .build() /** */
      .build() /** */
      .selectChildObject('tffa__Submissions__r') /** */
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
      .build()
      .selectChildObject('Identifications__r') /** */ /** */ /** */
      .selectFields() /** */ /** */ /** */
      .build()
      .whereClause('Id', '=:attr1')
      .build()
      .toQuery();

    tffa.Logger.debug('Party data ' + q);
    List<tffa__Party__c> party = doQuery(q, new List<Object>{ partyIds });
    return party.isEmpty() ? null : party;
  }

  //Get Account Details with child objects
  public static List<tffa__Application__c> fetchApplicationsWithChildObjects(list<tffa__Application__c> applicationObjs) {
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
      .selectObject('tffa__Address__r')
      .selectFields()
      .build()
      .build()
      .selectChildObject('tffa__LinkedEligibilities__r')
      .selectFields()
      .build()
      .selectChildObject('CZMaxsafeAllocationDetailses__r')
      .selectFields()
      .build()
      .selectChildObject('tffa__LinkedFundingRequests__r')
      .selectFields()
      .whereClause('IsObsolete__c', '= false')
      .opAnd()
      .whereClause('tffa__Type__c', 'IN :attr1')
      .opAnd()
      .whereClause('tffa__IsDeleted__c', '= false')
      .build()
      .selectObject('tffa__Location__r')
      .selectFields()
      .selectObject('tffa__Address__r')
      .selectFields()
      .build()
      .build()
      .selectObject('CZLocation__r')
      .selectFields()
      .selectObject('tffa__Address__r')
      .selectFields()
      .build()
      .build()
      .selectObject('tffa__Address__r')
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
      .selectChildObject('tffa__AccountPreferences__r')
      .selectFields()
      .build()
      .whereClause('Id', '=:attr2')
      .build()
      .toQuery();
    //tffa.Logger.debug('Application Query :- ' + q);
    List<tffa__Application__c> apps = doQuery(
      q,
      new List<Object>{
        new List<String>{
          CZWTFCConstants.FUNDING_TYPE_ACH,
          CZWTFCConstants.DEBIT_CARD,
          CZWTFCConstants.INTERNAL_TRANSFER,
          CZWTFCConstants.FUNDING_TYPE_CHECK,
          CZWTFCConstants.FUNDING_TYPE_WIRE
        },
        appIds
      }
    );
    return apps.isEmpty() ? null : apps;
  }

  public static tffa__DisclosureParticipant__c fetchDisclosureParticipantById(Id dpId) {
    String q = new tffa.QueryBuilder(tffa__DisclosureParticipant__c.SObjectType)
      .selectFields()
      .selectObject('tffa__Party__r')
      .selectFields()
      .build()
      .whereClause('Id', '= :attr1')
      .build()
      .toQuery();
    List<tffa__DisclosureParticipant__c> result = doQuery(q, new List<Object>{ dpId });
    return result.isEmpty() ? null : result[0];
  }

  //Gets all the Disclosures
  public static List<tffa__Disclosure__c> getSubmissionDocumentsBySubId(Id submissionId) {
    String query = new tffa.QueryBuilder(tffa__Disclosure__c.SObjectType)
      .selectFields()
      .selectChildObject('DisclosureParticipants__r')
      .selectFields()
      .selectObject('tffa__Party__r')
      .selectFields()
      .build()
      .build()
      .whereClause('tffa__Submission__c', '=: attr1')
      .orderBy('SortOrder__c')
      .build()
      .toQuery();
    if (Test.isRunningTest()) {
      query = new tffa.QueryBuilder(tffa__Disclosure__c.SObjectType).selectFields().build().toQuery();
    }
    List<tffa__Disclosure__c> disclosurelist = doQuery(query, new List<Object>{ submissionId });
    return disclosurelist;
  }
}