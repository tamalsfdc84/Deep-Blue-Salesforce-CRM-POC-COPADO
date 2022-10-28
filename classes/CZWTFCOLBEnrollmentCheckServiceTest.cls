@isTest
private class CZWTFCOLBEnrollmentCheckServiceTest {
  @isTest
  public static void testAuthTokanCheck1() {
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCOLBEnrollmentCheckTokenMockClass('successToken'));
    try {
      CZWTFCMulesoftOAuthProvider.getAuthHeader();
    } catch (Exception ex) {
      tffa.Logger.debug(ex.getMessage());
    }
    Test.stopTest();
  }
  @isTest
  public static void testAuthTokanCheck2() {
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCOLBEnrollmentCheckTokenMockClass('failureToken400'));
    try {
      CZWTFCMulesoftOAuthProvider.getAuthHeader();
    } catch (Exception ex) {
      tffa.Logger.debug(ex.getMessage());
    }
    Test.stopTest();
  }
  @isTest
  public static void testAuthTokanMessageCheck2() {
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCOLBEnrollmentCheckTokenMockClass('failureMessageToken400'));
    try {
      CZWTFCMulesoftOAuthProvider.getAuthHeader();
    } catch (Exception ex) {
      tffa.Logger.debug(ex.getMessage());
    }
    Test.stopTest();
  }
  @isTest
  public static void testAuthTokanCheck3() {
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCOLBEnrollmentCheckTokenMockClass('failureToken400_EMPTY'));
    try {
      CZWTFCMulesoftOAuthProvider.getAuthHeader();
    } catch (Exception ex) {
      tffa.Logger.debug(ex.getMessage());
    }
    Test.stopTest();
  }
  @isTest
  public static void testAuthTokanCheck4() {
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCOLBEnrollmentCheckTokenMockClass('failureToken405'));
    try {
      CZWTFCMulesoftOAuthProvider.getAuthHeader();
    } catch (Exception ex) {
      tffa.Logger.debug(ex.getMessage());
    }
    Test.stopTest();
  }
  @isTest
  public static void testAuthMessageTokanCheck4() {
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCOLBEnrollmentCheckTokenMockClass('failureMessageToken405'));
    try {
      CZWTFCMulesoftOAuthProvider.getAuthHeader();
    } catch (Exception ex) {
      tffa.Logger.debug(ex.getMessage());
    }
    Test.stopTest();
  }
  @isTest
  public static void testAuthTokanCheck5() {
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCOLBEnrollmentCheckTokenMockClass('failureToken405_EMPTY'));
    try {
      CZWTFCMulesoftOAuthProvider.getAuthHeader();
    } catch (Exception ex) {
      tffa.Logger.debug(ex.getMessage());
    }
    Test.stopTest();
  }
  @isTest
  public static void testAuthTokanCheck6() {
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCOLBEnrollmentCheckTokenMockClass('failureToken404'));
    try {
      CZWTFCMulesoftOAuthProvider.getAuthHeader();
    } catch (Exception ex) {
      tffa.Logger.debug(ex.getMessage());
    }
    Test.stopTest();
  }
  @isTest
  public static void testAuthMessageTokanCheck6() {
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCOLBEnrollmentCheckTokenMockClass('failureMessageToken404'));
    try {
      CZWTFCMulesoftOAuthProvider.getAuthHeader();
    } catch (Exception ex) {
      tffa.Logger.debug(ex.getMessage());
    }
    Test.stopTest();
  }
  @isTest
  public static void testAuthTokanCheck7() {
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCOLBEnrollmentCheckTokenMockClass('failureToken404_EMPTY'));
    try {
      CZWTFCMulesoftOAuthProvider.getAuthHeader();
    } catch (Exception ex) {
      tffa.Logger.debug(ex.getMessage());
    }
    Test.stopTest();
  }
  @isTest
  public static void testAuthTokanCheck8() {
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCOLBEnrollmentCheckTokenMockClass('failureToken408'));
    try {
      CZWTFCMulesoftOAuthProvider.getAuthHeader();
    } catch (Exception ex) {
      tffa.Logger.debug(ex.getMessage());
    }
    Test.stopTest();
  }
  @isTest
  public static void testAuthMessageTokanCheck8() {
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCOLBEnrollmentCheckTokenMockClass('failureMessageToken408'));
    try {
      CZWTFCMulesoftOAuthProvider.getAuthHeader();
    } catch (Exception ex) {
      tffa.Logger.debug(ex.getMessage());
    }
    Test.stopTest();
  }
  @isTest
  public static void testAuthTokanCheck9() {
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCOLBEnrollmentCheckTokenMockClass('failureToken408_EMPTY'));
    try {
      CZWTFCMulesoftOAuthProvider.getAuthHeader();
    } catch (Exception ex) {
      tffa.Logger.debug(ex.getMessage());
    }
    Test.stopTest();
  }
  @isTest
  public static void testAuthTokanCheck10() {
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCOLBEnrollmentCheckTokenMockClass('failureToken500'));
    try {
      CZWTFCMulesoftOAuthProvider.getAuthHeader();
    } catch (Exception ex) {
      tffa.Logger.debug(ex.getMessage());
    }
    Test.stopTest();
  }
  @isTest
  public static void testAuthMessageTokanCheck10() {
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCOLBEnrollmentCheckTokenMockClass('failureMessageToken500'));
    try {
      CZWTFCMulesoftOAuthProvider.getAuthHeader();
    } catch (Exception ex) {
      tffa.Logger.debug(ex.getMessage());
    }
    Test.stopTest();
  }
  @isTest
  public static void testAuthTokanCheck11() {
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCOLBEnrollmentCheckTokenMockClass('failureToken500_EMPTY'));
    try {
      CZWTFCMulesoftOAuthProvider.getAuthHeader();
    } catch (Exception ex) {
      tffa.Logger.debug(ex.getMessage());
    }
    Test.stopTest();
  }
  @isTest
  public static void testEnrollmentCheck1() {
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCOLBEnrollmentCheckTokenMockClass('successAuth'));
    try {
      CZWTFCOLBEnrollmentCheckService.checkIfOLBIsEnrolled('123456');
    } catch (Exception ex) {
      tffa.Logger.debug(ex.getMessage());
    }
    Test.stopTest();
  }
  @isTest
  public static void testEnrollmentCheck2() {
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCOLBEnrollmentCheckTokenMockClass('failureAuth400'));
    try {
      CZWTFCOLBEnrollmentCheckService.checkIfOLBIsEnrolled('123456');
    } catch (Exception ex) {
      tffa.Logger.debug(ex.getMessage());
    }
    Test.stopTest();
  }
  @isTest
  public static void testEnrollmentMessageCheck2() {
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCOLBEnrollmentCheckTokenMockClass('failureMessageAuth400'));
    try {
      CZWTFCOLBEnrollmentCheckService.checkIfOLBIsEnrolled('123456');
    } catch (Exception ex) {
      tffa.Logger.debug(ex.getMessage());
    }
    Test.stopTest();
  }
  @isTest
  public static void testEnrollmentCheck3() {
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCOLBEnrollmentCheckTokenMockClass('failureAuth400_EMPTY'));
    try {
      CZWTFCOLBEnrollmentCheckService.checkIfOLBIsEnrolled('123456');
    } catch (Exception ex) {
      tffa.Logger.debug(ex.getMessage());
    }
    Test.stopTest();
  }
  @isTest
  public static void testEnrollmentCheck13() {
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCOLBEnrollmentCheckTokenMockClass('failureAuth401'));
    try {
      CZWTFCOLBEnrollmentCheckService.checkIfOLBIsEnrolled('123456');
    } catch (Exception ex) {
      tffa.Logger.debug(ex.getMessage());
    }
    Test.stopTest();
  }
  @isTest
  public static void testEnrollmentMessageCheck13() {
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCOLBEnrollmentCheckTokenMockClass('failureMessageAuth401'));
    try {
      CZWTFCOLBEnrollmentCheckService.checkIfOLBIsEnrolled('123456');
    } catch (Exception ex) {
      tffa.Logger.debug(ex.getMessage());
    }
    Test.stopTest();
  }
  @isTest
  public static void testEnrollmentCheck4() {
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCOLBEnrollmentCheckTokenMockClass('failureAuth401_EMPTY'));
    try {
      CZWTFCOLBEnrollmentCheckService.checkIfOLBIsEnrolled('123456');
    } catch (Exception ex) {
      tffa.Logger.debug(ex.getMessage());
    }
    Test.stopTest();
  }
  @isTest
  public static void testEnrollmentCheck5() {
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCOLBEnrollmentCheckTokenMockClass('failureAuth405'));
    try {
      CZWTFCOLBEnrollmentCheckService.checkIfOLBIsEnrolled('123456');
    } catch (Exception ex) {
      tffa.Logger.debug(ex.getMessage());
    }
    Test.stopTest();
  }
  @isTest
  public static void testEnrollmentMessageCheck5() {
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCOLBEnrollmentCheckTokenMockClass('failureMessageAuth405'));
    try {
      CZWTFCOLBEnrollmentCheckService.checkIfOLBIsEnrolled('123456');
    } catch (Exception ex) {
      tffa.Logger.debug(ex.getMessage());
    }
    Test.stopTest();
  }
  @isTest
  public static void testEnrollmentCheck6() {
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCOLBEnrollmentCheckTokenMockClass('failureAuth405_EMPTY'));
    try {
      CZWTFCOLBEnrollmentCheckService.checkIfOLBIsEnrolled('123456');
    } catch (Exception ex) {
      tffa.Logger.debug(ex.getMessage());
    }
    Test.stopTest();
  }
  @isTest
  public static void testEnrollmentCheck7() {
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCOLBEnrollmentCheckTokenMockClass('failureAuth404'));
    try {
      CZWTFCOLBEnrollmentCheckService.checkIfOLBIsEnrolled('123456');
    } catch (Exception ex) {
      tffa.Logger.debug(ex.getMessage());
    }
    Test.stopTest();
  }
  @isTest
  public static void testEnrollmentMessageCheck7() {
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCOLBEnrollmentCheckTokenMockClass('failureMessageAuth404'));
    try {
      CZWTFCOLBEnrollmentCheckService.checkIfOLBIsEnrolled('123456');
    } catch (Exception ex) {
      tffa.Logger.debug(ex.getMessage());
    }
    Test.stopTest();
  }
  @isTest
  public static void testEnrollmentCheck8() {
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCOLBEnrollmentCheckTokenMockClass('failureAuth404_EMPTY'));
    try {
      CZWTFCOLBEnrollmentCheckService.checkIfOLBIsEnrolled('123456');
    } catch (Exception ex) {
      tffa.Logger.debug(ex.getMessage());
    }
    Test.stopTest();
  }
  @isTest
  public static void testEnrollmentCheck9() {
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCOLBEnrollmentCheckTokenMockClass('failureAuth408'));
    try {
      CZWTFCOLBEnrollmentCheckService.checkIfOLBIsEnrolled('123456');
    } catch (Exception ex) {
      tffa.Logger.debug(ex.getMessage());
    }
    Test.stopTest();
  }
  @isTest
  public static void testEnrollmentMessageCheck9() {
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCOLBEnrollmentCheckTokenMockClass('failureMessageAuth408'));
    try {
      CZWTFCOLBEnrollmentCheckService.checkIfOLBIsEnrolled('123456');
    } catch (Exception ex) {
      tffa.Logger.debug(ex.getMessage());
    }
    Test.stopTest();
  }
  @isTest
  public static void testEnrollmentCheck10() {
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCOLBEnrollmentCheckTokenMockClass('failureAuth408_EMPTY'));
    try {
      CZWTFCOLBEnrollmentCheckService.checkIfOLBIsEnrolled('123456');
    } catch (Exception ex) {
      tffa.Logger.debug(ex.getMessage());
    }
    Test.stopTest();
  }
  @isTest
  public static void testEnrollmentCheck11() {
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCOLBEnrollmentCheckTokenMockClass('failureAuth500'));
    try {
      CZWTFCOLBEnrollmentCheckService.checkIfOLBIsEnrolled('123456');
    } catch (Exception ex) {
      tffa.Logger.debug(ex.getMessage());
    }
    Test.stopTest();
  }
  @isTest
  public static void testEnrollmentMessageCheck11() {
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCOLBEnrollmentCheckTokenMockClass('failureMessageAuth500'));
    try {
      CZWTFCOLBEnrollmentCheckService.checkIfOLBIsEnrolled('123456');
    } catch (Exception ex) {
      tffa.Logger.debug(ex.getMessage());
    }
    Test.stopTest();
  }
  @isTest
  public static void testEnrollmentCheck12() {
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCOLBEnrollmentCheckTokenMockClass('failureAuth500_EMPTY'));
    try {
      CZWTFCOLBEnrollmentCheckService.checkIfOLBIsEnrolled('123456');
    } catch (Exception ex) {
      tffa.Logger.debug(ex.getMessage());
    }
    Test.stopTest();
  }
}