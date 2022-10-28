public class CZNachaFilesTransferService {
  public static CZWTFCFileTransferResultDTO transferFiles(List<ContentVersion> cvList, Map<String, UploadFileHistory__c> fileMap) {
    UploadFileHistory__c file;

    Nacha_Config__mdt wtfcnachaConfig = CZWTFCCustomMetadataRepository.fetchWtfcNachaConfig();
    Double retryCount = (Double) wtfcnachaConfig.Max_Retry_Count__c;
    String client_id = (String) wtfcnachaConfig.CLIENT_ID__c;
    String client_secret = (String) wtfcnachaConfig.CLIENT_SECRET__c;
    String authTokenEndPoint = (String) wtfcnachaConfig.Oauth_Endpoint__c;
    String grant_type = (String) wtfcnachaConfig.GRANT_TYPE__c;
    String method = (String) wtfcnachaConfig.METHOD__c;
    String APIEndPoint = (String) wtfcnachaConfig.API_Endpoint__c;
    tffa.Logger.debug('wtfcnachaConfig--:' + wtfcnachaConfig);
    for (ContentVersion cv : cvList) {
      if (fileMap == null) {
        fileMap = new Map<String, UploadFileHistory__c>();
      }

      file = fileMap.get(cv.ContentDocumentId);
      Boolean isException = false;
      tffa.Logger.debug('Transfer file started for ' + cv.Title + ' & File type :' + cv.FileType + ' cv.PathOnClient:' + cv.PathOnClient);
      String filename = cv.PathOnClient;
      //HttpRequest req = new HttpRequest();
      /*req = createOauthTokenReq(wtfcnachaConfig);
      Http h = new Http();
      HttpResponse res = new HttpResponse();
      try {
        if (!Test.isRunningTest()) {
        //  res = h.send(req);
          tffa.Logger.debug('Oauthtoken res:' + res.getBody());
        } else {
          res.setBody('{"access_token":"qx1dT61EcC1mvNROMNUOOu6J1PCD","token_type":"Bearer","expires_in":7200}');
        }
      } catch (exception e) {
        tffa.Logger.error('Oauthtoken exception message ::' + e.getMessage());
      }
      */
      String auth_header;
      if (!Test.isRunningTest()) {
        auth_header = CZWTFCMulesoftOAuthProvider.getAuthHeader();
      } else {
        auth_header = 'Bearer abcdTest';
      }
      HttpRequest req2 = new HttpRequest();
      req2 = createApiReq(cv, wtfcnachaConfig, auth_header, file);
      Http h2 = new Http();
      HttpResponse resp = new HttpResponse();
      try {
        resp = h2.send(req2);
        tffa.Logger.debug('Resp for Nacha File transfer is =' + resp);
        tffa.Logger.debug('Resp body for Nacha File transfer is =' + resp.getBody());
      } catch (exception e) {
        tffa.Logger.error('Exception API call: ==-> ' + e.getMessage() + ' ' + e.getStackTraceString());
        cv.FileTransferStatusMessage__c = e.getMessage();
        isException = true;
      } finally {
        tffa.Logger.debug('response---Nacha File transfer--->' + resp);
        file.FileTransferRetryCount__c = file.FileTransferRetryCount__c + 1;
        if (resp.getStatusCode() == 200) {
          file.FileTransferStatus__c = CZWTFCConstants.FILE_TRANSFER_SUCCESS;
          cv.FileTransferStatus__c = CZWTFCConstants.FILE_TRANSFER_SUCCESS;
          cv.FileTransferStatusMessage__c = 'File upload successful';
          tffa.Logger.debug(cv.FileTransferStatusMessage__c);
        } else {
          file.FileTransferStatus__c = 'Failure';
          cv.FileTransferStatus__c = 'Failure';
          if (!isException)
            cv.FileTransferStatusMessage__c = 'File upload failed' + ' error code ' + resp.getStatusCode() + ' error msg ' + resp.getBody();
          tffa.Logger.debug(cv.FileTransferStatusMessage__c);
        }
      }

      fileMap.put(cv.ContentDocumentId, file);
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

  public static HttpRequest createOauthTokenReq(Nacha_Config__mdt wtfcnachaConfig) {
    HttpRequest req = new HttpRequest();
    String clientid = (String) wtfcnachaConfig.CLIENT_ID__c;
    String clientsecret = (String) wtfcnachaConfig.CLIENT_SECRET__c;
    String granttype = (String) wtfcnachaConfig.GRANT_TYPE__c;
    String authTokenEndPoint = (String) wtfcnachaConfig.Oauth_Endpoint__c;
    String method = (String) wtfcnachaConfig.METHOD__c;
    req.setEndpoint(authTokenEndPoint);
    req.setMethod(method);
    req.setBody('grant_type=' + granttype + '&client_id=' + clientid + '&client_secret=' + clientsecret);
    tffa.Logger.debug('Oauth token req:' + req.getBody());
    return req;
  }

  public static HttpRequest createApiReq(
    ContentVersion cv,
    Nacha_Config__mdt wtfcnachaConfig,
    String auth_header,
    UploadFileHistory__c file
  ) {
    HttpRequest req = new HttpRequest();
    String method = (String) wtfcnachaConfig.METHOD__c;
    String APIEndPoint = (String) wtfcnachaConfig.API_Endpoint__c;
    String separationString = '%$##$%%$##$%';
    String bcode = file.BrandCode__c;
    String sNo = file.SerialNumber__c;
    String filedate = System.now().format('MMddYYYYHHmmss');
    String encodedHash = createHash(cv);
    tffa.Logger.debug('encodedHash:' + encodedHash);
    String bodyPayload = createPayload(cv, separationString);
    req.setEndpoint(APIEndPoint + 'charter_id=' + bcode + '&file_dt=' + filedate + '&file_sno=' + sNo);
    req.setMethod(method);
    req.setHeader('Content-MD5', encodedHash);
    req.setHeader('Content-Type', 'multipart/form-data; boundary=' + separationString);
    req.setHeader('Content-Length', String.valueOf(bodyPayload.length()));
    req.setHeader('Authorization', auth_header);
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