public with sharing class AdverseActionLetterExtension {
  //Score Date

  public String partyId { get; set; }

  public String brandName { get; set; }
  public String brandAddress { get; set; }
  public String brandPhoneNumber { get; set; }
  public boolean chexSystem { get; set; }

  public tffa__Party__c partyDtls { get; set; }
  public tffa__Brand__c brandDtls { get; set; }

  public List<String> reasons { get; set; }

  public AdverseActionLetterExtension(ApexPages.StandardController stdController) {
    try {
      List<tffa__DueDiligence__c> ddList = new List<tffa__DueDiligence__c>();
      partyId = ApexPages.currentPage().getParameters().get('id');
      tffa.Logger.debug('partyId:' + partyId);

      //partyId = 'a108A000002pSjXQAU'; //temp for testing
      reasons = new List<String>();
      partyDtls = CZWTFCPartyRepository.fetchPartyById(partyId);
      ddList = CZWTFCHelperRepository.getDueDiligenceList(partyId);
      List<String> fraudTagList = new List<String>();
      List<String> chexSystemTagList = new List<String>();
      WintrustEnvConfig__mdt wintrustConfig = CZWTFCHelperRepository.fetchWintrustEnvConfig();
      fraudTagList = wintrustConfig.CZFraudTags__c.split(',');
      chexSystemTagList = wintrustConfig.CZChexSystemTags__c.split(',');
      boolean fraudTag = false;
      boolean chexSystemTag = false;
      tffa__DueDiligence__c idvDD;
      if (ddList != null && !ddList.isEmpty()) {
        for (tffa__DueDiligence__c dd : ddList) {
          if (dd.tffa__Type__c.equalsIgnoreCase('IDV')) {
            idvDD = dd;
            break;
          }
        }
      }

      if (fraudTagList != null && !fraudTagList.isEmpty()) {
        for (String tag : fraudTagList) {
          if (idvDD.tffa__Tags__c.contains(tag)) {
            fraudTag = true;
          }
        }
      }

      if (!fraudTag && chexSystemTagList != null && !chexSystemTagList.isEmpty()) {
        for (String tag : chexSystemTagList) {
          if (idvDD.tffa__Tags__c.contains(tag)) {
            chexSystemTag = true;
          }
        }
      }

      if (fraudTag) {
        chexSystem = false;
      } else if (chexSystemTag) {
        chexSystem = true;
      } else {
        chexSystem = false;
      }
      brandDtls = CZWTFCBrandRepository.fetchBrandByCode(partyDtls.tffa__BrandCode__c);

      brandName = brandDtls.Name;
      brandAddress = brandDtls.Address__c;
      brandPhoneNumber = brandDtls.ContactNumber__c;
      tffa.Logger.debug('brandName:' + brandName);
      tffa.Logger.debug('brandAddress:' + brandAddress);
    } catch (Exception ex) {
      tffa.Logger.error(' Exception msg in adverse action ext: ' + ex.getMessage() + ' ' + ex.getStackTraceString());
    }
  }
}