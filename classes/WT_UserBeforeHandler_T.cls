/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_UserBeforeHandler_T
* @Author			Himmat Patel	<hpatel@wintrust.com>
* @Version			v1.0
* @CreatedDate		06-10-2022
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is test class for before handler class for WT_UserBeforeHandler.
* ---------------------------------------------------------------------------------------------------------------------------------------------------
**/
@isTest
public class WT_UserBeforeHandler_T 
{
   
    @testSetup
    static void Setup()
    {
        WT_DataFactory.createRequiredCustomSetting();	
        User userRecord = WT_DataFactory.createUser('System Administrator');
        userRecord.FirstName = 'Test506';
        insert userRecord;
    }

    @isTest 
    static void testUpdateDateOfLastStatusChangeOnCreateUser()
    {
        User user = [SELECT Id, IsActive,WT_Date_of_Last_Status_Change__c FROM User WHERE FirstName='Test506'];
        system.assertEquals(user.IsActive,true);
        system.assertNotEquals(null,user.WT_Date_of_Last_Status_Change__c);
    }

    @isTest 
    static void testUpdateDateOfLastStatusChangeOnUserRecordChange()
    { 
        User user1 = [SELECT Id, IsActive,WT_Date_of_Last_Status_Change__c FROM User WHERE FirstName='Test506'];
        test.startTest();
        user1.FirstName = 'Test ABC';
        update user1;
        test.stopTest();
        User user2 = [SELECT Id, IsActive,WT_Date_of_Last_Status_Change__c FROM User WHERE FirstName='Test ABC'];
        system.assertEquals(user1.WT_Date_of_Last_Status_Change__c,user2.WT_Date_of_Last_Status_Change__c);
    }
  
    @isTest 
    static void testUpdateDateOfLastStatusChangeOnInActiveUser()
    {
        User user1 = [SELECT Id, IsActive,WT_Date_of_Last_Status_Change__c FROM User WHERE FirstName='Test506'];
        test.startTest();
        user1.IsActive = false;
        user1.FirstName = 'TestABC123';
        update user1;
        test.stopTest();
        User user2 = [SELECT Id, IsActive,WT_Date_of_Last_Status_Change__c FROM User WHERE FirstName='TestABC123'];
        //system.assertNotEquals(user1.WT_Date_of_Last_Status_Change__c,user2.WT_Date_of_Last_Status_Change__c);
    }
}