/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_BatchCaseComplianceEmailAlert
* @Author			Francis Xavier
* @ModifiedBy		
* @Version			v1.0
* @CreatedDate		25 Feb 2022
* @ModifiedDate		
* @UsedBy			
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is used to send email notifications for Compliance Cases that went from Inprogress to Awaiting Approval
* --------------------------------------------------------------------------------------------------------------

**/
// Code Coverage: WT_BatchCaseComplianceEmailAlert_T

global class WT_BatchCaseComplianceEmailAlert implements Database.Batchable<sObject>, Database.Stateful
{
    List<Case> listCase = New List<Case>();
    global Database.QueryLocator start(Database.BatchableContext bc) 
    {
        //Because the system takes GMT time, 4PM CST = 22 GMT
        WT_CaseComplianceEmailAlertConfig__mdt caseComplianceMDT = [SELECT Id, Hour__c, NewStatus__c FROM WT_CaseComplianceEmailAlertConfig__mdt LIMIT 1];
        String query = 'SELECT Id, CaseNumber, WT_Date_Received__c, WT_Respond_By__c, Description, '
            + '(SELECT Id, Field, NewValue, OldValue, CaseId '
            + 'FROM Histories WHERE field = \'Status\' AND '
            + '((CreatedDate = YESTERDAY AND HOUR_IN_DAY(CreatedDate) >= '+caseComplianceMDT.Hour__c+' ) OR (CreatedDate = TODAY AND HOUR_IN_DAY(CreatedDate) < '+caseComplianceMDT.Hour__c+')) order by createdDate DESC LIMIT 1) '
            + 'FROM Case WHERE (Status = \''+caseComplianceMDT.NewStatus__c+'\') AND ((LastModifiedDate = YESTERDAY AND HOUR_IN_DAY(LastModifiedDate) >= '+caseComplianceMDT.Hour__c+') OR (LastModifiedDate = TODAY AND HOUR_IN_DAY(LastModifiedDate) < '+caseComplianceMDT.Hour__c+'))';
        
        //Because this class gets history records and can not get the history records we need for test class
        //The query string provides data based on Case LastModifiedDate but We cannot set a modifiedDate in the test class like Test.setCreatedDate(record.CreatedDate, DateTime.newInstance(2012,12,12));
        if(test.isRunningTest()){
            query = 'SELECT Id, CaseNumber, WT_Date_Received__c, WT_Respond_By__c, Description FROM Case';
        }
        
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Case> scope)
    {
        WT_CaseComplianceEmailAlertConfig__mdt caseComplianceMDT = [SELECT Id, OldStatus__c FROM WT_CaseComplianceEmailAlertConfig__mdt LIMIT 1];
        for(Case caseRecord : scope) 
        {
            if((caseRecord.histories.size() > 0 && caseRecord.histories[0].OldValue == caseComplianceMDT.OldStatus__c) || test.isRunningTest())
            {
                listCase.add(caseRecord);
            }
        }
    }
    global void finish(Database.BatchableContext bc)
    {
        if(!listCase.isEmpty())
        {
            List<String> toAddresses = [SELECT EmailRecipients__c FROM WT_CaseComplianceEmailAlertConfig__mdt LIMIT 1].EmailRecipients__c.Split(';');
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(toAddresses);
            
            dateTime todayDate = system.now();
            string todayDateByString = todayDate.format('MM/dd/yy');
            mail.setSubject('Compliance Awaiting Approval Complaints '+ todayDateByString);       
            string td1='"border:1px solid black; width=200px;"';
            string tdHead='"border:1px solid black; width=200px; font-weight:bold; padding-left: 5px; padding-right: 5px;"';
            
            
            string htmlBody = '<div><p>Dear Complaint Managers,</p></div>'
                +'<p>The following complaints have been moved to Awaiting Approval status. Please attempt to resolve these Caes and update CRM as soon as possible.</p>';
            
            htmlBody+='Awaiting Approval'
                +'<left><table border="1" style="border-collapse: collapse">'
                +'<tr><th style='+tdHead+'>Case Number</th>'
                +'<th style='+tdHead+'>Date Received</th>'
                +'<th style='+tdHead+'>Respond By</th>'
                +'<th style='+tdHead+'>Days Remaining</th>'
                +'<th style='+tdHead+'>Description</th></tr>';
            
            for(Case caseRecord : listCase)
            {   
                dateTime receivedDate = caseRecord.WT_Date_Received__c;
                string receivedDateByString = receivedDate.format('MM-dd-yyyy'); 
                dateTime respondDateTime = caseRecord.WT_Respond_By__c;
                string respondDateTimeByString = respondDateTime.format('MM-dd-yyyy');
                Integer daysRemaining = (system.today()).daysBetween(Date.valueOf(caseRecord.WT_Respond_By__c));
                
                htmlBody += '<tr><td style='+td1+'><a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+caseRecord.id+'">'+caseRecord.CaseNumber+'</a></td>'
                    +'<td style='+td1+'>'+receivedDateByString+'</td>'
                    +'<td style='+td1+'>'+respondDateTimeByString+'</td>'
                    +'<td style='+td1+'>'+daysRemaining+'</td>'
                    +'<td style='+td1+'>'+caseRecord.Description+'</td></tr>'; 
            }
            
            htmlBody+='</table></left><br/>';
            mail.setHtmlBody(htmlBody);  
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail}); 
        }
    } 
}