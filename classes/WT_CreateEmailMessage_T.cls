/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name				WT_CreateEmailMessage_T
* @Author			Karishma Keswani	<kkeswani@wintrust.com>
* @version 			v1.0 
* @CreatedDate		15-12-2020
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* This is a test class used for WT_CreateEmailMessage 
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
@isTest
public class WT_CreateEmailMessage_T 
{
    static testmethod void testInvocableEmail()
    {
        Case caseRecord = new Case();
        caseRecord.Status = 'Submitted';
        caseRecord.WT_Resolution_Target__c = Date.Today()-1;
        insert caseRecord;
        
		QueueSobject caseQueue = [SELECT Id, QueueId, SobjectType FROM QueueSobject where SobjectType ='Case' limit 1];
        Group groupRecord = [select id,developername,email,ownerid from group where type = 'Queue' and id=:caseQueue.QueueId limit 1];
        groupRecord.Email = 'test@test.com.invalid';
        update groupRecord;
        
        Case caseRecordQueue = new Case();
        caseRecordQueue.Status = 'Submitted';
        caseRecordQueue.WT_Resolution_Target__c = Date.Today()-1;
        caseRecordQueue.OwnerId = groupRecord.id;
        insert caseRecordQueue;
        
        List<emailTemplate> emailTemplateRecord = [select id, developername, subject,body from emailTemplate limit 1];
        
        List<WT_CreateEmailMessage.FlowInputs> inputFlowList = new List<WT_CreateEmailMessage.FlowInputs>();
        WT_CreateEmailMessage.FlowInputs inputFlow = new WT_CreateEmailMessage.FlowInputs();
        inputFlow.caseRecord = caseRecord;
        inputFlow.emailTemplateDevelperName = emailTemplateRecord[0].developername;
        inputFlow.toAddress = 'test@test.com';
        inputFlow.fromAddress = 'test1@test.com';
        inputFlowList.add(inputFlow);
        
        List<WT_CreateEmailMessage.FlowInputs> inputFlowListCasewithQueue = new List<WT_CreateEmailMessage.FlowInputs>();
        WT_CreateEmailMessage.FlowInputs inputFlowCaseQueue = new WT_CreateEmailMessage.FlowInputs();
        inputFlowCaseQueue.caseRecord = caseRecordQueue;
        inputFlowCaseQueue.emailTemplateDevelperName = emailTemplateRecord[0].developername;
        inputFlowCaseQueue.toAddress = '';
        inputFlowCaseQueue.fromAddress = '';
        inputFlowListCasewithQueue.add(inputFlowCaseQueue);
        
        Test.startTest();
        WT_CreateEmailMessage.CreateMessageOnCase(inputFlowList);
        WT_CreateEmailMessage.CreateMessageOnCase(inputFlowListCasewithQueue);
        Test.stopTest();
        
        EmailMessage MessageRecord = [select id from emailmessage where RelatedToId = : caseRecord.Id];
        system.assertNotEquals(null, MessageRecord);
        
        MessageRecord = [select id from emailmessage where RelatedToId = : caseRecordQueue.Id];
        system.assertNotEquals(null, MessageRecord);
    }
}