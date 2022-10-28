public with sharing class ACHBatchControlRecord {
  private final String recordTypecode = ACHConstants.BATCH_CONTROL_RECORD_TYPE_CODE;
  private String serviceCode;
  private Integer entryCount;
  private Integer entryHash;
  private Decimal totalBatchDebitAmount = 0.00;
  private Decimal totalBatchCreditAmount = 0.00;
  private Integer totalBatchDebitRecords = 0;
  private Integer totalBatchCreditRecords = 0;

  private String companyIdentification;
  private String msgAuthCode;
  private String reservedField;
  private String odfiIdentification;
  private Integer batchNo;

  public ACHBatchControlRecord() {
  }

  public String getRecordTypecode() {
    return recordTypecode;
  }

  public String getServiceCode() {
    return serviceCode;
  }

  public void setServiceCode(String serviceCode) {
    this.serviceCode = serviceCode;
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

  public Decimal getTotalBatchDebitAmount() {
    return totalBatchDebitAmount;
  }

  public void setTotalBatchDebitAmount(Decimal totalBatchDebitAmount) {
    this.totalBatchDebitAmount = totalBatchDebitAmount;
  }

  public Decimal getTotalBatchCreditAmount() {
    return totalBatchCreditAmount;
  }

  public void setTotalBatchCreditAmount(Decimal totalBatchCreditAmount) {
    this.totalBatchCreditAmount = totalBatchCreditAmount;
  }

  public Integer getTotalBatchDebitRecords() {
    return totalBatchDebitRecords;
  }

  public void setTotalBatchDebitRecords(Integer totalBatchDebitRecords) {
    this.totalBatchDebitRecords = totalBatchDebitRecords;
  }

  public Integer getTotalBatchCreditRecords() {
    return totalBatchCreditRecords;
  }

  public void setTotalBatchCreditRecords(Integer totalBatchCreditRecords) {
    this.totalBatchCreditRecords = totalBatchCreditRecords;
  }

  public String getCompanyIdentification() {
    return companyIdentification;
  }

  public void setCompanyIdentification(String companyIdentification) {
    this.companyIdentification = companyIdentification;
  }

  public String getMsgAuthCode() {
    return msgAuthCode;
  }

  public void setMsgAuthCode(String msgAuthCode) {
    this.msgAuthCode = msgAuthCode;
  }

  public String getReservedField() {
    return reservedField;
  }

  public void setReservedField(String reservedField) {
    this.reservedField = reservedField;
  }

  public String getOdfiIdentification() {
    return odfiIdentification;
  }

  public void setOdfiIdentification(String odfiIdentification) {
    this.odfiIdentification = odfiIdentification;
  }

  public Integer getBatchNo() {
    return batchNo;
  }

  public void setBatchNo(Integer batchNo) {
    this.batchNo = batchNo;
  }

  public String getRecordString() {
    String record = '';

    record = record + ACHFieldFormatter.prePadNumField(getRecordTypecode(), 1);
    record = record + ACHFieldFormatter.prePadNumField(getServiceCode(), 3);
    record = record + ACHFieldFormatter.prePadNumField(getEntryCount(), 6);
    record = record + ACHFieldFormatter.prePadNumField(getEntryHash(), 10);
    record = record + ACHFieldFormatter.prePadAmountField(getTotalBatchDebitAmount(), 12);
    record = record + ACHFieldFormatter.prePadAmountField(getTotalBatchCreditAmount(), 12);
    record = record + ACHFieldFormatter.postPadAlphaNumField(getCompanyIdentification(), 10);
    record = record + ACHFieldFormatter.postPadAlphaNumField(getMsgAuthCode(), 19);
    record = record + ACHFieldFormatter.postPadAlphaNumField(getReservedField(), 6);
    record = record + ACHFieldFormatter.postPadAlphaNumField(getOdfiIdentification(), 8);
    record = record + ACHFieldFormatter.prePadNumField(getBatchNo(), 7);

    tffa.Logger.debug('ACHBatchControlRecord : ' + record);
    tffa.Logger.debug('ACHBatchControlRecord : ' + record.length());

    return record;
  }
}