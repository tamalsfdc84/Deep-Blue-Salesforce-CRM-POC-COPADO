global inherited sharing class CZPartyServiceExt extends tffa.PartyServiceExt {
  /**
   * Called after persisting Party entities to data store. Does not include deleted entities.
   * @see PartyService.createOrUpdate
   * @param entities list of Party entities
   */
  global override List<tffa__Party__c> postCreateOrUpdate(List<tffa__Party__c> entities) {
    tffa.Interaction.begin(CZPartyServiceExt.class, 'postCreateOrUpdate');
    try {
      return CZWTFCPartyRepository.save(setName(entities));
    } catch (Exception ex) {
      tffa.Logger.debug('Error in CZPartyServiceExt.postCreateOrUpdate ' + ex.getStackTraceString());
    } finally {
      tffa.Interaction.close();
    }
    return entities;
  }

  /**
   * Set Party Name
   */
  public static List<tffa__Party__c> setName(List<tffa__Party__c> parties) {
    for (tffa__Party__c party : parties) {
      String partyName;
      if (party.tffa__Type__c == 'INDIVIDUAL') {
        List<String> names = new List<String>();

        if (String.isNotBlank(party.tffa__FirstName__c)) {
          names.add(party.tffa__FirstName__c);
        }

        if (String.isNotBlank(party.tffa__MiddleName__c)) {
          names.add(party.tffa__MiddleName__c);
        }

        if (String.isNotBlank(party.tffa__LastName__c)) {
          names.add(party.tffa__LastName__c);
        }

        if (String.isNotBlank(party.tffa__Suffix__c)) {
          names.add(party.tffa__Suffix__c);
        }

        partyName = String.join(names, ' ').trim();
        if (String.isNotBlank(partyName) && partyName.length() > 80) {
          partyName = partyName.substring(0, 80);
        }

        party.Name = partyName;
      }
    }
    return parties;
  }
}