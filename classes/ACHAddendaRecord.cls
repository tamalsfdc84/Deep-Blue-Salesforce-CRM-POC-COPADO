/**
 * @description Automatic Clearing House (ACH) Document Addenda Record
 */
public with sharing class ACHAddendaRecord {
  private final String recordTypecode = ACHConstants.ADDENDA_RECORD_TYPE_CODE;
  private String addendaCodeType;
  private String paymentInfo;
  private Integer addendaSeqNo;
  private Integer entryDetailSeqNo;

  public ACHAddendaRecord() {
    addendaCodeType = ACHConstants.ADDENDA_CODE_TYPE_CDD_PDD_CTX;
  }

  public String getRecordTypecode() {
    return recordTypecode;
  }

  public String getAddendaCodeType() {
    return addendaCodeType;
  }

  public void setAddendaCodeType(String addendaCodeType) {
    this.addendaCodeType = addendaCodeType;
  }

  public String getPaymentInfo() {
    return paymentInfo;
  }

  public void setPaymentInfo(String paymentInfo) {
    this.paymentInfo = paymentInfo;
  }

  public Integer getAddendaSeqNo() {
    return addendaSeqNo;
  }

  public void setAddendaSeqNo(Integer addendaSeqNo) {
    this.addendaSeqNo = addendaSeqNo;
  }

  public Integer getEntryDetailSeqNo() {
    return entryDetailSeqNo;
  }

  public void setEntryDetailSeqNo(Integer entryDetailSeqNo) {
    this.entryDetailSeqNo = entryDetailSeqNo;
  }

  public String getRecordString() {
    String record = '';

    record = record + ACHFieldFormatter.prePadNumField(getRecordTypecode(), 1);
    record = record + ACHFieldFormatter.prePadNumField(getAddendaCodeType(), 2);
    record = record + ACHFieldFormatter.postPadAlphaNumField(getPaymentInfo(), 80);
    record = record + ACHFieldFormatter.prePadNumField(getAddendaSeqNo(), 4);
    record = record + ACHFieldFormatter.prePadNumField(getEntryDetailSeqNo(), 7);

    tffa.Logger.debug('ACHAddendaRecord : ' + record);
    tffa.Logger.debug('ACHAddendaRecord : ' + record.length());

    return record;
  }
}