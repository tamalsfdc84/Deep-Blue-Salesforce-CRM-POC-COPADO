public with sharing class ACHBatch {
  private ACHBatchHeaderRecord batchHeader;
  private List<ACHEntryDetailRecord> batchEntries;
  private ACHBatchControlRecord batchControl;

  public ACHBatchHeaderRecord getBatchHeader() {
    return batchHeader;
  }

  public void setBatchHeader(ACHBatchHeaderRecord batchHeader) {
    this.batchHeader = batchHeader;
  }

  public List<ACHEntryDetailRecord> getBatchEntries() {
    return batchEntries;
  }

  public void setBatchEntries(List<ACHEntryDetailRecord> batchEntries) {
    this.batchEntries = batchEntries;
  }

  public ACHBatchControlRecord getBatchControl() {
    return batchControl;
  }

  public void setBatchControl(ACHBatchControlRecord batchControl) {
    this.batchControl = batchControl;
  }

  public String getBatchString() {
    String str = '';
    str = str + batchHeader.getRecordString() + ACHConstants.ACH_NEWLINE_CHAR;
    for (ACHEntryDetailRecord er : batchEntries) {
      str = str + er.getRecordString() + ACHConstants.ACH_NEWLINE_CHAR;
    }
    str = str + batchControl.getRecordString();
    return str;
  }
}