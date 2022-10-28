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
* ------------------------------------------------------------------------------------------------------------------
* @Changes
* v1.1             Anoop B  <abattini@wintrust.com>
* 23-07-2021       Added Custom Labels and Added "Closed" status in the criteria
* -------------------------------------------------------------------------------------------------------------------
**/
// Code Coverage: WT_BatchMarkEventsCancelled_T
global class WT_BatchMarkEventsCancelled implements Database.Batchable<sObject>
{
    global Database.QueryLocator  start(Database.BatchableContext bc) 
    {
        String query = 'SELECT Id,WT_Status__c,RecordType.Name,StartDateTime,EndDateTime,ActivityDate,LastModifiedDate FROM Event WHERE (RecordType.Name =\'Event\' or RecordType.Name =\'CRA Event\' or RecordType.Name =\'Wintrust Event\') and (WT_Status__c!=\'Completed\' and WT_Status__c!=\'Cancelled\'and WT_Status__c!=\'Closed\')';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Event> scope)
    {
        List<Event> listEventRecords=new List<Event>();
        Integer RemoveMonths=  Integer.valueof(System.Label.Remove_Months_Activities_Cancelled);
        Integer AddMonths =  Integer.valueof(System.Label.AddMonths_Activities_Cancelled);
        Date lastDateModified;
        for( Event listEvent:scope)
        {
            lastDateModified=Date.Today().addMonths(RemoveMonths);
            DateTime exceededDueDate= listEvent.EndDateTime.addMonths(AddMonths);
            if(RemoveMonths==1)
            {
                lastDateModified=Date.Today().addDays(-1);
            }
            else
            {
                lastDateModified=Date.Today().addMonths(RemoveMonths);
            }
            
            if(Date.today()>exceededDueDate && listEvent.lastModifiedDate<LastDateModified) 
            {
                listEvent.WT_Status__c='Cancelled';
                listEventRecords.add(listEvent);
            }
        }
        Database.SaveResult[] srList = Database.update(listEventRecords, false);
    }
    global void finish(Database.BatchableContext bc)
    {
        
    } 
}