/**
* --------------------------------------------------------------------------------------------------------------
* @Name             WT_BatchUpdateClientCoverageOnAccount_T
* @Author           Vamsi Pulikallu <vpulikallu@wintrust.com>
* @ModifiedBy       Vamsi Pulikallu <vpulikallu@wintrust.com>
* @Version          v1.0
* @CreatedDate      15 Jan 2021
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is test class for after handler class for WT_BatchUpdateClientCoverageOnAccount.
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* FUNCTIONAL TEST LOGIC
* 1- coveredAnnualTest() 
*   > used to test the updation of client coverage fields on Account
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
@isTest
public class WT_BatchUpdateClientCoverageRelGrpAcc_T {
    @isTest
    public static void coveredAnnualTest()
    {
        id realationshipGroupRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Relationship_Group').getRecordTypeId();
        id relationshipCoverageRecordTypeId = Schema.SObjectType.WT_Client_Coverage__c.getRecordTypeInfosByDeveloperName().get('WT_Relationship').getRecordTypeId();
        id taskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('WT_CRA_Call').getRecordTypeId();
        id eventRecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByDeveloperName().get('WT_CRA_Event').getRecordTypeId();
        id eventRecordTypeId1 = Schema.SObjectType.Event.getRecordTypeInfosByDeveloperName().get('WT_Wintrust_Event').getRecordTypeId();
        test.startTest();
        User userRecord = WT_DataFactory.createUser('System Administrator'); 
        userRecord.WT_Line_of_Business__c = 'Middle Market';
        User userRecord2 = WT_DataFactory.createUser('System Administrator'); 
        List<User> listUser = new List<User>();
        listUser.add(userRecord);
        listUser.add(userRecord2);
        insert listUser;
        Account accountRecord = new Account(Name = 'Test1',type = 'Customer',ownerID = userRecord.id, RecordTypeId = realationshipGroupRecordTypeId,WT_Classification__c = 'C1', BillingStreet='11', BillingCity='11',BillingState='Some',BillingPostalCode='0011001',BillingCountry='India');
        Account accountRecord2 = new Account(Name = 'Test12',type = 'Customer',RecordTypeId = realationshipGroupRecordTypeId,WT_Classification__c = 'C2', WT_Covered_Last_Year_Report__c='',WT_Covered_Last_Year__c='', BillingStreet='11', BillingCity='11',BillingState='Some',BillingPostalCode='0011001',BillingCountry='India');
        Account accountRecord3 = new Account(Name = 'Test1',type = 'Customer',RecordTypeId = realationshipGroupRecordTypeId,WT_Classification__c = 'C2', BillingStreet='11', BillingCity='11',BillingState='Some',BillingPostalCode='0011001',BillingCountry='India');
        Account accountRecord4 = new Account(Name = 'Test1',type = 'Customer',RecordTypeId = realationshipGroupRecordTypeId,WT_Classification__c = '', BillingStreet='11', BillingCity='11',BillingState='Some',BillingPostalCode='0011001',BillingCountry='India');
        
        List <Account> listNewClassifiedAccount = new list<Account>();
        listNewClassifiedAccount.add(accountRecord);
        listNewClassifiedAccount.add(accountRecord2);
        listNewClassifiedAccount.add(accountRecord3);
        listNewClassifiedAccount.add(accountRecord4);
        insert listNewClassifiedAccount;  
        Event eventRecord1 =new Event(Subject='Send Letter', WT_Relationship_Group__c = accountRecord.id, ActivityDate = Date.today().addDays(-1),whatId=accountRecord.Id,
                                      ActivityDateTime=System.now()-72,DurationInMinutes=6,recordtypeid=eventRecordTypeId);
        insert eventRecord1;
        Event eventRecord2 =new Event(Subject='Send Letter 2', WT_Relationship_Group__c = accountRecord2.id, ActivityDate = Date.today().addDays(-1),whatId=accountRecord.Id,
                                      ActivityDateTime=System.now()-382,DurationInMinutes=6,recordtypeid=eventRecordTypeId1);
        insert eventRecord2;
        Task taskRecord1 = new Task(ActivityDate = Date.today() - 72,RecordTypeid = taskRecordTypeId,WhatId = accountRecord.id, WT_Relationship_Group__c = accountRecord3.id,status = 'Completed');
        insert taskRecord1;
        Task taskRecord2 = new Task(ActivityDate = Date.today() - 382,RecordTypeid = taskRecordTypeId,WhatId = accountRecord.id,WT_Relationship_Group__c = accountRecord3.id,status = 'Completed');
        insert taskRecord2;
        EmailMessage[] newEmail = new EmailMessage[0];
        newEmail.add(new EmailMessage(FromAddress = 'test@test.com',FromName = 'testuser',ToAddress = 'test@test.com',Subject = 'test',
                                      TextBody = 'test',HtmlBody = 'test',RelatedToId=listNewClassifiedAccount[0].Id));
        insert newEmail;
        list<WT_Client_Coverage__c> listClientCoverage = new list<WT_Client_Coverage__c>();
        WT_Client_Coverage__c clientCoverage = new WT_Client_Coverage__c(WT_Relationship_Classification__c='C1', WT_Coverage_Time_Period_Type__c='Annual',WT_Lines_of_Business__c='Middle Market',
                                                                         WT_All_Other_Lines_of_Business__c=false, WT_Total_Number_of_Activities_Required__c=1, WT_Include_CRA_Events__c=true,
                                                                         WT_Months__c=12, WT_Include_Tasks__c=true, WT_Include_WFG_Calls__c=true, WT_Include_CRA_Calls__c=true,WT_Include_Emails__c=true,
                                                                         WT_Include_Standard_Calls__c=true,WT_Include_Events__c=true,recordtypeid = relationshipCoverageRecordTypeId); 
        listClientCoverage.add(clientCoverage);
        WT_Client_Coverage__c clientCoverage2 = new WT_Client_Coverage__c(WT_Relationship_Classification__c='C2', WT_Coverage_Time_Period_Type__c='Period', WT_Lines_of_Business__c='Middle Market',
                                                                          WT_All_Other_Lines_of_Business__c=false, WT_Total_Number_of_Activities_Required__c=1, WT_Include_CRA_Events__c=true,
                                                                          WT_Months__c=10, WT_Include_Tasks__c=true, WT_Include_WFG_Calls__c=true, WT_Include_CRA_Calls__c=true,WT_Include_Emails__c=true,
                                                                          WT_Include_Standard_Calls__c=true,WT_Include_Events__c=true,recordtypeid = relationshipCoverageRecordTypeId); 
        listClientCoverage.add(clientCoverage2);
        WT_Client_Coverage__c clientCoverage3 = new WT_Client_Coverage__c(WT_Relationship_Classification__c='C2', WT_Coverage_Time_Period_Type__c='Period',
                                                                          WT_All_Other_Lines_of_Business__c=true, WT_Total_Number_of_Activities_Required__c=12, WT_Include_CRA_Events__c=true,
                                                                          WT_Months__c=12, WT_Include_Tasks__c=true, WT_Include_WFG_Calls__c=true, WT_Include_CRA_Calls__c=true,WT_Include_Emails__c=true,
                                                                          WT_Include_Standard_Calls__c=true,WT_Include_Events__c=true,recordtypeid = relationshipCoverageRecordTypeId); 
        listClientCoverage.add(clientCoverage3);
        WT_Client_Coverage__c clientCoverage4 = new WT_Client_Coverage__c(WT_Relationship_Classification__c='C2', WT_Coverage_Time_Period_Type__c='Annual',
                                                                          WT_All_Other_Lines_of_Business__c=true, WT_Total_Number_of_Activities_Required__c=12, WT_Include_CRA_Events__c=true,
                                                                          WT_Months__c=12, WT_Include_Tasks__c=true, WT_Include_WFG_Calls__c=true, WT_Include_CRA_Calls__c=true,WT_Include_Emails__c=true,
                                                                          WT_Include_Standard_Calls__c=true,WT_Include_Events__c=true,recordtypeid = relationshipCoverageRecordTypeId); 
        listClientCoverage.add(clientCoverage4);
        
        insert listClientCoverage;
        system.runAs(userRecord)
        {
            Database.executeBatch(new WT_BatchUpdateClientCoverageRelGrpAcc());
        }   
        System.assertEquals(4, [select count() from Account Where recordTypeId = :realationshipGroupRecordTypeId AND isdeleted = false]);    
        system.runAs(userRecord2)
        {
            Database.executeBatch(new WT_BatchUpdateClientCoverageRelGrpAcc());
        }
        test.stopTest();
    }
    /*
    @isTest
    public static void coveredPeriodTest()
    {
        id realationshipGroupRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('BusinessAccount_Customer').getRecordTypeId();
        id relationshipCoverageRecordTypeId = Schema.SObjectType.WT_Client_Coverage__c.getRecordTypeInfosByDeveloperName().get('WT_Account').getRecordTypeId();
        id taskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('WT_CRA_Call').getRecordTypeId();
        id eventRecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByDeveloperName().get('WT_CRA_Event').getRecordTypeId();
        
        test.startTest();
        User userRecord = WT_DataFactory.createUser('System Administrator'); 
        insert userRecord;
        Account accountRecord = new Account(Name = 'Test1',type = 'Customer',WT_Covered_Annual__c = 'Covered', WT_Covered_Period__c = 'Covered',RecordTypeId = realationshipGroupRecordTypeId,WT_Classification__c = 'C',WT_Census_Tract_Processed__c = true, BillingStreet='11', BillingCity='11',BillingState='some', BillingPostalCode='0011001',BillingCountry='India');
        Account accountRecord2 = new Account(Name = 'Test12',type = 'Customer',RecordTypeId = realationshipGroupRecordTypeId,WT_Classification__c = 'C1', WT_Covered_Last_Year_Report__c='Covered',WT_Covered_Last_Year__c='Covered',WT_Census_Tract_Processed__c = true, BillingStreet='11', BillingCity='11',BillingState='Some',BillingPostalCode='0011001',BillingCountry='India');
        Account accountRecord3 = new Account(Name = 'Test1',type = 'Customer',RecordTypeId = realationshipGroupRecordTypeId,WT_Classification__c = 'C4',WT_Census_Tract_Processed__c = true, BillingStreet='11', BillingCity='11',BillingState='Some',BillingPostalCode='0011001',BillingCountry='India');
        List <Account> listNewClassifiedAccount = new list<Account>();
        listNewClassifiedAccount.add(accountRecord);
        listNewClassifiedAccount.add(accountRecord2);
        listNewClassifiedAccount.add(accountRecord3);
        system.runAs(userRecord)
        {
            insert listNewClassifiedAccount;
        }
        list<WT_Client_Coverage__c> listClientCoverage = new list<WT_Client_Coverage__c>();
        WT_Client_Coverage__c clientCoverage3 = new WT_Client_Coverage__c(WT_Relationship_Classification__c='C4', WT_Coverage_Time_Period_Type__c='Annual',
                                                                          WT_All_Other_Lines_of_Business__c=true, WT_Total_Number_of_Activities_Required__c=12, WT_Include_CRA_Events__c=true,
                                                                          Months__c=12, WT_Include_Tasks__c=true, WT_Include_WFG_Calls__c=true, WT_Include_CRA_Calls__c=true,
                                                                          WT_Include_Standard_Calls__c=true,WT_Include_Events__c=true,recordtypeid = relationshipCoverageRecordTypeId); 
        listClientCoverage.add(clientCoverage3);
        WT_Client_Coverage__c clientCoverage4 = new WT_Client_Coverage__c(WT_Relationship_Classification__c='C4', WT_Coverage_Time_Period_Type__c='Period',
                                                                          WT_All_Other_Lines_of_Business__c=true, WT_Total_Number_of_Activities_Required__c=12, WT_Include_CRA_Events__c=true,
                                                                          Months__c=10, WT_Include_Tasks__c=true, WT_Include_WFG_Calls__c=true, WT_Include_CRA_Calls__c=true,
                                                                          WT_Include_Standard_Calls__c=true,WT_Include_Events__c=true,recordtypeid = relationshipCoverageRecordTypeId); 
        listClientCoverage.add(clientCoverage4);
        insert listClientCoverage;
        system.runAs(userRecord)
        {
            Database.executeBatch(new WT_BatchUpdateClientCoverageRelGrpAcc());
        }   
        System.assertEquals(3, [select count() from Account Where recordTypeId = :realationshipGroupRecordTypeId AND isdeleted = false]);    
        test.stopTest();
    }
    
    @isTest
    public static void coveredNA()
    {
        id realationshipGroupRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('BusinessAccount_Customer').getRecordTypeId();
        id relationshipCoverageRecordTypeId = Schema.SObjectType.WT_Client_Coverage__c.getRecordTypeInfosByDeveloperName().get('WT_Account').getRecordTypeId();
        test.startTest();
        User userRecord = WT_DataFactory.createUser('System Administrator'); 
        userRecord.WT_Line_of_Business__c = 'Middle Market';
        insert userRecord;
        Account accountRecord = new Account(Name = 'Test12',type = 'Customer',RecordTypeId = realationshipGroupRecordTypeId,WT_Classification__c = 'C2', BillingStreet='11', BillingCity='11',BillingState='Some',BillingPostalCode='0011001',BillingCountry='India');
        insert accountRecord;
        Account accountRecord3 = new Account(Name = 'Test1',type = 'Customer',RecordTypeId = realationshipGroupRecordTypeId,WT_Classification__c = 'C4', BillingStreet='11', BillingCity='11',BillingState='Some',BillingPostalCode='0011001',BillingCountry='India');
        insert accountRecord3;
        list<WT_Client_Coverage__c> listClientCoverage = new list<WT_Client_Coverage__c>();
        WT_Client_Coverage__c clientCoverage = new WT_Client_Coverage__c(WT_Relationship_Classification__c='C4', WT_Coverage_Time_Period_Type__c='Annual', WT_Lines_of_Business__c='Middle Market',
                                                                         WT_All_Other_Lines_of_Business__c=true, WT_Total_Number_of_Activities_Required__c=1, WT_Include_CRA_Events__c=true,
                                                                         Months__c=12, WT_Include_Tasks__c=true, WT_Include_WFG_Calls__c=true, WT_Include_CRA_Calls__c=true,WT_Include_Emails__c=true,
                                                                         WT_Include_Standard_Calls__c=true,WT_Include_Events__c=true,recordtypeid = relationshipCoverageRecordTypeId); 
        WT_Client_Coverage__c clientCoverage2 = new WT_Client_Coverage__c(WT_Relationship_Classification__c='C2', WT_Coverage_Time_Period_Type__c='Period', WT_Lines_of_Business__c='Middle Market',
                                                                         WT_All_Other_Lines_of_Business__c=true, WT_Total_Number_of_Activities_Required__c=1, WT_Include_CRA_Events__c=true,
                                                                         Months__c=12, WT_Include_Tasks__c=true, WT_Include_WFG_Calls__c=true, WT_Include_CRA_Calls__c=true,WT_Include_Emails__c=true,
                                                                         WT_Include_Standard_Calls__c=true,WT_Include_Events__c=true,recordtypeid = relationshipCoverageRecordTypeId); 
        listClientCoverage.add(clientCoverage);
        listClientCoverage.add(clientCoverage2);
        insert listClientCoverage;
        system.runAs(userRecord)
        {
           Database.executeBatch(new WT_BatchUpdateClientCoverageRelGrpAcc());
        }   
        System.assertEquals(2, [select count() from Account Where recordTypeId = :realationshipGroupRecordTypeId AND isdeleted = false]);    
        test.stopTest();
    }
    */
    @isTest
    public static void schedulerTest()
    {
        String cronexpression = '0 0 0 15 3 ? *';
        Test.startTest();
        String jobId = System.schedule('ScheduleBatchApexClass',  cronexpression, new WT_BatchUpdateClientCoverageSchedule());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(cronexpression, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();
    }
    
}