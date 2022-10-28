public with sharing class ACHFileHeaderRecord {
  private final String recordTypecode = ACHConstants.FILE_HEADER_RECORD_TYPE_CODE;
  private String priorityCode;
  private String immediateDestination;
  private String immdiateOrigin;
  private String fileCreationDate;
  private String fileCreationTime;
  private String fileIdModifier;
  private String recordSize;
  private String blockingFactor;
  private String formatCode;
  private String immediateDestinationName;
  private String immediateOriginName;
  private String refCode;

  public ACHFileHeaderRecord() {
    priorityCode = ACHConstants.FIELD_PRIORITY_CODE;
    recordSize = ACHConstants.FIELD_RECORD_SIZE;
    blockingFactor = ACHConstants.FIELD_BLOCKING_FACTOR;
    formatCode = ACHConstants.FIELD_FORMAT_CODE;
  }
  public String getRecordTypecode() {
    return recordTypecode;
  }

  public String getPriorityCode() {
    return priorityCode;
  }

  public void setPriorityCode(String priorityCode) {
    this.priorityCode = priorityCode;
  }

  public String getImmediateDestination() {
    return immediateDestination;
  }

  public void setImmediateDestination(String immediateDestination) {
    this.immediateDestination = immediateDestination;
  }

  public String getImmdiateOrigin() {
    return immdiateOrigin;
  }

  public void setImmdiateOrigin(String immdiateOrigin) {
    this.immdiateOrigin = immdiateOrigin;
  }

  public String getFileCreationDate() {
    return fileCreationDate;
  }

  public void setFileCreationDate(String fileCreationDate) {
    this.fileCreationDate = fileCreationDate;
  }

  public String getfileCreationTime() {
    return fileCreationTime;
  }

  public void setFileCreationTime(String fileCreationTime) {
    this.fileCreationTime = fileCreationTime;
  }

  public String getFileIdModifier() {
    return fileIdModifier;
  }

  public void setFileIdModifier(String fileIdModifier) {
    this.fileIdModifier = fileIdModifier;
  }

  public String getRecordSize() {
    return recordSize;
  }

  public void setRecordSize(String recordSize) {
    this.recordSize = recordSize;
  }

  public String getBlockingFactor() {
    return blockingFactor;
  }

  public void setBlockingFactor(String blockingFactor) {
    this.blockingFactor = blockingFactor;
  }

  public String getFormatCode() {
    return formatCode;
  }

  public void setFormatCode(String formatCode) {
    this.formatCode = formatCode;
  }

  public String getImmediateDestinationName() {
    return immediateDestinationName;
  }

  public void setImmediateDestinationName(String immediateDestinationName) {
    this.immediateDestinationName = immediateDestinationName;
  }

  public String getImmediateOriginName() {
    return immediateOriginName;
  }

  public void setImmediateOriginName(String immediateOriginName) {
    this.immediateOriginName = immediateOriginName;
  }

  public String getRefCode() {
    return refCode;
  }

  public void setRefCode(String refCode) {
    this.refCode = refCode;
  }

  public String getRecordString() {
    String record = '';

    record = record + ACHFieldFormatter.prePadNumField(getRecordTypecode(), 1);
    record = record + ACHFieldFormatter.prePadNumField(getPriorityCode(), 2);
    record = record + ACHFieldFormatter.postPadAlphaNumField(getImmediateDestination(), 10);
    record = record + ACHFieldFormatter.prePadAlphaNumField(getImmdiateOrigin(), 10);
    record = record + ACHFieldFormatter.prePadNumField(getFileCreationDate(), 6);
    record = record + ACHFieldFormatter.prePadNumField(getFileCreationTime(), 4);
    record = record + ACHFieldFormatter.postPadAlphaNumField(getFileIdModifier(), 1);
    record = record + ACHFieldFormatter.postPadAlphaNumField(getRecordSize(), 3);
    record = record + ACHFieldFormatter.postPadAlphaNumField(getBlockingFactor(), 2);
    record = record + ACHFieldFormatter.postPadAlphaNumField(getFormatCode(), 1);
    record = record + ACHFieldFormatter.postPadAlphaNumField(getImmediateDestinationName(), 23);
    record = record + ACHFieldFormatter.postPadAlphaNumField(getImmediateOriginName(), 23);
    record = record + ACHFieldFormatter.postPadAlphaNumField(getRefCode(), 8);

    tffa.Logger.debug('ACHFileHeaderRecord : ' + record);
    tffa.Logger.debug('ACHFileHeaderRecord  : ' + record.length());

    return record;
  }
}