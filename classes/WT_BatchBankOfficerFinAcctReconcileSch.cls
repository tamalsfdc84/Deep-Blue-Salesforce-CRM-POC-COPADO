//Test class: WT_BatchBankOfficerFinAcctReconcileSch_T
global class WT_BatchBankOfficerFinAcctReconcileSch implements Schedulable
{
    global void execute(SchedulableContext scheduleContext)
    {
        WT_BatchBankOfficerFinAcctReconciliation financialAccountOwnerReconciliationBatch = new WT_BatchBankOfficerFinAcctReconciliation();
        Id batchProcessId = Database.executeBatch(financialAccountOwnerReconciliationBatch, 200);           
    }
}