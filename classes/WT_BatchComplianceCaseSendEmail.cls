/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_BatchComplianceCaseSendEmail
* @Author			Vamsi Pulikallu	<VPulikal@wintrust.com>
* @ModifiedBy		Vamsi Pulikallu	<VPulikal@wintrust.com>
* @Version			v1.0
* @CreatedDate		19 Jan 2021
* @ModifiedDate		09 Feb 2021
* @UsedBy			
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is used to send email notifications for Past due and future due Compliance Cases
* --------------------------------------------------------------------------------------------------------------
* @Changes
* v1.0
*--------------------------------------------------------------------------------------------------------------
**/
// Code Coverage: WT_BatchComplianceCaseSendEmail_T
global class WT_BatchComplianceCaseSendEmail implements Database.Batchable<sObject>, Database.Stateful
{
    Map<string,List<Case>> mapOwnerwithPastCases = new Map<string,List<Case>>();
    Map<string,List<Case>> mapOwnerwithFutureCases = new Map<string,List<Case>>();
    List<Case> listCase = New List<Case>();
    set<string> setUserIds = new set<string>();
    set<string> setGroupIds = new set<string>();
    global Database.QueryLocator start(Database.BatchableContext bc) 
    {
        String query = 'SELECT Id, CaseNumber, Description ,WT_Case_Title__c, RecordType.Name , Status, Owner.Name, Owner.Email, OwnerId, WT_Date_Received__c, WT_Respond_By__c FROM Case WHERE RecordType.DeveloperName =\'WT_Compliance_Complaint\' AND (Status = \'In Progress\') AND (WT_Respond_By__c <= TODAY OR WT_Respond_By__c <= NEXT_N_DAYS:3)';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Case> scope)
    {
        for(Case caseRecord : scope) 
        {
            string caseOwner = caseRecord.ownerid;
            boolean isDueDate = false;
            if(caseRecord.WT_Respond_By__c>=system.now() && caseRecord.WT_Respond_By__c<=system.now().addMinutes(4320)){
                isDueDate = true;
            }
            //if the due date is within 3 days
            if(isDueDate)
            {
                if(caseOwner.substring(0,3) == '005')
                {
                    setUserIds.add(caseOwner);
                }
                else if(caseOwner.substring(0,3) == '00G')
                {
                    setGroupIds.add(caseOwner);   
                }
                if(mapOwnerwithFutureCases.get(caseOwner)!=null)
                {
                    listCase = mapOwnerwithFutureCases.get(caseOwner);
                    listCase.add(caseRecord);
                    mapOwnerwithFutureCases.put(caseOwner,listCase);
                }
                else
                {
                    listCase = new List<Case>();
                    listCase.add(caseRecord);
                    mapOwnerwithFutureCases.put(caseOwner,listCase);
                }
            }
            //if the due date is already passed
            else if(caseRecord.WT_Respond_By__c < system.now())
            {
                if(caseOwner.substring(0,3) == '005')
                {
                    setUserIds.add(caseOwner);   
                }
                else if(caseOwner.substring(0,3) == '00G')
                {
                    setGroupIds.add(caseOwner);   
                }
                if(mapOwnerwithPastCases.get(caseOwner)!=null)
                {
                    listCase = mapOwnerwithPastCases.get(caseOwner);
                    listCase.add(caseRecord);
                    mapOwnerwithPastCases.put(caseOwner,listCase);
                }
                else
                {
                    listCase = new List<Case>();
                    listCase.add(caseRecord);
                    mapOwnerwithPastCases.put(caseOwner,listCase);
                }
            }
        }
    }
    global void finish(Database.BatchableContext bc)
    {
        if(!mapOwnerwithPastCases.isEmpty() || !mapOwnerwithFutureCases.isEmpty())
        {
            set<string> setIds = new set<string>();
            setIds.addAll(setUserIds);
            setIds.addAll(setGroupIds);
            Map<id,User> mapUserDetails = new Map<id,User>();
            Map<id,Group> mapGroupDetails = new Map<id,Group>();
            if(setUserIds.size()>0)
            {
                mapUserDetails = New MaP<id,User>([Select id,email,isactive,Name from user where id IN:setUserIds and Isactive=true]);
            }
            if(setGroupIds.size()>0)
            {
                mapGroupDetails = New MaP<id,Group>([Select id,email,Name from group where id IN:setGroupIds]);
            }
            List<Messaging.SingleEmailMessage> listOfMail = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage mail;
            user userRecord;
            Group groupRecord;
            string email = '';
            string name = '';
            List<String> toAddresses;
            List<Case> listPastCases = new List<Case>();
            List<Case> listFutureCases = new List<Case>();
            string td1='"border:1px solid black; width=200px;"';
            string tdHead='"border:1px solid black; width=200px; font-weight:bold;"';
            for(string ownerId:setIds)
            {
                listPastCases = new list<Case>();
                listFutureCases = new list<Case>();
                listPastCases = mapOwnerwithPastCases.get(ownerId);
                listFutureCases = mapOwnerwithFutureCases.get(ownerId);
                mail = new Messaging.SingleEmailMessage();
                toAddresses = new List<String>();
                if(ownerId.subString(0,3) == '005')
                {
                    userRecord = mapUserDetails.get(ownerId);
                    if(userRecord != null && string.isNotBlank(userRecord.email))
                    {
                        email = userRecord.email;
                    }
                    if(userRecord != null && string.isNotBlank(userRecord.name))
                    {
                        name = userRecord.name;
                    }                    
                }
                else if(ownerId.subString(0,3) == '00G')
                {
                    groupRecord = mapGroupDetails.get(ownerId);
                    if(groupRecord != null && string.isNotBlank(groupRecord.email))
                    {
                        email = groupRecord.email;
                    }
                    if(groupRecord != null && string.isNotBlank(groupRecord.name))
                    {
                        name = groupRecord.name;
                    }
                }
                if(string.isNotBlank(email)){
                    toAddresses.add(email);
                    mail.setToAddresses(toAddresses);
                    mail.setSubject('Compliance Pending Complaints '+ date.today());                
                    string htmlBody = '<div><p>Dear '+name+',</p></div>'
                        +'<p>The following complaints are past due or coming due. Please attempt to resolve these issues and update CRM as soon as possible</p>';
                    if(listPastCases != null && listPastCases.size() > 0)
                    {                    
                        htmlBody+='Response Past Due'
                            +'<left><table border="1" style="border-collapse: collapse">'
                            +'<tr><th style='+tdHead+'>Case Number</th>'
                            +'<th style='+tdHead+'>Case Title</th>'
                            +'<th style='+tdHead+'>Date Received</th>'
                            +'<th style='+tdHead+'>Respond By</th>'
                            +'<th style='+tdHead+'>Days Remaining</th>'
                            +'<th style='+tdHead+'>Description</th></tr>';
                        for(Case caseRecord:listPastCases)
                        {
                            datetime respondByDateTime = caseRecord.WT_Respond_By__c;
                            string respondByString = respondByDateTime.format('MM-dd-yyyy');
                            datetime dateTimeReceived = caseRecord.WT_Date_Received__c;
                            string dateReceivedString = dateTimeReceived.formatGMT('MM-dd-yyyy');
                            date respondByDate = Date.valueOf(caseRecord.WT_Respond_By__c);
                            integer numberOfDaysLeft = (system.today()).daysBetween(respondByDate);                        
                            htmlBody += '<tr><td style='+td1+'><a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+caseRecord.id+'">'+caseRecord.CaseNumber+'</a></td>'
                                +'<td style='+td1+'>'+caseRecord.WT_Case_Title__c+'</td>'
                                +'<td style='+td1+'>'+dateReceivedString+'</td>'
                                +'<td style='+td1+'>'+respondByString+'</td>'
                                +'<td style="text-align:center; border:1px solid black; width=200px;">'+numberOfDaysLeft+'</td>'
                                +'<td style='+td1+'>'+caseRecord.Description+'</td></tr>';
                        }                    
                        htmlBody+='</table></left><br/>';
                    }                
                    if(listFutureCases != null && listFutureCases.size() > 0)
                    {
                        htmlBody+='Response Coming Due'
                            +'<left><table border="1" style="border-collapse: collapse">'
                            +'<tr><th style='+tdHead+'>Case Number</th>'
                            +'<th style='+tdHead+'>Case Title</th>'
                            +'<th style='+tdHead+'>Date Received</th>'
                            +'<th style='+tdHead+'>Respond By</th>'
                            +'<th style='+tdHead+'>Days Remaining</th>'
                            +'<th style='+tdHead+'>Description</th></tr>';
                        for(Case caseRecord:listFutureCases)
                        {
                            datetime respondByDateTime = caseRecord.WT_Respond_By__c;
                            string respondByString = respondByDateTime.format('MM-dd-yyyy');
                            datetime dateTimeReceived = caseRecord.WT_Date_Received__c;
                            string dateReceivedString = dateTimeReceived.formatGMT('MM-dd-yyyy');
                            date respondByDate = Date.valueOf(caseRecord.WT_Respond_By__c);
                            integer numberOfDaysLeft = (system.today()).daysBetween(respondByDate);                        
                            htmlBody += '<tr><td style='+td1+'><a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+caseRecord.id+'">'+caseRecord.CaseNumber+'</a></td>'
                                +'<td style='+td1+'>'+caseRecord.WT_Case_Title__c+'</td>'
                                +'<td style='+td1+'>'+dateReceivedString+'</td>'
                                +'<td style='+td1+'>'+respondByString+'</td>'
                                +'<td style="text-align:center; border:1px solid black; width=200px;">'+numberOfDaysLeft+'</td>'
                                +'<td style='+td1+'>'+caseRecord.Description+'</td></tr>';
                        }                    
                        htmlBody+='</table></left><br/>';
                    }
                    mail.setHtmlBody(htmlBody);                
                    listOfMail.add(mail);
                }
                
            }
            if(listOfMail.size()>0)
            {
                Messaging.sendEmail(listOfMail);
            }
        }
    } 
}