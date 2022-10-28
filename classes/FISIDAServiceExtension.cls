public with sharing class FISIDAServiceExtension {
  public static FISIDARequestDTO idaFetchOOWRequestDto = new FISIDARequestDTO();
  public static FISIDAVerifyRequestDTO idaVerifyReqDto = new FISIDAVerifyRequestDTO();

  @TestVisible
  private static boolean testException = false;

  public static object getOOWQuestions(
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
        fisccRequestBaseDTO = generateFetchOOWQuestionsReq(partyObj, adapterConfig, charterConfig);
        FISCCIntegrationLogService.applicationCode = 'DSS';
        result = FISCCHostAdapter.processHostRequest(fisccRequestBaseDTO, adapterConfig, charterConfig);
        tffa.Logger.debug('IDA fetch OOW Question Response: ' + result);
      }
      return result;
    } catch (Exception ex) {
      tffa.Logger.error('Error in fetching OOW questions: ' + ex.getStackTraceString() + ' Message ::: ' + ex.getMessage());
    }
    return null;
  }

  public static Object verifyOOWAnswers(
    tffa__party__c partyObj,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig,
    tffa__DueDiligence__c ddIDA
  ) {
    FISCCRequestBaseDTO fisccRequestBaseDTO = null;
    Object result = null;

    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }

      if (partyObj != null) {
        fisccRequestBaseDTO = generateVerifyOOWQuestionsReq(partyObj, adapterConfig, charterConfig, ddIDA);
        FISCCIntegrationLogService.applicationCode = 'DSS';
        result = FISCCHostAdapter.processHostRequest(fisccRequestBaseDTO, adapterConfig, charterConfig);
        tffa.Logger.debug('IDA verify OOW Question Response: ' + result);
      }
      return result;
    } catch (Exception ex) {
      tffa.Logger.error('Error in verify OOW questions: ' + ex.getStackTraceString() + ' Message ::: ' + ex.getMessage());
    }
    return null;
  }

  // two calls ---> generate ques
  //

  public static FISCCRequestBaseDTO generateFetchOOWQuestionsReq(
    tffa__Party__c partyObj,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    tffa.Logger.debug('Inside generateFetchOOWQuestionsReq method');
    FISCCRequestBaseDTO fisccRequestBaseDTO = null;
    FISDSSConfig__mdt idaConfig = CZWTFCHelperRepository.fetchDSSConfig('IDA');

    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      if (partyObj != null) {
        // set ida identification data
        idaFetchOOWRequestDto.idaIdentification.acquirerid = idaConfig.AcquirerId__c;
        idaFetchOOWRequestDto.idaIdentification.configkey = idaConfig.ConfigKey__c;
        idaFetchOOWRequestDto.idaIdentification.customerid = charterConfig.CustomerId__c;
        idaFetchOOWRequestDto.idaIdentification.locationid = charterConfig.LocationId__c;
        idaFetchOOWRequestDto.idaIdentification.productcd = idaConfig.ProductCd__c;
        idaFetchOOWRequestDto.idaIdentification.productversion = idaConfig.ProductVersion__c;
        idaFetchOOWRequestDto.idaIdentification.staging = idaConfig.IsStaging__c;
        idaFetchOOWRequestDto.idaIdentification.aqr = idaConfig.Aqr__c;
        idaFetchOOWRequestDto.idaIdentification.instancecd = idaConfig.InstanceCd__c;
        idaFetchOOWRequestDto.idaIdentification.msgUuid = idaConfig.MsgUuid__c;

        //set party information
        if (partyObj.tffa__AddressXrefs__r[0] != null) {
          idaFetchOOWRequestDto.idaPerson.address = (partyObj.tffa__AddressXrefs__r[0].tffa__Address__r.tffa__Line1__c).abbreviate(24);
          idaFetchOOWRequestDto.idaPerson.city = (partyObj.tffa__AddressXrefs__r[0].tffa__Address__r.tffa__City__c).abbreviate(19);
          idaFetchOOWRequestDto.idaPerson.state = partyObj.tffa__AddressXrefs__r[0].tffa__Address__r.tffa__State__c;
          idaFetchOOWRequestDto.idaPerson.zip = formatZipCode(
            String.valueOf(partyObj.tffa__AddressXrefs__r[0].tffa__Address__r.tffa__ZipCode__c)
          );
        }

        idaFetchOOWRequestDto.idaPerson.dob = formatBirthDate(partyObj.tffa__BirthDate__c);
        idaFetchOOWRequestDto.idaPerson.firstName = (partyObj.tffa__FirstName__c).abbreviate(12);
        idaFetchOOWRequestDto.idaPerson.lastName = (partyObj.tffa__LastName__c).abbreviate(20);
        idaFetchOOWRequestDto.idaPerson.middleName = partyObj.tffa__MiddleName__c != null
          ? (partyObj.tffa__MiddleName__c).substring(0, 1)
          : '';
        idaFetchOOWRequestDto.idaPerson.govtNbr = partyObj.tffa__NationalIdentifierValue__c;
      }
    } catch (Exception ex) {
      tffa.Logger.error(' Exception into generateFetchOOWQuestionsReq :::' + ex.getMessage() + ' Exception:::' + ex.getStackTraceString());
      return null;
    }
    fisccRequestBaseDTO = idaFetchOOWRequestDto;
    return fisccRequestBaseDTO;
  }

  public static FISCCRequestBaseDTO generateVerifyOOWQuestionsReq(
    tffa__Party__c partyObj,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig,
    tffa__DueDiligence__c ddIDA
  ) {
    tffa.Logger.debug('Inside generateFetchOOWQuestionsReq method');
    FISCCRequestBaseDTO fisccRequestBaseDTO = null;
    FISDSSConfig__mdt idaConfig = CZWTFCHelperRepository.fetchDSSConfig('IDA');
    tffa__DueDiligence__c dueDiligence;
    List<tffa__DueDiligence__c> ddList = new List<tffa__DueDiligence__c>();
    ddList = CZWTFCHelperRepository.getDueDiligenceList(partyObj.Id);

    if (partyObj.tffa__IDAStatus__c.equals('CHALLENGED') && ddList != null && ddIDA == null) {
      for (tffa__DueDiligence__c dd : ddList) {
        if (dd.tffa__Type__c.equals('IDA')) {
          dueDiligence = dd;
        }
      }
    } else {
      dueDiligence = ddIDA;
    }

    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      if (partyObj != null) {
        // set ida identification data
        idaVerifyReqDto.idaIdentification.acquirerid = idaConfig.AcquirerId__c;
        idaVerifyReqDto.idaIdentification.configkey = idaConfig.ConfigKey__c;
        idaVerifyReqDto.idaIdentification.customerid = charterConfig.CustomerId__c;
        idaVerifyReqDto.idaIdentification.locationid = charterConfig.LocationId__c;
        idaVerifyReqDto.idaIdentification.productcd = idaConfig.ProductCd__c;
        idaVerifyReqDto.idaIdentification.productversion = idaConfig.ProductVersion__c;
        idaVerifyReqDto.idaIdentification.staging = idaConfig.IsStaging__c;
        idaVerifyReqDto.idaIdentification.aqr = idaConfig.Aqr__c;
        idaVerifyReqDto.idaIdentification.instancecd = idaConfig.InstanceCd__c;
        idaVerifyReqDto.idaIdentification.msgUuid = idaConfig.MsgUuid__c;

        //set ans information
        if (dueDiligence != null) {
          idaVerifyReqDto.ans.quizId = dueDiligence.tffa__ExternalQuestionnaireId__c;
          idaVerifyReqDto.ans.transId = dueDiligence.tffa__ConversationId__c;
          Integer counter = 0;
          for (tffa__DueDiligenceItem__c ddItem : dueDiligence.tffa__Items__r) {
            counter++;
            if (counter == 1) {
              idaVerifyReqDto.ans.answer1QuestionId = ddItem.tffa__Code__c;
              idaVerifyReqDto.ans.answer1ResponseId = ddItem.tffa__Value__c;
            } else if (counter == 2) {
              idaVerifyReqDto.ans.answer2QuestionId = ddItem.tffa__Code__c;
              idaVerifyReqDto.ans.answer2ResponseId = ddItem.tffa__Value__c;
            } else if (counter == 3) {
              idaVerifyReqDto.ans.answer3QuestionId = ddItem.tffa__Code__c;
              idaVerifyReqDto.ans.answer3ResponseId = ddItem.tffa__Value__c;
            } else if (counter == 4) {
              idaVerifyReqDto.ans.answer4QuestionId = ddItem.tffa__Code__c;
              idaVerifyReqDto.ans.answer4ResponseId = ddItem.tffa__Value__c;
            } else if (counter == 5) {
              idaVerifyReqDto.ans.answer5QuestionId = ddItem.tffa__Code__c;
              idaVerifyReqDto.ans.answer5ResponseId = ddItem.tffa__Value__c;
            } else if (counter == 6) {
              idaVerifyReqDto.ans.answer6QuestionId = ddItem.tffa__Code__c;
              idaVerifyReqDto.ans.answer6ResponseId = ddItem.tffa__Value__c;
            } else if (counter == 7) {
              idaVerifyReqDto.ans.answer7QuestionId = ddItem.tffa__Code__c;
              idaVerifyReqDto.ans.answer7ResponseId = ddItem.tffa__Value__c;
            } else if (counter == 8) {
              idaVerifyReqDto.ans.answer8QuestionId = ddItem.tffa__Code__c;
              idaVerifyReqDto.ans.answer8ResponseId = ddItem.tffa__Value__c;
            } else if (counter == 9) {
              idaVerifyReqDto.ans.answer9QuestionId = ddItem.tffa__Code__c;
              idaVerifyReqDto.ans.answer9ResponseId = ddItem.tffa__Value__c;
            }
          }
        }
      }
    } catch (Exception ex) {
      tffa.Logger.error(' Exception into generateFetchOOWQuestionsReq :::' + ex.getMessage() + ' Exception:::' + ex.getStackTraceString());
      return null;
    }
    fisccRequestBaseDTO = idaVerifyReqDto;
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
}