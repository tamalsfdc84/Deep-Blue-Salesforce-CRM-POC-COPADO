public class ACHDocumentBuilder {
  private Integer blockCount = 0;
  private Integer totalEntryCount = 0;
  private Integer fillerRecCount = 0;
  private Integer totalRecCount = 0;
  private ACHFileDTO achdata;

  public ACHDocumentBuilder(ACHFileDTO achdata) {
    this.achdata = achdata;
  }

  public ACHDocumentDTO buildACHDocument() {
    ACHDocumentDTO doc = new ACHDocumentDTO();

    ACHFileHeaderRecord fileHeader = buildFileHeaderRec();

    achdata.batchNo += 1;
    List<ACHBatch> batches = new List<ACHBatch>();
    ACHBatchBuilder batchBuilder = new ACHBatchBuilder(achdata);
    batches.add(batchBuilder.getBatch());
    setFileRecCounts(batches);

    ACHFileControlRecord fileControl = buildFileControlRec(batches);
    ACHFillerRecords fillerRecs = new ACHFillerRecords(fillerRecCount);
    tffa.Logger.debug('****fileHeader' + fileHeader);
    tffa.Logger.debug('****batches' + batches);
    tffa.Logger.debug('****fileControl' + fileControl);
    tffa.Logger.debug('****fillerRecs' + fillerRecs);
    doc.setFileHeader(fileHeader);
    doc.setBatches(batches);
    doc.setFileControl(fileControl);
    doc.setFillerRecs(fillerRecs);

    return doc;
  }

  private ACHFileHeaderRecord buildFileHeaderRec() {
    ACHFileHeaderRecord fileHeader = new ACHFileHeaderRecord();
    fileHeader.setImmediateDestination(' ' + achdata.immediateDestination);
    fileHeader.setImmdiateOrigin(achdata.immediateOrigin);
    fileHeader.setImmediateDestinationName(achdata.immediateDestinationName);
    fileHeader.setImmediateOriginName(achdata.immediateOriginName);
    fileHeader.setFileCreationDate(ACHFieldFormatter.getDateString(achdata.buildDate));
    fileHeader.setFileCreationTime(ACHFieldFormatter.getTimeString(achdata.buildDate));
    fileHeader.setRefCode(ACHConstants.FIELD_REF_CODE);
    fileHeader.setfileIdModifier(String.valueOf(achdata.fileNo));
    return fileHeader;
  }

  private ACHFileControlRecord buildFileControlRec(List<ACHBatch> batches) {
    ACHFileControlRecord fileCtrl = new ACHFileControlRecord();
    fileCtrl.setBatchCount(batches.size());
    fileCtrl.setBlockCount(blockCount);
    fileCtrl.setEntryCount(totalEntryCount);
    fileCtrl.setEntryHash(calculateEntryHash(batches));
    calculateAndSetTotalAmountsAndRecords(fileCtrl, batches);
    return fileCtrl;
  }

  private void setFileRecCounts(List<ACHBatch> batches) {
    Integer blockingFactor = Integer.valueOf(ACHConstants.FIELD_BLOCKING_FACTOR);
    //initialize total records in file to 2. one for file header record and one for file control
    Integer totalRecNo = 2;
    Integer entryRecNo = 0;

    for (ACHBatch b : batches) {
      totalRecNo = totalRecNo + 2; // batch header and batch control
      List<ACHEntryDetailRecord> edrs = b.getBatchEntries();
      for (ACHEntryDetailRecord edr : edrs) {
        entryRecNo = entryRecNo + 1;
        if (edr.getAddendaRec() != null) {
          entryRecNo = entryRecNo + 1;
        }
      }
    }
    totalRecNo = totalRecNo + entryRecNo;
    blockCount = totalRecNo / blockingFactor;
    fillerRecCount = Math.mod(totalRecNo, blockingFactor);
    if (fillerRecCount != 0) {
      blockCount = blockCount + 1;
      fillerRecCount = blockingFactor - fillerRecCount;
    }
    totalEntryCount = entryRecNo;
    totalRecCount = totalRecNo;

    tffa.Logger.debug('totalRecCount ==>' + totalRecCount);
    tffa.Logger.debug('blockCount ==>' + blockCount);
    tffa.Logger.debug('fillerRecCount ==>' + fillerRecCount);
    tffa.Logger.debug('totalEntryCount ==>' + entryRecNo);
  }

  private Integer calculateEntryHash(List<ACHBatch> batches) {
    Long entryHash = 0;
    try {
      for (ACHBatch ab : batches) {
        List<ACHEntryDetailRecord> batchEntries = ab.getBatchEntries();
        for (ACHEntryDetailRecord er : batchEntries) {
          Integer rtno = Integer.valueOf(er.getRdfiIdentification());
          entryHash = entryHash + rtno;
        }
      }

      tffa.Logger.debug('File entryHash == > ' + entryHash);
      String entryHashString = String.valueOf(entryHash);
      if (entryHashString.length() > 10) {
        entryHashString = entryHashString.substring(entryHashString.length() - 10, entryHashString.length());
      }

      return Integer.valueOf(entryHashString);
    } catch (Exception ex) {
      tffa.Logger.debug('Exception  :::' + ex.getMessage() + 'LineNumber  :::' + ex.getStackTraceString());
      throw ex;
    }
  }

  @TestVisible
  private void calculateAndSetTotalAmountsAndRecords(ACHFileControlRecord fileCtrl, List<ACHBatch> batches) {
    Decimal totalDebitAmount = 0.00;
    Decimal totalCreditAmount = 0.00;
    Integer totalDebitRecords = 0;
    Integer totalCreditRecords = 0;

    for (ACHBatch ab : batches) {
      ACHBatchControlRecord bc = ab.getBatchControl();
      totalDebitAmount += bc.getTotalBatchDebitAmount();
      totalCreditAmount += bc.getTotalBatchCreditAmount();
      totalDebitRecords += bc.getTotalBatchDebitRecords();
      totalCreditRecords += bc.getTotalBatchCreditRecords();
    }

    fileCtrl.setTotalFileDebitAmount(totalDebitAmount);
    fileCtrl.setTotalFileCreditAmount(totalCreditAmount);
    fileCtrl.setTotalFileDebitRecords(totalDebitRecords);
    fileCtrl.setTotalFileCreditRecords(totalCreditRecords);
  }
}