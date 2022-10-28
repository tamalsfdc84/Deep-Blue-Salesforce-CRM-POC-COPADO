@isTest
public with sharing class CZIDVServiceProviderTest {
  @isTest
  public static void testSuccess() {
    Test.startTest();
    // Test.setMock(HttpCalloutMock.class, new CZWtfcIDServiceProviderMockClass('success'));
    Test.setMock(HttpCalloutMock.class, new CZWTFCOLBEnrollmentCheckTokenMockClass('success'));
    try {
      Map<String, Object> params = new Map<String, Object>();
      tffa__Party__c party1 = new tffa__Party__c();
      party1.tffa__Type__c = 'INDIVIDUAL';
      party1.tffa__FirstName__c = 'Carol1';
      party1.tffa__BirthDate__c = date.newinstance(1990, 2, 17);
      party1.tffa__LastName__c = 'Ellerbrock1';
      party1.Name = 'Carol1 Ellerbrock1';
      party1.tffa__MiddleName__c = 'Samuel1';
      party1.tffa__NationalIdentifierValue__c = '123456789';
      party1.tffa__PrimaryPhone__c = '2314211952';
      party1.tffa__IsExistingCustomer__c = true;
      party1.Customer_Number__c = '123456';
      party1.tffa__BrandCode__c = '118';
      new CZIDVServiceProvider().verify(new List<tffa__Party__c>{ party1 }, params);
    } catch (Exception ex) {
      tffa.Logger.debug(ex.getMessage());
    }
    /*try{
      FISCCCustomerSearchTaxnbrProvider.persistData();
    }catch(Exception ex){}*/

    Test.stopTest();
  }
  @isTest
  public static void testFailure() {
    Test.startTest();
    // Test.setMock(HttpCalloutMock.class, new CZWtfcIDServiceProviderMockClass('failure'));
    Test.setMock(HttpCalloutMock.class, new CZWTFCOLBEnrollmentCheckTokenMockClass('failure'));
    try {
      Map<String, Object> params = new Map<String, Object>();
      tffa__Party__c party2 = new tffa__Party__c();
      party2.tffa__Type__c = 'INDIVIDUAL';
      party2.tffa__FirstName__c = 'Carol2';
      party2.tffa__BirthDate__c = date.newinstance(1990, 2, 17);
      party2.tffa__LastName__c = 'Ellerbrock2';
      party2.Name = 'Carol2 Ellerbrock2';
      party2.tffa__MiddleName__c = 'Samuel2';
      party2.tffa__NationalIdentifierValue__c = '123457789';
      party2.tffa__PrimaryPhone__c = '2314222952';
      party2.tffa__IsExistingCustomer__c = true;
      party2.Customer_Number__c = '123456';
      party2.tffa__BrandCode__c = '118';
      new CZIDVServiceProvider().verify(new List<tffa__Party__c>{ party2 }, params);
    } catch (Exception ex) {
      tffa.Logger.debug(ex.getMessage());
    }
    Test.stopTest();
  }
  @isTest
  public static void testExceptionCase() {
    Test.startTest();
    //Test.setMock(HttpCalloutMock.class, new CZWtfcIDServiceProviderMockClass('exceptionCase'));
    Test.setMock(HttpCalloutMock.class, new CZWTFCOLBEnrollmentCheckTokenMockClass('exceptionCase'));
    try {
      Map<String, Object> params = new Map<String, Object>();
      tffa__Party__c party3 = new tffa__Party__c();
      party3.tffa__Type__c = 'INDIVIDUAL';
      party3.tffa__FirstName__c = 'Carol3';
      party3.tffa__BirthDate__c = date.newinstance(1990, 2, 17);
      party3.tffa__LastName__c = 'Ellerbrock3';
      party3.Name = 'Carol3 Ellerbrock3';
      party3.tffa__MiddleName__c = 'Samuel3';
      party3.tffa__NationalIdentifierValue__c = '123457889';
      party3.tffa__PrimaryPhone__c = '2314233952';
      party3.tffa__IsExistingCustomer__c = true;
      party3.Customer_Number__c = '123456';
      party3.tffa__BrandCode__c = '118';
      new CZIDVServiceProvider().verify(new List<tffa__Party__c>{ party3 }, params);
    } catch (Exception ex) {
      tffa.Logger.debug(ex.getMessage());
    }
    Test.stopTest();
  }
}