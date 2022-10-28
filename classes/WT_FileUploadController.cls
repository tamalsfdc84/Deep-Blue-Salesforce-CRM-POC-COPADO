/**
* --------------------------------------------------------------------------------------------------------------------------------------------------------
* @Name				WT_FileUploadController
* @Author			Krupa Chinthakindi<KChintha@wintrust.com>
* @ModifiedBy		Krupa Chinthakindi<KChintha@wintrust.com>
* @Version			v1.0
* @CreatedDate		07-20-2022
----------------------------------------------------------------------------------------------------------------------------------------------------------
* Description:      This method is to process the goal import file to get the record count and queueable jobID and send the response to the LWC Component.
* Code Coverage     WT_RecordsToProcessFromFileQueuable_T 
-----------------------------------------------------------------------------------------------------------------------------------------------------------
@Changes
* vX.X
* MM-DD-YYYY
* ---------------------------------------------------------------------------------------------------------------------------------------------------------
**/
public with sharing class WT_FileUploadController 
{
    /**
*-------------------------------------------------------------------------------------------------------------------------------------------------------
*@Description
*This method is to process the goal import file to get the record count and queueable jobID and send the response to the LWC Component.
--------------------------------------------------------------------------------------------------------------------------------------------------------
*@param     fileFormatInBase64      base64 string that represents the file
*@param     fileName                full file name with extension
*@return    UploadResponseModel     Class    
*-----------------------------------------------------------------------------------------------------------------------------------------
*/
    @AuraEnabled
    public static UploadResponseModel UploadFile(String fileFormatInBase64, String fileName) 
    {
        UploadResponseModel responseModel = new UploadResponseModel(); 
        Integer totalRecordsToProcess = 0;
        Integer emptyRowCount = 0;
        Integer actualRecordCount = 0;
        String  jobId = '';
        ContentVersion createVersion = CreateContentVersion(fileFormatInBase64, fileName);
        ContentVersion contentVersionObj = [SELECT Id, 
                                            ContentDocumentId,
                                            VersionData 
                                            FROM ContentVersion 
                                            WHERE Id=:createVersion.Id];
        List<String> listCsvRecord = contentVersionObj.VersionData.toString().split('\n');
        Integer totalRecordCount = listCsvRecord.size() - 1; // just to avoid column headings
        for(Integer i = 1; i < listCsvRecord.size(); i++)
        {
            if(listCsvRecord[i] != '' && listCsvRecord[i] != Null)
            {
                String csvRowLine =listCsvRecord[i];
                if(String.isNotBlank(csvRowLine))
                {
                    List<String> csvColumnData = WT_FileUploadController.HandleColumnComma(csvRowLine);
                    if(string.isNotBlank(csvColumnData[0]) || string.isNotBlank(csvColumnData[1]) || string.isNotBlank(csvColumnData[2])|| string.isNotBlank(csvColumnData[3]) || string.isNotBlank(csvColumnData[4]) || string.isNotBlank(csvColumnData[5])|| string.isNotBlank(csvColumnData[6]) || string.isNotBlank(csvColumnData[7]) || string.isNotBlank(csvColumnData[8])|| string.isNotBlank(csvColumnData[9]) || string.isNotBlank(csvColumnData[10]) || string.isNotBlank(csvColumnData[11])|| string.isNotBlank(csvColumnData[12]) || string.isNotBlank(csvColumnData[13]) || string.isNotBlank(csvColumnData[14])|| string.isNotBlank(csvColumnData[15]) || string.isNotBlank(csvColumnData[16]) || string.isNotBlank(csvColumnData[17])|| string.isNotBlank(csvColumnData[18]) || string.isNotBlank(csvColumnData[19]) || string.isNotBlank(csvColumnData[20])|| string.isNotBlank(csvColumnData[21]))
                    {
                        totalRecordsToProcess++;
                    }
                    else
                    {
                        emptyRowCount++;
                    }
                }
            }
        }
        actualRecordCount = totalRecordCount - emptyRowCount;
        if(createVersion !=null)
        {
            jobId = System.enqueueJob(new WT_RecordsToProcessFromFileQueuable(createVersion));
        }
        responseModel.countRecordToProcess = actualRecordCount;
        responseModel.queueableJobId = jobId;
        return responseModel;
    }
    
    /**
*-----------------------------------------------------------------------------------------------------------------------------------------
*@Description
*Creates a content version from a given file's base64 and filename
------------------------------------------------------------------------------------------------------------------------------------------
*@param     fileFormatInBase64              base64 string that represents the file
*@param     filename                        full file name with extension
*@return    ContentVersion                  returns the newly created ContentVersion otherwise returns null
*-----------------------------------------------------------------------------------------------------------------------------------------
*/
    public static ContentVersion CreateContentVersion(String fileFormatInBase64, String filename) 
    {
        ContentVersion contentVersion = new ContentVersion();
        contentVersion.VersionData = EncodingUtil.base64Decode(fileFormatInBase64);
        contentVersion.Title = filename;
        contentVersion.PathOnClient = filename;
        try
        {
            insert contentVersion;   
        }
        catch(Exception ex) 
        {
            System.debug(ex.getMessage());
        }
        return contentVersion;
    }
    
    /**
*-----------------------------------------------------------------------------------------------------------------------------------------
*@Description
* Returns the list of failure records from WT_Goals_Import_Process_Log__c object and sends to Lwc component
------------------------------------------------------------------------------------------------------------------------------------------
*@param     jobId         queuable Job Id   
*-----------------------------------------------------------------------------------------------------------------------------------------
*/
    @AuraEnabled
    public static List<WT_Goals_Import_Process_Log__c> GetFailedRecordFromProcessLog(String jobId)
    {
        List<WT_Goals_Import_Process_Log__c> listGoalImportProcessLog = new List<WT_Goals_Import_Process_Log__c>();
        if(jobId!=null || jobId!='')
        {
            List<WT_Goals_Import_Process_Log__c> listOfGoalProcessLog = [SELECT id,
                                                                         Name,
                                                                         WT_Message__c,
                                                                         WT_Outcome__c,
                                                                         WT_Excel_Row_Number__c,
                                                                         Queueable_Job_Id__c
                                                                         FROM WT_Goals_Import_Process_Log__c
                                                                         WHERE Queueable_Job_Id__c =:jobId];
            
            for(WT_Goals_Import_Process_Log__c goalImportLog: listOfGoalProcessLog)
            {
                listGoalImportProcessLog.add(goalImportLog); 
            } 
        }
        return listGoalImportProcessLog;
    }
  
    public class UploadResponseModel 
    {
        @AuraEnabled public Integer countRecordToProcess;
        @AuraEnabled public String queueableJobId;
    }
    
    /**
*-----------------------------------------------------------------------------------------------------------------------------------------
*@Description
* Handle the commas from csv file columns 
------------------------------------------------------------------------------------------------------------------------------------------
*@param     csvRowLine         csv file Row   
*-----------------------------------------------------------------------------------------------------------------------------------------
*/
    public static List<String> HandleColumnComma(String csvRowLine)
    {
        List<String> csvColumnData = new List<String>();
        if(String.isNotBlank(csvRowLine))
        {
            Integer startIndex;
            Integer endIndex;
            while(csvRowLine.indexOf('"') > -1)
            {
                if(startIndex == null)
                {
                    startIndex = csvRowLine.indexOf('"');
                    csvRowLine = csvRowLine.substring(0, startIndex) + ':quotes:' + csvRowLine.substring(startIndex+1, csvRowLine.length());
                }
                else
                {
                    if(endIndex == null)
                    {
                        endIndex = csvRowLine.indexOf('"');
                        csvRowLine = csvRowLine.substring(0, endIndex) + ':quotes:' + csvRowLine.substring(endIndex+1, csvRowLine.length());
                    }
                }
                if(startIndex != null && endIndex != null)
                {
                    String rowDataSubString = csvRowLine.substring(startIndex, endIndex);
                    rowDataSubString = rowDataSubString.replaceAll(',', ':comma:');
                    csvRowLine = csvRowLine.substring(0, startIndex) + rowDataSubString + csvRowLine.substring(endIndex, csvRowLine.length());
                    startIndex = null;
                    endIndex = null;
                }
            }
            for(String csvColumn : csvRowLine.split(','))
            {
                csvColumn = csvColumn.replaceAll(':quotes:', '').replaceAll(':comma:', ',');
                csvColumnData.add(csvColumn);
            }
        }
        return csvColumnData;
    }
}