/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name            WT_BatchMarkTasksCancelled_T
* @Author         Anoop B  <abattini@wintrust.com> 
* @version         v1.0 
* @CreatedDate     11-18-2020
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* Class is used as test class for WT_BatchMarkTasksCancelled
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* FUNCTIONAL TEST LOGIC

* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/

@isTest
private class WT_BatchMarkTasksCancelled_T 
{
 
    @isTest static void runBatchTasksCacelled()
    {
        List<Task> listTaskRecords =  WT_DataFactory.createTaskRecords(5,'WT_Standard_Call');
        insert listTaskRecords;
        Test.startTest();
        WT_BatchMarkTasksCancelled batchTasksUpdate= new WT_BatchMarkTasksCancelled();
        Database.executeBatch(batchTasksUpdate);
        Test.stopTest();
    }
    
    //test function for WT_BatchTasksCancelledSchedule
    @isTest static void runBatchATasksCancelledSchedule()
    {
        Test.StartTest();
        WT_BatchMarkTasksCancelledSchedule batchTasksSchedule = new WT_BatchMarkTasksCancelledSchedule();
        String scheduleTime = '0 0 23 * * ?'; 
        system.schedule('Test Business Unit scheduler', scheduleTime, batchTasksSchedule); 
        Test.stopTest(); 
    }
    
   
}