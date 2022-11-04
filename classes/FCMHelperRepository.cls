public inherited sharing class FCMHelperRepository extends tffa.AbstractRepository {

  public static List<ContentDocumentLink> findCDLinkByIdList(List<Id> idList) {
    String query = new tffa.QueryBuilder(ContentDocumentLink.SObjectType)
      .selectFields()
      .whereClause('LinkedEntityId', 'in :attr1')
      .build()
      .toQuery();	
                
    return (List<ContentDocumentLink>) doQuery(query, new List<Object>{ idList });
  }

  public static List<ContentDocumentLink> findCDLinkByContentDocumentIdList(List<Id> idList) {
    String query = new tffa.QueryBuilder(ContentDocumentLink.SObjectType)
      .selectFields()
      .whereClause('ContentDocumentId', 'in :attr1')
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

  public static List<UploadFileHistory__c> fetchFCMFileHistory(String subId) {
    string type = 'FCM';

    String q = new tffa.QueryBuilder(UploadFileHistory__c.SObjectType)
      .selectFields()
      .whereClause('FileType__c', ' =:attr1')
      .opAnd()
      .whereClause('SubmissionID__c', ' =:attr2')
      .build()
      .toQuery();

    return doQuery(q, new List<Object>{ type, subId});
  }

  public static list<UploadFileHistory__c> save(list<UploadFileHistory__c> entities) {
    return (list<UploadFileHistory__c>) doUpsert(entities);
  }

  public static List<CZFCMContentVersionDTO> findContentVersionBySubmissionId(tffa__Submission__c sub) {
    List<CZFCMContentVersionDTO> contentVersionDTOList = new List<CZFCMContentVersionDTO>();
    List<Id> entityIds = new List<Id>();
    entityIds.add(sub.Id);

    // fetch docusign data
    contentVersionDTOList.addAll(fetchDocusignData(sub));

    // Fetch stipulation data
    List<CZFCMContentVersionDTO> stipulationContentDTO = fetchStipulationData(sub);

    // Add stipulation entity ids
    if(stipulationContentDTO != null){
      for(CZFCMContentVersionDTO dto : stipulationContentDTO){
        entityIds.add(dto.EntityId);
      }
    }

    // add stipulation data into list
    contentVersionDTOList.addAll(stipulationContentDTO);

    tffa.Logger.debug('contentVersionDTOList1 : ' + contentVersionDTOList);

    // Fetch all submission/Stipulation level content document link
    List<ContentDocumentLink> cdlList = FCMHelperRepository.findCDLinkByIdList(entityIds);

    List<Id> contentDocumentIdList = new List<Id>();
    for(ContentDocumentLink CDLink : cdlList){
      contentDocumentIdList.add(CDLink.ContentDocumentId);
    }

    // Fetch all content document link
    List<ContentDocumentLink> contentDocumentList = new List<ContentDocumentLink>();
    if(contentDocumentIdList.size() > 0){
      contentDocumentList = FCMHelperRepository.findCDLinkByContentDocumentIdList(contentDocumentIdList);
    }

    tffa.Logger.debug('contentDocumentList : ' + contentDocumentList);

    // Create a map of entity and its related document ids
    Map<String, List<String>> EntityMap = new Map<String, List<String>>();
    for(ContentDocumentLink CDLink : contentDocumentList){
      if(EntityMap.containsKey(CDLink.LinkedEntityId)){
        List<String> docIds = EntityMap.get(CDLink.LinkedEntityId);
        docIds.add(CDLink.ContentDocumentId);
        EntityMap.put(CDLink.LinkedEntityId, docIds);
      } else {
        EntityMap.put(CDLink.LinkedEntityId, new List<String>{ CDLink.ContentDocumentId});
      }
    }

    tffa.Logger.debug('EntityMap : ' + EntityMap);

    // Assign content document id for each DTO
    List<Id> CDList = new List<Id>();
    for(CZFCMContentVersionDTO cvDTO : contentVersionDTOList){
      if(EntityMap.containsKey(cvDTO.EntityId)){
        cvDTO.ContentDocumentId = EntityMap.get(cvDTO.EntityId)[0];
        CDList.add(cvDTO.ContentDocumentId);
      }
    }

    // Generate content version DTO for customer/Banker uploaded docs
    for(ContentDocumentLink CDLink : cdlList){
      if(!CDList.contains(CDLink.ContentDocumentId)){
        for(tffa__application__c app : FISCCIntegrationLogService.applicationObjs){
          CZFCMContentVersionDTO dto = new CZFCMContentVersionDTO();
          dto.ApplicationId = app.Id;
          dto.ContentDocumentId = CDLink.ContentDocumentId;
  
          contentVersionDTOList.add(dto);
        }
      }
    }

    CDList = new List<Id>();

    for(CZFCMContentVersionDTO cvDTO : contentVersionDTOList){
      CDList.add(cvDTO.ContentDocumentId);
    }

    // fetch all content versions
    List<ContentVersion> contentVersionList = findCVdataByDocId(CDList);

    Map<String, ContentVersion> contentversionMap = new Map<String, ContentVersion>();
    for(ContentVersion cv : contentVersionList){
      contentversionMap.put(cv.ContentDocumentId, cv);
    }

    tffa.Logger.debug('contentversionMap : ' + contentversionMap);

    // populate content version data into DTO
    for(CZFCMContentVersionDTO cvDTO : contentVersionDTOList){
      ContentVersion cv = contentversionMap.get(cvDTO.ContentDocumentId);
      if(cv != null){
        cvDTO.ContentVersionId = (String) cv.Id;
        cvDTO.FileExtension = (String) cv.FileExtension;
        cvDTO.PathOnClient = (String) cv.PathOnClient;
        cvDTO.contentSize = cv.contentSize;

        if(String.isBlank(cvDTO.Title)){
          cvDTO.Title = (String) cv.Title;
        }
      }
    }

    tffa.Logger.debug('contentVersionDTOList2 : ' + contentVersionDTOList);

    // Generate DTO for Internal content disclosures (Digital Channel)
    if(sub.tffa__Channel__c == 'DIGITAL'){
      contentVersionDTOList.addAll(fetchInternalContentData(new List<Id>{ String.valueOf(sub.Id)}));
    }

    tffa.Logger.debug('contentVersionDTOList3 : ' + contentVersionDTOList);

    return contentVersionDTOList;
  }

  // by submission
  public static List<CZFCMContentVersionDTO> fetchInternalContentData(List<Id> idList) {
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

    if(disclosureList == null || disclosureList.size() == 0){
      return contentVersionDTOList;
    }

    for(tffa__Disclosure__c disclosure: disclosureList){

      // if application and party is null upload the document for all application
      if(disclosure.tffa__Party__c == null && disclosure.tffa__LinkedApplication__c == null){
        contentVersionDTOList.addAll(generateInternalContentVersionDTO(disclosure));
        continue;
      }

      CZFCMContentVersionDTO dto = new CZFCMContentVersionDTO();
      dto.URL = disclosure.tffa__DocumentUrl__c ;
      dto.PartyId = disclosure.tffa__Party__c == null ? '' :  disclosure.tffa__Party__c;
      dto.ApplicationId = disclosure.tffa__LinkedApplication__c == null ? '' :  disclosure.tffa__LinkedApplication__c;
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
        dt.DeveloperName = strList[0];

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
      if(contentAssetMap != null && contentAssetMap.containsKey(dt.DeveloperName)){
        ContentAsset ca = contentAssetMap.get(dt.DeveloperName);
        
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

  // Generate content version DTO for disclosure(Digital flow) data
  public static List<CZFCMContentVersionDTO> generateInternalContentVersionDTO(tffa__Disclosure__c disclosure) {
    List<CZFCMContentVersionDTO> contentVersionDTOList = new List<CZFCMContentVersionDTO>();

    for(tffa__application__c app : FISCCIntegrationLogService.applicationObjs){
      CZFCMContentVersionDTO dto = new CZFCMContentVersionDTO();
      dto.URL = disclosure.tffa__DocumentUrl__c ;
      dto.ApplicationId = app.Id;

      contentVersionDTOList.add(dto);
    }

    return contentVersionDTOList;
  }

  // Generate DTO based on docusign disclosures
  public static List<CZFCMContentVersionDTO> fetchDocusignData(tffa__Submission__c sub) {
    List<CZFCMContentVersionDTO> contentVersionDTOList = new List<CZFCMContentVersionDTO>();

    List<String> typeList = new List<String>{'Docusign'};

    // Get disclosure based on submission,type and status
    String query = new tffa.QueryBuilder(tffa__Disclosure__c.SObjectType)
      .selectFields()
      .whereClause('tffa__Submission__c', ' =:attr1')
      .opAnd()
      .whereClause('tffa__Type__c', ' in :attr2')
      .opAnd()
      .whereClause('tffa__Status__c', ' =:attr3')
      .build()
      .toQuery();	
                
    List<tffa__Disclosure__c> disclosureList = (List<tffa__Disclosure__c>) doQuery(query, new List<Object>{ sub.Id, typeList, 'Completed' });
    tffa.Logger.debug('disclosureList : ' + disclosureList);

    for(tffa__Disclosure__c disclosure : disclosureList){
      if(String.isNotBlank(disclosure.CZRelatedApplication__c)){
        String[] applicationList = disclosure.CZRelatedApplication__c.split(',');

        // Run for all application
        for(String appId: applicationList){
          if(String.isNotBlank(appId)){
            disclosure.tffa__LinkedApplication__c = appId;
            contentVersionDTOList.add(generateDisclosreContentVersionDTO(disclosure)) ;
          }
        }
        continue;
      }

      contentVersionDTOList.add(generateDisclosreContentVersionDTO(disclosure)) ;
    }
    return contentVersionDTOList;
  }

  // Generate content version DTO for docusign disclosure data
  public static CZFCMContentVersionDTO generateDisclosreContentVersionDTO(tffa__Disclosure__c disclosure){
    CZFCMContentVersionDTO dto = new CZFCMContentVersionDTO();
    dto.DocumentCode = disclosure.tffa__Code__c;
    dto.EntityId = disclosure.Id;
    dto.PartyId = disclosure.tffa__Party__c == null ? '' :  disclosure.tffa__Party__c;
    dto.ApplicationId = disclosure.tffa__LinkedApplication__c == null ? '' :  disclosure.tffa__LinkedApplication__c;
    dto.Title = disclosure.Name;

    return dto;
  }

  // Generate DTO based on Stipulations

  // Not listing under submission after raising and after uploading also
  public static List<CZFCMContentVersionDTO> fetchStipulationData(tffa__Submission__c sub) {
    List<CZFCMContentVersionDTO> contentVersionDTOList = new List<CZFCMContentVersionDTO>();

    List<String> partyIds = new List<String>();
    for(tffa__SubmissionPartyXref__c spx: sub.tffa__PartyXrefs__r){
      partyIds.add(spx.tffa__Party__r.Id);
    }

    // Get Stipulation based on partyId and status
    String query = new tffa.QueryBuilder(tffa__Stipulation__c.SObjectType)
      .selectFields()
      .whereClause('tffa__Party__c', ' in :attr1')
      .build()
      .toQuery();	
                
    List<tffa__Stipulation__c> stipulationList = (List<tffa__Stipulation__c>) doQuery(query, new List<Object>{ partyIds });
    tffa.Logger.debug('stipulationList : ' + stipulationList);

    for(tffa__Stipulation__c stipulation : stipulationList){
      contentVersionDTOList.add(generateStipulationContentVersionDTO(stipulation)) ;
    }
    
    return contentVersionDTOList;
  }

  // Generate content version DTO for Stipulation data
  public static CZFCMContentVersionDTO generateStipulationContentVersionDTO(tffa__Stipulation__c stipulation){
    CZFCMContentVersionDTO dto = new CZFCMContentVersionDTO();
    dto.DocumentCode = stipulation.tffa__Code__c;
    dto.EntityId = stipulation.Id;
    dto.PartyId = stipulation.tffa__Party__c == null ? '' :  stipulation.tffa__Party__c;
    dto.ApplicationId = stipulation.tffa__Application__c == null ? '' :  stipulation.tffa__Application__c;
    dto.Title = stipulation.Name;

    return dto;
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