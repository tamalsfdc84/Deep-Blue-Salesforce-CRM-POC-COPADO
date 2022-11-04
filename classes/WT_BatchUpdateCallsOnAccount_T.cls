/**
* --------------------------------------------------------------------------------------------------------------
* @Name             WT_BatchUpdateCallsOnAccount_T
* @Author           Vamsi Pulikallu <vpulikallu@wintrust.com>
* @ModifiedBy       Vamsi Pulikallu <vpulikallu@wintrust.com>
* @Version          v1.0
* @CreatedDate      31 Jan 2022
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is test class for after handler class for WT_BatchUpdateCallsOnAccount.
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* FUNCTIONAL TEST LOGIC
* 1- callsUpdate() 
*   > used to test the updation of calls made in a year fields on Account
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
@isTest
public class WT_BatchUpdateCallsOnAccount_T 
{
    @isTest
    public static void coveredNA()
    {
        id businessCustomerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('BusinessAccount_Customer').getRecordTypeId();
        id accountCoverageRecordTypeId = Schema.SObjectType.WT_Client_Coverage__c.getRecordTypeInfosByDeveloperName().get('WT_Account').getRecordTypeId();
        test.startTest();
        User userRecord = WT_DataFactory.createUser('System Administrator'); 
        userRecord.WT_Line_of_Business__c = 'Middle Market';
        insert userRecord;
        Account accountRecord = new Account(Name = 'Test12',WT_Calls_Made_This_Year__c =2,type = 'Customer',RecordTypeId = businessCustomerRecordTypeId,WT_Classification__c = 'C2', BillingStreet='11', BillingCity='11',BillingState='Some',BillingPostalCode='0011001',BillingCountry='India');
        insert accountRecord;
        Account accountRecord1 = new Account(Name = 'Test12',WT_Calls_Made_Last_Year__c =null,type = 'Customer',RecordTypeId = businessCustomerRecordTypeId,WT_Classification__c = 'C2', BillingStreet='11', BillingCity='11',BillingState='Some',BillingPostalCode='0011001',BillingCountry='India');
        insert accountRecord1;
        system.runAs(userRecord)
        {
            Database.executeBatch(new WT_BatchUpdateCallsOnAccount());
        }   
        System.assertEquals(2, [select count() from Account Where recordTypeId = :businessCustomerRecordTypeId AND isdeleted = false]);    
        test.stopTest();
    }
    
    @isTest
    public static void schedulerTest()
    {
        String cronexpression = '0 0 0 15 3 ? *';
        Test.startTest();
        String jobId = System.schedule('ScheduleBatchApexClass',  cronexpression, new WT_BatchUpdateCallsOnAccountSchedule());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(cronexpression, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();
    }
}