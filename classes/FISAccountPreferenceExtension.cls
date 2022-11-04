public inherited sharing class FISAccountPreferenceExtension {
  public static Object invokemultiKeywordsApi(
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig,
    String reqType,
    tffa__Application__c app
  ) {
    FISCCRequestBaseDTO fisccRequestBaseDTO = null;
    Object result = null;

    fisccRequestBaseDTO = getMultiKeywordRequest(reqType, app);
    tffa.Logger.debug('getMultiKeywordRequest :: ' + fisccRequestBaseDTO);
    result = FISCCHostAdapter.processHostRequest(fisccRequestBaseDTO, adapterConfig, charterConfig);
    tffa.Logger.debug('result in invokemultiKeywordsApi ==>' + result);
    return result;
  }

  private static FISCCRequestBaseDTO getMultiKeywordRequest(String reqType, tffa__Application__c app) {
    tffa.Logger.debug('reqType ' + reqType);
    FISCCRequestBaseDTO requestDTO;
    FISCCMultiKeywordsRequestDTO request = new FISCCMultiKeywordsRequestDTO();
    FISCCMultiKeywordsRequestDTO.Keywords keyword;

    if (reqType.contains(FISCCIntegrationConstants.ESTMT_TYPE)) {
      keyword = new FISCCMultiKeywordsRequestDTO.Keywords();
      keyword.DPKywrdCde = 'PAPERF';
      keyword.DPKywrdVal = 'N';
      request.keywordsLst.add(keyword);

      keyword = new FISCCMultiKeywordsRequestDTO.Keywords();
      keyword.DPKywrdCde = 'ELECTF';
      keyword.DPKywrdVal = 'Y';
      request.keywordsLst.add(keyword);
    }
    if (reqType.contains(FISCCIntegrationConstants.OD_ATM_N) || reqType.contains(FISCCIntegrationConstants.OD_ATM_Y)) {
      DateTime dateValue = Date.Today();
      String frmtdate = dateValue.format('MMddyyyy');

      keyword = new FISCCMultiKeywordsRequestDTO.Keywords();
      keyword.DPKywrdCde = 'ESPIND';
      keyword.DPKywrdVal = 'C';
      request.keywordsLst.add(keyword);

      keyword = new FISCCMultiKeywordsRequestDTO.Keywords();
      keyword.DPKywrdCde = 'OPTDTE';
      keyword.DPKywrdVal = frmtdate;
      request.keywordsLst.add(keyword);

      keyword = new FISCCMultiKeywordsRequestDTO.Keywords();
      keyword.DPKywrdCde = 'OPTMTH';
      keyword.DPKywrdVal = 'DO';
      request.keywordsLst.add(keyword);

      keyword = new FISCCMultiKeywordsRequestDTO.Keywords();
      keyword.DPKywrdCde = 'CMSESP';
      if (reqType.contains(FISCCIntegrationConstants.OD_ATM_N)) {
        keyword.DPKywrdVal = 'N';
      } else {
        keyword.DPKywrdVal = 'Y';
      }
      request.keywordsLst.add(keyword);
    }

    if (reqType.contains('StatusCodeExpiry')) {
      if (app.CZStatusCode1ExpiryDate__c != null && FISCCIntegrationConstants.STATUSCODE_KEYWORD_MAP.containsKey(app.CZStatusCode1__c)) {
        keyword = new FISCCMultiKeywordsRequestDTO.Keywords();
        keyword.DPKywrdCde = FISCCIntegrationConstants.STATUSCODE_KEYWORD_MAP.get(app.CZStatusCode1__c);
        keyword.DPKywrdVal = String.valueOf(app.CZStatusCode1ExpiryDate__c);
        request.keywordsLst.add(keyword);
      }

      if (app.CZStatusCode2ExpiryDate__c != null && FISCCIntegrationConstants.STATUSCODE_KEYWORD_MAP.containsKey(app.CZStatusCode2__c)) {
        keyword = new FISCCMultiKeywordsRequestDTO.Keywords();
        keyword.DPKywrdCde = FISCCIntegrationConstants.STATUSCODE_KEYWORD_MAP.get(app.CZStatusCode2__c);
        keyword.DPKywrdVal = String.valueOf(app.CZStatusCode2ExpiryDate__c);
        request.keywordsLst.add(keyword);
      }

      if (app.CZStatusCode3ExpiryDate__c != null && FISCCIntegrationConstants.STATUSCODE_KEYWORD_MAP.containsKey(app.CZStatusCode3__c)) {
        keyword = new FISCCMultiKeywordsRequestDTO.Keywords();
        keyword.DPKywrdCde = FISCCIntegrationConstants.STATUSCODE_KEYWORD_MAP.get(app.CZStatusCode3__c);
        keyword.DPKywrdVal = String.valueOf(app.CZStatusCode3ExpiryDate__c);
        request.keywordsLst.add(keyword);
      }
      if (app.CZIsLargeDollarHold__c) {
        keyword = new FISCCMultiKeywordsRequestDTO.Keywords();
        keyword.DPKywrdCde = 'USRCD4';
        keyword.DPKywrdVal = 'F';
        request.keywordsLst.add(keyword);
      }
    }

    if (reqType.contains(FISCCIntegrationConstants.APY_INFO)) {
      if (app.tffa__APY__c != null) {
        keyword = new FISCCMultiKeywordsRequestDTO.Keywords();
        keyword.DPKywrdCde = 'TDOAPY';
        keyword.DPKywrdVal = getAPYValue(String.valueOf(app.tffa__APY__c));
        keyword.DPKywrdSegId = '1';
        keyword.DPTxnCde = 381;
        request.keywordsLst.add(keyword);
      }
    }

    if (
      reqType.contains(FISCCIntegrationConstants.ACCOUNT_OPENING_INFO) &&
      FISCCIntegrationLogService.submissionObj != null &&
      app.tffa__AccountPurpose__c != FISCCIntegrationConstants.ALLOWED_PURPOSE_DEBIT_CARD &&
      !FISCCIntegrationConstants.SAFE_DEPOSIT_PROD_CATEGORY.contains(app.tffa__ProductCategory__c)
    ) {
      if (FISCCIntegrationLogService.submissionObj.tffa__SubmittedChannel__c == 'BRANCH') {
        keyword = new FISCCMultiKeywordsRequestDTO.Keywords();
        keyword.DPKywrdCde = 'APPCHN';
        keyword.DPKywrdVal = 'TFBRN';
        request.keywordsLst.add(keyword);
        if (FISCCIntegrationLogService.submissionObj.tffa__SubmittedBy__c != null) {
          tffa__AgentDetail__c agentDetail = tffa.AgentDetailService.readForUser(
            FISCCIntegrationLogService.submissionObj.tffa__SubmittedBy__c
          );
          if (agentDetail != null && String.isNotBlank(agentDetail.CZOfficerNbr__c)) {
            keyword = new FISCCMultiKeywordsRequestDTO.Keywords();
            keyword.DPKywrdCde = 'APPUSR';
            keyword.DPKywrdVal = agentDetail.CZOfficerNbr__c;
            request.keywordsLst.add(keyword);
          }
        }
      } else {
        keyword = new FISCCMultiKeywordsRequestDTO.Keywords();
        keyword.DPKywrdCde = 'APPCHN';
        keyword.DPKywrdVal = 'TFDIG';
        request.keywordsLst.add(keyword);
      }
    }

    requestDTO = request;
    return requestDTO;
  }

  public static String getAPYValue(String apy) {
    String formattedAPY = apy;
    String tempAPYBeforeDecimalPoint = apy.SubStringBefore('.');
    String tempAPYAfterDecimalPoint = apy.substringAfter('.');

    if (tempAPYBeforeDecimalPoint.length() == 1) {
      formattedAPY = '0' + formattedAPY;
    }
    if (tempAPYAfterDecimalPoint.length() == 1) {
      formattedAPY = formattedAPY + '0';
    }

    return formattedAPY;
  }
}