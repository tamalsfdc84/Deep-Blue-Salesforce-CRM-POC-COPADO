public inherited sharing class FCMGenerateDocumentIdExtension {
  public static String docId = '';

  public static String getFCMDocumentId(tffa__Application__c app, CZFCMContentVersionDTO contentVersionDTO, tffa__Party__c party, FISCC_Adapter_Configs__mdt adapterConfig, FISCC_Charter_Config__mdt charterConfig) {
    FISCCRequestBaseDTO fisccRequestBaseDTO = null;
    Object result = null;
    try {
      docId = '';

      fisccRequestBaseDTO = createGetFCMDocumentIdRequest(app, contentVersionDTO, party, adapterConfig, charterConfig);

      result = FISCCHostAdapter.processHostRequest(fisccRequestBaseDTO, adapterConfig, charterConfig);
      
      isFCMAPICallSuccess(result);

      return docId;
    } catch (Exception ex) {
      tffa.Logger.error('Exception in getAccessToken : ' + ex.getMessage() + ex.getLineNumber() + ex.getStackTraceString());
      return '';
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
      request.ftype = fetchFileType(contentVersionDTO.FileExtension);
      request.FCMUploadDate = fetchDate();

      if(party != null){
        contentVersionDTO.Title = contentVersionDTO.Title + ';' + party.Name;
      }

      String description = contentVersionDTO.Title;
      if(description != null && description.length() > 100){
        description = description.substring(0,100);
      }

      if(FISCCIntegrationConstants.DIGITAL.equalsIgnoreCase(FISCCIntegrationLogService.submissionObj.tffa__Channel__c)){
        request.dtype = 'Account Opening Documents – Digital';
        request.docdescription = 'Digital:' + description;
      } else {
        request.dtype = 'Account Opening Documents';
        request.docdescription = description;
      }
      
      if(app != null){
        accountObj.account = FISCCIntegrationConstants.SAFE_DEPOSIT_PROD_CATEGORY.contains(app.tffa__ProductCategory__c) ? app.tffa__DepositBoxAccountNumber__c : app.tffa__AccountNumber__c;
        String fcmAccountType = getFCMAccountType(app.tffa__Product__r, app.tffa__Brand__c);

        if(fcmAccountType != ''){
          accountObj.application = fcmAccountType;
        }
      }

      if(String.isNotBlank(contentVersionDTO.DocumentCode)){
        CZFCMDocumenTypes__c docType = CZFCMDocumenTypes__c.getValues(contentVersionDTO.DocumentCode);

        if(docType != null){
          request.dtype = docType.DocumentType__c;
        }

        if(docType != null && docType.IsCustomerlevelDoc__c && party != null){
          accountObj.account = party.tffa__NationalIdentifierValue__c != null ? party.tffa__NationalIdentifierValue__c : party.Customer_Number__c;
          accountObj.application = 'ZZ';
        }
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
    if (type.equalsIgnoreCase('jpeg') || type.equalsIgnoreCase('jpg') || type.equalsIgnoreCase('png')|| type.equalsIgnoreCase('bmp')|| type.equalsIgnoreCase('gif')) {
      return 'jpg';
    } else if (type.equalsIgnoreCase('tif') || type.equalsIgnoreCase('tiff')) {
      return 'tif';
    } else if (type.equalsIgnoreCase('xls') || type.equalsIgnoreCase('xlsx') || type.equalsIgnoreCase('doc') || type.equalsIgnoreCase('docx') || type.equalsIgnoreCase('msg')) {
      return type.toLowerCase();
    }

    return 'pdf';
  }

  public static String fetchDate() {
    DateTime d = Date.Today();
    return d.format('MM/dd/yyyy');
  }

  //TODO-PAHSE2 : SDB  
  public static String getFCMAccountType(tffa__Product__c product, String brancdCode) {
    String productTypecode = '';
    String fcmAccountType = '';
    if (product.tffa__Category__c == CZWTFCConstants.IRA) {
      return 'TI';
    } else if (product.tffa__Category__c.contains(CZWTFCConstants.CERTIFICATE)) {
      productTypecode =  brancdCode + ' CD';
    } else if (product.tffa__Category__c.contains(CZWTFCConstants.CHECKING)) {
      productTypecode =  brancdCode + ' DDA';
    } else if (product.tffa__Category__c.contains(CZWTFCConstants.MONEY_MARKET)) {
      productTypecode =  brancdCode + ' DDA';
    } else if (product.tffa__Category__c.contains(CZWTFCConstants.SAVINGS) || product.tffa__Category__c.contains(CZWTFCConstants.HSA)) {
      productTypecode =  brancdCode + ' Savings';
    } 

    if(!Test.isRunningTest()){
      fcmAccountType = productTypeCode != '' ? CZFCMAccountTypesList__c.getValues(productTypeCode).AccountTypeId__c : '';
    }

    return fcmAccountType;
  }
}