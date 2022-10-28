public with sharing class ACHEntryDetailRecord {
  private final String recordTypecode = ACHConstants.ENTRY_DETAIL_RECORD_TYPE_CODE;
  private String transactionCode;
  private String rdfiIdentification;
  private String checkDigit;
  private String dfiAcctNo;
  private Decimal amount = 0.00;
  private String indvidualIdentificationNo;
  private String individualName;
  private String paymentTypeCode;
  private String addendaRecFlag;
  private String traceNo;
  private ACHAddendaRecord addendaRec;
  private String productName;
  private String pcbAcctNo;
  private String achFileName;

  public ACHEntryDetailRecord() {
    addendaRecFlag = ACHConstants.FIELD_ADDEDNDA_RECORD_INDICATOR;
    paymentTypeCode = ACHConstants.FIELD_PAYMENTTYPECODE;
  }

  public String getAchFileName() {
    return achFileName;
  }

  public void setAchFileName(String achFileName) {
    this.achFileName = achFileName;
  }

  public String getPcbAcctNo() {
    return pcbAcctNo;
  }

  public void setPcbAcctNo(String pcbAcctNo) {
    this.pcbAcctNo = pcbAcctNo;
  }

  public String getProductName() {
    return productName;
  }

  public void setProductName(String productName) {
    this.productName = productName;
  }

  public ACHAddendaRecord getAddendaRec() {
    return addendaRec;
  }

  public void setAddendaRec(ACHAddendaRecord addendaRec) {
    this.addendaRec = addendaRec;
  }

  public String getRecordTypecode() {
    return recordTypecode;
  }

  public String getTransactionCode() {
    return transactionCode;
  }

  public void setTransactionCode(String transactionCode) {
    this.transactionCode = transactionCode;
  }

  public String getRdfiIdentification() {
    return rdfiIdentification;
  }

  public void setRdfiIdentification(String rdfiIdentification) {
    this.rdfiIdentification = rdfiIdentification;
  }

  public String getCheckDigit() {
    return checkDigit;
  }

  public void setCheckDigit(String checkDigit) {
    this.checkDigit = checkDigit;
  }

  public String getDfiAcctNo() {
    return dfiAcctNo;
  }

  public void setDfiAcctNo(String dfiAcctNo) {
    this.dfiAcctNo = dfiAcctNo;
  }

  public Decimal getAmount() {
    return amount;
  }

  public void setAmount(Decimal amount) {
    this.amount = amount;
  }

  public String getIndvidualIdentificationNo() {
    return indvidualIdentificationNo;
  }

  public void setIndvidualIdentificationNo(String indvidualIdentificationNo) {
    this.indvidualIdentificationNo = indvidualIdentificationNo;
  }

  public String getIndividualName() {
    return individualName;
  }

  public void setIndividualName(String individualName) {
    this.individualName = individualName;
  }

  public String getPaymentTypeCode() {
    return paymentTypeCode;
  }

  public void setPaymentTypeCode(String paymentTypeCode) {
    this.paymentTypeCode = paymentTypeCode;
  }

  public String getAddendaRecFlag() {
    return addendaRecFlag;
  }

  public void setAddendaRecFlag(String addendaRecFlag) {
    this.addendaRecFlag = addendaRecFlag;
  }

  public String getTraceNo() {
    return traceNo;
  }

  public void setTraceNo(String traceNo) {
    this.traceNo = traceNo;
  }

  public String getRecordString() {
    String record = '';

    record = record + ACHFieldFormatter.prePadNumField(getRecordTypecode(), 1);
    record = record + ACHFieldFormatter.prePadNumField(getTransactionCode(), 2);
    record = record + ACHFieldFormatter.prePadNumField(getRdfiIdentification(), 8);
    record = record + ACHFieldFormatter.prePadNumField(getCheckDigit(), 1);
    record = record + ACHFieldFormatter.postPadAlphaNumField(getDfiAcctNo(), 17);
    record = record + ACHFieldFormatter.prePadAmountField(getAmount(), 10);
    record = record + ACHFieldFormatter.postPadAlphaNumField(getIndvidualIdentificationNo(), 15);
    record = record + ACHFieldFormatter.postPadAlphaNumField(getIndividualName(), 22);
    record = record + ACHFieldFormatter.postPadAlphaNumField(getPaymentTypeCode(), 2);
    record = record + ACHFieldFormatter.postPadAlphaNumField(getAddendaRecFlag(), 1);
    record = record + ACHFieldFormatter.postPadAlphaNumField(getTraceNo(), 15);

    if (addendaRec != null) {
      record = record + ACHConstants.ACH_NEWLINE_CHAR + addendaRec.getRecordString();
    }

    tffa.Logger.debug('ACHEntryDetailRecord : ' + record);
    tffa.Logger.debug('ACHEntryDetailRecord : ' + record.length());

    return record;
  }

  public String getRecStrForCreditFile(String recType) {
    String repHeader = ACHCreditFileBuilder.REPORT_HEADER;

    String record = '';
    record = record + ((repHeader == recType) ? 'ACH Filename, ' : getAchFileName() + ', ');
    record = record + ((repHeader == recType) ? 'Reference Number, ' : getTraceNo() + ', ');
    record = record + ((repHeader == recType) ? 'Customer name, ' : getIndividualName() + ', ');
    record = record + ((repHeader == recType) ? 'Application name, ' : getIndvidualIdentificationNo() + ', ');
    record = record + ((repHeader == recType) ? 'Product, ' : getProductName() + ', ');
    record = record + ((repHeader == recType) ? 'Account Number for Product, ' : getPcbAcctNo() + ', ');
    record = record + ((repHeader == recType) ? 'Amount' : String.valueOf(getAmount()));

    // Add entry to detect if file record is debit or credit since sdv is involved.

    tffa.Logger.debug('Credit rec =>' + record);
    return record;
  }
}