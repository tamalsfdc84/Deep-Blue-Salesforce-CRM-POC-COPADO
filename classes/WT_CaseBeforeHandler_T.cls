/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name         WT_CaseBeforeHandler_T
* @Author           Sivaranjani     <sivaranjani.d2@tcs.com.tcsdev> 
* @version      v1.0 
* @CreatedDate      11-26-2020
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* Class is used as test class for WT_caseBeforeHandle,WT_CaseTrigger 
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* FUNCTIONAL TEST LOGIC
* 1- runCaseStatusChangeValidation() 
*   > use to run test validation on status change  checkCaseValidation() function on WT_caseBeforeHandler, for fulfilled and Waiting for Customer status 
* changes on case. 
* 
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
@isTest
public class WT_CaseBeforeHandler_T 
{
    @isTest
    static void setResolutionTargetTest()
    {
      RecordType complianceRecordType= [select id, developerName, Name from RecordType where Name='Compliance Complaint' and SobjectType='Case'];
      WT_DataFactory.createRequiredCustomSetting();
      Case caseRecord = new Case();
      caseRecord.RecordTypeId=complianceRecordType.Id;
      caseRecord.WT_Exception__c='Complex Issue';
      caseRecord.WT_Date_Received__c=Date.Today();
      caseRecord.WT_Case_Title__c='Test Case';
      caseRecord.WT_Non_Customer_Complainant__c='Test';  
      insert caseRecord;
      caseRecord.WT_Exception__c='';
      update caseRecord;
    }
    @isTest
    static void testValidations()
    { 
      RecordType complianceRecordType= [select id, developerName, Name from RecordType where Name='Compliance Complaint' and SobjectType='Case'];
      WT_DataFactory.createRequiredCustomSetting();
      Case caseRecord = new Case();
      caseRecord.RecordTypeId=complianceRecordType.Id;
      caseRecord.WT_Exception__c='Complex Issue';
      caseRecord.WT_Date_Received__c=Date.Today();
      caseRecord.WT_Case_Title__c='Test Case';
      caseRecord.WT_Non_Customer_Complainant__c='Test'; 
      caseRecord.Status = 'Pending';
      insert caseRecord;
      CaseRecord.Status = 'Resolved';
      try
        {
           update caseRecord; 
        }
        catch(DmlException e)
        {
            System.debug(e.getMessage());
            System.assertEquals('Update failed. First exception on row 0 with id '+ caseRecord.id +'; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, '+System.Label.WT_Error_on_Case_Resolved+': []',e.getMessage());
        }
        WT_Case_Note__c newCaseNote = new WT_Case_Note__c();
        newCaseNote.WT_Case__c = caseRecord.id;
        newCaseNote.WT_Note_Category__c = 'Status Update';
        newCaseNote.WT_Type__c ='Resolving';
        newCaseNote.WT_Notes__c='test';
        insert newCaseNote;
        update caseRecord;
    }
    @isTest
    static void testValidations2()
    { 
      RecordType complianceRecordType= [select id, developerName, Name from RecordType where Name='Compliance Complaint' and SobjectType='Case'];
      WT_DataFactory.createRequiredCustomSetting();
      Case caseRecord = new Case();
      caseRecord.RecordTypeId=complianceRecordType.Id;
      caseRecord.WT_Exception__c='Complex Issue';
      caseRecord.WT_Date_Received__c=Date.Today();
      caseRecord.WT_Case_Title__c='Test Case';
      caseRecord.WT_Non_Customer_Complainant__c='Test'; 
      caseRecord.Status = 'Pending';
      insert caseRecord;
      CaseRecord.Status = 'Cancelled';
      try
        {
           update caseRecord; 
        }
        catch(DmlException e)
        {
            System.debug(e.getMessage());
            System.assertEquals('Update failed. First exception on row 0 with id '+ caseRecord.id +'; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, '+System.Label.WT_Error_on_Cancellation+': []',e.getMessage());
        }
        WT_Case_Note__c newCaseNote = new WT_Case_Note__c();
        newCaseNote.WT_Case__c = caseRecord.id;
        newCaseNote.WT_Note_Category__c = 'Status Update';
        newCaseNote.WT_Type__c ='Cancellation';
        newCaseNote.WT_Notes__c='test';
        insert newCaseNote;
        update caseRecord;
    }
}