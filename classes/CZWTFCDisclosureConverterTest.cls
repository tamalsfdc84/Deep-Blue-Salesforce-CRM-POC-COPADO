@isTest
public with sharing class CZWTFCDisclosureConverterTest {
  @isTest
  public static void testCaseOne() {
    tffa__Brand__c objBrand = new tffa__Brand__c();
    objBrand.tffa__Code__c = '118';
    objBrand.ContactNumber__c = '123455';
    insert objBrand;

    tffa__Submission__c sub = new tffa__Submission__c(tffa__Brand__c = '118', tffa__Status__c = 'SUBMITTED');
    insert sub;

    tffa__Disclosure__c disObj = new tffa__Disclosure__c();
    disObj.tffa__EventName__c = 'AccountDetails_OD';
    disObj.tffa__Label__c = '<div>{Product_Name}</div> <div>Standard Overdraft Practice: <b>{STD_OPT}</b> </div> <div>ATM and Non-Recurring Debit Card Transactions: <b>{ATM_OPT}</b></div> <div>Overdraft Protection from another Deposit Account: <b>{OD_OPT}</b></div>';
    disObj.tffa__Type__c = 'TEXT';
    disObj.tffa__Code__c = 'TEXT';
    disObj.tffa__Submission__c = sub.Id;
    insert disObj;

    tffa.SObjectAssembler asmSub = new tffa.SObjectAssembler(sub);
    asmSub.addChildObject('Disclosures__r', disObj);

    Test.startTest();
    Database.executeBatch(new CZWTFCPdfConverterBatch());
    CZWTFCGenDisclosurePdfProvider genDiscPdf = new CZWTFCGenDisclosurePdfProvider();
    Object resp = genDiscPdf.generateDisclosurePdf((tffa__Submission__c) asmSub.assemble());
    System.assertNotEquals(resp, null);
    Test.stopTest();
  }
}