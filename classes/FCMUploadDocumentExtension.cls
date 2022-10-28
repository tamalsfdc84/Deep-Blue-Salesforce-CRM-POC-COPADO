public inherited sharing class FCMUploadDocumentExtension {
  public static String message = '';
  public static String uploadFCMDocument(FISCC_Adapter_Configs__mdt adapterConfig, FISCC_Charter_Config__mdt charterConfig) {
    FISCCRequestBaseDTO fisccRequestBaseDTO = null;
    Object result = null;
    try {
      fisccRequestBaseDTO = createUploadFCMDocumentRequest(adapterConfig, charterConfig);

      result = FISCCHostAdapter.processHostRequest(fisccRequestBaseDTO, adapterConfig, charterConfig);

      if (result == 'OK') {
        message = CZWTFCConstants.FILE_TRANSFER_SUCCESS;
      } else {
        message = CZWTFCConstants.FILE_TRANSFER_FAILURE;
      }

      return message;
    } catch (Exception ex) {
      tffa.Logger.error('Exception in uploadFCMDocument : ' + ex.getMessage() + ex.getLineNumber() + ex.getStackTraceString());
      return CZWTFCConstants.FILE_TRANSFER_FAILURE;
    }
  }

  public static FISCCRequestBaseDTO createUploadFCMDocumentRequest(
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    tffa.Logger.debug('started createUploadFCMDocumentRequest');
    FISCCRequestBaseDTO fisccRequestBaseDTO = null;

    fisccRequestBaseDTO = new FISCCGetAccessTokenDTO();
    return fisccRequestBaseDTO;
  }
}