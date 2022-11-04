@isTest
public class WT_BatchBankOfficerAcctReconciliation_T 
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
    static void TestPersonAccountCustomerUpdate()
    {
        List<User> listNewUser = [SELECT Id, Name FROM User];
        
        Test.startTest();
        WT_Bank_Officer_Lookup__c newLookup = new WT_Bank_Officer_Lookup__c();
        newLookup.WT_User__c = listNewUser[0].Id;
        newLookup.WT_Branch_Code__c = '123';
        newLookup.WT_Officer_Code__c = '123';
        newLookup.WT_Source_System__c = 'FIS';        
        insert newLookup;
        
        User userRecord = WT_DataFactory.createUser('WT Retail');
        insert userRecord;
        
        List<Account> listAccount = WT_DataFactory.createAccounts(1, 'PersonAccount_Customer', userRecord.Id);
        listAccount[0].WT_Primary_Officer_Number__c = '123|123';
        insert listAccount;
        
        Database.executeBatch(new WT_BatchBankOfficerAccountReconciliation());
        
        Account accountToCheck = [SELECT Id,
                                  OwnerId,
                                  RecordTypeId,
                                  WT_Primary_Officer_Number__c
                                  FROM Account
                                  WHERE Id = :listAccount[0].Id
                                  LIMIT 1];
        Test.stopTest();
    }
}