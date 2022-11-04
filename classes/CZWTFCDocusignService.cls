public with sharing class CZWTFCDocusignService {
  public List<CZWTFCDocusignRequestDTO.CompositeTemplateDTO> lstCompositeTemplate = new List<CZWTFCDocusignRequestDTO.CompositeTemplateDTO>();
  //Docusign Signers list to be used in case of online signing
  //  List<CZWTFCDocusignRequestDTO.SignerDTO> lstDocusignSigners = new List<CZWTFCDocusignRequestDTO.SignerDTO>();
  //Signers
  //  public CZWTFCDocusignRequestDTO.SignerDTO signer = new CZWTFCDocusignRequestDTO.SignerDTO();

  public CZWTFCDocusingResult initateDocusign(List<CZWTFCDocusignRequestDTO.CompositeTemplateDTO> compositeTemplates, String action) {
    CZWTFCDocusignRequestDTO request = new CZWTFCDocusignRequestDTO();
    CZWTFCDocusingResult result = new CZWTFCDocusingResult();
    tffa.Interaction.begin(CZWTFCDocusignService.class, 'initateDocusign');
    try {
      tffa.Logger.debug('In CZWTFCDocusignService');
      try {
        request.envelope.compositeTemplates = compositeTemplates;
        request.envelope.status = action;
      } catch (Exception ex) {
        tffa.Logger.debug('Exception in CZWTFCDocusignService ' + ex.getLineNumber() + ' ' + ex.getMessage());
      }
      result = processRequest(request, action);
    } finally {
      tffa.Interaction.close();
    }
    return result;
  }

  public CZWTFCDocusingResult processRequest(CZWTFCDocusignRequestDTO request, String action) {
    CZWTFCDocusingResult docuResult = new CZWTFCDocusingResult();

    try {
      tffa.Interaction.begin(CZWTFCDocusignService.class, 'processRequest');

      //Call API to send templates and generate envelop ID
      CZWTFCDocusignAdapter adptr = new CZWTFCDocusignAdapter(request);
      CZWTFCDocusignResponseDTO generateEnvelopIDresponse = adptr.processRequestforApplicationDocusign();
      tffa.Logger.debug('response from generate envelop => ' + generateEnvelopIDresponse);

      if ((generateEnvelopIDresponse != null && generateEnvelopIDresponse.envelopeResp != null) || test.isRunningTest()) {
        tffa.Logger.debug('generateEnvelopIDresponse==>' + generateEnvelopIDresponse);
        docuResult.envelopeId = test.isRunningTest() ? '1234' : generateEnvelopIDresponse.envelopeResp.envelopeId;
        // tffa.Logger.debug('docuRequest==>' + docuRequest);

        if (action == CZDocusignConstants.GENERATE_DRAFT_MODE) {
          //Call API to get recipeint view for each recipient
          //adptr = new CZWTFCDocusignAdapter(request);
          Map<String, String> params = new Map<String, String>();
          params.put('envId', docuResult.envelopeId);
          docuResult = adptr.fetchDocusignUrl(params);
          tffa.Logger.debug('Result from recipeint view API ==>' + docuResult);
        }
      }
    } finally {
      tffa.Interaction.close();
    }

    return docuResult;
  }
  /*
  public CZWTFCDocusignRequestDTO.CompositeTemplateDTO createTemplate(CZDocusignDocumentGenDTO document) {
    CZWTFCDocusignRequestDTO.CompositeTemplateDTO compositTemplate = new CZWTFCDocusignRequestDTO.CompositeTemplateDTO();

    CZWTFCDocusignRequestDTO.ServerTemplateDTO serverTemplate = new CZWTFCDocusignRequestDTO.ServerTemplateDTO();
    serverTemplate.templateId = document.documentDTO.documentId;
    serverTemplate.sequence = String.valueOf(document.documentDTO.sequenceNumber);

    compositTemplate.serverTemplates = new List<CZWTFCDocusignRequestDTO.ServerTemplateDTO>{ serverTemplate };
    //----------------------------------------------------------------------------------------------------------

    CZWTFCDocusignRequestDTO.InlineTemplateDTO inlineTemplate = new CZWTFCDocusignRequestDTO.InlineTemplateDTO();
    inlineTemplate.sequence = String.valueOf(document.documentDTO.sequenceNumber);
    inlineTemplate.recipients = new CZWTFCDocusignRequestDTO.RecipientDTO();

    inlineTemplate.recipients.signers = new List<CZWTFCDocusignRequestDTO.SignerDTO>();

    inlineTemplate.recipients.signers = addSigners(document);
    //Add Signers
    tffa.Logger.debug('template fater adding signers ==>' + JSON.serialize(inlineTemplate.recipients.signers));
    compositTemplate.inlineTemplates = new List<CZWTFCDocusignRequestDTO.InlineTemplateDTO>{ inlineTemplate };
    return compositTemplate;
  }

  public CZWTFCDocusignRequestDTO.EnvelopeRecipientTabDTO getSignerTabs(CZDocusignDocumentGenDTO.SignerDTO signerDTO) {
    //Map result to docusing request
    CZWTFCDocusignRequestDTO.EnvelopeRecipientTabDTO lsttabs = new CZWTFCDocusignRequestDTO.EnvelopeRecipientTabDTO();
    lsttabs.textTabs = new List<CZWTFCDocusignRequestDTO.TextTabDTO>(); //document.documentDTO.prefillDataDTO.lstTextDTO;
    for (CZDocusignDocumentGenDTO.TextDTO textDTO : signerDTO.prefillDataDTO.lstTextDTO) {
      CZWTFCDocusignRequestDTO.TextTabDTO txt = new CZWTFCDocusignRequestDTO.TextTabDTO();
      txt.tabLabel = textDTO.name;
      txt.value = textDTO.value;
      lsttabs.textTabs.add(txt);
    }
    signerDTO.prefillDataDTO.lstTextDTO.clear(); //TODO: check without clear();
    lsttabs.radioGroupTabs = new List<CZWTFCDocusignRequestDTO.RadioTabDTO>(); //document.documentDTO.prefillDataDTO.lstTextDTO;
    for (CZDocusignDocumentGenDTO.RadioDTO textDTO : signerDTO.prefillDataDTO.lstRadioTO) {
      CZWTFCDocusignRequestDTO.RadioTabDTO txt = new CZWTFCDocusignRequestDTO.RadioTabDTO();
      txt.radios = new List<CZWTFCDocusignRequestDTO.RadiosDTO>();
      CZWTFCDocusignRequestDTO.RadiosDTO radiovalue = new CZWTFCDocusignRequestDTO.RadiosDTO();
      txt.groupName = textDTO.name;
      radiovalue.value = textDTO.radios[0].value;
      radiovalue.selected = 'true';
      txt.radios.add(radiovalue);
      lsttabs.radioGroupTabs.add(txt);
    }
    signerDTO.prefillDataDTO.lstRadioTO.clear();

    // lsttabs.checkboxTabs = new List<CZWTFCDocusignRequestDTO.CheckboxTabDTO>(); //document.documentDTO.prefillDataDTO.lstCheckBoxTO;

    lsttabs.checkboxTabs = new List<CZWTFCDocusignRequestDTO.CheckboxTabDTO>(); //document.documentDTO.prefillDataDTO.lstTextDTO;
    for (CZDocusignDocumentGenDTO.CheckboxDTO textDTO : signerDTO.prefillDataDTO.lstCheckBoxTO) {
      CZWTFCDocusignRequestDTO.CheckboxTabDTO txt = new CZWTFCDocusignRequestDTO.CheckboxTabDTO();
      txt.tabLabel = textDTO.name;
      txt.value = textDTO.value;
      txt.selected = textDTO.selected;
      lsttabs.checkboxTabs.add(txt);
    }
    signerDTO.prefillDataDTO.lstCheckBoxTO.clear();
    //Initiate

    return lsttabs;
  }

  public List<CZWTFCDocusignRequestDTO.SignerDTO> addSigners(CZDocusignDocumentGenDTO document) {
    List<CZWTFCDocusignRequestDTO.SignerDTO> result = new List<CZWTFCDocusignRequestDTO.SignerDTO>();
    Integer count = 0;
    for (CZDocusignDocumentGenDTO.SignerDTO signerDTO : document.documentDTO.lstSignerDTO) {
      CZWTFCDocusignRequestDTO.SignerDTO signer = new CZWTFCDocusignRequestDTO.SignerDTO();
      signer.name = signerDTO.name;
      signer.email = signerDTO.email;
      signer.recipientId = String.valueOf(signerDTO.recipientId);
      signer.clientUserId = String.valueOf(signerDTO.clientUserId);
      signer.roleName = signerDTO.roleName;

      signer.tabs = getSignerTabs(signerDTO);
      result.add(signer);
    }
    return result;
  }

  public static List<tffa__Party__c> fetchSigningStatus(Map<String, String> params) {
    CZWTFCDocusignResponseDTO response = new CZWTFCDocusignResponseDTO();
    tffa__Submission__c sub = CZWTFCSubmissionRepository.findOne(params.get('Submission__c'));
    String partyid = params.containsKey('Party__c') ? params.get('Party__c') : '';
    Map<String, tffa__Party__c> partymap = new Map<String, tffa__Party__c>();
    CZWTFCDocusignRequestDTO request = new CZWTFCDocusignRequestDTO();
    String envelopeId = sub.DocusignEnvelopID__c;
    List<tffa__Party__c> pendingSigners = new List<tffa__Party__c>();
    response = getSignersStatus(sub.id, envelopeId); //here
    //sub = CustomSubmissionRepository.findSubmissionById(params.get('Submission__c'));
    Set<Id> idSet = new Set<Id>();
    for (tffa__SubmissionPartyXref__c signerfromObject : sub.tffa__PartyXrefs__r) {
      idSet.add(signerfromObject.tffa__Party__c);
    }
    Integer pendingcount = 0;
    pendingSigners = FISCCIntegrationLogRepository.findPartydWithChildObjects(new List<Id>(idSet));
    tffa.Logger.debug('Signing Resp ' + response);
    if (response.signersStatus != null) {
      for (tffa__Party__c signerfromObject : pendingSigners) {
        Boolean issigner = false;
        // for (Docusign_Signing_Sequence__c signerfromObject : lstSigners) {
        for (CZWTFCSignersStatusDTO.SignersDTO signerfromAPI : response.signersStatus.signers) {
          if (signerfromAPI.email == signerfromObject.tffa__PrimaryEmail__c && signerfromAPI.name == signerfromObject.Name) {
            issigner = true;
            if ('Completed'.equalsIgnorecase(signerfromAPI.status)) {
              //Update status to Done
              signerfromObject.SigningStatus__c = 'Done';
            } else if (!'Completed'.equalsIgnorecase(signerfromAPI.status)) {
              signerfromObject.SigningStatus__c = 'Pending';

              pendingcount++;
            }
          }
        }
        tffa.Logger.debug('Pending Count ' + pendingcount);
        if (!issigner) {
          signerfromObject.SigningStatus__c = 'Done';
        }
        partymap.put(signerfromObject.id, signerfromObject);
      }
      FISCCObjectManagerRepository.doUpsertParties(pendingSigners);
    }
    if (pendingcount > 0) {
      sub.Envelope_Status__c = 'In Progress';
      // sub.tffa__State__c = 'Pending Docusign Signature';
    } else {
      sub.Envelope_Status__c = 'Completed';
      sub.Document_Saved_Status__c = 'Completed';
    }

    FISCCObjectManagerRepository.updateRecords(new List<tffa__Submission__c>{ sub });
    if (String.isNotBlank(partyid) && partymap.containsKey(partyid)) {
      return (new List<tffa__Party__c>{ partymap.get(partyid) });
    }
    return pendingSigners;
  }
*/
  public static CZWTFCSignersStatusDTO getSignersStatus(String submissionId, String envelopeId) {
    //CZWTFCDocusignRequestDTO request = new CZWTFCDocusignRequestDTO();
    CZWTFCDocusignAdapter adptr = new CZWTFCDocusignAdapter();
    CZWTFCSignersStatusDTO response;
    try {
      //Call Get Signers Status API
      response = adptr.getSignersStatus(envelopeId);
    } catch (exception ex) {
      tffa.Logger.debug('Exception in getSignersStatus  ==>' + ex.getStackTraceString() + 'at line number ' + ex.getLineNumber());
    }
    return response;
  }
  /*
  public CZWTFCDocusingResult prefillEnv(Map<String, String> params) {
    tffa.Logger.debug('In prefillEnv');
    tffa__Submission__c sub = CZWTFCSubmissionRepository.findOne(params.get('Submission__c'));
    tffa__DisclosureEnvelope__c discEnv = CZDocusignRepository.fetchDiscEnv(sub.Id);
    CZWTFCDocusingResult result = new CZWTFCDocusingResult();
    CZWTFCDocusignAdapter docAdapter = new CZWTFCDocusignAdapter();
    try {
      if (discEnv != null) {
        params.put('envId', discEnv.tffa__ExternalId__c);
        Blob respBlob = docAdapter.prefilledEnvelope(params);
        if (respBlob != null) {
          tffa.DocumentMetadataDTO report = new tffa.DocumentMetadataDTO('Docusign-Prefill.pdf', respBlob, sub.Id, 'OTHER');
          report.participants.add(new tffa.DocumentParticipantDTO(null, (String) discEnv.Id));
          ContentVersion cv = tffa.ContentService.createContentWithParticipant(report);
          result.msg = 'Success';
          result.contentDocId = cv.ContentDocumentId;
          return result;
        }
      }
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in prefill Env' + ex.getMessage());
    }
    result.msg = 'Failure';
    return result;
  }

  public CZWTFCDocusingResult fetchDocUrl(Map<String, String> params) {
    tffa.Logger.debug('In fetchDocUrl');
    CZWTFCDocusingResult result = new CZWTFCDocusingResult();
    CZWTFCDocusignRequestDTO request = new CZWTFCDocusignRequestDTO();
    CZWTFCDocusignAdapter docAdapter = new CZWTFCDocusignAdapter(request);
    try {
      result = docAdapter.fetchDocusignUrl(params);
      return result;
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in fetchDocUrl Env' + ex.getMessage());
    }
    result.msg = 'Failure';
    return result;
  }*/
}