public without sharing class WT_ExceptionLogHelper 
{
    public static void LogException(String recordId, String className, String methodName,
                                    String dmlException)
    {
        List<WT_Exception_Log__c> listExceptionLogToInsert = new List<WT_Exception_Log__c>();
        WT_Exception_Log__c newLog = new WT_Exception_Log__c();
        newLog.WT_Record_Id__c = recordId;
        newLog.WT_Class_Name__c = className;
        newLog.WT_Method_Name__c = methodName;
        newLog.WT_Exception__c = dmlException;

        listExceptionLogToInsert.add(newLog);
        Database.insert(listExceptionLogToInsert, false);
    }   
}