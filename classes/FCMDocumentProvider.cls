public inherited sharing class FCMDocumentProvider {
  public static String generateFCMDocumentId(tffa__Application__c app, CZFCMContentVersionDTO contentVersionDTO, tffa__Party__c party, FISCC_Charter_Config__mdt charterConfig) {
    String docId = '';
    try {
      FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig('GenerateDocumentId');
      adapterConfig.ServiceURL__c = adapterConfig.ServiceURL__c.replace('{EntityID}', charterConfig.FCMEntityId__c);
      docId = FCMGenerateDocumentIdExtension.getFCMDocumentId(app, contentVersionDTO, party, adapterConfig, charterConfig);
    } catch (Exception ex) {
      tffa.logger.error('Exception in FCMDocumentProvider ' + ex.getMessage() + ' ' + ex.getStackTraceString());
    }
    return docId;
  }

  // Map contains document id and FCM document id
  public static String uploadFCMDocuments(FISCC_Charter_Config__mdt charterConfig) {
    String uploadStatus = '';
    try {
      FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig('UploadFCMDocument');
      adapterConfig.ServiceURL__c = adapterConfig.ServiceURL__c.replace('{EntityID}', charterConfig.FCMEntityId__c);
      adapterConfig.ServiceURL__c = adapterConfig.ServiceURL__c.replace('{FcmDocId}', FISCCIntegrationLogService.fcmDocumentId);

      uploadStatus = FCMUploadDocumentExtension.uploadFCMDocument(adapterConfig, charterConfig);
    } catch (Exception ex) {
      tffa.logger.error('Exception in FCMDocumentProvider ' + ex.getMessage() + ' ' + ex.getStackTraceString());
      return CZWTFCConstants.FILE_TRANSFER_FAILURE;
    }
    return uploadStatus;
  }
}