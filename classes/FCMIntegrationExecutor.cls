public inherited sharing class FCMIntegrationExecutor {
  public static List<UploadFileHistory__c> updatedUploadHistoryList = new List<UploadFileHistory__c>();
  public static Boolean errorFlag = false;
  public static Set<String> fcmFileExtension = new Set<String>{ 'jpg', 'jpeg', 'png', 'pdf' };
  public static Map<String, tffa__Party__c> partyMap = new Map<String, tffa__Party__c>();

  public static tffa__Application__c processRequest(tffa__Application__c app) {
    try {
      tffa.Logger.debug('Submission : ' + app.tffa__Submission__c);

      FISCCIntegrationLogService.applicationCode = 'FCM';
      FISCCIntegrationLogService.setSubmissionObj(String.valueOf(app.tffa__Submission__c));
      FISCCIntegrationLogService.setIntegrationLog(String.valueOf(app.tffa__Submission__c));

      // Fetch Auth token
      FISCCIntegrationLogService.auth = FISCCGetAccessTokenProvider.processGetAccessToken(FISCCIntegrationLogService.charterConfig);

      if (String.isEmpty(FISCCIntegrationLogService.auth) && !Test.isRunningTest()) {
        errorFlag = true;
        return app;
      }

      // Fetch Entity Auth Token
      FISCCIntegrationLogService.entityAuthToken = FCMGetEntityAuthorizationTokenProvider.processGetAuthorizationTokenToken(
        FISCCIntegrationLogService.charterConfig
      );

      if (String.isEmpty(FISCCIntegrationLogService.entityAuthToken) && !Test.isRunningTest()) {
        errorFlag = true;
        return app;
      }
      List<UploadFileHistory__c> uploadHistoryList = FCMHelperRepository.fetchFCMFileHistory(app.id);

      Map<String, UploadFileHistory__c> fileHistoryMap = new Map<String, UploadFileHistory__c>();
      for (UploadFileHistory__c obj : uploadHistoryList) {
        fileHistoryMap.put(obj.DocumentId__c + (obj.CZPartyID__c == null ? '' : obj.CZPartyID__c), obj);
      }

      tffa.Logger.debug('fileHistoryMap : ' + fileHistoryMap);

      // Get all uploaded images by party
      List<CZFCMContentVersionDTO> tempContentVersionList = getContentVersions(new List<Id>{ String.valueOf(app.tffa__Submission__c) });

      List<CZFCMContentVersionDTO> contentVersionList = new List<CZFCMContentVersionDTO>();
      for (CZFCMContentVersionDTO cv : tempContentVersionList) {
        if (fcmFileExtension.contains(cv.FileExtension)) {
          contentVersionList.add(cv);
        }
      }

      // Get all Disclosures (PDF)
      List<CZFCMContentVersionDTO> disclosureContent = FCMHelperRepository.findContentVersionBySubmissionId(
        new List<Id>{ String.valueOf(app.tffa__Submission__c) }
      );

      if (contentVersionList != null && disclosureContent != null) {
        contentVersionList.addAll(disclosureContent);
      }

      Set<String> partyIds = new Set<String>();
      for (CZFCMContentVersionDTO cvDTO : contentVersionList) {
        if (cvDTO.PartyId != null && String.isNotBlank(cvDTO.PartyId)) {
          partyIds.add(cvDTO.PartyId);
        }
      }

      for (tffa__Party__c party : CZWTFCPartyRepository.fetchPartyByIds(partyIds)) {
        partyMap.put(party.Id, party);
      }

      tffa.Logger.debug('contentVersionList : ' + contentVersionList);

      if (contentVersionList != null && fileHistoryMap != null) {
        for (CZFCMContentVersionDTO cv : contentVersionList) {
          UploadFileHistory__c uploadFileHistory = fileHistoryMap.get(cv.ContentVersionId + cv.PartyId);

          if (uploadFileHistory == null) {
            uploadFileHistory = new UploadFileHistory__c();
            uploadFileHistory.ApplicationID__c = app.id;
            uploadFileHistory.SubmissionID__c = String.valueOf(app.tffa__Submission__c);
            uploadFileHistory.BrandCode__c = app.tffa__Brand__c;
            uploadFileHistory.FileName__c = cv.PathOnClient;
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

          if (cv.contentSize > FISCCIntegrationConstants.MAX_ALLOWED_FILE_SIZE) {
            uploadFileHistory.FileTransferStatus__c = CZWTFCConstants.PROCESS_STATUS_FAILURE;
            uploadFileHistory.FileTransferStatusMessage__c = 'File size too large. Cannot transfer';
            updatedUploadHistoryList.add(uploadFileHistory);
            continue;
          }

          try {
            if (String.isEmpty(uploadFileHistory.FCMDocumentId__c)) {
              uploadFileHistory.FCMDocumentId__c = FCMDocumentProvider.generateFCMDocumentId(
                app,
                cv,
                partyMap.get(uploadFileHistory.CZPartyID__c),
                FISCCIntegrationLogService.charterConfig
              );
            }

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
    } finally {
      // Update or Insert Upload file history record
      if (updatedUploadHistoryList != null) {
        FCMHelperRepository.save(updatedUploadHistoryList);
      }

      // Update application level FCMUploadStatus__c to sucess only when all files are uploade sucessfully.
      if (errorFlag) {
        app.FCMUploadStatus__c = CZWTFCConstants.PROCESS_STATUS_FAILURE;
        app.FCMUploadRetryCount__c++;
      } else {
        app.FCMUploadStatus__c = CZWTFCConstants.PROCESS_STATUS_SUCCESS;
      }

      FISCCIntegrationLogService.persistIntegationLogs();
    }

    return app;
  }

  /**
   * Get all content versions by submissionid
   */
  public static List<CZFCMContentVersionDTO> getContentVersions(List<Id> idList) {
    List<ContentDocumentLink> cdlList = FCMHelperRepository.findCDLinkByIdList(idList);

    List<Id> contentdocumentids = new List<Id>();
    for (ContentDocumentLink cdl : cdlList) {
      if (cdl.ContentDocumentId != null) {
        contentdocumentids.add(cdl.ContentDocumentId);
      }
    }

    List<ContentVersion> contentVerList = FCMHelperRepository.findCVdataByDocId(contentdocumentids);

    List<CZFCMContentVersionDTO> contentVersionDTOList = new List<CZFCMContentVersionDTO>();
    for (ContentVersion cv : contentVerList) {
      CZFCMContentVersionDTO dto = new CZFCMContentVersionDTO();

      dto.ContentVersionId = (String) cv.Id;
      dto.Title = (String) cv.Title;
      dto.FileExtension = (String) cv.FileExtension;
      dto.PathOnClient = (String) cv.PathOnClient;
      dto.PartyId = '';
      dto.contentSize = cv.contentSize;

      contentVersionDTOList.add(dto);
    }

    return contentVersionDTOList;
  }
}