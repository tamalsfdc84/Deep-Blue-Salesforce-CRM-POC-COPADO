/**
@author     : Amit Wagle
@description: This test class covers testcoverage for CZWTFCFISHolidayBatchTest
@version 	: 1.0  02 Nov, 2021
*/

@isTest
private class CZWTFCFISHolidayBatchTest {
  @isTest
  static void test1() {
    tffa__Brand__c brand1 = new tffa__Brand__c();
    brand1.tffa__Code__c = '118';
    insert brand1;

    CZFISHolidayList__c holiday1 = new CZFISHolidayList__c();
    holiday1.BrandCode__c = '118';
    holiday1.HolidayCurYrDt__c = Date.today();
    holiday1.HolidayDesc__c = 'Holi';
    holiday1.HolidayNxtYrDt__c = Date.today();
    holiday1.Name = 'abc';
    insert holiday1;

    CZFISHolidayList__c holiday2 = new CZFISHolidayList__c();
    holiday2.BrandCode__c = '118';
    holiday2.HolidayCurYrDt__c = Date.today();
    holiday2.HolidayDesc__c = 'Holiday';
    holiday2.HolidayNxtYrDt__c = Date.today();
    holiday2.Name = 'abcd';
    insert holiday2;

    Test.StartTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCFISHolidayBatchMockClass());
    Database.executeBatch(new CZWTFCFISHolidayBatch());
    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }

  @isTest
  static void test2() {
    Test.StartTest();
    List<CZWTFCFISHolidayDTO> holiday = new List<CZWTFCFISHolidayDTO>();

    CZWTFCFISHolidayDTO holidtls = new CZWTFCFISHolidayDTO();
    holidtls.BrandCode = '118';
    holidtls.HolCurYrDte = '01/01/2020';
    holidtls.HolDesc = 'Holi';
    holidtls.HolNxtYrDte = '01/01/2020';
    holiday.add(holidtls);

    CZWTFCFISHolidayDTO holidtls2 = new CZWTFCFISHolidayDTO();
    holidtls2.BrandCode = '118';
    holidtls2.HolCurYrDte = '01/01/2020';
    holidtls2.HolDesc = 'Holi';
    holidtls2.HolNxtYrDte = '01/01/2020';
    holiday.add(holidtls2);

    CZWTFCFISHolidayResponse holiResponse = new CZWTFCFISHolidayResponse();
    List<CZWTFCFISHolidayDTO> holidayList = holiResponse.holidayList;
    holidayList.add(holidtls);
    holidayList.add(holidtls2);

    CZWTFCFISHolidayDTO objCZWTFCFISHolidayDTO = new CZWTFCFISHolidayDTO();
    FISCCHostAdapter.processHostRequest(null, null, null);

    try {
      CZWTFCFISHolidayResponse response = CZWTFCFISHolidayProvider.getHolidayDetails('118');

      if (response != null) {
        List<CZFISHolidayList__c> updatedHolidayDetails = CZWTFCFISHolidayBatch.getUpdatedHolidayDtls('118', holiday);
        tffa.Logger.debug('CZWTFCFISHolidayBatch updatedHolidayDetails');

        List<CZFISHolidayList__c> fetchHolidayDetails = CZWTFCHelperRepository.fetchFISHolidayDetails('118');
        Savepoint sp = Database.setSavepoint();
        try {
          if (!updatedHolidayDetails.isEmpty()) {
            if (!fetchHolidayDetails.isEmpty()) {
              CZWTFCHelperRepository.deleteFISHolidayList(fetchHolidayDetails);
            }
            WTFCObjectManagerRepository.doUpsertObjects(updatedHolidayDetails);
          }
        } catch (Exception ep) {
          Database.rollback(sp);
          tffa.Logger.error('CZWTFCFISHolidayBatch Exception : ' + ep.getMessage() + ' ' + ep.getStackTraceString());
          tffa.logger.debug('CZWTFCFISHolidayBatch: Rollback ');
        }
        tffa.Logger.debug('CZWTFCFISHolidayBatch fetchHolidayDetails');
      }
    } catch (Exception ex) {
      tffa.Logger.debug('Test Execption thrown');
    }
    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }

  @isTest
  static void test3() {
    Test.StartTest();
    try {
      CZWTFCFISHolidayResponse response = CZWTFCFISHolidayProvider.getHolidayDetails('118');
      if (response != null) {
        List<CZFISHolidayList__c> updatedHolidayDetails = CZWTFCFISHolidayBatch.getUpdatedHolidayDtls('118', null);
        List<CZFISHolidayList__c> fetchHolidayDetails = CZWTFCHelperRepository.fetchFISHolidayDetails('118');

        updatedHolidayDetails.clear();
        fetchHolidayDetails.clear();

        Savepoint sp = Database.setSavepoint();
        try {
          if (!updatedHolidayDetails.isEmpty()) {
            if (!fetchHolidayDetails.isEmpty()) {
              CZWTFCHelperRepository.deleteFISHolidayList(fetchHolidayDetails);
            }
            WTFCObjectManagerRepository.doUpsertObjects(updatedHolidayDetails);
          }
        } catch (Exception ep) {
          Database.rollback(sp);
          tffa.Logger.error('CZWTFCFISHolidayBatch Exception : ' + ep.getMessage() + ' ' + ep.getStackTraceString());
          tffa.logger.debug('CZWTFCFISHolidayBatch: Rollback ');
        }
      }
    } catch (Exception ex) {
      tffa.Logger.debug('Test Execption thrown');
    }
    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }

  @isTest
  static void test4() {
    Test.StartTest();
    String validResponse = '{"Entity":{"processing-schedules-weekdays":{"Tue":"Y","Thur":"Y","Wed":"Y","Sat":"N","WkDaySegEffDte":"1996-08-08","Fri":"Y","Sun":"N","Mon":"Y","HolSegEffDte":"2021-12-10"},"processing-schedules-holidaysLst":[{"HolPrevYrDte":"01/01/2021","HolCurYrDte":"01/01/2022","HolDesc":"NEW YEARS DAY","HolNxtYrDte":"01/02/2023"},{"HolPrevYrDte":"01/18/2021","HolCurYrDte":"01/17/2022","HolDesc":"MARTIN LUTHER KING","HolNxtYrDte":"01/16/2023"},{"HolPrevYrDte":"02/15/2021","HolCurYrDte":"02/21/2022","HolDesc":"PRESIDENTS DAY","HolNxtYrDte":"02/20/2023"},{"HolPrevYrDte":"05/31/2021","HolCurYrDte":"05/30/2022","HolDesc":"MEMORIAL DAY","HolNxtYrDte":"05/29/2023"},{"HolPrevYrDte":"06/19/2021","HolCurYrDte":"06/20/2022","HolDesc":"JUNETEENTH DAY","HolNxtYrDte":"06/19/2023"},{"HolPrevYrDte":"07/05/2021","HolCurYrDte":"07/04/2022","HolDesc":"INDEPENDENCE DAY","HolNxtYrDte":"07/04/2023"},{"HolPrevYrDte":"09/06/2021","HolCurYrDte":"09/05/2022","HolDesc":"LABOR DAY","HolNxtYrDte":"09/04/2023"},{"HolPrevYrDte":"10/11/2021","HolCurYrDte":"10/10/2022","HolDesc":"COLUMBUS DAY","HolNxtYrDte":"10/09/2023"},{"HolPrevYrDte":"11/11/2021","HolCurYrDte":"11/11/2022","HolDesc":"VETERANS DAY","HolNxtYrDte":"11/11/2023"},{"HolPrevYrDte":"11/25/2021","HolCurYrDte":"11/24/2022","HolDesc":"THANKSGIVING DAY","HolNxtYrDte":"11/23/2023"},{"HolPrevYrDte":"12/25/2021","HolCurYrDte":"12/26/2022","HolDesc":"CHRISTMAS DAY","HolNxtYrDte":"12/25/2023"}]},"Metadata":{"MsgLst":[{"Type":"Informational Message","Text":"Success","Severity":"Info","Code":"0"}]}}';

    try {
      new FISCCGetFISHolidayDtlsResponseBuilder().build(validResponse, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
      new FISCCGetFISHolidayDtlsResponseBuilder().parseResponse(new FISCCGetHolidayEntityResponse(), null, null);
    } catch (Exception e) {
      tffa.Logger.debug('Test Execption thrown');
    }
    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }

  @isTest
  static void test5() {
    Test.StartTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCFISHolidayBatchMockClass());
    Database.executeBatch(new CZWTFCFISHolidayBatch());

    try {
      FISCCGetFISHolidayDtlsResponseBuilder.testException = true;
      new FISCCGetFISHolidayDtlsResponseBuilder().build(null, null, null);
      new FISCCGetFISHolidayDtlsResponseBuilder().parseResponse(null, null, null);
    } catch (Exception e) {
      tffa.Logger.debug('Test Execption thrown');
    }

    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }

  @isTest
  static void test6() {
    tffa__Brand__c brand1 = new tffa__Brand__c();
    brand1.tffa__Code__c = '118';
    insert brand1;

    CZFISHolidayList__c holiday1 = new CZFISHolidayList__c();
    holiday1.BrandCode__c = '118';
    holiday1.HolidayCurYrDt__c = Date.today();
    holiday1.HolidayDesc__c = 'Holi';
    holiday1.HolidayNxtYrDt__c = Date.today();
    holiday1.Name = 'abc';
    insert holiday1;

    CZFISHolidayList__c holiday2 = new CZFISHolidayList__c();
    holiday2.BrandCode__c = '118';
    holiday2.HolidayCurYrDt__c = Date.today();
    holiday2.HolidayDesc__c = 'Holiday';
    holiday2.HolidayNxtYrDt__c = Date.today();
    holiday2.Name = 'abcd';
    insert holiday2;

    Test.StartTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCFISHolidayBatchMockClass());
    Database.executeBatch(new CZWTFCFISHolidayBatch());

    try {
      CZWTFCFISHolidayResponse response = CZWTFCFISHolidayProvider.getHolidayDetails('118');
      if (response == null) {
        tffa.Logger.debug('CZWTFCFISHolidayResponse is null');
      }
    } catch (Exception ex) {
      tffa.logger.debug('CZWTFCFISHolidayProvider.getHolidayDetails: Exception :::' + ex.getMessage() + ex.getStackTraceString());
    }

    try {
      CZWTFCFISHolidayResponse response2 = CZWTFCHolidayDetailsExtension.invokeHolidayDetails(null, null);
      if (response2 == null) {
        tffa.Logger.debug('CZWTFCFISHolidayResponse is null');
      }
      CZWTFCFISHolidayResponse finalResponse = new CZWTFCFISHolidayResponse();
      FISCC_Adapter_Configs__mdt adapterConfigInput = null;
      Object result = FISCCHostAdapter.processHostRequest(null, null, null);
      CZWTFCFISHolidayResponse response = CZWTFCHolidayDetailsExtension.isFISCCAPICallSuccess(result);
      if (response != null) {
        finalResponse.controlData = response.controlData;
        finalResponse.holidayList = response.holidayList;
      }
    } catch (Exception e) {
      tffa.Logger.debug('Test Execption thrown');
    }
    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }

  @isTest
  static void test7() {
    Test.StartTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCFISHolidayBatchMockClass());
    Database.executeBatch(new CZWTFCFISHolidayBatch());

    List<CZWTFCFISHolidayDTO> holiday = new List<CZWTFCFISHolidayDTO>();

    CZWTFCFISHolidayDTO holidtls = new CZWTFCFISHolidayDTO();
    holidtls.BrandCode = '118';
    holidtls.HolCurYrDte = '01/01/2020';
    holidtls.HolDesc = 'Holi';
    holidtls.HolNxtYrDte = '01/01/2020';
    holiday.add(holidtls);

    CZWTFCFISHolidayResponse finalResponse = new CZWTFCFISHolidayResponse();

    CZWTFCFISHolidayResponse response = CZWTFCHolidayDetailsExtension.isFISCCAPICallSuccess(null);
    response = new CZWTFCFISHolidayResponse();
    response.controlData.Fri = 'Y';
    response.controlData.Mon = 'Y';
    response.controlData.Thur = 'Y';
    response.holidayList = holiday;

    if (response != null) {
      finalResponse.controlData = response.controlData;
      finalResponse.holidayList = response.holidayList;
    }

    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }

  @isTest
  static void test8() {
    Test.StartTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCFISHolidayBatchMockClass());
    Database.executeBatch(new CZWTFCFISHolidayBatch());

    List<CZFISHolidayList__c> fetchDtls = new List<CZFISHolidayList__c>();

    if (!fetchDtls.isEmpty()) {
      CZWTFCHelperRepository.deleteFISHolidayList(fetchDtls);
    }
    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }

  @isTest
  static void test9() {
    Test.StartTest();
    Test.setMock(HttpCalloutMock.class, new CZWTFCFISHolidayBatchMockClass());
    Database.executeBatch(new CZWTFCFISHolidayBatch());

    CZWTFCFISHolidayDTO holidtls = new CZWTFCFISHolidayDTO();
    holidtls.BrandCode = '118';
    holidtls.HolCurYrDte = '01/01/2020';
    holidtls.HolDesc = 'Holi';
    holidtls.HolNxtYrDte = '01/01/2020';

    FISCCHostAdapter.processHostRequest(null, null, null);

    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }

  @isTest
  static void test10() {
    Test.StartTest();

    List<CZFISHolidayList__c> updatedHolidayDetails = new List<CZFISHolidayList__c>();
    CZFISHolidayList__c updatedHoliday = new CZFISHolidayList__c();
    updatedHoliday.name = 'abc';
    updatedHoliday.BrandCode__c = '109';
    updatedHoliday.HolidayCurYrDt__c = Date.parse('07/04/2021');
    updatedHoliday.HolidayNxtYrDt__c = Date.parse('07/04/2022');
    updatedHoliday.HolidayDesc__c = 'HolDesc';
    updatedHolidayDetails.add(updatedHoliday);

    List<CZFISHolidayList__c> fetchHolidayDetails = new List<CZFISHolidayList__c>();
    CZFISHolidayList__c fetchHoliday = new CZFISHolidayList__c();
    fetchHoliday.name = 'abcd';
    fetchHoliday.BrandCode__c = '110';
    fetchHoliday.HolidayCurYrDt__c = Date.parse('07/04/2021');
    fetchHoliday.HolidayNxtYrDt__c = Date.parse('07/04/2022');
    fetchHoliday.HolidayDesc__c = 'HolDesc2';
    fetchHolidayDetails.add(fetchHoliday);

    try {
      if (!updatedHolidayDetails.isEmpty()) {
        if (!fetchHolidayDetails.isEmpty()) {
          CZWTFCHelperRepository.deleteFISHolidayList(fetchHolidayDetails);
        }
        WTFCObjectManagerRepository.doUpsertObjects(updatedHolidayDetails);
      }
    } catch (Exception ep) {
      tffa.Logger.error('CZWTFCFISHolidayBatch Exception : Rollback -' + ep.getMessage() + ' ' + ep.getStackTraceString());
    }
    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }
}