/**
* --------------------------------------------------------------------------------------------------------------
* @Name             WT_BatchMarkTasksCancelled
* @Author           Anoop B <abattini@wintrust.com>
* @ModifiedBy       Anoop B <abattini@wintrust.com>
* @Version          v1.0
* @CreatedDate      13-12-2020
* @UsedBy           
* --------------------------------------------------------------------------------------------------------------
* @Description
* This  Batch Class is used to Cancel the Activities that are a year past their Due date OR  End date 
* that also haven’t been modified in over a year.
* --------------------------------------------------------------------------------------------------------------
* @Changes
* v1.0
* --------------------------------------------------------------------------------------------------------------
**/
// Code Coverage: WT_BatchMarkTasksCancelled_T

global class WT_BatchMarkTasksCancelled implements Database.Batchable<sObject>
{
    global Database.QueryLocator  start(Database.BatchableContext bc) 
    {
        String query = 'SELECT Id,Status,RecordType.Name,ActivityDate,LastModifiedDate FROM Task WHERE (RecordType.Name =\'CRA Call\' or RecordType.Name =\'Wintrust Task\' or RecordType.Name =\'Standard Call\' or RecordType.Name =\'WFG Call\' or RecordType.Name =\'Task\') and Status!=\'Completed\'';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Task> scope)
    {
        List<Task> listTaskRecords=new List<Task>(); 
        Date exceededDueDate;
        for( Task listTask:scope)
        {
            if(listTask.ActivityDate!=null){
                exceededDueDate= listTask.ActivityDate.addMonths(12);
            }
            Date lastDateModified=Date.Today().addMonths(-12);
            if(Date.today()>exceededDueDate && listTask.lastModifiedDate<LastDateModified) 
            {
                listTask.Status='Cancelled';
                listTaskRecords.add(listTask);
            }
        }
        try{
            update listTaskRecords;
        }
        catch(Exception e)
        {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
    }
    global void finish(Database.BatchableContext bc)
    {
    } 
}