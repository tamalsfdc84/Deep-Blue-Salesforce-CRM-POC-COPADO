global with sharing class CZDousignReminderBatch extends tffa.AbstractBatchJob implements Database.Batchable<sObject>, Database.AllowsCallouts {
  global List<tffa__DisclosureEnvelope__c> start(Database.BatchableContext bc) {
    List<tffa__DisclosureEnvelope__c> discEnvs = CZWTFCHelperRepository.findGeneratedDisclosureEnvs();
    //
    return discEnvs;
  }

  global void execute(Database.BatchableContext batchableContext, List<SObject> subObject) {
    tffa.Logger.debug('In CZDousignReminderBatch.execute');
    List<tffa__DisclosureEnvelope__c> envList = (List<tffa__DisclosureEnvelope__c>) subObject;
    tffa.Interaction.begin(CZDousignReminderBatch.class, 'execute');
    try {
      List<Id> envIdList = new List<Id>();
      for (tffa__DisclosureEnvelope__c env : envList) {
        envIdList.add(env.Id);
      }
      List<tffa__Disclosure__c> diclosuresLst = CZWTFCHelperRepository.findDiscsByEnvId(envIdList);
      for (tffa__Disclosure__c disc : diclosuresLst) {
        if (disc.CZDisclosureParticipantCount__c < 1 || !disc.tffa__ExecutionRequired__c) {
          disc.tffa__Status__c = 'COMPLETED';
        }
      }
      for (tffa__DisclosureEnvelope__c discEnv : envList) {
        boolean isPendingDisc = false;
        for (tffa__Disclosure__c disc : diclosuresLst) {
          if (disc.tffa__Status__c != 'COMPLETED') {
            isPendingDisc = true;
          }
        }
        if (isPendingDisc) {
          CZWTFCSignersStatusDTO signerStatusDTO;
          if (!Test.isRunningTest()) {
            signerStatusDTO = CZWTFCDocusignService.getSignersStatus(discEnv.tffa__Submission__c, discEnv.tffa__ExternalId__c);
          } else {
            CZWTFCSignersStatusDTO.SignersDTO signerStatus = new CZWTFCSignersStatusDTO.SignersDTO();
            signerStatusDTO = new CZWTFCSignersStatusDTO();
            signerStatusDTO.signers.add(signerStatus);
          }

          if (!isSigningCompleted(signerStatusDTO)) {
            Boolean isPending = CZDocusignReminderHelper.sendReminderMail(signerStatusDTO, discEnv);
            if (!isPending) {
              discEnv.tffa__Status__c = 'COMPLETED';
            }
          } else {
            for (tffa__Disclosure__c disc : diclosuresLst) {
              if (discEnv.tffa__ExternalId__c == disc.tffa__EnvelopeId__c) {
                disc.tffa__Status__c = 'COMPLETED';
              }
            }
            discEnv.tffa__Status__c = 'COMPLETED';
          }
        } else {
          discEnv.tffa__Status__c = 'COMPLETED';
        }
      }
      WTFCObjectManagerRepository.doUpsertObjects(envList);
      WTFCObjectManagerRepository.doUpsertObjects(diclosuresLst);
    } catch (Exception ex) {
      tffa.Logger.error('Exception in CZDousignReminderBatch ' + ex.getStackTraceString() + ' ' + ex.getLineNumber());
    } finally {
      tffa.Interaction.close();
    }
  }

  global void finish(Database.BatchableContext batchableContext) {
    tffa.Logger.debug('CZDousignReminderBatch finish()');
    tffa.Logger.flush();
  }

  public static boolean isSigningCompleted(CZWTFCSignersStatusDTO signerStatusDTO) {
    boolean isCompleted = true;
    for (CZWTFCSignersStatusDTO.SignersDTO signer : signerStatusDTO.signers) {
      if ((signer.status != null && !signer.status.equalsIgnoreCase('Completed'))) {
        isCompleted = false;
      }
    }
    return isCompleted;
  }
}