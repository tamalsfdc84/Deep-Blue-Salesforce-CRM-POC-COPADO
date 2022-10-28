@isTest
public class WT_BatchBankOfficerFinAcctReconcileSch_T 
{
    @isTest 
    static void runFinancialAccountReconciliationUpdate()
    {
        Test.StartTest();
        WT_BatchBankOfficerFinAcctReconcileSch reconcileSchedule = new WT_BatchBankOfficerFinAcctReconcileSch();
        String scheduleTime = '0 0 23 * * ?'; 
        system.schedule('Test Business Unit scheduler', scheduleTime, reconcileSchedule); 
        Test.stopTest(); 
    }
}