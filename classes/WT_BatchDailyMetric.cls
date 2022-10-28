/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_BatchDailyMetric
* @Author			Himanshu Patel	<hpatel1@wintrust.com>
* @ModifiedBy		Himanshu Patel	<hpatel1@wintrust.com>
* @Version			v1.0
* @CreatedDate		06-21-2021
* @UsedBy			
* --------------------------------------------------------------------------------------------------------------
* @Description
* This job consolidates the various metrics that business is looking for and sends out an email with the summary
*
*
* --------------------------------------------------------------------------------------------------------------
* @Changes
* v1.0
* 06-21-2021
* --------------------------------------------------------------------------------------------------------------
**/
// Code Coverage: WT_BatchDailyMetric_T
global class WT_BatchDailyMetric implements Database.Batchable<sobject>, Database.Stateful, Database.AllowsCallouts
{    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {	
        Date today = System.today();        
        DescribeSObjectResult describeResult = WT_Daily_Metric__c.getSObjectType().getDescribe();	
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );	
        String query = ' SELECT ' + String.join( fieldNames, ',' ) +
            ' FROM ' +	      
            describeResult.getName() +
            ' WHERE ' +
            ' WT_Report_Date__c =: today AND WT_Date_Processed__c = null ' + 
            ' LIMIT 1';
        
        return Database.getQueryLocator(
            query
        );
    }
    
    global void execute(Database.BatchableContext bc, List<sObject> scope) 
    {  
        Id craCallRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('CRA Call').getRecordTypeId();
        Id standardCallRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Standard Call').getRecordTypeId();
        Id wfgCallRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('WFG Call').getRecordTypeId();
        
        List<Id> listCallRecordType = new List<Id>();
        listCallRecordType.add(craCallRecordTypeId);
        listCallRecordType.add(standardCallRecordTypeId);
        listCallRecordType.add(wfgCallRecordTypeId);
        
        DateTime dateOneDayPriorToGoLive = DateTime.newInstance(2021, 6, 13);
        List<WT_Daily_Metric__c> listMetricToUpsert = new List<WT_Daily_Metric__c>();
        WT_Daily_Metric__c metricToProcess = (WT_Daily_Metric__c)scope[0];
        WT_Daily_Metric__c metricForNextRun = new WT_Daily_Metric__c();
        metricForNextRun.WT_Report_Date__c = System.today().addDays(1);
        
        //# of Unique Logins
        Integer countUniqueLoginTillNow = [SELECT COUNT()
                                           FROM User
                                           WHERE IsActive = true AND WT_Date_Welcome_Email_Sent__c != null AND LastLoginDate != null
                                           AND LastLoginDate >: dateOneDayPriorToGoLive AND (NOT Profile.Name LIKE '%Admin%') AND (NOT Profile.Name LIKE '%Access%')];
        
        //Set fields for # of Unique logins for today's and next run metric
        metricToProcess.WT_Number_of_Unique_Login_Today__c = countUniqueLoginTillNow;
        metricForNextRun.WT_Number_of_Unique_Login_Yesterday__c = countUniqueLoginTillNow;
        
        //Set fields for # of New logins for today's and next run metric
        metricToProcess.WT_Number_of_New_Logins_Today__c = countUniqueLoginTillNow - metricToProcess.WT_Number_of_Unique_Login_Yesterday__c;
        metricForNextRun.WT_Number_of_New_Logins_Yesterday__c = countUniqueLoginTillNow - metricToProcess.WT_Number_of_Unique_Login_Yesterday__c;
        
        //# of Walk Ins
        Integer countWalkInsLogged = [SELECT COUNT()
                                      FROM Task
                                      WHERE WT_Activity_Type__c = 'Walk-in'
                                      AND CreatedDate >: dateOneDayPriorToGoLive];
        
        //Set fields for # of Walk-Ins for today's and next run metric
        metricToProcess.WT_Number_of_Walk_Ins_Today__c = countWalkInsLogged;
        metricForNextRun.WT_Number_of_Walk_Ins_Yesterday__c = countWalkInsLogged;
        
        //# of Calls Logged
        Integer countCallsLogged = [SELECT COUNT()
                                    FROM Task
                                    WHERE WT_Activity_Type__c != 'Walk-in'
                                    AND RecordTypeId IN: listCallRecordType
                                    AND CreatedDate >: dateOneDayPriorToGoLive
                                    AND Status != 'Scheduled'];
        
        //Set fields for # of Walk-Ins for today's and next run metric
        metricToProcess.WT_Number_of_Call_Logged_Today__c = countCallsLogged;
        metricForNextRun.WT_Number_of_Calls_Logged_Yesterday__c = countCallsLogged;
        
        //# of Calls Scheduled
        Integer countCallsScheduled = [SELECT COUNT()
                                       FROM Task
                                       WHERE WT_Activity_Type__c != 'Walk-in'
                                       AND RecordTypeId IN: listCallRecordType
                                       AND CreatedDate >: dateOneDayPriorToGoLive
                                       AND Status = 'Scheduled'];
        
        //Set fields for # of Walk-Ins for today's and next run metric
        metricToProcess.WT_Number_of_Calls_Scheduled_Today__c = countCallsScheduled;
        metricForNextRun.WT_Number_of_Calls_Scheduled_Yesterday__c = countCallsScheduled;
        
        //# of Action Plans Created
        Integer countActionPlanCreated = [SELECT COUNT()
                                          FROM ActionPlan
                                          WHERE CreatedDate >: dateOneDayPriorToGoLive];
        
        //Set fields for # of Walk-Ins for today's and next run metric
        metricToProcess.WT_Number_of_Action_Plans_Today__c = countActionPlanCreated;
        metricForNextRun.WT_Number_of_Action_Plans_Yesterday__c = countActionPlanCreated;
        
        //# of Referrals Submitted 
        List<AggregateResult> listLeadSubmitted = [SELECT FinServ__ReferredByUser__r.Profile.Name, COUNT(Id)
                                                   FROM Lead
                                                   WHERE Status NOT IN ('Qualified - Converted', 'Qualified - Not Converted')
                                                   AND CreatedDate >: dateOneDayPriorToGoLive
                                                   GROUP BY FinServ__ReferredByUser__r.Profile.Name];
        
        Integer referralsSubmittedByRetailToday = 0;
        Integer referralsSubmittedByWealthToday = 0;
        Integer referralsSubmittedByMortgageToday = 0;
        for(AggregateResult result : listLeadSubmitted)
        {
            //Set fields for # of referral Submitted for retail for today's and next run metric
            if(result.get('Name') == 'WT Retail')
            {
                referralsSubmittedByRetailToday = result.get('expr0') != null ? Integer.valueOf(String.valueOf(result.get('expr0'))) : 0;
            }
            
            //Set fields for # of referral Submitted for wealth for today's and next run metric
            if(result.get('Name') == 'WT Wealth')
            {
                referralsSubmittedByWealthToday = result.get('expr0') != null ? Integer.valueOf(String.valueOf(result.get('expr0'))) : 0;
            }
            
            //Set fields for # of referral Submitted for mortgage for today's and next run metric
            if(result.get('Name') == 'WT Mortgage')
            {
                referralsSubmittedByMortgageToday = result.get('expr0') != null ? Integer.valueOf(String.valueOf(result.get('expr0'))) : 0;
            }
        }
        
        metricToProcess.WT_Referrals_Submitted_By_Retail_Today__c = referralsSubmittedByRetailToday;
        metricForNextRun.WT_Referrals_Submitted_By_Retail_YDA__c = referralsSubmittedByRetailToday;
        
        metricToProcess.WT_Referrals_Submitted_By_Wealth_Today__c = referralsSubmittedByWealthToday;
        metricForNextRun.WT_Referrals_Submitted_By_Wealth_YDA__c = referralsSubmittedByWealthToday;
        
        metricToProcess.WT_Referrals_Submitted_By_Mortgage_Today__c = referralsSubmittedByMortgageToday;
        metricForNextRun.WT_Referrals_Submitted_By_Mortgage_YDA__c = referralsSubmittedByMortgageToday;
        
        //# of Referrals Qualified 
        List<AggregateResult> listLeadQualified = [SELECT FinServ__ReferredByUser__r.Profile.Name, COUNT(Id)
                                                   FROM Lead
                                                   WHERE Status = 'Qualified - Not Converted'
                                                   AND CreatedDate >: dateOneDayPriorToGoLive
                                                   GROUP BY FinServ__ReferredByUser__r.Profile.Name];
        
        Integer referralsQualifiedByRetailToday = 0;
        Integer referralsQualifiedByWealthToday = 0;
        Integer referralsQualifiedByMortgageToday = 0;
        for(AggregateResult result : listLeadQualified)
        {
            //Set fields for # of referral Qualified for retail for today's and next run metric
            if(result.get('Name') == 'WT Retail')
            {
                referralsQualifiedByRetailToday = result.get('expr0') != null ? Integer.valueOf(String.valueOf(result.get('expr0'))) : 0;
            }
            
            //Set fields for # of referral Qualified for wealth for today's and next run metric
            if(result.get('Name') == 'WT Wealth')
            {
                referralsQualifiedByWealthToday = result.get('expr0') != null ? Integer.valueOf(String.valueOf(result.get('expr0'))) : 0;
            }
            
            //Set fields for # of referral Qualified for mortgage for today's and next run metric
            if(result.get('Name') == 'WT Mortgage')
            {
                referralsQualifiedByMortgageToday = result.get('expr0') != null ? Integer.valueOf(String.valueOf(result.get('expr0'))) : 0;
            }
        }
        
        metricToProcess.WT_Referrals_Qualified_By_Retail_Today__c = referralsQualifiedByRetailToday;
        metricForNextRun.WT_Referrals_Qualified_By_Retail_YDA__c = referralsQualifiedByRetailToday;
        
        metricToProcess.WT_Referrals_Qualified_By_Wealth_Today__c = referralsQualifiedByWealthToday;
        metricForNextRun.WT_Referrals_Qualified_By_Wealth_YDA__c = referralsQualifiedByWealthToday;
        
        metricToProcess.WT_Referrals_Qualified_By_Mortgage_Today__c = referralsQualifiedByMortgageToday;
        metricForNextRun.WT_Referrals_Qualified_By_Mortgage_YDA__c = referralsQualifiedByMortgageToday;
        
        //# of Referrals Qualified Converted
        List<AggregateResult> listLeadConverted = [SELECT FinServ__ReferredByUser__r.Profile.Name, COUNT(Id)
                                                   FROM Lead
                                                   WHERE Status = 'Qualified - Converted'
                                                   AND CreatedDate >: dateOneDayPriorToGoLive
                                                   GROUP BY FinServ__ReferredByUser__r.Profile.Name];
        
        Integer referralsConvertedByRetailToday = 0;
        Integer referralsConvertedByWealthToday = 0;
        Integer referralsConvertedByMortgageToday = 0;
        for(AggregateResult result : listLeadConverted)
        {
            //Set fields for # of referral Converted for retail for today's and next run metric
            if(result.get('Name') == 'WT Retail')
            {
                referralsConvertedByRetailToday = result.get('expr0') != null ? Integer.valueOf(String.valueOf(result.get('expr0'))) : 0;
            }
            
            //Set fields for # of referral Converted for wealth for today's and next run metric
            if(result.get('Name') == 'WT Wealth')
            {
                referralsConvertedByWealthToday = result.get('expr0') != null ? Integer.valueOf(String.valueOf(result.get('expr0'))) : 0;
            }
            
            //Set fields for # of referral Converted for mortgage for today's and next run metric
            if(result.get('Name') == 'WT Mortgage')
            {
                referralsConvertedByMortgageToday = result.get('expr0') != null ? Integer.valueOf(String.valueOf(result.get('expr0'))) : 0;
            }
        }
        
        metricToProcess.WT_Referrals_Converted_By_Retail_Today__c = referralsConvertedByRetailToday;
        metricForNextRun.WT_Referrals_Converted_By_Retail_YDA__c = referralsConvertedByRetailToday;
        
        metricToProcess.WT_Referrals_Converted_By_Wealth_Today__c = referralsConvertedByWealthToday;
        metricForNextRun.WT_Referrals_Converted_By_Wealth_YDA__c = referralsConvertedByWealthToday;
        
        metricToProcess.WT_Referrals_Converted_By_Mortgage_Today__c = referralsConvertedByMortgageToday;
        metricForNextRun.WT_Referrals_Converted_By_Mortgage_YDA__c = referralsConvertedByMortgageToday;
        
        //Update today's metrics & Insert a metric record for next run
        List<Messaging.SingleEmailMessage> listEmailToSend = new List<Messaging.SingleEmailMessage>();
        metricToProcess.WT_Date_Processed__c = System.now();
        
        listMetricToUpsert.add(metricToProcess);
        listMetricToUpsert.add(metricForNextRun);
        upsert listMetricToUpsert;
        
        //Get the contact that is associated with Integration Service Account
        Id contactId;
        List<Contact> listContact = [SELECT Id, Name
                                     FROM Contact
                                     WHERE Email = 'salesforcecrmcenterofexcellence@wintrust.com.integration'];
        
        if(listContact == null || listContact.isEmpty())
        {
            Contact newContact = new Contact();
            newContact.FirstName = 'Integration';
            newContact.LastName = 'Service Account';
            newContact.Email = 'salesforcecrmcenterofexcellence@wintrust.com.integration';
            
            insert newContact;
            contactId = newContact.Id;
        }
        else
        {
            contactId = listContact[0].Id;
        }
        
        //Email out the results using the pre defined Email Template
        List<EmailTemplate> listEmailTemplate = [SELECT Id, Name
                                                 FROM EmailTemplate
                                                 WHERE DeveloperName = 'WT_Daily_Metrics'];
        
        try
        {
            WT_Daily_Metric_Recipient__mdt[] setDailyMetricRecipient = [SELECT Recipient_Email__c
                                                                        FROM WT_Daily_Metric_Recipient__mdt];
            List<String> listToEmail = new List<String>();
            
            for(WT_Daily_Metric_Recipient__mdt recipient : setDailyMetricRecipient)
            {
                listToEmail.add(recipient.Recipient_Email__c);
            }
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(listToEmail);
            mail.setTemplateId(listEmailTemplate[0].Id);
            mail.setBccSender(false);
            mail.setUseSignature(false);
            mail.setReplyTo('noreply@salesforce.com');
            mail.setSenderDisplayName('Wintrust CRM');
            mail.setSaveAsActivity(false); 
            mail.setTargetObjectId(contactId);
            mail.setWhatId(metricToProcess.Id);
            
            listEmailToSend.add(mail);
            Messaging.sendEmail(listEmailToSend);
        }
        catch(Exception ex)
        {
            
        }
    }  
    
    global void finish(Database.BatchableContext bc) 
    {
        
    }
}