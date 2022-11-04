@isTest
public class WT_FAQCustomerSupportController_T 
{
	@testSetup
    static void Setup()
    {
        WT_FAQ_Customer_Support__c newCustomerSupport = new WT_FAQ_Customer_Support__c();
        newCustomerSupport.WT_Bank_Name__c = 'Test';
        newCustomerSupport.WT_Customer_Support_Phone__c = '5555555555';
        
        insert newCustomerSupport;
    }
    
    @isTest
    static void TestGetCustomerSupportInformation()
    {
        Test.startTest();
        WT_FAQCustomerSupportController.GetCustomerSupportInformation();
        Test.stopTest();
    }
}