/**
 * Copyright (c) 2020 Terafina Inc
 * @group  Repository
 * @description ACH repository
 **/
public with sharing class CZWTFCACHRepository extends tffa.AbstractRepository {
  private static final String STATUS_FUNDED = 'FUNDED';
  private static final String ACH_DEBIT = 'ACH_Debit%';

  /**
   * @description used for retrieving contentversion
   * @param String id
   * @return ContentVersion
   **/
  public static ContentVersion findContentVersion(String id) {
    List<String> queryParams = new List<String>();
    queryParams.add(id);
    String q = new tffa.QueryBuilder(ContentVersion.SObjectType).selectFields().build().whereClause('Id', '=:attr1').build().toQuery();
    List<ContentVersion> l = doQuery(q, queryParams);
    return l.isEmpty() ? null : l[0];
  }

  /**
   * @description used for retrieving content workspace
   * @param String name
   * @return List<ContentWorkspace>
   **/
  public static ContentWorkspace findContentWorkspace(String name) {
    List<String> queryParams = new List<String>();
    queryParams.add(name);
    String q = new tffa.QueryBuilder(ContentWorkspace.SObjectType)
      .selectFields()
      .build()
      .whereClause('Name', '=:attr1')
      .withLimit(1)
      .build()
      .toQuery();
    List<ContentWorkspace> l = doQuery(q, queryParams);
    return l.isEmpty() ? null : l[0];
  }

  /**
   * @description used for retrieving content folder
   * @param String name
   * @return List<ContentFolder>
   **/
  public static ContentFolder findContentFolder(String name) {
    List<String> queryParams = new List<String>();
    queryParams.add(name);
    String q = new tffa.QueryBuilder(ContentFolder.SObjectType)
      .selectFields()
      .build()
      .whereClause('Name', '=:attr1')
      .withLimit(1)
      .build()
      .toQuery();
    List<ContentFolder> l = doQuery(q, queryParams);
    return l.isEmpty() ? null : l[0];
  }

  /**
   * @description used for retrieving content folder Name
   * @param String docId
   * @return List<ContentFolderMember>
   **/
  public static ContentFolderMember findContentFolderMember(String docId) {
    List<String> queryParams = new List<String>();
    queryParams.add(docId);
    String q = new tffa.QueryBuilder(ContentFolderMember.SObjectType)
      .selectFields()
      .build()
      .whereClause('ChildRecordId', '=:attr1')
      .withLimit(1)
      .build()
      .toQuery();
    List<ContentFolderMember> l = doQuery(q, queryParams);
    return l.isEmpty() ? null : l[0];
  }

  /**
   * @description inserts contentversion
   * @param List<ContentVersion> contentVersion
   **/
  public static void insertItem(List<ContentVersion> contentVersion) {
    doInsert(contentVersion);
  }

  /**
   * @description inserts ach file
   * @param List<UploadFileHistory__c> achFiles
   **/
  public static void insertAchFIle(List<UploadFileHistory__c> achFiles) {
    doInsert(achFiles);
  }

  /**
   * @description inserts documentLink
   * @param List<ContentDocumentLink> contentDocLink
   **/
  public static void insertDocumentLink(List<ContentDocumentLink> contentDocLink) {
    doInsert(contentDocLink);
  }

  /**
   * @description updates folder member
   * @param List<ContentFolderMember> contentFolderName
   **/
  public static void updateFolderMember(List<ContentFolderMember> contentFolderName) {
    doUpsert(contentFolderName);
  }
  /**
   * @description updates ACHFIles
   * @param List<UploadFileHistory__c> achFiles
   **/
  public static void updateAchFiles(List<UploadFileHistory__c> achFiles) {
    doUpsert(achFiles);
  }

  public static List<ContentFolderMember> save(List<ContentFolderMember> entities) {
    return (List<ContentFolderMember>) doUpsert(entities);
  }

  public static List<ContentVersion> getContentVersion() {
    List<String> queryParam = new List<String>();
    String ACH_Debit = '%TRFACH_%';
    queryParam.add(ACH_Debit);
    String achConfig = new tffa.QueryBuilder(ContentVersion.SObjectType)
      .selectFields()
      .whereClause('Title', 'like :attr1')
      .opAnd()
      .whereClause('CreatedDate', '= TODAY')
      .build()
      .toQuery();
    List<ContentVersion> achConfigs = doQuery(achConfig, queryParam);
    return achConfigs;
  }

  public static List<ACHConfigurations__mdt> getMetaData(String brandCode) {
    List<String> queryParam = new List<String>();
    queryParam.add(brandCode);
    String achConfig = new tffa.QueryBuilder(ACHConfigurations__mdt.SObjectType)
      .selectFields()
      .whereClause('Brand__c', '= :attr1')
      .build()
      .toQuery();
    List<ACHConfigurations__mdt> achConfigs = doQuery(achConfig, queryParam);
    return achConfigs;
  }

  public static List<UploadFileHistory__c> fetchACHNachaFileTransferResults() {
    List<String> statuses = new List<String>{ 'Pending', 'Failure' };
    string ACH = 'ACH';
    Nacha_Config__mdt nachaConfig = CZWTFCCustomMetadataRepository.fetchWtfcNachaConfig();
    Double retryCount = (Double) nachaConfig.Max_Retry_Count__c;
    String q = new tffa.QueryBuilder(UploadFileHistory__c.SObjectType)
      .selectFields()
      .whereClause('FileTransferStatus__c', 'in:attr1')
      .opAnd()
      .whereClause('FileType__c', 'like :attr2')
      .opAnd()
      .whereClause('FileTransferRetryCount__c', '< :attr3')
      .build()
      .toQuery();
    return doQuery(q, new List<Object>{ statuses, ACH, retryCount });
  }

  public static List<SObject> getFundingRequestsForACHFileGeneration(String brandCode) {
    String query = new tffa.QueryBuilder(tffa__FundingRequest__c.SObjectType)
      .selectFields()
      .selectObject('tffa__LinkedApplication__r')
      .whereClause('tffa__AccountNumber__c', '!= null')
      .opAnd()
      .whereClause('tffa__Brand__c', '= :attr1')
      .opAnd()
      .selectFields()
      .selectObject('tffa__Product__r')
      .selectFields(new List<String>{ 'Name' })
      .build()
      .build()
      .whereClause('tffa__Status__c', '= :attr2')
      .opAnd()
      .whereClause('tffa__Type__c', '= :attr3')
      .opAnd()
      .whereClause('IsCoreEntryComplete__c', '= true')
      .opAnd()
      .whereClause('IsObsolete__c', '= false')
      .toQuery();

    return doQuery(query, new List<Object>{ brandCode, ACHConstants.FUNDING_IN_PROGRESS, CZWTFCConstants.FUNDING_TYPE_ACH });
  }

  public static List<SObject> getFundingRequestsForACHFileGenerationBatch() {
    String query = new tffa.QueryBuilder(tffa__FundingRequest__c.SObjectType)
      .selectFields()
      .selectObject('tffa__Submission__r')
      .selectFields()
      .build()
      .whereClause('tffa__Type__c', '= :attr1')
      .opAnd()
      .whereClause('ACHReportGenerated__c', '= :attr2')
      .opAnd()
      .whereClause('tffa__Status__c', '!= :attr3')
      .toQuery();

    return doQuery(query, new List<Object>{CZWTFCConstants.FUNDING_TYPE_ACH,false,ACHConstants.FUNDING_IN_PROGRESS});
  }
}