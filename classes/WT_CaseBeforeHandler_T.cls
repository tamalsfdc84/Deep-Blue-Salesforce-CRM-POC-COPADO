/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name         WT_CaseBeforeHandler_T
* @Author           Sivaranjani     <sivaranjani.d2@tcs.com.tcsdev> 
* @version      v1.0 
* @CreatedDate      11-26-2020
* @Author           Anitha Jaini     <ajaini@wintrust.com> 
* @version      v1.1 
* @ModifiedDate    12-18-2021
*
* @Author           Francis Xavier     <fxavierd@wintrust.com> 
* @version      v1.2 
* @ModifiedDate    04-20-2022
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
        
        User userRecord1 = WT_DataFactory.createUser('WT Funds');
        insert userRecord1; 
        
        // SGE-9 Create Account
        Account acc = new Account(
            Name = 'TestAcc',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
            .get('Relationship_Group')
            .getRecordTypeId()
        );
        insert acc;
        Contact con = new Contact(
            LastName = 'TestContact',
            AccountId = acc.Id
        );
        insert con;
        
        Case caseRecord = new Case();
        caseRecord.RecordTypeId=complianceRecordType.Id;
        caseRecord.WT_Exception__c='Complex Issue';
        caseRecord.WT_Date_Received__c=Date.Today();
        caseRecord.WT_Case_Title__c='Test Case';
        caseRecord.WT_Non_Customer_Complainant__c='Test';  
        caseRecord.OwnerId = userRecord1.Id;  
        caseRecord.AccountId = acc.Id;
        caseRecord.WT_Customer_Name_CRM__c = acc.Id; 
        insert caseRecord;
        
        WT_Employee__c wtEmp = new WT_Employee__c(
            WT_Email__c = 'test@wt.com'
        );
        insert wtEmp;
        
        // Femi: for my hr case 
        Case caseRecord2 = new Case();
        caseRecord2.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('WT_MyHR').getRecordTypeId();
        caseRecord2.WT_Exception__c='Complex Issue';
        caseRecord.WT_Date_Received__c=Date.Today();
        caseRecord2.WT_Case_Title__c='Test Case';
        caseRecord2.WT_Non_Customer_Complainant__c='Test';  
        caseRecord2.OwnerId = userRecord1.Id;  
        caseRecord2.AccountId = acc.Id;
        caseRecord2.Origin = 'Email';
        caseRecord2.SuppliedEmail = 'test@wt.com';
        //caseRecord2.WT_HRCaseOwner__c = userinfo.getUserId();
        insert caseRecord2;
        
        caseRecord.WT_Exception__c='';
        //added SGE-9
        ContentVersion contentVersion_1 = WT_TestSetupHelper.getContentVersion(caseRecord.Id);
        insert contentVersion_1;
        User userRecord2 = WT_DataFactory.createUser('WT Retail');
        insert userRecord2; 
        system.assertnotEquals(userRecord1.username, userRecord2.username);      
        Test.startTest();
        caseRecord.OwnerId = userRecord2.Id;  
        update caseRecord;
        WT_Case_Note__c newCaseNote = new WT_Case_Note__c();
        newCaseNote.WT_Case__c = caseRecord.id;
        newCaseNote.WT_Note_Category__c = 'Status Update';
        newCaseNote.WT_Type__c ='Resolving';
        newCaseNote.WT_Notes__c='test';
        insert newCaseNote;
        
        Test.stopTest();
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
        //update caseRecord;
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
    
    @isTest
    static void testValidations3()
    {   
        User user = WT_DataFactory.createUser('WT MyHR');
        insert user;
        
        RecordType complianceRecordType= [select id, developerName, Name from RecordType where Name='myHR' and SobjectType='Case'];
        WT_DataFactory.createRequiredCustomSetting();
        Case caseRecord = new Case();
        caseRecord.RecordTypeId=complianceRecordType.Id;
        caseRecord.WT_Exception__c='Complex Issue';
        caseRecord.WT_Date_Received__c=Date.Today();
        caseRecord.WT_Case_Title__c='Test Case';
        caseRecord.WT_Non_Customer_Complainant__c='Test'; 
        caseRecord.Status = 'Pending';
        caseRecord.WT_Topic__c = 'Benefits';
        caseRecord.WT_Action__c = 'Medical';
        system.runAs(user){
            insert caseRecord;
        }
        caseRecord.WT_HRCaseOwner__c = user.Id;
        caseRecord.WT_Topic__c = 'Misc';
        caseRecord.WT_Action__c = 'Misc';
        caseRecord.OwnerId = user.Id;
        try
        {
            system.runAs(user){
                update caseRecord; 
            }
        }
        catch(DmlException e)
        {
            System.debug(e.getMessage());
            System.assertEquals('Update failed. First exception on row 0 with id '+ caseRecord.id +'; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, '+System.Label.WT_Error_on_Cancellation+': []',e.getMessage());
        }
    }  
}