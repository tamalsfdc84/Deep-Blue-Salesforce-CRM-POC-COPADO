public with sharing class FISCCCreateBenefCustomerRequest {
  public static FISCCCustomerDTO createBeneficiaryRequest(
    tffa__Beneficiary__c benefObj,
    tffa__Submission__c submissionObj,
    tffa__Application__c appObj,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    tffa.logger.debug('Inside createBeneficiaryRequest method');
    FISCCDepositOriginationRequestBaseDTO fisccDepositOriginationRequestBaseDTO = null;
    FISCCCustomerDTO objFISCCCustomerDTO = new FISCCCustomerDTO();
    tffa.logger.debug('BenefObj in createBeneficiaryRequest==>' + benefObj);
    tffa__Brand__c brandObj = FISCCIntegrationLogService.brandObj;
    try {
      if (benefObj != null) {
        objFISCCCustomerDTO.CIBirthdate = String.valueOf(benefObj.tffa__BirthDate__c);

        objFISCCCustomerDTO.CICitizenshipCde = 'Y';
        tffa.logger.debug('objFISCCCustomerDTO.CICitizenshipCde ==>' + objFISCCCustomerDTO.CICitizenshipCde);
        objFISCCCustomerDTO.CIBrnchNbr = Integer.valueOf(appObj.FISBranchCode__c);
        objFISCCCustomerDTO.CICstCntrNbr = Integer.valueOf(appObj.CostCenter__c);
        objFISCCCustomerDTO.NAStandardizationOvride = 'Y';
        tffa__Address__c addressObj = benefObj.tffa__Address__r;
        objFISCCCustomerDTO.CINmeAddrLne01 = CZWTFCCommonHelper.getFormattedFullName(
          benefObj.tffa__FirstName__c,
          '',
          benefObj.tffa__LastName__c,
          benefObj.tffa__Suffix__c,
          FISCCIntegrationConstants.FULL_NAME_LENGTH
        );

        if (brandObj != null && !String.isBlank(brandObj.CIPrmyOffcrNbr__c)) {
          objFISCCCustomerDTO.CIPrmyOffcrNbr = brandObj.CIPrmyOffcrNbr__c;
        }
        objFISCCCustomerDTO.CINmeAddrLneCde01 = 'N';
        objFISCCCustomerDTO.CINmeAddrLne02 = addressObj.tffa__Line1__c;
        if (String.isNotBlank(addressObj.tffa__Line2__c)) {
          objFISCCCustomerDTO.CINmeAddrLne03 = addressObj.tffa__Line2__c;
          objFISCCCustomerDTO.CINmeAddrLne04 =
            addressObj.tffa__City__c +
            ' ' +
            addressObj.tffa__State__c +
            ' ' +
            addressObj.tffa__ZipCode__c;
          objFISCCCustomerDTO.CINmeAddrLneCde02 = 'A';
          objFISCCCustomerDTO.CINmeAddrLneCde03 = 'S';
          objFISCCCustomerDTO.CINmeAddrLneCde04 = 'C';
        } else {
          objFISCCCustomerDTO.CINmeAddrLne03 =
            addressObj.tffa__City__c +
            ' ' +
            addressObj.tffa__State__c +
            ' ' +
            addressObj.tffa__ZipCode__c;
          objFISCCCustomerDTO.CINmeAddrLneCde02 = 'S';
          objFISCCCustomerDTO.CINmeAddrLneCde03 = 'C';
        }
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in createBeneficiaryRequest : ' + ex.getMessage() + ex.getStackTraceString());
      return null;
    }
    tffa.Logger.debug('Benef objFISCCCustomerDTO ' + objFISCCCustomerDTO);
    return objFISCCCustomerDTO;
  }
}