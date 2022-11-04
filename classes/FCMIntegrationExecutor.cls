public inherited sharing class FCMIntegrationExecutor {
  public static List<UploadFileHistory__c> updatedUploadHistoryList = new List<UploadFileHistory__c>();
  public static Boolean errorFlag = false;
  public static Boolean apiLimitFlag = false;
  public static Set<String> fcmFileExtension = new Set<String>{ 'jpg', 'jpeg', 'png', 'pdf', 'bmp', 'gif', 'tif', 'tiff', 'xls', 'xlsx', 'msg', 'doc', 'docx' };
  public static Map<String, tffa__Party__c> partyMap = new Map<String, tffa__Party__c>();

  public static tffa__Submission__c processRequest(tffa__Submission__c sub) {
    try {
      tffa.Logger.debug('Submission : ' + sub);

      FISCCIntegrationLogService.applicationCode = 'FCM';
      FISCCIntegrationLogService.setSubmissionObj(String.valueOf(sub.Id));
      FISCCIntegrationLogService.setIntegrationLog(String.valueOf(sub.Id));
      FISCCIntegrationLogService.setApplicationObjs();
      apiLimitFlag = false;
      // Create Application map
      for(tffa__Application__c application : FISCCIntegrationLogService.applicationObjs){
        FISCCIntegrationLogService.applicationObjMap.put(application.Id, application);
      }

      // Fetch Auth token
      FISCCIntegrationLogService.auth = FISCCGetAccessTokenProvider.processGetAccessToken(FISCCIntegrationLogService.charterConfig);

      if (String.isEmpty(FISCCIntegrationLogService.auth) && !Test.isRunningTest()) {
        errorFlag = true;
        return sub;
      }

      // Fetch Entity Auth Token
      FISCCIntegrationLogService.entityAuthToken = FCMGetEntityAuthorizationTokenProvider.processGetAuthorizationTokenToken(
        FISCCIntegrationLogService.charterConfig
      );

      if (String.isEmpty(FISCCIntegrationLogService.entityAuthToken) && !Test.isRunningTest()) {
        errorFlag = true;
        return sub;
      }

      // Fetch upload file history based on submisison Id
      List<UploadFileHistory__c> uploadHistoryList = FCMHelperRepository.fetchFCMFileHistory(FISCCIntegrationLogService.submissionObj.Id);

      // Create a map of upload file history with combination of docId, appId and partyId
      Map<String, UploadFileHistory__c> fileHistoryMap = new Map<String, UploadFileHistory__c>();
      for (UploadFileHistory__c obj : uploadHistoryList) {
        fileHistoryMap.put(obj.DocumentId__c + (obj.ApplicationID__c == null ? '' : obj.ApplicationID__c) + (obj.CZPartyID__c == null ? '' : obj.CZPartyID__c), obj);
      }

      tffa.Logger.debug('fileHistoryMap : ' + fileHistoryMap);

      // Get all eligible documents for upload
      List<CZFCMContentVersionDTO> disclosureContent = new List<CZFCMContentVersionDTO>();
      disclosureContent = FCMHelperRepository.findContentVersionBySubmissionId(FISCCIntegrationLogService.submissionObj);

      // Remove unsupported file extension format data and remove the files which is not needed to upload
      List<CZFCMContentVersionDTO> contentVersionList = new List<CZFCMContentVersionDTO>();
      for (CZFCMContentVersionDTO cv : disclosureContent) {
        if (fcmFileExtension.contains(cv.FileExtension)) {
          if(String.isNotBlank(cv.DocumentCode)){
            CZFCMDocumenTypes__c docType = CZFCMDocumenTypes__c.getValues(cv.DocumentCode);
            if(docType != null && !docType.IsUploadRequired__c){
              continue;
            }
          }
          contentVersionList.add(cv);
        }
      }

      //Fetch all party present in the DTO
      Set<String> partyIds = new Set<String>();
      for (CZFCMContentVersionDTO cvDTO : contentVersionList) {
        if (cvDTO.PartyId != null && String.isNotBlank(cvDTO.PartyId)) {
          partyIds.add(cvDTO.PartyId);
        }
      }

      //Create Party Map
      if(partyIds != null && partyIds.size() > 0){
        for (tffa__Party__c party : CZWTFCPartyRepository.fetchPartyByIds(partyIds)) {
          partyMap.put(party.Id, party);
        }
      }
      
      tffa.Logger.debug('contentVersionList : ' + contentVersionList);

      if (contentVersionList != null && fileHistoryMap != null) {
        for (CZFCMContentVersionDTO cv : contentVersionList) {

          // File callout is more than 90 break.
          if (Limits.getCallouts() > 90) {
            apiLimitFlag = true;
            break;
          }

          UploadFileHistory__c uploadFileHistory = fileHistoryMap.get(cv.ContentVersionId + (cv.ApplicationId != null ? cv.ApplicationId : '') + (cv.PartyId != null ? cv.PartyId : ''));

          if (uploadFileHistory == null) {
            uploadFileHistory = new UploadFileHistory__c();
            if(String.isNotBlank(cv.ApplicationId)){
              uploadFileHistory.ApplicationID__c = cv.ApplicationId;
            }
            uploadFileHistory.SubmissionID__c = FISCCIntegrationLogService.submissionObj.Id;
            uploadFileHistory.BrandCode__c = FISCCIntegrationLogService.submissionObj.tffa__Brand__c;
            uploadFileHistory.FileName__c = FISCCIntegrationLogService.submissionObj.tffa__Channel__c == 'DIGITAL' ? cv.PathOnClient : cv.Title;
            uploadFileHistory.FileExt__c = cv.FileExtension;
            uploadFileHistory.FileType__c = 'FCM';
            uploadFileHistory.DocumentId__c = cv.ContentVersionId;
            uploadFileHistory.FileTransferStatus__c = CZWTFCConstants.PROCESS_STATUS_FAILURE;
            uploadFileHistory.FCMDocumentId__c = '';
            uploadFileHistory.SubmissionName__c = FISCCIntegrationLogService.submissionObj.Name;
            uploadFileHistory.CZPartyID__c = cv.PartyId != null ? cv.PartyId : '';
          } else if (uploadFileHistory.FileTransferStatus__c == CZWTFCConstants.PROCESS_STATUS_SUCCESS) {
            //already uploaded skip this file
            continue;
          }

          // If file Size is above max limit skip that file
          if (cv.contentSize > FISCCIntegrationConstants.MAX_ALLOWED_FILE_SIZE) {
            uploadFileHistory.FileTransferStatus__c = CZWTFCConstants.PROCESS_STATUS_FAILURE;
            uploadFileHistory.FileTransferStatusMessage__c = 'File size too large. Cannot transfer';
            updatedUploadHistoryList.add(uploadFileHistory);
            continue;
          }

          try {
            // If FCM document id is empty generate a Id
            if (String.isEmpty(uploadFileHistory.FCMDocumentId__c)) {
              uploadFileHistory.FCMDocumentId__c = FCMDocumentProvider.generateFCMDocumentId(
                FISCCIntegrationLogService.applicationObjMap.get(uploadFileHistory.ApplicationID__c),
                cv,
                partyMap.get(uploadFileHistory.CZPartyID__c),
                FISCCIntegrationLogService.charterConfig
              );
            }

            // If FCM documnet id generation failed set FileTransferStatus__c to Failure else upload the file
            if (String.isEmpty(uploadFileHistory.FCMDocumentId__c)) {
              // document id generation failed
              errorFlag = true;
              uploadFileHistory.FileTransferStatus__c = CZWTFCConstants.FILE_TRANSFER_FAILURE;
            } else {
              FISCCIntegrationLogService.fcmDocumentId = uploadFileHistory.FCMDocumentId__c;
              FISCCIntegrationLogService.contentVersionData = FCMHelperRepository.getContentVersionById(cv.ContentVersionId)[0].VersionData;
              uploadFileHistory.FileTransferStatus__c = FCMDocumentProvider.uploadFCMDocuments(FISCCIntegrationLogService.charterConfig);
            }
          } catch (Exception ex) {
            tffa.Logger.error('Exception in FCMIntegrationExecutor :' + ex.getMessage() + ' :: ' + ex.getStackTraceString());
            errorFlag = true;
            uploadFileHistory.FileTransferStatus__c = CZWTFCConstants.FILE_TRANSFER_FAILURE;
          } finally {
            updatedUploadHistoryList.add(uploadFileHistory);
          }
        }
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in FCMIntegrationExecutor :' + ex.getMessage() + ' :: ' + ex.getStackTraceString());
      errorFlag = true;
    } finally {
      // Update or Insert Upload file history record
      if (updatedUploadHistoryList != null) {
        FCMHelperRepository.save(updatedUploadHistoryList);
      }

      // Update submission level FCMUploadStatus__c to sucess only when all files are uploade sucessfully.
      if (errorFlag) {
        sub.FCMUploadStatus__c = CZWTFCConstants.PROCESS_STATUS_FAILURE;
        sub.FCMUploadRetryCount__c++;
      } else {
        sub.FCMUploadStatus__c = CZWTFCConstants.PROCESS_STATUS_SUCCESS;
      }

      if(apiLimitFlag){
        sub.FCMUploadStatus__c = CZWTFCConstants.PROCESS_STATUS_IN_PROGRESS;
      }

      FISCCIntegrationLogService.persistIntegationLogs();
    }

    return sub;
  }
}