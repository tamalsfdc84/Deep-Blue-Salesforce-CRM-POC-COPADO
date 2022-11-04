public inherited sharing class CZStarterCheckExecutor {
  public static List<UploadFileHistory__c> uploadFileHistoryList = new List<UploadFileHistory__c>();

  public static void processRequest(tffa__Application__c app) {
    FISCCIntegrationLogService.applicationCode = FISCCIntegrationConstants.STARTER_CHECK;
    tffa__AccountPreference__c accPref;
    try {
      for (tffa__AccountPreference__c accPrefObj : app.tffa__AccountPreferences__r) {
        if (('CHECK-ORDER').equals(accPrefObj.tffa__Code__c) && accPrefObj.CZIsStarterCheckRequired__c) {
          accPref = accPrefObj;
          break;
        }
      }
      if (accPref == null) {
        return;
      }
      FISCCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.STARTER_CHECK + '-' + app.Name + '-' + app.tffa__AccountNumber__c);
      WintrustEnvConfig__mdt wintrustEnvConfig = CZWTFCHelperRepository.fetchWintrustEnvConfig();

      List<UploadFileHistory__c> uploadHistoryList = CZWTFCHelperRepository.fetchUploadFileHistory(app.Id, CZWTFCConstants.STARTER_CHECK);
      Integer fileNumber = 1;
      Integer chqStartNum = Integer.valueOf(app.tffa__Product__r.CZStarterCheckStartNumber__c);
      if (chqStartNum == 0 || chqStartNum == null) {
        chqStartNum = CZWTFCConstants.STARTER_CHECK_START_NUMBER;
      }
      Integer starterCheckCount = Integer.valueOf(app.tffa__Product__r.CZStarterCheckCount__c);
      if (starterCheckCount == 0 || starterCheckCount == null) {
        starterCheckCount = CZWTFCConstants.STARTER_CHECK_COUNT;
      }

      Decimal temp = starterCheckCount / 3.0;
      Integer totalFileCount = (Integer) temp.round(roundingMode.UP);

      tffa.Logger.debug('CZStarterCheckExecutor totalFileCount ' + totalFileCount);

      while (fileNumber <= totalFileCount) {
        UploadFileHistory__c uploadFileHistory;
        if (uploadHistoryList != null) {
          for (UploadFileHistory__c uploadFileHistoryObj : uploadHistoryList) {
            if (Integer.valueOf(uploadFileHistoryObj.SerialNumber__c) == fileNumber) {
              uploadFileHistory = uploadFileHistoryObj;
              break;
            }
          }
        }

        if (uploadFileHistory != null && uploadFileHistory.FileTransferStatus__c == CZWTFCConstants.PROCESS_STATUS_SUCCESS) {
          tffa.Logger.debug('CZStarterCheckExecutor fileNumber :' + uploadFileHistory.FileName__c + ' already exist.');
          fileNumber++;
          continue;
        }

        FISCCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.STARTER_CHECK, app.id, true);
        try {
          tffa.Logger.debug('CZStarterCheckExecutor chqStartNum :' + chqStartNum);
          tffa.Logger.debug('CZStarterCheckExecutor fileNumber :' + fileNumber);

          CZWTFCPrintRequestDTO request = new CZWTFCPrintRequestDTO();
          request.PrintRequest.CheckData.JobID = accPref.StarterCheckJobID__c;
          request.PrintRequest.CheckData.CustomerData01 = app.CZTitle1__c;
          request.PrintRequest.CheckData.CustomerData02 = app.CZTitle2__c;
          request.PrintRequest.CheckData.CustomerData03 = app.CZTitle3__c;

          if (app.tffa__Address__r != null) {
            tffa__Address__c addressObj = app.tffa__Address__r;
            request.PrintRequest.CheckData.CustomerData04 =
              addressObj.tffa__Line1__c + (addressObj.tffa__Line2__c != null ? ', ' + addressObj.tffa__Line2__c : '');

            request.PrintRequest.CheckData.CustomerData05 =
              addressObj.tffa__City__c +
              (addressObj.tffa__State__c != null ? ', ' + addressObj.tffa__State__c : '') +
              ', ' +
              addressObj.tffa__ZipCode__c;
          }

          request.PrintRequest.CheckData.CheckNumber01 = ((fileNumber - 1) * 3) + chqStartNum;
          request.PrintRequest.CheckData.CheckNumber02 = ((fileNumber - 1) * 3) + chqStartNum + 1;
          request.PrintRequest.CheckData.CheckNumber03 = ((fileNumber - 1) * 3) + chqStartNum + 2;
          request.PrintRequest.CheckData.BranchID = app.FISBranchCode__c;
          request.PrintRequest.CheckData.RoutingNumber = FISCCIntegrationLogService.submissionObj.tffa__BrandEntity__r.tffa__RoutingNumber__c;
          request.PrintRequest.CheckData.AccountNumber = app.tffa__AccountNumber__c;
          request.PrintRequest.CheckData.UserID = wintrustEnvConfig.StarterCheckUserID__c;

          String bulkContent = '<?xml version="1.0"?>' + new CZWTFCXMLSerializer().serialize(request);
          tffa.Logger.debug('CZStarterCheckExecutor bulkContent : ' + bulkContent);

          String fileName = 'Starter_Check_' + accPref.StarterCheckJobID__c + '-' + fileNumber + '.txt';
          if (uploadFileHistory == null)
            uploadFileHistory = setUploadHistory(app, fileName, fileNumber);

          Nacha_Config__mdt wtfcnachaConfig = CZWTFCCustomMetadataRepository.fetchWtfcNachaConfig();
          /*ContentVersion created only to pass file name and file contents. ContentVersion is not to be saved*/
          ContentVersion cv = new ContentVersion();
          cv.PathOnClient = fileName;
          cv.VersionData = Blob.valueOf(bulkContent);
          FISCCIntegrationLogService.setLogItemRequestAndResponse(
            'File Name : ' +
            fileName +
            '\n' +
            '    File Contents : ' +
            bulkContent,
            null
          );
          CZMulesoftFileTransferService.transferSingleFile(uploadFileHistory, cv, wtfcnachaConfig);

          uploadFileHistoryList.add(uploadFileHistory);

          tffa.Logger.debug('CZStarterCheckExecutor New File Generated* ');
        } catch (Exception ex) {
          FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.LOG_ITEM_STATUS_FAILURE);
          tffa.Logger.error('Exception in CZStarterCheckExecutor :' + ex.getMessage() + ' :: ' + ex.getStackTraceString());
        } finally {
          fileNumber++;
        }
        FISCCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.LOG_ITEM_STATUS_SUCCESS);
        if (Test.isRunningTest()) {
          break;
        }
      }

      FISCCIntegrationLogService.setUploadFileHistory(uploadFileHistoryList);
      FISCCIntegrationLogService.setLogOk(FISCCIntegrationConstants.LOG_ITEM_STATUS_SUCCESS);
    } catch (Exception ex) {
      FISCCIntegrationLogService.setLogFailed(FISCCIntegrationConstants.LOG_ITEM_STATUS_FAILURE);
      tffa.Logger.error('Exception in CZStarterCheckExecutor :' + ex.getMessage() + ' :: ' + ex.getStackTraceString());
    }
  }

  public static UploadFileHistory__c setUploadHistory(tffa__Application__c app, String fileName, Integer fileNumber) {
    UploadFileHistory__c uploadFileHistory = new UploadFileHistory__c();
    uploadFileHistory.ApplicationID__c = app.id;
    uploadFileHistory.SubmissionID__c = String.valueOf(app.tffa__Submission__c);
    uploadFileHistory.BrandCode__c = app.tffa__Brand__c;
    uploadFileHistory.FileName__c = fileName;
    uploadFileHistory.FileExt__c = 'txt';
    uploadFileHistory.FileType__c = CZWTFCConstants.STARTER_CHECK;
    uploadFileHistory.FileTransferStatus__c = CZWTFCConstants.PROCESS_STATUS_FAILURE;
    uploadFileHistory.SubmissionName__c = FISCCIntegrationLogService.submissionObj.Name;
    uploadFileHistory.SerialNumber__c = String.valueOf(fileNumber);
    return uploadFileHistory;
  }
}