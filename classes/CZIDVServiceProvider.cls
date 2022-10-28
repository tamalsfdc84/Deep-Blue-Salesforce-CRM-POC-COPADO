/**
 * Copyright (c) 2020 Terafina Inc
 * @group  Provider
 * @description Override the package default functionalities for due diligence
 **/

global with sharing class CZIDVServiceProvider extends tffa.DueDiligenceServiceProvider {
  private final tffa.AlloyServiceHelper helper = new tffa.AlloyServiceHelper();
  /**
   * @description
   * @param tffa__Party__c partyObj
   * @param Map<String Object> params
   * @return List<tffa__Party__c>
   **/
  private List<tffa__Application__c> apps;
  global override List<tffa__Party__c> verify(List<tffa__Party__c> parties, Map<String, Object> params) {
    tffa.Logger.debug('In CZIDVServiceProvider Verify');
    Boolean skipDSS = false;
    Boolean saveIDA = false;
    Boolean saveVerifyIDA = false;
    Boolean saveIDV = false;
    Boolean isStudent = false;
    Boolean doIDV = false;
    Boolean isStudProd = false;
    Boolean isAuthKycRequired = false;

    FISIDAResponseDTO idaResp;
    FISIDVResponseDTO idvResp;

    List<tffa__Party__c> partyList;
    //    List<tffa__Party__c> partyDetailList = new List<tffa__Party__c>();
    List<String> ids = new List<String>();
    tffa__DueDiligence__c dueDiligenceVerify;
    for (tffa__Party__c party : parties) {
      ids.add(party.Id);
    }
    parties = CZWTFCPartyRepository.findAllPartiesByIds(ids);
    String flowName = parties[0].Name + '-' + FISCCIntegrationConstants.CUSTOMER_API_INQUIRES;
    try {
      CZWTFCIntegrationLogService.setIntegrationLog((String) params.get('Submission__c'), flowName);
      tffa__Submission__c submissionObj = CZWTFCSubmissionRepository.findOne((String) params.get('Submission__c'));

      CZWTFCIntegrationLogService.setCurrentLog(flowName);
      //CZWTFCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.SEARCH_CUSTOMER, parties[0].name, true);
      if (!parties[0].IsAuthenticatedCustomer__c) {
        parties[0].tffa__IsExistingCustomer__c = false;
        parties[0].IsCrossCharterCustomer__c = false;
        parties[0].IsExceptionPlanRequired__c = true;
        parties[0].Customer_Number__c = '';
        parties[0].CZMDMPartyID__c = '';
        parties[0].IsOLBEnrolled__c = 'F';
        parties[0].FISDob__c = '';
        parties[0].FISLastName__c = '';
        parties[0] = searchCustomerInMDM(parties[0]);
      }
      /*FISCCCustomerSearchTaxnbrProvider.processSearchByTaxbr((String) params.get('Submission__c'), parties[0]);
        //CZWTFCIntegrationLogService.setLogOk(FISCCIntegrationConstants.SEARCH_CUSTOMER);

        if (parties[0].tffa__IsExistingCustomer__c) {
          CZWTFCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.SEARCH_CUSTOMER);
        } else {
          CZWTFCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.SEARCH_CUSTOMER);
        }*/

      for (tffa__Party__c party : parties) {
        if ((party.tffa__IsExistingCustomer__c || party.IsCrossCharterCustomer__c) && !party.IsAuthenticatedCustomer__c) {
          try {
            CZWTFCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.OLB_CHECK, parties[0].name, true);
            if (CZWTFCOLBEnrollmentCheckService.checkIfOLBIsEnrolled(party.CZMDMPartyID__c)) {
              party.IsOLBEnrolled__c = 'Y';
              CZWTFCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.OLB_CHECK);
            } else {
              party.IsOLBEnrolled__c = 'N';
              CZWTFCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.OLB_CHECK);
            }
          } catch (Exception ex) {
            tffa.Logger.error('In IDV Service Provider OLB ' + ex.getMessage() + ' ' + ex.getStackTraceString());
            party.IsOLBEnrolled__c = 'F';
            CZWTFCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.OLB_CHECK);
          }
        }
        // party.tffa__IDAStatus__c = 'PASSED';
      }

      //--------------------------------------Alloy------------------------------------------------------------//
      tffa.Logger.debug('Processing Alloy IDV');

      if (parties[0].IsAuthenticatedCustomer__c && submissionObj.tffa__Channel__c == FISCCIntegrationConstants.DIGITAL) {
        params.put('AUTHENTICATED_CUSTOMER', 'AUTHENTICATED_CUSTOMER');
      }

      CZWTFCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.DO_IDV_VERIFICATION, parties[0].name, true);
      params.put('Submission__r', submissionObj);

      CZAlloyIDVServiceProvider alloyIdvProvider = new CZAlloyIDVServiceProvider();
      parties = alloyIdvProvider.verifyUsingAlloy(parties, params);

      /*
      partyDetailList[0].tffa__IsExistingCustomer__c = parties[0].tffa__IsExistingCustomer__c;
      partyDetailList[0].Customer_Number__c = parties[0].Customer_Number__c;
      partyDetailList[0].IsOLBEnrolled__c = parties[0].IsOLBEnrolled__c;
      partyDetailList[0].FISDob__c = parties[0].FISDob__c;
      partyDetailList[0].FISLastName__c = parties[0].FISLastName__c;
      partyDetailList[0].IsCrossCharterCustomer__c = parties[0].IsCrossCharterCustomer__c;
      partyDetailList[0].IsExceptionPlanRequired__c = parties[0].IsExceptionPlanRequired__c;
      partyDetailList[0].CZMDMPartyID__c = parties[0].CZMDMPartyID__c;
      partyDetailList[0].CZFisHomeNbr__c = parties[0].CZFisHomeNbr__c;
      partyDetailList[0].CZFisWorkNbr__c = parties[0].CZFisWorkNbr__c;
      partyDetailList[0].CZFisCellNbr__c = parties[0].CZFisCellNbr__c;
      partyDetailList[0].CZFisEmail__c = parties[0].CZFisEmail__c;
      partyDetailList[0].CZFisCustCodes__c = parties[0].CZFisCustCodes__c;
      partyDetailList[0].CZFisHomeNbrEffDt__c = parties[0].CZFisHomeNbrEffDt__c;
      partyDetailList[0].CZFisWorkNbrEffDt__c = parties[0].CZFisWorkNbrEffDt__c;
      partyDetailList[0].CZFisCellNbrEffDt__c = parties[0].CZFisCellNbrEffDt__c;
      partyDetailList[0].CZFisEmailEffDt__c = parties[0].CZFisEmailEffDt__c;
*/
      tffa.Logger.debug('In CZIDVServiceProvider Verify CheckPoint Two');
    } catch (Exception ex) {
      tffa.Logger.error(' Exception In IDV Provider' + ex.getMessage() + ' ' + ex.getStackTraceString());

      CZWTFCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.DO_IDV_VERIFICATION);
      CZWTFCIntegrationLogService.setLogItemMessage(FISCCIntegrationConstants.DO_IDV_VERIFICATION_FAILURE);

      //partyDetailList = parties;
    } finally {
      CZWTFCIntegrationLogService.persistIntegationLogs();
    }

    CZWTFCPartyRepository.save(parties);
    // //fetch without dd

    return parties;
  }

  public static tffa__Party__c searchCustomerInMDM(tffa__Party__c partyObj) {
    tffa.Logger.debug('Search Cust in MDM');
    try {
      Map<String, String> params = new Map<String, String>();
      params.put('lstNme', partyObj.tffa__LastName__c);
      params.put('ssnNmb', partyObj.tffa__NationalIdentifierValue__c);
      params.put('brandCode', partyObj.tffa__BrandCode__c);
      params.put('authType', 'ind-3');
      params.put('method', 'CUSTOMER_SEARCH');
      CZWTFCAuthResponse authResp = CZWTFCAuthenticationService.verifyUser(params);
      tffa.Logger.debug('authResp ' + authResp);
      if (String.isNotBlank(authResp.status) && authResp.status.equalsIgnoreCase('success')) {
        if (String.isNotBlank(authResp.custInfo.CISNumber)) {
          partyObj.tffa__IsExistingCustomer__c = authResp.custInfo.IsExistingCustomer;
          partyObj.Customer_Number__c = authResp.custInfo.CISNumber;
        }
        partyObj.IsCrossCharterCustomer__c = authResp.custInfo.IsCrossCharterCustomer;
        partyObj.IsExceptionPlanRequired__c = authResp.custInfo.IsExceptionPlanRequired;
        partyObj.CZMDMPartyID__c = authResp.globalCustomerId;
        partyObj.FISDob__c = authResp.custInfo.DateOfBirth;
        partyObj.FISLastName__c = authResp.custInfo.LastName;
      }
    } catch (Exception ex) {
      tffa.Logger.error(' Exception In IDV Service Provider searchCustomerInMDM ' + ex.getMessage() + ' ' + ex.getStackTraceString());
    }
    return partyObj;
  }

  global override List<tffa__DueDiligence__c> refreshStatus(List<tffa__DueDiligence__c> diligences, Map<String, Object> facts) {
    Boolean isWebhook = facts.get('webhook') == true;
    if (isWebhook) {
      tffa__DueDiligence__c dd = diligences[0];
      diligences = tffa.DueDiligenceService.readAll(
        new tffa.QueryContext(
          new Map<String, Object>{
            'Party__c' => dd.tffa__Party__c,
            'SourcePartyId__c' => dd.tffa__SourcePartyId__c,
            'Status__c' => 'IN_PROGRESS'
          }
        )
      );
      if (diligences.isEmpty()) {
        tffa.Logger.error(
          'DueDiligence matching Party__c={0} SourcePartyId__c={1} Status__c={2} not found',
          new List<Object>{ dd.tffa__Party__c, dd.tffa__SourcePartyId__c, 'IN_PROGRESS' }
        );
        throw new tffa.ApplicationException('DueDiligence record not found');
      }
      dd = diligences[0];
      tffa__Party__c party = tffa.PartyService.read(dd.tffa__Party__c);
      String submissionId;
      List<tffa.DocumentMetadataDTO> reports = new List<tffa.DocumentMetadataDTO>();
      CZAlloyIDVServiceProvider alloyIdvProvider = new CZAlloyIDVServiceProvider();
      try {
        tffa.AlloyDTO.EvaluationResponse response = (tffa.AlloyDTO.EvaluationResponse) facts.get('evaluation');
        submissionId = response.external_group_id;
        if (helper.hasRequiredError(response)) {
          helper.populateRequiredErrorDetails(dd, response);
          tffa.DueDiligenceService.rollupDetails(party, dd);
        } else {
          // we are not expecting any reports here
          alloyIdvProvider.parseIDVResponse(response, party, diligences, reports);
          alloyIdvProvider.parseOFACResponse(response, party, diligences);
          alloyIdvProvider.parseFraudResponse(response, party, diligences);
          alloyIdvProvider.parseDebitBureauResponse(response, party, diligences);
          helper.populateKYCDetails(party, response);
        }
      } catch (tffa.AlloyService.AlloyException ex) {
        alloyIdvProvider.handleError(ex, party, diligences);
      }
      tffa.DueDiligenceService.createOrUpdate(diligences, new Map<String, Object>());
      tffa.PartyService.modify(party);

      if (!reports.isEmpty()) {
        for (tffa.DocumentMetadataDTO report : reports) {
          // also link submission if available
          if (submissionId != null) {
            report.participants.add(new tffa.DocumentParticipantDTO(null, submissionId));
          }
        }
        tffa.ContentService.createOrUpdate(reports);
      }
    }
    return diligences;
  }

  global override List<tffa__DueDiligence__c> updateStatus(List<tffa__DueDiligence__c> diligences, Map<String, Object> facts) {
    Boolean isWebhook = facts.get('webhook') == true;
    if (isWebhook) {
      tffa.AlloyDTO.EntityReview review = (tffa.AlloyDTO.EntityReview) facts.get('review');
      tffa__DueDiligence__c idvDD = diligences[0];
      diligences = tffa.DueDiligenceService.readAll(
        new tffa.QueryContext(
          new Map<String, Object>{
            'Party__c' => idvDD.tffa__Party__c,
            'SourcePartyId__c' => idvDD.tffa__SourcePartyId__c,
            'Status__c' => 'REVIEW'
          }
        )
      );
      if (diligences.isEmpty()) {
        tffa.Logger.error(
          'DueDiligence matching Party__c={0} SourcePartyId__c={1} Status__c={2} not found',
          new List<Object>{ idvDD.tffa__Party__c, idvDD.tffa__SourcePartyId__c, 'REVIEW' }
        );
        throw new tffa.ApplicationException('DueDiligence record not found');
      }
      /*
      List<tffa__AgentDetail__c> agents = tffa.AgentDetailService.readAll(
        new tffa.QueryContext(
          new Map<String, Object>{
            'UserEmail__c' => review.agent.email,
            'Skills__c' => tffa.AlloyServiceHelper.SKILL_EXTERNAL_KYC_REVIEWER
          }
        )
      );
      if (agents.isEmpty()) {
        tffa.Logger.error(
          'AgentDetail matching UserEmail__c={0} Skills__c={1} Status__c={2} not found',
          new List<Object>{ review.agent.email, tffa.AlloyServiceHelper.SKILL_EXTERNAL_KYC_REVIEWER }
        );
        throw new tffa.ApplicationException('Agent Details record not found');
      }
*/
      // if one of the related dds is overridden, skip update
      for (tffa__DueDiligence__c dd : diligences) {
        if (dd.tffa__Overridden__c) {
          tffa.Logger.error('Record {0} status already overridden, skipping update', new List<Object>{ dd.Id });
          throw new tffa.ApplicationException('Invalid');
        }
        dd.tffa__Status__c = idvDD.tffa__Status__c;
        dd.tffa__OverrideReason__c = idvDD.tffa__OverrideReason__c;
        dd.tffa__OverrideComments__c = idvDD.tffa__OverrideComments__c;
        dd.tffa__OverrideSource__c = idvDD.tffa__OverrideSource__c;
        dd.tffa__Overridden__c = true;
      }
    }
    Map<Id, tffa__DueDiligence__c> diligenceMap = new Map<Id, tffa__DueDiligence__c>();
    Set<Id> partyIds = new Set<Id>();
    for (
      tffa__DueDiligence__c dd : tffa.DueDiligenceService.readAll(
        new tffa.QueryContext(new Map<String, Object>{ 'Id' => tffa.CollectionUtils.getIds(diligences) })
      )
    ) {
      diligenceMap.put(dd.Id, dd);
      partyIds.add(dd.tffa__Party__c);
    }
    Map<Id, tffa__Party__c> partyMap = new Map<Id, tffa__Party__c>(
      tffa.PartyService.readAll(new tffa.QueryContext(new Map<String, Object>{ 'Id' => partyIds }))
    );
    List<tffa__DueDiligence__c> modifiedDDs = new List<tffa__DueDiligence__c>();
    for (tffa__DueDiligence__c dd : diligences) {
      tffa__DueDiligence__c originalDD = diligenceMap.get(dd.Id);
      if (originalDD == null) {
        throw new tffa.ApplicationException('DueDiligence record not found');
      }
      if (dd.tffa__Status__c != originalDD.tffa__Status__c) {
        dd = (tffa__DueDiligence__c) tffa.SObjectAssembler.combine(originalDD, dd);
        tffa__Party__c party = partyMap.get(dd.tffa__Party__c);
        // prevent circular update
        if (dd.tffa__Type__c == tffa.DueDiligenceType.IDV.name() && !isWebhook) {
          pushStatusUpdate(dd, party);
        }
        dd.tffa__Overridden__c = true;
        modifiedDDs.add(dd);
        tffa.DueDiligenceService.rollupDetails(party, dd);
      } else {
        modifiedDDs.add(originalDD);
      }
    }
    if (!modifiedDDs.isEmpty()) {
      modifiedDDs = tffa.DueDiligenceService.createOrUpdate(modifiedDDs, new Map<String, Object>());
      List<tffa__Party__c> modifiedParties = partyMap.values();
      for (tffa__Party__c party : modifiedParties) {
        tffa.PartyService.modify(party);
      }
    }
    return modifiedDDs;
  }

  public void pushStatusUpdate(tffa__DueDiligence__c dd, tffa__Party__c party) {
    try {
      tffa__AgentDetail__c agent = tffa.AgentDetailService.getCurrentAgentDetail();
      if (
        agent.tffa__Skills__c?.contains(tffa.AlloyServiceHelper.SKILL_EXTERNAL_KYC_REVIEWER) == true &&
        agent.tffa__UserEmail__c != null
      ) {
        tffa.AlloyService service = new tffa.AlloyService(party.tffa__Type__c == 'INDIVIDUAL' ? 'Alloy_Person' : 'Alloy_Business');
        tffa.AlloyDTO.EntityReview review = new tffa.AlloyDTO.EntityReview();
        review.entity_token = dd.tffa__Party__c;
        review.outcome = (String) tffa.CollectionUtils.findKey(tffa.AlloyServiceHelper.OUTCOME_STATUS_MAP, dd.tffa__Status__c);
        review.addReason(
          tffa.LookupTableService.getLookupValue(tffa.AlloyServiceHelper.LT_ALLOY_REVIEW_REASONS, dd.tffa__OverrideReason__c)
        );
        review.agent = new tffa.AlloyDTO.AgentDetail(agent.tffa__UserEmail__c, null);
        review = service.createEntityReview(review);
        if (!String.isBlank(dd.tffa__OverrideComments__c)) {
          tffa.AlloyDTO.Note note = new tffa.AlloyDTO.Note(dd.tffa__OverrideComments__c, agent.tffa__UserEmail__c);
          note.review_token = review.review_token;
          note.entity_token = review.entity_token;
          note = service.createEntityReviewNote(note);
        }
      }
    } catch (Exception ex) {
      tffa.Logger.error(ex);
    }
  }
}