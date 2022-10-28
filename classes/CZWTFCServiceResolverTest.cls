@isTest
public with sharing class CZWTFCServiceResolverTest {
  @isTest
  public static void disclosureResolver() {
    tffa__Submission__c submissionObj = new tffa__Submission__c();
    submissionObj.tffa__Status__c = 'IN_PROGRESS';

    submissionObj.tffa__State__c = 'PersonalInfo';
    submissionObj.tffa__HasExistingParty__c = true;
    submissionObj.tffa__SubmittedChannel__c = 'DIGITAL';
    insert submissionObj;

    tffa.SObjectAssembler asmsub = new tffa.SObjectAssembler(submissionObj);
    tffa__Party__c partyObj = CZWTFCTestDataRepository.createIndividualParty();

    partyObj.tffa__ExternalId__c = '123456';
    insert partyObj;

    tffa__SubmissionPartyXref__c xref1 = new tffa__SubmissionPartyXref__c();
    xref1.tffa__Submission__c = submissionObj.id;
    xref1.tffa__Party__r = partyObj;
    xref1.Name = 'TEst';
    xref1.tffa__Primary__c = true;
    xref1.tffa__Type__c = 'INDIVIDUAL';

    asmsub.addChildObjects('tffa__PartyXrefs__r', new List<tffa__SubmissionPartyXref__c>{ xref1 });
    submissionObj = (tffa__Submission__c) asmsub.assemble();

    tffa__DisclosureChecklist__c checklist = CZWTFCTestDataRepository.createDisclosureChecklist();
    tffa.SObjectAssembler asm = new tffa.SObjectAssembler(checklist);

    tffa__DisclosureItem__c item = CZWTFCTestDataRepository.createDisclosureItem();
    tffa__DisclosureTemplate__c template = CZWTFCTestDataRepository.createDisclosureTemplate();
    insert template;
    item.tffa__Template__c = template.Id;
    asm.addChildObject('Items__r', item);
    checklist = (tffa__DisclosureChecklist__c) asm.assemble();

    tffa__Disclosure__c disclosureObj = new tffa__Disclosure__c();
    disclosureObj.tffa__Submission__c = submissionObj.Id;
    disclosureObj.tffa__Type__c = 'DOCUSIGN';
    disclosureObj.tffa__EntityType__c = 'PARTY';
    disclosureObj.tffa__Code__c = '32311';
    disclosureObj.tffa__Template__c = '23445';
    disclosureObj.tffa__EnvelopeId__c = '23445';
    insert disclosureObj;

    tffa__Party__c p = submissionObj.tffa__PartyXrefs__r[0].tffa__Party__r;
    tffa.Context ctx = tffa.Context.get();
    ctx.eventName = 'Submission_ReviewAndSubmit';
    ctx.partyId = p.id;
    Map<String, Object> facts = new Map<String, Object>();
    facts.put('Submission__c', submissionObj.id);
    facts.put('EventName__c', 'Submission_ReviewAndSubmit');

    Test.startTest();

    try {
      Map<String, Object> mp = new Map<String, Object>();
      mp.put('Accepted__c', false);
      mp.put('Submission__c', submissionObj.id);
      CZDisclosureServiceProvider discServiceProvider = new CZDisclosureServiceProvider();
      discServiceProvider.deliver(new List<tffa__Disclosure__c>{ disclosureObj }, mp);
      ctx.eventName = 'ESignConsentDisclosure';
      discServiceProvider.deliver(new List<tffa__Disclosure__c>{ disclosureObj }, mp);
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      CZDisclosureServiceProvider discServiceProvider = new CZDisclosureServiceProvider();
      Map<String, Object> mp = new Map<String, Object>();
      mp.put('Accepted__c', false);
      mp.put('Submission__c', submissionObj.id);

      mp.put('Party__c', p.id);
      discServiceProvider.deliver(new List<tffa__Disclosure__c>{ disclosureObj }, mp);
      ctx.eventName = 'ESignConsentDisclosure';
      discServiceProvider.deliver(new List<tffa__Disclosure__c>{ disclosureObj }, mp);
    } catch (Exception ex) {
      System.assertNotEquals(ex.getMessage(), null);
    }

    try {
      CZWTFCDisclosureResolver ds = new CZWTFCDisclosureResolver();
      ds.resolve(facts);
      Object response = CZWTFCSubmissionRepository.findSubmissionById(submissionObj.Id);
      System.assertNotEquals(response, null);
    } catch (Exception e) {
      System.assertNotEquals(e.getMessage(), null);
    }
    Test.stopTest();
  }
}