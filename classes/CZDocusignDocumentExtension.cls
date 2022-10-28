public with sharing class CZDocusignDocumentExtension {
  public static void fetchAndSaveDocument(List<tffa__Disclosure__c> discList) {
    Map<Id, Blob> pdfMap = new Map<Id, Blob>();
    tffa.Logger.debug('In fetchAndSaveDocument' + discList);
    List<tffa__Disclosure__c> wetsignDisc = new List<tffa__Disclosure__c>();
    Map<String, List<tffa__Disclosure__c>> envDiscLstMap = CZWTFCSubmissionRepository.fetchEnvsByEnvIds(discList);
    for (tffa__Disclosure__c discObj : discList) {
      try {
        if (discObj.tffa__ProcessState__c != 'Downloaded') {
          tffa.Logger.debug('In discObjtffa__ProcessState__c ' + discObj.tffa__ProcessState__c);
          List<ContentDocumentLink> documents = FCMHelperRepository.findCDLinkByIdList(new List<Id>{ discObj.Id });
          if (documents != null && !documents.isEmpty()) {
            discObj.tffa__ProcessState__c = 'Downloaded';
            wetsignDisc.add(discObj);
          }
          if (discObj.tffa__ProcessState__c != 'Downloaded') {
            tffa.Logger.debug('In fetchAndSaveDocument1');
            Map<String, String> reqMap = new Map<String, String>();
            reqMap.put('envId', discObj.tffa__EnvelopeId__c);
            reqMap.put('documentId', getDocId(discObj, envDiscLstMap));
            CZWTFCDocusignAdapter docAdapter = new CZWTFCDocusignAdapter();
            Blob documentPdf = docAdapter.fetchDocumentPDF(reqMap);
            if (documentPdf != null) {
              pdfMap.put(discObj.Id, documentPdf);
            }
          }
        }
      } catch (Exception ex) {
        tffa.Logger.error('Exception in downloading docs ' + ex.getMessage() + ex.getStackTraceString());
      }
    }
    tffa.Logger.debug('In pdfMap ' + pdfMap.keySet());
    List<tffa__Disclosure__c> discUpdatedList = new List<tffa__Disclosure__c>();
    for (tffa__Disclosure__c disc : discList) {
      try {
        if (pdfMap.containsKey(disc.Id)) {
          Blob respBlob = pdfMap.get(disc.Id);
          tffa.DocumentMetadataDTO doc = new tffa.DocumentMetadataDTO(disc.Name + '.pdf', respBlob, disc.Id, 'OTHER');
          doc.participants.add(new tffa.DocumentParticipantDTO(null, (String) disc.tffa__Submission__c));
          ContentVersion cv = tffa.ContentService.createContentWithParticipant(doc);
          disc.tffa__ProcessState__c = 'Downloaded';
          discUpdatedList.add(disc);
        }
      } catch (Exception ex) {
        tffa.Logger.error('Exception in saving content version ' + ex.getMessage() + ex.getStackTraceString());
      }
    }
    if (!discUpdatedList.isEmpty()) {
      WTFCObjectManagerRepository.doUpsertObjects(discUpdatedList);
    }
    if (!wetsignDisc.isEmpty()) {
      WTFCObjectManagerRepository.doUpsertObjects(wetsignDisc);
    }
  }

  public static String getDocId(tffa__Disclosure__c disc, Map<String, List<tffa__Disclosure__c>> envDiscLstMap) {
    List<tffa__Disclosure__c> discLst = envDiscLstMap.get(disc.tffa__EnvelopeId__c);
    Integer docId = (Integer.valueOf(disc.tffa__SortOrder__c) - Integer.valueOf(discLst[0].tffa__SortOrder__c)) + 1;
    return String.valueOf(docId);
  }
}