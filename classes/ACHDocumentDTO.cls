public with sharing class ACHDocumentDTO {
  private ACHFileHeaderRecord fileHeader;
  private List<ACHBatch> batches;
  private ACHFileControlRecord fileControl;
  private ACHFillerRecords fillerRecs;

  public ACHFileHeaderRecord getFileHeader() {
    return fileHeader;
  }

  public List<ACHBatch> getBatches() {
    return batches;
  }

  public ACHFileControlRecord getFileControl() {
    return fileControl;
  }

  public void setFileControl(ACHFileControlRecord fileControl) {
    this.fileControl = fileControl;
  }

  public void setFileHeader(ACHFileHeaderRecord fileHeader) {
    this.fileHeader = fileHeader;
  }

  public void setBatches(List<ACHBatch> batches) {
    this.batches = batches;
  }

  public ACHFillerRecords getFillerRecs() {
    return fillerRecs;
  }

  public void setFillerRecs(ACHFillerRecords fillerRecs) {
    this.fillerRecs = fillerRecs;
  }

  public String getACHDocumentString() {
    String str = '';
    str = str + fileHeader.getRecordString() + ACHConstants.ACH_NEWLINE_CHAR;
    tffa.Logger.debug('batches === ' + batches);
    for (ACHBatch lb : batches) {
      if ((lb.getbatchentries() == null) || lb.getbatchentries().size() == 0) {
        return '';
      }
      str = str + lb.getBatchString() + ACHConstants.ACH_NEWLINE_CHAR;
    }
    str = str + fileControl.getRecordString() + ACHConstants.ACH_NEWLINE_CHAR;
    str = str + fillerRecs.getRecordString();
    str = str.removeEnd(ACHConstants.ACH_NEWLINE_CHAR);
    str = str + ACHConstants.ACH_NEWLINE_CHAR;
    tffa.Logger.debug('FileString == ' + str);
    return str;
  }
}