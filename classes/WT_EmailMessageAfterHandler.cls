/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_EmailMessageAfterTrigger
* @Author			Anoop B	<ABattini@wintrust.com>
* @ModifiedBy		Anoop B	<ABattini@wintrust.com>
* @Version			v1.1
* @CreatedDate		25-05-2021
* @UsedBy			EmailMessage Object
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is handler class for EmailMessage trigger.
* This handles all the after logic of the EmailMessage trigger.
* Used to update Task ownerId on the Email message object
* --------------------------------------------------------------------------------------------------------------
* @Changes
* Vasavi Kolusu
* 09-16-2022
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
        createAttachments(listNewEmailMessages, mapOldEmailMessageIdandEmailMessage);
    }
    private void PopulateGlobalLists()
    {        
        listNewEmailMessages = (List<EmailMessage>) Trigger.new;
        mapNewEmailMessageIdandEmailMessage = (Map<Id, EmailMessage>) Trigger.newMap;
        mapOldEmailMessageIdandEmailMessage = (Map<Id, EmailMessage>) Trigger.oldMap;
    }
    public static void createAttachments(List<EmailMessage> listNewEmailMessages, Map<Id, EmailMessage> mapOldEmailMessageIdandEmailMessage)
    {
        Set<Id> setEmailMessageIds=new Set<Id>();
        Map<Id,Id> mapEmailIdAndCaseId = new Map<Id,Id>();
        for(EmailMessage emailRecord:listNewEmailMessages)
        {
            if(emailRecord.Subject == String.valueOf(emailRecord.ParentId))
            {
                setEmailMessageIds.add(emailRecord.Id);
                mapEmailIdAndCaseId.put(emailRecord.Id, emailRecord.TextBody);
            }
        } 
        
        if(!setEmailMessageIds.isEmpty())
        {   	
            deleteAttachmentAndEmailMessageRecords(setEmailMessageIds, mapEmailIdAndCaseId);
        }        
    }
    @future
    public static void deleteAttachmentAndEmailMessageRecords(Set<Id> setEmailMessageIds, Map<Id,Id> mapEmailIdAndCaseId)
    {
        if(setEmailMessageIds.size() > 0)
        {
            List<Attachment> listAttachmentsToInsert = new List<Attachment>();
            List<Attachment> listAttachmentsToDelete = new List<Attachment>();
            Attachment attachmentObject;
            
            for(Attachment attachment: [SELECT SystemModstamp, ParentId, OwnerId, Name, 
                                        LastModifiedDate, LastModifiedById, IsPrivate, IsDeleted, 
                                        Id, Description, CreatedDate, CreatedById, 
                                        ContentType, BodyLength, Body 
                                        FROM Attachment 
                                        WHERE parentId IN :setEmailMessageIds]) 
            {
                if(mapEmailIdAndCaseId.containsKey(attachment.ParentId))
                {
                    attachmentObject = attachment.clone(false,false);
                    attachmentObject.ParentId = mapEmailIdAndCaseId.get(attachment.ParentId);
                    listAttachmentstoInsert.add(attachmentObject); 
                    listAttachmentsToDelete.add(attachment);
                }              
            }
            
            if(listAttachmentstoInsert.size() > 0)
            {
                insert listAttachmentsToInsert;
            }
            
            if(listAttachmentsToDelete.size() > 0)
            {
                delete listAttachmentsToDelete;
            }
            
            List<EmailMessage> listEmailMessage = new List<EmailMessage>();
            for(Id currentId : setEmailMessageIds)
            {
                EmailMessage emailMessageRecord = new EmailMessage(Id = currentId);  
                listEmailMessage.add(emailMessageRecord);
            }
            
            if(listEmailMessage.size() > 0)
            {  
                delete listEmailMessage;
            }
        }
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
        
        List<EmailMessage> EmailMessageList=new List<EmailMessage>();
        List<Task> TaskList=new List<Task>();
        if(!System.isFuture() && !System.isBatch())
        {
            EmailMessageList=[Select Id, Subject,RelatedToId,ActivityId from EmailMessage Where ActivityId =:TaskIdsList];
            TaskList=[Select Id, Subject,WhatId,OwnerId from Task Where Id =:TaskIdsList];
        }
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