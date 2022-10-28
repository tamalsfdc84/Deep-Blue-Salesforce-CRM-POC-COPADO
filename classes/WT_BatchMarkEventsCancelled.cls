/**
* --------------------------------------------------------------------------------------------------------------
* @Name             WT_BatchMarkEventsCancelled
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
// Code Coverage: WT_BatchMarkEventsCancelled_T
global class WT_BatchMarkEventsCancelled implements Database.Batchable<sObject>
{
    global Database.QueryLocator  start(Database.BatchableContext bc) 
    {
        String query = 'SELECT Id,WT_Status__c,RecordType.Name,StartDateTime,EndDateTime,ActivityDate,LastModifiedDate FROM Event WHERE (RecordType.Name =\'Event\' or RecordType.Name =\'CRA Event\' or RecordType.Name =\'Wintrust Event\') and WT_Status__c!=\'Completed\'';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Event> scope)
    {
        List<Event> listEventRecords=new List<Event>();
        for( Event listEvent:scope)
        {
            DateTime exceededDueDate= listEvent.EndDateTime.addMonths(12);
            Date lastDateModified=Date.Today().addMonths(-12);
            if(Date.today()>exceededDueDate && listEvent.LastModifiedDate<lastDateModified) 
            {
                listEvent.WT_Status__c='Cancelled';
                listEventRecords.add(listEvent);
            }
        }
        try{
            update listEventRecords;
        }
        catch(Exception e)
        {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
    }
    global void finish(Database.BatchableContext bc)
    {
        // execute any log files 
    } 
}