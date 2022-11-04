/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_BatchHRCaseSendEmail
* @Author			Vamsi Pulikallu	<VPulikal@wintrust.com>
* @ModifiedBy		Vamsi Pulikallu	<VPulikal@wintrust.com>
* @Version			v1.0
* @CreatedDate		15 June 2021
* @ModifiedDate		28 June 2021
* @UsedBy			
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is used to send email notifications for SLA breached HR Cases
* --------------------------------------------------------------------------------------------------------------
* @Changes
* v1.0
*  Femi: Added 'In Progress' to the  query 
*--------------------------------------------------------------------------------------------------------------
**/
// Code Coverage:  WT_BatchHRCaseSendEmail_T
global class  WT_BatchHRCaseSendEmail implements Database.Batchable<sObject>, Database.Stateful
{
    Map<string,List<Case>> mapOwnerwithPastCases = new Map<string,List<Case>>();
    Map<string,List<Case>> mapOwnerwithFutureCases = new Map<string,List<Case>>();
    List<Case> listCase = New List<Case>();
    set<string> setUserIds = new set<string>();
    set<string> setGroupIds = new set<string>();
    
    global Database.QueryLocator start(Database.BatchableContext bc) 
    {
        
        String query = 'SELECT Id, Createddate, WT_Case_Title__c, RecordType.Name , Status, Owner.Name, Owner.Email, OwnerId, WT_Date_Received__c, WT_Respond_By__c,WT_Employee__c,WT_Employee__r.Name,WT_EmployeeIDs__c,CaseNumber FROM Case WHERE RecordType.DeveloperName =\'WT_MyHR\' AND (Status IN( \'In Queue\',\'In Process\',\'In Progress\',\'Escalated\')) AND (WT_Respond_By__c < TOMORROW) ORDER BY Owner.Name, WT_Respond_By__c NULLS LAST';
        return Database.getQueryLocator(query);
        
    }
    global void execute(Database.BatchableContext bc, List<Case> scope)
    {
        
        for(Case caseRecord : scope) 
        {
            //if the SLA date is already passed
            if(caseRecord.WT_Respond_By__c < system.now())
            {
                listCase.add(caseRecord);
            }
        }
    }
    global void finish(Database.BatchableContext bc)
    {
        string toEmail = system.label.WT_HR_Cases_Recipients;
        list<string> toEMailList = new list<string>();
        string td1='"border:1px solid black; width=200px;"';
        string tdHead='"border:1px solid black; width=200px; font-weight:bold;"';        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<Messaging.SingleEmailMessage> listOfMail = new List<Messaging.SingleEmailMessage>();        
        mail.setSubject('MYHR Breached Cases ');                
        string htmlBody = '<div><p>Dear MYHR Representative,</p></div>'
            +'<p>The following SLA\'s have been breached.</p>'
            +'<p>SLA Status: '+date.today()+'</p>'
            +'<p>Case Type: MYHR </p>';
        htmlBody+= +'<left><table border="1" style="border-collapse: collapse">'
            +'<tr><th style='+tdHead+'>Opened Date</th>'
            +'<th style='+tdHead+'>SLA Status</th>'
            +'<th style='+tdHead+'>SLA Due Date</th>'
            +'<th style='+tdHead+'>Days Breached</th>'
            +'<th style='+tdHead+'>Case Title</th>'
            +'<th style='+tdHead+'>Status</th>'
            +'<th style='+tdHead+'>Employee</th>'
            +'<th style='+tdHead+'>Employee ID</th>'
            +'<th style='+tdHead+'>HR Rep</th>'
            +'<th style='+tdHead+'>Case Number</th></tr>';
        Organization org =[SELECT IsSandbox FROM Organization];
        if(org.IsSandbox)
        {
            // toEmailList = new List<String>{'lkilbridge@wintrust.com', 'jmirza@wintrust.com', 'mslaviero@wintrust.com'};
            toEmailList = new List<String>{'mslaviero@wintrust.com'};
        }
        else
        {
            toEMailList = toEmail.split(',');            
        }      
        mail.setToAddresses(toEMailList);
        for(Case caseRecord : listCase) 
        {
            //if the SLA date is already passed
            if(caseRecord.WT_Respond_By__c < system.now())
            {
                datetime createdDateTime = caseRecord.CreatedDate;
                string createdDateString = createdDateTime.format('MM-dd-yyyy');
                datetime dateTimeReceived;
                string dateReceivedString = '';
                if(caseRecord.WT_Respond_By__c != null)
                {
                    dateTimeReceived = caseRecord.WT_Respond_By__c;
                    dateReceivedString = dateTimeReceived.format('MM-dd-yyyy');
                }
                date respondByDate = Date.valueOf(caseRecord.WT_Respond_By__c);
                integer numberOfDaysLeft = (system.today()).daysBetween(respondByDate);                        
                htmlBody += '<tr>'
                    +'<td style='+td1+'>'+createdDateString+'</td>'
                    +'<td style='+td1+'>Breached</td>'
                    +'<td style='+td1+'>'+dateReceivedString+'</td>'
                    +'<td style="text-align:center; border:1px solid black; width=200px;">'+numberOfDaysLeft+'</td>'
                    +'<td style='+td1+'>'+caseRecord.WT_Case_Title__c+'</td>'
                    +'<td style='+td1+'>'+caseRecord.Status+'</td>'
                    +'<td style='+td1+'>'+caseRecord.WT_Employee__r.Name+'</td>'
                    +'<td style='+td1+'>'+caseRecord.WT_EmployeeIDs__c+'</td>'
                    +'<td style='+td1+'>'+caseRecord.Owner.Name+'</td>'//hr rep
                    +'<td style='+td1+'><a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+caseRecord.id+'">'+caseRecord.CaseNumber+'</a></td></tr>';
            }
        }
        htmlBody+='</table></left><br/><br/>';
        htmlBody+='Sincerely<br/>';
        htmlBody+='CRM Support<br/>';
        htmlBody+='crmsupport@wintrust.com';
        mail.setHtmlBody(htmlBody);                
        listOfMail.add(mail);
        Messaging.sendEmail(listOfMail);
    } 
}