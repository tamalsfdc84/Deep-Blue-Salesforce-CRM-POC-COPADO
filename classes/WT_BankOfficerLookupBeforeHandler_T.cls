/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name			WT_BankOfficerLookupBeforeHandler_T
* @Author		Himanshu Patel
* @version 		v1.0 
* @CreatedDate	06-17-2021
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* Test class for WT_BankOfficerLookupBeforeHandler
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* FUNCTIONAL TEST LOGIC
*  TestValidateCodeIsUniqueOnInsert()
* 	> Tests the ValidateCodeIsUnique method (for insert) & ConvertFormulaFieldsToText in WT_BankOfficerLookupBeforeHandler.  

*  TestValidateCodeIsUniqueOnUpdate()
* 	> Tests the ValidateCodeIsUnique method (for update) & ConvertFormulaFieldsToText in WT_BankOfficerLookupBeforeHandler.  
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
@isTest
public class WT_BankOfficerLookupBeforeHandler_T 
{
    @testSetup
    static void Setup()
    {
        User newUser = WT_TestSetupHelper.GetUser('testfirstname', 'testlastname', 'test-user@fakeemail.com', 'test-user@fakeemail.com.wintrustbank', 'Standard User');
        WT_Switch_Settings__c newSwitchSetting = WT_TestSetupHelper.GetCustomSetting();
        
        insert newSwitchSetting;
        insert newUser;
    }
    
    @isTest
    static void TestValidateCodeIsUniqueOnInsert()
    {
        List<User> listNewUser = [SELECT Id, Name FROM User];
        
        Test.startTest();
        WT_Bank_Officer_Lookup__c newLookup = new WT_Bank_Officer_Lookup__c();
        newLookup.WT_User__c = listNewUser[0].Id;
        newLookup.WT_Branch_Code__c = '123';
        newLookup.WT_Officer_Code__c = '123';
        newLookup.WT_Source_System__c = 'FIS';
        
        insert newLookup;
        
        WT_Bank_Officer_Lookup__c newLookup2 = new WT_Bank_Officer_Lookup__c();
        newLookup2.WT_User__c = listNewUser[0].Id;
        newLookup2.WT_Branch_Code__c = '123';
        newLookup2.WT_Officer_Code__c = '123';
        newLookup2.WT_Source_System__c = 'FIS';
        
        try
        {
            insert newLookup2;
        }
        catch(Exception ex)
        {
            
        }
        
        Test.stopTest();
    }
    
    @isTest
    static void TestValidateCodeIsUniqueOnUpdate()
    {
        List<User> listNewUser = [SELECT Id, Name FROM User];
        
        WT_Bank_Officer_Lookup__c newLookup = new WT_Bank_Officer_Lookup__c();
        newLookup.WT_User__c = listNewUser[0].Id;
        newLookup.WT_Branch_Code__c = '123';
        newLookup.WT_Officer_Code__c = '123';
        newLookup.WT_Source_System__c = 'FIS';
        
        insert newLookup;
        
        WT_Bank_Officer_Lookup__c newLookup2 = new WT_Bank_Officer_Lookup__c();
        newLookup2.WT_User__c = listNewUser[0].Id;
        newLookup2.WT_Branch_Code__c = '123';
        newLookup2.WT_Officer_Code__c = '122';
        newLookup2.WT_Source_System__c = 'FIS';
        
        insert newLookup2;
        
        Test.startTest();  
        
        try
        {
            newLookup2.WT_Officer_Code__c = '123';
            update newLookup2;   
        }
        catch(Exception ex)
        {
            
        }
        
        Test.stopTest();
    }
}