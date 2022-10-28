//Test class: WT_BatchBankOfficerAcctReconcileSch_T
global class WT_BatchBankOfficerAcctReconciliationSch implements Schedulable
{
    global void execute(SchedulableContext scheduleContext)
    {
        WT_BatchBankOfficerAccountReconciliation accountOwnerReconciliationBatch = new WT_BatchBankOfficerAccountReconciliation();
        Id batchProcessId = Database.executeBatch(accountOwnerReconciliationBatch, 200);           
    }
}