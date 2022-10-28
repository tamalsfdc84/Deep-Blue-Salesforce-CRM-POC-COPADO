public with sharing virtual class CZWTFCDocusignDocumentEnricher {
  /*public override CZDocusignRepository getAllSigners(CZDocusignRepository docusignRepo, CZDocusignDocumentGenDTO documentResponseDTO) {
        docusignRepo.documentSigners.add(docusignRepo.mapParties.get(docusignRepo.primarySignerId));
        return docusignRepo;
    }*/
  public virtual CZWTFCDocusignRequestDTO.CompositeTemplateDTO setDocument(
    CZDocusignRepository docusignRepo,
    tffa__Disclosure__c disclosure,
    Integer documentIndex
  ) {
    CZWTFCDocusignRequestDTO.CompositeTemplateDTO compositTemplate = new CZWTFCDocusignRequestDTO.CompositeTemplateDTO();

    CZWTFCDocusignRequestDTO.ServerTemplateDTO serverTemplate = new CZWTFCDocusignRequestDTO.ServerTemplateDTO();
    serverTemplate.templateId = disclosure.tffa__Template__c;
    serverTemplate.sequence = String.valueOf(documentIndex);

    compositTemplate.serverTemplates = new List<CZWTFCDocusignRequestDTO.ServerTemplateDTO>{ serverTemplate };
    CZWTFCDocusignRequestDTO.InlineTemplateDTO inlineTemplate = new CZWTFCDocusignRequestDTO.InlineTemplateDTO();
    inlineTemplate.sequence = String.valueOf(documentIndex);
    inlineTemplate.recipients = new CZWTFCDocusignRequestDTO.RecipientDTO();

    inlineTemplate.recipients.signers = addSigners(docusignRepo);

    //Add Signers
    tffa.Logger.debug('template fater adding signers ==>' + JSON.serialize(inlineTemplate.recipients.signers));
    compositTemplate.inlineTemplates = new List<CZWTFCDocusignRequestDTO.InlineTemplateDTO>{ inlineTemplate };

    return compositTemplate;
  }

  public List<CZWTFCDocusignRequestDTO.SignerDTO> addSigners(CZDocusignRepository docusignRepo) {
    //tffa.logger.debug('addSigners signers==>' + signers);
    List<CZWTFCDocusignRequestDTO.SignerDTO> result = new List<CZWTFCDocusignRequestDTO.SignerDTO>();

    //    documentResponseDTO.documentDTO.lstSignerDTO = new List<CZWTFCDocusignRequestDTO.SignerDTO>();
    Integer idx;
    if (docusignRepo.currentDisclosure != null) {
      setBusinessParty(docusignRepo);

      Map<String, Integer> roleIndexMap = new Map<String, Integer>();
      for (tffa__DisclosureParticipant__c dp : docusignRepo.currentDisclosure.tffa__DisclosureParticipants__r) {
        CZWTFCDocusignRequestDTO.SignerDTO signer = new CZWTFCDocusignRequestDTO.SignerDTO();

        if (roleIndexMap.containsKey(dp.tffa__RoleCode__c)) {
          idx = roleIndexMap.get(dp.tffa__RoleCode__c);
        } else {
          idx = 1;
        }
        roleIndexMap.put(dp.tffa__RoleCode__c, idx + 1);

        signer.roleName = dp.tffa__RoleCode__c + '_' + String.valueOf(idx);
        signer.recipientId = dp.Id;

        if (dp.tffa__Type__c == 'PARTY') {
          tffa__Party__c partyObj = docusignRepo.mapParties.get(dp.tffa__party__c);
          signer.clientUserId = partyObj.Id;
          if (String.isNotBlank(partyObj.tffa__PrimaryEmail__c)) {
            signer.email = partyObj.tffa__PrimaryEmail__c;
          } else {
            signer.email = 'test@mail.com';
          }

          signer.name = partyObj.Name;
        } else if (dp.tffa__Type__c == 'USER') {
          User currentUserObj = docusignRepo.currentUser;
          signer.clientUserId = currentUserObj.Id;
          signer.email = currentUserObj.Email;
          signer.name = currentUserObj.Name;
        } else if (dp.tffa__Type__c == 'OTHER') {
          tffa__Party__c partyObj = docusignRepo.mapParties.get(dp.tffa__party__c);
          signer.clientUserId = dp.Id;
          if (String.isNotBlank(partyObj.tffa__PrimaryEmail__c)) {
            signer.email = partyObj.tffa__PrimaryEmail__c;
          } else {
            signer.email = 'test@mail.com';
          }
          if (dp.tffa__RoleCode__c == 'NATURAL_PERSON')
            signer.name = partyObj.CZCertifyingIndividualFN__c + ' ' + partyObj.CZCertifyingIndividualLN__c;
          else {
            signer.name = partyObj.CZSpouseName__c;
          }
        }

        addSignerTabs(docusignRepo, signer, dp);

        result.add(signer);
      }
    }
    return result;
  }

  /*
  public static Integer getSignerUniqueNumber(ID signerId, CZDocusignRepository docusignRepo) {
    Integer result = docusignRepo.signerUniqueId.containsKey(signerId) ? docusignRepo.signerUniqueId.get(signerId) : 1;
    return result;
  }*/

  public void addSignerTabs(
    CZDocusignRepository docusignRepo,
    CZWTFCDocusignRequestDTO.SignerDTO signerDTO,
    tffa__DisclosureParticipant__c dp
  ) {
    List<String> requiredDataPoints = getRequiredDataPoints(docusignRepo, signerDTO, dp);
    tffa.Logger.debug('requiredDataPoints: ' + requiredDataPoints);
    if (requiredDataPoints == null && !Test.isRunningTest()) {
      return;
    }

    signerDTO.tabs = new CZWTFCDocusignRequestDTO.EnvelopeRecipientTabDTO();
    signerDTO.tabs.textTabs = new List<CZWTFCDocusignRequestDTO.TextTabDTO>();
    signerDTO.tabs.radioGroupTabs = new List<CZWTFCDocusignRequestDTO.RadioTabDTO>();
    signerDTO.tabs.checkboxTabs = new List<CZWTFCDocusignRequestDTO.CheckboxTabDTO>();

    if (dp.tffa__Type__c == 'PARTY') {
      prefillPartyDetails(docusignRepo, signerDTO, dp.tffa__party__c, requiredDataPoints);
    } else if (dp.tffa__Type__c == 'USER') {
      prefillUserDetails(docusignRepo, signerDTO);
    } else if (dp.tffa__Type__c == 'OTHER') {
      prefillOtherParticipantDetails(docusignRepo, signerDTO, dp);
    }

    invokeRequiredDataPoint(requiredDataPoints, docusignRepo, signerDTO, dp);
  }

  public static void invokeRequiredDataPoint(
    List<String> requiredDataPoints,
    CZDocusignRepository docusignRepo,
    CZWTFCDocusignRequestDTO.SignerDTO signerDTO,
    tffa__DisclosureParticipant__c dp
  ) {
    if (requiredDataPoints.contains('BUSINESSDTLS'))
      prefillBusinessDetails(docusignRepo, signerDTO, dp);
    if (requiredDataPoints.contains('ACCOUNTDTLS'))
      prefillAccountDetails(docusignRepo, signerDTO, dp);
    if (requiredDataPoints.contains('ACCOUNTNUMBERS'))
      prefillAccountNumbers(docusignRepo, signerDTO, dp);
    if (requiredDataPoints.contains('ACCOUNTNUMBERSANDDETAILS'))
      prefillAccountNumbersAndAddressDetails(docusignRepo, signerDTO, dp);
    if (requiredDataPoints.contains('BRANDDTLS'))
      prefillBrandDetails(docusignRepo, signerDTO, dp);
    if (requiredDataPoints.contains('BENEFICIARYDTLS'))
      prefillBeneficiaryDetails(docusignRepo, signerDTO, dp, requiredDataPoints);
    if (requiredDataPoints.contains('OWNERSHIPDTLS'))
      prefillOwnershipDetails(docusignRepo, signerDTO, dp);
    if (requiredDataPoints.contains('CURRENTDATEDTLS'))
      prefillCurrentDateDetails(docusignRepo, signerDTO, dp);
    if (requiredDataPoints.contains('BENEFICIALOWNERDTLS'))
      prefillBeneficialOwnerDetails(docusignRepo, signerDTO, dp);
    if (requiredDataPoints.contains('RATEDETAILS'))
      prefillRateDetails(docusignRepo, signerDTO, dp);
    if (requiredDataPoints.contains('PRINCIPALDTLS'))
      prefillPrincipalDetails(docusignRepo, signerDTO, dp);
    if (requiredDataPoints.contains('CERTIFICATEDTLS'))
      prefillCertificateDepositDetails(docusignRepo, signerDTO, dp);
    if (requiredDataPoints.contains('IRADTLS'))
      prefillIRADetails(docusignRepo, signerDTO, dp);
    if (requiredDataPoints.contains('MAXSAFEACCMAINDTLS'))
      prefillMaxsafeAccountMaintenanceDetails(docusignRepo, signerDTO, dp);
    if (requiredDataPoints.contains('BANKERDTLS'))
      prefillBankerDetails(docusignRepo, signerDTO, dp);
    if (requiredDataPoints.contains('ELIGIBILITYDTLS'))
      prefillEligibilityDetails(docusignRepo, signerDTO, dp);
    if (requiredDataPoints.contains('HSACONTRIBUTIONDTLS'))
      prefillHSAContributionDetails(docusignRepo, signerDTO, dp);
    if (requiredDataPoints.contains('ODDTLS'))
      prefillOverdraftDetails(docusignRepo, signerDTO, dp);
    if (requiredDataPoints.contains('JUNIORDETAILS'))
      prefillJuniorSaverDetails(docusignRepo, signerDTO, dp);
    if (requiredDataPoints.contains('IRAELIGIBILITYDTLS'))
      prefillIRAEligibilityDetails(docusignRepo, signerDTO, dp);
  }

  public static List<String> getRequiredDataPoints(
    CZDocusignRepository docusignRepo,
    CZWTFCDocusignRequestDTO.SignerDTO signerDTO,
    tffa__DisclosureParticipant__c dp
  ) {
    String dataPoints = '';
    /* Rolecode Without Index */
    String roleCode = docusignRepo.currentDisclosure.tffa__Code__c + '_' + dp.tffa__RoleCode__c;

    if (docusignRepo.enricherConfig.containsKey(roleCode)) {
      dataPoints = docusignRepo.enricherConfig.get(roleCode);
    }

    /* Rolecode with Index */
    roleCode = docusignRepo.currentDisclosure.tffa__Code__c + '_' + signerDTO.roleName;

    if (docusignRepo.enricherConfig.containsKey(roleCode)) {
      dataPoints = dataPoints + ',' + docusignRepo.enricherConfig.get(roleCode);
    }

    if (String.isBlank(dataPoints)) {
      return null;
    } else {
      List<String> lstString = dataPoints.split(',');
      return lstString;
    }
  }

  public static void prefillPartyDetails(
    CZDocusignRepository docusignRepo,
    CZWTFCDocusignRequestDTO.SignerDTO signerDTO,
    Id partyID,
    List<String> requiredDataPoints
  ) {
    tffa__Party__c partyObj = docusignRepo.mapParties.get(partyID);
    if (requiredDataPoints.contains('NAME') && partyObj != null) {
      tffa__Application__c appObj = docusignRepo.mapApps.get(docusignRepo.currentDisclosure.tffa__LinkedApplication__c);

      String custodianLabel = '';
      if (appObj != null && appObj.tffa__AccountPurpose__c == 'UTMA') {
        for (tffa__ApplicationPartyXref__c appParty : appObj.tffa__PartyXrefs__r) {
          if (
            appParty.tffa__RoleCode__c == 'CUSTODIAN' &&
            appParty.tffa__party__c == partyObj.Id &&
            docusignRepo.currentDisclosure.tffa__Code__c == 'CONSIGNCARD'
          ) {
            custodianLabel = custodianLabel + ' ' + 'Custodian';
          }

          if (appParty.tffa__RoleCode__c == 'UTMA') {
            CZDocusignDocumentPrefillHelper.prefillTextField('\\*UTMA_NAME', CZWTFCCommonHelper.formatName(appParty.Name), signerDTO);
          }
        }
      }

      CZDocusignDocumentPrefillHelper.prefillTextField('\\*Name', CZWTFCCommonHelper.formatName(partyObj.Name) + custodianLabel, signerDTO);
      CZDocusignDocumentPrefillHelper.prefillTextField('FirstName', partyObj.tffa__FirstName__c, signerDTO);
      CZDocusignDocumentPrefillHelper.prefillTextField('LastName', partyObj.tffa__LastName__c, signerDTO);
      CZDocusignDocumentPrefillHelper.prefillTextField('MiddleName', partyObj.tffa__MiddleName__c, signerDTO);

      String middleInitial = String.isNotBlank(partyObj.tffa__MiddleName__c) ? partyObj.tffa__MiddleName__c.substring(0, 1) : '-';
      CZDocusignDocumentPrefillHelper.prefillTextField('MiddleInitial', middleInitial, signerDTO);
    }

    if (requiredDataPoints.contains('IDENTITY')) {
      CZDocusignDocumentPrefillHelper.prefillTextField(
        'TaxID',
        getFormattedIdentificationNumber(partyObj.tffa__NationalIdentifierValue__c, partyObj.tffa__NationalIdentifierType__c),
        signerDTO
      );

      if (partyObj.tffa__BirthDate__c != null) {
        prefillDateOfBirthDetails(partyObj, signerDTO, '');
      }
    }

    if (
      requiredDataPoints.contains('IDENTIFICATION') &&
      partyObj.tffa__Identifications__r != null &&
      partyObj.tffa__Identifications__r.size() > 0
    ) {
      prefillIdentificationDetails(partyObj, signerDTO);
    }

    CZDocusignDocumentPrefillHelper.prefillTextField(
      'EmergencyContactName',
      CZWTFCCommonHelper.formatName(partyObj.CZEmergencyContactName__c),
      signerDTO
    );
    CZDocusignDocumentPrefillHelper.prefillTextField('Allergies', partyObj.CZAlergies__c, signerDTO);
    if (requiredDataPoints.contains('CONTACTDTLS')) {
      prefillPhoneNbrAndEmail(partyObj, signerDTO, '');
    }
    if (requiredDataPoints.contains('ADDRESS')) {
      prefillAddress(partyObj, signerDTO, '');
    }

    if (requiredDataPoints.contains('EMPLOYMENT') && partyObj.tffa__Employments__r != null && partyObj.tffa__Employments__r.size() > 0) {
      prefillEmploymentDetails(partyObj, signerDTO);
    }

    if (partyObj.tffa__MaritalStatus__c == 'Married') {
      CZDocusignDocumentPrefillHelper.prefillCheckBoxField('MARRIED', 'X', signerDTO);
      CZDocusignDocumentPrefillHelper.prefillTextField(
        'SpouseName1',
        CZWTFCCommonHelper.formatToCamelCase(partyObj.CZSpouseName__c),
        signerDTO
      );
    } else if (partyObj.tffa__MaritalStatus__c == 'Unmarried') {
      CZDocusignDocumentPrefillHelper.prefillCheckBoxField('UNMARRIED', 'X', signerDTO);
    }

    //Format: Total 13 character - Bank Number + CIS of Primary Owner
    if (requiredDataPoints.contains('MAXSAFEACCMAINDTLS') && partyObj.Customer_Number__c != null && partyObj.tffa__BrandCode__c != null) {
      String customerNumber = partyObj.Customer_Number__c.replaceFirst('^0+', '');
      String BankCISNumber = partyObj.tffa__BrandCode__c.rightPad((13 - customerNumber.length()), '0') + customerNumber;
      CZDocusignDocumentPrefillHelper.prefillTextField('BankCISNumber', BankCISNumber, signerDTO);
    }

    if (docusignRepo.currentDisclosure.tffa__Code__c == 'HSAAPPLICATION') {
      CZDocusignDocumentPrefillHelper.prefillTextField('RELCODE_HSAAUTHSIGNER', 'HSA Authorized Signer', signerDTO);
    }
  }

  public static void prefillEmploymentDetails(tffa__Party__c partyObj, CZWTFCDocusignRequestDTO.SignerDTO signerDTO) {
    CZDocusignDocumentPrefillHelper.prefillTextField(
      'EmploymentTitle',
      partyObj.tffa__Employments__r[0].tffa__Title__c != null
        ? CZWTFCCommonHelper.formatToCamelCase(partyObj.tffa__Employments__r[0].tffa__Title__c)
        : CZWTFCCommonHelper.getOccupationLabel(partyObj.tffa__Employments__r[0].OccupationType__c),
      signerDTO
    );
  }

  public static void prefillDateOfBirthDetails(tffa__Party__c partyObj, CZWTFCDocusignRequestDTO.SignerDTO signerDTO, String type) {
    Datetime BirthDate = Datetime.newInstance(partyObj.tffa__BirthDate__c, Time.newInstance(0, 0, 0, 0));
    String month = BirthDate.format('MM');
    String day = BirthDate.format('dd');
    String year = BirthDate.format('yyyy');

    Integer days = BirthDate.date().daysBetween(Date.Today());

    CZDocusignDocumentPrefillHelper.prefillTextField(type + 'Age', String.valueOf(Integer.valueOf(days / 365)), signerDTO);
    CZDocusignDocumentPrefillHelper.prefillTextField(type + 'BirthMonth', month, signerDTO);
    CZDocusignDocumentPrefillHelper.prefillTextField(type + 'BirthDay', day, signerDTO);
    CZDocusignDocumentPrefillHelper.prefillTextField(type + 'BirthYear', year, signerDTO);
    CZDocusignDocumentPrefillHelper.prefillTextField(type + 'DateOfBirth', month + '/' + day + '/' + year, signerDTO);
  }

  public static void prefillIdentificationDetails(tffa__Party__c partyObj, CZWTFCDocusignRequestDTO.SignerDTO signerDTO) {
    CZDocusignDocumentPrefillHelper.prefillTextField(
      'IdentificationType',
      CZWTFCCommonHelper.getIdentificationLabel(partyObj.tffa__Identifications__r[0].tffa__Type__c),
      signerDTO
    );
    CZDocusignDocumentPrefillHelper.prefillTextField(
      'IssuedCountry',
      CZWTFCCommonHelper.getIdentificationIssueCountryLabel(partyObj.tffa__Identifications__r[0].tffa__IssuingCountry__c),
      signerDTO
    );
    CZDocusignDocumentPrefillHelper.prefillTextField(
      'IssuedCountryCode',
      partyObj.tffa__Identifications__r[0].tffa__IssuingCountry__c,
      signerDTO
    );
    CZDocusignDocumentPrefillHelper.prefillTextField(
      'IdentificationNumber',
      partyObj.tffa__Identifications__r[0].tffa__IdentificationNumber__c,
      signerDTO
    );
    CZDocusignDocumentPrefillHelper.prefillTextField(
      'IssuedBy',
      partyObj.tffa__Identifications__r[0].tffa__IssuingAuthority__c != null
        ? String.valueOf(partyObj.tffa__Identifications__r[0].tffa__IssuingAuthority__c)
        : '',
      signerDTO
    );
    CZDocusignDocumentPrefillHelper.prefillTextField(
      'IssuedLocation',
      partyObj.tffa__Identifications__r[0].tffa__IssuingState__c,
      signerDTO
    );

    if (partyObj.tffa__Identifications__r[0].tffa__ExpirationDate__c != null) {
      CZDocusignDocumentPrefillHelper.prefillTextField(
        'ExpirationDate',
        CZWTFCCommonHelper.formatDate(partyObj.tffa__Identifications__r[0].tffa__ExpirationDate__c),
        signerDTO
      );
    }

    if (partyObj.tffa__Identifications__r[0].tffa__IssueDate__c != null) {
      CZDocusignDocumentPrefillHelper.prefillTextField(
        'IssueDate',
        CZWTFCCommonHelper.formatDate(partyObj.tffa__Identifications__r[0].tffa__IssueDate__c),
        signerDTO
      );
    }

    if (String.isNotBlank(partyObj.tffa__Citizenship__c)) {
      CZDocusignDocumentPrefillHelper.prefillCheckBoxField(partyObj.tffa__Citizenship__c, 'X', signerDTO);
    }
  }

  public static void prefillOtherParticipantDetails(
    CZDocusignRepository docusignRepo,
    CZWTFCDocusignRequestDTO.SignerDTO signerDTO,
    tffa__DisclosureParticipant__c dp
  ) {
    //Natural Person Details
    if (dp.tffa__RoleCode__c == 'NATURAL_PERSON') {
      String name = docusignRepo.businessParty.CZCertifyingIndividualFN__c + ' ' + docusignRepo.businessParty.CZCertifyingIndividualLN__c;
      CZDocusignDocumentPrefillHelper.prefillTextField('Name', CZWTFCCommonHelper.formatName(name), signerDTO);
      signerDTO.name = name;
    }
  }

  public static void prefillUserDetails(CZDocusignRepository docusignRepo, CZWTFCDocusignRequestDTO.SignerDTO signerDTO) {
    User currentUserObj = docusignRepo.currentUser;
    CZDocusignDocumentPrefillHelper.prefillTextField('Name', currentUserObj.Name, signerDTO);
    CZDocusignDocumentPrefillHelper.prefillTextField('Email', currentUserObj.Email, signerDTO);
  }

  public static void prefillOwnershipDetails(
    CZDocusignRepository docusignRepo,
    CZWTFCDocusignRequestDTO.SignerDTO signerDTO,
    tffa__DisclosureParticipant__c dp
  ) {
    if (!docusignRepo.mapParties.containsKey(docusignRepo.currentDisclosure.tffa__party__c)) {
      return;
    }

    for (tffa__PartyPartyXref__c pXref : docusignRepo.businessParty.tffa__PartyXrefs__r) {
      if (pXref.tffa__RelatedParty__c == dp.tffa__party__c) {
        if (pXref.tffa__OwnershipPercentage__c != null && pXref.tffa__OwnershipPercentage__c != 0) {
          CZDocusignDocumentPrefillHelper.prefillTextField(
            'OwnerPercentage',
            String.valueOf(pXref.tffa__OwnershipPercentage__c),
            signerDTO
          );
        }
        CZDocusignDocumentPrefillHelper.prefillTextField('Title', String.valueOf(pXref.tffa__Title__c), signerDTO);
      }
    }
  }

  public static void prefillBusinessDetails(
    CZDocusignRepository docusignRepo,
    CZWTFCDocusignRequestDTO.SignerDTO signerDTO,
    tffa__DisclosureParticipant__c dp
  ) {
    if (docusignRepo.businessParty == null) {
      return;
    }

    CZDocusignDocumentPrefillHelper.prefillTextField(
      '\\*OrgName',
      CZWTFCCommonHelper.formatName(docusignRepo.businessParty.Name),
      signerDTO
    );

    CZDocusignDocumentPrefillHelper.prefillCheckBoxField(docusignRepo.businessParty.tffa__OrganizationType__c, 'X', signerDTO);

    prefillBusinessAddress(docusignRepo.businessParty, signerDTO);
    String orgNbr;
    if (String.isNotBlank(docusignRepo.businessParty.tffa__PrimaryPhone__c)) {
      orgNbr = docusignRepo.businessParty.tffa__PrimaryPhone__c;
    } else {
      orgNbr = docusignRepo.businessParty.tffa__SecondaryPhone__c;
    }
    CZDocusignDocumentPrefillHelper.prefillTextField('\\*OrgNbr', formatPhoneNumber(orgNbr), signerDTO);
    CZDocusignDocumentPrefillHelper.prefillTextField('OrgEmail', docusignRepo.businessParty.tffa__PrimaryEmail__c, signerDTO);
    CZDocusignDocumentPrefillHelper.prefillTextField(
      'OrgTaxID',
      getFormattedIdentificationNumber(
        docusignRepo.businessParty.tffa__NationalIdentifierValue__c,
        docusignRepo.businessParty.tffa__NationalIdentifierType__c
      ),
      signerDTO
    );

    if (docusignRepo.businessParty.CZBoardMeetingDate__c != null) {
      Datetime meetingDate = Datetime.newInstance(docusignRepo.businessParty.CZBoardMeetingDate__c, Time.newInstance(0, 0, 0, 0));
      String month = meetingDate.format('MMMM');
      String day = meetingDate.format('dd');
      String year = meetingDate.format('yyyy');

      CZDocusignDocumentPrefillHelper.prefillTextField('MeetingDay', getOrdinalDay(Integer.valueOf(day)), signerDTO);
      CZDocusignDocumentPrefillHelper.prefillTextField('MeetingMonth', month, signerDTO);
      CZDocusignDocumentPrefillHelper.prefillTextField('MeetingYear', year, signerDTO);
    }

    if (docusignRepo.businessParty.CZIsPartiallyExcludedEntity__c) {
      CZDocusignDocumentPrefillHelper.prefillCheckBoxField('PartiallyExcludedEntity', 'X', signerDTO);
    }

    CZDocusignDocumentPrefillHelper.prefillTextField('PublicDepositorOf', docusignRepo.businessParty.CZPublicDepositorOf__c, signerDTO);
    CZDocusignDocumentPrefillHelper.prefillTextField('StateOf', docusignRepo.businessParty.CZStateOf__c, signerDTO);
  }

  public static void prefillAccountNumbers(
    CZDocusignRepository docusignRepo,
    CZWTFCDocusignRequestDTO.SignerDTO signerDTO,
    tffa__DisclosureParticipant__c dp
  ) {
    if (String.isEmpty(docusignRepo.currentDisclosure.CZRelatedApplication__c))
      return;

    String[] applicationList = docusignRepo.currentDisclosure.CZRelatedApplication__c.split(',');
    if (
      docusignRepo.currentDisclosure.CZAddendumsAttached__c != null &&
      docusignRepo.currentDisclosure.CZAddendumsAttached__c.contains('SCH2BBUSSIGNERS')
    ) {
      CZDocusignDocumentPrefillHelper.prefillCheckBoxField('SCHDULE_2_CHECKBOX', 'X', signerDTO);
    }
    if (applicationList.size() > 1) {
      CZDocusignDocumentPrefillHelper.prefillCheckBoxField('SCHEDULE_1_CHECKBOX', 'X', signerDTO);
      return;
    }
    CZDocusignDocumentPrefillHelper.prefillCheckBoxField('SPECIFIC_ACC_CHECKBOX', 'X', signerDTO);
    Integer index = 1;
    String AccountNumbers = '';
    for (String applicationID : applicationList) {
      tffa__Application__c appObj = docusignRepo.mapApps.get(applicationID);
      if (appObj != null) {
        CZDocusignDocumentPrefillHelper.prefillTextField('ACCOUNTNUMBER_' + index, appObj.tffa__AccountNumber__c, signerDTO);
        AccountNumbers = AccountNumbers + ',' + appObj.tffa__AccountNumber__c;
        index++;
      }
    }

    if (AccountNumbers != null) {
      AccountNumbers = AccountNumbers.replaceFirst('\\,', '');
    }

    CZDocusignDocumentPrefillHelper.prefillTextField('ACCOUNTNUMBERS', AccountNumbers, signerDTO);
  }

  public static void prefillAccountNumbersAndAddressDetails(
    CZDocusignRepository docusignRepo,
    CZWTFCDocusignRequestDTO.SignerDTO signerDTO,
    tffa__DisclosureParticipant__c dp
  ) {
    if (String.isEmpty(docusignRepo.currentDisclosure.CZRelatedApplication__c))
      return;

    String[] applicationList = docusignRepo.currentDisclosure.CZRelatedApplication__c.split(',');
    Integer index = 1;
    Boolean isTrustAccount = false;
    for (String applicationID : applicationList) {
      tffa__Application__c appObj = docusignRepo.mapApps.get(applicationID);
      if (appObj != null) {
        CZDocusignDocumentPrefillHelper.prefillTextField('ACCOUNTNUMBER_' + index, appObj.tffa__AccountNumber__c, signerDTO);
        CZDocusignDocumentPrefillHelper.prefillTextField('ACCOUNTTITLE_' + index, appObj.Name, signerDTO);

        for (tffa__ApplicationPartyXref__c appParty : appObj.tffa__PartyXrefs__r) {
          if (appParty.tffa__Primary__c) {
            tffa__party__c primaryParty = docusignRepo.mapParties.get(appParty.tffa__party__c);

            if(primaryParty.tffa__OrganizationType__c == 'TRUST' && !isTrustAccount){
              isTrustAccount = true;
            }

            tffa__Address__c addressObj;
            if (primaryParty.tffa__AddressXrefs__r.size() > 1) {
              addressObj = CZWTFCCommonHelper.getPartyAddressByType(primaryParty.tffa__AddressXrefs__r, 'MAILING');
            } else {
              addressObj = primaryParty.tffa__AddressXrefs__r[0].tffa__Address__r;
            }
            if (addressObj != null) {
              /*CZDocusignDocumentPrefillHelper.prefillTextField('ADDRESS_' + index, addressObj.tffa__Line1__c, signerDTO);
              CZDocusignDocumentPrefillHelper.prefillTextField('CITY_' + index, addressObj.tffa__City__c, signerDTO);
              CZDocusignDocumentPrefillHelper.prefillTextField('STATE_' + index, addressObj.tffa__State__c, signerDTO);
              CZDocusignDocumentPrefillHelper.prefillTextField('ZIP_' + index, addressObj.tffa__ZipCode__c, signerDTO);*/

              CZDocusignDocumentPrefillHelper.prefillTextField('ADDRESS_' + index, prefillFullAddress(addressObj), signerDTO);
            }
            CZDocusignDocumentPrefillHelper.prefillTextField('TIN_' + index, primaryParty.tffa__NationalIdentifierValue__c, signerDTO);
            break;
          }
        }

        index++;
      }
    }

    if (
      docusignRepo.currentDisclosure.CZParentDisclosureCode__c == 'BUSSIGNCARD') {
      if(!isTrustAccount){
        CZDocusignDocumentPrefillHelper.prefillCheckBoxField('RESOLUTION_CHECKBOX', 'X', signerDTO);
      }
      CZDocusignDocumentPrefillHelper.prefillCheckBoxField('SIGNATURE_CHECKBOX', 'X', signerDTO);
    }
  }

  public static void prefillAccountDetails(
    CZDocusignRepository docusignRepo,
    CZWTFCDocusignRequestDTO.SignerDTO signerDTO,
    tffa__DisclosureParticipant__c dp
  ) {
    tffa__Application__c appObj = docusignRepo.mapApps.get(docusignRepo.currentDisclosure.tffa__LinkedApplication__c);

    //Title
    setAppTitle(appObj, signerDTO);

    if (
      docusignRepo.currentDisclosure.CZAddendumsAttached__c != null &&
      (docusignRepo.currentDisclosure.CZAddendumsAttached__c.contains(CZWTFCConstants.SIGNCARDADDENDUMBUS_CODE) ||
      docusignRepo.currentDisclosure.CZAddendumsAttached__c.contains(CZWTFCConstants.SIGNCARDADDENDUMCUS_CODE))
    ) {
      CZDocusignDocumentPrefillHelper.prefillCheckBoxField(CZWTFCConstants.SCHEDULE2, 'X', signerDTO);
    }

    if (
      docusignRepo.currentDisclosure.CZAddendumsAttached__c != null &&
      (docusignRepo.currentDisclosure.CZAddendumsAttached__c.contains('SCHD1BBUSINESACC'))
    ) {
      CZDocusignDocumentPrefillHelper.prefillCheckBoxField(CZWTFCConstants.SCHEDULE1, 'X', signerDTO);
    }

    //Account Nbr
    CZDocusignDocumentPrefillHelper.prefillTextField('\\*AccountNbr', appObj.tffa__AccountNumber__c, signerDTO);

    if (appObj.tffa__AccountPurpose__c == 'UTMA' && appObj.CZSuccessorCustodian__c != null) {
      CZDocusignDocumentPrefillHelper.prefillTextField('SuccessorCustodian', appObj.CZSuccessorCustodian__c, signerDTO);
    }

    // Plan number for IRA
    if (appObj.tffa__ProductCategory__c == FISCCIntegrationConstants.IRA_PRODUCT_CATEGORY) {
      CZDocusignDocumentPrefillHelper.prefillTextField('PlanNumber', appObj.tffa__InvestmentPlanNumber__c, signerDTO);
    }

    //SDB
    if (
      FISCCIntegrationConstants.SAFE_DEPOSIT_PROD_CATEGORY.contains(appObj.tffa__ProductCategory__c) &&
      String.isNotBlank(appObj.tffa__DepositBoxAccountNumber__c)
    ) {
      prefillSDBDetails(appObj, signerDTO);
    }

    CZDocusignDocumentPrefillHelper.prefillTextField(
      'AccOpeningDate',
      appObj.CZAccountOpeningDate__c != null ? String.valueOf(appObj.CZAccountOpeningDate__c) : '',
      signerDTO
    );

    if (appObj.tffa__LinkedFundingRequests__r != null && appObj.tffa__LinkedFundingRequests__r.size() > 0) {
      CZDocusignDocumentPrefillHelper.prefillTextField(
        'DepositAmount',
        ('$' + CZWTFCCommonHelper.formatAmount(appObj.tffa__LinkedFundingRequests__r[0].tffa__Amount__c)),
        signerDTO
      );
    } else {
      CZDocusignDocumentPrefillHelper.prefillTextField('DepositAmount', '$0.00', signerDTO);
    }

    for (tffa__ApplicationPartyXref__c appParty : appObj.tffa__PartyXrefs__r) {
      if (appParty.tffa__Primary__c) {
        tffa__party__c primaryParty = docusignRepo.mapParties.get(appParty.tffa__party__c);
        CZDocusignDocumentPrefillHelper.prefillTextField(
          'PrimaryTaxId',
          getFormattedIdentificationNumber(primaryParty.tffa__NationalIdentifierValue__c, primaryParty.tffa__NationalIdentifierType__c),
          signerDTO
        );
        break;
      }
    }

    // Override PrimaryTaxId For IOLTA/IBRETA Products
    if (appObj.tffa__Product__r.CZIoltaIbretaTIN__c != null) {
      CZDocusignDocumentPrefillHelper.prefillTextField(
        'PrimaryTaxId',
        getFormattedIdentificationNumber(String.valueOf(appObj.tffa__Product__r.CZIoltaIbretaTIN__c), 'TIN'),
        signerDTO
      );
    }

    String DBA = '';
    Integer DBACount = 0;
    for (tffa__ApplicationPartyXref__c appParty : appObj.tffa__PartyXrefs__r) {
      if (appParty.tffa__RoleCode__c == 'DBA' && DBACount <= 10) {
        DBA += ', ' + appParty.tffa__Party__r.Name;
        DBACount++;
      }
    }

    DBA = DBA.replaceFirst('\\,', '');

    if (String.isNotBlank(DBA)) {
      CZDocusignDocumentPrefillHelper.prefillTextField('DBA', DBA, signerDTO);
    }
  }

  public static void prefillSDBDetails(tffa__Application__c appObj, CZWTFCDocusignRequestDTO.SignerDTO signerDTO) {
    CZDocusignDocumentPrefillHelper.prefillTextField('\\*AccountNbr', appObj.tffa__DepositBoxAccountNumber__c, signerDTO);
    CZDocusignDocumentPrefillHelper.prefillTextField('\\*BoxNumber', appObj.tffa__DepositBoxAccountNumber__c, signerDTO);
    CZDocusignDocumentPrefillHelper.prefillTextField('BoxSize', appObj.tffa__DepositBoxSize__c, signerDTO);
    CZDocusignDocumentPrefillHelper.prefillTextField(
      'AnnualRentalFee',
      appObj.tffa__DepositBoxRentalFee__c != null ? ('$ ' + String.valueOf(appObj.tffa__DepositBoxRentalFee__c)) : '',
      signerDTO
    );

    if (appObj.tffa__DepositBoxStartDate__c != null) {
      CZDocusignDocumentPrefillHelper.prefillTextField(
        '\\*DateOfLease',
        CZWTFCCommonHelper.formatDate(appObj.tffa__DepositBoxStartDate__c),
        signerDTO
      );
      CZDocusignDocumentPrefillHelper.prefillTextField(
        'YearlyRentalFeeOn',
        CZWTFCCommonHelper.formatDate(appObj.tffa__DepositBoxStartDate__c.addDays(365)),
        signerDTO
      );
    }

    if (appObj != null && appObj.CZLocation__r != null && appObj.CZLocation__r.tffa__Address__r != null) {
      String branchName = appObj.CZLocation__r.Name;
      String[] branchNameTemp = branchName.split(' - ');
      if (branchNameTemp.size() > 1) {
        branchName = branchNameTemp[1];
      }

      CZDocusignDocumentPrefillHelper.prefillTextField(
        'BoxLocation',
        CZWTFCCommonHelper.formatToCamelCase(branchName) +
        '- ' +
        prefillFullAddress(appObj.CZLocation__r.tffa__Address__r),
        signerDTO
      );
    }

    Integer applicationPartyCount = 0;
    List<String> rolesList = appObj.tffa__ProductCategory__c.contains('BUSINESS')
      ? CZWTFCDisclosureHelper.ROLE_MAP.get('BUSINESS_SIGNER')
      : CZWTFCDisclosureHelper.ROLE_MAP.get('CONSUMER_SIGNER');

    for (tffa__ApplicationPartyXref__c appParty : appObj.tffa__PartyXrefs__r) {
      if (appParty.tffa__Type__c == FISCCIntegrationConstants.INDIVIDUAL && rolesList.contains(appParty.tffa__RoleCode__c)) {
        applicationPartyCount++;
      }
    }

    prefillBoxOwnerShipDetails(signerDTO, appObj.tffa__ProductCategory__c, applicationPartyCount);

    if (appObj.tffa__LinkedFundingRequests__r != null && appObj.CZRenewalBillingMode__c == 'AUTO_DEBIT') {
      for (tffa__FundingRequest__c fundingRequest : appObj.tffa__LinkedFundingRequests__r) {
        if (fundingRequest.tffa__Purpose__c == 'RENEWAL') {
          CZDocusignDocumentPrefillHelper.prefillTextField('AutoDebitAccNbr', fundingRequest.tffa__AccountNumber__c, signerDTO);
        }
      }
    }
  }

  public static void prefillBoxOwnerShipDetails(
    CZWTFCDocusignRequestDTO.SignerDTO signerDTO,
    String productCategory,
    Integer applicationPartyCount
  ) {
    if (productCategory == 'SAFE_DEPOSIT_BOX' && applicationPartyCount == 1) {
      CZDocusignDocumentPrefillHelper.prefillTextField('BoxOwnerShip', 'Individual', signerDTO);
    } else if (productCategory == 'SAFE_DEPOSIT_BOX' && applicationPartyCount > 1) {
      CZDocusignDocumentPrefillHelper.prefillTextField('BoxOwnerShip', 'Joint', signerDTO);
    } else if (productCategory == 'BUSINESS_SAFE_DEPOSIT_BOX' && applicationPartyCount == 1) {
      CZDocusignDocumentPrefillHelper.prefillTextField('BoxOwnerShip', 'Authorized Signer', signerDTO);
    } else if (productCategory == 'BUSINESS_SAFE_DEPOSIT_BOX' && applicationPartyCount > 1) {
      CZDocusignDocumentPrefillHelper.prefillTextField('BoxOwnerShip', 'Authorized Signers', signerDTO);
    }
  }

  public static void prefillBrandDetails(
    CZDocusignRepository docusignRepo,
    CZWTFCDocusignRequestDTO.SignerDTO signerDTO,
    tffa__DisclosureParticipant__c dp
  ) {
    tffa__Application__c appObj = docusignRepo.mapApps.get(docusignRepo.currentDisclosure.tffa__LinkedApplication__c);
    tffa__Brand__c brand = docusignRepo.brandObj;

    if (appObj != null && appObj.CZLocation__r != null && appObj.CZLocation__r.FISBranchCode__c == '898') {
      CZDocusignDocumentPrefillHelper.prefillTextField('\\*BankName', 'The Chicago Trust Company, N.A.', signerDTO);
    } else {
      CZDocusignDocumentPrefillHelper.prefillTextField('\\*BankName', brand.Name, signerDTO);
    }

    if (appObj != null && appObj.CZLocation__r != null && appObj.CZLocation__r.tffa__Address__r != null) {
      if (appObj.CZLocation__r.FISBranchCode__c == '898') {
        CZDocusignDocumentPrefillHelper.prefillTextField('BranchLocation', 'MAXSAFE™', signerDTO);
      }

      tffa__Address__c address = appObj.CZLocation__r.tffa__Address__r;
      CZDocusignDocumentPrefillHelper.prefillTextField('\\*BankAddLine', address.tffa__Line1__c, signerDTO);

      String BankAddCityStateZip = '';
      if (String.isNotBlank(address.tffa__City__c)) {
        BankAddCityStateZip += address.tffa__City__c;
      }
      if (String.isNotBlank(address.tffa__State__c)) {
        BankAddCityStateZip += ', ' + address.tffa__State__c;
      }
      if (String.isNotBlank(address.tffa__ZipCode__c)) {
        BankAddCityStateZip += ', ' + address.tffa__ZipCode__c;
      }

      CZDocusignDocumentPrefillHelper.prefillTextField('\\*BankAddCityStateZip', BankAddCityStateZip, signerDTO);
    }

    CZDocusignDocumentPrefillHelper.prefillTextField('\\*BankNbr', brand.ContactNumber__c, signerDTO);
  }

  public static void setAppTitle(tffa__Application__c appObj, CZWTFCDocusignRequestDTO.SignerDTO signerDTO) {
    List<String> accTitleLst = new List<String>();
    if (String.isNotBlank(appObj.CZTitle1__c)) {
      accTitleLst.add(CZWTFCCommonHelper.formatName(appObj.CZTitle1__c));
    }
    if (String.isNotBlank(appObj.CZTitle2__c)) {
      accTitleLst.add(appObj.CZTitle2__c);
    }
    if (String.isNotBlank(appObj.CZTitle3__c)) {
      accTitleLst.add(appObj.CZTitle3__c);
    }
    if (appObj.tffa__Address__r != null) {
      accTitleLst.add(
        appObj.tffa__Address__r.tffa__Line1__c +
        (appObj.tffa__Address__r.tffa__Line2__c != null ? ', ' + appObj.tffa__Address__r.tffa__Line2__c : '')
      );

      accTitleLst.add(
        appObj.tffa__Address__r.tffa__City__c +
        ', ' +
        appObj.tffa__Address__r.tffa__State__c +
        +', ' +
        appObj.tffa__Address__r.tffa__ZipCode__c
      );
    }

    Integer accIdx = 1;
    for (String title : accTitleLst) {
      CZDocusignDocumentPrefillHelper.prefillTextField('AccountTitle' + String.valueOf(accIdx), title, signerDTO);
      accIdx++;
    }
  }

  public static void prefillBusinessAddress(tffa__Party__c partyObj, CZWTFCDocusignRequestDTO.SignerDTO signerDTO) {
    tffa__Address__c addressObj;
    if (partyObj.tffa__AddressXrefs__r == null || partyObj.tffa__AddressXrefs__r.size() == 0) {
      return;
    }

    if (partyObj.tffa__AddressXrefs__r.size() > 1) {
      addressObj = CZWTFCCommonHelper.getPartyAddressByType(partyObj.tffa__AddressXrefs__r, 'REGISTERED');
    } else {
      addressObj = partyObj.tffa__AddressXrefs__r[0].tffa__Address__r;
    }
    CZDocusignDocumentPrefillHelper.prefillTextField('OrgAddLine1', addressObj.tffa__Line1__c, signerDTO);
    CZDocusignDocumentPrefillHelper.prefillTextField('OrgAddLine2', addressObj.tffa__Line2__c, signerDTO);
    CZDocusignDocumentPrefillHelper.prefillTextField(
      '\\*OrgAddLine',
      addressObj.tffa__Line1__c + (String.isNotBlank(addressObj.tffa__Line2__c) ? +' ,' + addressObj.tffa__Line2__c : ''),
      signerDTO
    );
    CZDocusignDocumentPrefillHelper.prefillTextField('OrgAddCity', addressObj.tffa__City__c, signerDTO);
    CZDocusignDocumentPrefillHelper.prefillTextField('OrgAddState', addressObj.tffa__State__c, signerDTO);
    CZDocusignDocumentPrefillHelper.prefillTextField('OrgAddZip', addressObj.tffa__ZipCode__c, signerDTO);
    CZDocusignDocumentPrefillHelper.prefillTextField(
      '\\*OrgAddCityStateZip',
      addressObj.tffa__City__c +
      ',  ' +
      addressObj.tffa__State__c +
      ',  ' +
      addressObj.tffa__ZipCode__c,
      signerDTO
    );
    CZDocusignDocumentPrefillHelper.prefillTextField('OrgFullAddress', prefillFullAddress(addressObj), signerDTO);
    CZDocusignDocumentPrefillHelper.prefillTextField('OrgStateName', addressObj.tffa__State__c, signerDTO);
  }

  public static String prefillFullAddress(tffa__Address__c addressObj) {
    String addressStr = '';
    if (String.isNotBlank(addressObj.tffa__Line1__c)) {
      addressStr += addressObj.tffa__Line1__c;
    }
    if (String.isNotBlank(addressObj.tffa__Line2__c)) {
      addressStr += ' ' + addressObj.tffa__Line2__c;
    }
    if (String.isNotBlank(addressObj.tffa__City__c)) {
      addressStr += ' ' + addressObj.tffa__City__c;
    }
    if (String.isNotBlank(addressObj.tffa__State__c)) {
      addressStr += ' ' + addressObj.tffa__State__c;
    }
    if (String.isNotBlank(addressObj.tffa__ZipCode__c)) {
      addressStr += ' ' + addressObj.tffa__ZipCode__c;
    }
    return addressStr;
  }

  public static void prefillAddress(tffa__Party__c partyObj, CZWTFCDocusignRequestDTO.SignerDTO signerDTO, String type) {
    tffa__Address__c addressObj;
    if (partyObj.tffa__AddressXrefs__r == null || partyObj.tffa__AddressXrefs__r.size() == 0) {
      return;
    }

    if (partyObj.tffa__AddressXrefs__r.size() > 1) {
      addressObj = CZWTFCCommonHelper.getPartyAddressByType(partyObj.tffa__AddressXrefs__r, 'HOME');
    } else {
      addressObj = partyObj.tffa__AddressXrefs__r[0].tffa__Address__r;
    }
    CZDocusignDocumentPrefillHelper.prefillTextField(type + 'AddressLine1', addressObj.tffa__Line1__c, signerDTO);
    CZDocusignDocumentPrefillHelper.prefillTextField(type + 'AddressLine2', addressObj.tffa__Line2__c, signerDTO);
    CZDocusignDocumentPrefillHelper.prefillTextField(
      type + 'AddressLine',
      addressObj.tffa__Line1__c + (String.isNotBlank(addressObj.tffa__Line2__c) ? +' ,' + addressObj.tffa__Line2__c : ''),
      signerDTO
    );
    CZDocusignDocumentPrefillHelper.prefillTextField(type + 'AddressState', addressObj.tffa__State__c, signerDTO);
    CZDocusignDocumentPrefillHelper.prefillTextField(type + 'AddressCity', addressObj.tffa__City__c, signerDTO);
    CZDocusignDocumentPrefillHelper.prefillTextField(type + 'AddressZip', addressObj.tffa__ZipCode__c, signerDTO);
    CZDocusignDocumentPrefillHelper.prefillTextField(type + 'AddressCountry', addressObj.tffa__Country__c, signerDTO);
    CZDocusignDocumentPrefillHelper.prefillTextField(
      type + 'AddressCityStateZip',
      addressObj.tffa__City__c +
      ',  ' +
      addressObj.tffa__State__c +
      ',  ' +
      addressObj.tffa__ZipCode__c,
      signerDTO
    );
    CZDocusignDocumentPrefillHelper.prefillTextField(type + 'FullAddress', prefillFullAddress(addressObj), signerDTO);

    if (partyObj.tffa__HasDifferentMailingAddress__c) {
      CZDocusignDocumentPrefillHelper.prefillCheckBoxField('HasDifferentMailingAddress', 'X', signerDTO);
    }
  }

  // Type will be Juinor for junior saver for other it will be blank
  public static void prefillPhoneNbrAndEmail(tffa__Party__c partyObj, CZWTFCDocusignRequestDTO.SignerDTO signerDTO, String type) {
    //phonenbr   ;
    String strPrimaryphone = partyObj.tffa__PrimaryPhone__c != null ? formatPhoneNumber(partyObj.tffa__PrimaryPhone__c) : '';
    String strSecondaryphone = partyObj.tffa__SecondaryPhone__c != null ? formatPhoneNumber(partyObj.tffa__SecondaryPhone__c) : '';
    String strCellphone = partyObj.CellPhoneNumber__c != null ? formatPhoneNumber(partyObj.CellPhoneNumber__c) : '';

    if (String.isNotBlank(partyObj.PreferredContactNumber__c) && partyObj.PreferredContactNumber__c.equalsIgnoreCase('HOME')) {
      CZDocusignDocumentPrefillHelper.prefillTextField(type + 'PrimaryPhoneNumber', strPrimaryphone, signerDTO);
      prefillPreferredContactNumber(partyObj.tffa__PrimaryPhone__c, signerDTO, type);

      if (String.isNotBlank(strSecondaryphone)) {
        CZDocusignDocumentPrefillHelper.prefillTextField(type + 'SecondaryPhoneNumber', strSecondaryphone, signerDTO);
      } else if (String.isNotBlank(strCellphone)) {
        CZDocusignDocumentPrefillHelper.prefillTextField(type + 'SecondaryPhoneNumber', strCellphone, signerDTO);
      }
    } else if (String.isNotBlank(partyObj.PreferredContactNumber__c) && partyObj.PreferredContactNumber__c.equalsIgnoreCase('WORK')) {
      CZDocusignDocumentPrefillHelper.prefillTextField(type + 'PrimaryPhoneNumber', strSecondaryphone, signerDTO);
      prefillPreferredContactNumber(partyObj.tffa__SecondaryPhone__c, signerDTO, type);

      if (String.isNotBlank(strPrimaryphone)) {
        CZDocusignDocumentPrefillHelper.prefillTextField(type + 'SecondaryPhoneNumber', strPrimaryphone, signerDTO);
      } else if (String.isNotBlank(strCellphone)) {
        CZDocusignDocumentPrefillHelper.prefillTextField(type + 'SecondaryPhoneNumber', strCellphone, signerDTO);
      }
    } else if (String.isNotBlank(partyObj.PreferredContactNumber__c) && partyObj.PreferredContactNumber__c.equalsIgnoreCase('CELL')) {
      CZDocusignDocumentPrefillHelper.prefillTextField(type + 'PrimaryPhoneNumber', strCellphone, signerDTO);
      prefillPreferredContactNumber(partyObj.CellPhoneNumber__c, signerDTO, type);

      if (String.isNotBlank(strSecondaryphone)) {
        CZDocusignDocumentPrefillHelper.prefillTextField(type + 'SecondaryPhoneNumber', strSecondaryphone, signerDTO);
      } else if (String.isNotBlank(strPrimaryphone)) {
        CZDocusignDocumentPrefillHelper.prefillTextField(type + 'SecondaryPhoneNumber', strPrimaryphone, signerDTO);
      }
    }

    if (String.isNotBlank(partyObj.CZEmergencyContactNumber__c)) {
      String emergencyContactNumber = partyObj.CZEmergencyContactNumber__c;
      if (emergencyContactNumber.length() > 10) {
        emergencyContactNumber = emergencyContactNumber.Substring(emergencyContactNumber.length() - 10);
      }

      CZDocusignDocumentPrefillHelper.prefillTextField(type + 'EmergencyContactPhone1', emergencyContactNumber.substring(0, 3), signerDTO);
      CZDocusignDocumentPrefillHelper.prefillTextField(type + 'EmergencyContactPhone2', emergencyContactNumber.substring(3, 6), signerDTO);
      CZDocusignDocumentPrefillHelper.prefillTextField(type + 'EmergencyContactPhone3', emergencyContactNumber.substring(6), signerDTO);
    }

    String emailId = partyObj.tffa__PrimaryEmail__c;
    if (String.isNotBlank(emailId)) {
      CZDocusignDocumentPrefillHelper.prefillTextField(type + 'EmailID', emailId, signerDTO);
    }
  }

  public static void prefillPreferredContactNumber(String phoneNumber, CZWTFCDocusignRequestDTO.SignerDTO signerDTO, String type) {
    if (phoneNumber.length() > 10) {
      phoneNumber = phoneNumber.Substring(phoneNumber.length() - 10);
    }

    CZDocusignDocumentPrefillHelper.prefillTextField(type + 'Phone1', phoneNumber.substring(0, 3), signerDTO);
    CZDocusignDocumentPrefillHelper.prefillTextField(type + 'Phone2', phoneNumber.substring(3, 6), signerDTO);
    CZDocusignDocumentPrefillHelper.prefillTextField(type + 'Phone3', phoneNumber.substring(6, 10), signerDTO);
  }

  public static void prefillBeneficiaryDetails(
    CZDocusignRepository docusignRepo,
    CZWTFCDocusignRequestDTO.SignerDTO signerDTO,
    tffa__DisclosureParticipant__c dp,
    List<String> requiredDataPoints
  ) {
    tffa__Application__c appObj = docusignRepo.mapApps.get(docusignRepo.currentDisclosure.tffa__LinkedApplication__c);

    // Avoid beneficiary info to be added for IRA product type in signature card
    if (
      appObj.tffa__ProductCategory__c == FISCCIntegrationConstants.IRA_PRODUCT_CATEGORY &&
      docusignRepo.currentDisclosure.tffa__Code__c == 'CONSIGNCARD'
    ) {
      return;
    }

    List<tffa__Beneficiary__c> benefList = appObj.tffa__Beneficiaries__r;
    Integer totalBenefCount = appObj.tffa__Beneficiaries__r.size() - 1;
    List<tffa__Beneficiary__c> finalBenefList = new List<tffa__Beneficiary__c>();

    if (
      docusignRepo.currentDisclosure.tffa__Code__c == 'HSAAPPLICATION' ||
      docusignRepo.currentDisclosure.tffa__Code__c == 'INHERITIRAAPPLICATION' ||
      docusignRepo.currentDisclosure.tffa__Code__c == 'IRAAPPLICATION'
    ) {
      for (Integer i = 0; i <= 3; i++) {
        if (i <= totalBenefCount)
          finalBenefList.add(benefList[i]);
      }
    } else if (docusignRepo.currentDisclosure.tffa__Code__c == 'BENEFICIARYADDENDUM') {
      for (Integer i = 4; i <= totalBenefCount; i++) {
        if (i <= totalBenefCount)
          finalBenefList.add(benefList[i]);
      }

      CZDocusignDocumentPrefillHelper.prefillTextField(
        'ACCOUNT_NUMBER',
        appObj.tffa__AccountNumber__c != null ? appObj.tffa__AccountNumber__c : appObj.tffa__InvestmentPlanNumber__c,
        signerDTO
      );
    } else {
      finalBenefList = benefList;
    }
    finalBenefList = addBeneficiaryObjs(appObj, finalBenefList);
    Integer Idx = 1;
    for (tffa__Beneficiary__c benef : finalBenefList) {
      prefillBeneficiaryBasicDetails(benef, signerDTO, Idx);

      if (requiredDataPoints.contains('BENEFADDRESS') && benef.tffa__Address__r != null) {
        prefillBeneficiaryAddressDetails(benef.tffa__Address__r, signerDTO, Idx);
      }

      Idx++;
    }

    if (appObj.tffa__Beneficiaries__r != null && appObj.tffa__Beneficiaries__r.size() > 4) {
      CZDocusignDocumentPrefillHelper.prefillCheckBoxField('BENEFICIARYADDENDUM', 'X', signerDTO);
    }
  }

  public static List<tffa__Beneficiary__c> addBeneficiaryObjs(tffa__Application__c app, List<tffa__Beneficiary__c> benefList) {
    for (tffa__ApplicationPartyXref__c appParty : app.tffa__PartyXrefs__r) {
      if (appParty.tffa__Party__r != null && appParty.tffa__RoleCode__c == 'POA_BENEFICIARY') {
        tffa__Beneficiary__c benef = new tffa__Beneficiary__c();
        benef.Name = appParty.tffa__Party__r.Name;
        benef.tffa__BirthDate__c = appParty.tffa__Party__r.tffa__BirthDate__c;
        benef.tffa__PrimaryPhone__c = appParty.tffa__Party__r.tffa__PrimaryPhone__c;
        benefList.add(benef);
      }
    }
    return benefList;
  }

  public static void prefillBeneficiaryBasicDetails(
    tffa__Beneficiary__c beneficiary,
    CZWTFCDocusignRequestDTO.SignerDTO signerDTO,
    Integer Idx
  ) {
    CZDocusignDocumentPrefillHelper.prefillTextField(
      'BenefName' + String.valueOf(Idx),
      CZWTFCCommonHelper.formatName(beneficiary.Name),
      signerDTO
    );

    if (beneficiary.tffa__BirthDate__c != null) {
      Datetime birthDate = Datetime.newInstance(beneficiary.tffa__BirthDate__c, Time.newInstance(0, 0, 0, 0));

      CZDocusignDocumentPrefillHelper.prefillTextField(
        'BenefDOB' + String.valueOf(Idx),
        birthDate.format(CZDocusignConstants.BIRTH_DATE_FORMAT),
        signerDTO
      );
    }

    CZDocusignDocumentPrefillHelper.prefillTextField(
      'BenefShare' + String.valueOf(Idx),
      beneficiary.tffa__SharePercentage__c != null ? String.valueOf(beneficiary.tffa__SharePercentage__c) : '',
      signerDTO
    );
    CZDocusignDocumentPrefillHelper.prefillTextField(
      'BenefPhone' + String.valueOf(Idx),
      beneficiary.tffa__PrimaryPhone__c != null ? formatPhoneNumber(beneficiary.tffa__PrimaryPhone__c) : '',
      signerDTO
    );
    CZDocusignDocumentPrefillHelper.prefillTextField(
      'BenefTaxId' + String.valueOf(Idx),
      beneficiary.tffa__NationalIdentifierValue__c != null ? String.valueOf(beneficiary.tffa__NationalIdentifierValue__c) : '',
      signerDTO
    );

    if (String.isNotBlank(beneficiary.tffa__Type__c)) {
      CZDocusignDocumentPrefillHelper.prefillCheckBoxField(beneficiary.tffa__Type__c + String.valueOf(Idx), 'X', signerDTO);
    }

    if (beneficiary.tffa__RelationCode__r != null) {
      String relationCode = beneficiary.tffa__RelationCode__r.Name;

      if (relationCode == 'SPOUSE') {
        CZDocusignDocumentPrefillHelper.prefillCheckBoxField('BenefSPOUSE' + String.valueOf(Idx), 'X', signerDTO);
      } else if (relationCode == 'Non-SPOUSE') {
        CZDocusignDocumentPrefillHelper.prefillCheckBoxField('BenefNONSPOUSE' + String.valueOf(Idx), 'X', signerDTO);
      }
    }
  }

  public static void prefillBeneficiaryAddressDetails(
    tffa__Address__c addressObj,
    CZWTFCDocusignRequestDTO.SignerDTO signerDTO,
    Integer Idx
  ) {
    CZDocusignDocumentPrefillHelper.prefillTextField('Benef' + Idx + 'AddLine1', addressObj.tffa__Line1__c, signerDTO);
    CZDocusignDocumentPrefillHelper.prefillTextField('Benef' + Idx + 'AddLine2', addressObj.tffa__Line2__c, signerDTO);
    CZDocusignDocumentPrefillHelper.prefillTextField(
      'Benef' +
      Idx +
      'AddLine',
      addressObj.tffa__Line1__c + (String.isNotBlank(addressObj.tffa__Line2__c) ? +' ,' + addressObj.tffa__Line2__c : ''),
      signerDTO
    );
    CZDocusignDocumentPrefillHelper.prefillTextField('Benef' + Idx + 'AddCity', addressObj.tffa__City__c, signerDTO);
    CZDocusignDocumentPrefillHelper.prefillTextField('Benef' + Idx + 'AddState', addressObj.tffa__State__c, signerDTO);
    CZDocusignDocumentPrefillHelper.prefillTextField('Benef' + Idx + 'AddZip', addressObj.tffa__ZipCode__c, signerDTO);

    String addCityStateZip = '';

    if (addressObj.tffa__City__c != null) {
      addCityStateZip = addCityStateZip + addressObj.tffa__City__c;
    }
    if (addressObj.tffa__State__c != null) {
      addCityStateZip = addCityStateZip + ', ' + addressObj.tffa__State__c;
    }
    if (addressObj.tffa__ZipCode__c != null) {
      addCityStateZip = addCityStateZip + ', ' + addressObj.tffa__ZipCode__c;
    }

    CZDocusignDocumentPrefillHelper.prefillTextField('Benef' + Idx + 'AddCityStateZip', addCityStateZip, signerDTO);
  }

  public static String formatPhoneNumber(String phnNbr) {
    try {
      if (phnNbr.length() > 10) {
        phnNbr = phnNbr.Substring(phnNbr.length() - 10);
      }
      String areaCde = phnNbr.substring(0, 3);
      String localNbr_1 = phnNbr.substring(3, 6);
      String localNbr_2 = phnNbr.substring(6, 10);
      return '(' + areaCde + ') ' + localNbr_1 + '-' + localNbr_2;
    } catch (Exception ex) {
      tffa.Logger.debug('Error in foramt phone number ' + ex.getMessage());
    }
    return '';
  }

  public static void setBusinessParty(CZDocusignRepository docusignRepo) {
    if (docusignRepo.currentDisclosure.tffa__party__c != null) {
      docusignRepo.businessParty = docusignRepo.mapParties.get(docusignRepo.currentDisclosure.tffa__party__c);
    } else if (docusignRepo.currentDisclosure.tffa__LinkedApplication__c != null) {
      tffa__Application__c appObj = docusignRepo.mapApps.get(docusignRepo.currentDisclosure.tffa__LinkedApplication__c);
      for (tffa__ApplicationPartyXref__c appParty : appObj.tffa__PartyXrefs__r) {
        if (docusignRepo.ownerList.contains(appParty.tffa__RoleCode__c)) {
          docusignRepo.businessParty = docusignRepo.mapParties.get(appParty.tffa__party__c);
          break;
        }
      }
    } else {
      docusignRepo.businessParty = null;
    }
  }

  public static void prefillBeneficialOwnerDetails(
    CZDocusignRepository docusignRepo,
    CZWTFCDocusignRequestDTO.SignerDTO signerDTO,
    tffa__DisclosureParticipant__c dp
  ) {
    integer Idx = 1;
    for (tffa__PartyPartyXref__c pXref : docusignRepo.businessParty.tffa__PartyXrefs__r) {
      if (
        (pXref.Name == 'Beneficial Owner' ||
        pXref.Name == 'Beneficial Owner and Controlling Party') &&
        pXref.tffa__OwnershipPercentage__c != null &&
        pXref.tffa__OwnershipPercentage__c >= 25
      ) {
        prefillBeneficialOwnershipDetails(docusignRepo, signerDTO, pXref, idx);
        Idx++;
      }

      if ((pXref.Name == 'Controlling Party' || pXref.Name == 'Beneficial Owner and Controlling Party')) {
        prefillControllingPartyDetails(docusignRepo, signerDTO, pXref);
      }
    }
  }

  public static void prefillBeneficialOwnershipDetails(
    CZDocusignRepository docusignRepo,
    CZWTFCDocusignRequestDTO.SignerDTO signerDTO,
    tffa__PartyPartyXref__c pXref,
    Integer idx
  ) {
    tffa__Party__c partyObj = docusignRepo.mapParties.get(pXref.tffa__RelatedParty__c);

    tffa__Address__c addressObj = getPartyAddress(partyObj);
    CZDocusignDocumentPrefillHelper.prefillTextField('BOAddress' + '_' + String.valueOf(idx), prefillFullAddress(addressObj), signerDTO);
    CZDocusignDocumentPrefillHelper.prefillTextField(
      'BOName' +
      '_' +
      String.valueOf(idx),
      CZWTFCCommonHelper.formatName(partyObj.Name),
      signerDTO
    );
    CZDocusignDocumentPrefillHelper.prefillTextField(
      'BOTaxId' +
      '_' +
      String.valueOf(idx),
      String.valueOf(partyObj.tffa__NationalIdentifierValue__c),
      signerDTO
    );

    if (partyObj.tffa__BirthDate__c != null) {
      Datetime birthDate = Datetime.newInstance(partyObj.tffa__BirthDate__c, Time.newInstance(0, 0, 0, 0));
      CZDocusignDocumentPrefillHelper.prefillTextField(
        'BOBirthDate' +
        '_' +
        String.valueOf(idx),
        birthDate.format(CZDocusignConstants.BIRTH_DATE_FORMAT),
        signerDTO
      );
    }

    CZDocusignDocumentPrefillHelper.prefillTextField(
      'BOPerc' +
      '_' +
      String.valueOf(idx),
      String.valueOf(pXref.tffa__OwnershipPercentage__c),
      signerDTO
    );

    if (partyObj.tffa__Identifications__r != null && partyObj.tffa__Identifications__r.size() > 0) {
      CZDocusignDocumentPrefillHelper.prefillTextField(
        'BOIdentificationNumber' +
        '_' +
        String.valueOf(idx),
        partyObj.tffa__Identifications__r[0].tffa__IdentificationNumber__c,
        signerDTO
      );

      CZDocusignDocumentPrefillHelper.prefillTextField(
        'BOIssuedCountry' +
        '_' +
        String.valueOf(idx),
        CZWTFCCommonHelper.getIdentificationIssueCountryLabel(partyObj.tffa__Identifications__r[0].tffa__IssuingCountry__c),
        signerDTO
      );
    }
  }

  public static void prefillControllingPartyDetails(
    CZDocusignRepository docusignRepo,
    CZWTFCDocusignRequestDTO.SignerDTO signerDTO,
    tffa__PartyPartyXref__c pXref
  ) {
    tffa__Party__c partyObj = docusignRepo.mapParties.get(pXref.tffa__RelatedParty__c);

    tffa__Address__c addressObj = getPartyAddress(partyObj);
    CZDocusignDocumentPrefillHelper.prefillTextField('CPAddress', prefillFullAddress(addressObj), signerDTO);
    CZDocusignDocumentPrefillHelper.prefillTextField('CPName', CZWTFCCommonHelper.formatName(partyObj.Name), signerDTO);
    CZDocusignDocumentPrefillHelper.prefillTextField('CPTaxId', String.valueOf(partyObj.tffa__NationalIdentifierValue__c), signerDTO);

    if (partyObj.tffa__BirthDate__c != null) {
      Datetime birthDate = Datetime.newInstance(partyObj.tffa__BirthDate__c, Time.newInstance(0, 0, 0, 0));
      CZDocusignDocumentPrefillHelper.prefillTextField('CPBirthDate', birthDate.format(CZDocusignConstants.BIRTH_DATE_FORMAT), signerDTO);
    }

    CZDocusignDocumentPrefillHelper.prefillTextField('CPtitle', String.valueOf(pXref.tffa__Title__c), signerDTO);

    if (partyObj.tffa__Identifications__r != null && partyObj.tffa__Identifications__r.size() > 0) {
      CZDocusignDocumentPrefillHelper.prefillTextField(
        'CPIdentificationNumber',
        partyObj.tffa__Identifications__r[0].tffa__IdentificationNumber__c,
        signerDTO
      );

      CZDocusignDocumentPrefillHelper.prefillTextField(
        'CPIssuedCountry',
        CZWTFCCommonHelper.getIdentificationIssueCountryLabel(partyObj.tffa__Identifications__r[0].tffa__IssuingCountry__c),
        signerDTO
      );
    }
  }

  public static tffa__Address__c getPartyAddress(tffa__Party__c partyObj) {
    tffa__Address__c addressObj;
    if (partyObj.tffa__AddressXrefs__r.size() > 1) {
      addressObj = CZWTFCCommonHelper.getPartyAddressByType(partyObj.tffa__AddressXrefs__r, 'HOME');
    } else {
      addressObj = partyObj.tffa__AddressXrefs__r[0].tffa__Address__r;
    }

    return addressObj;
  }

  public static void prefillCurrentDateDetails(
    CZDocusignRepository docusignRepo,
    CZWTFCDocusignRequestDTO.SignerDTO signerDTO,
    tffa__DisclosureParticipant__c dp
  ) {
    Datetime currentDate = Datetime.now();
    String month = currentDate.format('MMM');
    String month2 = currentDate.format('MMMM');
    String day = currentDate.format('dd');
    String year = currentDate.format('yyyy');
    String year2 = currentDate.format('yy');

    CZDocusignDocumentPrefillHelper.prefillTextField('\\*CurrentDate', currentDate.format('MM/dd/yyyy'), signerDTO);
    CZDocusignDocumentPrefillHelper.prefillTextField('CurrentDay', getOrdinalDay(Integer.valueOf(day)), signerDTO);
    CZDocusignDocumentPrefillHelper.prefillTextField('CurrentMonth', month, signerDTO);
    CZDocusignDocumentPrefillHelper.prefillTextField('CurrentMonth2', month2, signerDTO);
    CZDocusignDocumentPrefillHelper.prefillTextField('CurrentYear', year, signerDTO);
    CZDocusignDocumentPrefillHelper.prefillTextField('CurrentYear2', year2, signerDTO);
  }

  public static void prefillTISADetails(tffa__Application__c appObj, CZWTFCDocusignRequestDTO.SignerDTO signerDTO) {
    Map<String, String> interestPayoutFrequencyMap = new Map<String, String>{
      'DAILY' => 'daily',
      'MONTHLY' => 'monthly',
      'QUARTERLY' => 'quarterly',
      'SEMI_ANNUALLY' => 'semi annually',
      'ANNUALLY' => 'annually',
      'AT_MATURITY' => 'at maturity'
    };

    CZDocusignDocumentPrefillHelper.prefillTextField(
      'PayoutMode',
      ' be compounded ' + interestPayoutFrequencyMap.get(appObj.tffa__InterestPayoutFrequency__c),
      signerDTO
    );

    if (appObj.tffa__InterestPayoutMode__c == 'COMPOUND') {
      CZDocusignDocumentPrefillHelper.prefillTextField(
        'PayoutFrequency',
        ' credited to your account ' + interestPayoutFrequencyMap.get(appObj.tffa__InterestPayoutFrequency__c),
        signerDTO
      );
    }

    if (appObj.tffa__InterestPayoutMode__c == 'INTERNAL_TRANSFER' || appObj.tffa__InterestPayoutMode__c == 'ACH') {
      CZDocusignDocumentPrefillHelper.prefillTextField(
        'PayoutFrequency',
        ' transferred to account ' +
        appObj.CZInterestPayoutAccountNumber__c +
        ' ' +
        interestPayoutFrequencyMap.get(appObj.tffa__InterestPayoutFrequency__c),
        signerDTO
      );
    }
  }

  public static void prefillRateDetails(
    CZDocusignRepository docusignRepo,
    CZWTFCDocusignRequestDTO.SignerDTO signerDTO,
    tffa__DisclosureParticipant__c dp
  ) {
    tffa__Application__c appObj = docusignRepo.mapApps.get(docusignRepo.currentDisclosure.tffa__LinkedApplication__c);

    if (appObj != null && appObj.tffa__MaturityDate__c != null) {
      Datetime maturityDate = Datetime.newInstance(appObj.tffa__MaturityDate__c, Time.newInstance(0, 0, 0, 0));
      CZDocusignDocumentPrefillHelper.prefillTextField(
        'MaturityDate',
        maturityDate.format(CZDocusignConstants.DOCUMENT_STANDARD_DATE_FORMAT),
        signerDTO
      );
    }

    if (CZWTFCCommonHelper.isCertificateProduct(appObj)) {
      CZDocusignDocumentPrefillHelper.prefillTextField(
        'InterestRate1',
        String.valueOf(appObj.tffa__TermDepositRate__c.setScale(3)),
        signerDTO
      );
      CZDocusignDocumentPrefillHelper.prefillTextField(
        'APY1',
        appObj.tffa__APY__c != null ? String.valueOf(appObj.tffa__APY__c.setScale(2)) : '0.00',
        signerDTO
      );
      prefillTISADetails(appObj, signerDTO);
    } else {
      String interestPlanCode = appObj.tffa__Product__r.InterestPlanCode__c;

      if (Test.isRunningTest()) {
        interestPlanCode = '100000';
      }

      if (String.isNotBlank(interestPlanCode)) {
        Integer tempIntplCode = Integer.valueOf(interestPlanCode);
        interestPlanCode = String.valueOf(tempIntplCode);

        List<InterestPlanDetails__c> interestPlanDetails = docusignRepo.interestPlanDetailsMap.containsKey(interestPlanCode)
          ? docusignRepo.interestPlanDetailsMap.get(interestPlanCode)
          : new List<InterestPlanDetails__c>();

        Integer Idx = 1;
        for (InterestPlanDetails__c interestPlanDetail : interestPlanDetails) {
          CZDocusignDocumentPrefillHelper.prefillTextField(
            'InterestRate' + String.valueOf(Idx),
            interestPlanDetail.InterestRate__c != null ? String.valueOf(interestPlanDetail.InterestRate__c.setScale(3)) : '0.000',
            signerDTO
          );
          CZDocusignDocumentPrefillHelper.prefillTextField(
            'APY' + String.valueOf(Idx),
            interestPlanDetail.APY__c != null ? String.valueOf(interestPlanDetail.APY__c.setScale(2)) : '0.00',
            signerDTO
          );

          List<String> args = new List<String>{ '0', 'number', '###,###,##0.00' };
          String minBal = '0.00';
          String maxBal = '0.00';

          if (interestPlanDetail.TierMinBal__c != null) {
            minBal = String.format(interestPlanDetail.TierMinBal__c.format(), args);
            String[] part = minBal.split('\\.');

            if (part.size() == 1) {
              minBal = minBal + '.00';
            }
          }

          if (interestPlanDetail.TierMaxBal__c != null) {
            maxBal = String.format(interestPlanDetail.TierMaxBal__c.format(), args);
            String[] part = maxBal.split('\\.');

            if (part.size() == 1) {
              maxBal = maxBal + '.00';
            }
          }

          CZDocusignDocumentPrefillHelper.prefillTextField('Tier' + String.valueOf(Idx) + 'Min', minBal, signerDTO);
          CZDocusignDocumentPrefillHelper.prefillTextField('Tier' + String.valueOf(Idx) + 'Max', maxBal, signerDTO);
          Idx++;
        }

        CZDocusignDocumentPrefillHelper.prefillTextField('PayoutMode', ' be compounded monthly', signerDTO);
        CZDocusignDocumentPrefillHelper.prefillTextField('PayoutFrequency', ' credited to your account monthly', signerDTO);
      }
    }
  }

  public static void prefillEligibilityDetails(
    CZDocusignRepository docusignRepo,
    CZWTFCDocusignRequestDTO.SignerDTO signerDTO,
    tffa__DisclosureParticipant__c dp
  ) {
    tffa__Application__c appObj = docusignRepo.mapApps.get(docusignRepo.currentDisclosure.tffa__LinkedApplication__c);

    for (tffa__Eligibility__c eligibility : appObj.tffa__LinkedEligibilities__r) {
      if (eligibility.tffa__ValueType__c == 'RADIO_GROUP' || eligibility.tffa__ValueType__c == 'SELECT') {
        CZDocusignDocumentPrefillHelper.prefillCheckBoxField(
          '\\*' +
          eligibility.tffa__Code__c +
          eligibility.tffa__Value__c,
          'X',
          signerDTO
        );
      }

      if (eligibility.tffa__ValueType__c == 'CURRENCY' || eligibility.tffa__ValueType__c == 'DATE') {
        CZDocusignDocumentPrefillHelper.prefillTextField(eligibility.tffa__Code__c, String.valueOf(eligibility.tffa__Value__c), signerDTO);
      }
    }
  }

  public static void prefillIRAEligibilityDetails(
    CZDocusignRepository docusignRepo,
    CZWTFCDocusignRequestDTO.SignerDTO signerDTO,
    tffa__DisclosureParticipant__c dp
  ) {
    tffa__Application__c appObj = docusignRepo.mapApps.get(docusignRepo.currentDisclosure.tffa__LinkedApplication__c);

    String contributionLabel = appObj.tffa__InvestmentContributionType__c == 'ROLLOVER'
      ? 'R'
      : appObj.tffa__InvestmentContributionType__c == 'DIRECTROLLOVER' ? 'D' : 'C';

    CZDocusignDocumentPrefillHelper.prefillCheckBoxField('\\*' + contributionLabel + '_' + 'NOTAPPLICABLE', 'X', signerDTO);

    for (tffa__Eligibility__c eligibility : appObj.tffa__LinkedEligibilities__r) {
      if (eligibility.tffa__ValueType__c == 'RADIO_GROUP' || eligibility.tffa__ValueType__c == 'SELECT') {
        CZDocusignDocumentPrefillHelper.prefillCheckBoxField(
          contributionLabel +
          '_' +
          eligibility.tffa__Code__c +
          eligibility.tffa__Value__c,
          'X',
          signerDTO
        );
      }
    }
  }

  public static void prefillPrincipalDetails(
    CZDocusignRepository docusignRepo,
    CZWTFCDocusignRequestDTO.SignerDTO signerDTO,
    tffa__DisclosureParticipant__c dp
  ) {
    if (docusignRepo.currentDisclosure != null && docusignRepo.currentDisclosure.tffa__party__c != null) {
      tffa__Party__c partyObj = docusignRepo.mapParties.get(docusignRepo.currentDisclosure.tffa__party__c);

      CZDocusignDocumentPrefillHelper.prefillTextField('PRINCIPALNAME', CZWTFCCommonHelper.formatName(partyObj.Name), signerDTO);
    }
  }

  public static void prefillCertificateDepositDetails(
    CZDocusignRepository docusignRepo,
    CZWTFCDocusignRequestDTO.SignerDTO signerDTO,
    tffa__DisclosureParticipant__c dp
  ) {
    Map<String, String> interestPayoutFrequencyMap = new Map<String, String>{
      'DAILY' => 'Daily',
      'MONTHLY' => 'Monthly',
      'QUARTERLY' => 'Quarterly',
      'SEMI_ANNUALLY' => 'Semi Annually',
      'ANNUALLY' => 'Annually',
      'AT_MATURITY' => 'At Maturity'
    };

    tffa__Application__c appObj = docusignRepo.mapApps.get(docusignRepo.currentDisclosure.tffa__LinkedApplication__c);

    String certificateNumber = appObj.tffa__AccountNumber__c + appObj.DPTDId__c != null ? appObj.DPTDId__c : '';
    CZDocusignDocumentPrefillHelper.prefillTextField('CertificateNumber', appObj.tffa__AccountNumber__c + '-' + '1', signerDTO);

    if (appObj.tffa__Amount__c != null) {
      CZDocusignDocumentPrefillHelper.prefillTextField(
        '\\*DepositAmount',
        CZWTFCCommonHelper.formatAmount(appObj.tffa__Amount__c),
        signerDTO
      );

      List<String> amountList = String.valueOf(appObj.tffa__Amount__c).split('\\.');
      String totalAmount = '';

      if (amountList.size() > 0) {
        String amount1 = CZWTFCCommonHelper.numberToWord(String.valueOf(amountList[0]));
        totalAmount = totalAmount + amount1 + ' Dollars ';
      }

      if (amountList.size() > 1 && amountList[1] != '00' && amountList[1] != '0') {
        String amount2 = CZWTFCCommonHelper.numberToWord(String.valueOf(amountList[1]));
        totalAmount = totalAmount + ' And ' + amount2 + ' Cents';
      } else {
        totalAmount = totalAmount + ' And ' + 'Zero' + ' Cents';
      }

      CZDocusignDocumentPrefillHelper.prefillTextField('AmountInWords', CZWTFCCommonHelper.formatName(totalAmount), signerDTO);
    }

    CZDocusignDocumentPrefillHelper.prefillTextField(
      'Term',
      String.valueOf(appObj.tffa__Term__c) +
      ' ' +
      CZWTFCCommonHelper.formatToCamelCase(appObj.tffa__TermUnit__c).replace(' ', '') +
      CZWTFCCommonHelper.fetchTermUnitSuffix(appObj.tffa__Term__c),
      signerDTO
    );

    if (appObj.tffa__MaturityDate__c != null) {
      Datetime maturityDate = Datetime.newInstance(appObj.tffa__MaturityDate__c, Time.newInstance(0, 0, 0, 0));
      CZDocusignDocumentPrefillHelper.prefillTextField(
        'MaturityDate',
        maturityDate.format(CZDocusignConstants.DOCUMENT_STANDARD_DATE_FORMAT),
        signerDTO
      );
    }

    CZDocusignDocumentPrefillHelper.prefillTextField(
      'RateType',
      appObj.tffa__Product__r.CZRateType__c != null ? String.valueOf(appObj.tffa__Product__r.CZRateType__c) : 'Fixed',
      signerDTO
    );
    CZDocusignDocumentPrefillHelper.prefillTextField('InvestmentPlanType', String.valueOf(appObj.tffa__InvestmentPlanType__c), signerDTO);
    CZDocusignDocumentPrefillHelper.prefillTextField('InterestRate', String.valueOf(appObj.tffa__TermDepositRate__c), signerDTO);
    CZDocusignDocumentPrefillHelper.prefillTextField(
      'APY',
      appObj.tffa__APY__c != null ? String.valueOf(appObj.tffa__APY__c.setScale(2)) : '0.00',
      signerDTO
    );
    CZDocusignDocumentPrefillHelper.prefillTextField(
      'InterestPayoutFreq',
      interestPayoutFrequencyMap.get(appObj.tffa__InterestPayoutFrequency__c),
      signerDTO
    );

    if (appObj.tffa__InterestPayoutMode__c == 'COMPOUND') {
      CZDocusignDocumentPrefillHelper.prefillCheckBoxField('InterestPayoutMode1', 'X', signerDTO);
      CZDocusignDocumentPrefillHelper.prefillTextField('InterestPayoutMode', 'compounded monthly', signerDTO);
    } else if (appObj.tffa__InterestPayoutMode__c == 'INTERNAL_TRANSFER' || appObj.tffa__InterestPayoutMode__c == 'ACH') {
      CZDocusignDocumentPrefillHelper.prefillCheckBoxField('InterestPayoutMode2', 'X', signerDTO);
      CZDocusignDocumentPrefillHelper.prefillTextField(
        'InterestAccNumber',
        String.valueOf(appObj.CZInterestPayoutAccountNumber__c),
        signerDTO
      );

      if (appObj.tffa__InterestPayoutMode__c == 'ACH') {
        CZDocusignDocumentPrefillHelper.prefillTextField(
          'InterestRoutNumber',
          String.valueOf(appObj.CZInterestPayoutRoutingNumber__c),
          signerDTO
        );
      } else {
        tffa__Brand__c brand = docusignRepo.brandObjMap.get(appObj.CZInterestPayoutCharterCode__c);
        CZDocusignDocumentPrefillHelper.prefillTextField(
          'InterestRoutNumber',
          brand != null ? String.valueOf(brand.tffa__RoutingNumber__c) : '',
          signerDTO
        );
      }

      CZDocusignDocumentPrefillHelper.prefillTextField('InterestPayoutMode', 'transferred monthly', signerDTO);
    }

    if (
      appObj.tffa__Product__r != null &&
      appObj.tffa__Product__r.tffa__AllowedRenewalInstructionType__c != null &&
      appObj.tffa__Product__r.tffa__AllowedRenewalInstructionType__c.contains('ROLLOVER')
    ) {
      CZDocusignDocumentPrefillHelper.prefillCheckBoxField('AUTO_RENEW', 'X', signerDTO);
    } else {
      CZDocusignDocumentPrefillHelper.prefillCheckBoxField('SINGLE_MATURITY', 'X', signerDTO);
    }
  }

  public static void prefillIRADetails(
    CZDocusignRepository docusignRepo,
    CZWTFCDocusignRequestDTO.SignerDTO signerDTO,
    tffa__DisclosureParticipant__c dp
  ) {
    tffa__Application__c appObj = docusignRepo.mapApps.get(docusignRepo.currentDisclosure.tffa__LinkedApplication__c);

    if (appObj.tffa__ProductCategory__c == 'HSA' && docusignRepo.currentDisclosure.tffa__Code__c == 'BENEFICIARYADDENDUM') {
      CZDocusignDocumentPrefillHelper.prefillCheckBoxField('HSA', 'X', signerDTO);
    }

    CZDocusignDocumentPrefillHelper.prefillTextField('planNbr', appObj.tffa__InvestmentPlanNumber__c, signerDTO);
    CZDocusignDocumentPrefillHelper.prefillTextField(
      'DeceasedName',
      appObj.CZInvestmentDeceasedPersonFirstName__c != null
        ? (appObj.CZInvestmentDeceasedPersonFirstName__c + ' ' + appObj.CZInvestmentDeceasedPersonLastName__c)
        : '',
      signerDTO
    );
    CZDocusignDocumentPrefillHelper.prefillTextField(
      'DeceasedTaxId',
      appObj.CZInvestmentDeceasedPersonTaxIDNumber__c != null ? appObj.CZInvestmentDeceasedPersonTaxIDNumber__c : '',
      signerDTO
    );

    if (appObj.CZInvestmentDeceasedPersonBirthDate__c != null) {
      CZDocusignDocumentPrefillHelper.prefillTextField(
        'DeceasedDOB',
        appObj.CZInvestmentDeceasedPersonBirthDate__c.format(CZDocusignConstants.DOCUMENT_STANDARD_DATE_FORMAT),
        signerDTO
      );
    }

    if (appObj.CZInvestmentDeceasedPersonDeathDate__c != null) {
      CZDocusignDocumentPrefillHelper.prefillTextField(
        'DeceasedDOD',
        appObj.CZInvestmentDeceasedPersonDeathDate__c.format(CZDocusignConstants.DOCUMENT_STANDARD_DATE_FORMAT),
        signerDTO
      );
    }

    if (appObj.tffa__InvestmentPlanType__c == 'TRADITIONAL') {
      CZDocusignDocumentPrefillHelper.prefillCheckBoxField('TRADITIONAL', 'X', signerDTO);
    } else if (appObj.tffa__InvestmentPlanType__c == 'SEP') {
      CZDocusignDocumentPrefillHelper.prefillCheckBoxField('SEP', 'X', signerDTO);
    } else if (appObj.tffa__InvestmentPlanType__c == 'CONTRIBUTION' || appObj.tffa__InvestmentPlanType__c == 'CONVERSION') {
      CZDocusignDocumentPrefillHelper.prefillCheckBoxField('ROTH', 'X', signerDTO);
    }

    if (appObj.tffa__InvestmentPlanType__c == 'TRADITIONAL' || appObj.tffa__InvestmentPlanType__c == 'SEP') {
      CZDocusignDocumentPrefillHelper.prefillCheckBoxField('TRADITIONAL/SEP', 'X', signerDTO);
    }

    prefillIRAContributionDetails(appObj, signerDTO);

    CZDocusignDocumentPrefillHelper.prefillTextField('EarningRate', String.valueOf(appObj.tffa__TermDepositRate__c), signerDTO);
    CZDocusignDocumentPrefillHelper.prefillTextField(
      'Term',
      (appObj.tffa__Term__c != null &&
        appObj.tffa__TermUnit__c != null)
        ? String.valueOf(appObj.tffa__Term__c) +
          ' ' +
          CZWTFCCommonHelper.formatToCamelCase(appObj.tffa__TermUnit__c).replace(' ', '') +
          CZWTFCCommonHelper.fetchTermUnitSuffix(appObj.tffa__Term__c)
        : '',
      signerDTO
    );
    CZDocusignDocumentPrefillHelper.prefillTextField('CompoundMethod', 'credited to account', signerDTO);
    CZDocusignDocumentPrefillHelper.prefillTextField(
      'InvestmentDesc',
      appObj.tffa__product__r != null ? appObj.tffa__product__r.Name : '',
      signerDTO
    );

    if (CZWTFCCommonHelper.isCertificateProduct(appObj) && docusignRepo.productMap.containsKey(appObj.tffa__product__c)) {
      for (tffa__ProductTerm__c term : docusignRepo.productMap.get(appObj.tffa__product__c).tffa__Terms__r) {
        if (term.tffa__Code__c == appObj.tffa__TermCode__c) {
          CZDocusignDocumentPrefillHelper.prefillTextField(
            'EarningPenalty',
            term.CZPenalityInterestMonths__c +
            ' Month' +
            CZWTFCCommonHelper.fetchTermUnitSuffix(term.CZPenalityInterestMonths__c),
            signerDTO
          );
          break;
        }
      }
    } else {
      CZDocusignDocumentPrefillHelper.prefillTextField('EarningPenalty', 'None', signerDTO);
    }
  }

  public static void prefillIRAContributionDetails(tffa__Application__c appObj, CZWTFCDocusignRequestDTO.SignerDTO signerDTO) {
    Set<String> CONTRIBUTION_TYPE_1 = new Set<String>{
      'ROLLOVER',
      'DIRECTROLLOVER',
      'TRANSFER',
      'INTERNAL_TRANSFER',
      'EXTERNAL_TRANSFER',
      'INHERITED_TRANSFER',
      'CONVERSION_TO_ROTH',
      'ROTH_CONVERSION_CONTRIBUTION'
    };
    Set<String> CONTRIBUTION_TYPE_2 = new Set<String>{
      'REGULAR',
      'REGULAR_SPOUSAL_CURRENT',
      'REGULAR_SPOUSAL_PREVIOUS',
      'EMPLOYER_SEP',
      'SEP_EMPLOYER_CY',
      'SEP_EMPLOYER_PY',
      'EMPLOYER_SIMPLE',
      'ROTH_CY_CONTRIBUTION',
      'ROTH_PY_CONTRIBUTION'
    };
    Set<String> INHERITED_CONTRIBUTION_TYPE_1 = new Set<String>{ 'ROLLOVER', 'DIRECTROLLOVER' };
    Set<String> INHERITED_CONTRIBUTION_TYPE_2 = new Set<String>{
      'TRANSFER',
      'INTERNAL_TRANSFER',
      'EXTERNAL_TRANSFER',
      'INHERITED_TRANSFER'
    };

    if (appObj.tffa__InvestmentContributionType__c != null && CONTRIBUTION_TYPE_1.contains(appObj.tffa__InvestmentContributionType__c)) {
      CZDocusignDocumentPrefillHelper.prefillCheckBoxField('TYPE1', 'X', signerDTO);
    } else if (
      appObj.tffa__InvestmentContributionType__c != null && CONTRIBUTION_TYPE_2.contains(appObj.tffa__InvestmentContributionType__c)
    ) {
      CZDocusignDocumentPrefillHelper.prefillCheckBoxField('TYPE2', 'X', signerDTO);
    }

    if (appObj.tffa__IsInheritedInvestmentPlan__c) {
      if (
        appObj.tffa__InvestmentContributionType__c != null &&
        INHERITED_CONTRIBUTION_TYPE_1.contains(appObj.tffa__InvestmentContributionType__c)
      ) {
        CZDocusignDocumentPrefillHelper.prefillCheckBoxField('CONTRIBUTIONTYPE1', 'X', signerDTO);
      } else if (
        appObj.tffa__InvestmentContributionType__c != null &&
        INHERITED_CONTRIBUTION_TYPE_2.contains(appObj.tffa__InvestmentContributionType__c)
      ) {
        CZDocusignDocumentPrefillHelper.prefillCheckBoxField('CONTRIBUTIONTYPE2', 'X', signerDTO);
      }
    } else {
      if (
        appObj.tffa__InvestmentContributionType__c == 'REGULAR_SPOUSAL_CURRENT' ||
        appObj.tffa__InvestmentContributionType__c == 'ROTH_CY_CONTRIBUTION'
      ) {
        CZDocusignDocumentPrefillHelper.prefillCheckBoxField('ContributionRegularCY', 'X', signerDTO);
        CZDocusignDocumentPrefillHelper.prefillTextField(
          'ContributionRegularCYYear',
          String.valueOf(appObj.tffa__InvestmentContributionTaxYear__c),
          signerDTO
        );
        CZDocusignDocumentPrefillHelper.prefillTextField(
          'ContributionRegularCYAmount',
          CZWTFCCommonHelper.formatAmount(appObj.tffa__Amount__c),
          signerDTO
        );
      }

      if (
        appObj.tffa__InvestmentContributionType__c == 'REGULAR_SPOUSAL_PREVIOUS' ||
        appObj.tffa__InvestmentContributionType__c == 'ROTH_PY_CONTRIBUTION'
      ) {
        CZDocusignDocumentPrefillHelper.prefillCheckBoxField('ContributionRegularPY', 'X', signerDTO);
        CZDocusignDocumentPrefillHelper.prefillTextField(
          'ContributionRegularPYYear',
          String.valueOf(appObj.tffa__InvestmentContributionTaxYear__c),
          signerDTO
        );
        CZDocusignDocumentPrefillHelper.prefillTextField(
          'ContributionRegularPYAmount',
          CZWTFCCommonHelper.formatAmount(appObj.tffa__Amount__c),
          signerDTO
        );
      }

      if (appObj.tffa__InvestmentContributionType__c == 'RECHARACTERIZATION') {
        CZDocusignDocumentPrefillHelper.prefillCheckBoxField('ContributionRecharacter', 'X', signerDTO);
        CZDocusignDocumentPrefillHelper.prefillTextField(
          'ContributionRecharacterAmount',
          CZWTFCCommonHelper.formatAmount(appObj.tffa__Amount__c),
          signerDTO
        );
      }

      if (
        appObj.tffa__InvestmentContributionType__c == 'CONVERSION_TO_ROTH' ||
        appObj.tffa__InvestmentContributionType__c == 'ROTH_CONVERSION_CONTRIBUTION'
      ) {
        CZDocusignDocumentPrefillHelper.prefillCheckBoxField('ContributionRoth', 'X', signerDTO);
        CZDocusignDocumentPrefillHelper.prefillTextField(
          'ContributionRothAmount',
          CZWTFCCommonHelper.formatAmount(appObj.tffa__Amount__c),
          signerDTO
        );
      }

      if (
        appObj.tffa__InvestmentContributionType__c == 'DIVORCE' ||
        appObj.tffa__InvestmentContributionType__c == 'EXTERNAL_TRANSFER' ||
        appObj.tffa__InvestmentContributionType__c == 'INTERNAL_TRANSFER' ||
        appObj.tffa__InvestmentContributionType__c == 'INHERITED_TRANSFER'
      ) {
        CZDocusignDocumentPrefillHelper.prefillCheckBoxField('ContributionTransfer', 'X', signerDTO);
        CZDocusignDocumentPrefillHelper.prefillCheckBoxField('ContributionTransferConduit', 'X', signerDTO);
        CZDocusignDocumentPrefillHelper.prefillTextField(
          'ContributionTransferAmount',
          CZWTFCCommonHelper.formatAmount(appObj.tffa__Amount__c),
          signerDTO
        );
      }

      if (appObj.tffa__InvestmentContributionType__c == 'DIRECTROLLOVER' || appObj.tffa__InvestmentContributionType__c == 'ROLLOVER') {
        CZDocusignDocumentPrefillHelper.prefillCheckBoxField('ContributionRollover', 'X', signerDTO);
        CZDocusignDocumentPrefillHelper.prefillCheckBoxField('ContributionRolloverConduit', 'X', signerDTO);
        CZDocusignDocumentPrefillHelper.prefillTextField(
          'ContributionRolloverAmount',
          CZWTFCCommonHelper.formatAmount(appObj.tffa__Amount__c),
          signerDTO
        );
      }

      if (
        appObj.tffa__InvestmentContributionType__c == 'SEP_EMPLOYER_CY' ||
        appObj.tffa__InvestmentContributionType__c == 'SEP_EMPLOYER_PY' ||
        appObj.tffa__InvestmentContributionType__c == 'EMPLOYER_SIMPLE' ||
        appObj.tffa__InvestmentContributionType__c == 'EMPLOYER_SEP'
      ) {
        CZDocusignDocumentPrefillHelper.prefillCheckBoxField('ContributionEmployer', 'X', signerDTO);

        if (appObj.tffa__InvestmentContributionType__c == 'EMPLOYER_SIMPLE') {
          CZDocusignDocumentPrefillHelper.prefillCheckBoxField('ContributionSimple', 'X', signerDTO);
        } else {
          CZDocusignDocumentPrefillHelper.prefillCheckBoxField('ContributionSEP', 'X', signerDTO);
        }

        CZDocusignDocumentPrefillHelper.prefillTextField(
          'ContributionSEPAmount',
          CZWTFCCommonHelper.formatAmount(appObj.tffa__Amount__c),
          signerDTO
        );
      }
    }

    CZDocusignDocumentPrefillHelper.prefillTextField(
      '\\*ContributionAmount',
      CZWTFCCommonHelper.formatAmount(appObj.tffa__Amount__c),
      signerDTO
    );
    CZDocusignDocumentPrefillHelper.prefillTextField('InvestmentDescription', appObj.tffa__product__r.Name, signerDTO);
    CZDocusignDocumentPrefillHelper.prefillTextField('InvestmentAccountNumber', appObj.tffa__AccountNumber__c, signerDTO);
  }

  public static void prefillMaxsafeAccountMaintenanceDetails(
    CZDocusignRepository docusignRepo,
    CZWTFCDocusignRequestDTO.SignerDTO signerDTO,
    tffa__DisclosureParticipant__c dp
  ) {
    tffa__Application__c appObj = docusignRepo.mapApps.get(docusignRepo.currentDisclosure.tffa__LinkedApplication__c);

    Boolean noBankBlocked = true;

    if (appObj.CZMaxsafeAllocationDetailses__r != null && appObj.CZMaxsafeAllocationDetailses__r.size() > 0) {
      for (CZMaxsafeAllocationDetails__c allocationDetails : appObj.CZMaxsafeAllocationDetailses__r) {
        if (allocationDetails.IsSelected__c) {
          noBankBlocked = false;
          break;
        }
      }
    }

    if (noBankBlocked) {
      CZDocusignDocumentPrefillHelper.prefillCheckBoxField('NoBankBlocked', 'X', signerDTO);
    } else {
      for (CZMaxsafeAllocationDetails__c allocationDetails : appObj.CZMaxsafeAllocationDetailses__r) {
        prefillMaxsafeAllocationDetails(signerDTO, allocationDetails, noBankBlocked);
      }
    }
  }

  public static void prefillMaxsafeAllocationDetails(
    CZWTFCDocusignRequestDTO.SignerDTO signerDTO,
    CZMaxsafeAllocationDetails__c allocationDetails,
    Boolean noBankBlocked
  ) {
    if (allocationDetails.IsSelected__c && !noBankBlocked) {
      CZDocusignDocumentPrefillHelper.prefillCheckBoxField(allocationDetails.BrandCode__c + 'Block', 'X', signerDTO);
    } else {
      CZDocusignDocumentPrefillHelper.prefillCheckBoxField(allocationDetails.BrandCode__c + 'Unblock', 'X', signerDTO);
    }
  }

  public static void prefillBankerDetails(
    CZDocusignRepository docusignRepo,
    CZWTFCDocusignRequestDTO.SignerDTO signerDTO,
    tffa__DisclosureParticipant__c dp
  ) {
    CZDocusignDocumentPrefillHelper.prefillTextField(
      '\\*BankerName',
      docusignRepo.currentUser != null ? CZWTFCCommonHelper.formatName(docusignRepo.currentUser.Name) : '',
      signerDTO
    );
    CZDocusignDocumentPrefillHelper.prefillTextField(
      'BankerPhone',
      docusignRepo.currentUser != null ? CZWTFCCommonHelper.formatName(docusignRepo.currentUser.Phone) : '',
      signerDTO
    );
  }

  public static void prefillHSAContributionDetails(
    CZDocusignRepository docusignRepo,
    CZWTFCDocusignRequestDTO.SignerDTO signerDTO,
    tffa__DisclosureParticipant__c dp
  ) {
    tffa__Application__c appObj = docusignRepo.mapApps.get(docusignRepo.currentDisclosure.tffa__LinkedApplication__c);

    CZDocusignDocumentPrefillHelper.prefillCheckBoxField(
      'ContributionSrc' + appObj.tffa__InvestmentContributionSourceType__c,
      'X',
      signerDTO
    );
    CZDocusignDocumentPrefillHelper.prefillTextField(
      'ContributionAmount',
      CZWTFCCommonHelper.formatAmount(appObj.tffa__Amount__c),
      signerDTO
    );

    if (appObj.tffa__InvestmentContributionType__c == 'REGULAR_SPOUSAL_CURRENT') {
      CZDocusignDocumentPrefillHelper.prefillTextField(
        'Contribution1CYAmount',
        CZWTFCCommonHelper.formatAmount(appObj.tffa__Amount__c),
        signerDTO
      );
      CZDocusignDocumentPrefillHelper.prefillTextField(
        'Contribution1TaxYear',
        String.valueOf(appObj.tffa__InvestmentContributionTaxYear__c),
        signerDTO
      );
    } else if (appObj.tffa__InvestmentContributionType__c == 'REGULAR_SPOUSAL_PREVIOUS') {
      CZDocusignDocumentPrefillHelper.prefillTextField(
        'Contribution1PYAmount',
        CZWTFCCommonHelper.formatAmount(appObj.tffa__Amount__c),
        signerDTO
      );
      CZDocusignDocumentPrefillHelper.prefillTextField(
        'Contribution1TaxYear',
        String.valueOf(appObj.tffa__InvestmentContributionTaxYear__c),
        signerDTO
      );
    }

    if (
      appObj.tffa__InvestmentContributionType__c == 'INTERNAL_TRANSFER' ||
      appObj.tffa__InvestmentContributionType__c == 'EXTERNAL_TRANSFER' ||
      appObj.tffa__InvestmentContributionType__c == 'TRANSFER'
    ) {
      CZDocusignDocumentPrefillHelper.prefillTextField(
        'Contribution3CYAmount',
        CZWTFCCommonHelper.formatAmount(appObj.tffa__Amount__c),
        signerDTO
      );
    }

    if (appObj.tffa__InvestmentContributionType__c == 'ROLLOVER') {
      CZDocusignDocumentPrefillHelper.prefillTextField(
        'Contribution4CYAmount',
        CZWTFCCommonHelper.formatAmount(appObj.tffa__Amount__c),
        signerDTO
      );
    }

    if (appObj.tffa__InvestmentContributionType__c == 'REIMBURSEMENT_DEPOSIT') {
      CZDocusignDocumentPrefillHelper.prefillTextField(
        'Contribution5CYAmount',
        CZWTFCCommonHelper.formatAmount(appObj.tffa__Amount__c),
        signerDTO
      );
      CZDocusignDocumentPrefillHelper.prefillTextField(
        'Contribution5TaxYear',
        String.valueOf(appObj.tffa__InvestmentContributionTaxYear__c),
        signerDTO
      );
    }
  }

  public static void prefillOverdraftDetails(
    CZDocusignRepository docusignRepo,
    CZWTFCDocusignRequestDTO.SignerDTO signerDTO,
    tffa__DisclosureParticipant__c dp
  ) {
    tffa__Application__c appObj = docusignRepo.mapApps.get(docusignRepo.currentDisclosure.tffa__LinkedApplication__c);

    Boolean isODATMRecordExist = false;
    Boolean isODSTDRecordExist = false;
    for (tffa__AccountPreference__c accountPreference : appObj.tffa__AccountPreferences__r) {
      if (accountPreference.tffa__Code__c == CZDocusignConstants.OD_FOR_STANDARD_TRANSACTIONS && accountPreference.tffa__Enabled__c) {
        CZDocusignDocumentPrefillHelper.prefillCheckBoxField('ODStandardYes', 'X', signerDTO);
        isODSTDRecordExist = true;
      }

      if (accountPreference.tffa__Code__c == CZDocusignConstants.OD_FOR_STANDARD_TRANSACTIONS && !accountPreference.tffa__Enabled__c) {
        CZDocusignDocumentPrefillHelper.prefillCheckBoxField('ODStandardNo', 'X', signerDTO);
        isODSTDRecordExist = true;
      }

      if (
        accountPreference.tffa__Code__c == CZDocusignConstants.OD_FOR_ATM_AND_DEBIT_CARD_TRANSACTIONS && accountPreference.tffa__Enabled__c
      ) {
        CZDocusignDocumentPrefillHelper.prefillCheckBoxField('ODAtmYes', 'X', signerDTO);
        isODATMRecordExist = true;
      }

      if (
        accountPreference.tffa__Code__c == CZDocusignConstants.OD_FOR_ATM_AND_DEBIT_CARD_TRANSACTIONS && !accountPreference.tffa__Enabled__c
      ) {
        CZDocusignDocumentPrefillHelper.prefillCheckBoxField('ODAtmNo', 'X', signerDTO);
        isODATMRecordExist = true;
      }
    }

    // If OD_FOR_ATM_AND_DEBIT_CARD_TRANSACTIONS is OPT-OUT no records will be there in acc pref
    if (!isODATMRecordExist) {
      CZDocusignDocumentPrefillHelper.prefillCheckBoxField('ODAtmNo', 'X', signerDTO);
    }

    // If OD_FOR_STANDARD_TRANSACTIONS is OPT-OUT no records will be there in acc pref
    if (!isODSTDRecordExist) {
      CZDocusignDocumentPrefillHelper.prefillCheckBoxField('ODStandardNo', 'X', signerDTO);
    }
  }

  public static void prefillJuniorSaverDetails(
    CZDocusignRepository docusignRepo,
    CZWTFCDocusignRequestDTO.SignerDTO signerDTO,
    tffa__DisclosureParticipant__c dp
  ) {
    if (docusignRepo.currentDisclosure != null && docusignRepo.currentDisclosure.tffa__party__c != null) {
      tffa__Party__c partyObj = docusignRepo.mapParties.get(docusignRepo.currentDisclosure.tffa__party__c);
      prefillJuniorSaverPartyDetails(signerDTO, partyObj);
    }
  }

  public static void prefillJuniorSaverPartyDetails(CZWTFCDocusignRequestDTO.SignerDTO signerDTO, tffa__Party__c partyObj) {
    CZDocusignDocumentPrefillHelper.prefillTextField(
      'JuniorFirstName',
      CZWTFCCommonHelper.formatName(partyObj.tffa__FirstName__c),
      signerDTO
    );
    CZDocusignDocumentPrefillHelper.prefillTextField(
      'JuniorLastName',
      CZWTFCCommonHelper.formatName(partyObj.tffa__LastName__c),
      signerDTO
    );
    CZDocusignDocumentPrefillHelper.prefillTextField('\\*JuniorName', CZWTFCCommonHelper.formatName(partyObj.Name), signerDTO);
    CZDocusignDocumentPrefillHelper.prefillTextField(
      'JuniorEmergencyContactName',
      CZWTFCCommonHelper.formatName(partyObj.CZEmergencyContactName__c),
      signerDTO
    );
    CZDocusignDocumentPrefillHelper.prefillTextField('JuniorAllergies', partyObj.CZAlergies__c, signerDTO);
    prefillDateOfBirthDetails(partyObj, signerDTO, 'Junior');
    prefillPhoneNbrAndEmail(partyObj, signerDTO, 'Junior');
    prefillAddress(partyObj, signerDTO, 'Junior');

    String middleInitial = String.isNotBlank(partyObj.tffa__MiddleName__c) ? partyObj.tffa__MiddleName__c.substring(0, 1) : '-';
    CZDocusignDocumentPrefillHelper.prefillTextField('JuniorMiddleInitial', middleInitial, signerDTO);
  }

  public static String getOrdinalDay(Integer day) {
    Integer j = Math.Mod(day, 10);
    Integer k = Math.Mod(day, 100);
    if (j == 1 && k != 11) {
      return day + 'st';
    }
    if (j == 2 && k != 12) {
      return day + 'nd';
    }
    if (j == 3 && k != 13) {
      return day + 'rd';
    }
    return day + 'th';
  }

  public static String getFormattedIdentificationNumber(String identifierValue, String type) {
    if ((type == 'SSN' || type == 'TIN') && identifierValue.length() == 9) {
      String ssn1 = identifierValue.Substring(0, 3);
      String ssn2 = identifierValue.Substring(3, 5);
      String ssn3 = identifierValue.Substring(5, 9);
      return ssn1 + '-' + ssn2 + '-' + ssn3;
    } else if (type == 'EIN' && identifierValue.length() == 9) {
      String ein1 = identifierValue.Substring(0, 2);
      String ein2 = identifierValue.Substring(2, 9);
      return ein1 + '-' + ein2;
    } else {
      return identifierValue;
    }
  }
}