/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name			WT_TestSetupHelper_T
* @Author		Himanshu Patel
* @version 		v1.0 
* @CreatedDate	05-17-2021
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* Test class for WT_TestSetupHelper
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* FUNCTIONAL TEST LOGIC
*  TestGetAccount()
* 	> Tests the GetAccount method in WT_TestSetupHelper. This method should return an instance of a Person Account.  

*  TestGetFinancialAccount()
* 	> Tests the GetFinancialAccount method in WT_TestSetupHelper. This method should return an instance of a Financial Account. 

*  TestGetUser()
* 	> Tests the GetUser method in WT_TestSetupHelper. This method should return an instance of a test User. 

*  TestGetCustomSetting()
* 	> Tests the GetCustomSetting method in WT_TestSetupHelper. This method should return an instance of a test Switch Setting Custom Setting. 

*  TestGetReferral()
* 	> Tests the GetReferral method in WT_TestSetupHelper. This method should return an instance of a test Lead. 
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
@isTest
public class WT_TestSetupHelper_T 
{
    @isTest
    static void TestGetAccount()
    {
        Test.startTest();
        Account newAccount = WT_TestSetupHelper.GetAccount('Person Account (Customer)');
        System.assertEquals(String.isNotBlank(newAccount.FirstName), true);
        Test.stopTest();
    }
    
    @isTest
    static void TestGetFinancialAccount()
    {
        Test.startTest();
        Account newAccount = WT_TestSetupHelper.GetAccount('Person Account (Customer)');
        insert newAccount;
        
        FinServ__FinancialAccount__c newFinancialAccount = WT_TestSetupHelper.GetFinancialAccount('Mortgage', newAccount.Id, null);
        System.assertEquals(String.isNotBlank(newFinancialAccount.Name), true);
        Test.stopTest();
    }
    
    @isTest
    static void TestGetUser()
    {
        Test.startTest();
        User newUser = WT_TestSetupHelper.GetUser('testfirstname', 'testlastname', 'test-user@fakeemail.com', 'test-user@fakeemail.com.wintrustbank', 'Standard User');
        System.assertEquals(String.isNotBlank(newUser.FirstName), true);
        Test.stopTest();
    }
    
    @isTest
    static void TestGetCustomSetting()
    {
        Test.startTest();
        WT_Switch_Settings__c newSetting = WT_TestSetupHelper.GetCustomSetting();
        System.assertEquals(newSetting.WT_Is_Trigger_Active__c, true);
        Test.stopTest();
    }
    
    @isTest
    static void TestGetReferral()
    {
        Test.startTest();
        Lead newLead = WT_TestSetupHelper.GetReferral(UserInfo.getUserId(), 'New - Not Contacted', UserInfo.getUserId());
        System.assertEquals(String.isNotBlank(newLead.LastName), true);
        Test.stopTest();
    }
}