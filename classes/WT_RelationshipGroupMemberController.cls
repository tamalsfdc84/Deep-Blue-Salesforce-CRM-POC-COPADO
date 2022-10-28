/**
* --------------------------------------------------------------------------------------------------------------
* @Name             WT_RelationshipGroupMemberController
* @Author           Swaminathan E   <SEzhumal@wintrust.com>
* @ModifiedBy       Swaminathan E   <SEzhumal@wintrust.com>
* @Version          v1.0
* @CreatedDate      09-03-2021
* @UsedBy           RelationshipGroup Relation Object
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is used by WT_RelationshipGroupMemberLWC and WT_RGRelatedListLWC component.
* This handles fetching, updating the RelationshipGroup Records and also fetch the related Activities.
* --------------------------------------------------------------------------------------------------------------
* @Changes
* vX.X
* MM-DD-YYYY
* --------------------------------------------------------------------------------------------------------------
**/
// Code Coverage: WT_RelationshipGroupMemberController_T
public class WT_RelationshipGroupMemberController
{
    @AuraEnabled(cacheable=true)
    public static List<WT_RelationshipGroup_Relation__c> getRelationshipRecord(Id accountId)
    {            
        return [SELECT Id, WT_Active__c, WT_StartDate__c, WT_Primary__c, WT_EndDate__c, WT_RelatedAccount__r.WT_Account_Owner__c, WT_RelatedAccount__r.RecordType.Name, WT_RelatedAccount__r.Name, WT_Account__c,WT_Roles__c, WT_RelatedAccount__c FROM WT_RelationshipGroup_Relation__c WHERE WT_Account__c = : accountId AND WT_Active__c = true ];
    }
    @AuraEnabled(cacheable=false)
    public static String updateRelationshipRecord(List<WT_RelationshipGroup_Relation__c> relationRecords )
    {
        String resultStatus = 'Member was updated.';
        for(WT_RelationshipGroup_Relation__c recordDetail : relationRecords)
        {
            recordDetail.WT_Primary__c= !(recordDetail.WT_Primary__c);
        }
        try 
        {
            update relationRecords;
        }
        catch (Exception e)
        {
            resultStatus = e.getMessage().split('first error:')[1].split(',')[0];
            return resultStatus;
        }   
        return resultStatus;
    }
    @AuraEnabled (cacheable=true)
    public static List<sObject> getRelationshipActivityRecord( String recordId, String sObjectName, String parentField) 
    {
        List<sObject> listSObjects = new List<sObject>();
        List<sObject> listActivity = new List<sObject>();
        List<String> objectName = sObjectName.split(',');
        //SGE-186 Added ActivityDate and Owner ID to the SOQL
        recordId = String.escapeSingleQuotes(recordId);
        sObjectName = String.escapeSingleQuotes(sObjectName);
        parentField = String.escapeSingleQuotes(parentField);
        String strSOQL = 'SELECT Id, Subject, WhatId, What.Name, WhoId, Who.Name, RecordType.Name, ActivityDate, OwnerId, Owner.Name  FROM ' + objectName[0] + ' WHERE ' + parentField + ' = \''+ recordId + '\' ';
        listSObjects =  Database.query( strSOQL );
        if(objectName.contains('Task'))
        {
            Set<Id> setTaskId = new Set<Id>();
            for(sObject taskRecord : listSObjects )
            {
                setTaskId.add(taskRecord.Id);
            }
            List<ActionPlanItem> listActionTask = [SELECT Id, ItemId FROM ActionPlanItem WHERE ItemId = :setTaskId];
            setTaskId.clear();
            for(ActionPlanItem itemId : listActionTask )
            {
                setTaskId.add(itemId.ItemId);
            }
            for(sObject taskRecord : listSObjects )
            {
                if(!setTaskId.contains(taskRecord.Id))
                {
                    listActivity.add(taskRecord);
                }
            }
        }
        strSOQL = 'SELECT Id, Subject, WhatId, What.Name, WhoId, Who.Name, RecordType.Name, ActivityDate, OwnerId, Owner.Name FROM ' + objectName[1] + ' WHERE ' + parentField + ' = \''+ recordId + '\' ';
        listSObjects =  Database.query( strSOQL );
        listActivity.addAll(listSObjects);
        return listActivity;
    }
}