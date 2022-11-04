public inherited sharing class CZNCRD3PartyAuthenticationProvider {
  public static String registerOnlineBankingUserId(tffa__Submission__c sub, tffa__Party__c party) {
    try {
      tffa.NCRD3DTO.UserRequestDTO requestDto = toUserRequestDTO(sub, party);

      requestDto.sourceCompanyId = (String) tffa__EnvironmentConfiguration__c.getOrgDefaults().tffa__OnlineBankingEntityId__c;

      tffa.NCRD3Service service = new tffa.NCRD3Service();

      CZWTFCIntegrationLogService.setLogItemRequestAndResponse(String.valueOf(requestDto), null);

      try {
        service.registerUser(requestDto);
        return 'SUCCESS';
      } catch (Exception ex) {
        tffa.logger.error(' exception in registerUser::: ' + ex.getStackTraceString() + ' Message ::: ' + ex.getMessage());
      }
    } catch (Exception ex) {
      tffa.logger.error(' exception ::: ' + ex.getStackTraceString() + ' Message ::: ' + ex.getMessage());
      CZWTFCIntegrationLogService.setLogItemRequestAndResponse(null, ex.getMessage());
    }

    return 'FAILURE';
  }

  public static tffa.NCRD3DTO.UserRequestDTO toUserRequestDTO(tffa__Submission__c sub, tffa__Party__c party) {
    tffa.NCRD3DTO.UserRequestDTO dto = new tffa.NCRD3DTO.UserRequestDTO();
    dto.referenceId = sub.Id;
    dto.mfa = false;
    dto.emailType = 'Primary';
    dto.profileType = 'CONSUMER';
    dto.primaryEmail = party.tffa__PrimaryEmail__c;
    dto.hostId = party.CZMDMPartyID__c;
    //check with AdditionalPreferences__r
    if (!party.tffa__AdditionalPreferences__r.isEmpty()) {
      for (tffa__AdditionalPreference__c pref : party.tffa__AdditionalPreferences__r) {
        if (pref.tffa__AddOnServiceType__c == 'ONLINE_BANKING') {
          dto.loginId = pref.tffa__Value__c;
        }
      } //
    }
    dto.primaryPhone = String.isNotBlank(party.CellPhoneNumber__c) ? party.CellPhoneNumber__c : party.tffa__PrimaryPhone__c;
    dto.firstName = party.tffa__FirstName__c;
    dto.lastName = party.tffa__LastName__c;
    if (
      !party.tffa__AddressXrefs__r.isEmpty() &&
      party.tffa__AddressXrefs__r[0] != null &&
      party.tffa__AddressXrefs__r[0].tffa__Address__r != null
    ) {
      tffa__Address__c address = party.tffa__AddressXrefs__r[0].tffa__Address__r;
      tffa.NCRD3DTO.Address add = new tffa.NCRD3DTO.Address();
      add.line1 = address.tffa__Line1__c;
      add.line2 = address.tffa__Line2__c;
      add.city = address.tffa__City__c;
      add.state = address.tffa__State__c;
      add.postalCode = address.tffa__ZipCode__c;
      add.countryCode = address.tffa__Country__c;
      dto.physicalAddress = add;
    }

    return dto;
  }
}