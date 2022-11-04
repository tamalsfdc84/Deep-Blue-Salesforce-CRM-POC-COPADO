public class CZMulesoftFileTransferService {
  public static String authHeader;
  public static void transferSingleFile(UploadFileHistory__c file, ContentVersion cv, Nacha_Config__mdt wtfcnachaConfig) {
    Boolean isException = false;
    tffa.Logger.debug('Transfer file started for ' + cv.Title + ' & File type :' + cv.FileType + ' cv.PathOnClient:' + cv.PathOnClient);

    HttpRequest req2 = new HttpRequest();
    req2 = createApiReq(cv, wtfcnachaConfig, file);
    Http h2 = new Http();
    HttpResponse resp = new HttpResponse();
    try {
      resp = h2.send(req2);
      tffa.Logger.debug('Resp body File transfer is =' + resp.getBody());
    } catch (exception e) {
      tffa.Logger.error('Exception API call: ==-> ' + e.getMessage() + ' ' + e.getStackTraceString());
      cv.FileTransferStatusMessage__c = e.getMessage();
      isException = true;
    } finally {
      tffa.Logger.debug('response--- File transfer--->' + resp);
      // file.FileTransferRetryCount__c = file.FileTransferRetryCount__c + 1;
      if (resp.getStatusCode() == 200) {
        file.FileTransferStatus__c = CZWTFCConstants.FILE_TRANSFER_SUCCESS;
        cv.FileTransferStatus__c = CZWTFCConstants.FILE_TRANSFER_SUCCESS;
        cv.FileTransferStatusMessage__c = 'File upload successful';
        tffa.Logger.debug(cv.FileTransferStatusMessage__c);
      } else {
        file.FileTransferStatus__c = 'Failure';
        file.FileTransferRetryCount__c = file.FileTransferRetryCount__c + 1;
        cv.FileTransferStatus__c = 'Failure';
        if (!isException)
          cv.FileTransferStatusMessage__c = 'File upload failed' + ' error code ' + resp.getStatusCode() + ' error msg ' + resp.getBody();
        tffa.Logger.debug(cv.FileTransferStatusMessage__c);
      }
      if (file.FileType__c == CZWTFCConstants.STARTER_CHECK) {
        if (isException) {
          CZWTFCIntegrationLogService.setLogItemRequestAndResponse(null, cv.FileTransferStatusMessage__c);
        } else {
          CZWTFCIntegrationLogService.setLogItemRequestAndResponse(null, resp.getBody());
        }
      }
    }
  }

  public static CZWTFCFileTransferResultDTO transferFiles(List<ContentVersion> cvList, Map<String, UploadFileHistory__c> fileMap) {
    UploadFileHistory__c file;
    Nacha_Config__mdt wtfcnachaConfig = CZWTFCCustomMetadataRepository.fetchWtfcNachaConfig();
    tffa.Logger.debug('wtfcnachaConfig--:' + wtfcnachaConfig);
    for (ContentVersion cv : cvList) {
      file = fileMap.get(cv.ContentDocumentId);
      transferSingleFile(file, cv, wtfcnachaConfig);
    }
    List<UploadFileHistory__c> files = new List<UploadFileHistory__c>();
    for (UploadFileHistory__c file1 : fileMap.values()) {
      files.add(file1);
    }

    CZWTFCFileTransferResultDTO fileTransferResultDTO = new CZWTFCFileTransferResultDTO();

    fileTransferResultDTO.files = files;
    fileTransferResultDTO.cvList = cvList;

    return fileTransferResultDTO;
  }

  public static HttpRequest createApiReq(ContentVersion cv, Nacha_Config__mdt wtfcnachaConfig, UploadFileHistory__c file) {
    if (authHeader == null) {
      if (!Test.isRunningTest()) {
        authHeader = CZWTFCMulesoftOAuthProvider.getAuthHeader();
      } else {
        authHeader = 'Bearer abcdTest';
      }
    }
    HttpRequest req = new HttpRequest();
    String separationString = '%$##$%%$##$%';
    String bcode = file.BrandCode__c;
    String sNo = file.SerialNumber__c;
    String filedate = System.now().format('MMddYYYYHHmmss');
    String encodedHash = createHash(cv);
    tffa.Logger.debug('encodedHash:' + encodedHash);
    String bodyPayload = createPayload(cv, separationString);
    String fileType = file.FileType__c;

    if (file.FileType__c == 'ACH') {
      fileType = 'NACHA';
    }
    req.setEndpoint(
      wtfcnachaConfig.API_Endpoint__c +
      'charter_id=' +
      bcode +
      '&file_dt=' +
      filedate +
      '&file_sno=' +
      sNo +
      '&file_type=' +
      fileType
    );
    req.setMethod(wtfcnachaConfig.METHOD__c);
    req.setHeader('Content-MD5', encodedHash);
    req.setHeader('Content-Type', 'multipart/form-data; boundary=' + separationString);
    req.setHeader('Content-Length', String.valueOf(bodyPayload.length()));
    req.setHeader('Authorization', authHeader);
    req.setBody(bodyPayload);
    req.setTimeout(120000);
    return req;
  }

  public static String createHash(ContentVersion cv) {
    Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(EncodingUtil.base64Encode(cv.VersionData)));
    String encodedHash = EncodingUtil.convertToHex(hash);
    return encodedHash;
  }

  public static String createPayload(ContentVersion cv, String separationString) {
    String NEW_LINE = '\r\n';
    String filename = cv.PathOnClient;
    String header =
      '--' +
      separationString +
      NEW_LINE +
      'Content-Disposition: form-data; name="file"; filename="' +
      fileName +
      '"' +
      NEW_LINE +
      'Content-Type: application/octet-stream' +
      NEW_LINE +
      NEW_LINE;
    String body = EncodingUtil.base64Encode(cv.VersionData);
    String footer = NEW_LINE + '--' + separationString + '--';
    String bodyPayload = header + body + footer;
    return bodyPayload;
  }
}