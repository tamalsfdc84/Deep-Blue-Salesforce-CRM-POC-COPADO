global with sharing class ACHFileTransRepository extends tffa.AbstractRepository {
  /**
   * Fetches an ContentVersion record with all fields by ContentDocumentId.
   * This method is used in UploadFileTransferBatch
   */
  global static List<ContentVersion> findCVByDocId(List<Id> docIds) {
    String query = new tffa.QueryBuilder(ContentVersion.SObjectType)
      .selectFields()
      .whereClause('ContentDocumentId', 'in :attr1')
      .opAnd()
      .whereClause('IsLatest', '=true')
      .build()
      .toQuery();

    List<ContentVersion> contentVerList = doQuery(query, new List<List<Id>>{ docIds });
    return contentVerList.isEmpty() ? null : contentVerList;
  }

  global static List<Document> findDocById(List<String> docIds) {
    String query = new tffa.QueryBuilder(Document.SObjectType).selectFields().whereClause('Id', '=:attr1').build().toQuery();

    List<Document> documents = doQuery(query, docIds);
    return documents.isEmpty() ? null : documents;
  }

  public static list<UploadFileHistory__c> save(list<UploadFileHistory__c> entities) {
    return (list<UploadFileHistory__c>) doUpsert(entities);
  }
}