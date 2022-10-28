public inherited sharing class FCMHelperRepository extends tffa.AbstractRepository {

  public static List<ContentDocumentLink> findCDLinkByIdList(List<Id> idList) {
    String query = new tffa.QueryBuilder(ContentDocumentLink.SObjectType)
      .selectFields()
      .whereClause('LinkedEntityId', 'in :attr1')
      .build()
      .toQuery();	
                
    return (List<ContentDocumentLink>) doQuery(query, new List<Object>{ idList });
  }

  public static List<ContentVersion> findCVdataByDocId(List<Id> contentdocumentids) {
    String query = new tffa.QueryBuilder(ContentVersion.SObjectType)
      .selectFields(
        new List<String>{
          'Id',
          'Title',
          'FileType',
          'FileExtension',
          'ContentDocumentId',
          'FileTransferStatus__c',
          'PathOnClient',
          'tffa__DocumentType__c',
          'VersionNumber',
          'ContentSize'
        }
      )
      .whereClause('ContentDocumentId', 'in :attr1')
      .build()
      .toQuery();

    return (List<ContentVersion>) doQuery(query, new List<Object>{ contentdocumentids });
  }

  public static List<UploadFileHistory__c> fetchFCMFileHistory(String applicationId) {
    string type = 'FCM';

    String q = new tffa.QueryBuilder(UploadFileHistory__c.SObjectType)
      .selectFields()
      .whereClause('FileType__c', ' =:attr1')
      .opAnd()
      .whereClause('ApplicationID__c', ' =:attr2')
      .build()
      .toQuery();

    return doQuery(q, new List<Object>{ type, applicationId});
  }

  public static list<UploadFileHistory__c> save(list<UploadFileHistory__c> entities) {
    return (list<UploadFileHistory__c>) doUpsert(entities);
  }

  // by submission
  public static List<CZFCMContentVersionDTO> findContentVersionBySubmissionId(List<Id> idList) {
    List<String> typeList = new List<String>{'INTERNAL_CONTENT'};

    // Get disclosure based on submission and type
    String query = new tffa.QueryBuilder(tffa__Disclosure__c.SObjectType)
      .selectFields()
      .whereClause('tffa__Submission__c', ' in :attr1')
      .opAnd()
      .whereClause('tffa__Type__c', ' in :attr2')
      .opAnd()
      .whereClause('tffa__Accepted__c', '= true')
      .build()
      .toQuery();	
                
    List<tffa__Disclosure__c> disclosureList = (List<tffa__Disclosure__c>) doQuery(query, new List<Object>{ idList, typeList });

    tffa.Logger.debug('disclosureList : ' + disclosureList);

    List<CZFCMContentVersionDTO> contentVersionDTOList = new List<CZFCMContentVersionDTO>();
    for(tffa__Disclosure__c disclosure: disclosureList){
      CZFCMContentVersionDTO dto = new CZFCMContentVersionDTO();
      dto.DisclosureCode = disclosure.tffa__Code__c;
      dto.URL = disclosure.tffa__DocumentUrl__c ;
      dto.PartyId = disclosure.tffa__Party__c == null ? '' :  disclosure.tffa__Party__c;
      contentVersionDTOList.add(dto);
    }

    tffa.Logger.debug('contentVersionDTOList : ' + contentVersionDTOList);

    Map<String, Integer> versionMap1 = new Map<String, Integer>();
    List<String> docUrlList = new List<String>();
    for(CZFCMContentVersionDTO dt: contentVersionDTOList){
      String str= dt.URL;
      str = str.replaceAll('/file-asset/', '');
      str = str.replaceAll('\\&.*', '');
      str = str.replaceAll('v=', '');

      String[] strList = str.split('\\?');

      if(strList != null && strList.size()>0){
        docUrlList.add(strList[0]);
        dt.DeveoperName = strList[0];

        if(strList.size()>1){
          versionMap1.put(strList[0], Integer.valueOf(strList[1]));
        }
      }
    }

    // Get content Asset
    String query2 = new tffa.QueryBuilder(ContentAsset.SObjectType)
      .selectFields()
      .whereClause('DeveloperName', ' IN :attr1')
      .build()
      .toQuery();

    List<ContentAsset> contentAssetList = doQuery(query2, new List<Object>{ docUrlList });

    tffa.Logger.debug('contentAssetList : ' + contentAssetList);

    Map<String, ContentAsset> contentAssetMap = new Map<String, ContentAsset>();
    for(ContentAsset ca: contentAssetList){
      contentAssetMap.put(ca.DeveloperName, ca);
    }

    Map<String, Integer> versionMap2 = new Map<String, Integer>();
    List<Id> contentDocumentIdList = new List<Id>();
    for(CZFCMContentVersionDTO dt: contentVersionDTOList){
      if(contentAssetMap != null && contentAssetMap.containsKey(dt.DeveoperName)){
        ContentAsset ca = contentAssetMap.get(dt.DeveoperName);
        
        contentDocumentIdList.add((Id)ca.ContentDocumentId);

        if(versionMap1.containsKey(ca.DeveloperName)){
          versionMap2.put(String.valueOf(ca.ContentDocumentId), versionMap1.get(ca.DeveloperName));
        }

        dt.ContentDocumentId =  (Id)ca.ContentDocumentId;
      } 
    }

    // Get Content Version
    String query3 = new tffa.QueryBuilder(ContentVersion.SObjectType)
      .selectFields(
        new List<String>{
          'Id',
          'Title',
          'FileType',
          'FileExtension',
          'ContentDocumentId',
          'FileTransferStatus__c',
          'PathOnClient',
          'tffa__DocumentType__c',
          'VersionNumber',
          'ContentSize'
        }
      )
      .whereClause('ContentDocumentId', ' IN :attr1')
      .build()
      .toQuery();

    List<ContentVersion> contentVersionList = (List<ContentVersion>) doQuery(query3, new List<Object>{ contentDocumentIdList });

    List<ContentVersion> newContentVersionList = new List<ContentVersion>();
    for(ContentVersion cv : contentVersionList){
      if(versionMap2.containsKey(cv.ContentDocumentId) && versionMap2.get(cv.ContentDocumentId) == integer.valueof(cv.VersionNumber)){
        newContentVersionList.add(cv);
      }
    }

    tffa.Logger.debug('newContentVersionList : ' + newContentVersionList);

    Map<Id, ContentVersion> contentVersionMap =  new Map<Id, ContentVersion>();
    for(ContentVersion  cv : newContentVersionList){
      contentVersionMap.put(cv.ContentDocumentId, cv);
    }

    for(CZFCMContentVersionDTO dt: contentVersionDTOList){
      ContentVersion cv  = contentVersionMap.get(dt.ContentDocumentId);
      dt.ContentVersionId = (String) cv.Id;
      dt.Title = (String) cv.Title;
      dt.FileExtension = (String) cv.FileExtension;
      dt.PathOnClient = (String) cv.PathOnClient;
      dt.contentSize = cv.contentSize;
    }

    tffa.Logger.debug('contentVersionDTOList : ' + contentVersionDTOList);
    
    return contentVersionDTOList;
  }

  public static List<ContentVersion> getContentVersionById(String contentVersionId) {
    String query = new tffa.QueryBuilder(ContentVersion.SObjectType)
      .selectFields(
        new List<String>{
          'Id',
          'Title',
          'FileType',
          'VersionData',
          'FileExtension',
          'ContentDocumentId',
          'FileTransferStatus__c',
          'PathOnClient',
          'tffa__DocumentType__c',
          'VersionNumber',
          'ContentSize'
        }
      )
      .whereClause('Id', ' =:attr1')
      .build()
      .toQuery();

    return (List<ContentVersion>) doQuery(query, new List<Object>{ contentVersionId });
  }
}