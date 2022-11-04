@isTest
public class WT_BatchBankOfficerFinAcctReconcile_T 
{
    @testSetup
    static void Setup()
    {
        User newUser = WT_TestSetupHelper.GetUser('testfirstname', 'testlastname', 'test-user@libertyvillebank.com', 'test-user@fakeemail.com.wintrustbank', 'Standard User');
        WT_Switch_Settings__c newSwitchSetting = WT_TestSetupHelper.GetCustomSetting();
        
        insert newSwitchSetting;
        insert newUser;
    }
    
    @isTest
    static void TestFinancialAccountUpdate()
    {
        List<User> listNewUser = [SELECT Id, Name FROM User];
        User userRecord = WT_DataFactory.createUser('WT Retail');
        insert userRecord;
        
        String householdRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        List <Account> listNewPersonAccount = WT_DataFactory.createAccounts(1, 'PersonAccount_Customer', userRecord.id);
        insert listNewPersonAccount;
        
        WT_Bank_Officer_Lookup__c newLookup = new WT_Bank_Officer_Lookup__c();
        newLookup.WT_User__c = listNewUser[0].Id;
        newLookup.WT_Branch_Code__c = '123';
        newLookup.WT_Officer_Code__c = '123';
        newLookup.WT_Source_System__c = 'FIS';        
        insert newLookup;
        
        FinServ__FinancialAccount__c newFinancialAccount = new FinServ__FinancialAccount__c();
        newFinancialAccount.FinServ__PrimaryOwner__c = listNewPersonAccount[0].Id;
        newFinancialAccount.WT_Officer_Number__c = '123|123';
        insert newFinancialAccount;
        
        Database.executeBatch(new WT_BatchBankOfficerFinAcctReconciliation());
    }
}