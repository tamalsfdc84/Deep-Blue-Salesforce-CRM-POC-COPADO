/**
* ----------------------------------------------------------------------------------------------------------------
* @Name             WT_RelationshipGroupRelationHandler
* @Author           Swaminathan E   <SEzhumal@wintrust.com>
* @Version          v1.0
* @CreatedDate      29-07-2021
* @UsedBy           WT_RelationshipGroup_Relation__c Object
* -----------------------------------------------------------------------------------------------------------------
* @Description
* This is handler class for WT_RelationshipGroup_Relation__c trigger.
*
* This handles all the Rollup child records logic of the WT_RelationshipGroup_Relation__c trigger.
* ------------------------------------------------------------------------------------------------------------------
**/
public class WT_RelationshipGroupRelationHandler extends TriggerHandler 
{
    private List<WT_RelationshipGroup_Relation__c> listNewAccountAccount = new List<WT_RelationshipGroup_Relation__c>();
    private List<WT_RelationshipGroup_Relation__c> listOldAccountAccount = new List<WT_RelationshipGroup_Relation__c>();
    //constructor     
    public WT_RelationshipGroupRelationHandler()
    {
        if(trigger.isUpdate)
        {
            this.listNewAccountAccount = (List<WT_RelationshipGroup_Relation__c>) Trigger.new;
        }
        if(trigger.isInsert)
        {
            this.listNewAccountAccount = (List<WT_RelationshipGroup_Relation__c>) Trigger.new;            
        }
        if(trigger.isDelete)
        {
            this.listOldAccountAccount = (List<WT_RelationshipGroup_Relation__c>) Trigger.old;
        }
    }
    public override void afterInsert()
    { 
        calculateRollupRecords(listNewAccountAccount);
    }
    public override void afterUpdate()
    {    
        reCalculateRollupRecords(listNewAccountAccount);
    }
    public override void afterDelete()
    {  
        removeRollupRecords(listOldAccountAccount);
    } 
/**
*-------------------------------------------------------------------------------------------------------------- 
* @Description
* This method is used to calculate Rollup of child records
* --------------------------------------------------------------------------------------------------------------
* @Param  listOldAccountAccount    Map of old Account
* @Return void                         none
*--------------------------------------------------------------------------------------------------------------
**/
    public void removeRollupRecords(List<WT_RelationshipGroup_Relation__c> listOldAccountAccount)
    {
        List<SObject> listOfSObject = new List<SObject>();
        Set<Id> setAccountId = new Set<Id>();
        for(WT_RelationshipGroup_Relation__c acountAccountRecord: listOldAccountAccount)
        {
            setAccountId.add(acountAccountRecord.WT_RelatedAccount__c);
        }
        if(!setAccountId.isEmpty())
        {
            List<Opportunity> listOpportunity = [SELECT Id, WT_Relationship_Group__c, AccountId FROM Opportunity WHERE AccountId IN :setAccountId ];
            for(Opportunity opportunityRecord :listOpportunity)
            {
                opportunityRecord.WT_Relationship_Group__c = Null;
            }
            List<FinServ__FinancialAccount__c> listFinancialAccount = [SELECT Id, WT_Relationship_Group__c, FinServ__PrimaryOwner__c FROM FinServ__FinancialAccount__c WHERE FinServ__PrimaryOwner__c IN :setAccountId ];
            for(FinServ__FinancialAccount__c financialRecord: listFinancialAccount)
            {  
                financialRecord.WT_Relationship_Group__c = Null;
            }
            List<Lead> listReferral = [SELECT Id, FinServ__RelatedAccount__c FROM Lead WHERE FinServ__RelatedAccount__c IN :setAccountId ];
            for(Lead leadRecord: listReferral)
            {
                leadRecord.WT_Relationship_Group__c = Null;
            }
            List<Event> listEvent = [SELECT Id, WT_Relationship_Group__c, WhatId FROM Event WHERE WhatId IN :setAccountId ];
            for(Event eventRecord: listEvent)
            {
                eventRecord.WT_Relationship_Group__c = Null;
            }
            List<Task> listTask = [SELECT Id, WT_Relationship_Group__c, WhatId FROM Task WHERE WhatId IN :setAccountId ];
            for(Task taskRecord: listTask)
            {
                 taskRecord.WT_Relationship_Group__c = Null;
            }
            List<ActionPlan> listActionPlan = [SELECT Id, TargetId, WT_Relationship_Group__c FROM ActionPlan WHERE TargetId IN :setAccountId];
            for(ActionPlan actionPlanRecord: listActionPlan)
            {
                if(actionPlanRecord.TargetId.getsObjectType() == Account.sObjectType)
                {
                    actionPlanRecord.WT_Relationship_Group__c = Null;
                }
            }
            listOfSObject.addAll(listOpportunity);
            listOfSObject.addAll(listFinancialAccount);
            listOfSObject.addAll(listReferral);
            listOfSObject.addAll(listEvent);
            listOfSObject.addAll(listTask);
            listOfSObject.addAll(listActionPlan);
            List<Database.SaveResult> listUpdateResult = Database.update(listOfSObject, false);
            for (Database.SaveResult result : listUpdateResult) 
            {
                if (!result.isSuccess())
                {
                    for (Database.Error error : result.getErrors())
                    {
                        System.debug('Record Id: '+result.getId()+'Error: '+ error.getMessage());
                    }
                }    
            }
        }
    }
/**
* --------------------------------------------------------------------------------------------------------------
* @Description
* This method is used to calculate Rollup of child records
* --------------------------------------------------------------------------------------------------------------
* @Param  listNewAccountAccount    Map of new Account
* @Return void                         none
*--------------------------------------------------------------------------------------------------------------
**/
    public void calculateRollupRecords(List<WT_RelationshipGroup_Relation__c> listNewAccountAccount)
    {
        List<SObject> listOfSObject = new List<SObject>();
        Map<Id,Id> mapAccountId = new Map<Id,Id>();
        for(WT_RelationshipGroup_Relation__c acountAccountRecord: listNewAccountAccount)
        {
            if(acountAccountRecord.WT_Active__c)
            {
                mapAccountId.put(acountAccountRecord.WT_RelatedAccount__c,acountAccountRecord.WT_Account__c);
            }
        }
        if(!mapAccountId.isEmpty())
        {
            List<Opportunity> listOpportunity = [SELECT Id, WT_Relationship_Group__c, AccountId FROM Opportunity WHERE AccountId IN :mapAccountId.keySet() ];
            for(Opportunity opportunityRecord :listOpportunity)
            {
                opportunityRecord.WT_Relationship_Group__c = mapAccountId.get(opportunityRecord.AccountId);
            }
            List<FinServ__FinancialAccount__c> listFinancialAccount = [SELECT Id, WT_Relationship_Group__c, FinServ__PrimaryOwner__c FROM FinServ__FinancialAccount__c WHERE FinServ__PrimaryOwner__c IN :mapAccountId.keySet() ];
            for(FinServ__FinancialAccount__c financialRecord: listFinancialAccount)
            {  
                financialRecord.WT_Relationship_Group__c = mapAccountId.get(financialRecord.FinServ__PrimaryOwner__c);
            }
            List<Lead> listReferral = [SELECT Id , FinServ__RelatedAccount__c FROM Lead WHERE FinServ__RelatedAccount__c IN :mapAccountId.keySet() ];
            for(Lead leadRecord: listReferral)
            {
                leadRecord.WT_Relationship_Group__c = mapAccountId.get(leadRecord.FinServ__RelatedAccount__c);
            }
            List<Event> listEvent = [SELECT Id, WT_Relationship_Group__c, WhatId FROM Event WHERE WhatId IN :mapAccountId.keySet() ];
            for(Event eventRecord: listEvent)
            {
                  eventRecord.WT_Relationship_Group__c = mapAccountId.get(eventRecord.WhatId);
            }
            List<Task> listTask = [SELECT Id, WT_Relationship_Group__c, WhatId FROM Task WHERE WhatId IN :mapAccountId.keySet() ];
            for(Task taskRecord: listTask)
            {
                  taskRecord.WT_Relationship_Group__c = mapAccountId.get(taskRecord.WhatId);
            }
            List<ActionPlan> listActionPlan = [SELECT Id, TargetId, WT_Relationship_Group__c FROM ActionPlan WHERE TargetId IN :mapAccountId.keySet()];
            for(ActionPlan actionPlanRecord: listActionPlan)
            {
                if(actionPlanRecord.TargetId.getsObjectType() == Account.sObjectType)
                {
                    actionPlanRecord.WT_Relationship_Group__c = mapAccountId.get(actionPlanRecord.TargetId);
                }
            }
            listOfSObject.addAll(listOpportunity);
            listOfSObject.addAll(listFinancialAccount);
            listOfSObject.addAll(listReferral);
            listOfSObject.addAll(listEvent);
            listOfSObject.addAll(listTask);
            listOfSObject.addAll(listActionPlan);
            List<Database.SaveResult> listUpdateResult = Database.update(listOfSObject, false);
            for (Database.SaveResult result : listUpdateResult) 
            {
                if (!result.isSuccess())
                {
                    for (Database.Error error : result.getErrors())
                    {
                        System.debug('Record Id: '+result.getId()+'Error: '+ error.getMessage());
                    }
                }
            }
        }
    }
    /**
*-------------------------------------------------------------------------------------------------------------- 
* @Description
* This method is used to recalculate Rollup of child records
* --------------------------------------------------------------------------------------------------------------
* @Param  listNewAccountAccount    Map of new Account
* @Return void                         none
*--------------------------------------------------------------------------------------------------------------
**/
    public void reCalculateRollupRecords(List<WT_RelationshipGroup_Relation__c> listNewAccountAccount)
    {
        List<SObject> listOfSObject = new List<SObject>();
        Set<Id> setActiveRelatedId = new Set<Id>();
        Map<Id,Id> mapAccountId = new Map<Id,Id>();
        for(WT_RelationshipGroup_Relation__c acountAccountRecord: listNewAccountAccount)
        {
            if(acountAccountRecord.WT_Active__c)
            {
                setActiveRelatedId.add(acountAccountRecord.WT_RelatedAccount__c);
            }
            mapAccountId.put(acountAccountRecord.WT_RelatedAccount__c,acountAccountRecord.WT_Account__c);  
        }
        if(!mapAccountId.isEmpty())
        {
            List<Opportunity> listOpportunity = [SELECT Id, WT_Relationship_Group__c, AccountId FROM Opportunity WHERE AccountId IN :mapAccountId.keySet() ];
            for(Opportunity opportunityRecord :listOpportunity)
            {
                if(setActiveRelatedId.contains(opportunityRecord.AccountId))
                {
                    opportunityRecord.WT_Relationship_Group__c = mapAccountId.get(opportunityRecord.AccountId);
                }
                else
                {
                    opportunityRecord.WT_Relationship_Group__c = Null; 
                }
            }
            List<FinServ__FinancialAccount__c> listFinancialAccount = [SELECT Id, WT_Relationship_Group__c, FinServ__PrimaryOwner__c FROM FinServ__FinancialAccount__c WHERE FinServ__PrimaryOwner__c IN :mapAccountId.keySet() ];
            for(FinServ__FinancialAccount__c financialRecord: listFinancialAccount)
            {  
                if(setActiveRelatedId.contains(financialRecord.FinServ__PrimaryOwner__c))
                {
                    financialRecord.WT_Relationship_Group__c = mapAccountId.get(financialRecord.FinServ__PrimaryOwner__c);
                }
                else
                {
                    financialRecord.WT_Relationship_Group__c = Null; 
                }
            }
            List<Lead> listReferral = [SELECT Id, FinServ__RelatedAccount__c FROM Lead WHERE FinServ__RelatedAccount__c IN :mapAccountId.keySet()  ];
            for(Lead leadRecord: listReferral)
            {
                if(setActiveRelatedId.contains(leadRecord.FinServ__RelatedAccount__c))
                {
                    leadRecord.WT_Relationship_Group__c = mapAccountId.get(leadRecord.FinServ__RelatedAccount__c);
                }
                else
                {
                    leadRecord.WT_Relationship_Group__c = Null; 
                }
            }
            List<Event> listEvent = [SELECT Id, WT_Relationship_Group__c, WhatId FROM Event WHERE WhatId IN :mapAccountId.keySet()  ];
            for(Event eventRecord: listEvent)
            {
                if(setActiveRelatedId.contains(eventRecord.WhatId))
                {
                    eventRecord.WT_Relationship_Group__c = mapAccountId.get(eventRecord.WhatId);
                }
                else
                {
                    eventRecord.WT_Relationship_Group__c = Null;
                }   
            }
            List<Task> listTask = [SELECT Id, WT_Relationship_Group__c, WhatId FROM Task WHERE WhatId IN :mapAccountId.keySet()  ];
            for(Task taskRecord: listTask)
            {
                if(setActiveRelatedId.contains(taskRecord.WhatId))
                {
                    taskRecord.WT_Relationship_Group__c = mapAccountId.get(taskRecord.WhatId);
                }
                else
                {
                    taskRecord.WT_Relationship_Group__c = Null; 
                }     
            }
            List<ActionPlan> listActionPlan = [SELECT Id, TargetId, WT_Relationship_Group__c FROM ActionPlan WHERE TargetId IN :mapAccountId.keySet()];
            for(ActionPlan actionPlanRecord: listActionPlan)
            {
                if(actionPlanRecord.TargetId != null && actionPlanRecord.TargetId.getsObjectType() == Account.sObjectType)
                {
                    if(setActiveRelatedId.contains(actionPlanRecord.TargetId))
                    {
                        actionPlanRecord.WT_Relationship_Group__c = mapAccountId.get(actionPlanRecord.TargetId); 
                    }
                    else
                    {
                        actionPlanRecord.WT_Relationship_Group__c = Null;
                    }
                }
            }
            listOfSObject.addAll(listOpportunity);
            listOfSObject.addAll(listFinancialAccount);
            listOfSObject.addAll(listReferral);
            listOfSObject.addAll(listEvent);
            listOfSObject.addAll(listTask);
            listOfSObject.addAll(listActionPlan);
            List<Database.SaveResult> listUpdateResult = Database.update(listOfSObject, false);
            for (Database.SaveResult result : listUpdateResult) 
            {
                if (!result.isSuccess())
                {
                    for (Database.Error error : result.getErrors())
                    {
                        System.debug('Record Id: '+result.getId()+'Error: '+ error.getMessage());
                    }
                }
            }
        }
    }
}