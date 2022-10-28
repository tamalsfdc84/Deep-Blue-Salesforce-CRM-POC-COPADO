/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name			WT_ContactCenterSearchController_T
* @Author		Himanshu Patel
* @version 		v1.0 
* @CreatedDate	05-17-2021
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* Test class for WT_ContactCenterSearchController
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* FUNCTIONAL TEST LOGIC
*  Setup()
* 	> Creates a Person Account and a related Financial Account to use as test data

*  TestFormattedPhoneNumber()
* 	> Tests the FormatPhoneNumber method in WT_ContactCenterSearchController. This method should return a formatted phone number. 

*  TestGetAccount()
* 	> Tests the GetAccounts method in WT_ContactCenterSearchController. This method should return a list of custom search model. 

*  TestGetMulesoftData()
* 	> Tests the GetMulesoftData method in WT_ContactCenterSearchController. This method should return a custom Mulesoft model. 

*  TestGetAdditionalDetails()
* 	> Tests the GetAdditionalDetails method in WT_ContactCenterSearchController. This method should return a custom model with two lists. 
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
@isTest
public class WT_ContactCenterSearchController_T 
{
    @testSetup
    static void Setup()
    {
        Account newTestAccount = WT_TestSetupHelper.GetAccount('Person Account (Customer)');
        insert newTestAccount;
        
        FinServ__FinancialAccount__c financialAccount = WT_TestSetupHelper.GetFinancialAccount('Mortgage', newTestAccount.Id, null);
        insert financialAccount;
    }
    
    @isTest
    static void TestFormattedPhoneNumber()
    {
        Test.startTest();
        String formattedPhoneNumber = WT_ContactCenterSearchController.FormatPhoneNumber('1111111111');
        System.assertEquals(formattedPhoneNumber, '(111) 111-1111');
        
        String unFormattedPhoneNumber = WT_ContactCenterSearchController.FormatPhoneNumber('21111111111');
        System.assertEquals(unFormattedPhoneNumber, '21111111111');
        Test.stopTest();
    }
    
	@isTest
    static void TestGetAccount()
    {
        Test.startTest();
        List<WT_ContactCenterSearchController.AccountSearchResultModel> listSearchResult = WT_ContactCenterSearchController.GetAccounts('111-11111111', 'TesterFirstName', 'TesterLastName',
                                                                                                                                        '123121234', '123456');
        System.assertEquals(listSearchResult.size(), 1);
        Test.stopTest();
    }
    
    @isTest
    static void TestGetMulesoftData()
    {
        Test.startTest();
        List<Account> listExistingAccount = [SELECT Id FROM Account];
        WT_ContactCenterSearchController.MulesoftSearchResultModel mulesoftSearchResult = WT_ContactCenterSearchController.GetMulesoftData(listExistingAccount[0].Id, '(555) 555-5555');
        System.assertEquals(String.isNotBlank(mulesoftSearchResult.DriversLicense), true);
        System.assertEquals(mulesoftSearchResult.ListPasswordModel.size(), 2);
        Test.stopTest();
    }
    
    @isTest
    static void TestGetAdditionalDetails()
    {
        Test.startTest();
        List<Account> listExistingAccount = [SELECT Id FROM Account];
        WT_ContactCenterSearchController.AdditionalDetailSearchResultModel additionalSearchResult = WT_ContactCenterSearchController.GetAdditionalDetails(listExistingAccount[0].Id);
        System.assertEquals(additionalSearchResult.ListFinancialAccount.size(), 1);
        System.assertEquals(additionalSearchResult.ListResidence.size(), 1);
        Test.stopTest();
    }
}