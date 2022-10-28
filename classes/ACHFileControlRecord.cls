public with sharing class ACHFileControlRecord {
  private final String recordTypecode = ACHConstants.FILE_CONTROL_RECORD_TYPE_CODE;
  private Integer batchCount;
  private Integer blockCount;
  private Integer entryCount;
  private Integer entryHash;
  private Decimal totalFileDebitAmount = 0.00;
  private Decimal totalFileCreditAmount = 0.00;
  private Integer totalFileDebitRecords = 0;
  private Integer totalFileCreditRecords = 0;

  private String reservedField;

  public String getRecordTypecode() {
    return recordTypecode;
  }

  public Integer getBatchCount() {
    return batchCount;
  }

  public void setBatchCount(Integer batchCount) {
    this.batchCount = batchCount;
  }

  public Integer getBlockCount() {
    return blockCount;
  }

  public void setBlockCount(Integer blockCount) {
    this.blockCount = blockCount;
  }

  public Integer getEntryCount() {
    return entryCount;
  }

  public void setEntryCount(Integer entryCount) {
    this.entryCount = entryCount;
  }

  public Integer getEntryHash() {
    return entryHash;
  }

  public void setEntryHash(Integer entryHash) {
    this.entryHash = entryHash;
  }

  public Decimal getTotalFileDebitAmount() {
    return totalFileDebitAmount;
  }

  public void setTotalFileDebitAmount(Decimal totalFileDebitAmount) {
    this.totalFileDebitAmount = totalFileDebitAmount;
  }

  public Decimal getTotalFileCreditAmount() {
    return totalFileCreditAmount;
  }

  public void setTotalFileCreditAmount(Decimal totalFileCreditAmount) {
    this.totalFileCreditAmount = totalFileCreditAmount;
  }

  public String getReservedField() {
    return reservedField;
  }

  public void setReservedField(String reservedField) {
    this.reservedField = reservedField;
  }

  public Integer getTotalFileDebitRecords() {
    return totalFileDebitRecords;
  }

  public void setTotalFileDebitRecords(Integer totalFileDebitRecords) {
    this.totalFileDebitRecords = totalFileDebitRecords;
  }

  public Integer getTotalFileCreditRecords() {
    return totalFileCreditRecords;
  }

  public void setTotalFileCreditRecords(Integer totalFileCreditRecords) {
    this.totalFileCreditRecords = totalFileCreditRecords;
  }

  public String getRecordString() {
    String record = '';

    record = record + ACHFieldFormatter.prePadNumField(getRecordTypecode(), 1);
    record = record + ACHFieldFormatter.prePadNumField(getBatchCount(), 6);
    record = record + ACHFieldFormatter.prePadNumField(getBlockCount(), 6);
    record = record + ACHFieldFormatter.prePadNumField(getEntryCount(), 8);
    record = record + ACHFieldFormatter.prePadNumField(getEntryHash(), 10);
    record = record + ACHFieldFormatter.prePadAmountField(getTotalFileDebitAmount(), 12);
    record = record + ACHFieldFormatter.prePadAmountField(getTotalFileCreditAmount(), 12);
    record = record + ACHFieldFormatter.postPadAlphaNumField(getReservedField(), 39);

    tffa.Logger.debug('ACHFileControlRecord : ' + record);
    tffa.Logger.debug('ACHFileControlRecord : ' + record.length());

    return record;
  }
}