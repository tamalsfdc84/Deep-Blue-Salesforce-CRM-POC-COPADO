/**
 * Copyright (c) 2019 Terafina Inc
 *
 * @description Upload File Transfer Batch job
 * @group Job
 */
global inherited sharing class CZNachaFileTransferBatch extends tffa.AbstractBatchJob implements Database.Batchable<sObject>, Database.AllowsCallouts {
  @TestVisible
  private static boolean testException = false;
  private final String templateName = 'ACHFileTransferReport';
  global List<UploadFileHistory__c> start(Database.BatchableContext bc) {
    List<UploadFileHistory__c> fileList = new List<UploadFileHistory__c>();
    fileList.addAll(CZWTFCACHRepository.fetchACHNachaFileTransferResults());
    tffa.Logger.flush();
    return fileList;
  }
  global void execute(Database.BatchableContext batchableContext, List<UploadFileHistory__c> files) {
    UploadFileHistory__c file;
    list<Id> docIds = new List<Id>();
    CZWTFCFileTransferResultDTO fileTransferResultDTO = new CZWTFCFileTransferResultDTO();
    tffa.Interaction.begin(CZNachaFileTransferBatch.class, 'execute');
    try {
      for (UploadFileHistory__c f : files) {
        if (f.DocumentId__c != null) {
          docIds.add(f.DocumentId__c);
        }
      }
      Map<String, UploadFileHistory__c> fileMap = new Map<String, UploadFileHistory__c>();

      for (UploadFileHistory__c uploadFile : files) {
        fileMap.put(uploadFile.DocumentId__c, uploadFile);
      }

      List<ContentVersion> cvList = ACHFileTransRepository.findCVByDocId(docIds);
      fileTransferResultDTO = CZMulesoftFileTransferService.transferFiles(cvList, fileMap);

      ACHFileTransRepository.save(fileTransferResultDTO.files);
    } catch (exception e) {
      tffa.Logger.error('Exception : ==-> ' + e.getMessage() + ' ' + e.getStackTraceString());
    } finally {
      try {
        sendEmail(fileTransferResultDTO.cvList);
      } finally{
        tffa.Interaction.close();
      }
    }
  }
  global void finish(Database.BatchableContext batchableContext) {
    tffa.Logger.debug('CZNachaFileTransferBatch finish()');
    tffa.Logger.flush();
  }

  public void sendEmail(List<ContentVersion> cvList) {
    try {
      List<tffa.NotificationDTO> notifications = new List<tffa.NotificationDTO>();
      Nacha_Config__mdt wtfcnachaConfig = CZWTFCCustomMetadataRepository.fetchWtfcNachaConfig();
      String emailid = wtfcnachaConfig.File_Upload_Failed_Mail_Id__c == null ? '' : wtfcnachaConfig.File_Upload_Failed_Mail_Id__c;
      List<String> emailIdList = emailid.split(',');
      tffa.NotificationDTO.NotificationRecipientDTO[] recipients = new List<tffa.NotificationDTO.NotificationRecipientDTO>{};

      if (emailIdList != null && !emailIdList.isEmpty()) {
        for (String mail : emailIdList) {
          recipients.add(
            new tffa.NotificationDTO.NotificationRecipientDTO(tffa.NotificationDTO.NotificationRecipientType.USER, null, null, mail, null)
          );
        }
      }
      String htmlBody = '';

      List<SObject> fundingRequestList = CZWTFCACHRepository.getFundingRequestsForACHFileGenerationBatch();
      Map<string, Map<String, Integer>> achFundingRequestDetailsMap = new Map<String, Map<String, Integer>>();
      tffa__FundingRequest__c fundingReq;
      List<tffa__FundingRequest__c> fundingRequeststoUpdate = new List<tffa__FundingRequest__c>();
      for (SObject fundingRequest : fundingRequestList) {
        fundingReq = (tffa__FundingRequest__c) fundingRequest;
        fundingReq.ACHReportGenerated__c = true;
        fundingRequeststoUpdate.add(fundingReq);
        Map<String, Integer> fundingRequestStatusMap = new Map<String, Integer>();
        if (achFundingRequestDetailsMap.ContainsKey(fundingReq.tffa__Submission__r.tffa__Brand__c)) {
          fundingRequestStatusMap = achFundingRequestDetailsMap.get(fundingReq.tffa__Submission__r.tffa__Brand__c);
          if (fundingRequestStatusMap.containsKey(fundingReq.tffa__Status__c)) {
            fundingRequestStatusMap.put(fundingReq.tffa__Status__c, fundingRequestStatusMap.get(fundingReq.tffa__Status__c) + 1);
          } else {
            fundingRequestStatusMap.put(fundingReq.tffa__Status__c, 1);
          }
        } else {
          fundingRequestStatusMap.put(fundingReq.tffa__Status__c, 1);
          achFundingRequestDetailsMap.put(fundingReq.tffa__Submission__r.tffa__Brand__c, fundingRequestStatusMap);
        }
      }
      if (!achFundingRequestDetailsMap.IsEmpty() || cvList != null) {
        htmlBody = 'Hi,<br/>ACH Batch Job has completed.<br/>Below are the details.<br/><br/>';
      } else {
        htmlBody = 'Hi,<br/>ACH Batch Job has completed.<br/>There were no records to process.<br/><br/>';
      }

      if (!achFundingRequestDetailsMap.IsEmpty()) {
        htmlBody += '<table border="1" style="border-collapse: collapse"><caption>ACH Request File Generation Status</caption><tr><th>Brand</th><th>ACH Request Status</th><th>Record Count</th></tr>';
        Integer count;
        for (String brandCode : achFundingRequestDetailsMap.keyset()) {
          Map<String, Integer> statusMap = achFundingRequestDetailsMap.get(brandCode);
          string status;
          for (String statusfromMap : statusMap.keyset()) {
            status = statusfromMap;
            count = statusMap.get(status);
            htmlBody += '<tr><td>' + brandCode + '</td>';
            htmlBody += '<td>' + status + '</td>';
            htmlBody += '<td>' + count + '</td></tr>';
          }
        }
        htmlBody += '</table><br/><br/>';
      }
      if (cvList != null) {
        htmlBody += '<table border="1" style="border-collapse: collapse"><caption>File Transfer Status</caption>';
        for (ContentVersion cv : cvList) {
          if (cv.FileTransferStatus__c == CZWTFCConstants.FILE_TRANSFER_SUCCESS) {
            htmlBody += '<tr><td>' + String.valueOf(cv.PathOnClient + '   ' + cv.FileTransferStatusMessage__c) + +'</td></tr>';
          }
          if (cv.FileTransferStatus__c == 'Failure') {
            htmlBody += '<tr><td>' + String.valueOf(cv.PathOnClient + '   ' + cv.FileTransferStatusMessage__c) + '</td></tr>';
          }
        }
        htmlBody += '</table>';
      }

      if (htmlBody != '' && !emailIdList.isEmpty()) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.ToAddresses = emailIdList;
        mail.HTMLBody = htmlBody;
        mail.Subject = 'ACH File Transfer Report';
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>{ mail };
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        if (results[0].success) {
          WTFCObjectManagerRepository.doUpsertObjects(fundingRequeststoUpdate);
        } else {
          tffa.Logger.error('FileTransferBatch email failed :' + results[0].errors[0].message);
        }
      }
    } catch (Exception ex) {
      tffa.Logger.error('FileTransferBatch email failed :' + ex.getMessage() + ' ' + ex.getStackTraceString());
    }
  }
}