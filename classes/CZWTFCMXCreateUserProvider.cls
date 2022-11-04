public with sharing class CZWTFCMXCreateUserProvider {
  @TestVisible
  private static boolean testException = false;
  public static String invokeCreateUserAPI(String subId, Map<String, String> params) {
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      CZWTFCMXCreateUserResponseDTO.User user = new CZWTFCMXCreateUserResponseDTO.User();
      //fetch submission
      tffa__Submission__c submissionObj = CZWTFCSubmissionRepository.findSubmissionById(subId);
      String primaryPartyID;

      if(params.containsKey('partyId')){
        primaryPartyID = params.get('partyId');
      }else{
      //loop over sub party to fetch primary party id.
      for (tffa__SubmissionPartyXref__c partyXref : submissionObj.tffa__PartyXrefs__r) {
        if (partyXref.tffa__Primary__c && partyXref.tffa__Type__c == FISCCIntegrationConstants.INDIVIDUAL) {
          primaryPartyID = partyXref.tffa__Party__r.id;
        }
      }}

      // fetch party details
      tffa__Party__c partyObj = CZWTFCPartyRepository.findByIdWithChildObjects(primaryPartyID);

      if (String.valueOf(params.get('isMXUserCreated')) == 'false') {
        Map<String, String> reqParams = new Map<String, String>();

        if (partyObj.Id != null) {
          reqParams.put('id', String.valueOf(partyObj.Id));
        } else {
          reqParams.put('id', '');
        }

        if (partyObj.tffa__BirthDate__c != null) {
          reqParams.put('birthdate', String.valueOf(partyObj.tffa__BirthDate__c));
        } else {
          reqParams.put('birthdate', '');
        }

        if (partyObj.tffa__PrimaryEmail__c != null) {
          reqParams.put('email', String.valueOf(partyObj.tffa__PrimaryEmail__c));
        } else {
          reqParams.put('email', '');
        }

        if (partyObj.tffa__FirstName__c != null) {
          reqParams.put('first_name', String.valueOf(partyObj.tffa__FirstName__c));
        } else {
          reqParams.put('first_name', '');
        }

        if (partyObj.tffa__LastName__c != null) {
          reqParams.put('last_name', String.valueOf(partyObj.tffa__LastName__c));
        } else {
          reqParams.put('last_name', '');
        }

        if (partyObj.tffa__PrimaryPhone__c != null) {
          reqParams.put('phone', String.valueOf(partyObj.tffa__PrimaryPhone__c));
        } else {
          reqParams.put('phone', '');
        }

        for (tffa__PartyAddressXref__c partyAddressXrefObj : partyObj.tffa__AddressXrefs__r) {
          if (partyAddressXrefObj.tffa__Type__c.equalsignorecase('Home')) {
            if (partyAddressXrefObj.tffa__Address__r.tffa__ZipCode__c != null) {
              reqParams.put('zip_code', String.valueOf(partyAddressXrefObj.tffa__Address__r.tffa__ZipCode__c));
            } else {
              reqParams.put('zip_code', '');
            }
          }
        }
        CZWTFCMXCreateUserResponseDTO responseDTO = CZWTFCMXCreateUserServiceProvider.invokeCreateUserAPI(reqParams);
        if (responseDTO != null) {
          if (responseDTO.user != null) {
            user = responseDTO.User;
            CZWTFCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.CREATEUSER);
            return user.id;
          } else if (responseDTO.error != null) {
            if (responseDTO.error.message == 'That id is already in use, please use a unique id.') {
              CZWTFCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.CREATEUSER);
              return partyObj.id;
            }
          }
        }
      } else {
        return partyObj.id;
      }
      CZWTFCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.CREATEUSER);
      return '';
    } catch (Exception ex) {
      CZWTFCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.CREATEUSER);
      tffa.logger.error(' Exception into processHostRequest  :::' + ex.getMessage() + ' Exception:::' + ex.getStackTraceString());
      return '';
    }
  }
}