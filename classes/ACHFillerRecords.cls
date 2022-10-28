public with sharing class ACHFillerRecords {
  private Integer recNos = 0;
  private String recString = '';
  private String recChar = '9';

  public ACHFillerRecords(Integer recNos) {
    this.recNos = recNos;
    for (Integer i = 0; i < ACHConstants.RECORD_SIZE; i++) {
      recString = recString + recChar;
    }
  }

  public String getRecordString() {
    String record = '';
    tffa.Logger.debug('setting filler records >> ' + recNos);
    for (Integer i = 0; i < recNos; i++) {
      record = record + recString + ACHConstants.ACH_NEWLINE_CHAR;
    }
    record = record.removeEnd(ACHConstants.ACH_NEWLINE_CHAR);

    return record;
  }
}