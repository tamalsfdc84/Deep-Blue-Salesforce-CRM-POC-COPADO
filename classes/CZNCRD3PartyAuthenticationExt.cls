global inherited sharing class CZNCRD3PartyAuthenticationExt extends tffa.PartyAuthenticationProvider {
  /**
   * Authenticate party using configured CZNCRD3PartyAuthenticationExt in the system.
   * @param  params
   * @return tffa__Party__c
   */
  global override tffa__Party__c authenticate(Map < String, Object > params) {
    tffa.Interaction.begin(CZNCRD3PartyAuthenticationExt.class, 'authenticate');
    try {
      return doAuthenticate(params);
    } finally {
      tffa.Interaction.close();
    }
  }

  /**
   * Validates online banking UserId, when applying for a online banking add-on service.
   * This may include checking if UserId is available. Request should also contain reference (ID)
   * to associated Application.
   * @param facts contains the UserId and Application reference, may include more parameters
   * depending on the implementation. Structured as `{UserId__c:String}`.
   * @return `Map<String, Object>` validation response, structured as `{status: String}`
   */
  global override Map<String, Object> validateOnlineBankingUserId(Map<String, Object> facts) {
    tffa.Interaction.begin(CZNCRD3PartyAuthenticationExt.class, 'validateOnlineBankingUserId');
    try {
    tffa.NCRD3DTO.UserRequestDTO requestDto = new tffa.NCRD3DTO.UserRequestDTO();
    requestDto.loginId = (String) facts.get('UserId__c');
    Map<String, Object> env = tffa.EnvironmentService.readEnvironmentConfigurations(null);
    requestDto.sourceCompanyId = (String) env.get('OnlineBankingEntityId__c');
    tffa.NCRD3Service service = new tffa.NCRD3Service();
    tffa.NCRD3DTO.UserResponseDTO responseDto = service.validateUser(requestDto);
    return new Map<String, Object>();
    } finally {
    tffa.Interaction.close();
    }
  }

  /**
   * Initializes authentication mechanism for the existing customer via online banking provider or via third-party authentication
   * provider. Returns the necessary information such as login URL, login mechanism (iframe/new window) etc. Delegates the call
   * to respective authentication provider based on the configured online banking provider in the system.
   *
   * @param facts
   * @return  `Map<String, Object>`
   */
  global override Map < String, Object > initialize(Map < String, Object > facts) {
    tffa.Interaction.begin(CZNCRD3PartyAuthenticationExt.class, 'initialize');
    try {
      Map < String, Object > env = tffa.EnvironmentService.readEnvironmentConfigurations(null);
      if (env.get('OnlineBankingLoginUrl__c') != null) {
        return new Map < String, Object > {
          'Url__c' => (String) env.get('OnlineBankingLoginUrl__c'),
          'Destination__c' => 'IFRAME'
        };
      } else {
        return new Map < String, Object > ();
      }
    } finally {
      tffa.Interaction.close();
    }
  }

  /**
   * Matches list of parties from the repository based on key attributes of the source party. Key attributes might include
   * Last Name, SSN, Date of birth, primary email address etc. Delegates the call to `PartyMatcher` class.
   * @param party
   */
  private void fetchRelatedRecords(tffa__Party__c party) {
    tffa.PartyMatcher matcher = tffa.PartyMatcher.getInstance();
    List < tffa__Party__c > parties = matcher.match(party, new Map < String, Object > {});
    if (!parties.isEmpty() && parties.size() > 1) {
      List < String > partyIds = new List < String > ();
      for (tffa__Party__c p: parties) {
        partyIds.add(p.Id);
      }
      party.tffa__RecordIds__c = String.join(partyIds, ',');
    }
  }

  /**
   * Match with email
   */
  private tffa__Party__c doAuthenticate(Map < String, Object > qparams) {
    Map < String, Object > params = qparams.clone();
    // set brand
    tffa.Context ctx = tffa.Context.get();
    if (ctx.brand != null) {
      params.put('BrandCode__c', ctx.brand);
    }
    tffa__Party__c party;

    //search by query params
    String lastName = (String) params.get('LastName__c');
    if (lastName != null) {
      List < tffa__Party__c > parties = tffa.PartyService.readAll(new tffa.QueryContext(params));
      if (parties != null && !parties.isEmpty()) {
        party = parties[0];
      }
    } else {

      String primaryEmail = (String) params.get('PrimaryEmail__c');
      if (primaryEmail != null) {

        List < tffa__Party__c > parties = tffa.PartyService.readAll(new tffa.QueryContext(params));
        if (parties != null && !parties.isEmpty()) {
          party = parties[0];
        }
      }
    }

    if (party == null) {
      Map < String, Object > facts = params.clone();
      facts.remove('Password');
      throw new tffa.ApplicationException('CUSTOMER NOT FOUND');
    }
    party.tffa__Prefilled__c = true;
    fetchRelatedRecords(party);
    return party;
  }
}