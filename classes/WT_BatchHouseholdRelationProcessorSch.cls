global class WT_BatchHouseholdRelationProcessorSch implements Schedulable 
{   
    global void execute(SchedulableContext context) 
    {
        WT_BatchHouseholdRelationProcessor batchObject = new WT_BatchHouseholdRelationProcessor(); 
        Database.executeBatch(batchObject, 100);
    } 
}