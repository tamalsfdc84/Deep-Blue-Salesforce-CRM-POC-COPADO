public with sharing class CZWTFCConvergeService {
  @TestVisible
  private static boolean testException = false;

  public static Map<String, Object> fetchSessionToken(Map<String, Object> params) {
    Map<String, Object> resp = new Map<String, Object>();
    HttpResponse response;
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      FISCCIntegrationLogService.setSubmissionObj(String.valueOf(params.get('SubmissionId')));
      FISCCIntegrationLogService.setIntegrationLog(String.valueOf(params.get('SubmissionId')));

      CZWTFCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.ELAVONPREAUTH);
      CZWTFCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.ELAVON, FISCCIntegrationConstants.SESSION_TOKEN, true);
      CZConvergeCharterConfiguration__mdt convergeCharterConfig = CZWTFCHelperRepository.fetchConvergeCharterConfig(
        FISCCIntegrationLogService.submissionObj.tffa__Brand__c
      );
      CZConvergeConfiguration__mdt convergeConfig = CZWTFCHelperRepository.fetchConvergeConfig('CONVERGE_SESSION_TOKEN');
      String firstName = String.valueOf(params.get('firstname'));
      String lastName = String.valueOf(params.get('lastname'));
      String zipCode = String.valueOf(params.get('zipCode'));
      if (firstName.length() > 20) {
        firstName = firstName.substring(0, 19);
      }
      if (lastName.length() > 30) {
        lastName = lastName.substring(0, 29);
      }
      if (zipCode.contains('-')) {
        zipCode = zipCode.split('-')[0];
      }
      if (zipCode.length() > 9) {
        zipCode = zipCode.substring(0, 9);
      }
      String endpoint =
        convergeConfig.EndPoint__c +
        '?ssl_merchant_id=' +
        convergeCharterConfig.MerchantId__c +
        '&ssl_pin=' +
        convergeCharterConfig.SslPin__c +
        '&ssl_user_id=' +
        convergeCharterConfig.UserId__c +
        '&ssl_transaction_type=' +
        convergeConfig.TransactionType__c +
        '&ssl_first_name=' +
        EncodingUtil.URLENCODE(String.valueOf(firstName), 'UTF-8').replaceAll('\\s+', '') +
        '&ssl_last_name=' +
        EncodingUtil.URLENCODE(String.valueOf(lastName), 'UTF-8').replaceAll('\\s+', '') +
        '&ssl_amount=' +
        String.valueOf(params.get('amount')) +
        '&ssl_avs_address=' +
        EncodingUtil.URLENCODE(String.valueOf(params.get('address')), 'UTF-8').replaceAll('\\s+', '') +
        '&ssl_avs_zip=' +
        zipCode;

      convergeConfig.EndPoint__c = endpoint;

      response = CZWTFCConvergeAdapter.execute(convergeConfig, params, '');
      if (response != null) {
        CZWTFCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.SESSION_TOKEN);
        resp.put('StatusCode', response.getStatusCode());
        resp.put('SessionToken', response.getBody());
      }
    } catch (Exception e) {
      resp.put('StatusCode', '400');
      resp.put('SessionToken', 'Unable to retrieve session token');
      tffa.Logger.error('Exception in fetchSessionToken ' + e.getStackTraceString() + e.getMessage() + e.getLineNumber());
      CZWTFCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.SESSION_TOKEN);
    } finally {
      CZWTFCIntegrationLogService.persistIntegationLogs();
    }
    tffa.Logger.debug('responseMap ' + resp);
    return resp;
  }

  public static boolean ccDeleteConvergeTrans(String submissionId, String txnId) {
    HttpResponse response;
    boolean isSuccess = false;
    tffa.Logger.debug('In CZWTFCConvergeService.ccDeleteConvergeTrans');
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      FISCCIntegrationLogService.setSubmissionObj(submissionId);
      CZWTFCIntegrationLogService.setIntegrationLog(submissionId);

      CZWTFCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.ELAVONPREAUTH);
      CZWTFCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.ELAVON, FISCCIntegrationConstants.CCDELETE, false);
      CZConvergeConfiguration__mdt convergeConfig = CZWTFCHelperRepository.fetchConvergeConfig('CONVERGE_CCDELETE');
      Map<String, Object> params = new Map<String, Object>();
      CZConvergeCharterConfiguration__mdt convergeCharterConfig = CZWTFCHelperRepository.fetchConvergeCharterConfig(
        FISCCIntegrationLogService.submissionObj.tffa__Brand__c
      );
      String request = CZWTFCConvergeService.generateCCDelTransactionReq(txnId, convergeConfig, convergeCharterConfig);
      response = CZWTFCConvergeAdapter.execute(convergeConfig, params, request);
      if (response != null && response.getBody() != null) {
        isSuccess = CZWTFCConvergeService.parseTransactionResponse(response.getBody(), FISCCIntegrationConstants.CCDELETE, null);
        return isSuccess;
      } else {
        CZWTFCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.CCDELETE);
        return false;
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in ccDeleteConvergeTrans ' + ex.getStackTraceString() + ex.getMessage() + ex.getLineNumber());
      CZWTFCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.CCDELETE);
      return false;
    } finally {
      CZWTFCIntegrationLogService.persistIntegationLogs();
    }
  }

  //rename
  public static boolean ccCompleteConvergeTrans(Map<String, Object> params, tffa__FundingRequest__c fundingObj) {
    tffa.Logger.debug('In CZWTFCConvergeService.ccCompleteConvergeTrans');
    HttpResponse response;
    boolean isSuccess = false;
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      CZConvergeCharterConfiguration__mdt convergeCharterConfig = CZWTFCHelperRepository.fetchConvergeCharterConfig(
        String.valueOf(params.get('brandCode'))
      );
      CZConvergeConfiguration__mdt convergeConfig = CZWTFCHelperRepository.fetchConvergeConfig('CONVERGE_CCCOMPLETE');
      String amnt = String.valueOf(params.get('amount'));
      String multiPartialComplete = String.valueOf(params.get('multiPartialComplete'));
      String txnId = String.valueOf(params.get('txnId'));
      String request = CZWTFCConvergeService.generateCompleteReq(txnId, convergeConfig, amnt, multiPartialComplete, convergeCharterConfig);
      response = CZWTFCConvergeAdapter.execute(convergeConfig, params, request);
      if (response != null && response.getBody() != null) {
        isSuccess = CZWTFCConvergeService.parseTransactionResponse(
          response.getBody(),
          FISCCIntegrationConstants.APPROVAL_CCCOMPLETE,
          fundingObj
        );
        return isSuccess;
      } else {
        CZWTFCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.APPROVAL_CCCOMPLETE);
        return false;
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in ccCompleteConvergeTrans ' + ex.getStackTraceString() + ex.getMessage() + ex.getLineNumber());
      CZWTFCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.CCDELETE);
      return false;
    }
  }

  public static String generateCCDelTransactionReq(
    String sslTxnId,
    CZConvergeConfiguration__mdt convergeConfig,
    CZConvergeCharterConfiguration__mdt convergeCharterConfig
  ) {
    String xmlRequest =
      'xmldata=<txn><ssl_merchant_id>' +
      convergeCharterConfig.MerchantId__c +
      '</ssl_merchant_id><ssl_user_id>' +
      convergeCharterConfig.UserId__c +
      '</ssl_user_id><ssl_pin>' +
      convergeCharterConfig.SslPin__c +
      '</ssl_pin><ssl_transaction_type>' +
      convergeConfig.TransactionType__c +
      '</ssl_transaction_type><ssl_txn_id>' +
      sslTxnId +
      '</ssl_txn_id></txn>';

    tffa.Logger.debug('Request in generateCCDelTransactionReq:: ' + xmlRequest);
    return xmlRequest;
  }

  public static String generateCompleteReq(
    String sslTxnId,
    CZConvergeConfiguration__mdt convergeConfig,
    String amnt,
    String multiPartialComplete,
    CZConvergeCharterConfiguration__mdt convergeCharterConfig
  ) {
    String xmlRequest =
      'xmldata=<txn><ssl_merchant_id>' +
      convergeCharterConfig.MerchantId__c +
      '</ssl_merchant_id><ssl_user_id>' +
      convergeCharterConfig.UserId__c +
      '</ssl_user_id><ssl_pin>' +
      convergeCharterConfig.SslPin__c +
      '</ssl_pin><ssl_transaction_type>' +
      convergeConfig.TransactionType__c +
      '</ssl_transaction_type><ssl_txn_id>' +
      sslTxnId +
      '</ssl_txn_id><ssl_amount>' +
      amnt +
      '</ssl_amount><ssl_partial_shipment_flag>' +
      multiPartialComplete +
      '</ssl_partial_shipment_flag></txn>';

    tffa.Logger.debug('Request in generateCompleteReq:: ' + xmlRequest);
    return xmlRequest;
  }

  public static boolean parseTransactionResponse(String response, String logItem, tffa__FundingRequest__c fundingObj) {
    String errorCode;
    String resultMessage;
    Dom.Document doc = new Dom.Document();
    try {
      doc.load(response);
      Dom.XmlNode rootNode = doc.getRootElement();

      tffa.Logger.debug('rootNode ' + rootNode);

      Dom.XmlNode errorXmlNode = rootNode.getChildElement('errorCode', null);

      if (errorXmlNode != null) {
        errorCode = errorXmlNode.getText();
        if (String.isNotBlank(errorCode)) {
          CZWTFCIntegrationLogService.setLogItemFailed(logItem);
          return false;
        }
      }

      Dom.XmlNode resultMessageXmlNode = rootNode.getChildElement('ssl_result_message', null);
      Dom.XmlNode txnIdXmlNode = rootNode.getChildElement('ssl_txn_id', null);

      if (txnIdXmlNode != null && fundingObj != null) {
        fundingObj.ApprovalTransRefId__c = txnIdXmlNode.getText();
      }

      if (resultMessageXmlNode != null) {
        resultMessage = resultMessageXmlNode.getText();
        if (String.isNotBlank(resultMessage) && (resultMessage.equalsIgnoreCase('APPROVAL') || resultMessage.equalsIgnoreCase('SUCCESS'))) {
          CZWTFCIntegrationLogService.setLogItemOk(logItem);
          return true;
        }
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in parseTransactionResponse ' + ex.getStackTraceString() + ex.getMessage() + ex.getLineNumber());
      CZWTFCIntegrationLogService.setLogItemFailed(logItem);
      return false;
    }
    CZWTFCIntegrationLogService.setLogItemFailed(logItem);
    return false;
  }
}