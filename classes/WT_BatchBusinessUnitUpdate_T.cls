/**
 * -------------------------------------------------------------------------------------------------------------------------------------------------
 * @Name            WT_BatchBusinessUnitUpdate_T
 * @Author          Sivaranjani     <sivaranjani.d2@tcs.com.tcsdev> 
 * @version         v1.0 
 * @CreatedDate     11-18-2020
 * ---------------------------------------------------------------------------------------------------------------------------------------------------
 * @Description 
 * Class is used as test class for WT_BatchBusinessUnitEntityUpdate, WT_BatchBusinessUnitEntityUpdateSchedule
 * ---------------------------------------------------------------------------------------------------------------------------------------------------
 * FUNCTIONAL TEST LOGIC
 * 1- runBatchBusinessUnitUpdate() 
 *  > used to test the update of Business unit entity based on the unproccess Business unit entity stagging records
 * 
 * 2- runBatchBusinessUnitEntityUpdateSchedule()
 *  > used to run the scheduler class for the WT_BatchBusinessUnitEntityUpdate , generally for code coverage.
 * ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
@isTest
private class WT_BatchBusinessUnitUpdate_T 
{
    @isTest static void runBatchBusinessUnitUpdate()
    {
        WT_Business_Unit_Entity_Staging__c businessUnitStagingRecord =  WT_DataFactory.createBusinessUnitEntityStagging();
        insert businessUnitStagingRecord;
        WT_Business_Unit_Entity_Staging__c businessUnitStagingRecordWTFC =  WT_DataFactory.createBusinessUnitEntityStaggingWTFC();
        insert businessUnitStagingRecordWTFC;
        WT_Business_Unit_Entity__c businessUnitRecord = WT_DataFactory.createBusinessUnitEntity();
        insert businessUnitRecord;
        WT_Business_Unit_Entity__c businessUnitRecordWTFC = WT_DataFactory.createBusinessUnitEntityWTFC();
        insert businessUnitRecordWTFC;
        WT_Business_Unit_Entity_Staging__c businessUnitStagingRecord2 = WT_DataFactory.createBusinessUnitEntityStagging2();
        insert businessUnitStagingRecord2;
        System.assertEquals(businessUnitStagingRecord.WT_Is_Processed__c, false);
        System.assertEquals(businessUnitStagingRecordWTFC.WT_Is_Processed__c, false);
        Test.startTest();
        WT_BatchBusinessUnitUpdate batchBusinessUnitUpdate= new WT_BatchBusinessUnitUpdate();
        Database.executeBatch(batchBusinessUnitUpdate);
        Test.stopTest();
        WT_Business_Unit_Entity_Staging__c businessUnitEntityStagingRecordQuery = [select Id, WT_Is_Processed__c from WT_Business_Unit_Entity_Staging__c where id =: businessUnitStagingRecord.id];
        System.assertEquals(businessUnitEntityStagingRecordQuery.WT_Is_Processed__c, true);
        WT_Business_Unit_Entity_Staging__c businessUnitEntityStagingRecordQuery2 = [select Id, WT_Is_Processed__c from WT_Business_Unit_Entity_Staging__c where id =: businessUnitStagingRecord2.id];
        System.assertEquals(businessUnitEntityStagingRecordQuery2.WT_Is_Processed__c, false);
        
        WT_Business_Unit_Entity_Staging__c businessUnitEntityStagingRecordWTFCQuery = [select Id, WT_Is_Processed__c from WT_Business_Unit_Entity_Staging__c where id =: businessUnitStagingRecordWTFC.id];
        System.assertEquals(businessUnitEntityStagingRecordWTFCQuery.WT_Is_Processed__c, true);
    }
    //test function for WT_BatchBUEntityUpdateSchedule
    @isTest static void runBatchBusinessUnitEntityUpdateSchedule()
    {
        Test.StartTest();
        WT_BatchBusinessUnitUpdateSchedule batchBusinessUnitUpdateSchedule = new WT_BatchBusinessUnitUpdateSchedule();
        String scheduleTime = '0 0 23 * * ?'; 
        system.schedule('Test Business Unit scheduler', scheduleTime, batchBusinessUnitUpdateSchedule); 
        Test.stopTest(); 
    }
}