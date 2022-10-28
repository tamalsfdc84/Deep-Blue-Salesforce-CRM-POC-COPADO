/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name				WT_BatchTaskTMCall_T
* @Author			Vamsi Pulikallu	<vpulikal@wintrust.com>	
* @version 			v1.0 
* @CreatedDate		26 Feb 2021
* @ModifiedDate		26 Feb 2021
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* Class is used as test class for WT_BatchtaskTMCallPastDueSendEmail,WT_BatchTaskTMCallCompletedSendEmail,
* WT_BatchTaskTMPastDueSendEmailSchedule,WT_BatchTaskTMCompletedSendEmailSchedule
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
@isTest
public class WT_BatchTaskTMCall_T 
{
    @isTest
	public static void setUpData()
    {
        test.startTest();        
        User userRecord1 = WT_DataFactory.createUser('System Administrator');
        insert userRecord1;
        User userRecord = WT_DataFactory.createUser('System Administrator');
        insert userRecord;
        userRecord.WT_Line_of_Business__c = 'Treasury Management';
        userRecord.ManagerId = userRecord1.Id;
        update userRecord;
        id prospectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('BusinessAccount_Customer').getRecordTypeId();
        Account accountRecord1 = new Account();
        accountRecord1.name = 'Test1';
        accountRecord1.type = 'Prospect';
        accountRecord1.RecordTypeId = prospectRecordTypeId;
        insert accountRecord1;
        List<Opportunity> listOpportunity = new List<Opportunity>();
        Id RecordTypeIdOpportunity = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('WT_TM').getRecordTypeId();
        Opportunity opportunityRecord = new Opportunity(StageName='Stage 6 - Deal Booked/Closed', RecordTypeId=RecordTypeIdOpportunity, CloseDate=Date.Today(),name ='test',WT_Status__c = 'Closed/Won',Probability=100,AccountId = accountRecord1.id, Amount=12345,WT_New_Dollar__c=10,WT_TMOnboarding_Eligible__c = true,WT_Changes_to_TM_Onboarding_Process__c ='No Changes to Automatic Onboarding Process',WT_Actual_Close_Date__c = system.now().addMinutes(-1429));
        listOpportunity.add(opportunityRecord);
        
        insert listOpportunity;
        OpportunityTeamMember opportunityTeamMemberB = new OpportunityTeamMember(OpportunityAccessLevel = 'Read',UserId = userRecord.id,TeamMemberRole = 'Product Partner',OpportunityId = listOpportunity[0].id);
        insert opportunityTeamMemberB;
        Id tmTaskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('TM_Call').getRecordTypeId();
        Id tmActivityExtensionRecordTypeId = Schema.SObjectType.WT_Activity_Extension__c.getRecordTypeInfosByDeveloperName().get('TM_Call').getRecordTypeId();
        list<WT_Activity_Extension__c> listactivityExtensions = new list<WT_Activity_Extension__c>();
        list<Task> listTasks = new list<Task>();
        Task Day14Task1 = new Task(WhatId = listOpportunity[0].Id, Subject = '14 Day TM Onboarding Call – '+listOpportunity[0].Account.Name,
                                  RecordTypeId = tmTaskRecordTypeId,OwnerId = userRecord.id,ActivityDate = system.today().addDays(-3),Status ='Open'
                                 );
        listTasks.add(Day14Task1);
        Task Day60Task1 = new Task(WhatId = listOpportunity[0].Id, Subject = '14 Day TM Onboarding Call – '+listOpportunity[0].Account.Name,
                                  RecordTypeId = tmTaskRecordTypeId,OwnerId = userRecord.id,ActivityDate = system.today().adddays(-3),Status ='Open'
                                 );
        listTasks.add(Day60Task1);
        Task Day14Task = new Task(WhatId = listOpportunity[0].Id, Subject = '14 Day TM Onboarding Call – '+listOpportunity[0].Account.Name,
                                  RecordTypeId = tmTaskRecordTypeId,OwnerId = userRecord.id,ActivityDate = system.today().addDays(-1),Status ='Completed',
                                 WT_Activity_Completed_Date__c = system.today().addDays(-1));
        listTasks.add(Day14Task);
        Task Day60Task = new Task(WhatId = listOpportunity[0].Id, Subject = '14 Day TM Onboarding Call – '+listOpportunity[0].Account.Name,
                                  RecordTypeId = tmTaskRecordTypeId,OwnerId = userRecord.id,ActivityDate = system.today().adddays(-1),Status ='Completed' ,
                                 WT_Activity_Completed_Date__c = system.today().addDays(-1));
        listTasks.add(Day60Task);
        insert listTasks;
        WT_Activity_Extension__c Day14activityExtension = new WT_Activity_Extension__c(WT_TaskId__c = Day14Task.Id,
            WT_TM_Onboarding_Call__c = '14 Days', WT_Activity_Type__c = 'Task',
            WT_TM_Onboarding_Due_Date__c = system.today()+14,OwnerId=userRecord.id,RecordTypeId = tmActivityExtensionRecordTypeId);
        listactivityExtensions.add(Day14activityExtension);
        WT_Activity_Extension__c Day60activityExtension = new WT_Activity_Extension__c(WT_TaskId__c = Day60Task.Id,
            WT_TM_Onboarding_Call__c = '60 Days',  WT_Activity_Type__c = 'Task',
            WT_TM_Onboarding_Due_Date__c = system.today()+60,OwnerId=userRecord.id,RecordTypeId = tmActivityExtensionRecordTypeId);
        listactivityExtensions.add(Day60activityExtension);
        WT_Activity_Extension__c Day14activityExtension1 = new WT_Activity_Extension__c(WT_TaskId__c = Day14Task1.Id,
            WT_TM_Onboarding_Call__c = '14 Days', WT_Activity_Type__c = 'Task',
            WT_TM_Onboarding_Due_Date__c = system.today()+14,OwnerId=userRecord.id,RecordTypeId = tmActivityExtensionRecordTypeId);
        listactivityExtensions.add(Day14activityExtension1);
        WT_Activity_Extension__c Day60activityExtension1 = new WT_Activity_Extension__c(WT_TaskId__c = Day60Task1.Id,
            WT_TM_Onboarding_Call__c = '60 Days',  WT_Activity_Type__c = 'Task',
            WT_TM_Onboarding_Due_Date__c = system.today()+60,OwnerId=userRecord.id,RecordTypeId = tmActivityExtensionRecordTypeId);
        listactivityExtensions.add(Day60activityExtension1);        
        insert listactivityExtensions;
        
        Database.executeBatch(new WT_BatchTaskTMCallPastDueSendEmail());
        Database.executeBatch(new WT_BatchTaskTMCallCompletedSendEmail());
        System.assertEquals(1, [select count() from Opportunity Where recordTypeId = :RecordTypeIdOpportunity AND isdeleted = false]);
        test.stopTest();
    }
    
    @isTest
    public static void schedulerPastDueSendEmailTest()
    {
        Test.startTest();
        String cronexpression = '0 0 0 15 3 ? *';
        String jobId = System.schedule('ScheduleBatchApexClass',  cronexpression, new WT_BatchTaskTMPastDueSendEmailSchedule());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(cronexpression, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();
    }
    
    @isTest
    public static void schedulerCompletedSendEmailTest()
    {
        Test.startTest();
        String cronexpression = '0 0 0 15 3 ? *';
        String jobId = System.schedule('ScheduleBatchApexClass',  cronexpression, new WT_BatchTaskTMCompletedSendEmailSchedule());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(cronexpression, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();
    }
}