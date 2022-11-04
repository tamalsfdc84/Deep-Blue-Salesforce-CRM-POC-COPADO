@isTest
public class WT_BatchBankOfficerAcctReconcileSch_T 
{
    @isTest 
    static void runBatchBusinessUnitUpdate()
    {
        Test.StartTest();
        WT_BatchBankOfficerAcctReconciliationSch reconcileSchedule = new WT_BatchBankOfficerAcctReconciliationSch();
        String scheduleTime = '0 0 23 * * ?'; 
        system.schedule('Test Business Unit scheduler', scheduleTime, reconcileSchedule); 
        Test.stopTest(); 
    }
}