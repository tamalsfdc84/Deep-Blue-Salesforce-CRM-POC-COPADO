/**-------------------
* @Name				WT_ActivityTimeLineController_T
* @Author			Vamshi papisetty>
* @Version			v1.0
* @CreatedDate		5-24-2022
* @Description
* This is test class for after handler class for WT_ActivityTimeLineController
------------------------------------------------*/
@isTest
public class WT_ActivityTimeLineController_T
 {
     static testMethod void testMethod1() 
     {
        Id recordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('BusinessAccount_Customer').getRecordTypeId();
        Account account = new Account(Name='Test',RecordTypeId = recordId);
        insert account;
        Task taskObj = new Task();
        taskObj.Status = 'Completed';
        taskObj.Subject = 'Test';
        taskObj.WhatId = account.id;
        insert taskObj;
        test.startTest();
        WT_ActivityTimeLineController.getActivites(account.Id);
        WT_ActivityTimeLineController.getRecordTypesInfo(account.Id);
        WT_ActivityTimeLineController.getTestRecordTestTypeInfo();
        test.stopTest();
    }
     static testMethod void testMethod2()
      {
        Id recordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Prospect').getRecordTypeId();
        Account account = new Account(LastName ='test',RecordTypeId = recordId);
        insert account;   
        Task taskObj = new Task();
        taskObj.Status = 'Completed';
         taskObj.Subject = 'Test';
        taskObj.WhatId = account.id;
        insert taskObj;
        test.startTest();
        WT_ActivityTimeLineController.getActivites(account.Id);
        WT_ActivityTimeLineController.getRecordTypesInfo(account.id);
        WT_ActivityTimeLineController.getTestRecordTestTypeInfo();
        test.stopTest();
      }
     static testMethod void testMethod3()
      {
       Id prospectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Customer').getRecordTypeId();
        Account accountRecord1 = new Account();
        accountRecord1.lastname = 'Test1';
        accountRecord1.type = 'Prospect';
        accountRecord1.RecordTypeId = prospectRecordTypeId;
        insert accountRecord1;
        Opportunity testOpportunity1 = new Opportunity();
        testOpportunity1.AccountId = accountRecord1.Id;
        testOpportunity1.Name = 'Test Opportunity 1';
        testOpportunity1.StageName = 'Stage 1 - Opportunity Identified';
        testOpportunity1.CloseDate = system.today().addDays(5);
        insert testOpportunity1;
        Task taskObj = new Task();
        Id TaskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('WT_CRA_Call').getRecordTypeId();
        taskObj.Status = 'Completed';
        taskObj.Subject = 'Test';
        taskObj.WT_Outcome_Notes__c = 'Test';
        taskObj.WhatId = testOpportunity1.id;
        taskObj.recordTypeId=TaskRecordTypeId;
        insert taskObj;
        test.startTest();
        WT_ActivityTimeLineController.getActivites(testOpportunity1.Id);        
        WT_ActivityTimeLineController.getRecordTypesInfo(testOpportunity1.id);
        WT_ActivityTimeLineController.getTestRecordTestTypeInfo();
        test.stopTest();
      }    
 }