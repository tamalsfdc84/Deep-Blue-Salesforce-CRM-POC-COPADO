public with sharing class ACHFieldFormatter {
  //add code to truncate the fields if its exceeds th length. check the length first. Also check the max amount supported by
  //ach and funding amount populated in ach file.

  public static String postPadAlphaNumField(String val, Integer reqLength) {
    String str = String.isNotBlank(val) ? val : '';
    return str.rightPad(reqLength, ACHConstants.PADSTR_ALPHANUMFIELD);
  }

  public static String prePadAlphaNumField(String val, Integer reqLength) {
    String str = String.isNotBlank(val) ? val : '';
    return str.LeftPad(reqLength, ACHConstants.PADSTR_ALPHANUMFIELD);
  }

  public static String prePadNumField(String val, Integer reqLength) {
    String str = String.isNotBlank(val) ? val : '';
    return str.LeftPad(reqLength, ACHConstants.PADSTR_NUMFIELD);
  }

  public static String prePadNumField(Integer val, Integer reqLength) {
    String str = val != null ? String.valueOf(val) : String.valueOf(0);
    return str.LeftPad(reqLength, ACHConstants.PADSTR_NUMFIELD);
  }

  public static String prePadAmountField(Decimal val, Integer reqLength) {
    //val is multiplied by hundred to get the cents values directly
    String str = val != null ? String.valueOf(val * 100) : String.valueOf(0);
    str = str.substringBefore('.');
    return str.LeftPad(reqLength, ACHConstants.PADSTR_NUMFIELD);
  }

  public static String getDateString(Datetime d) {
    return d.format('yyMMdd');
  }

  public static String getTimeString(Datetime d) {
    return d.format('HHmm');
  }

  public static String getDateTimeString(Datetime d) {
    return d.format('yyMMdd') + d.format('HHmmSS');
  }
}