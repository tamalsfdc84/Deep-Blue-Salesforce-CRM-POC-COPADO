/**
 * Copyright (c) 2019 Terafina Inc
 * @description     Extension to main controller, for any custom service implementations
 * @group   Controller
 **/
global with sharing class CZWTFCDocusignController extends tffa.AbstractController implements tffa.IController {
  @TestVisible
  private static tffa.IController controller;

  global CZWTFCDocusignController(tffa.IController p) {
    controller = p;
  }

  @RemoteAction
  /**
   * @description generate DocuSign URL
   * @param String Submission Id
   * @return tffa.Response
   */
  global static tffa.Response generateDraft(tffa.Context ctx, Map<String, String> params) {
    tffa.Interaction.begin(ctx, CZWTFCDocusignController.class, 'generateDraft');
    try {
      if (!Test.isRunningTest()) {
        validateSession();
        validateRecordAccess(params);
      }
      Map<String, String> facts = params.clone();
      if (!facts.containsKey('disclosureSet')) {
        facts.put('disclosureSet', '1');
      }
      facts.put('action', 'Created');
      //FISCCIntegrationLogService.setSubmissionObj(params.get('SubmissionId'));
      CZWTFCIntegrationLogService.setIntegrationLog(params.get('SubmissionId'));
      CZWTFCIntegrationLogService.setCurrentLog(CZDocusignConstants.DOCUSIGN + '-' + facts.get('disclosureSet'));

      CZWTFCDocusingResult resp = CZWTFCDocuSignProvider.generateEnvelope(facts);

      return tffa.Response.ok(resp).build();
    } catch (Exception ex) {
      return tffa.Response.fail(ex).build();
    } finally {
      CZWTFCIntegrationLogService.persistIntegationLogs();
      tffa.Interaction.close();
    }
  }

  @RemoteAction
  /**
   * @description generate DocuSign URL
   * @param String Submission Id
   * @return tffa.Response
   */
  global static tffa.Response generateEnvelope(tffa.Context ctx, Map<String, String> params) {
    tffa.Interaction.begin(ctx, CZWTFCDocusignController.class, 'generateEnvelope');
    try {
      if (!Test.isRunningTest()) {
        validateSession();
        validateRecordAccess(params);
      }
      Map<String, String> facts = params.clone();
      if (!facts.containsKey('disclosureSet')) {
        facts.put('disclosureSet', '1');
      }
      facts.put('action', 'sent');
      //FISCCIntegrationLogService.setSubmissionObj(params.get('SubmissionId'));
      CZWTFCIntegrationLogService.setIntegrationLog(params.get('SubmissionId'));
      CZWTFCIntegrationLogService.setCurrentLog(CZDocusignConstants.DOCUSIGN + '-' + facts.get('disclosureSet'));
      CZWTFCDocusingResult resp = CZWTFCDocuSignProvider.generateEnvelope(facts);
      return tffa.Response.ok(resp).build();
    } catch (Exception ex) {
      return tffa.Response.fail(ex).build();
    } finally {
      CZWTFCIntegrationLogService.persistIntegationLogs();
      tffa.Interaction.close();
    }
  }

  @RemoteAction
  /**
   * @description generate DocuSign URL
   * @param String Submission Id
   * @return tffa.Response
   */
  global static tffa.Response getSigningUrl(tffa.Context ctx, Map<String, String> params) {
    tffa.Interaction.begin(ctx, CZWTFCDocusignController.class, 'getSigningUrl');
    try {
      if (!Test.isRunningTest()) {
        validateSession();
        validateRecordAccess(params);
      }
      //FISCCIntegrationLogService.setSubmissionObj(params.get('Submission__c'));
      CZWTFCIntegrationLogService.setIntegrationLog(params.get('Submission__c'));
      CZWTFCIntegrationLogService.setCurrentLog(CZDocusignConstants.DOCUSIGN);
      return tffa.Response.ok(CZWTFCDocusignAdapter.getSigningUrl(params)).build();
    } catch (Exception ex) {
      return tffa.Response.fail(ex).build();
    } finally {
      CZWTFCIntegrationLogService.persistIntegationLogs();
      tffa.Interaction.close();
    }
  }

  @RemoteAction
  /**
   * @description generate DocuSign URL
   * @param String Submission Id
   * @return tffa.Response
   */
  global static tffa.Response viewGeneratedEnvelope(tffa.Context ctx, Map<String, String> params) {
    tffa.Interaction.begin(ctx, CZWTFCDocusignController.class, 'viewGeneratedEnvelope');
    try {
      if (!Test.isRunningTest()) {
        validateSession();
        validateRecordAccess(params);
      }
      Map<String, String> facts = params.clone();
      CZWTFCIntegrationLogService.setIntegrationLog(params.get('SubmissionId'));
      CZWTFCIntegrationLogService.setCurrentLog(CZDocusignConstants.DOCUSIGN);
      CZWTFCDocusignRequestDTO request = new CZWTFCDocusignRequestDTO();
      CZWTFCDocusignAdapter docAdapter = new CZWTFCDocusignAdapter(request);
      return tffa.Response.ok(docAdapter.fetchDocusignUrl(facts)).build();
    } catch (Exception ex) {
      return tffa.Response.fail(ex).build();
    } finally {
      tffa.Interaction.close();
    }
  }
}