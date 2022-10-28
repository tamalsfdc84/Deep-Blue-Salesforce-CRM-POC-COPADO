public with sharing class AdverseActionLetterV2Extension {
  //Score Date
  public String scoreDate { get; set; }
  public String partyId { get; set; }
  public String debitBureauScore{ get; set; }
  public String brandName { get; set; }
  public String brandAddress{ get; set; }
  public String brandPhoneNumber{ get; set; }

  public tffa__Party__c partyDtls { get; set; }
  public tffa__Brand__c brandDtls { get; set; }

  public List<String> reasons { get; set; }

  public AdverseActionLetterV2Extension(ApexPages.StandardController stdController) {
    try {
      List<tffa__DueDiligence__c> ddList = new List<tffa__DueDiligence__c>();
      partyId = ApexPages.currentPage().getParameters().get('id');
      tffa.Logger.debug('partyId:' + partyId);

      //partyId = 'a108A000002pSjXQAU'; //temp for testing
      reasons = new List<String>();
      partyDtls = CZWTFCPartyRepository.fetchPartyById(partyId);
      ddList = CZWTFCHelperRepository.getDueDiligenceList(partyId);
      if (ddList != null && !ddList.isEmpty()) {
        for (tffa__DueDiligence__c dd : ddList) {
          if (dd.tffa__Type__c.equalsIgnoreCase('DEBIT_BUREAU')) {
            //Set qualifile date
            scoreDate = dd.CreatedDate.format('MM/dd/yyyy');

            //Set qualifile reason
            if (dd.tffa__Items__r != null && !dd.tffa__Items__r.isEmpty()) {
              for (tffa__DueDiligenceItem__c ddItem : dd.tffa__Items__r) {
                reasons.add(ddItem.tffa__Value__c);
              }
            }
            break;
          }
        }
      }
      brandDtls = CZWTFCBrandRepository.fetchBrandByCode(partyDtls.tffa__BrandCode__c);
      debitBureauScore = partyDtls.tffa__DebitBureauScore__c != null?String.valueOf(partyDtls.tffa__DebitBureauScore__c):'';
      brandName = brandDtls.Name;
	  brandAddress = brandDtls.Address__c;
      brandPhoneNumber = brandDtls.ContactNumber__c;
      tffa.Logger.debug('brandName:' + brandName);
      tffa.Logger.debug('brandAddress:' + brandAddress);
      tffa.Logger.debug('debitBureauScore:' + debitBureauScore);
    } catch (Exception ex) {
      tffa.Logger.debug(' Exception msg : ' + ex.getMessage() + ' ' + ex.getStackTraceString());
    }
  }
}