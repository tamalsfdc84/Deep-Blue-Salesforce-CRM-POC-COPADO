public inherited sharing class FCMGenerateDocumentIdExtension {
  public static String docId = '';
  public static String getFCMDocumentId(tffa__Application__c app, CZFCMContentVersionDTO contentVersionDTO, tffa__Party__c party, FISCC_Adapter_Configs__mdt adapterConfig, FISCC_Charter_Config__mdt charterConfig) {
    FISCCRequestBaseDTO fisccRequestBaseDTO = null;
    Object result = null;
    try {
      fisccRequestBaseDTO = createGetFCMDocumentIdRequest(app, contentVersionDTO, party, adapterConfig, charterConfig);

      result = FISCCHostAdapter.processHostRequest(fisccRequestBaseDTO, adapterConfig, charterConfig);
      
      isFCMAPICallSuccess(result);

      return docId;
    } catch (Exception ex) {
      tffa.Logger.error('Exception in getAccessToken : ' + ex.getMessage() + ex.getLineNumber() + ex.getStackTraceString());
      return docId;
    }
  }

  public static FISCCRequestBaseDTO createGetFCMDocumentIdRequest(
    tffa__Application__c app, 
    CZFCMContentVersionDTO contentVersionDTO, 
    tffa__Party__c party,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    FISCCRequestBaseDTO fisccRequestBaseDTO = null;
    FCMGenerateDocumentIdRequest request = new FCMGenerateDocumentIdRequest();
    FCMGenerateDocumentIdRequest.Accounts accountObj = new FCMGenerateDocumentIdRequest.Accounts();
    try {
    
      request.dtype = 'Account Opening Documents – Digital';
      request.ftype = fetchFileType(contentVersionDTO.FileExtension);
      request.FCMUploadDate = fetchDate();
      accountObj.account = app.tffa__AccountNumber__c;

      if(party != null){
        contentVersionDTO.Title = contentVersionDTO.Title + ';' + party.Name;
      }
      
      request.docdescription = 'Digital:' + contentVersionDTO.Title;

      String fcmAccountType = getFCMAccountType(app.tffa__Product__r, app.tffa__Brand__c);

      if(fcmAccountType != ''){
        accountObj.application = fcmAccountType;
      }

      request.accountlist.add(accountObj);

      fisccRequestBaseDTO = request;

      tffa.Logger.debug('fisccRequestBaseDTO::'+ fisccRequestBaseDTO);

      return fisccRequestBaseDTO;
    } catch (Exception ex) {
      tffa.Logger.error(
        'Exception in FCMGenerateDocumentIdExtension createGetFCMDocumentIdRequest : ' +
        ex.getMessage() +
        ex.getLineNumber() +
        ex.getStackTraceString()
      );
    }
    return fisccRequestBaseDTO;
  }

  public static void isFCMAPICallSuccess(Object response) {
    FCMGenerateDocIdResponse objFCMGenerateDocumentIdResponse = null;
    try {    
      objFCMGenerateDocumentIdResponse = (FCMGenerateDocIdResponse) response;
      docId = objFCMGenerateDocumentIdResponse.docid;

    } catch (Exception ex) {
      tffa.Logger.error(
        'Exception in FCMGenerateDocumentIdExtension isFCMAPICallSuccess : ' +
        ex.getMessage() +
        ex.getLineNumber() +
        ex.getStackTraceString()
      );
    }
  }

  public static String fetchFileType(String type) {
    if (type.equalsIgnoreCase('jpeg') || type.equalsIgnoreCase('jpg')) {
      return 'jpg';
    } else if (type.equalsIgnoreCase('tif') || type.equalsIgnoreCase('tiff')) {
      return 'tif';
    }

    return 'pdf';
  }

  public static String fetchDate() {
    DateTime d = Date.Today();
    return d.format('MM/dd/yyyy');
  }

  public static String getFCMAccountType(tffa__Product__c product, String brancdCode) {
    String productTypecode = '';
    String fcmAccountType = '';
    if (product.tffa__Category__c == 'CERTIFICATE') {
      productTypecode = productTypecode + brancdCode + ' CD';
    } else if (product.tffa__Category__c == 'CHECKING') {
      productTypecode = productTypecode + brancdCode + ' DDA';
    } else if (product.tffa__Category__c == 'SAVINGS' && product.IsMoneyMarketProduct__c) {
      productTypecode = productTypecode + brancdCode + ' DDA';
    } else if (product.tffa__Category__c == 'SAVINGS') {
      productTypecode = productTypecode + brancdCode + ' Savings';
    } 

    if(!Test.isRunningTest()){
      fcmAccountType = productTypeCode != '' ? CZFCMAccountTypesList__c.getValues(productTypeCode).AccountTypeId__c : '';
    }

    return fcmAccountType;
  }
}