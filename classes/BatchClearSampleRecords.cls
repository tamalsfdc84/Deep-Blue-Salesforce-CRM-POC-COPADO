//SGE 396
//Test class: TestBatchClearSampleRecords
public class BatchClearSampleRecords implements Database.Batchable<sObject>, Database.Stateful
{
    public Integer recordsProcessed = 0; //Instantiate Record Counter Variable
    
    //Start Apex Batch Process
    public Database.QueryLocator start(Database.BatchableContext batchableContext)
    {
        return Database.getQueryLocator([SELECT Id FROM Opportunity WHERE Name LIKE '%(Sample)']);
    }
    public List<Opportunity> deletedOpportunities = new List<Opportunity>();//Store Informaton about deleted values
    
    //Start Execute Batch Process
    public void execute(Database.BatchableContext batchableContext, List<Opportunity> scope)
    {
        List<Opportunity> opportunitiestoDelete = new List<Opportunity>();
        for(Opportunity opportunity : scope)
        {
            opportunitiestoDelete.add(opportunity); //Add Opportunities retrived to list for deletion
            
            recordsProcessed++; //Increment Record Counter
        }
        delete opportunitiestoDelete; //Delete all opportunities in delete list (Single DML Call)
    }
    
    public void finish(Database.BatchableContext batchableContext)
    {
       system.debug('Total Number of Opportunities Removed: ' + recordsProcessed);
    }
}