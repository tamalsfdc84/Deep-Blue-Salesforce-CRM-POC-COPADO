/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_TaskBeforeHandler
* @Author			Karishma Keswani	<kkeswani@wintrust.com>
* @ModifiedBy		Swaminathan E	    <SEzhumal@wintrust.com>
* @Version			v1.0
* @CreatedDate		13-11-2020
* @UsedBy			Task Object
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is handler class for Task trigger.
* This handles all the before logic of the Task trigger.
* --------------------------------------------------------------------------------------------------------------
* @Changes
* v1.0
* 04-12-2021
* --------------------------------------------------------------------------------------------------------------
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
        ValidateOutcomeNotesOnInsert(listNewTask);
    }
    public override void beforeUpdate()
    {
        ValidateOutcomeNotesOnUpdate(mapNewTaskIdandTask);
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
        List<WT_Activity_Extension__c> listActivity=[Select Id, WT_TaskId__c, WT_Outcome_Notes__c from WT_Activity_Extension__c where WT_TaskId__c=:mapNewTaskIdandTask.keyset()];
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
        List<WT_Activity_Extension__c> listActivityExt=[select Id, WT_TaskId__c from WT_Activity_Extension__c where WT_TaskId__c=:listActivityExtIds];       
        if(listActivityExt!=null && listActivityExt.size()>0)
        {      
            delete listActivityExt;  
        }
    }
}