public with sharing class FISCCDueDiligenceServiceExtension {
  @TestVisible
  private static Boolean testException = false;

  public static void fetchCDDQuestion(List<tffa__Party__c> partyObjList) {
    tffa.Interaction.begin(FISCCDueDiligenceServiceExtension.class, 'fetchCDDQuestion');
    tffa.Logger.debug('In FISCCDueDiligenceServiceExtension.fetchCDDQuestion');
    Map<Id, Object> respMap = new Map<Id, Object>();

    try {
      List<String> partyWithCDD = CZWTFCHelperRepository.fetchPartiesWithCDD(partyObjList);
      for (tffa__Party__c partyObj : partyObjList) {
        if (
          partyObj.tffa__IsExistingCustomer__c &&
          String.isNotBlank(partyObj.Customer_Number__c) &&
          partyObj.tffa__Type__c == FISCCIntegrationConstants.ORGANIZATION &&
          !partyWithCDD.contains(partyObj.Id)
        ) {
          FISCCIntegrationLogService.setCurrentLog(partyObj.Name + '-' + FISCCIntegrationConstants.CUSTOMER_API_INQUIRES);
          if (Test.isRunningTest() && testException) {
            throw new tffa.ApplicationException('Called through test class');
          }
          FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig('FetchDueDiligence');
          if (!Test.isRunningTest()) {
            adapterConfig.ServiceURL__c = adapterConfig.ServiceURL__c.replace(
              '{CustNbr}',
              FISCCCommonHelper.encrypt(partyObj.Customer_Number__c)
            );
          }
          FISCC_Charter_Config__mdt charterConfig = FISCCIntegrationLogService.charterConfig;
          if (String.isBlank(FISCCIntegrationLogService.auth)) {
            FISCCIntegrationLogService.auth = FISCCGetAccessTokenProvider.processGetAccessToken(charterConfig);
          }

          FISCCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.FETCH_DUE_DILIGENCE_DEMOGRAPHICS, partyObj.Id, false);
          Object result = FISCCHostAdapter.processHostRequest(null, adapterConfig, charterConfig);
          if (result != null) {
            respMap.put(partyObj.Id, result);
          }
        }
      }
      parseDueDiligenceDemographicsResp(respMap);
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in fetchCDDQuestion ' + ex.getLineNumber() + ' ' + ex.getMessage());
    } finally {
      tffa.Interaction.close();
    }
  }

  public static void parseDueDiligenceDemographicsResp(Map<Id, Object> respMap) {
    tffa.Logger.debug('In parseDueDiligenceDemographicsResp');
    tffa__Questionnaire__c cddQuestions = CZWTFCHelperRepository.getCDDQuestions();
    for (Id partyId : respMap.keySet()) {
      Object resp = respMap.get(partyId);
      FISCCFetchDueDiligenceRespDTO respDto;
      if (resp instanceof FISCCFetchDueDiligenceRespDTO) {
        respDto = (FISCCFetchDueDiligenceRespDTO) resp;
      } else {
        return;
      }

      tffa__DueDiligence__c cddDueDiligence = new tffa__DueDiligence__c();
      List<tffa__DueDiligenceItem__c> ddItems = new List<tffa__DueDiligenceItem__c>();
      cddDueDiligence.Name = 'CDD';
      cddDueDiligence.tffa__Type__c = 'CDD';
      cddDueDiligence.tffa__Status__c = 'PASSED';
      cddDueDiligence.tffa__Provider__c = 'Internal';
      if (cddQuestions != null) {
        cddDueDiligence.tffa__Questionnaire__c = cddQuestions.Id;
      }
      cddDueDiligence.tffa__party__c = partyId;

      Map<String, String> questionMap = new Map<String, String>();

      for (tffa__QuestionGroupTemplate__c questionGrpTemp : cddQuestions.tffa__QuestionGroups__r) {
        for (tffa__QuestionTemplate__c questionTemp : questionGrpTemp.tffa__Questions__r) {
          if (String.isNotBlank(respDto.Entity.dueDiligenceDemographics.getValue(questionTemp.tffa__Code__c))) {
            String value = getCddValue(respDto.Entity.dueDiligenceDemographics.getValue(questionTemp.tffa__Code__c));
            if (questionTemp.tffa__AnswerType__c == 'SELECT') {
              value = value.toUpperCase();
            }
            tffa__DueDiligenceItem__c ddItem = new tffa__DueDiligenceItem__c();
            ddItem.Name = questionTemp.tffa__Label__c;
            ddItem.tffa__Code__c = questionTemp.tffa__Code__c;
            ddItem.tffa__Label__c = questionTemp.tffa__Label__c;
            ddItem.tffa__Type__c = 'QUESTION';
            ddItem.tffa__LongValue__c = value;
            ddItem.tffa__Value__c = value;
            ddItem.tffa__ValueName__c = value;
            ddItems.add(ddItem);
          }
        }
      }

      //Handle ACHTransactions & ISMSB questions
      ddItems = handleDDItemsList(ddItems, respDto);

      List<String> fisAddressCountryValues = new List<String>();
      if (respDto.Entity.incomingCountry != null && !respDto.Entity.incomingCountry.isEmpty()) {
        for (FISCCFetchDueDiligenceRespDTO.IncomingCountry incomingCountry : respDto.Entity.incomingCountry) {
          fisAddressCountryValues.add(incomingCountry.InCtryCde);
        }
      }

      if (respDto.Entity.outgoingCountry != null && !respDto.Entity.outgoingCountry.isEmpty()) {
        for (FISCCFetchDueDiligenceRespDTO.OutgoingCountry outgoingCountry : respDto.Entity.outgoingCountry) {
          fisAddressCountryValues.add(outgoingCountry.OutCtryCde);
        }
      }

      Map<String, String> tfFisMap = new Map<String, String>();
      if (!fisAddressCountryValues.isEmpty()) {
        tfFisMap = CZWTFCHelperRepository.getTFndFISMappings('AddressCountry', fisAddressCountryValues);
      }

      if (respDto.Entity.incomingCountry != null && !respDto.Entity.incomingCountry.isEmpty()) {
        tffa__DueDiligenceItem__c ddItem = new tffa__DueDiligenceItem__c();
        ddItem.Name = 'Foreign Originating Country';
        ddItem.tffa__Code__c = 'ForeignOriginatingCountry';
        ddItem.tffa__Label__c = 'Foreign Originating Country';
        ddItem.tffa__Type__c = 'QUESTION';
        ddItem.tffa__ValueType__c = 'MULTISELECT';
        for (FISCCFetchDueDiligenceRespDTO.IncomingCountry incomingCountry : respDto.Entity.incomingCountry) {
          if (ddItem.tffa__LongValue__c == null && tfFisMap.containsKey(incomingCountry.InCtryCde)) {
            ddItem.tffa__LongValue__c = tfFisMap.get(incomingCountry.InCtryCde);
            ddItem.tffa__Value__c = tfFisMap.get(incomingCountry.InCtryCde);
          } else if (tfFisMap.containsKey(incomingCountry.InCtryCde)) {
            ddItem.tffa__LongValue__c = ddItem.tffa__LongValue__c + ';' + tfFisMap.get(incomingCountry.InCtryCde);
            ddItem.tffa__Value__c = ddItem.tffa__Value__c + ';' + tfFisMap.get(incomingCountry.InCtryCde);
          }
        }
        ddItems.add(ddItem);
      }

      if (respDto.Entity.incomingCountry != null && !respDto.Entity.incomingCountry.isEmpty()) {
        tffa__DueDiligenceItem__c ddItem = new tffa__DueDiligenceItem__c();
        ddItem.Name = 'Foreign Destination Country';
        ddItem.tffa__Code__c = 'ForeignDestinationCountry';
        ddItem.tffa__Label__c = 'Foreign Destination Country';
        ddItem.tffa__Type__c = 'QUESTION';
        ddItem.tffa__ValueType__c = 'MULTISELECT';
        for (FISCCFetchDueDiligenceRespDTO.OutgoingCountry outgoingCountry : respDto.Entity.outgoingCountry) {
          if (ddItem.tffa__LongValue__c == null && tfFisMap.containsKey(outgoingCountry.OutCtryCde)) {
            ddItem.tffa__LongValue__c = tfFisMap.get(outgoingCountry.OutCtryCde);
            ddItem.tffa__Value__c = tfFisMap.get(outgoingCountry.OutCtryCde);
          } else if (tfFisMap.containsKey(outgoingCountry.OutCtryCde)) {
            ddItem.tffa__LongValue__c = ddItem.tffa__LongValue__c + ';' + tfFisMap.get(outgoingCountry.OutCtryCde);
            ddItem.tffa__Value__c = ddItem.tffa__Value__c + ';' + tfFisMap.get(outgoingCountry.OutCtryCde);
          }
        }
        ddItems.add(ddItem);
      }

      tffa.SObjectAssembler ddObjAssembler = new tffa.SObjectAssembler(cddDueDiligence);
      ddObjAssembler.setChildObjects('Items__r', ddItems);
      cddDueDiligence = (tffa__DueDiligence__c) ddObjAssembler.assemble();
      tffa.DueDiligenceService.createOrUpdate(partyId, new List<tffa__DueDiligence__c>{ cddDueDiligence });
    }
  }

  public static String getCddValue(String value) {
    if (value == 'Y') {
      return 'Yes';
    } else if (value == 'N') {
      return 'No';
    } else {
      return value;
    }
  }

  /**
   * Handle ACHTransactions & ISMSB questions
   */
  public static List<tffa__DueDiligenceItem__c> handleDDItemsList(
    List<tffa__DueDiligenceItem__c> ddItemsList,
    FISCCFetchDueDiligenceRespDTO respDto
  ) {
    tffa.Logger.debug('In handleDDItemsList');

    //ACHTransactions
    tffa__DueDiligenceItem__c ACHTransactionsItem = new tffa__DueDiligenceItem__c();
    ACHTransactionsItem.Name = FISCCIntegrationConstants.CDD_QUESTION_ACH_LABEL;
    ACHTransactionsItem.tffa__Code__c = FISCCIntegrationConstants.CDD_QUESTION_ACH_CODE;
    ACHTransactionsItem.tffa__Label__c = FISCCIntegrationConstants.CDD_QUESTION_ACH_LABEL;
    ACHTransactionsItem.tffa__Type__c = 'QUESTION';

    if (
      String.isNotBlank(respDto.Entity.dueDiligenceDemographics.OrigACHPymt) ||
      String.isNotBlank(respDto.Entity.dueDiligenceDemographics.ACHPymt)
    ) {
      ACHTransactionsItem.tffa__LongValue__c = 'Yes';
      ACHTransactionsItem.tffa__Value__c = 'Yes';
      ACHTransactionsItem.tffa__ValueName__c = 'Yes';
    } else {
      ACHTransactionsItem.tffa__LongValue__c = 'No';
      ACHTransactionsItem.tffa__Value__c = 'No';
      ACHTransactionsItem.tffa__ValueName__c = 'No';
    }
    ddItemsList.add(ACHTransactionsItem);

    //ISMSB Question
    tffa__DueDiligenceItem__c ISMSBItem = new tffa__DueDiligenceItem__c();
    ISMSBItem.Name = FISCCIntegrationConstants.CDD_QUESTION_ISMSB_LABEL;
    ISMSBItem.tffa__Code__c = FISCCIntegrationConstants.CDD_QUESTION_ISMSB_CODE;
    ISMSBItem.tffa__Label__c = FISCCIntegrationConstants.CDD_QUESTION_ISMSB_LABEL;
    ISMSBItem.tffa__Type__c = 'QUESTION';

    if (
      String.isNotBlank(respDto.Entity.dueDiligenceDemographics.MnyOrdr) ||
      String.isNotBlank(respDto.Entity.dueDiligenceDemographics.TrvlrCk) ||
      String.isNotBlank(respDto.Entity.dueDiligenceDemographics.MnyTrn) ||
      String.isNotBlank(respDto.Entity.dueDiligenceDemographics.CkCash) ||
      String.isNotBlank(respDto.Entity.dueDiligenceDemographics.CrncyExchg) ||
      String.isNotBlank(respDto.Entity.dueDiligenceDemographics.CrncyDeal) ||
      String.isNotBlank(respDto.Entity.dueDiligenceDemographics.StrVal)
    ) {
      ISMSBItem.tffa__LongValue__c = 'Yes';
      ISMSBItem.tffa__Value__c = 'Yes';
      ISMSBItem.tffa__ValueName__c = 'Yes';
    } else {
      ISMSBItem.tffa__LongValue__c = 'No';
      ISMSBItem.tffa__Value__c = 'No';
      ISMSBItem.tffa__ValueName__c = 'No';
    }
    ddItemsList.add(ISMSBItem);
    return ddItemsList;
  }
}