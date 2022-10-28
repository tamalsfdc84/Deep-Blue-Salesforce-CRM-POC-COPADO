/**
 * -------------------------------------------------------------------------------------------------------------------------------------------------
 * @Name			WT_TaskTMCallController_T
 * @Author			Anoop 	<abattini@wintrust.com>	
 * @version 		v1.0 
 * @CreatedDate		02/23/2021
 * ---------------------------------------------------------------------------------------------------------------------------------------------------
 * @Description 
 * Class is used as test class for WT_TaskTMCallController 
 * ---------------------------------------------------------------------------------------------------------------------------------------------------
 * FUNCTIONAL TEST LOGIC

 * ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
@isTest
public class WT_TaskTMCallController_T
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
        WT_Activity_Extension__c ActivityExt =new WT_Activity_Extension__c();
 		ActivityExt.WT_14Day_TMOnboarding_Call__c='Yes';
        ActivityExt.WT_TM_Onboarding_Call__c = '14 Days';
        insert ActivityExt;
        Task newTask1 = new Task(subject='Send Letter' , Priority='Normal' , Status='Open' , WhatId=listNewClassifiedAccount[0].Id ,WT_Override_DNC__c=true);
        insert newTask1;
        WT_Activity_Extension__c ActivityExt1 =new WT_Activity_Extension__c();
 		ActivityExt1.WT_14Day_TMOnboarding_Call__c='Yes';
        ActivityExt1.WT_TM_Onboarding_Call__c = '60 Days';
        insert ActivityExt1;
        Map<String,Id> maprecordTypeId = WT_TaskTMCallController.getRecordType();
        WT_TaskTMCallController.updateTask(ActivityExt.Id,newTask.Id);
        WT_TaskTMCallController.updateTask(ActivityExt1.Id,newTask1.Id);
        WT_TaskTMCallController.returnTaskDetails(newTask.Id);
        WT_TaskTMCallController.fetchRecordTypeID('TM Call');
        WT_TaskTMCallController.TMcallType(ActivityExt.Id);
        WT_TaskTMCallController.getTaskRecordTypeName('TM Call');
       	WT_Activity_Extension__c actExt = [select id,WT_14Day_TMOnboarding_Call__c FROM WT_Activity_Extension__c Where Id =: ActivityExt.Id];
        system.assertEquals(actExt.WT_14Day_TMOnboarding_Call__c,'Yes');
    }
        
}