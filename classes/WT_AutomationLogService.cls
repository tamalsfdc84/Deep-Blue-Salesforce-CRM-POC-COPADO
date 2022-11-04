public class WT_AutomationLogService 
{
    public static List<WT_Automation_Log__c> listAutomationLogToInsert = new List<WT_Automation_Log__c>();

    /**
    * --------------------------------------------------------------------------------------------------------------
    * @Description
    * This method adds the instance record in the static list maintained in this class
    * --------------------------------------------------------------------------------------------------------------
    * @Param  className    Name of the originating class for the log
    * @Param  methodName    Name of the originating method for the log
    * @Param  triggeringRecordId    Id of the Record that is used to trigger dependent object update
    * @Param  dependentRecordId    Id of the dependent Record that is updated
    * @Param  message    Descriptive message for the log
    * @Param  isSuccess    Tracks if the DML that triggered logging was successful or not
    * @Param  processDescription    Description of the automation which triggered this log (EX: Renewal Auto Creation)
    * @Return void                         none
    * --------------------------------------------------------------------------------------------------------------
    **/
    public static void Log(String className, String methodName, String triggeringRecordId, String dependentRecordId,
                            String message, Boolean isSuccess, String processDescription)
    {
        WT_Automation_Log__c newLogToCreate = new WT_Automation_Log__c();
        newLogToCreate.WT_Class_Name__c = className;
        newLogToCreate.WT_Method_Name__c = methodName;
        newLogToCreate.WT_Triggering_Record_Id__c = triggeringRecordId;
        newLogToCreate.WT_Dependent_Record_Id__c = dependentRecordId;
        newLogToCreate.WT_Message__c = message;
        newLogToCreate.WT_Is_Success__c = isSuccess;
        newLogToCreate.WT_Process_Description__c = processDescription;

        listAutomationLogToInsert.add(newLogToCreate);
    }

    /**
    * --------------------------------------------------------------------------------------------------------------
    * @Description
    * This method inserts the logs if there are any. Insert is done in Database class so that if it fails, it 
    * doesn't roll back the transaction
    * --------------------------------------------------------------------------------------------------------------
    * @Return void                         none
    * --------------------------------------------------------------------------------------------------------------
    **/
    public static void CommitLogs()
    {
        if(!listAutomationLogToInsert.isEmpty())
        {
            Database.insert(listAutomationLogToInsert, false);
        }
    }
}