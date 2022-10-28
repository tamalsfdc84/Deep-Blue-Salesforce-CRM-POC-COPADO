public with sharing class ACHBatchHeaderRecord {
  private final String recordTypecode = ACHConstants.BATCH_HEADER_RECORD_TYPE_CODE;
  private String serviceCode;
  private String companyName;
  private String companyDiscretionaryData;
  private String companyIdentification;
  private String stdEntryClassCode;
  private String companyEntrydesc;
  private String companyDescDate;
  private String effectiveEntryDate;
  private String settlementDate;
  private String origStatusCode;
  private String odfiIdentification;
  private Integer batchNo;

  public ACHBatchHeaderRecord(String originatorStatusCode) {
    origStatusCode = originatorStatusCode;
  }

  public String getRecordTypeCode() {
    return recordTypecode;
  }

  public String getServiceCode() {
    return serviceCode;
  }

  public void setServiceCode(String serviceCode) {
    this.serviceCode = serviceCode;
  }

  public String getCompanyName() {
    return companyName;
  }

  public void setCompanyName(String companyName) {
    this.companyName = companyName;
  }

  public String getCompanyDiscretionaryData() {
    return companyDiscretionaryData;
  }

  public void setCompanyDiscretionaryData(String companyDiscretionaryData) {
    this.companyDiscretionaryData = companyDiscretionaryData;
  }

  public String getCompanyIdentification() {
    return companyIdentification;
  }

  public void setCompanyIdentification(String companyIdentification) {
    this.companyIdentification = companyIdentification;
  }

  public String getStdEntryClassCode() {
    return stdEntryClassCode;
  }

  public void setStdEntryClassCode(String stdEntryClassCode) {
    this.stdEntryClassCode = stdEntryClassCode;
  }

  public String getCompanyEntrydesc() {
    return companyEntrydesc;
  }

  public void setCompanyEntrydesc(String companyEntrydesc) {
    this.companyEntrydesc = companyEntrydesc;
  }

  public String getCompanyDescDate() {
    return companyDescDate;
  }

  public void setCompanyDescDate(String companyDescDate) {
    this.companyDescDate = companyDescDate;
  }

  public String getEffectiveEntryDate() {
    return effectiveEntryDate;
  }

  public void setEffectiveEntryDate(String effectiveEntryDate) {
    this.effectiveEntryDate = effectiveEntryDate;
  }

  public String getSettlementDate() {
    return settlementDate;
  }

  public void setSettlementDate(String settlementDate) {
    this.settlementDate = settlementDate;
  }

  public String getOrigStatusCode() {
    return origStatusCode;
  }

  public void setOrigStatusCode(String origStatusCode) {
    this.origStatusCode = origStatusCode;
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
    record = record + ACHFieldFormatter.postPadAlphaNumField(getCompanyName(), 16);
    record = record + ACHFieldFormatter.postPadAlphaNumField(getCompanyDiscretionaryData(), 20);
    record = record + ACHFieldFormatter.postPadAlphaNumField(getCompanyIdentification(), 10);
    record = record + ACHFieldFormatter.postPadAlphaNumField(getStdEntryClassCode(), 3);
    record = record + ACHFieldFormatter.postPadAlphaNumField(getCompanyEntrydesc(), 10);
    record = record + ACHFieldFormatter.postPadAlphaNumField(getCompanyDescDate(), 6);
    record = record + ACHFieldFormatter.prePadNumField(getEffectiveEntryDate(), 6);
    record = record + ACHFieldFormatter.postPadAlphaNumField(getSettlementDate(), 3);
    record = record + ACHFieldFormatter.prePadNumField(getOrigStatusCode(), 1);
    record = record + ACHFieldFormatter.postPadAlphaNumField(getOdfiIdentification(), 8);
    record = record + ACHFieldFormatter.prePadNumField(getbatchNo(), 7);

    tffa.Logger.debug('ACHBatchheaderRecord : ' + record);
    tffa.Logger.debug('ACHBatchheaderRecord : ' + record.length());

    return record;
  }
}