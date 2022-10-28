public with sharing class FISCCDOCreateNewDepositAccExtension {
  public static FISCCCreateNewDepositAccDTO createNewDepositAccountRequest(
    List<tffa__Party__c> partyObjs,
    List<tffa__Application__c> appObjs,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    FISCCDepositOriginationRequestBaseDTO fisccDepositOriginationRequestBaseDTO = null;
    FISCCDOCreateNewDepositAccRequest objFISCCDOCreateNewDepositAccountRequest = new FISCCDOCreateNewDepositAccRequest();

    FISCCCreateNewDepositAccDTO fisccCreateNewDepositAccountDTO = new FISCCCreateNewDepositAccDTO();

    try {
      tffa.Logger.debug('Inside newDepositAccountRequest method');
      tffa__Party__c partyObj = CZWTFCCommonHelper.getPrimaryParty(FISCCIntegrationLogService.submissionObj, partyObjs);
      tffa__Brand__c brandObj = FISCCIntegrationLogService.brandObj;
      //FISCCIntegrationLogService.setPartyObjs();
      fisccCreateNewDepositAccountDTO.DPAcctNbrNewAcct = FISCCIntegrationConstants.DUMMY_ACCT_NUMBER;
      fisccCreateNewDepositAccountDTO.DPBrnch = Integer.valueOf(appObjs[0].FISBranchCode__c);
      fisccCreateNewDepositAccountDTO.DPCstCntr = Integer.valueOf(appObjs[0].CostCenter__c);

      // DateTime startDate = Date.Today();
      // fisccCreateNewDepositAccountDTO.RmrkExpDte = startDate.addMonths(FISCCIntegrationConstants.REMARK_MONTHS_TO_ADD).format('yyyy-dd-MM');
      // fisccCreateNewDepositAccountDTO.RmrkLne01 = FISCCIntegrationConstants.ACCOUNT_OPENED_ONLINE;
      // fisccCreateNewDepositAccountDTO.CIRmrkMaintSrcInd = FISCCIntegrationConstants.REMARK_IDENTITY;

      if (appObjs[0].tffa__PromotionCode__c != null && (!String.isBlank(appObjs[0].tffa__PromotionCode__c))) {
        if (appObjs[0].tffa__PromotionCode__c.length() > 12) {
          fisccCreateNewDepositAccountDTO.DPTrckCde = appObjs[0].tffa__PromotionCode__c.subString(0, 12);
        } else {
          fisccCreateNewDepositAccountDTO.DPTrckCde = appObjs[0].tffa__PromotionCode__c;
        }
      }

      fisccCreateNewDepositAccountDTO.DPAcctTyp = Integer.valueOf(appObjs[0].tffa__Product__r.tffa__Code__c);
      if (String.isNotBlank(partyObj.tffa__NationalIdentifierValue__c)) {
        fisccCreateNewDepositAccountDTO.DPFedTaxId = FISCCIntegrationConstants.DPFedTaxId;
        fisccCreateNewDepositAccountDTO.DPFedTaxNbr = partyObj.tffa__NationalIdentifierValue__c;
      } else {
        fisccCreateNewDepositAccountDTO.DPFedTaxId = 'N';
      }

      fisccCreateNewDepositAccountDTO.DPFedWithholdingInd = FISCCIntegrationConstants.DPFedWithholdingInd;

      if (brandObj != null && !String.isBlank(brandObj.CIPrmyOffcrNbr__c)) {
        fisccCreateNewDepositAccountDTO.DPPrmyOffcr = Integer.valueOf(brandObj.CIPrmyOffcrNbr__c);
      }

      fisccCreateNewDepositAccountDTO.DPAcctNme = CZWTFCCommonHelper.getFormattedFullName(
        partyObj.tffa__FirstName__c,
        partyObj.tffa__MiddleName__c,
        partyObj.tffa__LastName__c,
        '',
        24
      );
      fisccCreateNewDepositAccountDTO.DPBirthdate = partyObj.tffa__BirthDate__c;
      if ('CHECKING'.equals(appObjs[0].tffa__Product__r.tffa__Category__c) || appObjs[0].tffa__Product__r.IsMoneyMarketProduct__c) {
        fisccCreateNewDepositAccountDTO.DPStatCodes = FISCCIntegrationConstants.CHECKING_STAT_CODES;
      } else {
        fisccCreateNewDepositAccountDTO.DPStatCodes = FISCCIntegrationConstants.SAVINGS_STAT_CODES;
      }

      if (FISCCIntegrationLogService.partyObjs != null) {
        for (tffa__Party__c party : FISCCIntegrationLogService.partyObjs) {
          if (party.IsExceptionPlanRequired__c) {
            fisccCreateNewDepositAccountDTO.DPFundsAEP = FISCCIntegrationConstants.NEW_ACCOUNT_EXCEPTION_PLAN_CODE;
          }
        }
      }

      if (FISCCCommonHelper.validateStandardODAddOn(appObjs[0])) {
        fisccCreateNewDepositAccountDTO.DPExcpPlnNbr = FISCCIntegrationConstants.OD_FOR_STANDARD_ADDON_EXCPPLNNBR;
      }

      tffa.logger.debug(
        'FISCCDOCreateNewDepositAccountRequestExtension : fisccDepositOriginationRequestBaseDTO ==> ' +
        fisccDepositOriginationRequestBaseDTO
      );
    } catch (Exception ex) {
      tffa.Logger.error('Exception in invokeCEBEnroll : ' + +ex.getMessage() + ' Exception:::' + ex.getStackTraceString());
      return null;
    }
    tffa.logger.debug(
      'FISCCDOCreateNewDepositAccountRequestExtension : fisccDepositOriginationRequestBaseDTO1 ==>' + fisccCreateNewDepositAccountDTO
    );
    return fisccCreateNewDepositAccountDTO;
  }
}