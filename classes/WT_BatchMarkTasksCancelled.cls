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
* ------------------------------------------------------------------------------------------------------------------
* @Changes
* v1.1             Anoop B  <abattini@wintrust.com>
* 23-07-2021       Added Custom Labels and Added "Closed" status in the criteria
* -------------------------------------------------------------------------------------------------------------------
**/
// Code Coverage: WT_BatchMarkTasksCancelled_T

global class WT_BatchMarkTasksCancelled implements Database.Batchable<sObject>
{
    global Database.QueryLocator  start(Database.BatchableContext bc) 
    {
        String query = 'SELECT Id,Status,RecordType.Name,ActivityDate,LastModifiedDate FROM Task WHERE (RecordType.Name =\'CRA Call\' or RecordType.Name =\'Wintrust Task\' or RecordType.Name =\'Standard Call\' or RecordType.Name =\'WFG Call\' or RecordType.Name =\'Task\') and (Status!=\'Completed\' and Status!=\'Closed\' and Status!=\'Cancelled\')';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Task> scope)
    {
        System.debug('scope size=='+scope.size());
        List<Task> listTaskRecords=new List<Task>(); 
        Date exceededDueDate;
        Date lastDateModified;
        Integer RemoveMonths=  Integer.valueof(System.Label.Remove_Months_Activities_Cancelled);
        Integer AddMonths =  Integer.valueof(System.Label.AddMonths_Activities_Cancelled);
        for( Task listTask:scope)
        {
            if(listTask.ActivityDate!=null){
                exceededDueDate= listTask.ActivityDate.addMonths(AddMonths);
            }
            if(RemoveMonths==1)
            {
                lastDateModified=Date.Today().addDays(-1);
            }
            else
            {
                lastDateModified=Date.Today().addMonths(RemoveMonths);
            }
            
            if(Date.today()>exceededDueDate && listTask.lastModifiedDate<LastDateModified) 
            {
                listTask.Status='Cancelled';
                listTaskRecords.add(listTask);
            }
        }
        Database.SaveResult[] srList = Database.update(listTaskRecords, false);
    }
    global void finish(Database.BatchableContext bc)
    {
    } 
}