public with sharing class ACHCreditFileBuilder {
  public static final String REPORT_HEADER = 'ReportHeader';
  ACHDocumentDTO doc;
  public ACHCreditFileBuilder(ACHDocumentDTO doc) {
    this.doc = doc;
  }

  public String buildCreditFile() {
    Integer h = 0;
    String fileStr = '';
    List<ACHBatch> batches = doc.getBatches();

    for (ACHBatch ab : batches) {
      List<ACHEntryDetailRecord> entryRecs = ab.getBatchEntries();

      for (ACHEntryDetailRecord ae : entryRecs) {
        if (h == 0) {
          fileStr = fileStr + ae.getRecStrForCreditFile(REPORT_HEADER) + ACHConstants.ACH_NEWLINE_CHAR;
          h++;
        }
        fileStr = fileStr + ae.getRecStrForCreditFile('') + ACHConstants.ACH_NEWLINE_CHAR;
      }
    }

    fileStr = fileStr.removeEnd(ACHConstants.ACH_NEWLINE_CHAR);
    return fileStr;
  }
}