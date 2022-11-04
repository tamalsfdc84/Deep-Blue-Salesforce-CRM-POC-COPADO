/**
* --------------------------------------------------------------------------------------------------------------
* @Name             WT_AttachmentAfterHandler_T 
* @Author           Femi Onakoya    <fonakoya@wintrust.com>
* @ModifiedBy       
* @Version          v1.0
* @CreatedDate      07-18-2022
* @UsedBy           t
* --------------------------------------------------------------------------------------------------------------
* @Description
* This  class to is used to test WT_AttachmentAfterHandler 
* --------------------------------------------------------------------------------------------------------------
* @Changes
* vX.X
* MM-DD-YYYY
* --------------------------------------------------------------------------------------------------------------
**/

@isTest
public class WT_AttachmentAfterHandler_T
{
    
    static testMethod void attachmentConvertTOFileTest()
    {
        WT_Switch_Settings__c switchRecord = new WT_Switch_Settings__c(WT_Is_Process_Builder_Active__c=true,WT_Is_Trigger_Active__c=true,WT_Is_Validation_Rule_Active__c=false,WT_Is_Workflow_Rule_Active__c=true);
        insert switchRecord;
        
        List<Case> listOfCase = new List<case>();
        List<Attachment> listOfAttachment = new List<Attachment>();
        
        case caseRec = new case();
        caseRec.Origin = 'Email';
        caseRec.WT_Date_of_Request_Received__c = system.today();
        listOfCase.add(caseRec);
        INSERT listOfCase;
        
        EmailMessage email = new EmailMessage();
        email.FromAddress = 'test@abc.org';
        email.Incoming = True;
        email.ToAddress= 'test@xyz.org';
        email.Subject = 'Test email';
        email.HtmlBody = 'Test email body';
        email.ParentId = caseRec.Id; 
        email.CreatedDate = system.today();
        INSERT email;
        
        system.assertEquals(email.ParentId, caseRec.Id);
        
        Attachment attachmentRecord=new Attachment();       
        attachmentRecord.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attachmentRecord.body=bodyBlob;
        attachmentRecord.parentId=email.Id;
        attachmentRecord.ContentType = '.Wav';
        listOfAttachment.add(attachmentRecord);
        INSERT listOfAttachment;
        
        System.assertNotEquals(null, listOfAttachment[0].Id);
        
        Test.startTest(); 
        WT_AttachmentAfterHandler handler = new WT_AttachmentAfterHandler();
        handler.listOfNewAttachments = listOfAttachment;
        handler.ConvertAttachmentToFile();
        Test.stopTest();
    }
    
}