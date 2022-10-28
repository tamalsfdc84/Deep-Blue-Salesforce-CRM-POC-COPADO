public with sharing class FISIDVServiceExtension {
  public static FISIDVRequestDTO idvRequestDto = new FISIDVRequestDTO();

  @TestVisible
  private static boolean testException = false;

  public static object doIDVApiCall(
    tffa__party__c partyObj,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    FISCCRequestBaseDTO fisccRequestBaseDTO = null;
    Object result = null;

    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }

      if (partyObj != null) {
        fisccRequestBaseDTO = generateIDVRequest(partyObj, adapterConfig, charterConfig);
        FISCCIntegrationLogService.applicationCode = 'DSS';
        result = FISCCHostAdapter.processHostRequest(fisccRequestBaseDTO, adapterConfig, charterConfig);
        tffa.Logger.debug('IDV Response: ' + result);
      }
      return result;
    } catch (Exception ex) {
      tffa.Logger.error('Error in fetching IDV resp: ' + ex.getStackTraceString() + ' Message ::: ' + ex.getMessage());
    }
    return null;
  }

  public static FISCCRequestBaseDTO generateIDVRequest(
    tffa__Party__c partyObj,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    tffa.Logger.debug('Inside generateIDVRequest method');
    FISCCRequestBaseDTO fisccRequestBaseDTO = null;
    tffa.logger.debug('partyObj in generateIDVRequest ==>' + partyObj);
    FISDSSConfig__mdt idvConfig = CZWTFCHelperRepository.fetchDSSConfig('IDV');

    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      if (partyObj != null) {
        tffa.Logger.debug('inside party not null ');

        // set ida identification data
        idvRequestDto.custIdent.acquirerid = idvConfig.AcquirerId__c;
        idvRequestDto.custIdent.customerid = charterConfig.CustomerId__c;
        idvRequestDto.custIdent.aqr = Boolean.valueOf(idvConfig.Aqr__c);
        idvRequestDto.custIdent.includechexsystems = idvConfig.IncludeChexSystems__c;
        idvRequestDto.custIdent.includeidentitymanager = idvConfig.IncludeIdentityManager__c;
        idvRequestDto.custIdent.includeofac = idvConfig.IncludeOfac__c;
        idvRequestDto.custIdent.includequalifile = idvConfig.IncludeQualifile__c;
        idvRequestDto.custIdent.locationid = charterConfig.LocationId__c;
        idvRequestDto.custIdent.qualifileversionnbr = idvConfig.QualifileVersionNbr__c;
        idvRequestDto.custIdent.staging = idvConfig.IsStaging__c;
        idvRequestDto.custIdent.strategytypeid = idvConfig.StrategyTypeId__c;
        idvRequestDto.custIdent.reportdatatype = Integer.valueOf(idvConfig.ReportDataType__c);
        idvRequestDto.custIdent.instancecd = idvConfig.InstanceCd__c;
        idvRequestDto.custIdent.industrymarketcode = idvConfig.IndustryMarketCode__c;

        //set party information
        if (partyObj.tffa__AddressXrefs__r[0] != null && !partyObj.tffa__AddressXrefs__r.isEmpty()) {
          idvRequestDto.personQry.streetaddresstxt = partyObj.tffa__AddressXrefs__r[0].tffa__Address__r.tffa__Line1__c != null
            ? (partyObj.tffa__AddressXrefs__r[0].tffa__Address__r.tffa__Line1__c).abbreviate(24)
            : '';
          idvRequestDto.personQry.citynm = partyObj.tffa__AddressXrefs__r[0].tffa__Address__r.tffa__City__c != null
            ? (partyObj.tffa__AddressXrefs__r[0].tffa__Address__r.tffa__City__c).abbreviate(19)
            : '';
          idvRequestDto.personQry.statecd = partyObj.tffa__AddressXrefs__r[0].tffa__Address__r.tffa__State__c;

          if (partyObj.tffa__AddressXrefs__r[0].tffa__Address__r.tffa__ZipCode__c != null) {
            idvRequestDto.personQry.postalplusfourcd = formatZipCode(
              String.valueOf(partyObj.tffa__AddressXrefs__r[0].tffa__Address__r.tffa__ZipCode__c)
            );
          }

          idvRequestDto.personQry.countrynm = partyObj.tffa__AddressXrefs__r[0].tffa__Address__r.tffa__Country__c;
        }

        //set identification information
        if (
          partyObj.tffa__Identifications__r != null &&
          !partyObj.tffa__Identifications__r.isEmpty() &&
          partyObj.tffa__Identifications__r[0] != null
        ) {
          if (
            partyObj.tffa__Identifications__r[0].tffa__Type__c.equalsIgnoreCase('DL') ||
            partyObj.tffa__Identifications__r[0].tffa__Type__c.equalsIgnoreCase('StateID')
          ) {
            idvRequestDto.personQry.identificationstatenbr = partyObj.tffa__Identifications__r[0].tffa__IdentificationNumber__c;
            idvRequestDto.personQry.identificationstatecd = partyObj.tffa__Identifications__r[0].tffa__IssuingState__c;
          }
        }

        idvRequestDto.personQry.birthdt = formatBirthDate(partyObj.tffa__BirthDate__c);
        idvRequestDto.personQry.firstnm = (partyObj.tffa__FirstName__c).abbreviate(12);
        idvRequestDto.personQry.lastnm = (partyObj.tffa__LastName__c).abbreviate(20);
        idvRequestDto.personQry.middlenm = partyObj.tffa__MiddleName__c != null ? (partyObj.tffa__MiddleName__c).substring(0, 1) : '';
        idvRequestDto.personQry.governmentnbr = partyObj.tffa__NationalIdentifierValue__c;

        if (partyObj.PreferredContactNumber__c.equalsIgnoreCase('CELL')) {
          idvRequestDto.personQry.compositephonenbr = formatPhoneNumber(partyObj.CellPhoneNumber__c);
        } else if (partyObj.PreferredContactNumber__c.equalsIgnoreCase('HOME')) {
          idvRequestDto.personQry.compositephonenbr = formatPhoneNumber(partyObj.tffa__PrimaryPhone__c);
        } else if (partyObj.PreferredContactNumber__c.equalsIgnoreCase('WORK')) {
          idvRequestDto.personQry.compositephonenbr = formatPhoneNumber(partyObj.tffa__SecondaryPhone__c);
        }
      }
    } catch (Exception ex) {
      tffa.Logger.error(' Exception into generateIDVRequest :::' + ex.getMessage() + ' Exception:::' + ex.getStackTraceString());
      return null;
    }
    fisccRequestBaseDTO = idvRequestDto;
    return fisccRequestBaseDTO;
  }

  public static String formatBirthDate(Date birthDate) {
    String month = String.valueof(birthDate.month());
    String day = String.valueof(birthDate.day());
    if (month.length() == 1) {
      month = '0' + month;
    }
    if (day.length() == 1) {
      day = '0' + day;
    }
    return month + day + String.valueof(birthDate.year());
  }

  public static String formatZipCode(String zipCode) {
    if (zipCode.length() > 5) {
      return zipCode.replace('-', '');
    } else {
      return zipCode;
    }
  }

  public static String formatPhoneNumber(String phone) {
    return phone.replace('+1', '');
  }
}