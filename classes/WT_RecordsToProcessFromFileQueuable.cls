/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_RecordsToProcessFromFileQueuable
* @Author			Krupa Chinthakindi<KChintha@wintrust.com>
* @ModifiedBy		Krupa Chinthakindi<KChintha@wintrust.com>
* @Version			v1.0
* @CreatedDate		07-20-2022
* ----------------------------------------------------------------------------------------------------------------------------------------
* @Description
* This class is to process the goal import file to get the record count and queueable jobID and send the response to the LWC Component.
* Code Coverage     WT_RecordsToProcessFromFileQueuable_T 
* -----------------------------------------------------------------------------------------------------------------------------------------
* @Changes
* vX.X
* MM-DD-YYYY
* -----------------------------------------------------------------------------------------------------------------------------------------
**/

public with sharing class WT_RecordsToProcessFromFileQueuable implements Queueable
{
    ContentVersion createVersion;
    public WT_RecordsToProcessFromFileQueuable(ContentVersion contentVersionObject) 
    {
        this.createVersion = contentVersionObject;
    }
    
    public void execute(QueueableContext context) 
    {
        Map<String,Id> mapGoalMetricsNameAndGoalMetricsToProcess  = new Map<String,Id>();
        Map<String,Id> mapGoalNameAndGoalToProcess = new Map<String,Id>();
        Map<String,Id> mapUserNameAndUserIdToProcess = new Map<String,Id>();
        List<WT_Goal__c> listGoalInsert = new List<WT_Goal__c>();
        List<String> listGoalErrors= new List<String>();
        List<WT_Goals_Import_Process_Log__c> listGoalImportProcessLog = new List<WT_Goals_Import_Process_Log__c>();
        List<WT_Goals_Import_Process_Log__c> listGoalImportErrorLog = new List<WT_Goals_Import_Process_Log__c>();
        List<String> listOfgoalName = new List<String>();
        List<String> listOfGoalMetricName = new List<String>();
        List<String> listOfUserName = new List<String>();
        Set<Decimal> setFailedGoalId = new Set<Decimal>();
        Integer recordNumber = 0;
        Integer countFailedGoalRecord = 0;
        Integer countSuccessfulGoalRecord = 0;
        String jobId = '';
        jobId = context.getJobId();
        
        ContentVersion contentVersionObj = [SELECT 
                                            Id, 
                                            ContentDocumentId,
                                            VersionData 
                                            FROM ContentVersion 
                                            WHERE Id=:createVersion.Id];
        List<String> listOfCsvRecord = contentVersionObj.VersionData.toString().split('\n');
        for(Integer i = 1; i < listOfCsvRecord.size(); i++)
        { 
            if(listOfCsvRecord[i] != '' && listOfCsvRecord[i] != Null)
            {
                String csvRowLine = listOfCsvRecord[i];
                if(String.isNotBlank(csvRowLine))
                {
                    List<String> csvColumnData = WT_FileUploadController.handleColumnComma(csvRowLine);
                    
                    if(string.isNotBlank(csvColumnData[4]) || string.isNotBlank(csvColumnData[5]) || string.isNotBlank(csvColumnData[6]))
                    {
                        listOfgoalName.add(string.valueOf(csvColumnData[4]).trim());
                        listOfGoalMetricName.add(string.valueOf(csvColumnData[5])); 
                        listOfUserName.add(string.valueOf(csvColumnData[6]));
                    }   
                }     
            }   
        }
        
        List<WT_Goal__c> listOfGoal = [ SELECT Id,
                                       Name
                                       FROM WT_Goal__c 
                                       WHERE Name IN: listOfgoalName];
        
        for(WT_Goal__c goalToImport: listOfGoal)
        {
            mapGoalNameAndGoalToProcess.put(goalToImport.Name, goalToImport.Id);
        }
        
        List<WT_Goal_Metric__c> listOfGoalMetric = [SELECT Id, 
                                                    Name,
                                                    WT_Metric_Type__c
                                                    FROM WT_Goal_Metric__c 
                                                    WHERE Name =: listOfGoalMetricName];
        
        for(WT_Goal_Metric__c goalMetric: listOfGoalMetric)
        {
            mapGoalMetricsNameAndGoalMetricsToProcess.put(goalMetric.Name,goalMetric.Id);
        }
        
        List<User> listOfuser = [ SELECT Id, 
                                 Name 
                                 FROM User 
                                 WHERE Name =: listOfUserName];
        
        for(user user: listOfuser)
        {
            mapUserNameAndUserIdToProcess.put(user.Name.toLowerCase(),user.Id);
        }
        
        for(Integer i = 1; i < listOfCsvRecord.size(); i++)
        {  
            WT_Goal__c goalImport = new WT_Goal__c();
            String csvRowDataLine = listOfCsvRecord[i];
            if(String.isNotBlank(csvRowDataLine)) 
            {
                List<String> csvColumnData = WT_FileUploadController.HandleColumnComma(csvRowDataLine);  
                try
                { 
                    if(string.isNotBlank(csvColumnData[0]) || string.isNotBlank(csvColumnData[1]) || string.isNotBlank(csvColumnData[2])|| string.isNotBlank(csvColumnData[3]) || string.isNotBlank(csvColumnData[4]) || string.isNotBlank(csvColumnData[5])|| string.isNotBlank(csvColumnData[6]) || string.isNotBlank(csvColumnData[7]) || string.isNotBlank(csvColumnData[8])|| string.isNotBlank(csvColumnData[9]) || string.isNotBlank(csvColumnData[10]) || string.isNotBlank(csvColumnData[11])|| string.isNotBlank(csvColumnData[12]) || string.isNotBlank(csvColumnData[13]) || string.isNotBlank(csvColumnData[14])|| string.isNotBlank(csvColumnData[15]) || string.isNotBlank(csvColumnData[16]) || string.isNotBlank(csvColumnData[17])|| string.isNotBlank(csvColumnData[18]) || string.isNotBlank(csvColumnData[19]) || string.isNotBlank(csvColumnData[20])|| string.isNotBlank(csvColumnData[21]))
                    {
                        goalImport.Name = csvColumnData[0];
                        Id goalMetricId = mapGoalMetricsNameAndGoalMetricsToProcess.get(string.valueOf(csvColumnData[5]));
                        goalImport.WT_Goal_Metric__c = goalMetricId;
                        if(csvColumnData[18] == 'Count')
                        {
                            String targetInteger = string.valueOf(csvColumnData[2]);
                            if(targetInteger.contains(','))
                            {
                                targetInteger = targetInteger.replace(',','');
                                targetInteger =  targetInteger.trim();
                                goalImport.WT_Target__c = Decimal.valueOf(targetInteger);
                            } 
                            else
                            {
                                targetInteger =  targetInteger.trim();
                                goalImport.WT_Target__c = Decimal.valueOf(targetInteger);
                            }
                        }
                        else if(csvColumnData[18] == 'Amount')
                        {
                            String targetMoney = string.valueOf(csvColumnData[3]);
                            if(targetMoney.contains(',') && targetMoney.contains('$'))
                            {
                                targetMoney = targetMoney.remove('$');
                                targetMoney = targetMoney.replace(',','');
                                targetMoney =  targetMoney.trim();
                                goalImport.WT_Target__c = Decimal.valueOf(targetMoney);
                            } 
                        }
                        Id goalToProcessId  = mapGoalNameAndGoalToProcess.get(string.valueOf(csvColumnData[4]).trim());
                        goalImport.WT_Parent_Goal__c = goalToProcessId;
                        Id userId = mapUserNameAndUserIdToProcess.get(string.valueOf(csvColumnData[6]).toLowerCase());
                        goalImport.WT_Goal_Owner__c = userId;
                        goalImport.WT_RowNumber__c = Integer.valueOf(recordNumber+i);
                        String goalImportFromDate = csvColumnData[9];
                        String goalImportToDate = csvColumnData[10];
                        goalImport.WT_Date_From__c = date.parse(goalImportFromDate);
                        goalImport.WT_Date_To__c = Date.parse(goalImportToDate);
                        goalImport.WT_Should_Roll_Up_From_Child__c = Boolean.valueOf(csvColumnData[11]);
                        goalImport.WT_Goal_Level__c = csvColumnData[17];
                        goalImport.WT_MM_Scorecard_Category__c = csvColumnData[19];
                        goalImport.WT_BB_CB_Scorecard_Category__c = csvColumnData[20];
                        goalImport.WT_CRE_Scorecard_Category__c = csvColumnData[21];
                        listGoalInsert.add(goalImport);
                    }
                }
                catch(Exception exp)
                {
                    countFailedGoalRecord++;
                    String goalFailureMsg = 'Goal insertion failed '+ recordNumber+i +exp.getMessage();
                    WT_Goals_Import_Process_Log__c goalImportProcessLog = new WT_Goals_Import_Process_Log__c();
                    goalImportProcessLog.WT_Excel_Row_Number__c = String.valueOf(recordNumber+i);
                    goalImportProcessLog.WT_Message__c = goalFailureMsg;
                    goalImportProcessLog.WT_Outcome__c = 'Failure';
                    goalImportProcessLog.Queueable_Job_Id__c = jobId;
                    listGoalImportErrorLog.add(goalImportProcessLog);
                }
            }
        }
        if(listGoalImportErrorLog.size() > 0)
        {
            try
            {
                insert listGoalImportErrorLog;
            }
            catch(Exception exp)
            {
                system.debug(exp.getMessage());
            }
        }
        try
        {    
            if(listGoalInsert.size()>0) 
            {
                Integer saveResultIterator = 0;
                Database.SaveResult[] listGoalInsertSaveResult  =  database.insert(listGoalInsert,false);
                for (Database.SaveResult goalRecordInsert : listGoalInsertSaveResult) 
                {
                    if (!goalRecordInsert.isSuccess())
                    {  
                        countFailedGoalRecord++;
                        setFailedGoalId.add(listGoalInsert[saveResultIterator].WT_RowNumber__c);
                        Database.Error goalRecordFailures = goalRecordInsert.getErrors().size()>0?goalRecordInsert.getErrors().get(0):null;
                        if(goalRecordFailures !=null) 
                        { 
                            String goalFailureMsg = 'Goal insertion failed '+listGoalInsert.get(saveResultIterator).WT_RowNumber__c + ', ' + goalRecordFailures.getMessage();
                            WT_Goals_Import_Process_Log__c goalImportProcessLog = new WT_Goals_Import_Process_Log__c();
                            goalImportProcessLog.WT_Excel_Row_Number__c = String.valueOf(listGoalInsert.get(saveResultIterator).WT_RowNumber__c);
                            goalImportProcessLog.WT_Message__c = goalFailureMsg;
                            goalImportProcessLog.WT_Outcome__c = 'Failure';
                            goalImportProcessLog.Queueable_Job_Id__c = jobId;
                            listGoalImportProcessLog.add(goalImportProcessLog);
                        } 
                    }
                    else
                    {
                        countSuccessfulGoalRecord++;
                    }
                    saveResultIterator++;
                } 
                if(listGoalImportProcessLog!=null && listGoalImportProcessLog.size()>0)
                {
                    insert listGoalImportProcessLog;
                } 
            }
        }
        catch (Exception ex) 
        {
            throw new AuraHandledException(ex.getMessage());
        } 
        FileUploadToGoalEvent__e goalFileUploadEvent= new FileUploadToGoalEvent__e();
        goalFileUploadEvent.JobId__c = jobId;
        goalFileUploadEvent.WT_Count_of_Failure_Record__c = countFailedGoalRecord;
        goalFileUploadEvent.WT_Count_of_Success_Record__c = countSuccessfulGoalRecord;
        EventBus.publish(goalFileUploadEvent); 
    }
}