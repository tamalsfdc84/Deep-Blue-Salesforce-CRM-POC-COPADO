global inherited sharing class CZWTFCDueDiligenceServiceExt extends tffa.DueDiligenceServiceExt {
  global override List<tffa__Party__c> postVerify(List<tffa__Party__c> parties, Map<String, Object> facts) {
    tffa.Interaction.begin(CZWTFCDueDiligenceServiceExt.class, 'postVerify');
    try {
      tffa.Logger.debug('Parties ' + parties.size());
      return parties;
    } finally {
      tffa.Interaction.close();
    }
  }

  global override List<tffa__DueDiligence__c> postUpdateStatus(List<tffa__DueDiligence__c> entities, Map<String, Object> facts) {
    tffa.Interaction.begin(CZWTFCDueDiligenceServiceExt.class, 'postUpdateStatus');

    try {
      Set<Id> partyIds = new Set<Id>();

      for (tffa__DueDiligence__c dd : entities) {
        partyIds.add(dd.tffa__Party__c);
      }

      List<Id> partyIdLst = new List<Id>(partyIds);
      List<tffa__Party__c> partyLst = FISCCIntegrationLogRepository.findPartydWithChildObjects(partyIdLst);
      tffa.PartyService.doDecision(
        partyLst,
        new Map<String, Object>{
          'Type__c' => 'KYC',
          'CZFraudStatus__c' => partyLst[0].tffa__FraudStatus__c,
          'CZOFACStatus__c' => partyLst[0].tffa__OFACStatus__c
        }
      );

      return entities;
    } finally {
      tffa.Interaction.close();
    }
  }
}