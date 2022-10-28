public with sharing class ACHBatchBuilder {
  @TestVisible
  private Integer unqCounter = 0;
  private ACHFileDTO achdata;
  private final String ENTRY_REC_BUILDER = 'EntryRecordBuilder';

  public ACHBatchBuilder(ACHFileDTO achdata) {
    this.achdata = achdata;
  }

  public ACHBatch getBatch() {
    ACHBatch batch = new ACHBatch();

    ACHBatchHeaderRecord bh = buildBatchHeader();
    batch.setBatchHeader(bh);

    Type entryRecBuilderClass = Type.forName(achdata.filesType + ENTRY_REC_BUILDER);
    tffa.Logger.debug('ACHEntryRecordBuilder' + achdata.filesType + ENTRY_REC_BUILDER);
    ACHEntryRecordBuilder entryRecBuilder = (ACHEntryRecordBuilder) entryRecBuilderClass.newInstance();
    entryRecBuilder.setACHData(achdata);
    List<ACHEntryDetailRecord> batchEntries = entryRecBuilder.buildRecords();
    batch.setBatchEntries(batchEntries);

    ACHBatchControlRecord bcrec = buildBatchControlRecord(batchEntries, bh);
    batch.setBatchControl(bcrec);

    return batch;
  }

  private ACHBatchHeaderRecord buildBatchHeader() {
    ACHBatchHeaderRecord header = new ACHBatchHeaderRecord(achdata.originatorStatusCode);
    header.setServiceCode(achdata.serviceCode);
    header.setCompanyName(achdata.companyName); //TBC
    header.setCompanyDiscretionaryData('');
    header.setCompanyIdentification(achdata.companyId); //TBC
    header.setStdEntryClassCode(ACHConstants.FIELD_ENTRY_CLASS_CODE);
    header.setCompanyEntrydesc(achdata.entryClassDesc);
    header.setCompanyDescDate(ACHFieldFormatter.getDateString(achdata.buildDate));
    header.setEffectiveEntryDate(ACHFieldFormatter.getDateString(achdata.effectiveDate));
    header.setSettlementDate('');
    header.setOrigStatusCode(achdata.originatorStatusCode);
    String odfiId = achdata.odfiId;
    header.setOdfiIdentification(odfiId); //TBC
    header.setBatchNo(achdata.batchNo);
    return header;
  }

  private ACHBatchControlRecord buildBatchControlRecord(List<ACHEntryDetailRecord> batchEntries, ACHBatchHeaderRecord bh) {
    ACHBatchControlRecord bcrec = new ACHBatchControlRecord();
    String serviceCode = bh.getServiceCode();
    bcrec.setServiceCode(serviceCode);
    bcrec.setEntryCount(batchEntries.size());
    bcrec.setEntryHash(calculateEntryHash(batchEntries));
    bcrec.setCompanyIdentification(bh.getCompanyIdentification());
    bcrec.setOdfiIdentification(bh.getOdfiIdentification());
    bcrec.setBatchNo(bh.getBatchNo());
    calculateAndSetTotalAmounts(bcrec, batchEntries);
    return bcrec;
  }

  private void calculateAndSetTotalAmounts(ACHBatchControlRecord bcrec, List<ACHEntryDetailRecord> batchEntries) {
    Decimal totalDebitAmount = 0.00;
    Decimal totalCreditAmount = 0.00;
    Integer totalDebitRecords = 0;
    Integer totalCreditRecords = 0;

    for (ACHEntryDetailRecord edr : batchEntries) {
      if (ACHConstants.TXN_CODES_DEBIT.contains(edr.getTransactionCode())) {
        totalDebitAmount += edr.getAmount();
        totalDebitRecords += 1;
      } else if (ACHConstants.TXN_CODES_CREDIT.contains(edr.getTransactionCode())) {
        totalCreditAmount += edr.getAmount();
        totalCreditRecords += 1;
      }
    }
    bcrec.setTotalBatchDebitAmount(totalDebitAmount);
    bcrec.setTotalBatchCreditAmount(totalCreditAmount);
    bcrec.setTotalBatchDebitRecords(totalDebitRecords);
    bcrec.setTotalBatchCreditRecords(totalCreditRecords);
  }

  private Integer calculateEntryHash(List<ACHEntryDetailRecord> batchEntries) {
    Long entryHash = 0;
    try {
      for (ACHEntryDetailRecord er : batchEntries) {
        Integer rtno = Integer.valueOf(er.getRdfiIdentification());
        entryHash = entryHash + rtno;
      }
      tffa.Logger.debug('Batch entryHash => ' + entryHash);

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
}