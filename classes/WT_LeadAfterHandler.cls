/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_LeadAfterHandler
* @Author			Swaminathan E	<SEzhumal@wintrust.com>
* @ModifiedBy		Swaminathan E	<SEzhumal@wintrust.com>
* @Version			v1.0
* @CreatedDate		29-03-2021
* @UsedBy			Lead Object
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is handler class for lead trigger.
* This handles all the before logic of the account trigger.
* --------------------------------------------------------------------------------------------------------------
* @Changes
* vX.X
* MM-DD-YYYY
* --------------------------------------------------------------------------------------------------------------
**/
// Code Coverage: WT_LeadAfterHandler_T
public class WT_LeadAfterHandler extends TriggerHandler
{
    List<Lead> listNewLead = new List<Lead>();
    Map<Id, Lead> mapNewLeadIdandLead = new Map<Id, Lead>();
    Map<Id, Lead> mapOldLeadIdandLead = new Map<Id, Lead>();
    public WT_LeadAfterHandler()
    {              
        PopulateGlobalLists();        
    }    
    public override void afterInsert()
    {
        ProvideRefferedToUserAccess(listNewLead);
    }    
    public override void afterUpdate()
    {
        ProvideRefferedToUserAccessUpdate(listNewLead, mapOldLeadIdandLead);
    }  
    private void PopulateGlobalLists()
    {        
        listNewLead = (List<Lead>) Trigger.new;
        mapNewLeadIdandLead = (Map<Id, Lead>) Trigger.newMap;
        mapOldLeadIdandLead = (Map<Id, Lead>) Trigger.oldMap;
    }
    /**
*-----------------------------------------------------------------------------------------------------------------------------
* @description
*This method used to provide edit access to the referredby and the referredto of the lead record.
*-----------------------------------------------------------------------------------------------------------------------------
* @param    listNewLead   This contains list of Lead Records from AfterInsert Trigger
*-----------------------------------------------------------------------------------------------------------------------------
**/
    private void ProvideRefferedToUserAccess(List<Lead> listNewLead)
    {
        List<leadShare>  leadShareList = new List<leadShare>();
        for(Lead leadRecord: listNewLead)
        {
            if(leadRecord.OwnerId != leadRecord.WT_Referred_To__c)
            {
                leadShare leadRecordShareTo  = new leadShare();
                leadRecordShareTo.leadId = leadRecord.id;
                leadRecordShareTo.UserOrGroupId = leadRecord.WT_Referred_To__c;
                leadRecordShareTo.leadAccessLevel = 'Edit';
                leadRecordShareTo.RowCause = Schema.leadShare.RowCause.Manual;
                leadShareList.add(leadRecordShareTo); 
            }
            if(leadRecord.OwnerId != leadRecord.FinServ__ReferredByUser__c)
            {
                leadShare leadRecordShareBy  = new leadShare();
                leadRecordShareBy.leadId = leadRecord.id;
                leadRecordShareBy.UserOrGroupId = leadRecord.FinServ__ReferredByUser__c;
                leadRecordShareBy.leadAccessLevel = 'Edit';
                leadRecordShareBy.RowCause = Schema.leadShare.RowCause.Manual;            
                leadShareList.add(leadRecordShareBy);
            }
        }
        Database.SaveResult[] shareRecords = Database.insert(leadShareList,false);
        Integer i=0;
        for(Database.SaveResult shareRecord : shareRecords)
        {
            if(!shareRecord.isSuccess())
            {
                Database.Error error = shareRecord.getErrors()[0];
                if(!(error.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION && error.getMessage().contains('AccessLevel')))
                {                   
                    trigger.newMap.get(leadShareList[i].leadId).addError('Unable to grant sharing access due to following exception: '+ error.getMessage());
                }
            }
            i++;
        }
    }
    /**
*-----------------------------------------------------------------------------------------------------------------------------
* @description
*This method used to provide edit access to the referredby and the referredto of the lead record.
*-----------------------------------------------------------------------------------------------------------------------------
* @param    listNewLead   This contains list of Lead Records from AfterInsert Trigger
*			mapOldLeadIdandLead   This contains map of old Lead Records from AfterInsert Trigger
*-----------------------------------------------------------------------------------------------------------------------------
**/
    private void ProvideRefferedToUserAccessUpdate(List<Lead> listNewLead, Map<Id, Lead> mapOldLeadIdandLead)
    {
        List<leadShare>  leadShareList = new List<leadShare>();
        List<leadShare>  removeLeadShareList = new List<leadShare>();
        Set<Id> setLeadId = new Set<Id>();
        Map<Id,Id> setReferredBy = new Map<Id,Id>(); 
        Map<Id,Id> setReferredTo = new Map<Id,Id>();
        for(Lead leadRecord: listNewLead)
        {    
            setLeadId.add(leadRecord.Id);
            if(mapOldLeadIdandLead.get(leadRecord.Id).WT_Referred_To__c != leadRecord.WT_Referred_To__c)
            {
                if(leadRecord.OwnerId != leadRecord.WT_Referred_To__c)
                {
                    leadShare leadRecordShareTo  = new leadShare();
                    leadRecordShareTo.leadId = leadRecord.id;
                    leadRecordShareTo.UserOrGroupId = leadRecord.WT_Referred_To__c;
                    leadRecordShareTo.leadAccessLevel = 'Edit';
                    leadRecordShareTo.RowCause = Schema.leadShare.RowCause.Manual;
                    leadShareList.add(leadRecordShareTo); 
                }
                if(mapOldLeadIdandLead.get(leadRecord.Id).WT_Referred_To__c != leadRecord.FinServ__ReferredByUser__c )
                {
                    setReferredBy.put(mapOldLeadIdandLead.get(leadRecord.Id).WT_Referred_To__c,leadRecord.id);
                }
                
            }          	
            if(mapOldLeadIdandLead.get(leadRecord.Id).FinServ__ReferredByUser__c != leadRecord.FinServ__ReferredByUser__c)
            {
                if(leadRecord.OwnerId != leadRecord.FinServ__ReferredByUser__c)
                {
                    leadShare leadRecordShareBy  = new leadShare();
                    leadRecordShareBy.leadId = leadRecord.id;
                    leadRecordShareBy.UserOrGroupId = leadRecord.FinServ__ReferredByUser__c;
                    leadRecordShareBy.leadAccessLevel = 'Edit';
                    leadRecordShareBy.RowCause = Schema.leadShare.RowCause.Manual;
                    leadShareList.add(leadRecordShareBy);
                }
                if(mapOldLeadIdandLead.get(leadRecord.Id).FinServ__ReferredByUser__c != leadRecord.WT_Referred_To__c )
                {
                    setReferredTo.put(mapOldLeadIdandLead.get(leadRecord.Id).FinServ__ReferredByUser__c,leadRecord.id);
                }                
            }
        }   
        List<leadShare>  queryLeadShareList = [SELECT Id, leadId, UserorGroupID from LeadShare where leadId IN: setLeadId AND RowCause = 'Manual'];       
        Database.SaveResult[] shareRecords = Database.insert(leadShareList,false);
        Integer i=0;
        for(Database.SaveResult shareRecord : shareRecords)
        {
            if(!shareRecord.isSuccess())
            {
                Database.Error error = shareRecord.getErrors()[0];
                if(!(error.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION && error.getMessage().contains('AccessLevel')))
                {                   
                    trigger.newMap.get(leadShareList[i].leadId).addError('Unable to grant sharing access due to following exception: '+ error.getMessage());
                }
            }          
            i++;
        }
        for(leadShare leadShare : queryLeadShareList)
        {
            if(setReferredBy.get(leadShare.UserorGroupID) == leadShare.leadId && !removeLeadShareList.contains(leadShare))
            {
                removeLeadShareList.add(leadShare);
            }
            if(setReferredTo.get(leadShare.UserorGroupID) == leadShare.leadId && !removeLeadShareList.contains(leadShare))
            {
                removeLeadShareList.add(leadShare);
            }
        }
        delete removeLeadShareList;
    }
}