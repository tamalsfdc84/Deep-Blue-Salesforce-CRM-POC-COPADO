/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name				WT_CaseAfterHandler
* @Author			Sivaranjani 	<sivaranjani.d2@tcs.com.tcsdev>	
* @ModifiedBy		Sivaranjani 	<sivaranjani.d2@tcs.com.tcsdev>
* @version 			v1.0 
* @CreatedDate		01-02-2020
* @UsedBy			trigger:  WT_CaseTrigger
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* this is used by trigger WT_CaseTrigger
* used to provide view access to the requestor and the creator of the case
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Changes
* vx.x				<user id>
* MM-DD-YYYY		<Explanation> 
* Anitha Jaini		Added as part of SGE-9 -Update the fileowner to case owner when case owner is changed	
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
// Test class: WT_CaseBeforeHandler_T
public class WT_CaseAfterHandler extends TriggerHandler
{
    private static Set<Id> setCaseIdNotificationEmailSent = new Set<Id>();
    private List<Case> listNewCase = new List<Case>();
    private Map<Id, Case> mapNewCaseIdandCase = new Map<Id, Case>();
    private Map<Id, Case> mapOldCaseIdandCase = new Map<Id, Case>();
    //SGE-9 Added to avoid recursion boolean value
    private static boolean isOwnerChanged = False;
    public WT_caseAfterHandler()
    {
        this.listNewCase = (List<case>) Trigger.new;
        this.mapNewCaseIdandCase = (Map<Id, Case>) Trigger.newMap; 
        this.mapOldCaseIdandCase = (Map<Id, Case>) Trigger.oldMap; 
    }
    public override void afterInsert()
    {    
        CreateRecordShares(true);
        NotifyCaseOwner(false);
    }
    public override void afterUpdate()
    {
        CreateRecordShares(false);
        NotifyCaseOwner(true);
        
        //added for SGE-9
        if (isOwnerChanged == False || Test.isRunningTest())
        {
            updateFilesOwner(mapOldCaseIdandCase,mapNewCaseIdandCase);
            isOwnerChanged = True;
        }
    }
    
    private void CreateRecordShares(Boolean isEditAccess)
    {
        List<caseShare>  caseShareList = new List<caseShare>();
        for(Case caseRecord: listNewCase)
        {
            caseShare caseRecordShare  = new caseShare();
            caseRecordShare.caseId = caseRecord.id;
            caseRecordShare.UserOrGroupId = caseRecord.CreatedById;
            caseRecordShare.caseAccessLevel = (isEditAccess) ? 'Edit' : 'Read';
            caseRecordShare.RowCause = Schema.caseShare.RowCause.Manual;
            caseShareList.add(caseRecordShare);
        }
        Database.SaveResult[] shareRecords = Database.insert(caseShareList,false);
        for (Database.SaveResult shareRecord : shareRecords) 
        {
            if (shareRecord.isSuccess() == false) 
            {
                for(Database.Error errorReturned : shareRecord.getErrors()) 
                {
                    System.debug(errorReturned.getStatusCode() + ': ' + errorReturned.getMessage());
                }
            }
        } 
    }
    
    private void NotifyCaseOwner(Boolean isUpdate)
    {
        List<Case> listCaseToNotifyOwner = new List<Case>();
        Id myHRRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MyHR').getRecordTypeId(); 
        
        for(Case caseRecord : listNewCase)
        {
            Case oldCase = null;
            if(isUpdate)
            {
                oldCase = mapOldCaseIdandCase.get(caseRecord.Id);
            }
            
            if((!isUpdate || (isUpdate && caseRecord.WT_HRCaseOwner__c != null && oldCase.WT_HRCaseOwner__c != caseRecord.WT_HRCaseOwner__c)) && 
                caseRecord.WT_HRCaseOwner__c != null && !setCaseIdNotificationEmailSent.contains(caseRecord.Id))
            {         
                if(UserInfo.getUserId() != caseRecord.WT_HRCaseOwner__c)
                {       
                    listCaseToNotifyOwner.add(caseRecord);
                    setCaseIdNotificationEmailSent.add(caseRecord.Id);
                }
            }
        }
        if(!listCaseToNotifyOwner.isEmpty())
        {               
            List<Messaging.SingleEmailMessage> listEmailMessage = new List<Messaging.SingleEmailMessage>();
            EmailTemplate notificationTemplate = [SELECT Id, Subject,Body FROM EmailTemplate WHERE DeveloperName = 'WT_Case_Reassignment' LIMIT 1];
            for(Case caseRecord : listCaseToNotifyOwner)
            {
                Messaging.SingleEmailMessage mail = Messaging.renderStoredEmailTemplate(notificationTemplate.id, caseRecord.WT_HRCaseOwner__c, caseRecord.id);
                mail.setTargetObjectId(caseRecord.WT_HRCaseOwner__c);
                mail.setSaveAsActivity(false);
                listEmailMessage.add(mail);
            }
            if(!listEmailMessage.isEmpty() && !Test.isRunningTest())
            {
                try
                {
                    Messaging.sendEmail(listEmailMessage);
                }
                catch(Exception ex)
                {

                }
            }
        }
    }
    
    //added for SGE-9
    private void updateFilesOwner(Map<Id, Case> oldMap, Map<Id, Case> newMap) 
    {        
        Map<Id,Case> changedMap = new Map<Id,Case>();
        for(Case cs : newMap.values()) 
        {
            if(cs.OwnerId != oldMap.get(cs.Id).OwnerId) 
            {
                changedMap.put(cs.Id,cs);
            }
        }
        
        if (changedMap.size()>0)
        {
            List<ContentDocumentLink> contDocLinkList = [Select Id, ContentDocumentId, LinkedEntityId 
                                                         FROM ContentDocumentLink Where LinkedEntityId IN: changedMap.keySet()];
            Set<Id> contDocIds = new Set<Id>();
            for(ContentDocumentLink cdl : contDocLinkList) 
            {
                contDocIds.add(cdl.ContentDocumentId);
            }
            List<ContentVersion> contVersionList = [Select Id,FirstPublishLocationId, OwnerId FROM ContentVersion WHERE ContentDocumentId IN: contDocIds];
            
            for(ContentVersion cv : contVersionList) 
            {                
                if(changedMap.containskey(cv.FirstPublishLocationId) && cv.OwnerId != changedMap.get(cv.FirstPublishLocationId).OwnerId)
                {
                    cv.OwnerId = changedMap.get(cv.FirstPublishLocationId).OwnerId;
                }
            }
            
            if(contVersionList.size() > 0)
            {
                update contVersionList; 
            }
        }
    } 
}