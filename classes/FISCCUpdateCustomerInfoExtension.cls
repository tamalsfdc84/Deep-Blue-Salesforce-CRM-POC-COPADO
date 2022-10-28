public with sharing class FISCCUpdateCustomerInfoExtension {
  public static List<FISCCDepositOriginationRequestBaseDTO> generatePhnEmailDelReq(tffa__Party__c partyObj) {
    List<FISCCDepositOriginationRequestBaseDTO> reqList = new List<FISCCDepositOriginationRequestBaseDTO>();

    if (partyObj.CZFisEmail__c != null && partyObj.CZFisEmail__c != partyObj.tffa__PrimaryEmail__c) {
      FISCCCreateEmailAddressesDTO objFISCCCreateEmailAddressesDTO = new FISCCCreateEmailAddressesDTO();
      List<FISCCCreateEmailAddressesDTO> lstFISCCCreateEmailAddressesDTO = new List<FISCCCreateEmailAddressesDTO>();
      FISCCDOCustomerEmailRequest objFISCCDOCustomerEmailRequest = new FISCCDOCustomerEmailRequest();
      objFISCCCreateEmailAddressesDTO.AddDelInd = 'D';
      objFISCCCreateEmailAddressesDTO.ResnCde = 'PRI';
      objFISCCCreateEmailAddressesDTO.EffDte = partyObj.CZFisEmailEffDt__c;
      lstFISCCCreateEmailAddressesDTO.add(objFISCCCreateEmailAddressesDTO);
      objFISCCDOCustomerEmailRequest.customerEmail.emailAddressLst = lstFISCCCreateEmailAddressesDTO;
      objFISCCDOCustomerEmailRequest.customerEmail.CustNbr = partyObj.Customer_Number__c;
      objFISCCDOCustomerEmailRequest.SvcID = FISCCIntegrationConstants.SVCID_CustomerEmail;
      reqList.add(objFISCCDOCustomerEmailRequest);
    }

    if (checkFISContactNumberIsPresentForDelete(partyObj, 'All')) {
      FISCCCreatePhoneNumberDTO objprimaryPhneDTO = new FISCCCreatePhoneNumberDTO();
      FISCCCreatePhoneNumberDTO objWrkPhneDTO = new FISCCCreatePhoneNumberDTO();
      FISCCCreatePhoneNumberDTO objCellPhneDTO = new FISCCCreatePhoneNumberDTO();
      List<FISCCCreatePhoneNumberDTO> lstFISCCCreatePhoneNumberDTO = new List<FISCCCreatePhoneNumberDTO>();
      FISCCDOPhoneNumberRequest objFISCCDOPhoneNumberRequest = new FISCCDOPhoneNumberRequest();

      if (checkFISContactNumberIsPresentForDelete(partyObj, 'Home')) {
        objprimaryPhneDTO.AddDelInd = 'D';
        if (partyObj.tffa__Type__c == FISCCIntegrationConstants.INDIVIDUAL) {
          objprimaryPhneDTO.ResnCde = 'HME';
        } else {
          objprimaryPhneDTO.ResnCde = 'PRI';
        }

        objprimaryPhneDTO.EffDte = partyObj.CZFisHomeNbrEffDt__c;
        lstFISCCCreatePhoneNumberDTO.add(objprimaryPhneDTO);
      }

      if (checkFISContactNumberIsPresentForDelete(partyObj, 'Work')) {
        objWrkPhneDTO.AddDelInd = 'D';
        if (partyObj.tffa__Type__c == FISCCIntegrationConstants.INDIVIDUAL) {
          objWrkPhneDTO.ResnCde = 'WRK';
        } else {
          objWrkPhneDTO.ResnCde = 'SEC';
        }
        objWrkPhneDTO.EffDte = partyObj.CZFisWorkNbrEffDt__c;
        lstFISCCCreatePhoneNumberDTO.add(objWrkPhneDTO);
      }

      if (checkFISContactNumberIsPresentForDelete(partyObj, 'Cell')) {
        objCellPhneDTO.AddDelInd = 'D';
        objCellPhneDTO.ResnCde = 'MBL';
        objCellPhneDTO.EffDte = partyObj.CZFisCellNbrEffDt__c;
        lstFISCCCreatePhoneNumberDTO.add(objCellPhneDTO);
      }

      objFISCCDOPhoneNumberRequest.custPhoneNumber.CustNbr = partyObj.Customer_Number__c;
      objFISCCDOPhoneNumberRequest.SvcID = 'CI051';
      objFISCCDOPhoneNumberRequest.custPhoneNumber.phoneNumLst = lstFISCCCreatePhoneNumberDTO;
      reqList.add(objFISCCDOPhoneNumberRequest);
    }
    return reqList;
  }

  public static FISCCDepositOriginationRequestBaseDTO genUpdateCustomerDueDiligenceReq(tffa__Party__c partyObj) {
    FISCCDepositOriginationRequestBaseDTO fisccDepositOriginationRequestBaseDTO = null;
    FISCCDOCustomerDDRequest baseddReq = new FISCCDOCustomerDDRequest();
    if (partyObj.tffa__Employments__r != null && !partyObj.tffa__Employments__r.isEmpty()) {
      baseddReq.dueDiligenceReq.dueDiligenceDemographics.OccpnDesc = CZWTFCCommonHelper.getOccupationLabel(
        partyObj.tffa__Employments__r[0].OccupationType__c
      );
      if (String.isNotBlank(partyObj.tffa__Employments__r[0].tffa__Title__c)) {
        baseddReq.dueDiligenceReq.dueDiligenceDemographics.Title = partyObj.tffa__Employments__r[0].tffa__Title__c;
      } else {
        baseddReq.dueDiligenceReq.dueDiligenceDemographics.Title = '';
      }
      if (partyObj.tffa__Employments__r[0].tffa__Type__c == 'RETIRED') {
        baseddReq.dueDiligenceReq.dueDiligenceDemographics.FullTime = 'R';
      } else if (partyObj.tffa__Employments__r[0].tffa__Type__c == 'UNEMPLOYED') {
        baseddReq.dueDiligenceReq.dueDiligenceDemographics.FullTime = 'U';
      }
    }

    if (partyObj.tffa__Type__c == FISCCIntegrationConstants.INDIVIDUAL && partyObj.tffa__Citizenship__c == CZWTFCConstants.RESIDENT) {
      baseddReq.dueDiligenceReq.dueDiligenceDemographics.RsdntPrsn = 'Y';
    }

    if (partyObj.tffa__Type__c == FISCCIntegrationConstants.ORGANIZATION) {
      if (String.isNotBlank(partyObj.tffa__BusinessDescription__c)) {
        baseddReq.dueDiligenceReq.dueDiligenceDemographics.DescBus = partyObj.tffa__BusinessDescription__c;
      }
      if (FISCCIntegrationLogService.cddObjMap.containsKey(partyObj.Id)) {
        baseddReq = FISCCCustomerDDExtension.setCDDQuestions(partyObj, baseddReq);
      }
      //baseddReq.dueDiligenceReq.dueDiligenceDemographics.UsrDefFld22 = partyObj.CZIsCIPExempt__c ? 'Y' : 'N';
    }

    baseddReq.dueDiligenceReq.dueDiligenceDemographics.CustNbr = partyObj.Customer_Number__c;
    fisccDepositOriginationRequestBaseDTO = baseddReq;
    fisccDepositOriginationRequestBaseDTO.SvcID = FISCCIntegrationConstants.SVCID_DueDiligence;
    return fisccDepositOriginationRequestBaseDTO;
  }

  public static FISCCDepositOriginationRequestBaseDTO genUpdateCustomerDemographicsReq(tffa__Party__c partyObj) {
    tffa.Logger.debug('In genUpdateCustomerDueDiligenceReq');
    FISCCDepositOriginationRequestBaseDTO fisccDepositOriginationRequestBaseDTO = null;
    FISCCDOIndividualDemoRequest individualDemo = new FISCCDOIndividualDemoRequest();
    FISCCDOOrganizationDemoRequest organizationDemo = new FISCCDOOrganizationDemoRequest();

    List<String> codeList = new List<String>();
    if (partyObj.CZFisCustCodes__c != null) {
      codeList = partyObj.CZFisCustCodes__c.split(',');
    }
    tffa.Logger.debug('codeList ' + codeList + '  ' + codeList.contains('2'));
    if (partyObj.tffa__IsEmployee__c && !codeList.contains('2')) {
      codeList.add('002');
    }
    if (!partyObj.tffa__IsEmployee__c && codeList.contains('2')) {
      codeList = removeEmployeeCode(codeList);
    }
    if (FISCCCommonHelper.isPlatinumMemberShipCustomer(partyObj) && !codeList.contains('30')) {
      codeList.add('030');
    }
    if (FISCCCommonHelper.isJuniorSaverMember(partyObj) && !codeList.contains('18')) {
      codeList.add('018');
    }

    if (partyObj.tffa__Type__c == FISCCIntegrationConstants.INDIVIDUAL) {
      individualDemo.individualDemographics.CIApplNbr = partyObj.Customer_Number__c;

      individualDemo.individualDemographics.CICustDteOfBrth = String.valueOf(partyObj.tffa__BirthDate__c);
      individualDemo = FISCCCommonHelper.setIdentityInfo(partyObj, individualDemo);

      individualDemo.individualDemographics.CIBrnchNbr = partyObj.FISBranchCode__c;
      individualDemo.individualDemographics.CIPrmyOffcrNbr = partyObj.CZPrimaryOfficer__c;
      individualDemo.individualDemographics.CIScndyOffcrNbr = partyObj.CZSecondaryOfficer__c;
      individualDemo.individualDemographics.CICstCntrNbr = partyObj.CostCenter__c;

      if (String.isNotBlank(partyObj.tffa__NationalIdentifierValue__c)) {
        individualDemo.individualDemographics.DupTaxNbrOverride = 'Y';
        individualDemo.individualDemographics.CICustTaxNbr = partyObj.tffa__NationalIdentifierValue__c;
        CZTerafinaFisMapping__c tfFisTaxMap = CZTerafinaFisMapping__c.getValues('TaxType' + '_' + partyObj.tffa__NationalIdentifierType__c);
        if (tfFisTaxMap != null) {
          individualDemo.individualDemographics.CICustTaxCde = tfFisTaxMap.FisValue__c;
        }
      }

      individualDemo = fillCustomerCodes(codeList, individualDemo);

      fisccDepositOriginationRequestBaseDTO = individualDemo;
      fisccDepositOriginationRequestBaseDTO.SvcID = FISCCIntegrationConstants.INDIVIDUAL_DEMOGRAPHICS;
    } else if (partyObj.tffa__Type__c == FISCCIntegrationConstants.ORGANIZATION) {
      organizationDemo.organizationDemographics.CIApplNbr = partyObj.Customer_Number__c;

      organizationDemo.organizationDemographics.CIBrnchNbr = partyObj.FISBranchCode__c;
      organizationDemo.organizationDemographics.CIPrmyOffcrNbr = partyObj.CZPrimaryOfficer__c;
      organizationDemo.organizationDemographics.CIScndyOffcrNbr = partyObj.CZSecondaryOfficer__c;
      organizationDemo.organizationDemographics.CICstCntrNbr = partyObj.CostCenter__c;

      if (String.isNotBlank(partyObj.tffa__NationalIdentifierValue__c)) {
        organizationDemo.organizationDemographics.DupTaxNbrOverride = 'Y';
        organizationDemo.organizationDemographics.CICustTaxNbr = partyObj.tffa__NationalIdentifierValue__c;
        CZTerafinaFisMapping__c tfFisTaxMap = CZTerafinaFisMapping__c.getValues('TaxType' + '_' + partyObj.tffa__NationalIdentifierType__c);
        if (tfFisTaxMap != null) {
          organizationDemo.organizationDemographics.CICustTaxCde = tfFisTaxMap.FisValue__c;
        }
      }

      organizationDemo = fillOrgCustomerCodes(codeList, organizationDemo);

      if (String.isNotBlank(partyObj.tffa__IndustryClassificationValue__c)) {
        organizationDemo.organizationDemographics.CINaicsCde = partyObj.tffa__IndustryClassificationValue__c;
      }
      String orgType = partyObj.tffa__OrganizationType__c;
      if (orgType == 'LIMITED_LIABILITY_COMPANY') {
        orgType = 'LLC';
      }
      CZTerafinaFisMapping__c tfFisOrgTypeMap = CZTerafinaFisMapping__c.getValues('OrganizationType' + '_' + orgType);
      if (tfFisOrgTypeMap != null) {
        organizationDemo.organizationDemographics.CITypOfBusCde = tfFisOrgTypeMap.FisValue__c;
      }

      fisccDepositOriginationRequestBaseDTO = organizationDemo;
      fisccDepositOriginationRequestBaseDTO.SvcID = FISCCIntegrationConstants.ORGANIZATION_DEMOGRAPHICS;
    }
    return fisccDepositOriginationRequestBaseDTO;
  }

  public static FISCCCustNameAddressRequest generateNameAddressUpdateRequest(tffa__Party__c partyObj) {
    FISCCCustNameAddressRequest customerAddressReq = new FISCCCustNameAddressRequest();
    tffa__Address__c addressObj;
    if (!partyObj.tffa__AddressXrefs__r.isEmpty()) {
      addressObj = partyObj.tffa__AddressXrefs__r[0].tffa__Address__r;
    }
    if (partyObj.tffa__Type__c == FISCCIntegrationConstants.INDIVIDUAL) {
      customerAddressReq.customerAddress.CINmeAddrLne01 = CZWTFCCommonHelper.getFormattedFullName(
        partyObj.tffa__FirstName__c,
        partyObj.tffa__MiddleName__c,
        partyObj.tffa__LastName__c,
        partyObj.tffa__Suffix__c,
        FISCCIntegrationConstants.FULL_NAME_LENGTH
      );
    } else if (partyObj.tffa__Type__c == FISCCIntegrationConstants.ORGANIZATION) {
      if (partyObj.tffa__LegalName__c.length() > 40) {
        customerAddressReq.customerAddress.CINmeAddrLne01 = partyObj.tffa__LegalName__c.substring(0, 39);
      } else {
        customerAddressReq.customerAddress.CINmeAddrLne01 = partyObj.tffa__LegalName__c;
      }
    }
    customerAddressReq.customerAddress.CINmeAddrLneCde01 = 'N';
    if (addressObj != null) {
      customerAddressReq.customerAddress.CINmeAddrLne02 = addressObj.tffa__Line1__c;
      if (String.isNotBlank(addressObj.tffa__Line2__c)) {
        customerAddressReq.customerAddress.CINmeAddrLne03 = addressObj.tffa__Line2__c;
        customerAddressReq.customerAddress.CINmeAddrLne04 =
          addressObj.tffa__City__c +
          ' ' +
          addressObj.tffa__State__c +
          ' ' +
          addressObj.tffa__ZipCode__c;
        customerAddressReq.customerAddress.CINmeAddrLneCde02 = 'A';
        customerAddressReq.customerAddress.CINmeAddrLneCde03 = 'S';
        customerAddressReq.customerAddress.CINmeAddrLneCde04 = 'C';
      } else {
        customerAddressReq.customerAddress.CINmeAddrLne03 =
          addressObj.tffa__City__c +
          ' ' +
          addressObj.tffa__State__c +
          ' ' +
          addressObj.tffa__ZipCode__c;
        customerAddressReq.customerAddress.CINmeAddrLneCde02 = 'S';
        customerAddressReq.customerAddress.CINmeAddrLneCde03 = 'C';
        customerAddressReq.customerAddress.CINmeAddrLne04 = '';
        customerAddressReq.customerAddress.CINmeAddrLneCde04 = '';
      }
    }
    customerAddressReq.customerAddress.AddrOvrideInd = 'Y';
    customerAddressReq.customerAddress.OvrideAddrStddization = 'Y';
    customerAddressReq.customerAddress.CINmeAddrOvrideStdInd = 'Y';
    tffa.Logger.debug('Name Address update Request ' + customerAddressReq);
    return customerAddressReq;
  }

  public static List<FISCCDepositOriginationRequestBaseDTO> generatePhoneEmailUpdateReq(tffa__Party__c partyObj) {
    List<FISCCDepositOriginationRequestBaseDTO> reqList = new List<FISCCDepositOriginationRequestBaseDTO>();
    if (partyObj.tffa__PrimaryEmail__c != null && partyObj.CZFisEmail__c != partyObj.tffa__PrimaryEmail__c) {
      FISCCCreateEmailAddressesDTO objFISCCCreateEmailAddressesDTO = new FISCCCreateEmailAddressesDTO();
      List<FISCCCreateEmailAddressesDTO> lstFISCCCreateEmailAddressesDTO = new List<FISCCCreateEmailAddressesDTO>();
      FISCCDOCustomerEmailRequest objFISCCDOCustomerEmailRequest = new FISCCDOCustomerEmailRequest();
      objFISCCCreateEmailAddressesDTO.ResnCde = FISCCApplicationConstants.RESEND_CODE;
      objFISCCCreateEmailAddressesDTO.EmailAddr = partyObj.tffa__PrimaryEmail__c;
      objFISCCCreateEmailAddressesDTO.AddDelInd = FISCCIntegrationConstants.AddDelInd;
      lstFISCCCreateEmailAddressesDTO.add(objFISCCCreateEmailAddressesDTO);
      objFISCCDOCustomerEmailRequest.customerEmail.emailAddressLst = lstFISCCCreateEmailAddressesDTO;
      objFISCCDOCustomerEmailRequest.customerEmail.CustNbr = partyObj.Customer_Number__c;
      objFISCCDOCustomerEmailRequest.SvcID = FISCCIntegrationConstants.SVCID_CustomerEmail;
      reqList.add(objFISCCDOCustomerEmailRequest);
    }

    if (checkFISContactNumberIsPresentForUpdate(partyObj, 'All')) {
      FISCCCreatePhoneNumberDTO objprimaryPhneDTO = new FISCCCreatePhoneNumberDTO();
      FISCCCreatePhoneNumberDTO objWrkPhneDTO = new FISCCCreatePhoneNumberDTO();
      FISCCCreatePhoneNumberDTO objCellPhneDTO = new FISCCCreatePhoneNumberDTO();
      List<FISCCCreatePhoneNumberDTO> lstFISCCCreatePhoneNumberDTO = new List<FISCCCreatePhoneNumberDTO>();
      FISCCDOPhoneNumberRequest objFISCCDOPhoneNumberRequest = new FISCCDOPhoneNumberRequest();

      if (checkFISContactNumberIsPresentForUpdate(partyObj, 'Home')) {
        String homePhne = (partyObj.tffa__PrimaryPhone__c).Substring(partyObj.tffa__PrimaryPhone__c.length() - 10);

        String areaCde = homePhne.substring(0, 3);
        String localNbr = homePhne.substring(3, 10);

        if (partyObj.tffa__Type__c == FISCCIntegrationConstants.INDIVIDUAL) {
          objprimaryPhneDTO.ResnCde = 'HME';
        } else {
          objprimaryPhneDTO.ResnCde = 'PRI';
        }
        objprimaryPhneDTO.AddDelInd = 'A';
        objprimaryPhneDTO.AreaCde = areaCde;
        objprimaryPhneDTO.LocalNbr = localNbr;
        lstFISCCCreatePhoneNumberDTO.add(objprimaryPhneDTO);
      }

      if (checkFISContactNumberIsPresentForUpdate(partyObj, 'Work')) {
        String wrkPhne = (partyObj.tffa__SecondaryPhone__c).Substring(partyObj.tffa__SecondaryPhone__c.length() - 10);

        String areaCde = wrkPhne.substring(0, 3);
        String localNbr = wrkPhne.substring(3, 10);

        if (partyObj.tffa__Type__c == FISCCIntegrationConstants.INDIVIDUAL) {
          objWrkPhneDTO.ResnCde = 'WRK';
        } else {
          objWrkPhneDTO.ResnCde = 'SEC';
        }
        objWrkPhneDTO.AddDelInd = 'A';
        objWrkPhneDTO.AreaCde = areaCde;
        objWrkPhneDTO.LocalNbr = localNbr;
        lstFISCCCreatePhoneNumberDTO.add(objWrkPhneDTO);
      }

      if (checkFISContactNumberIsPresentForUpdate(partyObj, 'Cell')) {
        String cellPhne = (partyObj.CellPhoneNumber__c).Substring(partyObj.CellPhoneNumber__c.length() - 10);

        String areaCde = cellPhne.substring(0, 3);
        String localNbr = cellPhne.substring(3, 10);

        objCellPhneDTO.ResnCde = 'MBL';
        objCellPhneDTO.AddDelInd = 'A';
        objCellPhneDTO.AreaCde = areaCde;
        objCellPhneDTO.LocalNbr = localNbr;
        lstFISCCCreatePhoneNumberDTO.add(objCellPhneDTO);
      }

      objFISCCDOPhoneNumberRequest.custPhoneNumber.CustNbr = partyObj.Customer_Number__c;
      objFISCCDOPhoneNumberRequest.SvcID = 'CI051';
      objFISCCDOPhoneNumberRequest.custPhoneNumber.phoneNumLst = lstFISCCCreatePhoneNumberDTO;
      reqList.add(objFISCCDOPhoneNumberRequest);
    }
    return reqList;
  }

  public static boolean checkFISContactNumberIsPresentForDelete(tffa__Party__c partyObj, String type) {
    String homePhoneNbr = '';
    if (partyObj.tffa__PrimaryPhone__c != null) {
      homePhoneNbr = (partyObj.tffa__PrimaryPhone__c).Substring(partyObj.tffa__PrimaryPhone__c.length() - 10);
    }

    if ((type == 'Home' || type == 'All') && partyObj.CZFisHomeNbr__c != null && homePhoneNbr != partyObj.CZFisHomeNbr__c) {
      return true;
    }

    String wrkPhoneNbr = '';
    if (partyObj.tffa__SecondaryPhone__c != null) {
      wrkPhoneNbr = (partyObj.tffa__SecondaryPhone__c).Substring(partyObj.tffa__SecondaryPhone__c.length() - 10);
    }

    if ((type == 'Work' || type == 'All') && partyObj.CZFisWorkNbr__c != null && wrkPhoneNbr != partyObj.CZFisWorkNbr__c) {
      return true;
    }

    String cellPhoneNbr = '';
    if (partyObj.CellPhoneNumber__c != null) {
      cellPhoneNbr = (partyObj.CellPhoneNumber__c).Substring(partyObj.CellPhoneNumber__c.length() - 10);
    }
    if ((type == 'Cell' || type == 'All') && partyObj.CZFisCellNbr__c != null && cellPhoneNbr != partyObj.CZFisCellNbr__c) {
      return true;
    }

    return false;
  }

  public static boolean checkFISContactNumberIsPresentForUpdate(tffa__Party__c partyObj, String type) {
    String homePhoneNbr;
    if (partyObj.tffa__PrimaryPhone__c != null) {
      homePhoneNbr = (partyObj.tffa__PrimaryPhone__c).Substring(partyObj.tffa__PrimaryPhone__c.length() - 10);
    }
    if ((type == 'Home' || type == 'All') && homePhoneNbr != null && homePhoneNbr != partyObj.CZFisHomeNbr__c) {
      return true;
    }

    String wrkPhoneNbr;
    if (partyObj.tffa__SecondaryPhone__c != null) {
      wrkPhoneNbr = (partyObj.tffa__SecondaryPhone__c).Substring(partyObj.tffa__SecondaryPhone__c.length() - 10);
    }
    if ((type == 'Work' || type == 'All') && wrkPhoneNbr != null && wrkPhoneNbr != partyObj.CZFisWorkNbr__c) {
      return true;
    }

    String cellPhoneNbr;
    if (partyObj.CellPhoneNumber__c != null) {
      cellPhoneNbr = (partyObj.CellPhoneNumber__c).Substring(partyObj.CellPhoneNumber__c.length() - 10);
    }
    if ((type == 'Cell' || type == 'All') && cellPhoneNbr != null && cellPhoneNbr != partyObj.CZFisCellNbr__c) {
      return true;
    }
    return false;
  }

  public static List<String> removeEmployeeCode(List<String> strList) {
    Integer indx;
    for (Integer i = 0; i < strList.size(); i++) {
      if (strList[i] == '2') {
        indx = i;
        break;
      }
    }
    strList.remove(indx);
    return strList;
  }

  public static FISCCDOIndividualDemoRequest fillCustomerCodes(List<String> codeLst, FISCCDOIndividualDemoRequest individualDemo) {
    tffa.Logger.debug('In fillCustomerCodes ' + codeLst);

    individualDemo.individualDemographics.CICustCde1 = '0';
    individualDemo.individualDemographics.CICustCde2 = '0';
    individualDemo.individualDemographics.CICustCde3 = '0';
    individualDemo.individualDemographics.CICustCde4 = '0';
    individualDemo.individualDemographics.CICustCde5 = '0';
    individualDemo.individualDemographics.CICustCde6 = '0';
    individualDemo.individualDemographics.CICustCde7 = '0';
    individualDemo.individualDemographics.CICustCde8 = '0';
    individualDemo.individualDemographics.CICustCde9 = '0';
    individualDemo.individualDemographics.CICustCde10 = '0';
    individualDemo.individualDemographics.CICustCde11 = '0';
    individualDemo.individualDemographics.CICustCde12 = '0';
    individualDemo.individualDemographics.CICustCde13 = '0';
    individualDemo.individualDemographics.CICustCde14 = '0';
    individualDemo.individualDemographics.CICustCde15 = '0';

    for (String code : codeLst) {
      if (individualDemo.individualDemographics.CICustCde1 == '0') {
        individualDemo.individualDemographics.CICustCde1 = code;
      } else if (individualDemo.individualDemographics.CICustCde2 == '0') {
        individualDemo.individualDemographics.CICustCde2 = code;
      } else if (individualDemo.individualDemographics.CICustCde3 == '0') {
        individualDemo.individualDemographics.CICustCde3 = code;
      } else if (individualDemo.individualDemographics.CICustCde4 == '0') {
        individualDemo.individualDemographics.CICustCde4 = code;
      } else if (individualDemo.individualDemographics.CICustCde5 == '0') {
        individualDemo.individualDemographics.CICustCde5 = code;
      } else if (individualDemo.individualDemographics.CICustCde6 == '0') {
        individualDemo.individualDemographics.CICustCde6 = code;
      } else if (individualDemo.individualDemographics.CICustCde7 == '0') {
        individualDemo.individualDemographics.CICustCde7 = code;
      } else if (individualDemo.individualDemographics.CICustCde8 == '0') {
        individualDemo.individualDemographics.CICustCde8 = code;
      } else if (individualDemo.individualDemographics.CICustCde9 == '0') {
        individualDemo.individualDemographics.CICustCde9 = code;
      } else if (individualDemo.individualDemographics.CICustCde10 == '0') {
        individualDemo.individualDemographics.CICustCde10 = code;
      } else if (individualDemo.individualDemographics.CICustCde11 == '0') {
        individualDemo.individualDemographics.CICustCde11 = code;
      } else if (individualDemo.individualDemographics.CICustCde12 == '0') {
        individualDemo.individualDemographics.CICustCde12 = code;
      } else if (individualDemo.individualDemographics.CICustCde13 == '0') {
        individualDemo.individualDemographics.CICustCde13 = code;
      } else if (individualDemo.individualDemographics.CICustCde14 == '0') {
        individualDemo.individualDemographics.CICustCde14 = code;
      } else if (individualDemo.individualDemographics.CICustCde15 == '0') {
        individualDemo.individualDemographics.CICustCde15 = code;
      }
    }
    return individualDemo;
  }

  public static boolean updatePartyInfo(tffa__Party__c party) {
    tffa.Logger.debug('In updatePartyInfo');
    boolean isAliasDeleted = true;
    boolean partyUpdateSuccess = true;

    if (!party.CZAllAliasCreated__c) {
      if (party.tffa__IsExistingCustomer__c || party.IsCrossCharterCustomer__c) {
        List<String> aliasSeqNoList = FISCCCustomerAliasExtension.fetchCustomerAliasSeqNo(party);
        if (!aliasSeqNoList.isEmpty()) {
          isAliasDeleted = FISCCCustomerAliasExtension.deleteCustomerAlias(party, aliasSeqNoList);
        }
      }
      tffa.Logger.debug('In updatePartyInfo-->isAliasDeleted ' + isAliasDeleted);
      if (isAliasDeleted) {
        partyUpdateSuccess = FISCCCustomerAliasExtension.invokeAddAliasAPI(party);
      }
    }
    return partyUpdateSuccess;
  }

  public static FISCCDOOrganizationDemoRequest fillOrgCustomerCodes(List<String> codeLst, FISCCDOOrganizationDemoRequest organizationDemo) {
    tffa.Logger.debug('In fillCustomerCodes ' + codeLst);

    organizationDemo.organizationDemographics.CICustCde1 = '0';
    organizationDemo.organizationDemographics.CICustCde2 = '0';
    organizationDemo.organizationDemographics.CICustCde3 = '0';
    organizationDemo.organizationDemographics.CICustCde4 = '0';
    organizationDemo.organizationDemographics.CICustCde5 = '0';
    organizationDemo.organizationDemographics.CICustCde6 = '0';
    organizationDemo.organizationDemographics.CICustCde7 = '0';
    organizationDemo.organizationDemographics.CICustCde8 = '0';
    organizationDemo.organizationDemographics.CICustCde9 = '0';
    organizationDemo.organizationDemographics.CICustCde10 = '0';
    organizationDemo.organizationDemographics.CICustCde11 = '0';
    organizationDemo.organizationDemographics.CICustCde12 = '0';
    organizationDemo.organizationDemographics.CICustCde13 = '0';
    organizationDemo.organizationDemographics.CICustCde14 = '0';
    organizationDemo.organizationDemographics.CICustCde15 = '0';

    for (String code : codeLst) {
      if (organizationDemo.organizationDemographics.CICustCde1 == '0') {
        organizationDemo.organizationDemographics.CICustCde1 = code;
      } else if (organizationDemo.organizationDemographics.CICustCde2 == '0') {
        organizationDemo.organizationDemographics.CICustCde2 = code;
      } else if (organizationDemo.organizationDemographics.CICustCde3 == '0') {
        organizationDemo.organizationDemographics.CICustCde3 = code;
      } else if (organizationDemo.organizationDemographics.CICustCde4 == '0') {
        organizationDemo.organizationDemographics.CICustCde4 = code;
      } else if (organizationDemo.organizationDemographics.CICustCde5 == '0') {
        organizationDemo.organizationDemographics.CICustCde5 = code;
      } else if (organizationDemo.organizationDemographics.CICustCde6 == '0') {
        organizationDemo.organizationDemographics.CICustCde6 = code;
      } else if (organizationDemo.organizationDemographics.CICustCde7 == '0') {
        organizationDemo.organizationDemographics.CICustCde7 = code;
      } else if (organizationDemo.organizationDemographics.CICustCde8 == '0') {
        organizationDemo.organizationDemographics.CICustCde8 = code;
      } else if (organizationDemo.organizationDemographics.CICustCde9 == '0') {
        organizationDemo.organizationDemographics.CICustCde9 = code;
      } else if (organizationDemo.organizationDemographics.CICustCde10 == '0') {
        organizationDemo.organizationDemographics.CICustCde10 = code;
      } else if (organizationDemo.organizationDemographics.CICustCde11 == '0') {
        organizationDemo.organizationDemographics.CICustCde11 = code;
      } else if (organizationDemo.organizationDemographics.CICustCde12 == '0') {
        organizationDemo.organizationDemographics.CICustCde12 = code;
      } else if (organizationDemo.organizationDemographics.CICustCde13 == '0') {
        organizationDemo.organizationDemographics.CICustCde13 = code;
      } else if (organizationDemo.organizationDemographics.CICustCde14 == '0') {
        organizationDemo.organizationDemographics.CICustCde14 = code;
      } else if (organizationDemo.organizationDemographics.CICustCde15 == '0') {
        organizationDemo.organizationDemographics.CICustCde15 = code;
      }
    }
    return organizationDemo;
  }
}