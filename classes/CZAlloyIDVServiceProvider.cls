// Copyright (c) 2019 Terafina Inc
/**
 * Default implementation of IDVServiceProvider that uses Alloy APIs to fetch DueDiligence details (primarily IDV).
 * @group Provider
 */
global inherited sharing virtual class CZAlloyIDVServiceProvider extends tffa.DueDiligenceServiceProvider {
  private final tffa.AlloyServiceHelper helper = new tffa.AlloyServiceHelper();

  global List<tffa__Party__c> verifyUsingAlloy(List<tffa__Party__c> parties, Map<String, Object> facts) {
    /*    Map<Id, tffa__Party__c> partyMap = new Map<Id, tffa__Party__c>(
      CZWTFCPartyRepository.findByIdWithAddressType(tffa.CollectionUtils.getIds(parties), new Set<String>{ 'HOME', 'REGISTERED' })
    );*/
    String submissionId = (String) facts.get('Submission__c');

    // load old dds
    List<tffa__DueDiligence__c> oldDDs = tffa.DueDiligenceService.readAll(
      new tffa.QueryContext(
        new Map<String, Object>{
          'Party__c' => tffa.CollectionUtils.getIds(parties),
          'Type__c' => new List<String>{
            tffa.DueDiligenceType.IDV.name(),
            tffa.DueDiligenceType.IDA.name(),
            tffa.DueDiligenceType.OFAC.name(),
            tffa.DueDiligenceType.FRAUD.name(),
            tffa.DueDiligenceType.DEBIT_BUREAU.name(),
            tffa.DueDiligenceType.DEVICE.name()
          }
        }
      )
    );

    //List<tffa__Party__c> modified = new List<tffa__Party__c>();
    List<tffa__DueDiligence__c> allDiligences = new List<tffa__DueDiligence__c>();
    List<tffa.DocumentMetadataDTO> allReports = new List<tffa.DocumentMetadataDTO>();
    Map<String, Object> allFacts = facts;
    for (tffa__Party__c party : parties) {
      /* tffa__Party__c original = partyMap.get(party.Id);
      if (original == null) {
        throw new tffa.ApplicationException('Party not found');
      }*/
      facts = allFacts.clone();
      List<tffa__DueDiligence__c> diligences = new List<tffa__DueDiligence__c>(party.tffa__DueDiligences__r);
      if (party.tffa__Type__c == 'INDIVIDUAL') {
        verifyIndividual(party, diligences, allReports, facts);
      } else {
        verifyOrganization(party, diligences, allReports, facts);
      }
      allDiligences.addAll(diligences);
      //modified.add(party);
    }

    // mark old DueDiligence(s) for delete
    if (facts.get('Type__c') == tffa.DueDiligenceType.IDV.name()) {
      for (tffa__DueDiligence__c dd : oldDDs) {
        dd.tffa__IsDeleted__c = true;
        allDiligences.add(dd);
      }
    }

    if (!allDiligences.isEmpty()) {
      allDiligences = tffa.DueDiligenceService.createOrUpdate(allDiligences, new Map<String, Object>());
    }
    if (!allReports.isEmpty()) {
      for (tffa.DocumentMetadataDTO report : allReports) {
        // also link submission if available
        if (submissionId != null) {
          report.participants.add(new tffa.DocumentParticipantDTO(null, submissionId));
        }
      }
      tffa.ContentService.createOrUpdate(allReports);
    }
    //parties = modified;
    // modified = new List<tffa__Party__c>();
    for (tffa__Party__c party : parties) {
      // remove additional nodes fetched during evaluation
      party = (tffa__Party__c) tffa.SObjectAssembler.set(party, 'AddressXrefs__r', null);
      party = tffa.PartyService.modify(party);
      tffa__DueDiligence__c idaDD = getDueDiligence(allDiligences, party.Id, tffa.DueDiligenceType.IDA);
      if (idaDD?.tffa__Status__c == 'IN_PROGRESS') {
        party = (tffa__Party__c) tffa.SObjectAssembler.set(party, 'DueDiligences__r', new List<tffa__DueDiligence__c>{ idaDD });
      }
      //modified.add(party);
    }
    return parties;
  }

  /**
   * Populates individual details on the evaluation request.
   * @param request EvaluationRequest
   * @param party Person
   * @param facts additional information passed to verify
   */
  global void populatePersonDetails(tffa.AlloyDTO.EvaluationRequest request, tffa__Party__c party, Map<String, Object> facts) {
    helper.populatePersonDetails(request, party);
    checkFieldLimit(request, party);
    populatePhoneNumber(request, party);
    if (facts.containsKey('AUTHENTICATED_CUSTOMER')) {
      request.existing_customer = true;
    }
    if (
      tffa__EnvironmentConfiguration__c.getOrgDefaults().tffa__EnableIovationDeviceFingerprinting__c &&
      tffa.AgentDetailService.getCurrentAgentDetail().tffa__Channel__c == 'DIGITAL'
    ) {
      request.iovation_blackbox = (String) facts.get('DeviceToken__c');
    }
  }

  global void checkFieldLimit(tffa.AlloyDTO.EvaluationRequest request, tffa__Party__c party) {
    if (request.name_first.length() > 36) {
      request.name_first = request.name_first.substring(0, 35);
    }
    if (request.name_last.length() > 36) {
      request.name_last = request.name_last.substring(0, 35);
    }
  }
  global void populatePhoneNumber(tffa.AlloyDTO.EvaluationRequest request, tffa__Party__c party) {
    String strPrimaryphone = party.tffa__PrimaryPhone__c != null ? party.tffa__PrimaryPhone__c : '';
    String strSecondaryphone = party.tffa__SecondaryPhone__c != null ? party.tffa__SecondaryPhone__c : '';
    String strCellphone = party.CellPhoneNumber__c != null ? party.CellPhoneNumber__c : '';
    if (String.isNotBlank(party.PreferredContactNumber__c) && party.PreferredContactNumber__c.equalsIgnoreCase('HOME')) {
      if (strPrimaryphone.length() > 10) {
        request.phone_number = strPrimaryphone.Substring(strPrimaryphone.length() - 10);
      } else {
        request.phone_number = strPrimaryphone;
      }
    }
    if (String.isNotBlank(party.PreferredContactNumber__c) && party.PreferredContactNumber__c.equalsIgnoreCase('WORK')) {
      if (strSecondaryphone.length() > 10) {
        request.phone_number = strSecondaryphone.Substring(strSecondaryphone.length() - 10);
      } else {
        request.phone_number = strSecondaryphone;
      }
    }
    if (String.isNotBlank(party.PreferredContactNumber__c) && party.PreferredContactNumber__c.equalsIgnoreCase('CELL')) {
      if (strCellphone.length() > 10) {
        request.phone_number = strCellphone.Substring(strCellphone.length() - 10);
      } else {
        request.phone_number = strCellphone;
      }
    }
  }

  /**
   * Populates submission details on the evaluation request.
   * @param request EvaluationRequest
   * @param sub Submission
   * @param facts additional information passed to verify
   */
  global void populateSubmissionDetails(tffa.AlloyDTO.EvaluationRequest request, tffa__Submission__c sub, Map<String, Object> facts) {
    helper.populateSubmissionDetails(request, sub);
    request.meta.submission_id = sub.Name;
  }

  /**
   * Populates business details on the evaluation request.
   * @param request EvaluationRequest
   * @param party Business
   * @param facts additional information passed to verify
   */
  global void populateBusinessDetails(tffa.AlloyDTO.EvaluationRequest request, tffa__Party__c party, Map<String, Object> facts) {
    helper.populateBusinessDetails(request, party, tffa.AlloyServiceHelper.LT_BIZCHEX_ORGANIZATION_TYPES);
  }

  /**
   * Populates representatives of the business on the evaluation request.
   * @param request EvaluationRequest
   * @param party Business
   * @param relatedPartyXrefs relationships with Business
   * @param facts additional information passed to verify
   */
  global void populateRepresentatives(
    tffa.AlloyDTO.EvaluationRequest request,
    tffa__Party__c party,
    List<tffa__PartyPartyXref__c> relatedPartyXrefs,
    Map<String, Object> facts
  ) {
    // restrict relationships to parties in the submission
    List<tffa__PartyPartyXref__c> ppXrefs = new List<tffa__PartyPartyXref__c>();
    Set<String> relatedPartyIds = new Set<String>();
    Integer ownerCount = 0;
    Integer signerCount = 0;
    for (tffa__PartyPartyXref__c ppx : relatedPartyXrefs) {
      // filter relationships by business owner or authorized signer
      // restrict to business owner to 1
      // restrict to authorized signer to 2
      if ((ppx.tffa__RelationCodeValue__c == '101' || ppx.tffa__RelationCodeValue__c == '103') && ownerCount < 1) {
        ppXrefs.add(ppx);
        relatedPartyIds.add(ppx.tffa__RelatedParty__c);
        ownerCount++;
      } else if (ppx.tffa__RelationCodeValue__c == 'AUTHORIZED_SIGNATORY' && signerCount < 2) {
        ppXrefs.add(ppx);
        relatedPartyIds.add(ppx.tffa__RelatedParty__c);
        signerCount++;
      }
    }
    if (!ppXrefs.isEmpty()) {
      Map<Id, tffa__Party__c> partyMap = new Map<Id, tffa__Party__c>(
        CZWTFCPartyRepository.findByIdWithAddressType(relatedPartyIds, new Set<String>{ 'HOME' })
      );
      for (tffa__PartyPartyXref__c ppx : ppXrefs) {
        tffa__Party__c relatedParty = partyMap.get(ppx.tffa__RelatedParty__c);
        tffa.AlloyDTO.Representative rep = request.addRepresentative();
        helper.populatePersonDetails(rep, relatedParty);
        rep.type = (ppx.tffa__RelationCategory__c == '101' ||
          ppx.tffa__RelationCodeValue__c == '103')
          ? 'principal_owner'
          : 'authorized_signer';
        if (!relatedParty.tffa__AddressXrefs__r.isEmpty()) {
          helper.addAddressDetails(rep, relatedParty.tffa__AddressXrefs__r[0].tffa__Address__r, 'primary');
        }
      }
    }
  }

  private void verifyIndividual(
    tffa__Party__c party,
    tffa__DueDiligence__c[] diligences,
    tffa.DocumentMetadataDTO[] reports,
    Map<String, Object> facts
  ) {
    tffa__Submission__c sub = (tffa__Submission__c) facts.get('Submission__r');
    tffa__DueDiligence__c idaDD = getDueDiligence(diligences, party.Id, tffa.DueDiligenceType.IDA);
    tffa.AlloyDTO.EvaluationRequest request = new tffa.AlloyDTO.EvaluationRequest();

    if (idaDD != null && idaDD.tffa__Status__c == tffa.DueDiligenceService.STATUS_IN_PROGRESS) {
      helper.populateAnswers(request, idaDD);
    } else {
      populatePersonDetails(request, party, facts);
      if (sub != null) {
        populateSubmissionDetails(request, sub, facts);
      }
    }
    try {
      tffa.AlloyService service;
      if (sub.tffa__Channel__c == FISCCIntegrationConstants.BRANCH) {
        service = new tffa.AlloyService('Alloy_Branch_Person');
      } else {
        service = new tffa.AlloyService('Alloy_Person');
      }

      //Log request
      FISCCIntegrationLogService.setLogItemRequestAndResponse(String.valueOf(request), null);

      tffa.AlloyDTO.EvaluationResponse response;
      if (request.evaluation_token == null) {
        response = service.createEvaluation(request);
        addWebhook(service, party);
      } else {
        response = service.patchEvaluation(request);
      }

      // Log Response
      FISCCIntegrationLogService.setLogItemRequestAndResponse(null, String.valueOf(response));

      if (helper.hasRequiredError(response)) {
        tffa__DueDiligence__c dd = new tffa__DueDiligence__c(
          Name = 'Alloy IDV',
          tffa__Type__c = tffa.DueDiligenceType.IDV.name(),
          tffa__Party__c = party.Id
        );
        helper.populateRequiredErrorDetails(dd, response);
        tffa.DueDiligenceService.rollupDetails(party, dd);
        diligences.add(dd);
        FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.DO_IDV_VERIFICATION);
        FISCCIntegrationLogService.setLogItemMessage(FISCCIntegrationConstants.DO_IDV_VERIFICATION_FAILURE);
      } else {
        parseIDAResponse(response, party, diligences);
        if (response.summary != null) {
          if (!response.summary.result.equalsIgnoreCase('Success')) {
            party.CZIsRetryRequired__c = true;
          }
          parseIDVResponse(response, party, diligences, reports);
          parseOFACResponse(response, party, diligences);
          parseFraudResponse(response, party, diligences);
          parseDebitBureauResponse(response, party, diligences);
          parseDebitBureauReport(response, party, diligences, reports);
          parseDeviceResponse(response, party, diligences);
          helper.populateKYCDetails(party, response);
          if (response.summary.outcome == 'In Branch Manual Review') {
            party.tffa__KYCDecisionOutcome__c = 'REVIEW';
            party.tffa__AutoKYCDecisionOutcome__c = 'REVIEW';
          }
        }
        FISCCIntegrationLogService.setLogItemOk(
          FISCCIntegrationConstants.DO_IDV_VERIFICATION,
          FISCCIntegrationConstants.DO_IDV_VERIFICATION_SUCCESS
        );
      }
    } catch (tffa.AlloyService.AlloyException ex) {
      handleError(ex, party, diligences);
    }
  }
  /*
  public void setAdverseActionFlag(tffa.AlloyDTO.EvaluationResponse response, tffa__Party__c party) {
    if (
      response.summary.tags.contains('Denied Fraud') ||
      response.summary.tags.contains('Closure Total Amount') ||
      response.summary.tags.contains('Closure Total Dollar Amount')
    ) {
      party.tffa__AdverseActionNoticeRequired__c = true;
    }
  }
*/
  public void verifyOrganization(
    tffa__Party__c party,
    tffa__DueDiligence__c[] diligences,
    tffa.DocumentMetadataDTO[] reports,
    Map<String, Object> facts
  ) {
    tffa__Submission__c sub = (tffa__Submission__c) facts.get('Submission__r');
    tffa.AlloyDTO.EvaluationRequest request = new tffa.AlloyDTO.EvaluationRequest();
    populateBusinessDetails(request, party, facts);

    if (sub != null) {
      populateSubmissionDetails(request, sub, facts);

      // collect other (individual) parties in the submission
      Set<Id> otherPartyIds = new Set<Id>();
      for (tffa__SubmissionPartyXref__c spx : sub.tffa__PartyXrefs__r) {
        if (
          spx.tffa__Type__c == 'INDIVIDUAL' &&
          (spx.tffa__IsPresent__c || spx.tffa__SubmissionStatus__c == tffa.SubmissionStatus.SUBMITTED.name())
        ) {
          otherPartyIds.add(spx.tffa__Party__c);
        }
      }

      List<tffa__PartyPartyXref__c> ppXrefs = tffa.PartyPartyXrefService.readAll(
        new tffa.QueryContext(new Map<String, Object>{ 'Party__c' => party.Id, 'RelatedParty__c' => otherPartyIds })
      );
      populateRepresentatives(request, party, ppXrefs, facts);
    }
    try {
      //Log request
      FISCCIntegrationLogService.setLogItemRequestAndResponse(String.valueOf(request), null);

      tffa.AlloyService service = new tffa.AlloyService('Alloy_Business');
      tffa.AlloyDTO.EvaluationResponse response = service.createEvaluation(request);
      addWebhook(service, party);

      //Log Response
      FISCCIntegrationLogService.setLogItemRequestAndResponse(null, String.valueOf(response));
      if (helper.hasRequiredError(response)) {
        tffa__DueDiligence__c dd = new tffa__DueDiligence__c(
          Name = 'Alloy IDV',
          tffa__Type__c = tffa.DueDiligenceType.IDV.name(),
          tffa__Party__c = party.Id
        );
        helper.populateRequiredErrorDetails(dd, response);
        tffa.DueDiligenceService.rollupDetails(party, dd);
        diligences.add(dd);
      } else if (response.summary != null) {
        if (!response.summary.result.equalsIgnoreCase('Success')) {
          party.CZIsRetryRequired__c = true;
        }
        parseIDVResponse(response, party, diligences, reports);
        parseOFACResponse(response, party, diligences);
        parseFraudResponse(response, party, diligences);
        parseDebitBureauResponse(response, party, diligences);
        helper.populateKYCDetails(party, response);
      } else {
        // asynchronous evaluation case, e.g. webhook_pending
        tffa__DueDiligence__c dd = new tffa__DueDiligence__c(
          Name = 'Alloy IDV',
          tffa__Type__c = tffa.DueDiligenceType.IDV.name(),
          tffa__Party__c = party.Id
        );
        helper.populateEvaluationDetails(dd, response, true);
        tffa.DueDiligenceService.rollupDetails(party, dd);
        diligences.add(dd);
      }
    } catch (tffa.AlloyService.AlloyException ex) {
      handleError(ex, party, diligences);
    }
  }

  public void parseIDVResponse(
    tffa.AlloyDTO.EvaluationResponse response,
    tffa__Party__c party,
    tffa__DueDiligence__c[] diligences,
    tffa.DocumentMetadataDTO[] reports
  ) {
    tffa__DueDiligence__c dd = getDueDiligence(diligences, party.Id, tffa.DueDiligenceType.IDV);
    dd = dd == null
      ? new tffa__DueDiligence__c(Name = 'Alloy IDV', tffa__Type__c = tffa.DueDiligenceType.IDV.name(), tffa__Party__c = party.Id)
      : dd;
    helper.populateEvaluationDetails(dd, response, true);
    if (response.summary.outcome == 'In Branch Manual Review') {
      dd.tffa__Status__c = 'REVIEW';
      dd.tffa__Tags__c = ('Banker Review; ' + dd.tffa__Tags__c).left(255);
    }
    List<tffa__DueDiligenceItem__c> items = new List<tffa__DueDiligenceItem__c>();
    if (response.matching != null) {
      helper.parseMatchResults(response, items);
    }
    if (party.tffa__Type__c == 'INDIVIDUAL') {
      tffa.AlloyDTO.FormattedResponse formattedResponse = response.getFormattedResponse(tffa.AlloyServiceHelper.LEXIS_NEXIS_INSTANT_ID);
      if (formattedResponse != null) {
        if (formattedResponse.data.risk_codes != null) {
          helper.parseReasonCodes(
            formattedResponse.data.risk_codes,
            items,
            tffa.AlloyServiceHelper.LT_LEXIS_NEXIS_INSTANT_ID_REASON_CODES,
            tffa.AlloyServiceHelper.LEXIS_NEXIS_INSTANT_ID
          );
        }
        if (formattedResponse.data.followup_codes != null) {
          helper.parseReasonCodes(
            formattedResponse.data.followup_codes,
            items,
            tffa.AlloyServiceHelper.LT_LEXIS_NEXIS_INSTANT_ID_REASON_CODES,
            tffa.AlloyServiceHelper.LEXIS_NEXIS_INSTANT_ID
          );
        }
      }
      formattedResponse = response.getFormattedResponse(tffa.AlloyServiceHelper.ID_ANALYTICS_ID_SCORE);
      if (formattedResponse != null && formattedResponse.data.reason_codes != null) {
        helper.parseReasonCodes(
          formattedResponse.data.reason_codes,
          items,
          tffa.AlloyServiceHelper.LT_ID_ANALYTICS_ID_SCORE_REASON_CODES,
          tffa.AlloyServiceHelper.ID_ANALYTICS_ID_SCORE
        );
      }
      formattedResponse = response.getFormattedResponse(tffa.AlloyServiceHelper.SOCURE_30);
      if (formattedResponse != null && formattedResponse.data.get('reasonCodes') != null) {
        helper.parseReasonCodes(
          (List<Object>) formattedResponse.data.get('reasonCodes'),
          items,
          tffa.AlloyServiceHelper.LT_SOCURE_30_REASON_CODES,
          tffa.AlloyServiceHelper.SOCURE_30
        );
      }
    } else {
      tffa.AlloyDTO.FormattedResponse formattedResponse = response.getFormattedResponse(tffa.AlloyServiceHelper.MIDDESK);
      if (formattedResponse != null) {
        tffa.AlloyDTO.SourceData sdata = formattedResponse.data;
        helper.parseValue(sdata, 'search_status', items, 'searchStatus', 'Search Status');
        helper.parseValue(sdata, 'business_address_type', items, 'addressType', 'Business Address Type');
        helper.parseValue(sdata, 'top_industry_category', items, 'topIndustryCategory', 'Top Industry Category');
      }
    }
    dd = (tffa__DueDiligence__c) tffa.SObjectAssembler.set(dd, 'Items__r', items);
    tffa.DueDiligenceService.rollupDetails(party, dd);
    party.tffa__KYCReportUrl__c = Page.tffa__kycReport.getUrl();
    if (dd.Id == null) {
      diligences.add(dd);
    } else {
      // do in place replace, as object reference as changed
      for (Integer i = 0; i < diligences.size(); i++) {
        if (diligences[i].Id == dd.Id) {
          diligences[i] = dd;
          break;
        }
      }
    }
    reports.add(helper.createResponseDocument(response, party, dd));
  }

  public void parseOFACResponse(tffa.AlloyDTO.EvaluationResponse response, tffa__Party__c party, tffa__DueDiligence__c[] diligences) {
    if (response.diligence?.watchlists == null) {
      return;
    }
    tffa__DueDiligence__c dd = new tffa__DueDiligence__c(
      Name = 'Alloy OFAC',
      tffa__Type__c = tffa.DueDiligenceType.OFAC.name(),
      tffa__Party__c = party.Id
    );
    dd = helper.populateOFACDetails(dd, response);
    tffa.DueDiligenceService.rollupDetails(party, dd);
    diligences.add(dd);
  }

  public void parseFraudResponse(tffa.AlloyDTO.EvaluationResponse response, tffa__Party__c party, tffa__DueDiligence__c[] diligences) {
    if (response.diligence?.fraud == null) {
      return;
    }
    tffa__DueDiligence__c dd = new tffa__DueDiligence__c(
      Name = 'Alloy Fraud',
      tffa__Type__c = tffa.DueDiligenceType.FRAUD.name(),
      tffa__Party__c = party.Id
    );
    dd = helper.populateFraudDetails(dd, response);
    tffa.DueDiligenceService.rollupDetails(party, dd);
    diligences.add(dd);
  }

  public void parseDebitBureauResponse(
    tffa.AlloyDTO.EvaluationResponse response,
    tffa__Party__c party,
    List<tffa__DueDiligence__c> diligences
  ) {
    if (response.summary.hasRun(tffa.AlloyServiceHelper.QUALIFILE)) {
      tffa__DueDiligence__c dd = new tffa__DueDiligence__c(
        Name = 'ChexSys QualiFile',
        tffa__Type__c = tffa.DueDiligenceType.DEBIT_BUREAU.name(),
        tffa__Party__c = party.Id
      );
      dd = helper.populateQualiFileDetails(dd, response);
      tffa.DueDiligenceService.rollupDetails(party, dd);
      diligences.add(dd);
    } else if (response.summary.hasRun(tffa.AlloyServiceHelper.BIZCHEX)) {
      tffa__DueDiligence__c dd = new tffa__DueDiligence__c(
        Name = 'FIS BizChex',
        tffa__Type__c = tffa.DueDiligenceType.DEBIT_BUREAU.name(),
        tffa__Party__c = party.Id
      );
      dd = helper.populateBizChexDetails(dd, response);
      tffa.DueDiligenceService.rollupDetails(party, dd);
      diligences.add(dd);
    }
  }

  public void parseIDAResponse(tffa.AlloyDTO.EvaluationResponse response, tffa__Party__c party, List<tffa__DueDiligence__c> diligences) {
    if (response.prompts?.answers != null) {
      tffa__DueDiligence__c dd = new tffa__DueDiligence__c(
        Name = 'Alloy KBA',
        tffa__Type__c = tffa.DueDiligenceType.IDA.name(),
        tffa__Party__c = party.Id
      );
      dd = helper.populateQuestionDetails(dd, response);
      tffa.DueDiligenceService.rollupDetails(party, dd);
      diligences.add(dd);
    } else if (response.diligence?.identity_questions != null) {
      tffa__DueDiligence__c dd = getDueDiligence(diligences, party.Id, tffa.DueDiligenceType.IDA);
      if (dd != null) {
        dd = helper.populateIDADetails(dd, response);
        tffa.DueDiligenceService.rollupDetails(party, dd);
      }
    } else if (party.tffa__IDAStatus__c != null) {
      party.tffa__IDAStatus__c = tffa.DueDiligenceService.STATUS_EXPIRED;
    }
  }

  public void parseDebitBureauReport(
    tffa.AlloyDTO.EvaluationResponse response,
    tffa__Party__c party,
    List<tffa__DueDiligence__c> diligences,
    tffa.DocumentMetadataDTO[] reports
  ) {
    tffa.AlloyDTO.RawResponse rawResponse = response.getRawResponse(tffa.AlloyServiceHelper.QUALIFILE);
    if (rawResponse != null) {
      String txtReport = rawResponse.getString('callChexSystemsServiceV001Return.txtReport');
      tffa__DueDiligence__c dd = getDueDiligence(diligences, party.Id, tffa.DueDiligenceType.DEBIT_BUREAU);
      if (dd != null && txtReport != null) {
        String reportName = 'chexsystems_report.html';
        tffa.DocumentMetadataDTO report = new tffa.DocumentMetadataDTO(
          party.Name.left(40).toLowerCase().replaceAll('\\s+', '_') +
          '_' +
          reportName,
          Blob.valueOf(txtReport),
          party.Id,
          'IDENTITY'
        );
        report.participants.add(new tffa.DocumentParticipantDTO(dd));
        dd.tffa__ReportName__c = 'Chexsystems Report';
        dd.tffa__ReportUrl__c = Page.tffa__dueDiligenceReport.getUrl();
        reports.add(report);
      }
    }
  }

  public tffa__DueDiligence__c getDueDiligence(List<tffa__DueDiligence__c> diligences, String partyId, tffa.DueDiligenceType type) {
    for (tffa__DueDiligence__c dd : diligences) {
      if (dd.tffa__Party__c == partyId && dd.tffa__Type__c == type.name()) {
        return dd;
      }
    }
    return null;
  }

  public void parseDeviceResponse(tffa.AlloyDTO.EvaluationResponse response, tffa__Party__c party, tffa__DueDiligence__c[] diligences) {
    if (response.summary.hasRun(tffa.AlloyServiceHelper.IOVATION) && response.supplied.iovation_blackbox != null) {
      tffa__DueDiligence__c dd = new tffa__DueDiligence__c(
        Name = 'Alloy Device',
        tffa__Type__c = tffa.DueDiligenceType.DEVICE.name(),
        tffa__Party__c = party.Id
      );
      dd = helper.populateIovationDetails(dd, response);
      tffa.DueDiligenceService.rollupDetails(party, dd);
      diligences.add(dd);
    }
  }

  public void addWebhook(tffa.AlloyService service, tffa__Party__c party) {
    try {
      tffa.AlloyDTO.Entity entity = new tffa.AlloyDTO.Entity();
      entity.entity_token = party.Id;
      entity.meta.webhook_url = tffa.WebhookRESTService.getWebhookUrl('alloy');
      service.patchEntity(entity);
    } catch (Exception ex) {
      tffa.Logger.error(ex);
    }
  }

  public void handleError(tffa.AlloyService.AlloyException ex, tffa__Party__c party, tffa__DueDiligence__c[] diligences) {
    tffa.AlloyDTO.ErrorResponse response = ex.getResponse();
    tffa__DueDiligence__c idaDD = getDueDiligence(diligences, party.Id, tffa.DueDiligenceType.IDA);
    if (idaDD?.tffa__Status__c == tffa.DueDiligenceService.STATUS_IN_PROGRESS) {
      helper.populateErrorDetails(idaDD, response);
      tffa.DueDiligenceService.rollupDetails(party, idaDD);
    }
    tffa__DueDiligence__c dd = new tffa__DueDiligence__c(
      Name = 'Alloy IDV',
      tffa__Type__c = tffa.DueDiligenceType.IDV.name(),
      tffa__Party__c = party.Id
    );
    helper.populateErrorDetails(dd, response);
    tffa.DueDiligenceService.rollupDetails(party, dd);
    diligences.add(dd);
  }
}