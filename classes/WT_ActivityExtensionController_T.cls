/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name			WT_ActivityExtensionController_T
* @Author			Swaminathan E 	<sezhumal@wintrust.com>	
* @version 		v1.0 
* @CreatedDate		02/23/2021
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* Class is used as test class for WT_ActivityExtensionController
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* FUNCTIONAL TEST LOGIC
*runFetchRecordTypeID -> excute to cover the code coverage. 
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
@isTest
public class WT_ActivityExtensionController_T 
{
    @isTest static void runFetchRecordTypeID()
    {        
        WT_DataFactory.createRequiredCustomSetting();
        User userRecord = WT_DataFactory.createUser('System Administrator');       
        insert userRecord;
        List <Account> listNewClassifiedAccount = WT_DataFactory.createAccounts(1,'PersonAccount_Customer',userRecord.id);
        listNewClassifiedAccount[0].WT_SSN_TIN__pc='123427813';
        insert listNewClassifiedAccount;
        Task newTask = new Task(subject='Send Letter' , Priority='Normal' , Status='Open' , WhatId=listNewClassifiedAccount[0].Id ,WT_Override_DNC__c=true);
        insert newTask;
        WT_Activity_Extension__c activityExtension =new WT_Activity_Extension__c();
        activityExtension.WT_14Day_TMOnboarding_Call__c='Yes';
        activityExtension.WT_TM_Onboarding_Call__c = '14 Days';
        insert activityExtension;
        Task newTaskRecord = new Task(subject='Send Letter' , Priority='Normal' , Status='Open' , WhatId=listNewClassifiedAccount[0].Id ,WT_Override_DNC__c=true);
        insert newTaskRecord;
        WT_Activity_Extension__c activityExtensionRecord =new WT_Activity_Extension__c();
        activityExtensionRecord.WT_14Day_TMOnboarding_Call__c='Yes';
        activityExtensionRecord.WT_TM_Onboarding_Call__c = '60 Days';
        insert activityExtensionRecord;
        Test.startTest();
        WT_ActivityExtensionController.updateTask(activityExtension.Id,newTask.Id);
        WT_ActivityExtensionController.updateTask(activityExtensionRecord.Id,newTaskRecord.Id);
        WT_ActivityExtensionController.returnTaskDetails(newTask.Id);
        WT_ActivityExtensionController.fetchRecordTypeID('WT_Wintrust_Task');
        WT_ActivityExtensionController.returnEventDetails(null);
        Test.stopTest();
        WT_Activity_Extension__c actExt = [select id,WT_14Day_TMOnboarding_Call__c FROM WT_Activity_Extension__c Where Id =: activityExtension.Id];
        
    }        
}