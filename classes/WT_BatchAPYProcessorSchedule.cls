global class WT_BatchAPYProcessorSchedule implements Schedulable
{
    global void execute(SchedulableContext batchApyUpdateSchedule)
    {
        WT_BatchAPYProcessor apyProcessor = new WT_BatchAPYProcessor();
        Id batchProcessId = Database.executeBatch(apyProcessor, 200);           
    }
}