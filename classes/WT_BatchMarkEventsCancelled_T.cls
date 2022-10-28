/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name            WT_BatchMarkEventsCancelled_T
* @Author         Anoop B  <abattini@wintrust.com> 
* @version         v1.0 
* @CreatedDate     11-18-2020
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* Class is used as test class for WT_BatchMarkEventsCancelled
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* FUNCTIONAL TEST LOGIC

* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/

@isTest
private class WT_BatchMarkEventsCancelled_T 
{
    @isTest static void runBatchEventsCacelled()
    {
        List<Event> listEventRecords =  WT_DataFactory.createEventRecords(5,'WT_CRA_Event');
        insert listEventRecords;
        Test.startTest();
        WT_BatchMarkEventsCancelled batchEventsUpdate= new WT_BatchMarkEventsCancelled();
        Database.executeBatch(batchEventsUpdate);
        Test.stopTest();
    }
    
    //test function for WT_BatchEventsCancelledSchedule
    @isTest static void runBatchAEventsCancelledSchedule()
    {
        Test.StartTest();
        WT_BatchMarkEventsCancelledSchedule batchEventsSchedule = new WT_BatchMarkEventsCancelledSchedule();
        String scheduleTime = '0 0 23 * * ?'; 
        system.schedule('Test Business Unit scheduler', scheduleTime, batchEventsSchedule); 
        Test.stopTest(); 
    }
}