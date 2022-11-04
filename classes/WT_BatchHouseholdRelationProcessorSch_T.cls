@isTest
public class WT_BatchHouseholdRelationProcessorSch_T 
{
	@isTest
    static void TestScheduleClass()
    {
        Test.startTest();
        WT_BatchHouseholdRelationProcessorSch batchToSchedule = new WT_BatchHouseholdRelationProcessorSch();
        String cronSchedule = '0 0 23 * * ?';        
        System.schedule('Test Schedule', cronSchedule, batchToSchedule);
        Test.stopTest();
    }
}