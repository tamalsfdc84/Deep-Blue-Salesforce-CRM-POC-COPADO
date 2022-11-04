global with sharing class CZDisclosureServiceProvider extends tffa.DisclosureServiceProvider {
  /**
   * Delivers the resolved disclosures to the applicant based on delivery mechanism specified in the request.
   * Based on the electronic signing provider type implemented, delegates the call to ElectronicSignatureProvider. <br>
   * @param entities list of disclosures
   * @param  facts
   * @example facts = { Submission__c : <GUID>}
   * @return `List<Disclosure__c>`
   */
  global override List<tffa__Disclosure__c> deliver(List<tffa__Disclosure__c> entities, Map<String, Object> facts) {
    tffa.Interaction.begin(CZDisclosureServiceProvider.class, 'fetch');
    try {
      return doDeliver(entities, facts);
    } finally {
      tffa.Interaction.close();
    }
  }

  /**
   * Delivers the resolved disclosures to the applicant based on delivery mechanism specified in the request.
   * Based on the electronic signing provider type implemented, delegates the call to ElectronicSignatureProvider. <br>
   *
   */
  @TestVisible
  private List<tffa__Disclosure__c> doDeliver(List<tffa__Disclosure__c> entities, Map<String, Object> facts) {
    tffa.Interaction.begin(CZDisclosureServiceProvider.class, 'doFetch');
    try {
      String eventName;
      String subId = (String) facts.get('Submission__c');
      //check if exists
      tffa__Submission__c original = CZWTFCSubmissionRepository.findSubmissionById(subId);
      tffa__Party__c party;
      String partyId = (String) facts.get('Party__c');
      if (partyId != null) {
        party = CZWTFCPartyRepository.fetchPartyById(partyId);
        eventName = 'DisclosureRemoteSigningInitiated';
      } else {
        party = fetchPrimaryParty(original);
        eventName = 'DisclosureDeliveryInitiated';
      }

      if (
        tffa.Context.get() != null &&
        String.isNotBlank(tffa.Context.get().eventName) &&
        tffa.Context.get().eventName == 'ESignConsentDisclosure'
      ) {
        eventName = 'DisclosureDeliveryInitiated';
      }

      //build url params
      Map<String, String> urlParams = new Map<String, String>();
      urlParams.put('Submission__c', subId);
      urlParams.put('OTPStatus__c', 'CHALLENGED');
      urlParams.put('EventName__c', eventName);
      urlParams.put('Party__c', party.Id);

      //encrypt
      String q;
      if (!Test.isRunningTest()) {
        q = tffa.Cipher.encrypt(JSON.serialize(urlParams));
      }

      //generate otp and urlparams
      tffa.OTPProvider provider = tffa.OTPProvider.getInstance();
      provider.generate(new Map<String, Object>{ 'Party__c' => party.Id, 'UrlFragment__c' => q, 'EventName__c' => eventName });

      //raise events
      tffa.EventExtension.getInstance('Party_OTP_Generated').post(party);
      tffa.EventExtension.getInstance('Party_' + eventName).post(party);

      return entities;
    } finally {
      tffa.Interaction.close();
    }
  }

  /**
   * Fetch primary individual party from the applicants
   * @param sub
   * @return `Party__c`
   */
  @TestVisible
  private tffa__Party__c fetchPrimaryParty(tffa__Submission__c sub) {
    tffa__Party__c primaryParty;
    for (tffa__SubmissionPartyXref__c xref : sub.tffa__PartyXrefs__r) {
      if (xref.tffa__Type__c == 'INDIVIDUAL' && (xref.tffa__Primary__c || xref.tffa__PrimaryContact__c)) {
        primaryParty = xref.tffa__Party__r;
      }
    }
    return primaryParty;
  }
}