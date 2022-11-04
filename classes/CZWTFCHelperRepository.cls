public inherited sharing class CZWTFCHelperRepository extends tffa.AbstractRepository {
  /**
   * Fetch Doc
   */
  public static Document getDoc(String names) {
    String q = new tffa.QueryBuilder(Document.SObjectType).selectFields().whereClause('Name', '=:attr1').build().toQuery();

    List<Document> docList = doQuery(q, new List<Object>{ names });

    return docList.isEmpty() ? null : docList.get(0);
  }

  /**
   * Fetch Doc
   */
  public static void deleteContentDocument(String name) {
    String q = new tffa.QueryBuilder(ContentDocument.SObjectType).selectFields().whereClause('Title', '=:attr1').build().toQuery();

    List<ContentDocument> docList = doQuery(q, new List<Object>{ name });

    //return docList.isEmpty() ? null : docList.get(0);
    if (docList.isEmpty()) {
      tffa.Logger.debug(' Content Doc list Empty');
    } else {
      doDelete(docList);
    }
  }

  /**
   * Fetch Doc
   */
  public static void deleteContentDocumentById(List<String> idList) {
    String q = new tffa.QueryBuilder(ContentDocument.SObjectType).selectFields().whereClause('Id', 'In :attr1').build().toQuery();

    List<ContentDocument> docList = doQuery(q, new List<Object>{ idList });

    //return docList.isEmpty() ? null : docList.get(0);
    if (docList != null && !docList.isEmpty()) {
      doDelete(docList);
    }
  }

  /**
   * Fetch Doc
   */
  public static List<String> fetchContentDocumentId(List<String> idList) {
    List<String> cdLinkedIdList = new List<String>();

    String q = new tffa.QueryBuilder(ContentDocumentLink.SObjectType)
      .selectFields()
      .whereClause('LinkedEntityId', 'In :attr1')
      .build()
      .toQuery();

    List<ContentDocumentLink> docList = doQuery(q, new List<Object>{ idList });

    //return docList.isEmpty() ? null : docList.get(0);
    if (docList != null && !docList.isEmpty()) {
      for (ContentDocumentLink cdLinkObj : docList) {
        cdLinkedIdList.add(cdLinkObj.ContentDocumentId);
      }
    }
    return cdLinkedIdList;
  }

  /**
   * Fetch Doc
   */
  public static Folder getFolder(String folderName) {
    String q = new tffa.QueryBuilder(Folder.SObjectType).selectFields().whereClause('Name', '= :attr1').build().toQuery();

    List<Folder> folderList = doQuery(q, new List<Object>{ folderName });

    return folderList.isEmpty() ? null : folderList.get(0);
  }

  /**
   * Save Doc
   * */
  public static void saveDoc(Document doc) {
    doUpsert(new List<Document>{ doc });
  }

  /**
   *
   * Fetches an application record by submission id.
   */
  public static List<tffa__ApplicationPartyXref__c> findAppPartyByApp(tffa__Submission__c sub) {
    List<String> appIds = new List<String>();
    if (sub != null && sub.tffa__Applications__r != null) {
      for (tffa__Application__c app : sub.tffa__Applications__r) {
        appIds.add(app.Id);
      }
    } else {
      return new List<tffa__ApplicationPartyXref__c>();
    }

    String q = new tffa.QueryBuilder(tffa__ApplicationPartyXref__c.SObjectType)
      .selectFields()
      .selectObject('tffa__Party__r')
      .selectFields()
      .build()
      .whereClause('tffa__Application__c', 'In :attr1')
      .orderBy('tffa__SortOrder__c')
      .build()
      .toQuery();
    return (List<tffa__ApplicationPartyXref__c>) doQuery(q, new List<Object>{ appIds });
  }

  /**
   *
   * Fetches an account preference record by submission id.
   */
  public static List<tffa__AccountPreference__c> findAccountPrefBySub(tffa__Submission__c sub) {
    List<String> appIds = new List<String>();
    if (sub != null && sub.tffa__Applications__r != null) {
      for (tffa__Application__c app : sub.tffa__Applications__r) {
        appIds.add(app.Id);
      }
    } else {
      return new List<tffa__AccountPreference__c>();
    }

    String q = new tffa.QueryBuilder(tffa__AccountPreference__c.SObjectType)
      .selectFields()
      .whereClause('tffa__Application__c', 'In :attr1')
      .build()
      .toQuery();
    return (List<tffa__AccountPreference__c>) doQuery(q, new List<Object>{ appIds });
  }

  /**
   *
   * Fetches an Additional preference record by submission id.
   */
  public static List<tffa__AdditionalPreference__c> findAdditionalPrefBySub(String subId) {
    String q = new tffa.QueryBuilder(tffa__AdditionalPreference__c.SObjectType)
      .selectFields()
      .whereClause('tffa__Submission__c', '= :attr1')
      .build()
      .toQuery();
    return (List<tffa__AdditionalPreference__c>) doQuery(q, new List<Object>{ subId });
  }

  /**
   *
   * Fetches an Additional Service record by code and type.
   */
  public static tffa__AddOnService__c findAddOnServiceByCodeandType(String code, String type) {
    String q = new tffa.QueryBuilder(tffa__AddOnService__c.SObjectType)
      .selectFields()
      .whereClause('tffa__Code__c', '= :attr1')
      .opAnd()
      .whereClause('tffa__Type__c', '=:attr2')
      .build()
      .toQuery();
    List<tffa__AddOnService__c> addOns = (List<tffa__AddOnService__c>) doQuery(q, new List<Object>{ code, type });
    return (addOns == null || addOns.isEmpty()) ? new tffa__AddOnService__c() : addOns[0];
  }

  /**
   *
   * Fetches an Additional preference record by submission id.
   */
  public static List<tffa__AdditionalPreference__c> findAdditionalPrefByParty(String partyId) {
    String q = new tffa.QueryBuilder(tffa__AdditionalPreference__c.SObjectType)
      .selectFields()
      .whereClause('tffa__Party__c', '= :attr1')
      .build()
      .toQuery();
    return (List<tffa__AdditionalPreference__c>) doQuery(q, new List<Object>{ partyId });
  }

  /**
   *
   * Fetches an Additional preference record by submission id.
   */
  public static List<tffa__Stipulation__c> findStipByParty(String partyId) {
    String q = new tffa.QueryBuilder(tffa__Stipulation__c.SObjectType)
      .selectFields()
      .whereClause('tffa__Party__c', '= :attr1')
      .build()
      .toQuery();
    return (List<tffa__Stipulation__c>) doQuery(q, new List<Object>{ partyId });
  }

  /**
   *  Fetch adobeCampaign field Configs
   */
  public static List<AdobeCampaign__c> fetchCampaignConfigs(String type) {
    String q = new tffa.QueryBuilder(AdobeCampaign__c.SObjectType)
      .selectFields()
      .whereClause('TerafinaObjectName__c', '=:attr1')
      .build()
      .toQuery();
    return (List<AdobeCampaign__c>) doQuery(q, new List<Object>{ type });
  }

  public static AdobeCampaignConfiguration__mdt fetchAdobeCampaignApiConfig(String name) {
    String q = new tffa.QueryBuilder(AdobeCampaignConfiguration__mdt.SObjectType)
      .selectFields()
      .whereClause('DeveloperName', '=:attr1')
      .build()
      .toQuery();
    List<AdobeCampaignConfiguration__mdt> result = (List<AdobeCampaignConfiguration__mdt>) doQuery(q, new List<Object>{ name });
    return result.isEmpty() ? null : result[0];
  }
  public static WintrustEnvConfig__mdt fetchWintrustEnvConfig() {
    String q = new tffa.QueryBuilder(WintrustEnvConfig__mdt.SObjectType).selectFields().build().toQuery();
    List<WintrustEnvConfig__mdt> result = (List<WintrustEnvConfig__mdt>) doQuery(q, new List<Object>{});
    return result.isEmpty() ? null : result[0];
  }

  public static tffa__EnvironmentConfiguration__c fetchEnvConfig() {
    String q = new tffa.QueryBuilder(tffa__EnvironmentConfiguration__c.SObjectType).selectFields().build().toQuery();
    List<tffa__EnvironmentConfiguration__c> result = (List<tffa__EnvironmentConfiguration__c>) doQuery(q, new List<Object>{});
    return result.isEmpty() ? null : result[0];
  }

  /**
   * @description
   * @param String partyId
   * @return void
   **/
  public static void removeDDByPartyId(String partyId, List<String> typeList) {
    String q = new tffa.QueryBuilder(tffa__DueDiligence__c.SObjectType)
      .selectFields()
      .whereClause('tffa__Party__c', '=:attr1')
      .opAnd()
      .whereClause('tffa__Type__c', 'In :attr2')
      .build()
      .toQuery();
    List<tffa__DueDiligence__c> ddList = doQuery(q, new List<Object>{ partyId, typeList });
    doDelete(ddList);
  }

  public static FISDSSConfig__mdt fetchDSSConfig(String devName) {
    String q = new tffa.QueryBuilder(FISDSSConfig__mdt.SObjectType)
      .selectFields()
      .whereClause('DeveloperName', '=:attr1')
      .build()
      .toQuery();
    List<FISDSSConfig__mdt> idaConfigList = doQuery(q, new List<Object>{ devName });
    return idaConfigList.isEmpty() ? null : idaConfigList[0];
  }

  public static List<tffa__DueDiligence__c> getDueDiligenceList(string partyId) {
    String q = new tffa.QueryBuilder(tffa__DueDiligence__c.SObjectType)
      .selectFields()
      .selectChildObject('tffa__Items__r')
      .selectFields()
      .build()
      .selectObject('tffa__Party__r')
      .selectFields()
      .whereClause('Id', '=:attr1')
      .build()
      .build()
      .toQuery();
    return doQuery(q, new List<Object>{ partyId });
  }

  public static tffa__DueDiligence__c getDueDiligenceObj(String type, string partyId) {
    String q = new tffa.QueryBuilder(tffa__DueDiligence__c.SObjectType)
      .selectFields()
      .whereClause('tffa__Type__c', '=:attr1')
      .selectObject('tffa__Party__r')
      .selectFields()
      .whereClause('Id', '=:attr2')
      .build()
      .build()
      .toQuery();

    List<tffa__DueDiligence__c> dueDiligenceObj = doQuery(q, new List<Object>{ type, partyId });
    return dueDiligenceObj.isEmpty() ? null : dueDiligenceObj[0];
  }

  public static tffa__Beneficiary__c getBeneficiaryById(String benefId) {
    String q = new tffa.QueryBuilder(tffa__Beneficiary__c.SObjectType)
      .selectFields()
      .selectObject('tffa__Address__r') /** */
      .selectFields() /** */
      .build()
      .whereClause('Id', '= :attr1')
      .build()
      .toQuery();

    List<tffa__Beneficiary__c> benList = doQuery(q, new List<Object>{ benefId });
    return benList.isEmpty() ? null : benList[0];
  }

  /**
   * @description get product Terms against product
   */
  public static tffa__ProductTerm__c findProductTerms(String productId, Decimal prodTerm) {
    List<Object> queryParams = new List<Object>();
    queryParams.add(productId);
    queryParams.add(prodTerm);
    String q = new tffa.QueryBuilder(tffa__ProductTerm__c.SObjectType)
      .selectFields()
      .whereClause('tffa__Product__c', '=:attr1')
      .opAnd()
      .whereClause('tffa__MinTerm__c', '=:attr2')
      .build()
      .toQuery();
    tffa.Logger.debug('CommonFunctionsHelper Query :- ' + q);
    List<tffa__ProductTerm__c> l = doQuery(q, queryParams);
    return l.isEmpty() ? null : l[0];
  }

  /**
   * @description get Promotion object
   */
  public static String fetchPromotionPlanCode(String productCode) {
    List<Object> queryParams = new List<Object>();

    queryParams.add(productCode);

    String q = new tffa.QueryBuilder(tffa__Promotion__c.SObjectType)
      .selectFields()
      .whereClause('tffa__Code__c', '=:attr1')
      .build()
      .toQuery();

    List<tffa__Promotion__c> promo = doQuery(q, queryParams);
    if (promo != null && !promo.isEmpty()) {
      if (!String.isBlank(promo[0].InterestPlanCode__c)) {
        return promo[0].InterestPlanCode__c;
      }
    }
    return null;
  }

  public static void removeIntegrationItemLogs(List<IntegrationLogItem__c> entities) {
    doDelete(entities);
  }

  public static void removeIntegrationLogs(List<IntegrationLog__c> entities) {
    doDelete(entities);
  }

  public static void removePartyAddress(List<tffa__PartyAddressXref__c> entities) {
    doDelete(entities);
  }

  public static void removeAddress(List<tffa__Address__C> entities) {
    doDelete(entities);
  }
  public static void removeIdentification(List<tffa__Identification__c> entities) {
    doDelete(entities);
  }
  public static void removeEmployment(List<tffa__Employment__c> entities) {
    doDelete(entities);
  }
  public static void removeStip(List<tffa__Stipulation__c> entities) {
    doDelete(entities);
  }
  public static void removeAddPref(List<tffa__AdditionalPreference__c> entities) {
    doDelete(entities);
  }
  public static void removeParty(List<tffa__Party__c> entities) {
    doDelete(entities);
  }

  public static List<tffa__Disclosure__c> findAll(tffa.QueryContext qc) {
    String q = new tffa.QueryBuilder(tffa__Disclosure__c.SObjectType).selectFields().whereClause(qc).build().toQuery();
    return (List<tffa__Disclosure__c>) doQuery(q, null);
  }

  public static tffa__Submission__c fetchDataForDisclosures(String id) {
    String q = new tffa.QueryBuilder(tffa__Submission__c.SObjectType)
      .selectFields()
      .selectChildObject('tffa__PartyXrefs__r')
      .selectFields() /** */
      .selectObject('tffa__Party__r')
      .selectFields()
      .build()
      .build()
      .selectChildObject('tffa__Applications__r')
      .selectFields()
      .build()
      .whereClause('Id', '=:attr1')
      .withLimit(1)
      .build()
      .toQuery();

    List<tffa__Submission__c> l = doQuery(q, new List<Object>{ id });
    return l.isEmpty() ? null : l[0];
  }

  public static List<tffa__Disclosure__c> save(List<tffa__Disclosure__c> entities) {
    return (List<tffa__Disclosure__c>) doUpsert(entities);
  }

  public static List<tffa__Disclosure__c> findBySubmissionAndEventName(String subId, String eventName) {
    String q = new tffa.QueryBuilder(tffa__Disclosure__c.SObjectType)
      .selectFields()
      .whereClause('tffa__Submission__c', '=:attr1')
      .opAnd()
      .whereClause('tffa__EventName__c', '=:attr2')
      .build()
      .toQuery();
    //return Database.query(q);
    return (List<tffa__Disclosure__c>) doQuery(q, new List<Object>{ subId, eventName });
  }

  /**
   * returns Brand Object
   */
  public static tffa__Location__c fetchLocationById(String locId) {
    String query = new tffa.QueryBuilder(tffa__Location__c.SObjectType).selectFields().whereClause('Id', '=:attr1').build().toQuery();

    List<tffa__Location__c> locList = doQuery(query, new List<Object>{ locId });

    return locList.isEmpty() ? null : locList[0];
  }

  /**
   * returns Brand Object
   */
  public static tffa__Brand__c fetchBrandById(String brandId) {
    String query = new tffa.QueryBuilder(tffa__Brand__c.SObjectType).selectFields().whereClause('Id', '=:attr1').build().toQuery();

    List<tffa__Brand__c> brandList = doQuery(query, new List<Object>{ brandId });

    return brandList.isEmpty() ? null : brandList[0];
  }

  /**
   * returns Brand Object
   */
  public static SubBrand__c fetchSubBrandByextId(String externalId, String name) {
    String query = new tffa.QueryBuilder(SubBrand__c.SObjectType)
      .selectFields()
      .whereClause('ExternalId__c', '=:attr1')
      .opAnd()
      .whereClause('Name', '!=:attr2')
      .build()
      .toQuery();

    List<SubBrand__c> subBrandList = doQuery(query, new List<Object>{ externalId, name });

    return subBrandList.isEmpty() ? null : subBrandList[0];
  }

  /**
   * returns Brand Object
   */
  public static List<SubBrand__c> fetchSubBrandByBrand(String brandId) {
    String query = new tffa.QueryBuilder(SubBrand__c.SObjectType).selectFields().whereClause('Brand__c', '=:attr1').build().toQuery();

    List<SubBrand__c> subBrandList = doQuery(query, new List<Object>{ brandId });

    return subBrandList.isEmpty() ? null : subBrandList;
  }

  /**
   * returns Brand Object
   */
  public static List<tffa__BrandLocation__c> fetchBrandLocByBrand(String brandId) {
    String query = new tffa.QueryBuilder(tffa__BrandLocation__c.SObjectType)
      .selectFields()
      .whereClause('tffa__Brand__c', '=:attr1')
      .build()
      .toQuery();

    List<tffa__BrandLocation__c> respList = doQuery(query, new List<Object>{ brandId });

    return respList.isEmpty() ? null : respList;
  }

  /**
   * returns Brand Object
   */
  public static List<tffa__BrandLocation__c> fetchBrandLocByLoc(String locationId) {
    String query = new tffa.QueryBuilder(tffa__BrandLocation__c.SObjectType)
      .selectFields()
      .whereClause('tffa__Location__c', '=:attr1')
      .build()
      .toQuery();

    List<tffa__BrandLocation__c> respList = doQuery(query, new List<Object>{ locationId });

    return respList.isEmpty() ? null : respList;
  }

  /**
   * returns Brand Object
   */
  public static tffa__BrandLocation__c fetchBrandLocByextId(String extId) {
    String query = new tffa.QueryBuilder(tffa__BrandLocation__c.SObjectType)
      .selectFields()
      .whereClause('ExternalId__c', '=:attr1')
      .build()
      .toQuery();

    List<tffa__BrandLocation__c> respList = doQuery(query, new List<Object>{ extId });

    return respList.isEmpty() ? null : respList[0];
  }

  /**
   *
   */
  public static tffa__Product__c fetchProductById(String id) {
    String q = new tffa.QueryBuilder(tffa__Product__c.SObjectType).selectFields().whereClause('Id', '=:attr1').build().toQuery();

    List<tffa__Product__c> result = (List<tffa__Product__c>) doQuery(q, new List<Object>{ id });
    return result.isEmpty() ? null : result[0];
  }

  /**
   * returns tffa__FundingMatrix__c Object
   */
  public static tffa__FundingMatrix__c fetchfundMatByextId(String externalId, String type, String channel, Decimal sortOrder) {
    String query = new tffa.QueryBuilder(tffa__FundingMatrix__c.SObjectType)
      .selectFields()
      .whereClause('ExternalId__c', '=:attr1')
      .opAnd()
      .whereClause('tffa__Type__c', '!=:attr2')
      .opAnd()
      .whereClause('tffa__ChannelSet__c', '!=:attr3')
      .opAnd()
      .whereClause('tffa__SortOrder__c', '!=:attr4')
      .build()
      .toQuery();

    List<tffa__FundingMatrix__c> fundMatLst = doQuery(query, new List<Object>{ externalId, type, channel, sortOrder });

    return fundMatLst.isEmpty() ? null : fundMatLst[0];
  }

  /**
   * returns Brand Object
   */
  public static tffa__ProductMatrix__c fetchProdMatByextId(String externalId) {
    String query = new tffa.QueryBuilder(tffa__ProductMatrix__c.SObjectType)
      .selectFields()
      .whereClause('ExternalId__c', '=:attr1')
      .build()
      .toQuery();

    List<tffa__ProductMatrix__c> prodMatLst = doQuery(query, new List<Object>{ externalId });

    return prodMatLst.isEmpty() ? null : prodMatLst[0];
  }

  /**
   * returns Brand Object
   */
  public static tffa__ApplicationDecisionMatrix__c fetchAppDecMatBySort(Decimal srtOrder, String extId) {
    String query = new tffa.QueryBuilder(tffa__ApplicationDecisionMatrix__c.SObjectType)
      .selectFields()
      .whereClause('tffa__SortOrder__c', '=:attr1')
      .opAnd()
      .whereClause('tffa__ExternalId__c', '!=:attr2')
      .build()
      .toQuery();

    List<tffa__ApplicationDecisionMatrix__c> appDecMatLst = doQuery(query, new List<Object>{ srtOrder, extId });

    return appDecMatLst.isEmpty() ? null : appDecMatLst[0];
  }

  /**
   * returns Brand Object
   */
  public static tffa__Promotion__c fetchpromoById(String Id) {
    String query = new tffa.QueryBuilder(tffa__Promotion__c.SObjectType).selectFields().whereClause('Id', '=:attr1').build().toQuery();

    List<tffa__Promotion__c> promoLst = doQuery(query, new List<Object>{ Id });

    return promoLst.isEmpty() ? null : promoLst[0];
  }

  /**
   * returns Brand Object
   */
  public static tffa__PromotionPlan__c fetchPromoPlan(String promoId, String extId, String Name) {
    String query = new tffa.QueryBuilder(tffa__PromotionPlan__c.SObjectType)
      .selectFields()
      .whereClause('tffa__Promotion__c', '=:attr1')
      .opAnd()
      .whereClause('ExternalId__c', '=:attr2')
      .opAnd()
      .whereClause('Name', '!=:attr3')
      .build()
      .toQuery();

    List<tffa__PromotionPlan__c> promoPlanList = doQuery(query, new List<Object>{ promoId, extId, Name });

    return promoPlanList.isEmpty() ? null : promoPlanList[0];
  }

  /**
   * returns Brand Object
   */
  public static List<tffa__PromotionPlan__c> fetchPromoPlanByPromo(String promoId) {
    String query = new tffa.QueryBuilder(tffa__PromotionPlan__c.SObjectType)
      .selectFields()
      .whereClause('tffa__Promotion__c', '=:attr1')
      .build()
      .toQuery();

    List<tffa__PromotionPlan__c> promoPlanList = doQuery(query, new List<Object>{ promoId });

    return promoPlanList.isEmpty() ? null : promoPlanList;
  }

  /**
   * returns Brand Object
   */
  public static List<tffa__Location__c> fetchLocationByAddAndCode(String addId, String code) {
    String query = new tffa.QueryBuilder(tffa__Location__c.SObjectType)
      .selectFields()
      .whereClause('tffa__Address__c', '=:attr1')
      .opAnd()
      .whereClause('tffa__Code__c', '!=:attr2')
      .build()
      .toQuery();

    List<tffa__Location__c> locList = doQuery(query, new List<Object>{ addId, code });

    return locList.isEmpty() ? null : locList;
  }

  /**
   * returns Brand Object
   */
  public static tffa__Address__c fetchAddById(String addId) {
    String query = new tffa.QueryBuilder(tffa__Address__c.SObjectType).selectFields().whereClause('Id', '=:attr1').build().toQuery();

    List<tffa__Address__c> respList = doQuery(query, new List<Object>{ addId });

    return respList.isEmpty() ? null : respList[0];
  }

  /**
   * returns Brand Object
   */
  public static tffa__Address__c fetchAddByExtId(String extId) {
    String query = new tffa.QueryBuilder(tffa__Address__c.SObjectType)
      .selectFields()
      .whereClause('tffa__ExternalId__c', '=:attr1')
      .build()
      .toQuery();

    List<tffa__Address__c> respList = doQuery(query, new List<Object>{ extId });

    return respList.isEmpty() ? null : respList[0];
  }

  /**
   * returns Brand Object
   */
  public static tffa__RecommendationConfiguration__c fetchRecommendConfigByName(String name, String extId) {
    String query = new tffa.QueryBuilder(tffa__RecommendationConfiguration__c.SObjectType)
      .selectFields()
      .whereClause('Name', '=:attr1')
      .opAnd()
      .whereClause('tffa__ExternalId__c', '!=:attr2')
      .build()
      .toQuery();

    List<tffa__RecommendationConfiguration__c> respList = doQuery(query, new List<Object>{ name, extId });

    return respList.isEmpty() ? null : respList[0];
  }

  /**
   * returns Brand Object
   */
  public static tffa__DisclosureChecklist__c fetchdiscCheckListByName(String name, String externalId) {
    String query = new tffa.QueryBuilder(tffa__DisclosureChecklist__c.SObjectType)
      .selectFields()
      .whereClause('Name', '=:attr1')
      .opAnd()
      .whereClause('tffa__ExternalId__c', '!=:attr2')
      .build()
      .toQuery();

    List<tffa__DisclosureChecklist__c> respList = doQuery(query, new List<Object>{ name, externalId });

    return respList.isEmpty() ? null : respList[0];
  }

  /**
   * returns Brand Object
   */
  public static tffa__DisclosureChecklist__c fetchdiscCheckListById(String Id) {
    String query = new tffa.QueryBuilder(tffa__DisclosureChecklist__c.SObjectType)
      .selectFields()
      .whereClause('Id', '=:attr1')
      .build()
      .toQuery();

    List<tffa__DisclosureChecklist__c> respList = doQuery(query, new List<Object>{ Id });

    return respList.isEmpty() ? null : respList[0];
  }

  /**
   * returns Brand Object
   */
  public static tffa__DisclosureTemplate__c fetchdiscTempById(String Id) {
    String query = new tffa.QueryBuilder(tffa__DisclosureTemplate__c.SObjectType)
      .selectFields()
      .whereClause('Id', '=:attr1')
      .build()
      .toQuery();

    List<tffa__DisclosureTemplate__c> respList = doQuery(query, new List<Object>{ id });

    return respList.isEmpty() ? null : respList[0];
  }

  /**
   * returns Brand Object
   */
  public static tffa__DisclosureItem__c fetchdiscTempByExtId(String Id, String name) {
    String query = new tffa.QueryBuilder(tffa__DisclosureItem__c.SObjectType)
      .selectFields()
      .whereClause('tffa__ExternalId__c', '=:attr1')
      .opAnd()
      .whereClause('Name', '!=:attr2')
      .build()
      .toQuery();

    List<tffa__DisclosureItem__c> respList = doQuery(query, new List<Object>{ id, name });

    return respList.isEmpty() ? null : respList[0];
  }

  /**
   * returns Brand Object
   */
  public static tffa__AddOnServiceChecklist__c fetchAddOnServListByName(String name, String Id) {
    String query = new tffa.QueryBuilder(tffa__AddOnServiceChecklist__c.SObjectType)
      .selectFields()
      .whereClause('Name', '=:attr1')
      .opAnd()
      .whereClause('tffa__ExternalId__c', '!=:attr2')
      .build()
      .toQuery();

    List<tffa__AddOnServiceChecklist__c> respList = doQuery(query, new List<Object>{ name, Id });

    return respList.isEmpty() ? null : respList[0];
  }

  /**
   * returns Brand Object
   */
  public static tffa__AddOnServiceChecklist__c fetchAddOnServListById(String Id) {
    String query = new tffa.QueryBuilder(tffa__AddOnServiceChecklist__c.SObjectType)
      .selectFields()
      .whereClause('Id', '=:attr1')
      .build()
      .toQuery();

    List<tffa__AddOnServiceChecklist__c> respList = doQuery(query, new List<Object>{ Id });

    return respList.isEmpty() ? null : respList[0];
  }

  /**
   * returns Brand Object
   */
  public static tffa__AddOnService__c fetchAddOnServById(String Id) {
    String query = new tffa.QueryBuilder(tffa__AddOnService__c.SObjectType).selectFields().whereClause('Id', '=:attr1').build().toQuery();

    List<tffa__AddOnService__c> respList = doQuery(query, new List<Object>{ Id });

    return respList.isEmpty() ? null : respList[0];
  }

  /**
   * returns Brand Object
   */
  public static tffa__RecommendationConfiguration__c fetchRecommendConfigById(String Id) {
    String query = new tffa.QueryBuilder(tffa__RecommendationConfiguration__c.SObjectType)
      .selectFields()
      .whereClause('Id', '=:attr1')
      .build()
      .toQuery();

    List<tffa__RecommendationConfiguration__c> respList = doQuery(query, new List<Object>{ Id });

    return respList.isEmpty() ? null : respList[0];
  }

  /**
   * returns Brand Object
   */
  public static tffa__RecommendationConfigurationItem__c fetchRecommendItemByExtId(String externalId, String configName) {
    String query = new tffa.QueryBuilder(tffa__RecommendationConfigurationItem__c.SObjectType)
      .selectFields()
      .whereClause('ExternalId__c', '=:attr1')
      .opAnd()
      .whereClause('tffa__Configuration__c', '!=:attr2')
      .build()
      .toQuery();

    List<tffa__RecommendationConfigurationItem__c> respList = doQuery(query, new List<Object>{ externalId, configName });

    return respList.isEmpty() ? null : respList[0];
  }

  /**
   * returns Brand Object
   */
  public static tffa__AddOnServiceItem__c fetchAddOnServiceItemByExtId(String externalId, String service) {
    String query = new tffa.QueryBuilder(tffa__AddOnServiceItem__c.SObjectType)
      .selectFields()
      .whereClause('tffa__ExternalId__c', '=:attr1')
      .opAnd()
      .whereClause('tffa__Service__c', '!=:attr2')
      .build()
      .toQuery();

    List<tffa__AddOnServiceItem__c> respList = doQuery(query, new List<Object>{ externalId, service });

    return respList.isEmpty() ? null : respList[0];
  }

  /**
   * Save Address
   * */
  public static void saveAddress(List<tffa__Address__c> addObjList) {
    doUpsert(addObjList);
  }

  /**
   * Save promo plan
   * 
  public static void savePromoPlan(List<tffa__PromotionPlan__c> promoPlanList) {
    doUpsert(promoPlanList);
  }*/

  /**
   * Save Address
   * 
  public static void savesubBrand(List<SubBrand__c> subBrndLst) {
    doUpsert(subBrndLst);
  }

  /**
   * Save promo plan
   * *
  public static void saveBrandLoc(List<tffa__BrandLocation__c> brndLocList) {
    doUpsert(brndLocList);
  }
  */
  /**
   * returns tffa__ProductProductXref__c Object
   */
  public static tffa__ProductProductXref__c fetchProdXrefById(String Id, String name) {
    String query = new tffa.QueryBuilder(tffa__ProductProductXref__c.SObjectType)
      .selectFields()
      .whereClause('ExternalId__c', '=:attr1')
      .opAnd()
      .whereClause('Name', '!=:attr2')
      .build()
      .toQuery();

    List<tffa__ProductProductXref__c> respList = doQuery(query, new List<Object>{ id, name });

    return respList.isEmpty() ? null : respList[0];
  }

  /**
   * returns tffa__ProductProductXref__c Object
   */
  public static tffa__ProductMatrix__c fetchProdMatById(String Id, String product, Decimal srtOrder) {
    String query = new tffa.QueryBuilder(tffa__ProductMatrix__c.SObjectType)
      .selectFields()
      .whereClause('tffa__ExternalId__c', '=:attr1')
      .opAnd()
      .whereClause('tffa__Product__c', '!=:attr2')
      .opAnd()
      .whereClause('tffa__SortOrder__c', '!=:attr3')
      .build()
      .toQuery();

    List<tffa__ProductMatrix__c> respList = doQuery(query, new List<Object>{ id, product, srtOrder });

    return respList.isEmpty() ? null : respList[0];
  }

  public static List<tffa__FundingMatrix__c> getFundingMat(String channel) {
    Map<String, Object> mp = new Map<String, Object>();
    mp.put('Channel__c', channel);
    String query = new tffa.QueryBuilder(tffa__FundingMatrix__c.SObjectType)
      .selectFields()
      .whereWithFacts('VerifyFunding', mp)
      .build()
      .toQuery();
    List<tffa__FundingMatrix__c> respList = doQuery(query, new List<Object>{});
    return respList.isEmpty() ? new List<tffa__FundingMatrix__c>() : respList;
  }

  /**
   * returns CZConvergeConfiguration__mdt Object
   */
  public static CZConvergeConfiguration__mdt fetchConvergeConfig(String name) {
    String q = new tffa.QueryBuilder(CZConvergeConfiguration__mdt.SObjectType)
      .selectFields()
      .whereClause('DeveloperName', '=:attr1')
      .build()
      .toQuery();
    List<CZConvergeConfiguration__mdt> result = (List<CZConvergeConfiguration__mdt>) doQuery(q, new List<Object>{ name });
    return result.isEmpty() ? null : result[0];
  }

  public static Set<String> fetchUniqueInterestPlanCodes() {
    Set<String> intPlanCodeSet = new Set<String>();
    String prodTermQuery = new tffa.QueryBuilder(tffa__ProductTerm__c.SObjectType)
      .selectFields(new List<String>{ 'tffa__InterestPlanCode__c', 'CZFounderInterestPlan__c' })
      .build()
      .toQuery();
    List<tffa__ProductTerm__c> prodTermIntPlanCodeLst = doQuery(prodTermQuery, new List<Object>{});
    for (tffa__ProductTerm__c productTerm : prodTermIntPlanCodeLst) {
      if (!String.isBlank(productTerm.tffa__InterestPlanCode__c)) {
        intPlanCodeSet.add(productTerm.tffa__InterestPlanCode__c);
      }
      if (!String.isBlank(productTerm.CZFounderInterestPlan__c)) {
        intPlanCodeSet.add(productTerm.CZFounderInterestPlan__c);
      }
    }

    String productQuery = new tffa.QueryBuilder(tffa__Product__c.SObjectType)
      .selectFields(new List<String>{ 'InterestPlanCode__c' })
      .whereClause('InterestPlanCode__c', '!= null')
      .build()
      .toQuery();
    List<tffa__Product__c> productIntPlanCodeLst = doQuery(productQuery, new List<Object>{});
    for (tffa__Product__c product : productIntPlanCodeLst) {
      intPlanCodeSet.add(product.InterestPlanCode__c);
    }

    return intPlanCodeSet;
  }

  /**
   * Fetch Non-Tiered Interest Plan Details
   */
  public static InterestPlanDetails__c getIntPlanDtlsNonTiered(String brandCode, String intPlanCode, String rteSchedInd) {
    String q = new tffa.QueryBuilder(InterestPlanDetails__c.SObjectType)
      .selectFields()
      .whereClause('BrandCode__c', '=:attr1')
      .opAnd()
      .whereClause('IntPlnCde__c', '=:attr2')
      .opAnd()
      .whereClause('RteSchedInd__c', '=:attr3')
      .build()
      .toQuery();

    List<InterestPlanDetails__c> intPlanDtlsList = doQuery(q, new List<Object>{ brandCode, intPlanCode, rteSchedInd });

    return intPlanDtlsList.isEmpty() ? null : intPlanDtlsList.get(0);
  }

  /**
   * Fetch Tiered Interest Plan Details
   */
  public static InterestPlanDetails__c getIntPlanDtlsTiered(
    String brandCode,
    String intPlanCode,
    String rteSchedInd,
    Double tierMinBal,
    Double tierMaxBal
  ) {
    String q = new tffa.QueryBuilder(InterestPlanDetails__c.SObjectType)
      .selectFields()
      .whereClause('BrandCode__c', '=:attr1')
      .opAnd()
      .whereClause('IntPlnCde__c', '=:attr2')
      .opAnd()
      .whereClause('RteSchedInd__c', '=:attr3')
      .opAnd()
      .whereClause('TierMinBal__c', '=:attr4')
      .opAnd()
      .whereClause('TierMaxBal__c', '=:attr5')
      .build()
      .toQuery();

    List<InterestPlanDetails__c> intPlanDtlsList = doQuery(
      q,
      new List<Object>{ brandCode, intPlanCode, rteSchedInd, tierMinBal, tierMaxBal }
    );

    return intPlanDtlsList.isEmpty() ? null : intPlanDtlsList.get(0);
  }

  /**
   * Delete unused Interest Plan Details
   */
  public static void deleteUnusedInterestPlanDetails(String brandCode, List<string> usedIntPlanDtlsLst) {
    List<InterestPlanDetails__c> unusedIntPlanDtlsList = new List<InterestPlanDetails__c>();
    String q = new tffa.QueryBuilder(InterestPlanDetails__c.SObjectType)
      .selectFields()
      .whereClause('BrandCode__c', '=:attr1')
      .build()
      .toQuery();

    List<InterestPlanDetails__c> intPlanDtlsList = doQuery(q, new List<Object>{ brandCode });
    for (InterestPlanDetails__c intPlanDtls : intPlanDtlsList) {
      String lstKey = intPlanDtls.IntPlnCde__c;
      if (intPlanDtls.TierMinBal__c == null) {
        lstKey = lstKey + ':' + CZWTFCConstants.NON_TIERED;
      } else {
        lstKey = lstKey + ':' + String.valueOf(intPlanDtls.TierMinBal__c);
      }
      if (intPlanDtls.TierMaxBal__c == null) {
        lstKey = lstKey + ':' + CZWTFCConstants.NON_TIERED;
      } else {
        lstKey = lstKey + ':' + String.valueOf(intPlanDtls.TierMaxBal__c);
      }

      if (!usedIntPlanDtlsLst.contains(lstKey)) {
        unusedIntPlanDtlsList.add(intPlanDtls);
      }
    }

    if (unusedIntPlanDtlsList != null && !unusedIntPlanDtlsList.isEmpty()) {
      doDelete(unusedIntPlanDtlsList);
    }
  }

  public static List<InterestPlanDetails__c> fetchInterestPlanDetails(String interestPlanCode, String brandCode) {
    String query = new tffa.QueryBuilder(InterestPlanDetails__c.SObjectType)
      .selectFields()
      .whereClause('IntPlnCde__c', '=:attr1')
      .opAnd()
      .whereClause('BrandCode__c', '=:attr2')
      .build()
      .toQuery();
    List<InterestPlanDetails__c> respList = doQuery(query, new List<Object>{ interestPlanCode, brandCode });
    return respList.isEmpty() ? null : respList;
  }

  public static List<InterestPlanDetails__c> fetchInterestPlanDetailsOrderByMinBal(String interestPlanCode, String brandCode) {
    String query = new tffa.QueryBuilder(InterestPlanDetails__c.SObjectType)
      .selectFields()
      .whereClause('IntPlnCde__c', '=:attr1')
      .opAnd()
      .whereClause('BrandCode__c', '=:attr2')
      .orderBy('TierMinBal__c')
      .build()
      .toQuery();
    List<InterestPlanDetails__c> respList = doQuery(query, new List<Object>{ interestPlanCode, brandCode });
    return respList.isEmpty() ? new List<InterestPlanDetails__c>() : respList;
  }

  public static List<InterestPlanDetails__c> fetchInterestPlanDetailsByBrandCodeOrderByMinBal(String brandCode) {
    String query = new tffa.QueryBuilder(InterestPlanDetails__c.SObjectType)
      .selectFields()
      .whereClause('BrandCode__c', '=:attr1')
      .orderBy('TierMinBal__c')
      .build()
      .toQuery();
    List<InterestPlanDetails__c> respList = doQuery(query, new List<Object>{ brandCode });
    return respList.isEmpty() ? new List<InterestPlanDetails__c>() : respList;
  }

  public static MuleSoft_Adapter_Config__mdt fetchMulesoftAdapterConfig(String name) {
    String q = new tffa.QueryBuilder(MuleSoft_Adapter_Config__mdt.SObjectType)
      .selectFields()
      .whereClause('DeveloperName', '=:attr1')
      .build()
      .toQuery();
    List<MuleSoft_Adapter_Config__mdt> result = (List<MuleSoft_Adapter_Config__mdt>) doQuery(q, new List<Object>{ name });
    return result.isEmpty() ? null : result[0];
  }

  /**
   * Returns List<CZTerafinaFisMapping__c>
   * Params: type and fis value
   */
  public static CZTerafinaFisMapping__c getTFndFISMapping(String type, String fisValue) {
    String q = new tffa.QueryBuilder(CZTerafinaFisMapping__c.SObjectType)
      .selectFields()
      .whereClause('Type__c', '=:attr1')
      .opAnd()
      .whereClause('FisValue__c', '=:attr2')
      .build()
      .toQuery();
    List<CZTerafinaFisMapping__c> result = (List<CZTerafinaFisMapping__c>) doQuery(q, new List<Object>{ type, fisValue });
    return result.isEmpty() ? null : result[0];
  }

  /**
   * Returns List<CZTerafinaFisMapping__c>
   * Params: type
   */
  public static List<CZTerafinaFisMapping__c> getTFndFISMappingByType(String type) {
    String q = new tffa.QueryBuilder(CZTerafinaFisMapping__c.SObjectType)
      .selectFields()
      .whereClause('Type__c', '=:attr1')
      .build()
      .toQuery();
    return (List<CZTerafinaFisMapping__c>) doQuery(q, new List<Object>{ type });
  }

  /**
   * Returns List<tffa__AccountPreference__c>
   * Params: partyLst and type
   */
  public static List<tffa__AccountPreference__c> fetchAccountPrefByType(List<tffa__Party__c> prtyLst, String type) {
    List<Id> partyIdLst = new List<Id>();
    for (tffa__Party__c partyObj : prtyLst) {
      partyIdLst.add(partyObj.Id);
    }
    String q = new tffa.QueryBuilder(tffa__AccountPreference__c.SObjectType)
      .selectFields()
      .whereClause('tffa__Party__c', 'In :attr1')
      .opAnd()
      .whereClause('tffa__AddOnServiceType__c', '=:attr2')
      .build()
      .toQuery();
    List<tffa__AccountPreference__c> result = (List<tffa__AccountPreference__c>) doQuery(q, new List<Object>{ partyIdLst, type });
    return result.isEmpty() ? new List<tffa__AccountPreference__c>() : result;
  }

  /**
   * Save Account Preference
   * */
  public static void saveAccountPref(List<tffa__AccountPreference__c> accPrefLst) {
    doUpsert(accPrefLst);
  }

  /**
   * returns CZConvergeCharterConfiguration__mdt Object
   */
  public static CZConvergeCharterConfiguration__mdt fetchConvergeCharterConfig(String brand) {
    String q = new tffa.QueryBuilder(CZConvergeCharterConfiguration__mdt.SObjectType)
      .selectFields()
      .whereClause('BrandCode__c', '=:attr1')
      .build()
      .toQuery();
    List<CZConvergeCharterConfiguration__mdt> result = (List<CZConvergeCharterConfiguration__mdt>) doQuery(q, new List<Object>{ brand });
    return result.isEmpty() ? null : result[0];
  }

  /**
   * Fetch Agent Obj by User Id
   * Params: UserId
   * Return: tffa__AgentDetail__c
   */
  public static tffa__AgentDetail__c getAgentDetailsByUserId(String userId) {
    String q = new tffa.QueryBuilder(tffa__AgentDetail__c.SObjectType)
      .selectFields()
      .whereClause('tffa__User__c', '=:attr1')
      .build()
      .toQuery();

    List<tffa__AgentDetail__c> agentDetailLst = doQuery(q, new List<Object>{ userId });

    return agentDetailLst.isEmpty() ? null : agentDetailLst.get(0);
  }

  public static List<CZOfficerDetails__c> fetchOfficerDetails(String brandCode) {
    String q = new tffa.QueryBuilder(CZOfficerDetails__c.SObjectType)
      .selectFields()
      .whereClause('BrandCode__c', '=:attr1')
      .build()
      .toQuery();
    List<CZOfficerDetails__c> offDtls = doQuery(q, new List<Object>{ brandCode });
    return offDtls.isEmpty() ? new List<CZOfficerDetails__c>() : offDtls;
  }

  public static void deleteOfficerList(List<CZOfficerDetails__c> fetOffDtls) {
    if (fetOffDtls != null && !fetOffDtls.isEmpty()) {
      doDelete(fetOffDtls);
    }
  }

  public static List<tffa__BrandLocation__c> getBrandLocations() {
    String query = new tffa.QueryBuilder(tffa__BrandLocation__c.SObjectType)
      .selectFields()
      .selectObject('tffa__Brand__r')
      .selectFields()
      .build()
      .selectObject('tffa__Location__r')
      .selectFields()
      .build()
      .build()
      .toQuery();
    List<tffa__BrandLocation__c> listLocation = doQuery(query, new List<Object>{ null });
    return listLocation;
  }

  public static void saveLocation(List<tffa__Location__c> brnchLocationLst) {
    doUpsert(brnchLocationLst);
  }
  public static List<tffa__Address__c> doUpsertaddress(tffa__Address__c entity) {
    return doUpsert(new List<tffa__Address__c>{ entity });
  }
  public static List<tffa__PartyAddressXref__c> doUpsertPartyaddress(tffa__PartyAddressXref__c entity) {
    return doUpsert(new List<tffa__PartyAddressXref__c>{ entity });
  }
  public static List<tffa__Identification__c> doUpsertIdentification(List<tffa__Identification__c> entityLst) {
    return doUpsert(entityLst);
  }
  public static List<tffa__Employment__c> doUpsertEmployment(List<tffa__Employment__c> entityLst) {
    return doUpsert(entityLst);
  }

  public static list<UploadFileHistory__c> save(list<UploadFileHistory__c> entities) {
    return (list<UploadFileHistory__c>) doUpsert(entities);
  }

  public static List<UploadFileHistory__c> fetchUploadFileHistory(String applicationId, String type) {
    String q = new tffa.QueryBuilder(UploadFileHistory__c.SObjectType)
      .selectFields()
      .whereClause('FileType__c', '=:attr1')
      .opAnd()
      .whereClause('ApplicationID__c', '=:attr2')
      .build()
      .toQuery();
    return doQuery(q, new List<Object>{ type, applicationId });
  }

  public static Map<String, String> fetchApplicantRoleMap() {
    String q = new tffa.QueryBuilder(tffa__ApplicantRole__c.SObjectType).selectFields().build().toQuery();

    List<tffa__ApplicantRole__c> applicationRoleList = doQuery(q, new List<Object>{});
    Map<String, String> mp = new Map<String, String>();
    if (applicationRoleList != null && !applicationRoleList.isEmpty()) {
      for (tffa__ApplicantRole__c appRole : applicationRoleList) {
        mp.put(appRole.CZFISRelationshipCode__c, appRole.tffa__Label__c);
      }
    }
    return mp;
  }

  public static List<tffa__DisclosureParticipant__c> saveDisclosureParticipant(List<tffa__DisclosureParticipant__c> entities) {
    return (List<tffa__DisclosureParticipant__c>) doUpsert(entities);
  }

  public static List<tffa__DisclosureItem__c> findParticipants(List<String> itemids) {
    String q = new tffa.QueryBuilder(tffa__DisclosureItem__c.SObjectType)
      .selectFields() /** */ /** */
      .selectChildObject('CZDisclosureParticipantsConfig__r') /** */
      .selectFields() /** */ /** */
      .build() /** */
      .selectObject('Template__r')
      .selectFields()
      .build()
      .whereClause('Id', 'in:attr1')
      .build()
      .toQuery();
    return doQuery(q, new List<Object>{ itemids });
  }

  public static List<tffa__DisclosureChecklist__c> findByFacts(String eventName) {
    String q = new tffa.QueryBuilder(tffa__DisclosureChecklist__c.SObjectType)
      .selectFields()
      .selectChildObject('Items__r')
      .selectFields()
      .selectObject('Template__r')
      .selectFields()
      .build()
      .whereClause('Template__r.Disabled__c', '= false')
      .orderBy('SortOrder__c')
      .build()
      .whereClause('tffa__EventName__c', '=:attr1')
      .opAnd()
      .whereClause('Disabled__c', '=false')
      .orderBy('CZSortOrder__c')
      .build()
      .toQuery();
    return doQuery(q, new List<Object>{ eventName });
  }

  public static List<tffa__DisclosureChecklist__c> findByEventName(String eventName) {
    String query = new tffa.QueryBuilder(tffa__DisclosureMatrix__c.SObjectType)
      .selectFields()
      .whereClause('tffa__EventName__c', '=:attr1')
      .build()
      .toQuery();

    List<tffa__DisclosureMatrix__c> discMatrixList = (List<tffa__DisclosureMatrix__c>) doQuery(query, new List<Object>{ eventName });

    List<Id> discChecklistIds = new List<Id>();
    if (!discMatrixList.isEmpty()) {
      for (tffa__DisclosureMatrix__c discMatrix : discMatrixList) {
        discChecklistIds.add(discMatrix.tffa__Checklist__c);
      }

      String q = new tffa.QueryBuilder(tffa__DisclosureChecklist__c.SObjectType)
        .selectFields()
        .selectChildObject('Items__r')
        .selectFields()
        .selectObject('Template__r')
        .selectFields()
        .build()
        .whereClause('Template__r.Disabled__c', '= false')
        .orderBy('SortOrder__c')
        .build()
        .whereClause('Id', 'In :attr1')
        .opAnd()
        .whereClause('Disabled__c', '=false')
        .build()
        .toQuery();
      return doQuery(q, new List<Object>{ discChecklistIds });
    }
    return new List<tffa__DisclosureChecklist__c>();
  }

  public static List<tffa__DisclosureChecklist__c> findDiscByFacts(String factsName, Map<String, Object> factsMap) {
    String q = new tffa.QueryBuilder(tffa__DisclosureChecklist__c.SObjectType)
      .selectFields()
      .selectChildObject('Items__r')
      .selectFields()
      .selectObject('Template__r')
      .selectFields()
      .build()
      .whereClause('Template__r.Disabled__c', '= false')
      .orderBy('SortOrder__c')
      .build()
      .whereWithFacts(factsName, factsMap)
      .orderBy('CZSortOrder__c')
      .build()
      .toQuery();
    return doQuery(q, new List<Object>{});
  }

  public static List<CZFISHolidayList__c> fetchFISHolidayDetails(String brandCode) {
    String q = new tffa.QueryBuilder(CZFISHolidayList__c.SObjectType)
      .selectFields()
      .whereClause('BrandCode__c', '=:attr1')
      .build()
      .toQuery();
    List<CZFISHolidayList__c> offDtls = doQuery(q, new List<Object>{ brandCode });
    return offDtls.isEmpty() ? new List<CZFISHolidayList__c>() : offDtls;
  }

  public static void deleteFISHolidayList(List<CZFISHolidayList__c> holidayDtls) {
    if (holidayDtls != null && !holidayDtls.isEmpty()) {
      doDelete(holidayDtls);
    }
  }
  public static Deluxe_Creds__mdt fetchDeluxeConfig(String name) {
    String q = new tffa.QueryBuilder(Deluxe_Creds__mdt.SObjectType)
      .selectFields()
      .whereClause('DeveloperName', '=:attr1')
      .build()
      .toQuery();
    List<Deluxe_Creds__mdt> result = (List<Deluxe_Creds__mdt>) doQuery(q, new List<Object>{ name });
    return result.isEmpty() ? null : result[0];
  }

  // fetchUserDetails
  public static List<User> fetchUserDetails(Set<Id> idList) {
    String q = new tffa.QueryBuilder(User.SObjectType).selectFields().whereClause('Id', 'In :attr1').build().toQuery();
    List<User> userList = doQuery(q, new List<Object>{ idList });
    return userList.isEmpty() ? null : userList;
  }

  // findByQueueId
  public static List<Group> findByQueueId(Set<Id> idList) {
    String q = new tffa.QueryBuilder(Group.SObjectType).selectFields().whereClause('Id', 'In :attr1').build().toQuery();
    List<Group> queueSobjectList = doQuery(q, new List<Object>{ idList });
    return queueSobjectList.isEmpty() ? null : queueSobjectList;
  }

  public static tffa__Location__c fetchLocationByCode(String code) {
    String query = new tffa.QueryBuilder(tffa__Location__c.SObjectType)
      .selectFields()
      .whereClause('tffa__Code__c', '=:attr1')
      .build()
      .toQuery();

    List<tffa__Location__c> locList = doQuery(query, new List<Object>{ code });

    return locList.isEmpty() ? null : locList[0];
  }

  public static List<tffa__PartyRelationCode__c> getPartyRelationCode() {
    String q = new tffa.QueryBuilder(tffa__PartyRelationCode__c.SObjectType).selectFields().build().toQuery();

    return (List<tffa__PartyRelationCode__c>) doQuery(q, new List<Object>{});
  }

  public static tffa__Questionnaire__c getCDDQuestions() {
    String query = new tffa.QueryBuilder(tffa__QuestionnaireMatrix__c.SObjectType)
      .selectFields()
      .whereClause('tffa__Type__c', '=:attr1')
      .opAnd()
      .whereClause('tffa__PartyType__c', '=:attr2')
      .build()
      .toQuery();
    List<tffa__QuestionnaireMatrix__c> questionMatrixObj = doQuery(query, new List<Object>{ 'CDD', 'ORGANIZATION' });
    if (questionMatrixObj != null && !questionMatrixObj.isEmpty()) {
      String q = new tffa.QueryBuilder(tffa__Questionnaire__c.SObjectType).selectFields().whereClause('Id', '=:attr1').build().toQuery();

      List<tffa__Questionnaire__c> queryQuestionObj = doQuery(q, new List<Object>{ questionMatrixObj[0].tffa__Questionnaire__c });
      if (!queryQuestionObj.isEmpty()) {
        tffa__Questionnaire__c questionnaireObj = tffa.QuestionnaireService.read(queryQuestionObj[0].Id);
        return questionnaireObj;
      }
    }
    return null;
  }

  /**
   * @description
   * @param String partyId
   * @return void
   **/
  public static List<String> fetchPartiesWithCDD(List<tffa__Party__c> parties) {
    List<Id> partyIds = new List<Id>();
    for (tffa__Party__c p : parties) {
      partyIds.add(p.Id);
    }
    String q = new tffa.QueryBuilder(tffa__DueDiligence__c.SObjectType)
      .selectFields()
      .whereClause('tffa__Party__c', 'In :attr1')
      .opAnd()
      .whereClause('tffa__Type__c', '= :attr2')
      .build()
      .toQuery();
    List<tffa__DueDiligence__c> ddList = doQuery(q, new List<Object>{ partyIds, 'CDD' });
    List<String> partyIdList = new List<String>();
    for (tffa__DueDiligence__c ddObj : ddList) {
      partyIdList.add(ddObj.tffa__Party__c);
    }
    return partyIdList;
  }

  /**
   * Returns List<CZTerafinaFisMapping__c>
   * Params: type and fis value
   */
  public static Map<String, String> getTFndFISMappings(String type, List<String> fisValues) {
    Map<String, String> mp = new Map<String, String>();
    String q = new tffa.QueryBuilder(CZTerafinaFisMapping__c.SObjectType)
      .selectFields()
      .whereClause('Type__c', '=:attr1')
      .opAnd()
      .whereClause('FisValue__c', 'In :attr2')
      .build()
      .toQuery();
    List<CZTerafinaFisMapping__c> result = (List<CZTerafinaFisMapping__c>) doQuery(q, new List<Object>{ type, fisValues });
    if (!result.isEmpty()) {
      for (CZTerafinaFisMapping__c tf : result) {
        mp.put(tf.FisValue__c, tf.TerafinaValue__c);
      }
    }
    return mp;
  }

  public static List<tffa__DisclosureMatrix__c> findDiscMatrixByFacts(String factsName, Map<String, Object> factsMap) {
    String q = new tffa.QueryBuilder(tffa__DisclosureMatrix__c.SObjectType)
      .selectFields()
      .whereWithFacts(factsName, factsMap)
      .orderBy('tffa__SortOrder__c')
      .build()
      .toQuery();
    return doQuery(q, new List<Object>{});
  }

  public static Map<Id, tffa__DisclosureChecklist__c> fetchDiscMapUsingMatrix(List<tffa__DisclosureMatrix__c> discMatrixList) {
    List<Id> discChecklistIds = new List<Id>();
    for (tffa__DisclosureMatrix__c discMatrix : discMatrixList) {
      discChecklistIds.add(discMatrix.tffa__Checklist__c);
    }

    Map<Id, tffa__DisclosureChecklist__c> mp = new Map<Id, tffa__DisclosureChecklist__c>();

    String q = new tffa.QueryBuilder(tffa__DisclosureChecklist__c.SObjectType)
      .selectFields()
      .selectChildObject('Items__r')
      .selectFields()
      .selectObject('Template__r')
      .selectFields()
      .build()
      .whereClause('Template__r.Disabled__c', '= false')
      .orderBy('SortOrder__c')
      .build()
      .whereClause('Id', 'In :attr1')
      .build()
      .toQuery();

    List<tffa__DisclosureChecklist__c> discChecklistLst = (List<tffa__DisclosureChecklist__c>) doQuery(
      q,
      new List<Object>{ discChecklistIds }
    );
    if (!discChecklistLst.isEmpty()) {
      for (tffa__DisclosureChecklist__c discChecklist : discChecklistLst) {
        mp.put(discChecklist.Id, discChecklist);
      }
    }
    return mp;
  }

  public static Map<String, InterestPlanDetails__c> fetchInterestPlanMap(String brandCode) {
    String q = new tffa.QueryBuilder(InterestPlanDetails__c.SObjectType)
      .selectFields()
      .whereClause('BrandCode__c', '=:attr1')
      .orderBy('TierMaxBal__c', true)
      .build()
      .toQuery();

    List<InterestPlanDetails__c> intPlanDtlsList = doQuery(q, new List<Object>{ brandCode });
    Map<String, InterestPlanDetails__c> interestPlanMap = new Map<String, InterestPlanDetails__c>();
    List<String> dupPlancodeLst = new List<String>();
    if (!intPlanDtlsList.isEmpty()) {
      for (InterestPlanDetails__c intPlan : intPlanDtlsList) {
        if (!interestPlanMap.containsKey(intPlan.IntPlnCde__c)) {
          interestPlanMap.put(intPlan.IntPlnCde__c, intPlan);
        }
      }
    }
    return interestPlanMap;
  }

  public static List<tffa__DisclosureEnvelope__c> findGeneratedDisclosureEnvs() {
    String q;
    if (!Test.isRunningTest()) {
      q = new tffa.QueryBuilder(tffa__DisclosureEnvelope__c.SObjectType)
        .selectFields()
        .whereClause('tffa__Status__c', '= :attr1')
        .build()
        .toQuery();
    } else {
      q = new tffa.QueryBuilder(tffa__DisclosureEnvelope__c.SObjectType)
        .selectFields()
        .whereClause('tffa__Status__c', '= :attr1')
        .build()
        .withLimit(1)
        .toQuery();
    }
    return doQuery(q, new List<Object>{ 'GENERATED' });
  }

  public static List<tffa__Disclosure__c> findDiscsByEnvId(List<Id> envIds) {
    String q = new tffa.QueryBuilder(tffa__Disclosure__c.SObjectType)
      .selectFields()
      .selectChildObject('DisclosureParticipants__r')
      .selectFields()
      .build()
      .whereClause('tffa__Envelope__c', 'In :attr1')
      .build()
      .toQuery();
    //return Database.query(q);
    return (List<tffa__Disclosure__c>) doQuery(q, new List<Object>{ envIds });
  }

  /**
   * returns Brand Object
   */
  public static List<tffa__BrandLocation__c> fetchBrandLocByBrandAndLoc(String brandId, String locationId) {
    String query = new tffa.QueryBuilder(tffa__BrandLocation__c.SObjectType)
      .selectFields()
      .whereClause('tffa__Brand__c', '=:attr1')
      .opAnd()
      .whereClause('tffa__Location__c', '=:attr2')
      .build()
      .toQuery();

    List<tffa__BrandLocation__c> respList = doQuery(query, new List<Object>{ brandId, locationId });

    return respList.isEmpty() ? null : respList;
  }

  /**
   *Fetch Disc env with disc by Sub Id
   */
  public static List<tffa__DisclosureEnvelope__c> fetchDiscEnvBySubId(Id subId) {
    String q = new tffa.QueryBuilder(tffa__DisclosureEnvelope__c.SObjectType)
      .selectFields()
      .selectChildObject('tffa__Disclosures__r')
      .selectFields()
      .build()
      .whereClause('tffa__Submission__c', '= :attr1')
      .build()
      .toQuery();

    List<tffa__DisclosureEnvelope__c> respList = doQuery(q, new List<Object>{ subId });

    return respList.isEmpty() ? null : respList;
  }

  /**
   * Fetch Existing DD for Party
   */
  public static tffa__DueDiligence__c fetchExistingDueDiligence(String partyId, String ddType) {
    String q = new tffa.QueryBuilder(tffa__DueDiligence__c.SObjectType)
      .selectFields()
      .whereClause('tffa__Party__c', '= :attr1')
      .opAnd()
      .whereClause('tffa__Type__c', '= :attr2')
      .build()
      .toQuery();
    List<tffa__DueDiligence__c> respList = doQuery(q, new List<Object>{ partyId, ddType });
    return respList.isEmpty() ? null : respList[0];
  }

  /**
   * Fetch  Disclosure by sub id which are not accepted yet.
   */
  public static List<tffa__Disclosure__c> findDiscBySubId(String subId) {
    String q = new tffa.QueryBuilder(tffa__Disclosure__c.SObjectType)
      .selectFields()
      .whereClause('tffa__Submission__c', '=:attr1')
      .opAnd()
      .whereClause('tffa__Accepted__c', '=:attr2')
      .opAnd()
      .whereClause('tffa__Code__c', 'IN :attr3')
      .build()
      .toQuery();
    //return Database.query(q);
    return (List<tffa__Disclosure__c>) doQuery(
      q,
      new List<Object>{ subId, false, new List<String>{ 'DigitalbankingDisclosure_AllProd_AllBrand', 'ODServicesConsentForm' } }
    );
  }
}