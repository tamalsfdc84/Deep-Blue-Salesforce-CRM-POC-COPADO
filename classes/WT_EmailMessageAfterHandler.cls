/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_EmailMessageAfterTrigger
* @Author			Anoop B	<ABattini@wintrust.com>
* @ModifiedBy		Anoop B	<ABattini@wintrust.com>
* @Version			v1.0
* @CreatedDate		25-05-2021
* @UsedBy			EmailMessage Object
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is handler class for EmailMessage trigger.
* This handles all the after logic of the EmailMessage trigger.
* Used to update Task ownerId on the Email message object
* --------------------------------------------------------------------------------------------------------------
* @Changes
* vX.X
* MM-DD-YYYY
* --------------------------------------------------------------------------------------------------------------
**/
public class WT_EmailMessageAfterHandler extends TriggerHandler
{
    List<EmailMessage> listNewEmailMessages = new List<EmailMessage>();
    Map<Id, EmailMessage> mapNewEmailMessageIdandEmailMessage = new Map<Id, EmailMessage>();
    Map<Id, EmailMessage> mapOldEmailMessageIdandEmailMessage = new Map<Id, EmailMessage>();
    public WT_EmailMessageAfterHandler()
    {
        PopulateGlobalLists();        
    }
    public override void afterInsert()
    {
        updateEmailMessageWithOwner(listNewEmailMessages);
    }
    public override void afterUpdate()
    {
    }
    private void PopulateGlobalLists()
    {        
        listNewEmailMessages = (List<EmailMessage>) Trigger.new;
        mapNewEmailMessageIdandEmailMessage = (Map<Id, EmailMessage>) Trigger.newMap;
        mapOldEmailMessageIdandEmailMessage = (Map<Id, EmailMessage>) Trigger.oldMap;
    }
    public static void updateEmailMessageWithOwner(List<EmailMessage> listNewEmailMessages)
    {
        List<Id> TaskIdsList=new List<Id>();
        Map<String,Id> EmailOwnerSubjectmap=new Map<String,Id>();
        Map<String,Id> TaskOwnerSubjectmap=new Map<String,Id>(); 
        for(EmailMessage EmailRecord:listNewEmailMessages)
        {
            if(EmailRecord.ActivityId!=null)
            {
                TaskIdsList.add(EmailRecord.ActivityId);
                EmailOwnerSubjectmap.put(EmailRecord.Subject,EmailRecord.CreatedById);   
            }
            
        } 
        List<EmailMessage> EmailMessageList=[Select Id, Subject,RelatedToId,ActivityId from EmailMessage Where ActivityId =:TaskIdsList];
        List<Task> TaskList=[Select Id, Subject,WhatId,OwnerId from Task Where Id =:TaskIdsList];
        List<EmailMessage> updateEmails=new List<EmailMessage>();
        for(Task TaskRec:TaskList)
        {
            String newSubject=TaskRec.Subject.remove('Email: ');
            TaskOwnerSubjectmap.put(newSubject,TaskRec.OwnerId);  
        }
        for(EmailMessage EmailRec:EmailMessageList)
        {
            Id OwnerId=TaskOwnerSubjectmap.get(EmailRec.Subject);
            EmailRec.WT_Assigned_To__c=OwnerId;
            updateEmails.add(EmailRec);
        }
        
        if(updateEmails!=null && updateEmails.size()>0)
        {
            update updateEmails;
        }
        
    }    
}