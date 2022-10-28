public with sharing class CZWTFCAdobeCampaignService {
  /**
   * Generate Token and transfer Expired Submissions to Adobe
   */
  public List<tffa__Submission__c> processExpiredSubmissions(List<tffa__Submission__c> subObjList) {
    CZWTFCACCGenerateTokenService getToken = new CZWTFCACCGenerateTokenService();
    CZWTFCAccApiResponse accResp = getToken.getToken();

    List<tffa__Submission__c> subList = new List<tffa__Submission__c>();

    for (tffa__Submission__c sub : subObjList) {
      if (accResp.token != null) {
        CZWTFCAccApiResponse resp = transferExpiredSubs(sub, accResp.token);

        if (resp.isSuccess) {
          sub.IsAccTransferred__c = true;
        } else {
          sub.IsAccTransferred__c = false;
          sub.AdobeCampaignDesc__c = resp.faultDetailDesc;
          sub.AdobeCampaignRetryCount__c = sub.AdobeCampaignRetryCount__c + 1;
        }
      } else {
        sub.IsAccTransferred__c = false;
        sub.AdobeCampaignDesc__c = accResp.faultDetailDesc;
      }
      subList.add(sub);
    }
    return subList;
  }

  /**
   * Process Expired Submission Objects
   */
  public CZWTFCAccApiResponse transferExpiredSubs(tffa__Submission__c subObj, String token) {
    CZWTFCAccApiResponse resp;

    tffa__Submission__c sub = CZWTFCSubmissionRepository.findSubmissionAndChildObjById(subObj.Id);

    //Fetch application party
    List<tffa__ApplicationPartyXref__c> appPartyXrefList = new List<tffa__ApplicationPartyXref__c>();
    appPartyXrefList = CZWTFCHelperRepository.findAppPartyByApp(sub);

    //Fetch additional preference
    List<tffa__AdditionalPreference__c> additionalPrefList = new List<tffa__AdditionalPreference__c>();
    additionalPrefList = CZWTFCHelperRepository.findAdditionalPrefBySub(sub.Id);

    //Fetch account preference
    List<tffa__AccountPreference__c> accountPrefList = new List<tffa__AccountPreference__c>();
    accountPrefList = CZWTFCHelperRepository.findAccountPrefBySub(sub);

    //get subpartyxref
    List<tffa__SubmissionPartyXref__c> subParty = new List<tffa__SubmissionPartyXref__c>();
    List<tffa__Party__c> partyList = new List<tffa__Party__c>();
    if (sub.tffa__PartyXrefs__r != null) {
      subParty = sub.tffa__PartyXrefs__r;
      for (tffa__SubmissionPartyXref__c subP : sub.tffa__PartyXrefs__r) {
        partyList.add(subP.tffa__Party__r);
      }
    }

    //process parties
    CZWTFCACCTransferObjectService accParty = new CZWTFCACCTransferObjectService();
    resp = accParty.expiredObjects(partyList, token);

    //process submissionParty
    if (resp.isSuccess) {
      resp = new CZWTFCAccApiResponse();
      CZWTFCACCTransferObjectService accSubParty = new CZWTFCACCTransferObjectService();
      resp = accSubParty.expiredObjects(subParty, token);
    } else {
      return resp;
    }

    //process application
    if (resp.isSuccess) {
      resp = new CZWTFCAccApiResponse();
      CZWTFCACCTransferObjectService accApp = new CZWTFCACCTransferObjectService();
      resp = accApp.expiredObjects(sub.tffa__Applications__r, token);
    } else {
      return resp;
    }

    //process application party
    if (resp.isSuccess) {
      resp = new CZWTFCAccApiResponse();
      CZWTFCACCTransferObjectService accAppParty = new CZWTFCACCTransferObjectService();
      resp = accAppParty.expiredObjects(appPartyXrefList, token);
    } else {
      return resp;
    }

    //process account preference
    if (resp.isSuccess) {
      resp = new CZWTFCAccApiResponse();
      CZWTFCACCTransferObjectService accountPrefObj = new CZWTFCACCTransferObjectService();
      resp = accountPrefObj.expiredObjects(accountPrefList, token);
    } else {
      return resp;
    }

    //process additional preference
    if (resp.isSuccess) {
      resp = new CZWTFCAccApiResponse();
      CZWTFCACCTransferObjectService additionalPrefObj = new CZWTFCACCTransferObjectService();
      resp = additionalPrefObj.expiredObjects(additionalPrefList, token);
    } else {
      return resp;
    }

    //process submission
    if (resp.isSuccess) {
      resp = new CZWTFCAccApiResponse();
      CZWTFCACCTransferObjectService submissionObj = new CZWTFCACCTransferObjectService();
      resp = submissionObj.expiredObjects(new List<tffa__Submission__c>{ sub }, token);
    } else {
      return resp;
    }
    return resp;
  }
}