/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name         WT_BatchRelationshipGroupMemberRollUp
* @Author           Swaminathan E     <sezhumal@wintrust.com> 
* @ModifiedBy       Swaminathan E     <sezhumal@wintrust.com>
* @version      v1.0 
* @CreatedDate      09-05-2021
* @UsedBy           Relationship Group Relation Object
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* Class is used to roll up all the child records. 
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Changes
* vx.x              <user id>
* MM-DD-YYYY        <Explanation> 
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
// Test class: WT_BatchRelationshipGroupMemberRollUp_T
global class WT_BatchRelationshipGroupMemberRollUp implements Database.Batchable<sObject>
{
    public List<String> getRollUpObjectApiName;  
    global WT_BatchRelationshipGroupMemberRollUp (String getRollUpObjectApiName)
    {
        List<String> listRoll = getRollUpObjectApiName.split(',');
        List<String> listRollend = new List<String>();
        for(String rollupName : listRoll)
        {
            listRollend.add(rollupName.toLowerCase());
        }
        this.getRollUpObjectApiName = listRollend;
    }
    //Query all the existing Relationship Group Relation record
    public Database.QueryLocator start(Database.BatchableContext BC)
    {
        String query = 'SELECT Id, WT_RelatedAccount__c, WT_Account__c, WT_Active__c FROM WT_RelationshipGroup_Relation__c WHERE WT_RelatedAccount__c != Null';
        return Database.getQueryLocator(query);   
    }
    public void execute(Database.BatchableContext bc, List<WT_RelationshipGroup_Relation__c> listOfRGRelation)
    {
        List<SObject> listOfSObject = new List<SObject>();
        Set<Id> setActiveRelatedId = new Set<Id>();
        Map<Id,Id> mapAccountId = new Map<Id,Id>();
        for(WT_RelationshipGroup_Relation__c acountAccountRecord: listOfRGRelation)
        {
            if(acountAccountRecord.WT_Active__c)
            {
                setActiveRelatedId.add(acountAccountRecord.WT_RelatedAccount__c);
            }
            mapAccountId.put(acountAccountRecord.WT_RelatedAccount__c,acountAccountRecord.WT_Account__c);  
        }
        if(!mapAccountId.isEmpty())
        {
            if(getRollUpObjectApiName.contains('account')) 
            { 
                List<Account> listAccount = [SELECT Id, WT_Parent_Relationship_Group__c FROM Account WHERE Id IN :mapAccountId.keySet() ];
                for(Account accountRecord :listAccount)
                {
                    if(setActiveRelatedId.contains(accountRecord.Id))
                    {
                        accountRecord.WT_Parent_Relationship_Group__c = mapAccountId.get(accountRecord.Id);
                    }
                    else
                    {
                        accountRecord.WT_Parent_Relationship_Group__c = Null; 
                    }
                }
                listOfSObject.addAll(listAccount);
            }
            if(getRollUpObjectApiName.contains('opportunity')) 
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
                listOfSObject.addAll(listOpportunity);
            }
            if(getRollUpObjectApiName.contains('financial account'))
            { 
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
                listOfSObject.addAll(listFinancialAccount);
            }
            if(getRollUpObjectApiName.contains('referral'))
            {
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
                listOfSObject.addAll(listReferral);
            }
            if(getRollUpObjectApiName.contains('event'))
            {
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
                listOfSObject.addAll(listEvent);
            }
            if(getRollUpObjectApiName.contains('task'))
            { 
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
                listOfSObject.addAll(listTask);
            }
            if(getRollUpObjectApiName.contains('action plan'))
            { 
                List<ActionPlan> listActionPlan = [SELECT Id, TargetId, WT_Relationship_Group__c FROM ActionPlan WHERE TargetId IN :mapAccountId.keySet()];
                for(ActionPlan actionPlanRecord: listActionPlan)
                {
                    if(actionPlanRecord.TargetId.getsObjectType() == Account.sObjectType)
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
                listOfSObject.addAll(listActionPlan);
            }                                  
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
    public void finish(Database.BatchableContext bc)
    {
        // execute any post-processing operations
    }
}