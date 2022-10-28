global inherited sharing class CZMDMDataUploadBatch extends tffa.AbstractBatchJob implements Database.Batchable<sObject>, Database.AllowsCallouts {
  public static Set<String> subIdSet = new Set<String>();

  global Database.QueryLocator start(Database.BatchableContext batchableContext) {
    return Database.getQueryLocator(getQuery());
  }

  global void execute(Database.BatchableContext batchableContext, List<tffa__Submission__c> submissionList) {
    tffa.Interaction.begin(CZMDMDataUploadBatch.class, 'execute');
    try {
      tffa__Submission__c submission = submissionList[0];

      FISCCIntegrationLogService.setSubmissionObj(String.valueOf(submission.Id));
      FISCCIntegrationLogService.setPartyObjs();
      FISCCIntegrationLogService.setApplicationObjs();
      FISCCIntegrationLogService.setIntegrationLog(String.valueOf(submission.Id));
      FISCCIntegrationLogService.isBatchSource = true;

      CZMDMDataUploadExecutor.processRequest(submission);
    } catch (Exception ex) {
      tffa.Logger.error('CZMDMDataUploadBatch Exception msg : ' + ex.getMessage() + ' ' + ex.getStackTraceString());
    } finally {
      try {
        if (FISCCIntegrationLogService.partyObjs != null && FISCCIntegrationLogService.partyObjs.size() != 0) {
          FISCCObjectManagerRepository.doUpsertPartys(FISCCIntegrationLogService.partyObjs);
        }
        if (FISCCIntegrationLogService.applicationObjs != null && !FISCCIntegrationLogService.applicationObjs.isEmpty()) {
          FISCCObjectManagerRepository.doUpsertApplications(FISCCIntegrationLogService.applicationObjs);
        }
        FISCCIntegrationLogService.persistIntegationLogs();
        
      } finally {
        tffa.Interaction.close();
      }
    }
  }

  global void finish(Database.BatchableContext batchableContext) {
    tffa.Logger.debug('CZMDMDataUploadBatch finish()');
    tffa.Logger.flush();
  }

  private static String getQuery() {
    List<tffa__Application__c> applicationList = CZWTFCApplicationRepository.findApplicationByMDMStatus();

    for (tffa__Application__c app : applicationList) {
      if (app.tffa__Product__r.tffa__Category__c == 'CERTIFICATE' && String.isBlank(app.DPTDId__c)) {
        continue;
      }
      subIdSet.add(app.tffa__Submission__c);
    }

    // Fetch failed customer creation party
    List<tffa__Party__c> partyList = CZWTFCPartyRepository.fetchPartyByMDMUploadStatus('FAILURE');

    // Iterate through each party and get the submission Id
    for (tffa__Party__c party : partyList) {
      for (tffa__SubmissionPartyXref__c subParty : party.tffa__Submissions__r) {
        subIdSet.add(subParty.tffa__Submission__c);
      }
    }

    // Get the funding request with pending status
    String query = new tffa.QueryBuilder(tffa__Submission__c.SObjectType)
      .selectFields()
      .selectObject('tffa__BrandEntity__r')
      .selectFields()
      .build()
      .selectChildObject('tffa__Applications__r')
      .selectFields()
      .selectObject('tffa__Product__r')
      .selectFields()
      .build()
      .build()
      .selectChildObject('tffa__PartyXrefs__r')
      .selectFields()
      .selectObject('tffa__Party__r')
      .selectFields()
      .build()
      .build()
      .whereClause('Id', ' IN :subIdSet')
      .build()
      .toQuery();

    tffa.Logger.debug('CZMDMDataUploadBatch query => ' + query);

    return query;
  }
}