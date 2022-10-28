public with sharing class CZWTFCDisclosurePdfExtension {
  @TestVisible
  private static boolean testException = false;

  public String disTitle { get; set; }

  public String discontent { get; set; }

  public String subId;

  public CZWTFCDisclosurePdfExtension(ApexPages.StandardController stdController) {
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }

      disTitle = ApexPages.currentPage().getParameters().get('disclosureTitle');
      discontent = ApexPages.currentPage().getParameters().get('disclosureText');
    } catch (Exception ex) {
      tffa.Logger.error('Exception msg in CZWTFCDisclosurePdfExtension : ' + ex.getMessage() + ' ' + ex.getStackTraceString());
    }
  }
}