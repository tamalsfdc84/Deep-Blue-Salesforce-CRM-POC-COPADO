/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name			WT_caseBeforeHandler_T
* @Author			Sivaranjani 	<sivaranjani.d2@tcs.com.tcsdev>	
* @version 		v1.0 
* @CreatedDate		11-26-2020
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* Class is used as test class for WT_caseBeforeHandle,WT_CaseTrigger 
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* FUNCTIONAL TEST LOGIC
* 1- runtestTaskSendEmail() 
* 	> used to run test of sending emai to task owner on creation of a task  
* 
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
@isTest
public class WT_TaskSendEmailController_T 
{
    @isTest
    static void  runtestTaskSendEmail()
    {
        Profile systemAdministrator = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User user = new User(Alias = 'stdtes', Email='standarduser123@testorg.com', 
                             EmailEncodingKey='UTF-8', LastName='Test12345', LanguageLocaleKey='en_US', 
                             LocaleSidKey='en_US', ProfileId = systemAdministrator.Id, 
                             TimeZoneSidKey='America/Los_Angeles', UserName='stdtest12345@test1.com' ,
                             WT_Business_Unit_Entity__c='118-1');
        insert user ;
        Group depositApplicationGroup = new Group();
        depositApplicationGroup.name = 'Test Group';
        depositApplicationGroup.Type = 'Queue'; 
        Insert depositApplicationGroup;  
        System.runAs(new User(Id=UserInfo.getUserId()))
        {
            QueuesObject testQueue = new QueueSObject(QueueID = depositApplicationGroup.id, SObjectType = 'Case');
            insert testQueue;
        }       
        system.runAs(user)
        {
            Case caseRecord1 = new Case();
            caseRecord1.ownerId = user.Id;
            insert caseRecord1;
            Case caseRecord2 = new Case();   
            caseRecord2.OwnerId = depositApplicationGroup.Id;
            insert caseRecord2; 
            WT_CasesNewOverrideController.runCaseAssignmentRule(caseRecord2.id, 'Deposit Application'); 
            Task taskRecord1 = new Task();
            taskRecord1.WhatId = caseRecord1.Id;
            insert taskRecord1; 
            Task taskRecord2 = new Task();
            taskRecord2.WhatId = caseRecord2.Id;
            insert taskRecord2;
            GroupMember groupMember = new GroupMember();
            groupMember.UserOrGroupId = user.Id;
            groupMember.GroupId = DepositApplicationGroup.Id;
            Insert groupMember;
            Test.startTest();
            WT_TaskSendEmailController.fetchSendEmailToTaskOwner(taskRecord1.Id);
            WT_TaskSendEmailController.fetchSendEmailToTaskOwner(taskRecord2.Id);
            //system.assertEquals(WT_TaskSendEmailController.fetchSendEmailToTaskOwner(taskRecord1.Id),'Success');
            //system.assertEquals(WT_TaskSendEmailController.fetchSendEmailToTaskOwner(taskRecord2.Id),'Only owner of the request can send email to task owner');
            Test.stopTest();
        }
    }
}