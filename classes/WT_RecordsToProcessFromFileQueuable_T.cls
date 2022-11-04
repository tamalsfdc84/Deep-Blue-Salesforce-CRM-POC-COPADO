/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_RecordsToProcessFromFileQueuable_T
* @Author			Krupa Chinthakindi<KChintha@wintrust.com>
* @Version			v1.0
* @CreatedDate		08-08-2022
* -----------------------------------------------------------------------------------------------------------------------------
* @Description
* This test class is for WT_RecordsToProcessFromFileQueuable
* --------------------------------------------------------------------------------------------------------------------------------
* @Changes
* vX.X
* MM-DD-YYYY
* --------------------------------------------------------------------------------------------------------------
**/
@isTest
public class WT_RecordsToProcessFromFileQueuable_T 
{
    @isTest 
    public static void TestRecordsToProcessFromFileQueueable()
    {
        String fromDate = '10/01/2021';
        String toDate = '09/30/2022';
        String[] csvFileLines;
        Blob csvFileBody;
        List<User> listOfUser = new List<User>();
        User user = WT_DataFactory.createUser('WT Business Administrator');
        listOfUser.add(user);
        insert listOfUser; 
        
        WT_Goal_Metric__c goalMetric = new WT_Goal_Metric__c();
        goalMetric.Name = 'test1123';
        goalMetric.WT_Metric_Type__c = 'COUNT';
        goalMetric.WT_CRM_Object_API_Name__c = 'Opportunity';
        goalMetric.WT_CRM_Field_API_Name__c = '';
        goalMetric.WT_InProgress_Result_Criteria__c  = '[{"field":"Amount","operator":"greater than","value":"2000"},{},{},{},{},{},{}]';
        goalMetric.WT_In_Progress_Criteria_Logic__c = '1';
        goalMetric.WT_InProgress_Result_Date_Field_API_Name__c = 'CloseDate';
        system.runAs(user)
        {
          insert goalMetric;
        }
        
        WT_Goal__c goal = new WT_Goal__c();
        goal.Name = 'test123';
        goal.WT_Goal_Metric__c = goalMetric.Id;
        goal.OwnerId = user.Id;
        List<WT_Goal__c> listOfGoal = new List<WT_Goal__c>();
        listOfGoal.add(goal);
        insert listOfGoal;
        
        String goalImportFileData = 'Name,Amount,Target (Integer),Target(Money),Parent Goal,Goal Metric,UserName,Manager,Goal Period,date from,date To,Roll Up Only from Child Goals,Record Set for Rollup,,,,,Goal Type,Metric Type,MM Scorecard Category,BB Scorecard Category,CRE Scorecard Category, \n Test123,40,"40,000",$40,'+listOfGoal[0].Name+','+goalMetric.Name+','+listOfUser[0].Name+',Krupa,LOB Goal,'+fromDate+','+toDate+',,,,,,,LOB Goal,Count,,,, \n Test1223,41,,"$11,000",'+listOfGoal[0].Name+','+goalMetric.Name+','+listOfUser[0].Name+',Krupa,LOB Goal,'+fromDate+','+toDate+',,,,,,,LOB Goal,Amount,,,,';
        
        ContentVersion createVersion=new Contentversion();
        createVersion.title='ABC';
        createVersion.PathOnClient ='test';
        Blob b=Blob.valueOf('Unit Test Attachment Body');
        csvFileBody = Blob.valueOf(goalImportFileData); 
        createVersion.versiondata = csvFileBody;
        insert createVersion;
        
        csvFileBody = Blob.valueOf(goalImportFileData);        
        String csvAsString = EncodingUtil.base64Encode(csvFileBody);
        String filename = 'Test123';
        String base64 = 'Test456';
        csvFileBody = Blob.valueOf(goalImportFileData);
        csvFileLines = csvAsString.split('\n'); 
        
        String jobId = '123456';
        List<WT_Goals_Import_Process_Log__c> listGoalImportLog = new List<WT_Goals_Import_Process_Log__c>();
        WT_Goals_Import_Process_Log__c goalImportLog = new WT_Goals_Import_Process_Log__c();
        goalImportLog.WT_Excel_Row_Number__c = '1';
        goalImportLog.WT_Message__c = 'Test123';
        goalImportLog.WT_Outcome__c = 'Failure';
        goalImportLog.Queueable_Job_Id__c = jobId;
        insert goalImportLog;
        
        Test.startTest();
        System.enqueueJob(new WT_RecordsToProcessFromFileQueuable(createVersion));
        Test.stopTest();
    }
    
    @isTest 
    public static void TestUploadFile()
    {
        String fromDate = '10/01/2021';
        String toDate = '09/30/2022';
        String[] csvFileLines; 
        Blob csvFileBody;
        
        List<User> listOfUser = new List<User>();
        User user = WT_DataFactory.createUser('WT Business Administrator');
        listOfUser.add(user);
        insert listOfUser; 
        
        WT_Goal_Metric__c goalMetric = new WT_Goal_Metric__c();
        goalMetric.Name = 'test1123';
        goalMetric.WT_Metric_Type__c = 'COUNT';
        goalMetric.WT_CRM_Object_API_Name__c = 'Opportunity';
        goalMetric.WT_CRM_Field_API_Name__c = '';
        goalMetric.WT_InProgress_Result_Criteria__c  = '[{"field":"Amount","operator":"greater than","value":"2000"},{},{},{},{},{},{}]';
        goalMetric.WT_In_Progress_Criteria_Logic__c = '1';
        goalMetric.WT_InProgress_Result_Date_Field_API_Name__c = 'CloseDate';
        system.runAs(user)
        {
          insert goalMetric;
        }
        
        WT_Goal__c goal = new WT_Goal__c();
        goal.Name = 'test123';
        goal.WT_Goal_Metric__c = goalMetric.Id;
        goal.OwnerId = user.Id;
        List<WT_Goal__c> listOfGoal = new List<WT_Goal__c>();
        listOfGoal.add(goal);
        insert listOfGoal;
        
        String goalImportFileData = 'Name,Amount,Target (Integer),Target(Money),Parent Goal,Goal Metric,UserName,Manager,Goal Period,date from,date To,Roll Up Only from Child Goals,Record Set for Rollup,,,,,Goal Type,Metric Type,MM Scorecard Category,BB Scorecard Category,CRE Scorecard Category, \n Test123,40,"40,000",$40,'+listOfGoal[0].Name+','+goalMetric.Name+','+listOfUser[0].Name+',Krupa,LOB Goal,'+fromDate+','+toDate+',,,,,,,LOB Goal,Count,,,, \n Test1223,41,,"$11,000",'+listOfGoal[0].Name+','+goalMetric.Name+','+listOfUser[0].Name+',Krupa,LOB Goal,'+fromDate+','+toDate+',,,,,,,LOB Goal,Amount,,,,';
        ContentVersion createVersion=new Contentversion();
        createVersion.title='ABC';
        createVersion.PathOnClient ='test';
        Blob b=Blob.valueOf('Unit Test Attachment Body');
        csvFileBody = Blob.valueOf(goalImportFileData);  
        createVersion.versiondata = csvFileBody; 
        insert createVersion;
        
        csvFileBody = Blob.valueOf(goalImportFileData);        
        String csvAsString = EncodingUtil.base64Encode(csvFileBody);
        String filename = 'Test123';
        String base64 = 'Test456';
        csvFileBody = Blob.valueOf(goalImportFileData);
        csvFileLines = csvAsString.split('\n'); 
        
        String jobId = '123456';
        List<WT_Goals_Import_Process_Log__c> listGoalImportLog = new List<WT_Goals_Import_Process_Log__c>();
        WT_Goals_Import_Process_Log__c goalImportLog = new WT_Goals_Import_Process_Log__c();
        goalImportLog.WT_Excel_Row_Number__c = '1';
        goalImportLog.WT_Message__c = 'Test123';
        goalImportLog.WT_Outcome__c = 'Failure';
        goalImportLog.Queueable_Job_Id__c = jobId;
        listGoalImportLog.add(goalImportLog);
        insert listGoalImportLog;
        
        Test.startTest();
        WT_FileUploadController.uploadFile(csvAsString,filename);
        Test.stopTest();  
    }
    
    @isTest 
    public static void TestgetFailedRecordFromProcessLog()
    {
        String jobId = '123456';
        List<WT_Goals_Import_Process_Log__c> listGoalImportLog = new List<WT_Goals_Import_Process_Log__c>();
        WT_Goals_Import_Process_Log__c goalImportLog = new WT_Goals_Import_Process_Log__c();
        goalImportLog.WT_Excel_Row_Number__c = '1';
        goalImportLog.WT_Message__c = 'Test123';
        goalImportLog.WT_Outcome__c = 'Failure';
        goalImportLog.Queueable_Job_Id__c = jobId;
        listGoalImportLog.add(goalImportLog);
        insert listGoalImportLog;
        Test.startTest();
        WT_FileUploadController.getFailedRecordFromProcessLog(jobId);
        Test.stopTest();
    }
}