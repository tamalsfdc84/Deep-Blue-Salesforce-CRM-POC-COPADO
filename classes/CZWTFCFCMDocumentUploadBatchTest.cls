@isTest
public with sharing class CZWTFCFCMDocumentUploadBatchTest {
  @isTest
  static void testMethod1() {
    tffa__Submission__c sub = new tffa__Submission__c(
      tffa__Status__c = 'SUBMITTED',
      tffa__State__c = 'ReviewSubmit',
      DisclosureConverted__c = true
    );
    insert sub;
    tffa__Product__c product = CZWTFCTestDataRepository.createCheckingProduct();

    tffa__Address__c addr = new tffa__Address__c();
    addr.tffa__Line1__c = '2311 Main Street';
    addr.tffa__Line2__c = '';
    addr.tffa__State__c = 'GA';
    addr.tffa__City__c = 'Columbus';
    addr.tffa__ZipCode__c = '31901345';
    insert addr;

    tffa__Party__c party = CZWTFCTestDataRepository.createIndividualParty();

    tffa.SObjectAssembler asmParty = new tffa.SObjectAssembler(party);
    asmParty.addChildObjects('tffa__AddressXrefs__r', CZWTFCTestDataRepository.createPartyAddressXrefs());

    asmParty.addChildObject('tffa__Employments__r', CZWTFCTestDataRepository.createEmployment());
    asmParty.addChildObject('tffa__Identifications__r', CZWTFCTestDataRepository.createIdentification());
    party = (tffa__Party__c) asmParty.assemble();
    insert party;

    List<tffa__Party__c> partyList = new List<tffa__Party__c>();
    partyList.add(party);

    tffa__Identification__c identification = new tffa__Identification__c();
    identification.tffa__IssuingState__c = 'CA';
    identification.tffa__IdentificationNumber__c = 'Y3676237';
    identification.tffa__ExpirationDate__c = Date.newInstance(2038, 10, 12);
    identification.tffa__IssueDate__c = Date.newInstance(2014, 4, 12);
    identification.tffa__Party__c = party.id;
    identification.tffa__Type__c = 'DL';
    insert identification;

    tffa__PartyAddressXref__c partyAddrXref = new tffa__PartyAddressXref__c();
    partyAddrXref.tffa__Party__c = party.id;
    partyAddrXref.tffa__Type__c = 'Home';
    partyAddrXref.tffa__Address__c = addr.id;
    insert partyAddrXref;

    tffa__SubmissionPartyXref__c subPartyXref = new tffa__SubmissionPartyXref__c(
      tffa__Party__c = party.id,
      tffa__Submission__c = sub.id,
      tffa__Type__c = 'INDIVIDUAL',
      tffa__Primary__c = true
    );
    insert subPartyXref;

    tffa__FundingRequest__c fundingReq = new tffa__FundingRequest__c(tffa__Submission__c = sub.id, tffa__Amount__c = 100.0);
    insert fundingReq;

    tffa__Application__c app = new tffa__Application__c(
      tffa__Submission__c = sub.id,
      tffa__AccountNumber__c = '4601050395',
      tffa__Amount__c = 100.0,
      tffa__Product__c = product.id,
      FCMUploadRetryCount__c = 0,
      tffa__Status__c = 'FUNDED'
    );
    insert app;

    tffa.DocumentMetadataDTO disclosurePdf = new tffa.DocumentMetadataDTO('test' + '.pdf', Blob.valueOf('test'), sub.id, 'OTHER');
    tffa.ContentService.createContentWithParticipant(disclosurePdf);

    CZWTFCFCMDocumentUploadBatch bc = new CZWTFCFCMDocumentUploadBatch();
    database.executeBatch(bc);

    FCMGenerateDocumentIdExtension.fetchDate();
    FCMGenerateDocumentIdExtension.fetchFileType('jpg');
    FCMGenerateDocumentIdExtension.fetchFileType('tiff');
    FCMGenerateDocumentIdExtension.fetchFileType('pdf');

    FCMGenerateDocumentIdExtension.getFCMAccountType(product, '118');

    FCMGenerateDocumentIdRequest obj = new FCMGenerateDocumentIdRequest();
    FCMGenerateDocIdResponse obj1 = new FCMGenerateDocIdResponse();

    CZWTFCMXSSOAPIHelper.checkForInstance('test');

    FISCCIntegrationLogService.fcmDocumentId = '1234';

    FISCC_Charter_Config__mdt charterConfig = FISCCIntegrationLogRepository.findCharterConfigByBrandCode('118');

    FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig('GenerateDocumentId');

    FCMDocumentProvider.generateFCMDocumentId(app, new CZFCMContentVersionDTO(), party, charterConfig);

    FCMDocumentProvider.uploadFCMDocuments(charterConfig);

    FCMGetEntityAuthorizationTokenExtension.getAuthorizationToken(adapterConfig, charterConfig);

    FCMGenerateDocIdResponseBuilder obj2 = new FCMGenerateDocIdResponseBuilder();
    obj2.build('test', adapterConfig, charterConfig);
    obj2.parseResponse(null, adapterConfig, charterConfig);

    CZFCMContentVersionDTO contentVersionDTO = new CZFCMContentVersionDTO();

    FCMHelperRepository.getContentVersionById('id');
  }
}