/**
 * -------------------------------------------------------------------------------------------------------------------------------------------------
 * @Name			WT_BatchBusinessUnitEntityUpdate_T
 * @Author			Sivaranjani 	<sivaranjani.d2@tcs.com.tcsdev>	
 * @version 		v1.0 
 * @CreatedDate		11-18-2020
 * ---------------------------------------------------------------------------------------------------------------------------------------------------
 * @Description 
 * Class is used as test class for WT_BatchBusinessUnitEntityUpdate, WT_BatchBusinessUnitEntityUpdateSchedule
 * ---------------------------------------------------------------------------------------------------------------------------------------------------
 * FUNCTIONAL TEST LOGIC
 * 1- runBatchBusinessUnitEntityUpdate() 
 * 	> used to test the update of Business unit entity based on the unproccess Business unit entity stagging records
 * 
 * 2- runBatchBusinessUnitEntityUpdateSchedule()
 * 	> used to run the scheduler class for the WT_BatchBusinessUnitEntityUpdate , generally for code coverage.
 * ----------------------------------------------------------------------------------------------------------------------------------------------------
**/

@isTest
private class WT_BatchBusinessUnitEntityUpdate_T 
{
    @isTest static void runBatchBusinessUnitEntityUpdate()
    {
        WT_Business_Unit_Entity_Staging__c businessUnitStagingRecord =  WT_DataFactory.createBusinessUnitEntityStagging();
        insert businessUnitStagingRecord;
        WT_Business_Unit_Entity__c businessUnitRecord = WT_DataFactory.createBusinessUnitEntity();
        insert businessUnitRecord;
            
        System.assertEquals(businessUnitStagingRecord.WT_Is_Processed__c, false);
        Test.startTest();
        WT_BatchBusinessUnitEntityUpdate batchBusinessUnitEntityUpdate= new WT_BatchBusinessUnitEntityUpdate();
        Database.executeBatch(batchBusinessUnitEntityUpdate);
        Test.stopTest();
        
        WT_Business_Unit_Entity_Staging__c businessUnitEntityStagingRecordQuery = [select Id, WT_Is_Processed__c from WT_Business_Unit_Entity_Staging__c where id =: businessUnitStagingRecord.id];
        System.assertEquals(businessUnitEntityStagingRecordQuery.WT_Is_Processed__c, true);
    }
    //test function for WT_BatchBUEntityUpdateSchedule
    //@isTest static void runBatchBusinessUnitEntityUpdateSchedule()
    //{
    //    Test.StartTest();
    //    WT_BatchBusinessUnitEntityUpdateSchedule batchBusinessUnitEntityUpdateSchedule = new WT_BatchBusinessUnitEntityUpdateSchedule();
    //    String scheduleTime = '0 0 23 * * ?'; 
    //    system.schedule('Test Business Unit Entity scheduler', scheduleTime, batchBusinessUnitEntityUpdateSchedule); 
    //    Test.stopTest(); 
    //}
}