public with sharing class FISCCFundingHoldExtension {
  public static FISCCFundHoldRequestDTO fundHoldReq = new FISCCFundHoldRequestDTO();

  public static Boolean invokeApiCall(
    tffa__Application__c appObj,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig,
    String requestType
  ) {
    FISCCRequestBaseDTO fisccRequestBaseDTO = null;
    Object result = null;
    Boolean isSuccess;
    try {
      fisccRequestBaseDTO = FISCCFundingHoldExtension.generateFundingHoldReq(appObj, adapterConfig, charterConfig, requestType);

      String dpAcctNbr = adapterConfig.IsEncrypted__c
        ? FISCCCommonHelper.encrypt(appObj.tffa__AccountNumber__c)
        : appObj.tffa__AccountNumber__c;

      adapterConfig.ServiceURL__c = adapterConfig.ServiceURL__c.replace('{accNumber}', dpAcctNbr);
      result = FISCCHostAdapter.processHostRequest(fisccRequestBaseDTO, adapterConfig, charterConfig);
      isSuccess = FISCCFundingHoldExtension.parseFundHoldResponse(result);
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in FISCCFundingHoldExtension ' + ex.getMessage() + ' Exception :::' + ex.getStackTraceString());
    }
    return isSuccess;
  }

  public static FISCCRequestBaseDTO generateFundingHoldReq(
    tffa__Application__c appObj,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig,
    String requestType
  ) {
    tffa.Logger.debug('In generateFundingHoldReq');
    FISCCRequestBaseDTO fisccRequestBaseDTO = null;
    try {
      if (requestType == FISCCIntegrationConstants.FUNDINGHOLD) {
        fundHoldReq.holds.DPHldExpireDte = FISCCFundingHoldExtension.getExpDate(appObj);
        fundHoldReq.holds.DPHldAmt = appObj.tffa__Amount__c;
        fundHoldReq.holds.DPHldDesc = FISCCIntegrationConstants.FUNDINGHOLD;
      } else {
        fundHoldReq.holds.DPHldExpireDte = String.valueOf(appObj.CZLoanHoldExpiry__c);
        fundHoldReq.holds.DPHldAmt = appObj.CZLoanHoldAmount__c;
        fundHoldReq.holds.DPHldOvride = 'Y';
        fundHoldReq.holds.DPHldDesc = FISCCIntegrationConstants.LOANHOLD;
      }
      fundHoldReq.holds.DPHldTyp = 1;

      fisccRequestBaseDTO = fundHoldReq;
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in generateFundingHoldReq ' + ex.getMessage() + ' Exception :::' + ex.getStackTraceString());
    }
    return fundHoldReq;
  }

  public static Boolean parseFundHoldResponse(Object response) {
    tffa.Logger.debug('parseFundHoldResponse----> ' + response);
    try {
      if (response instanceof FISCCFundHoldResponseDTO) {
        FISCCFundHoldResponseDTO fundHoldResp = (FISCCFundHoldResponseDTO) response;
        tffa.Logger.debug('Fund Hold for acc number--> ' + fundHoldResp.Entity.holds.DPAcctNbr);
        return true;
      } else {
        return false;
      }
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in parseFundHoldResponse ' + ex.getMessage() + ' Exception :::' + ex.getStackTraceString());
      return false;
    }
  }

  public static String getExpDate(tffa__Application__c appObj) {
    Date startDate = system.today();
    Integer daysToAdd = Integer.valueOf(CZWTFCACHRepository.getMetaData(appObj.tffa__Brand__c)[0].AchHoldDays__c);

    for (Integer i = 0; i <= daysToAdd; i++) {
      Datetime dt = DateTime.newInstance(startDate, Time.newInstance(0, 0, 0, 0));
      String dayOfWeek = dt.format('EEEE');

      if (dayOfWeek.equalsIgnoreCase('Saturday') || dayOfWeek.equalsIgnoreCase('Sunday')) {
        daysToAdd++;
      }
      startDate = startDate.addDays(1);
    }

    Date expDate = system.today();

    String expDateStr = String.valueOf(expDate.addDays(daysToAdd));
    tffa.Logger.debug('exp fund hold date ' + expDateStr);

    return expDateStr;
  }
}