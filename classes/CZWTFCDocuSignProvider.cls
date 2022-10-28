public with sharing class CZWTFCDocuSignProvider {
  private static WintrustEnvConfig__mdt wintrustEnvConfig = CZWTFCHelperRepository.fetchWintrustEnvConfig();
  public static CZWTFCDocusingResult generateEnvelope(Map<string, string> params) {
    tffa.Logger.debug('In method CZWTFCDocuSignProvider::generateEnvelope');
    String submissionId = '';
    String envelopeId = '';
    String returnString = '';
    String requestType = '';
    String action = '';
    String documentType = 'Docusign';
    List<tffa__Disclosure__c> disclosuresWithEnvId = new List<tffa__Disclosure__c>();
    List<tffa__Disclosure__c> disclosures;

    submissionId = params.get('SubmissionId');
    requestType = params.get('RequestType');
    if (Test.isRunningTest()) {
      action = CZDocusignConstants.GENERATE_DRAFT_MODE;
    }
    if (params.containsKey('action')) {
      action = params.get('action');
    }
    CZWTFCDocusingResult resp = new CZWTFCDocusingResult();
    //Map<String, List<tffa__Disclosure__c>> envDiscMap = new Map<String, List<tffa__Disclosure__c>>();
    disclosures = CZDocusignRepository.getSubmissionDocuments(submissionId, documentType, Integer.valueOf(params.get('disclosureSet')));
    //List<List<tffa__Disclosure__c>> discSplitedList = new List<List<tffa__Disclosure__c>>();

    //discSplitedList = splitDisclosures(disclosures); // multiple envelope handling

    //for (List<tffa__Disclosure__c> discList : discSplitedList) {
    CZDocusignDocumentBuilder documentBuilder = new CZDocusignDocumentBuilder(submissionId, disclosures, requestType);
    List<CZWTFCDocusignRequestDTO.CompositeTemplateDTO> compositeTemplates = documentBuilder.getListOfDocuments();

    if (action == CZDocusignConstants.GENERATE_DRAFT_MODE) {
      List<CZWTFCDocusignRequestDTO.CompositeTemplateDTO> compositeTemplatesDuplicated = new List<CZWTFCDocusignRequestDTO.CompositeTemplateDTO>();
      compositeTemplatesDuplicated.addAll(compositeTemplates);
      compositeTemplates.clear();
      compositeTemplates.add(reviewDocument());
      compositeTemplates.addAll(compositeTemplatesDuplicated);
    }

    //documents.submissionId = submissionId;
    CZWTFCDocusignService docusignService = new CZWTFCDocusignService();
    CZWTFCDocusingResult result = docusignService.initateDocusign(compositeTemplates, action);

    tffa.Logger.debug('result==>' + result);
    //tffa.Logger.debug('documents==>' + documents);
    if (String.isNotBlank(result.envelopeId) && action == CZDocusignConstants.GENERATE_ENVELOPE_MODE) {
      resp.envelopeIDs.add(result.envelopeId);
      // envDiscMap.put(result.envelopeId, discList);
    } else if (String.isNotBlank(result.url) && action == CZDocusignConstants.GENERATE_DRAFT_MODE) {
      resp.draftURLs.add(result.url);
    } else {
      resp.status = 'FAILURE';
    }

    //Check if DocuSign envelope is created
    if (resp.status != 'FAILURE' && action == CZDocusignConstants.GENERATE_ENVELOPE_MODE) {
      tffa__Submission__c submission = CZWTFCSubmissionRepository.findOne(submissionId);
      updateDiscEnv(submission, disclosures, result.envelopeId);
      // if (params.get('disclosureSet') == '1') {
      //    updateAppStatus(submission);
      // }
    }

    tffa.Logger.debug('resp==' + resp.draftURLs);

    return resp;
  }

  public static void updateDiscEnv(tffa__Submission__c submission, List<tffa__Disclosure__c> disclosures, String envelope) {
    //List<tffa__DisclosureEnvelope__c> discEnvList = CZDocusignRepository.fetchDisclosureEnvBySubId(submission.Id);
    List<tffa__DisclosureEnvelope__c> disEnvListUpdated = new List<tffa__DisclosureEnvelope__c>();
    List<tffa__Disclosure__c> discList = new List<tffa__Disclosure__c>();

    tffa__DisclosureEnvelope__c discEnv = new tffa__DisclosureEnvelope__c();
    discEnv.tffa__Submission__c = submission.Id;
    discEnv.Name = 'Application_DocumentGeneration';
    discEnv.tffa__State__c = 'SENT';
    discEnv.tffa__Status__c = 'GENERATED';
    discEnv.tffa__ExternalId__c = envelope;
    discEnv.tffa__ReminderCount__c = 0;
    discEnv.tffa__Channel__c = 'BRANCH';
    disEnvListUpdated.add(discEnv);

    List<tffa__DisclosureEnvelope__c> updatedDiscEnv = CZDocusignRepository.saveDisclosureEnv(disEnvListUpdated);

    for (tffa__DisclosureEnvelope__c discEnvObj : updatedDiscEnv) {
      for (tffa__Disclosure__c disc : disclosures) {
        disc.tffa__Envelope__c = discEnvObj.Id;
        disc.tffa__EnvelopeId__c = discEnvObj.tffa__ExternalId__c;
        discList.add(disc);
      }
    }

    CZWTFCHelperRepository.save(discList);
  }

  public static CZWTFCDocusignRequestDTO.CompositeTemplateDTO reviewDocument() {
    CZWTFCDocusignRequestDTO.CompositeTemplateDTO reviewDocumentTemplateDTO = new CZWTFCDocusignRequestDTO.CompositeTemplateDTO();
    CZWTFCDocusignRequestDTO.ServerTemplateDTO serverTemplate = new CZWTFCDocusignRequestDTO.ServerTemplateDTO();
    CZWTFCDocusignRequestDTO.InlineTemplateDTO inlineTemplate = new CZWTFCDocusignRequestDTO.InlineTemplateDTO();
    reviewDocumentTemplateDTO.inlineTemplates = new List<CZWTFCDocusignRequestDTO.InlineTemplateDTO>();
    reviewDocumentTemplateDTO.inlineTemplates.add(inlineTemplate);
    serverTemplate.templateId = wintrustEnvConfig.CZDocusignReviewTemplateId__c;
    reviewDocumentTemplateDTO.serverTemplates = new List<CZWTFCDocusignRequestDTO.ServerTemplateDTO>{ serverTemplate };
    return reviewDocumentTemplateDTO;
  }

  // public static void updateAppStatus(tffa__Submission__c sub) {
  //   for (tffa__Application__c appObj : sub.tffa__Applications__r) {
  //     if (appObj.tffa__Status__c == 'SUBMITTED') {
  //       appObj.tffa__Status__c = 'DOCS_GENERATED';
  //     }
  //   }
  //   WTFCObjectManagerRepository.doUpsertObjects(sub.tffa__Applications__r);
  // }
}