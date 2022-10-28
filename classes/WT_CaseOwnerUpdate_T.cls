/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name             WT_CaseOwnerUpdate_T
* @Author           Francis Xavier     <fxavierd@wintrust.com> 
* @version          v1.0 
* @CreatedDate      04-20-2022
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* Class is used as test class for WT_CaseOwnerUpdate 
* ---------------------------------------------------------------------------------------------------------------------------------------------------
**/

@isTest
public class WT_CaseOwnerUpdate_T {
    
    @isTest
    static void setResolutionTargetTest()
    {
        RecordType complianceRecordType= [select id, developerName, Name from RecordType where Name='Compliance Complaint' and SobjectType='Case'];
        WT_DataFactory.createRequiredCustomSetting();
        
        User userRecord = WT_DataFactory.createUser('WT Funds');
        insert userRecord; 
        
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
        caseRecord.OwnerId = userRecord.Id;  
        caseRecord.AccountId = acc.Id;
        caseRecord.WT_Customer_Name_CRM__c = acc.Id; 
        
        try
        {
            insert caseRecord; 
            String updatedCaseRecordId = WT_CaseOwnerUpdate.setOwnerId(caseRecord.Id);
            System.assertEquals(updatedCaseRecordId, caseRecord.Id);
        }
        catch(DmlException e)
        {
            System.debug(e.getMessage());
            System.assertEquals('Update failed. First exception on row 0 with id '+ caseRecord.id +'; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, '+System.Label.WT_Error_on_Case_Resolved+': []',e.getMessage());
        }
    }
}