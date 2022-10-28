/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name				WT_BatchOpportunity_T
* @Author			Vamsi Pulikallu	<vpulikal@wintrust.com>	
* @version 			v1.0 
* @CreatedDate		21 Jan 2021
* @ModifiedDate		10 Sep 2021
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* Class is used as test class for WT_BatchOpportunitySendEmail, WT_BatchOpportunityClosedLostWeekly, WT_BatchOpportunityTreasuryManagement,
* WT_BatchOppSendEmailSchedule, WT_BatchOppClosedLostScheduleWeekly, WT_BatchOppTreasuryManagementSchedule
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/

@isTest
public class WT_BatchOpportunity_T 
{
	@isTest
    public static void setUpData()
    {
        User userRecord1 = WT_DataFactory.createUser('System Administrator');
        insert userRecord1;
        User userRecord = WT_DataFactory.createUser('System Administrator');
        insert userRecord;
        userRecord1.WT_Line_of_Business__c = 'Treasury Management';
        userRecord1.ManagerId = userRecord.Id;
        update userRecord1;
        
        test.startTest();
        id prospectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('BusinessAccount_Customer').getRecordTypeId();
        Account accountRecord1 = new Account();
        accountRecord1.name = 'Test1';
        accountRecord1.type = 'Prospect';
        accountRecord1.RecordTypeId = prospectRecordTypeId;
        insert accountRecord1;
        List<Opportunity> listOpportunity = new List<Opportunity>();
        Id RecordTypeIdOpportunity = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('WT_Deposit').getRecordTypeId();
        Opportunity opportunityRecord = new Opportunity(StageName='Stage 1 - Opportunity Identified', RecordTypeId=RecordTypeIdOpportunity, CloseDate=Date.Today()-10,name ='test',WT_Status__c = 'Open',Probability=35,AccountId = accountRecord1.id, Amount=12345,WT_New_Dollar__c=10);
        Opportunity opportunityRecord1 = new Opportunity(StageName='Stage 1 - Opportunity Identified', RecordTypeId=RecordTypeIdOpportunity, CloseDate=Date.Today()-11,name ='test1',WT_Status__c = 'Open',Probability=35,AccountId = accountRecord1.id, Amount=12345,WT_New_Dollar__c=10);
        Opportunity opportunityRecord2 = new Opportunity(StageName='Stage 1 - Opportunity Identified', RecordTypeId=RecordTypeIdOpportunity, CloseDate=Date.Today()+3,name ='test2',WT_Status__c = 'Open',Probability=35,AccountId = accountRecord1.id, Amount=12345,WT_New_Dollar__c=10);
        Opportunity opportunityRecord3 = new Opportunity(StageName='Stage 1 - Opportunity Identified', RecordTypeId=RecordTypeIdOpportunity, CloseDate=Date.Today()+5,name ='test3',WT_Status__c = 'Open',Probability=35,AccountId = accountRecord1.id, Amount=12345,WT_New_Dollar__c=10);
        Opportunity opportunityRecord4 = new Opportunity(StageName='Stage 1 - Opportunity Identified', RecordTypeId=RecordTypeIdOpportunity, CloseDate=Date.Today()-33,name ='test4',WT_Status__c = 'Open',Probability=35,AccountId = accountRecord1.id, Amount=12345,WT_New_Dollar__c=10);
        Opportunity opportunityRecord5 = new Opportunity(StageName='Stage 1 - Opportunity Identified', RecordTypeId=RecordTypeIdOpportunity, CloseDate=Date.Today()-22,name ='test5',WT_Status__c = 'Open',Probability=35,AccountId = accountRecord1.id, Amount=12345,WT_New_Dollar__c=10);
        Opportunity opportunityRecord6 = new Opportunity(StageName='Stage 1 - Opportunity Identified', RecordTypeId=RecordTypeIdOpportunity, CloseDate=Date.Today()-365,name ='test6',WT_Status__c = 'Open',Probability=35,AccountId = accountRecord1.id, Amount=12345,WT_New_Dollar__c=10);
        listOpportunity.add(opportunityRecord);
        listOpportunity.add(opportunityRecord1);
        listOpportunity.add(opportunityRecord2);
        listOpportunity.add(opportunityRecord3);
        listOpportunity.add(opportunityRecord4);
        listOpportunity.add(opportunityRecord5);
        listOpportunity.add(opportunityRecord6);
        system.runAs(userRecord1)
        {
        	insert listOpportunity;
        }
        Database.executeBatch(new WT_BatchOpportunitySendEmail());
        Database.executeBatch(new WT_BatchOpportunityClosedLostWeekly());
        System.assertEquals(7, [select count() from Opportunity Where recordTypeId = :RecordTypeIdOpportunity AND isdeleted = false]);
        test.stopTest();
    }
    
    @isTest
    public static void setUpData1()
    {
        test.startTest();
        WT_Switch_Settings__c switchRecord = new WT_Switch_Settings__c();
        switchRecord.WT_Is_Process_Builder_Active__c=true;
        switchRecord.WT_Is_Trigger_Active__c=true;
        switchRecord.WT_Is_Validation_Rule_Active__c=true;
        switchRecord.WT_Is_Workflow_Rule_Active__c=true;
        Database.insert(switchRecord,false);    
        
        User userRecord1 = WT_DataFactory.createUser('System Administrator');
        insert userRecord1;
        User userRecord = WT_DataFactory.createUser('System Administrator');
        insert userRecord;
        userRecord1.WT_Line_of_Business__c = 'Treasury Management';
        userRecord1.ManagerId = userRecord.Id;
        update userRecord1;
        id prospectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('BusinessAccount_Customer').getRecordTypeId();
        //id tmOpportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('WT_TM').getRecordTypeId();
        Account accountRecord1 = new Account();
        accountRecord1.name = 'Test1';
        accountRecord1.type = 'Prospect';
        accountRecord1.RecordTypeId = prospectRecordTypeId;
        accountRecord1.BillingStreet = 'TestA';
        accountRecord1.BillingState = 'Illinois';
        accountRecord1.BillingCity = 'Chicago';
        accountRecord1.BillingCountry = 'United States';
        accountRecord1.BillingPostalCode = '12345';
        accountRecord1.Phone = '1122334455';
        insert accountRecord1;
        Product2 productRecord = new Product2(isactive=true, Name = 'TM - Recapture', Family = 'TM');
        insert productRecord;
        List<Opportunity> listOpportunity = new List<Opportunity>();
        Id RecordTypeIdOpportunity = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('WT_TM').getRecordTypeId();
        Opportunity opportunityRecord = new Opportunity(StageName='Stage 6 - Deal Booked/Closed', WT_Product__c = productRecord.id,RecordTypeId=RecordTypeIdOpportunity, CloseDate=Date.Today(),name ='test',WT_Status__c = 'Closed/Won',Probability=100,AccountId = accountRecord1.id, Amount=12345,WT_New_Dollar__c=10,WT_TMOnboarding_Eligible__c = true,WT_Changes_to_TM_Onboarding_Process__c ='Manual Change - Kick off process with fee under threshold',WT_Actual_Close_Date__c = system.now().addMinutes(-1300));
        listOpportunity.add(opportunityRecord);
        system.runAs(userRecord1)
        {
            insert listOpportunity;        
        }
        OpportunityTeamMember opportunityTeamMemberB = new OpportunityTeamMember(OpportunityAccessLevel = 'Read',UserId = userRecord.id,TeamMemberRole = 'Share Credit',OpportunityId = listOpportunity[0].id);
        insert opportunityTeamMemberB;
        Database.executeBatch(new WT_BatchOpportunityTreasuryManagement());
        System.assertEquals(1, [select count() from Opportunity Where recordTypeId = :RecordTypeIdOpportunity AND isdeleted = false]);
        test.stopTest();
    }
    
    @isTest
    public static void schedulerEmailDailyTest()
    {
        Test.startTest();
        String cronexpression = '0 0 0 15 3 ? *';
        String jobId = System.schedule('ScheduleBatchApexClass',  cronexpression, new WT_BatchOppSendEmailSchedule());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(cronexpression, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();
    }
        
    @isTest
    public static void schedulerClosedStageWeeklyTest()
    {
        Test.startTest();
        String cronexpression = '0 0 0 15 3 ? *';
        String jobId = System.schedule('ScheduleBatchApexClass',  cronexpression, new WT_BatchOppClosedLostScheduleWeekly());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(cronexpression, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();
    }
    
    @isTest
    public static void schedulerTreasuryManagementTest()
    {
        Test.startTest();
        String cronexpression = '0 0 0 15 3 ? *';
        String jobId = System.schedule('ScheduleBatchApexClass',  cronexpression, new WT_BatchOppTreasuryManagementSchedule());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(cronexpression, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();
    }
}