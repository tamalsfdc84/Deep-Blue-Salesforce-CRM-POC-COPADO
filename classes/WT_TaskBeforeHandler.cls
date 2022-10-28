/**
* --------------------------------------------------------------------------------------------------------------
* @Name             WT_TaskBeforeHandler
* @Author           Karishma Keswani    <kkeswani@wintrust.com>
* @ModifiedBy       Swaminathan E       <SEzhumal@wintrust.com>
* @Version          v1.0
* @CreatedDate      13-11-2020
* @UsedBy           Task Object
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is handler class for Task trigger.
* This handles all the before logic of the Task trigger.
* --------------------------------------------------------------------------------------------------------------
* @Changes
* v1.0
* 04-12-2021
* V 2.0      <ajaini@wintrust.com>  
* 02-09-2022 SGE 124 - Added the method RestrictAccounts to restrict the Task from selecting the RG and HH Accounts 
* V 2.1      <ajaini@wintrust.com>  
* 03-11-2022 SGE-167 - restrict users from creating Task for an inactive Account
* Updated 59-94 for SGE-90
--------------------------------------------------------------------------------------------------------------  
--------------------------------------------------------------------------------------------------------------
**/
public class WT_TaskBeforeHandler extends TriggerHandler
{
    List<Task> listNewTask = new List<Task>();
    Map<Id, Task> mapNewTaskIdandTask = new Map<Id, Task>();
    Map<Id, Task> mapOldTaskIdandTask = new Map<Id, Task>();
    public WT_TaskBeforeHandler()
    {
        PopulateGlobalLists();        
    }
    public override void beforeInsert()
    {     
        SetRecordTypeIdFromGlobalLayout();
        SetActivityType();
        ValidateOutcomeNotesOnInsert(listNewTask);
        populateRelationshiproupId(listNewTask);
        RestrictAccounts(listNewTask);
    }
    public override void beforeUpdate()
    {
        ValidateOutcomeNotesOnUpdate(mapNewTaskIdandTask);
        populateRelationshiproupId(listNewTask);
        RestrictAccounts(listNewTask);
    }
    public override void beforeDelete()
    {
        DeleteActivityExtesionRecords(mapOldTaskIdandTask);
    }
    private void PopulateGlobalLists()
    {        
        listNewTask = (List<Task>) Trigger.new;
        mapNewTaskIdandTask = (Map<Id, Task>) Trigger.newMap;
        mapOldTaskIdandTask = (Map<Id, Task>) Trigger.oldMap;
    }
    //recordtype for task creation
    private void SetRecordTypeIdFromGlobalLayout()
    {
        for(Task newTask : listNewTask)
        {
            Id testCraCallTaskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('WT_CRA_Call_New').getRecordTypeId();
            Id craCallTaskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('WT_CRA_Call').getRecordTypeId();
            Id standardCallTaskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('WT_Standard_Call').getRecordTypeId();
            Id tmCallTaskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('TM_Call').getRecordTypeId();
            Id wfgCallTaskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('WT_WFG_Call').getRecordTypeId();
            Id wintrustTaskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('WT_Wintrust_Task').getRecordTypeId();
            Id standardCallTestTaskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('WT_Standard_Call_New').getRecordTypeId();
            Id tmCallTestTaskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('TM_Call_New').getRecordTypeId();
            Id wfgCallTestTaskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('WT_WFG_Call_New').getRecordTypeId();
            Id wintrustTestTaskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('WT_Wintrust_Task_New').getRecordTypeId();
            if(newTask.RecordTypeId == testCraCallTaskRecordTypeId)
            {
                newTask.RecordTypeId = craCallTaskRecordTypeId;
            }
            if(newTask.RecordTypeId == standardCallTestTaskRecordTypeId)
            {
                newTask.RecordTypeId = standardCallTaskRecordTypeId;
            }
            if(newTask.RecordTypeId == tmCallTestTaskRecordTypeId)
            {
                newTask.RecordTypeId = tmCallTaskRecordTypeId;
            }
            if(newTask.RecordTypeId == wfgCallTestTaskRecordTypeId)
            {
                newTask.RecordTypeId = wfgCallTaskRecordTypeId;
            }
            if(newTask.RecordTypeId == wintrustTestTaskRecordTypeId)
            {
                newTask.RecordTypeId = wintrustTaskRecordTypeId;
            }
        }
    }
    private void SetActivityType()
    {
        for(Task newTask : listNewTask)
        {
            Id craCallTaskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('WT_CRA_Call').getRecordTypeId();
            Id standardCallTaskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('WT_Standard_Call').getRecordTypeId();
            Id tmCallTaskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('TM_Call').getRecordTypeId();
            Id wfgCallTaskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('WT_WFG_Call').getRecordTypeId();
            Id wintrustTaskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('WT_Wintrust_Task').getRecordTypeId();
            Id standardTaskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('WT_Task').getRecordTypeId();

            if(newTask.WT_Activity_Type__c == null)
            {
                if(newTask.RecordTypeId == craCallTaskRecordTypeId || newTask.RecordTypeId == craCallTaskRecordTypeId ||
                    newTask.RecordTypeId == craCallTaskRecordTypeId || newTask.RecordTypeId == craCallTaskRecordTypeId)
                {
                    newTask.WT_Activity_Type__c = 'Phone Call';
                }

                if(newTask.RecordTypeId == wintrustTaskRecordTypeId || newTask.RecordTypeId == standardTaskRecordTypeId)
                {
                    newTask.WT_Activity_Type__c = 'Task';
                }
            }
        }
    }
    /**
* --------------------------------------------------------------------------------------------------------------
* @Description
* This method is used to populate the Relationship Group ID for the Task linked to Business accounts
*
* --------------------------------------------------------------------------------------------------------------
* @Param  listNewTask          List of Task
* @Return void                 Returns none
* --------------------------------------------------------------------------------------------------------------
**/
    public void populateRelationshiproupId(List<Task> listNewTask)
    {
        Set<Id> setAccountId = new Set<Id>();
        Map<Id,Id> mapAccountId = new Map<Id,Id>();
        for(Task taskRecord: listNewTask)
        {
            setAccountId.add(taskRecord.WhatId);  
        }
        List<WT_RelationshipGroup_Relation__c> listRelationRecord = [SELECT Id,
                                                                     WT_Account__c,
                                                                     WT_RelatedAccount__c 
                                                                     FROM WT_RelationshipGroup_Relation__c 
                                                                     WHERE WT_Active__c = true 
                                                                     AND WT_RelatedAccount__c IN :setAccountId];
        if (listRelationRecord.size() > 0)
        {
            for(WT_RelationshipGroup_Relation__c relation :listRelationRecord )
            {
                mapAccountId.put(relation.WT_RelatedAccount__c,relation.WT_Account__c);
            }
        }
        for(Task taskRecord: listNewTask)
        {
            if(mapAccountId.containsKey(taskRecord.WhatId))
            {
                taskRecord.WT_Relationship_Group__c = mapAccountId.get(taskRecord.WhatId);
            }
            else
            {
                taskRecord.WT_Relationship_Group__c = Null; 
            }     
        }
    }   
    /**
* --------------------------------------------------------------------------------------------------------------
* @Description
* This method Validates the Task Record for Outcome Notes when changing the status to completed.
* --------------------------------------------------------------------------------------------------------------
* @Param  listNewTask    List of Task
* @Return void           Returns none
* --------------------------------------------------------------------------------------------------------------
**/   
    private void ValidateOutcomeNotesOnInsert(List<Task> listNewTask)
    {        
        for(Task taskRecord : listNewTask)
        { 
            if(taskRecord.WT_Outcome_Notes__c==null && taskRecord.Status == 'Completed' && !(taskRecord.Subject.contains('Case')) && !(taskRecord.Subject.contains('Email:')))
            { 
                taskRecord.addError('Outcome Notes field should be mandatory.');
            }
        }
    }
    /**
* --------------------------------------------------------------------------------------------------------------
* @Description
* This method Validates the Task Record for Outcome Notes when changing the status to completed.
* --------------------------------------------------------------------------------------------------------------
* @Param  listNewTask    List of Task
* @Return void           Returns none
* --------------------------------------------------------------------------------------------------------------
**/   
    private void ValidateOutcomeNotesOnUpdate(Map<Id, Task> mapNewTaskIdandTask)
    {
        List<WT_Activity_Extension__c> listActivity=[SELECT Id, 
                                                     WT_TaskId__c, 
                                                     WT_Outcome_Notes__c 
                                                     FROM WT_Activity_Extension__c 
                                                     WHERE WT_TaskId__c=:mapNewTaskIdandTask.keyset()];
        for(WT_Activity_Extension__c ActivityRecord:listActivity)
        {
            Task newTaskRecord=mapNewTaskIdandTask.get(ActivityRecord.WT_TaskId__c);        
            if(newTaskRecord.Status=='Completed' && ActivityRecord.WT_Outcome_Notes__c == null)
            {
                newTaskRecord.addError('Outcome Notes field should be mandatory.'); 
            }
        }
    }    
    /**
* --------------------------------------------------------------------------------------------------------------
* @Description
* This method deletes the Activity Extension Records when associated task record gets deleted.
* --------------------------------------------------------------------------------------------------------------
* @Param  mapOldTaskIdandTask    Map of Task Id and Task
* @Return void           Returns none
* --------------------------------------------------------------------------------------------------------------
**/    
    private void DeleteActivityExtesionRecords(Map<Id, Task> mapOldTaskIdandTask)
    {           
        List<Id> listActivityExtIds=new List<Id>();
        for(Task deletedTasks:mapOldTaskIdandTask.Values())
        {
            listActivityExtIds.add(deletedTasks.Id);           
        }       
        List<WT_Activity_Extension__c> listActivityExt=[SELECT Id, 
                                                        WT_TaskId__c 
                                                        FROM WT_Activity_Extension__c 
                                                        WHERE WT_TaskId__c=:listActivityExtIds];       
        if(listActivityExt!=null && listActivityExt.size()>0)
        {      
            delete listActivityExt;  
        }
    }
    
    /* --------------------------------------------------------------------------------------------------------------   
* @Description  
* This method Validates and restricts the Task Record for the record types of RG and HH Accounts.   
* --------------------------------------------------------------------------------------------------------------    
* @Param  listNewTask    List of Task   
* @Return void           Returns none   
* --------------------------------------------------------------------------------------------------------------    
**/     
    private void RestrictAccounts(List<Task> listNewTask)   
    {   
        Set<Id> setAccountIds = new Set<Id>();    
        List<Task> listAccountTask = New List<Task>();      
        Final String HOUSEHOLD_RECORD_TYPE_DEVELOPER_NAME = 'IndustriesHousehold';  
        Final String RELATIONSHIPGROUP_RECORD_TYPE_DEVELOPER_NAME = 'Relationship_Group';   
        try 
        {   
            for(Task taskRecord : listNewTask){ 
                if(taskRecord.WhatId.getsObjectType() == Account.sObjectType)   
                {   
                    setAccountIds.add(taskRecord.WhatId);   
                    listAccountTask.add(taskRecord);    
                }                   
            }          
            if(!setAccountIds.isEmpty())    
            {   
                Map<Id,Account> mapAccountIdAndAccount = new Map<Id,Account>([SELECT Id,
                                                                              RecordType.DeveloperName, 
                                                                              FinServ__Status__c    
                                                                              FROM Account 
                                                                              WHERE Id IN: setAccountIds]); 
                if(!mapAccountIdAndAccount.isEmpty())   
                {                      
                    Account accountRecord;  
                    for(Task taskRecord :listAccountTask)   
                    {                        
                        if(mapAccountIdAndAccount.get(taskRecord.WhatId)!=null) 
                        {   
                            accountRecord = mapAccountIdAndAccount.get(taskRecord.WhatId);  
                            if(accountRecord.RecordType.DeveloperName==HOUSEHOLD_RECORD_TYPE_DEVELOPER_NAME ||  
                               accountRecord.RecordType.DeveloperName==RELATIONSHIPGROUP_RECORD_TYPE_DEVELOPER_NAME) 
                            {   
                                taskRecord.addError(system.Label.WT_Task_RG_HH_Account_Error);//created a label for error   
                            }
                        }       
                    }   
                }                   
            }   
        }   
        catch(Exception e)  
        {   
            System.debug('The following exception has occurred: TaskBeforeHandler>RestrictAccounts> ' + e.getMessage());    
        }   
    }   
    
}