/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_BatchTaskTMCallCompletedSendEmail
* @Author			Vamsi Pulikallu	<VPulikal@wintrust.com>
* @ModifiedBy		Vamsi Pulikallu	<VPulikal@wintrust.com>
* @Version			v1.0
* @CreatedDate		25 Feb 2021
* @ModifiedDate		25 Feb 2021
* @UsedBy			
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is used to send email notifications to the managers when 14 Day & 60 Day Onboarding calls are completed
* --------------------------------------------------------------------------------------------------------------
* @Changes
* v1.0
*--------------------------------------------------------------------------------------------------------------
**/
//Code Coverage - WT_BatchTaskTMCall_T
public class WT_BatchTaskTMCallCompletedSendEmail implements Database.Batchable<sObject>, Database.Stateful
{
    string query;
    Id tmTaskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('TM_Call').getRecordTypeId();
    set<id> setDay14UserIds = new set<Id>();
    set<id> setDay60UserIds = new set<Id>();
    set<id> setManagerIds = new set<Id>();
    List<Task> listTasks = New List<Task>();
    map<Id,list<emailWrapper>> mapDay14OwnerIdWrapper = new map<Id,list<emailWrapper>> ();
    map<Id,list<emailWrapper>> mapDay60OwnerIdWrapper = new map<Id,list<emailWrapper>> ();
    map<Id,list<emailWrapper>> mapDay14ManagerIdWrapper = new map<Id,list<emailWrapper>> ();
    map<Id,list<emailWrapper>> mapDay60ManagerIdWrapper = new map<Id,list<emailWrapper>> ();
    
    public Database.QueryLocator start(Database.BatchableContext bc) 
    {
        string query = 'Select Id, Subject, OwnerId, Owner.Name, whatid,ActivityDate  FROM task ';
        query += 'where Status = \'Completed\' AND recordtype.DeveloperName = \'TM_Call\' AND ActivityDate = YESTERDAY';
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext bc, List<Task> scope)
    {
        list<Id> listTaskIds = new list<Id>();
        for(Task taskRecord:scope)
        {
            listTaskIds.add(taskRecord.Id);
        }
        list<WT_Activity_Extension__c> listActivity= new list<WT_Activity_Extension__c>();
        map<Id,WT_Activity_Extension__c> mapActivity= new map<Id,WT_Activity_Extension__c>();
        listActivity = [Select Id, WT_TaskId__c,WT_TM_Onboarding_Call__c,WT_TM_Onboarding_Due_Date__c from WT_Activity_Extension__c where WT_TaskId__c IN:listTaskIds];
        for(WT_Activity_Extension__c activityExtension:listActivity)
        {
            mapActivity.put(activityExtension.WT_TaskId__c,activityExtension);
        }
        list<emailWrapper> recordlist = new list<emailWrapper>();
        list<emailWrapper> listDay14OwnerWrapper = new list<emailWrapper>();
        list<emailWrapper> listDay60OwnerWrapper = new list<emailWrapper>();
        map<id,emailWrapper> map14DayEmailWrapper= new map<id,emailWrapper>();
        map<id,emailWrapper> map60DayEmailWrapper= new map<id,emailWrapper>();
        list<Id> listOpportunityIds = new list<Id>();
        list<Opportunity> listOpportunity = new list<Opportunity>();
        for(Task taskRecord:scope)
        {
            WT_Activity_Extension__c activity = new WT_Activity_Extension__c();
            activity = mapActivity.get(taskRecord.Id);
            string opportunityId = taskRecord.whatId;
            if(opportunityId != null && opportunityId.substring(0,3)=='006')
            {
                listOpportunityIds.add(opportunityId);
                if(activity != null && activity.WT_TM_Onboarding_Call__c != null &&
                   activity.WT_TM_Onboarding_Call__c == '14 Days')
                {
                    emailWrapper email14DayWrap = new emailWrapper();
                    email14DayWrap.callDueDate = taskRecord.ActivityDate;
                    email14DayWrap.TaskId = taskRecord.Id;
                    email14DayWrap.OwnerId = taskRecord.OwnerId;
                    email14DayWrap.OwnerName = taskRecord.Owner.Name;
                    email14DayWrap.Subject = taskRecord.Subject;
                    map14DayEmailWrapper.put(opportunityId,email14DayWrap);
                }
                if(activity != null && activity.WT_TM_Onboarding_Call__c != null &&
                   activity.WT_TM_Onboarding_Call__c == '60 Days')
                {
                    emailWrapper email60DayWrap = new emailWrapper();
                    email60DayWrap.callDueDate = taskRecord.ActivityDate;
                    email60DayWrap.TaskId = taskRecord.Id;
                    email60DayWrap.OwnerId = taskRecord.OwnerId;
                    email60DayWrap.OwnerName = taskRecord.Owner.Name;
                    email60DayWrap.Subject = taskRecord.Subject;
                    map60DayEmailWrapper.put(opportunityId,email60DayWrap);
                }
            }
        }
        if(listOpportunityIds.size()>0)
        {
            listOpportunity = [SELECT Id, name, WT_Actual_Close_Date__c, Account.name , Owner.Name, Owner.Email, OwnerId  FROM Opportunity where id in:listOpportunityIds];
            for(Opportunity Opportunityrecord:listOpportunity)
            {
                emailWrapper email14DayWrap = new emailWrapper();
                email14DayWrap = map14DayEmailWrapper.get(Opportunityrecord.Id);
                if(email14DayWrap!= null)
                {                    
                    email14DayWrap.AccountName = Opportunityrecord.Account.name;
                    email14DayWrap.OpportunityName = Opportunityrecord.name;
                    email14DayWrap.OpportunityId = Opportunityrecord.Id;
                    email14DayWrap.OpportunityCloseDate = Opportunityrecord.WT_Actual_Close_Date__c;
                    map14DayEmailWrapper.put(Opportunityrecord.Id,email14DayWrap);
                }
                
                emailWrapper email60DayWrap = new emailWrapper();
                email60DayWrap = map60DayEmailWrapper.get(Opportunityrecord.Id);
                if(email60DayWrap!= null)
                {                    
                    email60DayWrap.AccountName = Opportunityrecord.Account.name;
                    email60DayWrap.OpportunityName = Opportunityrecord.name;
                    email60DayWrap.OpportunityId = Opportunityrecord.Id;
                    email60DayWrap.OpportunityCloseDate = Opportunityrecord.WT_Actual_Close_Date__c;
                    map60DayEmailWrapper.put(Opportunityrecord.Id,email60DayWrap);
                }
            }
        }
        if(listOpportunityIds.size() >0)
        {
            for(Id opportunityId : listOpportunityIds)
            {
                emailWrapper email14DayWrap = new emailWrapper();
                email14DayWrap = map14DayEmailWrapper.get(opportunityId);
                if(email14DayWrap!= null)
                {
                    if(mapDay14OwnerIdWrapper.get(email14DayWrap.OwnerId)!=null)
                    {
                        listDay14OwnerWrapper = mapDay14OwnerIdWrapper.get(email14DayWrap.OwnerId);
                        if(!listDay14OwnerWrapper.contains(email14DayWrap))
                        {
                            listDay14OwnerWrapper.add(email14DayWrap);
                            mapDay14OwnerIdWrapper.put(email14DayWrap.OwnerId,listDay14OwnerWrapper);
                        }                        
                    }
                    else
                    {
                        listDay14OwnerWrapper = new List<emailWrapper>();
                        listDay14OwnerWrapper.add(email14DayWrap);
                        mapDay14OwnerIdWrapper.put(email14DayWrap.OwnerId,listDay14OwnerWrapper);
                    }
                }
                emailWrapper email60DayWrap = new emailWrapper();
                email60DayWrap = map60DayEmailWrapper.get(opportunityId);
                if(email60DayWrap!= null)
                {
                    if(mapDay60OwnerIdWrapper.get(email60DayWrap.OwnerId)!=null)
                    {
                        listDay60OwnerWrapper = mapDay60OwnerIdWrapper.get(email60DayWrap.OwnerId);
                        if(!listDay60OwnerWrapper.contains(email60DayWrap))
                        {                            
                            listDay60OwnerWrapper.add(email60DayWrap);
                            mapDay60OwnerIdWrapper.put(email60DayWrap.OwnerId,listDay60OwnerWrapper);
                        }
                    }
                    else
                    {
                        listDay60OwnerWrapper = new List<emailWrapper>();
                        listDay60OwnerWrapper.add(email60DayWrap);
                        mapDay60OwnerIdWrapper.put(email60DayWrap.OwnerId,listDay60OwnerWrapper);
                    }
                }
            }
        }
        
    }
    public void finish(Database.BatchableContext bc)
    {
        if(mapDay14OwnerIdWrapper!=null || mapDay60OwnerIdWrapper!=null)
        {
            list<emailWrapper> listDay14ManagerWrapper = new list<emailWrapper>();
            list<emailWrapper> listDay60ManagerWrapper = new list<emailWrapper>();            
            setDay14UserIds = mapDay14OwnerIdWrapper.keySet();
            setDay60UserIds = mapDay60OwnerIdWrapper.keySet();
            set<Id> userIds = new set<Id>();
            set<Id> managerIds = new set<Id>();
            userIds.addAll(setDay14UserIds);
            userIds.addAll(setDay60UserIds);
            Map<id,User> mapOwnerDetails = New MaP<id,User>([SELECT id,name,email,isactive,Managerid,Manager.name,Manager.email FROM user WHERE id IN:userIds AND Isactive=true]);
            List<Messaging.SingleEmailMessage> listOfMail = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage mail;
            user userRecord;
            List<String> toAddresses;
            List<emailWrapper> listday14OwnerRecords = new List<emailWrapper>();
            List<emailWrapper> listday60OwnerRecords = new List<emailWrapper>();
            List<emailWrapper> listday14ManagerRecords = new List<emailWrapper>();
            List<emailWrapper> listday60ManagerRecords = new List<emailWrapper>();
            for(Id userId: userIds)
            {
                User userRecord1 = mapOwnerDetails.get(userId);
                if(userRecord1.managerid != null)
                {
                    managerIds.add(userRecord1.managerid);
                    List<emailWrapper> listDay14recordsforMap = new list<emailWrapper>();
                    listDay14recordsforMap = mapDay14OwnerIdWrapper.get(userRecord1.Id);
                    List<emailWrapper> listDay60recordsforMap = new list<emailWrapper>();
                    listDay60recordsforMap = mapDay60OwnerIdWrapper.get(userRecord1.Id);
                    if(listDay14recordsforMap!= null && listDay14recordsforMap != null)
                    {                        
                        for(emailWrapper email60DayWrap:listDay14recordsforMap)
                        {
                            if(mapDay14ManagerIdWrapper.get(userRecord1.managerId)!=null)
                            {
                                listDay14ManagerWrapper = mapDay14ManagerIdWrapper.get(userRecord1.managerId);
                                listDay14ManagerWrapper.add(email60DayWrap);
                                mapDay14ManagerIdWrapper.put(userRecord1.managerId,listDay14ManagerWrapper);
                            }
                            else
                            {
                                listDay14ManagerWrapper = new List<emailWrapper>();
                                listDay14ManagerWrapper.add(email60DayWrap);
                                mapDay14ManagerIdWrapper.put(userRecord1.managerId,listDay14ManagerWrapper);
                            }
                        }
                    }
                    if(listDay60recordsforMap!= null && listDay60recordsforMap.size()>0)
                    {
                        for(emailWrapper email60DayWrap:listDay60recordsforMap)
                        {
                            if(mapDay60ManagerIdWrapper.get(userRecord1.managerId)!=null)
                            {
                                listDay60ManagerWrapper = mapDay60ManagerIdWrapper.get(userRecord1.managerId);
                                listDay60ManagerWrapper.add(email60DayWrap);
                                mapDay60ManagerIdWrapper.put(userRecord1.managerId,listDay60ManagerWrapper);
                            }
                            else
                            {
                                listDay60ManagerWrapper = new List<emailWrapper>();
                                listDay60ManagerWrapper.add(email60DayWrap);
                                mapDay60ManagerIdWrapper.put(userRecord1.managerId,listDay60ManagerWrapper);
                            }
                        }
                    }                    
                }
            }
            string td1='"border:1px solid black; width=200px;"';
            string tdHead='"border:1px solid black; width=200px; font-weight:bold;"';
            if(managerIds != null)
            {
                Map<id,User> mapManagerDetails = New MaP<id,User>([SELECT id,email,isactive,name FROM user WHERE id IN:managerIds AND Isactive=true]);                
                for(Id ownerId:managerIds)
                {
                    listday14ManagerRecords = new list<emailWrapper>();
                    listday60ManagerRecords = new list<emailWrapper>();
                    listday14ManagerRecords = mapDay14ManagerIdWrapper.get(ownerId);
                    listday60ManagerRecords = mapDay60ManagerIdWrapper.get(ownerId);
                    mail = new Messaging.SingleEmailMessage();
                    toAddresses = new List<String>();
                    userRecord = mapManagerDetails.get(ownerId);
                    toAddresses.add(userRecord.email);
                    mail.setToAddresses(toAddresses);
                    mail.setSubject('Subject: Your Team\'s TM Onboarding Calls - Completed');                
                    string htmlBody = '<div><p>Dear '+userRecord.name+',</p></div>'
                        +'<p>The following TM Onboarding Calls have been completed by members of your team.</p></n></n>';
                    if(listday14ManagerRecords != null && listday14ManagerRecords.size() > 0)
                    {                    
                        htmlBody+='14 Day Onboarding Call:</n>'
                            +'<left><table border="1" style="border-collapse: collapse">'
                            +'<tr><th style='+tdHead+'>Owner</th>'
                            +'<th style='+tdHead+'>Account Name</th>'
                            +'<th style='+tdHead+'>Call Due Date</th>'
                            +'<th style='+tdHead+'>Subject</th>'
                            +'<th style='+tdHead+'>Sales Opportunity</th>'
                            +'<th style='+tdHead+'>Opportunity Close Date</th>';
                        for(emailWrapper emailWrap:listday14ManagerRecords)
                        {
                            htmlBody += '<tr>'
                                +'<td style='+td1+'>'+emailWrap.OwnerName+'</td>'
                                +'<td style='+td1+'>'+emailWrap.AccountName+'</td>'
                                +'<td style='+td1+'>'+emailWrap.callDueDate+'</td>'
                                +'<td style='+td1+'>'+'<br/><a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+emailWrap.TaskId+'">'+emailWrap.Subject+'</a>'+'</td>'
                                +'<td style='+td1+'>'+'<br/><a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+emailWrap.OpportunityId+'">'+emailWrap.OpportunityName+'</a>'+'</td>'
                                +'<td style='+td1+'>'+emailWrap.OpportunityCloseDate+'</td></tr>';
                        }                    
                        htmlBody+='</table></left><br/>';
                    }                
                    if(listday60ManagerRecords != null && listday60ManagerRecords.size() > 0)
                    {                    
                        htmlBody+='60 Day Onboarding Call:</n>'
                            +'<left><table border="1" style="border-collapse: collapse">'
                            +'<tr><th style='+tdHead+'>Owner</th>'
                            +'<th style='+tdHead+'>Account Name</th>'
                            +'<th style='+tdHead+'>Call Due Date</th>'
                            +'<th style='+tdHead+'>Subject</th>'
                            +'<th style='+tdHead+'>Sales Opportunity</th>'
                            +'<th style='+tdHead+'>Opportunity Close Date</th>';
                        for(emailWrapper emailWrap:listday60ManagerRecords)
                        {
                            htmlBody += '<tr>'
                                +'<td style='+td1+'>'+emailWrap.OwnerName+'</td>'
                                +'<td style='+td1+'>'+emailWrap.AccountName+'</td>'
                                +'<td style='+td1+'>'+emailWrap.callDueDate+'</td>'
                                +'<td style='+td1+'>'+'<br/><a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+emailWrap.TaskId+'">'+emailWrap.Subject+'</a>'+'</td>'
                                +'<td style='+td1+'>'+'<br/><a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+emailWrap.OpportunityId+'">'+emailWrap.OpportunityName+'</a>'+'</td>'
                                +'<td style='+td1+'>'+emailWrap.OpportunityCloseDate+'</td></tr>';
                        }                    
                        htmlBody+='</table></left><br/>';
                    }
                    htmlBody+='Sincerely, <br/>'
                        +'CRM Support <br/>'
                        +'crmsupport@wintrust.com';
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
    public class emailWrapper
    {
        public string AccountName { get; set;}
        public date callDueDate { get; set;}
        public string Subject { get; set;}
        public string TaskId { get; set;}
        public string OwnerId { get; set;}
        public string OwnerName { get; set;}
        public string OpportunityName { get; set;}
        public string OpportunityId { get; set;}
        public datetime OpportunityCloseDate {get; set;}
    }
}