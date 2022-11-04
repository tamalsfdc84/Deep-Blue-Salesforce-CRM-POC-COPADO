global with sharing class CZUpdatePartyInfoBatch extends tffa.AbstractBatchJob implements Database.Batchable<sObject>, Database.AllowsCallouts {
  global List<tffa__Party__c> start(Database.BatchableContext bc) {
    List<tffa__Party__c> parties = CZWTFCPartyRepository.fetchPartyForUpdate();
    return parties;
  }

  global void execute(Database.BatchableContext batchableContext, List<SObject> subObjectList) {
    tffa.Interaction.begin(CZUpdatePartyInfoBatch.class, 'execute');
    List<tffa__Party__c> parties = (List<tffa__Party__c>) subObjectList;
    try {
      for (tffa__Party__c partyObj : parties) {
        tffa.Logger.debug('partyObj in  update party batch ' + partyObj.Id);
        tffa__SubmissionPartyXref__c subPartyObj = CZWTFCPartyRepository.findSubPartyById(partyObj.Id);
        FISCCIntegrationLogService.setSubmissionObj(String.valueOf(subPartyObj.tffa__Submission__c));
        if (
          FISCCIntegrationLogService.submissionObj.tffa__SubmittedChannel__c == CZWTFCConstants.BRANCH &&
          !FISCCIntegrationLogService.submissionObj.CZIsDebitCardProductSelected__c
        ) {
          FISCCIntegrationLogService.setIntegrationLog(subPartyObj.tffa__Submission__c, FISCCIntegrationConstants.CUSTOMER_INFORMATION);
          FISCCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.CUSTOMER_INFORMATION);
          boolean aliasUpdateSuccess = FISCCUpdateCustomerInfoExtension.updatePartyInfo(partyObj);
          if (partyObj.tffa__IsExistingCustomer__c && !partyObj.CZCustomerUpdated__c) {
            FISCCUpdateCustInfoProvider.isBatchSource = true;
            FISCCUpdateCustInfoProvider.updateBranchCustomerInformation(new List<tffa__Party__c>{ partyObj });
          }

          if (aliasUpdateSuccess && (partyObj.CZCustomerUpdated__c || partyObj.tffa__IsExistingCustomer__c)) {
            partyObj.CZBatchUpdateStatus__c = FISCCIntegrationConstants.PARTY_UPDATE_COMPLETED;
          }
          partyObj.CZBatchUpdateRetryCount__c++;
        } else {
          partyObj.CZBatchUpdateStatus__c = FISCCIntegrationConstants.PARTY_UPDATE_COMPLETED;
        }
      }
      parties = getupdatedPartyList(parties);
      WTFCObjectManagerRepository.doUpsertObjects(parties);
    } catch (Exception ex) {
      tffa.Logger.error('Exception in CZUpdatePartyInfoBatch.execute ' + ex.getStackTraceString());
    } finally {
      FISCCIntegrationLogService.persistIntegationLogs();
      tffa.Interaction.close();
      tffa.Logger.flush();
    }
  }

  global void finish(Database.BatchableContext batchableContext) {
    tffa.Logger.debug('In CZUpdatePartyInfoBatch.finish');
    tffa.Logger.flush();
  }

  public static List<tffa__Party__c> getupdatedPartyList(List<tffa__Party__c> parties) {
    List<tffa__Party__c> updatedParties = new List<tffa__Party__c>();
    for (tffa__Party__c party : parties) {
      tffa__Party__c p = new tffa__Party__c();
      p.Id = party.Id;
      p.CZCustomerUpdated__c = party.CZCustomerUpdated__c;
      p.CZBatchUpdateStatus__c = party.CZBatchUpdateStatus__c;
      p.CZBatchUpdateRetryCount__c = party.CZBatchUpdateRetryCount__c;
      updatedParties.add(p);
    }
    return updatedParties;
  }
}