public with sharing class CZDocusignDocumentBuilder {
  public List<CZDocusignDocumentGenDTO> lstDocuments;
  public CZDocusignRepository docusignRepo;
  List<tffa__Disclosure__c> disclosures;
  Map<Id, List<tffa__Party__c>> discsignerMap;

  public CZDocusignDocumentBuilder(String submissionId, List<tffa__Disclosure__c> disclosures, String requestType) {
    tffa.Logger.debug('In CZDocumentBuilder');
    this.docusignRepo = new CZDocusignRepository(submissionId).fetchData();
    // this.lstDocuments = new List<CZDocusignDocumentGenDTO>();
    this.disclosures = disclosures;
  }
  public List<CZWTFCDocusignRequestDTO.CompositeTemplateDTO> getListOfDocuments() {
    List<CZWTFCDocusignRequestDTO.CompositeTemplateDTO> templateList = new List<CZWTFCDocusignRequestDTO.CompositeTemplateDTO>();
    //setParticipants(this.disclosures);
    //Set requestDTO properties
    Integer disclosureCount = 0;
    for (tffa__Disclosure__c disclosure : this.disclosures) {
      this.docusignRepo = this.docusignRepo.setDocumentUniqueId(disclosure.tffa__Code__c)
        .setCurrentDisclosure(disclosure)
        .getDocumentMasterConfig();

      CZWTFCDocusignDocumentEnricher requestEnricher = new CZWTFCDocusignDocumentEnricher();
      //this.docusignRepo = requestEnricher.getAllSigners(this.docusignRepo, document);

      CZWTFCDocusignRequestDTO.CompositeTemplateDTO compositTemplate = requestEnricher.setDocument(this.docusignRepo, disclosure, 1);

      //    document = requestEnricher.addPrefillData(this.docusignRepo, document, this.discsignerMap.get(disclosure.Id));

      /*if (document.documentDTO.lstSignerDTO != null) {
        for (CZDocusignDocumentGenDTO.SignerDTO signer : document.documentDTO.lstSignerDTO) {
          if (!response.branchSigners.containsKey(signer.partyId)) {
            response.branchSigners.put(signer.partyId, signer);
          }
        }
      }*/
      templateList.add(compositTemplate);
    }

    return templateList;
  }

  public void setParticipants(List<tffa__Disclosure__c> disclosures) {
    this.discsignerMap = new Map<Id, List<tffa__Party__c>>();
    for (tffa__Disclosure__c d : disclosures) {
      List<tffa__Party__c> partyLst = new List<tffa__Party__c>();
      for (tffa__DisclosureParticipant__c dp : d.tffa__DisclosureParticipants__r) {
        if (this.docusignRepo.mapParties.containsKey(dp.tffa__party__c)) {
          partyLst.add(this.docusignRepo.mapParties.get(dp.tffa__party__c));
        }
      }
      this.discsignerMap.put(d.Id, partyLst);
    }
  }
}