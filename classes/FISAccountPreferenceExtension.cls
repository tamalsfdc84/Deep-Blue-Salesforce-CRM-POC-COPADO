public inherited sharing class FISAccountPreferenceExtension {
  public static Object invokemultiKeywordsApi(
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig,
    String reqType
  ) {
    FISCCRequestBaseDTO fisccRequestBaseDTO = null;
    Object result = null;

    fisccRequestBaseDTO = getMultiKeywordRequest(reqType);
    tffa.Logger.debug('getMultiKeywordRequest :: ' + fisccRequestBaseDTO);
    result = FISCCHostAdapter.processHostRequest(fisccRequestBaseDTO, adapterConfig, charterConfig);
    tffa.Logger.debug('result in invokemultiKeywordsApi ==>' + result);
    return result;
  }

  private static FISCCRequestBaseDTO getMultiKeywordRequest(String reqType) {
    tffa.Logger.debug('reqType ' + reqType);
    FISCCRequestBaseDTO requestDTO;
    FISCCMultiKeywordsRequestDTO request = new FISCCMultiKeywordsRequestDTO();
    FISCCMultiKeywordsRequestDTO.Keywords keyword;

    if (reqType.equalsIgnoreCase(FISCCIntegrationConstants.ESTMT_TYPE)) {
      keyword = new FISCCMultiKeywordsRequestDTO.Keywords();
      keyword.DPKywrdCde = 'PAPERF';
      keyword.DPKywrdVal = 'N';
      request.keywordsLst.add(keyword);

      keyword = new FISCCMultiKeywordsRequestDTO.Keywords();
      keyword.DPKywrdCde = 'ELECTF';
      keyword.DPKywrdVal = 'Y';
      request.keywordsLst.add(keyword);
    } else if (
      reqType.equalsIgnoreCase(FISCCIntegrationConstants.OD_ATM_N) || reqType.equalsIgnoreCase(FISCCIntegrationConstants.OD_ATM_Y)
    ) {
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
      if (reqType.equalsIgnoreCase(FISCCIntegrationConstants.OD_ATM_N)) {
        keyword.DPKywrdVal = 'N';
      } else {
        keyword.DPKywrdVal = 'Y';
      }

      request.keywordsLst.add(keyword);
    }

    requestDTO = request;
    return requestDTO;
  }
}