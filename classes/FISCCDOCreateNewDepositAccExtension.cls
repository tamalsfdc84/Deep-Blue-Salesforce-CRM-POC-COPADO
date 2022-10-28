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
      tffa__Party__c partyObj = CZWTFCCommonHelper.getAppPrimaryParty(appObjs[0], partyObjs);
      tffa__Brand__c brandObj = FISCCIntegrationLogService.brandObj;
      fisccCreateNewDepositAccountDTO.DPAcctNbrNewAcct = appObjs[0].tffa__AccountNumber__c;
      fisccCreateNewDepositAccountDTO.DPBrnch = Integer.valueOf(appObjs[0].FISBranchCode__c);
      if (appObjs[0].CostCenter__c != null) {
        fisccCreateNewDepositAccountDTO.DPCstCntr = Integer.valueOf(appObjs[0].CostCenter__c);
      }

      if (appObjs[0].tffa__PromotionCode__c != null && (!String.isBlank(appObjs[0].tffa__PromotionCode__c))) {
        if (appObjs[0].tffa__PromotionCode__c.length() > 12) {
          fisccCreateNewDepositAccountDTO.DPTrckCde = appObjs[0].tffa__PromotionCode__c.subString(0, 12);
        } else {
          fisccCreateNewDepositAccountDTO.DPTrckCde = appObjs[0].tffa__PromotionCode__c;
        }
      }

      fisccCreateNewDepositAccountDTO.DPAcctTyp = Integer.valueOf(appObjs[0].tffa__Product__r.tffa__Code__c);

      if (
        String.isNotBlank(appObjs[0].tffa__AccountPurpose__c) &&
        (appObjs[0].tffa__AccountPurpose__c == FISCCIntegrationConstants.IOLTA ||
        appObjs[0].tffa__AccountPurpose__c == FISCCIntegrationConstants.IBRETA)
      ) {
        fisccCreateNewDepositAccountDTO.DPFedTaxId = FISCCIntegrationConstants.TAX_ID_TYPE_F;
        fisccCreateNewDepositAccountDTO.DPFedTaxNbr = String.valueOf(appObjs[0].tffa__Product__r.CZIoltaIbretaTIN__c);
        fisccCreateNewDepositAccountDTO.DPIntPmtMeth = 'T';
        CZProductCharterConfig__mdt prodCharterConfig = CZProductCharterConfig__mdt.getInstance(
          FISCCIntegrationConstants.IOLTA_IBRETA_TRANSFERACCOUNT +
          '_' +
          appObjs[0].tffa__Brand__c +
          '_' +
          appObjs[0].tffa__Product__r.tffa__Code__c
        );

        if (prodCharterConfig != null) {
          fisccCreateNewDepositAccountDTO.DPTrsfrAcctNbr = prodCharterConfig.Value__c;
        }
      } else {
        if (String.isNotBlank(partyObj.tffa__NationalIdentifierValue__c)) {
          CZTerafinaFisMapping__c tfFisTaxMap = CZTerafinaFisMapping__c.getValues(
            'TaxType' +
            '_' +
            partyObj.tffa__NationalIdentifierType__c
          );
          if (tfFisTaxMap != null) {
            fisccCreateNewDepositAccountDTO.DPFedTaxId = tfFisTaxMap.FisValue__c;
          }
          fisccCreateNewDepositAccountDTO.DPFedTaxNbr = partyObj.tffa__NationalIdentifierValue__c;
        } else {
          fisccCreateNewDepositAccountDTO.DPFedTaxId = 'N';
        }
      }

      fisccCreateNewDepositAccountDTO.DPFedWithholdingInd = FISCCIntegrationConstants.DPFedWithholdingInd;

      if (String.isNotBlank(partyObj.CZPrimaryOfficer__c)) {
        fisccCreateNewDepositAccountDTO.DPPrmyOffcr = Integer.valueOf(partyObj.CZPrimaryOfficer__c);
      }
      if (String.isNotBlank(partyObj.CZSecondaryOfficer__c)) {
        fisccCreateNewDepositAccountDTO.DPScndyOffcr = Integer.valueOf(partyObj.CZSecondaryOfficer__c);
      }

      if (partyObj.tffa__Type__c == FISCCIntegrationConstants.INDIVIDUAL) {
        fisccCreateNewDepositAccountDTO.DPAcctNme = CZWTFCCommonHelper.getFormattedFullName(
          partyObj.tffa__FirstName__c,
          partyObj.tffa__MiddleName__c,
          partyObj.tffa__LastName__c,
          '',
          24
        );
      } else {
        fisccCreateNewDepositAccountDTO.DPAcctNme = CZWTFCCommonHelper.getFormattedFullName(partyObj.tffa__LegalName__c, '', '', '', 24);
      }

      if (
        FISCCIntegrationConstants.IRA_PRODUCT_CATEGORY.equalsIgnoreCase(appObjs[0].tffa__ProductCategory__c) ||
        FISCCIntegrationConstants.HSA_PRODUCT_CATEGORY.equalsIgnoreCase(appObjs[0].tffa__ProductCategory__c) ||
        partyObj.tffa__Type__c == FISCCIntegrationConstants.INDIVIDUAL
      ) {
        fisccCreateNewDepositAccountDTO.DPBirthdate = partyObj.tffa__BirthDate__c;
      }

      fisccCreateNewDepositAccountDTO = populateStatusCode(fisccCreateNewDepositAccountDTO, appObjs[0]);

      if (FISCCIntegrationLogService.partyObjMap.values() != null) {
        for (tffa__Party__c party : FISCCIntegrationLogService.partyObjMap.values()) {
          if (party.IsExceptionPlanRequired__c) {
            fisccCreateNewDepositAccountDTO.DPFundsAEP = FISCCIntegrationConstants.NEW_ACCOUNT_EXCEPTION_PLAN_CODE;
          }
        }
      }

      if (FISCCCommonHelper.validateStandardODAddOn(appObjs[0])) {
        fisccCreateNewDepositAccountDTO.DPExcpPlnNbr = FISCCIntegrationConstants.OD_FOR_STANDARD_ADDON_EXCPPLNNBR;
      }

      if (FISCCIntegrationConstants.IRA_PRODUCT_CATEGORY.equalsIgnoreCase(appObjs[0].tffa__ProductCategory__c)) {
        fisccCreateNewDepositAccountDTO.DPRetPlnNbr = appObjs[0].tffa__InvestmentPlanNumber__c;

        CZTerafinaFisMapping__c tfFisInvestmentPlanTypeMap = CZTerafinaFisMapping__c.getValues(
          'InvestmentPlanType' +
          '_' +
          appObjs[0].tffa__InvestmentPlanType__c
        );
        fisccCreateNewDepositAccountDTO.DPRetPlnTyp = Integer.valueOf(tfFisInvestmentPlanTypeMap.FisValue__c);
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

  public static FISCCCreateNewDepositAccDTO populateStatusCode(
    FISCCCreateNewDepositAccDTO fisccCreateNewDepositAccountDTO,
    tffa__Application__c appObj
  ) {
    String statusCode = '';
    if (String.isNotBlank(appObj.CZStatusCode1__c)) {
      statusCode = appObj.CZStatusCode1__c;
    }
    if (String.isNotBlank(appObj.CZStatusCode2__c)) {
      statusCode = statusCode + appObj.CZStatusCode2__c;
    }
    if (String.isNotBlank(appObj.CZStatusCode3__c)) {
      statusCode = statusCode + appObj.CZStatusCode3__c;
    }
    if (String.isNotBlank(statusCode)) {
      fisccCreateNewDepositAccountDTO.DPStatCodes = statusCode;
    }
    return fisccCreateNewDepositAccountDTO;
  }
}