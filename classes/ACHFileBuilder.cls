public class ACHFileBuilder {
  @TestVisible
  private static Boolean testException = false;
  ACHFileDTO achdata;
  private final String templateName = 'ACHFilesGen';
  public ACHFileBuilder(ACHFileDTO achdata) {
    this.achdata = achdata;
  }

  public void buildACHFile() {
    String achFileStr = '';
    String creditFileStr = '';
    String genMsg = '';
    ACHDocumentDTO doc = null;
    try {
      if (
        (achdata.filesType == ACHFileType.ACH &&
        achdata.abtAccts != null &&
        achdata.abtAccts.size() > 0) // || (achdata.filesType == ACHFileType.SDV && achdata.sdvs !=null && achdata.sdvs.size()>0))
      ) {
        try {
          ACHDocumentBuilder adb = new ACHDocumentBuilder(achdata);
          tffa.Logger.debug('ACHDocumentBuilder ' + adb);
          doc = adb.buildACHDocument();
          tffa.Logger.debug('ACHDocumentDTO ' + doc);
          achFileStr = doc.getACHDocumentString(); //retrieve ACH Debit file String
          tffa.Logger.debug(achFileStr);
          tffa.Logger.debug('achFileStr is ' + achFileStr);
          ACHCreditFileBuilder acb = new ACHCreditFileBuilder(doc);
          creditFileStr = acb.buildCreditFile();
          tffa.Logger.debug('creditFileStr is ' + creditFileStr);
          genMsg = 'File Generated Successfully';
        } catch (Exception e) {
          genMsg = e.getMessage() + ' ' + e.getStackTraceString();
          tffa.Logger.error('Exception while generating file' + genMsg);
        }
        createFilesAndNotify(doc, achFileStr, creditFileStr, genMsg);
      }
    } catch (Exception e) {
      //Ideally this should never happen
      String errorMsg = e.getMessage() + ' ' + e.getStackTraceString();
      tffa.Logger.error('Exception while processing ACH File');
      tffa.Logger.error(e.getMessage() + ' ' + e.getStackTraceString());
      logACHFileInfo(errorMsg);
    }
  }

  private UploadFileHistory__c insertIntoACHFile(
    ACHDocumentDTO doc,
    Integer totalFileRecNo,
    String fileName,
    ACHFileType ft,
    String genMsg,
    String docId,
    String brandCode,
    Integer serialNumber
  ) {
    tffa.Logger.debug('Start inserting into ACHFiles');
    UploadFileHistory__c af = new UploadFileHistory__c();
    Decimal debitAmt = 0.00;
    Decimal creditAmt = 0.00;
    Integer debitItems = 0;
    Integer creditItems = 0;
    Integer entryRecCount = 0;

    if (doc != null) {
      ACHFileControlRecord fc = doc.getFileControl();
      debitAmt = fc.getTotalFileDebitAmount();
      creditAmt = fc.getTotalFileCreditAmount();
      debitItems = fc.getTotalFileDebitRecords();
      creditItems = fc.getTotalFileCreditRecords();
      entryRecCount = fc.getEntryCount();
    }

    af.TotalFileDebitAmount__c = debitAmt;

    af.TotalFileEntryRecords__c = entryRecCount;
    af.DocumentId__c = docId;
    af.FileName__c = fileName;
    af.TotalFileRecNo__c = totalFileRecNo;
    af.FileType__c = ft.name();
    af.GenMsg__c = genMsg; //'File generated Successfully';
    af.CompanyID__c = achdata.companyId;
    af.CompanyName__c = achdata.companyName;
    af.ImmediateOriginName__c = achdata.immediateOriginName;
    af.CreditItemCount__c = creditItems;
    af.DebitItemCount__c = debitItems;
    af.TotalFileCreditAmount__c = creditAmt;
    af.EffectiveDate__c = achdata.effectiveDate;
    af.BrandCode__c = brandCode;
    af.SerialNumber__c = String.valueOf(serialNumber);
    CZWTFCApplicationRepository.saveSingle(af);

    tffa.Logger.debug('Finish inserting into ACHFiles');
    return af;
  }

  private void createFilesAndNotify(ACHDocumentDTO doc, String achFileStr, String creditFileStr, String genMsg) {
    if (doc.getFileControl().getEntryCount() > 0) {
      Integer totalFileRecNo = String.isNotBlank(achFileStr) ? (achFileStr.countMatches(ACHConstants.ACH_NEWLINE_CHAR) + 1) : 0;
      String docIdD = insertIntoDocument(achFileStr, achdata.fileDesc, achdata.achFileName, null);
      //this method call will have 2 more parameters
      UploadFileHistory__c af = insertIntoACHFile(
        doc,
        totalFileRecNo,
        achdata.achFileName,
        achdata.filesType,
        genMsg,
        docIdD,
        achdata.brandCode,
        achdata.fileNo
      );
      af.DocumentId__c = docIdD;
      CZWTFCApplicationRepository.saveSingle(af);
      //One is not added since static header record is present in file while calculating totalfile rec no.
      //Total number of records in CSV credit file should match with no of entry records in debit file
      Integer totalFileRecNoC = String.isNotBlank(creditFileStr) ? (creditFileStr.countMatches(ACHConstants.ACH_NEWLINE_CHAR)) : 0;
      String docIdC = insertIntoDocument(creditFileStr, achdata.reportFileDesc, achdata.reportFileName, null);
      //this method call will have 2 more parameters
      UploadFileHistory__c afC = insertIntoACHFile(
        doc,
        totalFileRecNoC,
        achdata.reportFileName,
        ACHFileType.ACH_REPORT,
        genMsg,
        docIdC,
        achdata.brandCode,
        achdata.fileNo
      );
      //send email notification
      afC.DocumentId__c = docIdC;
      CZWTFCApplicationRepository.saveSingle(afC);
      //sendEmail(af.id);
    }
  }

  private String insertIntoDocument(String fileData, String description, String fileName, String documentLinkId) {
    tffa.Logger.debug('Start inserting into document');
    ACHContentHelper upd = new ACHContentHelper();
    String extension;
    if (fileName.contains('Report')) {
      extension = '.csv';
    } else {
      extension = '.txt';
    }
    String result = upd.uploadFile(Blob.valueOf(fileData), fileName + extension, 'ACHFiles', documentLinkId);
    tffa.Logger.debug('Finish inserting into document' + result);
    return result;
  }

  @TestVisible
  private void logACHFileInfo(String msg) {
    UploadFileHistory__c af = new UploadFileHistory__c();
    af.GenMsg__c = msg;
    CZWTFCApplicationRepository.saveSingle(af);
  }
}