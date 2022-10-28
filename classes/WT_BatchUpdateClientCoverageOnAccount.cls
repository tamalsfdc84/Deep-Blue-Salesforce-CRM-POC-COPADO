/**
* --------------------------------------------------------------------------------------------------------------
* @Name             WT_BatchUpdateClientCoverageOnAccount
* @Author           Karishma Keswani<kkeswani@wintrust.com>
* @ModifiedBy       Vamsi Krishna<vpulikal@wintrust.com>
* @Version          v1.0
* @CreatedDate      19 Jan 2021
* @ModifiedDate     14 Oct 2021
* @UsedBy           
* --------------------------------------------------------------------------------------------------------------
* @Description
* This batch updates the coverage details on Accounts.
* --------------------------------------------------------------------------------------------------------------
* @Changes
* v1.0
* 28 Jan 2021
*--------------------------------------------------------------------------------------------------------------
**/
// Code Coverage: WT_BatchUpdateClientCoverageOnAccount_T
public class WT_BatchUpdateClientCoverageOnAccount implements Database.Batchable<sObject>, Database.Stateful
{
    Map<id,List<Account>> mapOwnerwithAccounts = new Map<id,List<Account>>();
    Date coveredAnnualEndDate = Date.today().addDays(-1);
    Date coveredAnnualStartDate = Date.today().addYears(-1);    
    Date coveredAnnualReportEndDate = (Date.today().month())==1 ? DATE.newInstance((Date.today().year())-1,12,31) : DATE.newInstance((Date.today().year()),(Date.today().month()),1)-1;
    Date coveredAnnualReportStartDate = Date.newInstance(Date.today().year()-1, 1, 1);    
    Date coveredLastYearEndDate = coveredAnnualEndDate.addYears(-1);
    Date coveredLastYearStartDate = coveredAnnualStartDate.addYears(-1);    
    Date coveredLastYearReportEndDate = coveredAnnualReportEndDate.addYears(-1);
    Date coveredLastYearReportStartDate = coveredAnnualReportStartDate.addYears(-1);    
    Date coveredPeriodEndDate;
    Date coveredPeriodStartDate;    
    Date coveredPeriodReportEndDate;
    Date coveredPeriodReportStartDate;    
    Date coveredLastPeriodEndDate;
    Date coveredLastPeriodStartDate;    
    Date coveredLastPeriodReportEndDate;
    Date coveredLastPeriodReportStartDate;
    Public Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query = 'SELECT Id,WT_Covered_Annual__c,WT_Covered_Period__c,WT_Covered_Period_Report__c,WT_Covered_Last_Period__c,WT_Classification__c,OwnerID,Owner.WT_Line_of_Business__c,WT_Covered_Annual_Report__c,WT_Covered_Last_Year__c,WT_Covered_Last_Year_Report__c FROM Account WHERE RecordType.DeveloperName in (\'BusinessAccount_Customer\',\'BusinessAccount_Prospect\')';
        return Database.getQueryLocator(query);
    }
    Public void execute(Database.BatchableContext bc, List<Account> scope)
    {
        
        Integer noOfCoveredAnnual = 0;
        Integer noOfCoveredAnnualReport = 0;
        Integer noOfCoveredAnnualLast = 0;
        Integer noOfCoveredAnnualReportLast=0;        
        Integer noOfCoveredPeriod = 0;
        Integer noOfCoveredPeriodReport = 0;
        Integer noOfCoveredPeriodLast = 0;
        Integer noOfCoveredPeriodReportLast=0;        
        List<Account> listUncoveredAccount = New List<Account>();
        List<WT_Client_Coverage__c> listApplicableRules = new List<WT_Client_Coverage__c>();
        Map<id,List<EmailMessage>> mapOfAccountIDwithEmailMessages = New Map<id,List<EmailMessage>>();
        list<account> listUpdateCoverageAccount = new list<Account>();
        list<account> listNAAccounts = new list<Account>();
        List<WT_Client_Coverage__c> rulesApplicable;
        Boolean addRecord;
        Boolean periodRulePresent;
        Boolean annualRulePresent;
        Boolean unclassifiedOrUncovered = true;
        scope = [SELECT Id,WT_Covered_Annual__c,WT_Classification__c,OwnerID,Owner.WT_Line_of_Business__c,WT_Covered_Annual_Report__c,
                 WT_Covered_Last_Year__c,WT_Covered_Last_Year_Report__c,WT_Covered_Period__c,WT_Covered_Period_Report__c,WT_Covered_Last_Period__c,
                 WT_Covered_Last_Period_Report__c,WT_Last_Date_Of_Contact__c,Name,
                 (SELECT id,subject,createddate,ActivityDate,RecordTypeId,RecordType.developerName,status FROM tasks),
                 (SELECT id,createddate,ActivityDate,RecordTypeId,RecordType.developerName FROM events)
                 FROM Account WHERE Id in:Scope];
        WT_Client_Coverage__c[] coverageRules = [Select Id,WT_Account_Classification__c,WT_Coverage_Time_Period_Type__c,WT_Lines_of_Business__c,
                                                 WT_All_Other_Lines_of_Business__c,WT_Total_Number_of_Activities_Required__c,WT_Include_CRA_Events__c,
                                                 WT_Months__c,WT_Include_Tasks__c,WT_Include_WFG_Calls__c,WT_Include_CRA_Calls__c,WT_Include_Emails__c,
                                                 WT_Include_Standard_Calls__c,WT_Include_Events__c, WT_Include_Annual_Review__c 
                                                 from WT_Client_Coverage__c 
                                                 where recordtype.developername in('WT_Account')];
        
        Map<account,List<WT_Client_Coverage__c>> mapAccountWithRule = new Map<account,List<WT_Client_Coverage__c>>();        
        List<EmailMessage> listOfEmailMessages = [Select id, relatedtoId,createddate from emailmessage where relatedtoId IN:scope];
        list<EmailMessage> listOfRelatedEmailMessages;
        List<Task> listApplicableTasks = new List<Task>();
        List<Event> listApplicableEvents = new List<Event>();                 
        Integer numberOfActivies = 0;   
        Integer noOfMonths = 0;
        for(EmailMessage emailMessageRecord:listOfEmailMessages)
        {
            if(mapOfAccountIDwithEmailMessages.get(emailMessageRecord.RelatedToId)!=null)
            {
                listOfRelatedEmailMessages = mapOfAccountIDwithEmailMessages.get(emailMessageRecord.RelatedToId);
                listOfRelatedEmailMessages.add(emailMessageRecord);
                mapOfAccountIDwithEmailMessages.put(emailMessageRecord.RelatedToId,listOfRelatedEmailMessages);
            }
            else
            {
                listOfRelatedEmailMessages = New List<EmailMessage>();
                listOfRelatedEmailMessages.add(emailMessageRecord);
                mapOfAccountIDwithEmailMessages.put(emailMessageRecord.RelatedToId,listOfRelatedEmailMessages);
            }
        }  
        for(Account accountRecord: Scope)
        {
            unclassifiedOrUncovered = true;
            if(accountRecord.WT_Classification__c!=null)
            {
                for(WT_Client_Coverage__c applicableRule: coverageRules)
                {
                    boolean isMiddleMarketUser = false;
                    boolean addRuleToMap = false;
                    if(accountRecord.owner.WT_Line_of_Business__c !=null && accountRecord.owner.WT_Line_of_Business__c == 'Middle Market')
                    {
                        isMiddleMarketUser = true;
                    }
                    if(applicableRule.WT_Account_Classification__c==accountRecord.WT_Classification__c)
                    {
                        if(isMiddleMarketUser && applicableRule.WT_Lines_of_Business__c != null && (applicableRule.WT_Lines_of_Business__c.contains(accountRecord.owner.WT_Line_of_Business__c)))
                        {
                            addRuleToMap = true;
                        }
                        else if(!isMiddleMarketUser && applicableRule.WT_All_Other_Lines_of_Business__c)
                        {
                            addRuleToMap = true;
                        }
                    }
                    if(addRuleToMap)
                    {
                        unclassifiedOrUncovered = false;
                        if(mapAccountWithRule.get(accountRecord)!=null)
                        {
                            listApplicableRules = mapAccountWithRule.get(accountRecord);
                            listApplicableRules.add(applicableRule);
                            mapAccountWithRule.put(accountRecord,listApplicableRules);
                        }
                        else
                        {
                            listApplicableRules = new List<WT_Client_Coverage__c>();
                            listApplicableRules.add(applicableRule);
                            mapAccountWithRule.put(accountRecord,listApplicableRules);
                        }
                    }
                }
            }
            if(unclassifiedOrUncovered)
            {
                listNAAccounts.add(accountRecord);
            }
        }
        if(!mapAccountWithRule.isEmpty())
        {
            for(account accountRecord:mapAccountWithRule.keyset())
            {
                addRecord = false;
                periodRulePresent = false;
                annualRulePresent = false;
                rulesApplicable = new List<WT_Client_Coverage__c>();
                rulesApplicable = mapAccountWithRule.get(accountRecord);
                if(!rulesApplicable.isEmpty())
                {
                    for(WT_Client_Coverage__c ruleApplicable:rulesApplicable)
                    {
                        listApplicableTasks = new List<Task>();
                        listApplicableEvents = new List<Event>();                 
                        numberOfActivies = 0;   
                        if(ruleApplicable.WT_Coverage_Time_Period_Type__c=='Period')
                        {
                            periodRulePresent = true;
                            noOfMonths = Integer.valueOf(ruleApplicable.WT_Months__c);                            
                            coveredPeriodEndDate = coveredAnnualEndDate;
                            coveredPeriodStartDate = coveredPeriodEndDate.addMonths(-noOfMonths).adddays(1);                            
                            coveredPeriodReportEndDate = (Date.today().month())==1 ? DATE.newInstance((Date.today().year())-1,12,31) : DATE.newInstance((Date.today().year()),(Date.today().month()),1)-1;
                            coveredPeriodReportStartDate = coveredPeriodReportEndDate.addMonths(-noOfMonths).adddays(1);                            
                            coveredLastPeriodEndDate = coveredPeriodStartDate.addDays(-1);
                            coveredLastPeriodStartDate = coveredLastPeriodEndDate.addMonths(-noOfMonths).adddays(1);                            
                            coveredLastPeriodReportEndDate = coveredPeriodReportEndDate.addMonths(-noOfMonths);
                            coveredLastPeriodReportStartDate = coveredLastPeriodReportEndDate.addMonths(-noOfMonths).adddays(1);                            
                            noOfCoveredPeriod = 0;
                            noOfCoveredPeriodReport=0;
                            noOfCoveredPeriodLast=0;
                            noOfCoveredPeriodReportLast=0;   
                            for(task taskrecord:accountRecord.tasks)
                            {
                                if((ruleApplicable.WT_Include_Standard_Calls__c && taskrecord.RecordType.developerName == 'WT_Standard_Call')
                                   || (ruleApplicable.WT_Include_WFG_Calls__c && taskrecord.RecordType.developerName=='WT_WFG_Call')
                                   || (ruleApplicable.WT_Include_CRA_Calls__c && taskrecord.RecordType.developerName=='WT_CRA_Call')
                                   || (ruleApplicable.WT_Include_Tasks__c && taskrecord.RecordType.developerName=='WT_Wintrust_Task'))
                                {
                                    if(coveredPeriodStartDate<=taskrecord.ActivityDate &&  taskrecord.ActivityDate<=coveredPeriodEndDate)
                                    {
                                        noOfCoveredPeriod++;
                                    }
                                    if(coveredPeriodReportStartDate<=taskrecord.ActivityDate &&  taskrecord.ActivityDate<=coveredPeriodReportEndDate)
                                    {
                                        noOfCoveredPeriodReport++;
                                    }
                                    if(coveredLastPeriodStartDate<=taskrecord.ActivityDate &&  taskrecord.ActivityDate<=coveredLastPeriodEndDate)
                                    {
                                        noOfCoveredPeriodLast++;
                                    }
                                    if(coveredLastPeriodReportStartDate<=taskrecord.ActivityDate &&  taskrecord.ActivityDate<=coveredLastPeriodReportEndDate)
                                    {
                                        noOfCoveredPeriodReportLast++;
                                    }
                                }
                            }
                            
                            for(event eventrecord:accountRecord.events)
                            {
                                if((ruleApplicable.WT_Include_CRA_Events__c && eventrecord.RecordType.developerName == 'WT_CRA_Event')
                                   || (ruleApplicable.WT_Include_Events__c && eventrecord.RecordType.developerName == 'WT_Wintrust_Event')
                                   || (ruleApplicable.WT_Include_Annual_Review__c && eventrecord.RecordType.developerName == 'WT_Annual_Review'))
                                {
                                    if(coveredPeriodStartDate<=eventrecord.ActivityDate &&  eventrecord.ActivityDate<=coveredPeriodEndDate)
                                    {
                                        noOfCoveredPeriod++;
                                    }
                                    if(coveredPeriodReportStartDate<=eventrecord.ActivityDate &&  eventrecord.ActivityDate<=coveredPeriodReportEndDate)
                                    {
                                        noOfCoveredPeriodReport++;
                                    }
                                    if(coveredLastPeriodStartDate<=eventrecord.ActivityDate &&  eventrecord.ActivityDate<=coveredLastPeriodEndDate)
                                    {
                                        noOfCoveredPeriodLast++;
                                    }
                                    if(coveredLastPeriodReportStartDate<=eventrecord.ActivityDate &&  eventrecord.ActivityDate<=coveredLastPeriodReportEndDate)
                                    {
                                        noOfCoveredPeriodReportLast++;
                                    }
                                }
                            }
                            
                            if(ruleApplicable.WT_Include_Emails__c)
                            {
                                listOfRelatedEmailMessages = mapOfAccountIDwithEmailMessages.get(accountRecord.Id);
                                if(listOfRelatedEmailMessages!=null && !listOfRelatedEmailMessages.isEmpty())
                                {
                                    for(EmailMessage emailMessageRecord:listOfRelatedEmailMessages)
                                    {
                                        if(coveredPeriodStartDate<=emailMessageRecord.CreatedDate &&  emailMessageRecord.CreatedDate<=coveredPeriodEndDate)
                                        {
                                            noOfCoveredPeriod++;
                                        }
                                        if(coveredPeriodReportStartDate<=emailMessageRecord.CreatedDate &&  emailMessageRecord.CreatedDate<=coveredPeriodReportEndDate)
                                        {
                                            noOfCoveredPeriodReport++;
                                        }
                                        if(coveredLastPeriodStartDate<=emailMessageRecord.CreatedDate &&  emailMessageRecord.CreatedDate<=coveredLastPeriodEndDate)
                                        {
                                            noOfCoveredPeriodLast++;
                                        }
                                        if(coveredLastPeriodReportStartDate<=emailMessageRecord.CreatedDate &&  emailMessageRecord.CreatedDate<=coveredLastPeriodReportEndDate)
                                        {
                                            noOfCoveredPeriodReportLast++;
                                        }   
                                    }
                                }
                            }
                            //CoveredPeriod
                            if(ruleApplicable.WT_Total_Number_of_Activities_Required__c<=noOfCoveredPeriod)
                            {
                                if(String.isBlank(accountRecord.WT_Covered_Period__c) || !accountRecord.WT_Covered_Period__c.equalsIgnoreCase('Covered'))
                                {
                                    accountRecord.WT_Covered_Period__c = 'Covered';
                                    addRecord = true;
                                }
                            }
                            else if(String.isBlank(accountRecord.WT_Covered_Period__c) || !accountRecord.WT_Covered_Period__c.equalsIgnoreCase('Not Covered'))
                            {
                                accountRecord.WT_Covered_Period__c = 'Not Covered';
                                addRecord = true;
                                if(mapOwnerwithAccounts.get(accountRecord.ownerid)!=null)
                                {
                                    listUncoveredAccount = mapOwnerwithAccounts.get(accountRecord.ownerid);
                                    listUncoveredAccount.add(accountRecord);
                                    mapOwnerwithAccounts.put(accountRecord.ownerid,listUncoveredAccount);
                                }
                                else
                                {
                                    listUncoveredAccount = new List<Account>();
                                    listUncoveredAccount.add(accountRecord);
                                    mapOwnerwithAccounts.put(accountRecord.ownerid,listUncoveredAccount);
                                }
                            }
                            //CoveredPeriodReport
                            if(ruleApplicable.WT_Total_Number_of_Activities_Required__c<=noOfCoveredPeriodReport)
                            {
                                if(String.isBlank(accountRecord.WT_Covered_Period_Report__c) || !accountRecord.WT_Covered_Period_Report__c.equalsIgnoreCase('Covered'))
                                {
                                    accountRecord.WT_Covered_Period_Report__c = 'Covered';
                                    addRecord = true;
                                }
                            }
                            else if(String.isBlank(accountRecord.WT_Covered_Period_Report__c) || !accountRecord.WT_Covered_Period_Report__c.equalsIgnoreCase('Not Covered'))
                            {
                                accountRecord.WT_Covered_Period_Report__c = 'Not Covered';
                                addRecord = true;
                            }
                            //CoveredPeriodLast
                            if(ruleApplicable.WT_Total_Number_of_Activities_Required__c<=noOfCoveredPeriodLast)
                            {
                                if(String.isBlank(accountRecord.WT_Covered_Last_Period__c) || !accountRecord.WT_Covered_Last_Period__c.equalsIgnoreCase('Covered'))
                                {
                                    accountRecord.WT_Covered_Last_Period__c = 'Covered';
                                    addRecord = true;
                                }
                            }
                            else if(String.isBlank(accountRecord.WT_Covered_Last_Period__c) || !accountRecord.WT_Covered_Last_Period__c.equalsIgnoreCase('Not Covered'))
                            {
                                accountRecord.WT_Covered_Last_Period__c = 'Not Covered';
                                addRecord = true;
                            }
                            //CoveredPeriodReportLast
                            if(ruleApplicable.WT_Total_Number_of_Activities_Required__c<=noOfCoveredPeriodReportLast)
                            {
                                if(String.isBlank(accountRecord.WT_Covered_Last_Period_Report__c) || !accountRecord.WT_Covered_Last_Period_Report__c.equalsIgnoreCase('Covered'))
                                {
                                    accountRecord.WT_Covered_Last_Period_Report__c = 'Covered';
                                    addRecord = true;
                                }
                            }
                            else if(String.isBlank(accountRecord.WT_Covered_Last_Period_Report__c) || !accountRecord.WT_Covered_Last_Period_Report__c.equalsIgnoreCase('Not Covered'))
                            {
                                accountRecord.WT_Covered_Last_Period_Report__c = 'Not Covered';
                                addRecord = true;
                            }
                        }
                        else
                        {
                            annualRulePresent = true;
                            noOfCoveredAnnual=0;
                            noOfCoveredAnnualReport = 0;
                            noOfCoveredAnnualLast = 0;
                            noOfCoveredAnnualReportLast=0;
                            
                            for(task taskrecord:accountRecord.tasks)
                            {
                                if( (ruleApplicable.WT_Include_Standard_Calls__c && taskrecord.RecordType.developerName == 'WT_Standard_Call')
                                   || (ruleApplicable.WT_Include_WFG_Calls__c && taskrecord.RecordType.developerName=='WT_WFG_Call')
                                   || (ruleApplicable.WT_Include_CRA_Calls__c && taskrecord.RecordType.developerName=='WT_CRA_Call')
                                   || (ruleApplicable.WT_Include_Tasks__c && taskrecord.RecordType.developerName=='WT_Wintrust_Task'))
                                {
                                    if(coveredAnnualStartDate<=taskrecord.ActivityDate &&  taskrecord.ActivityDate<=coveredAnnualEndDate)
                                    {
                                        noOfCoveredAnnual++;
                                    }
                                    if(coveredAnnualReportStartDate<=taskrecord.ActivityDate &&  taskrecord.ActivityDate<=coveredAnnualReportEndDate)
                                    {
                                        noOfCoveredAnnualReport++;
                                    }
                                    if(coveredLastYearStartDate<=taskrecord.ActivityDate &&  taskrecord.ActivityDate<=coveredLastYearEndDate)
                                    {
                                        noOfCoveredAnnualLast++;
                                    }
                                    if(coveredLastYearReportStartDate<=taskrecord.ActivityDate &&  taskrecord.ActivityDate<=coveredLastYearReportEndDate)
                                    {
                                        noOfCoveredAnnualReportLast++;
                                    }
                                }                    
                            }                            
                            
                            for(event eventrecord:accountRecord.events)
                            {
                                if((ruleApplicable.WT_Include_CRA_Events__c && eventrecord.RecordType.developerName == 'WT_CRA_Event')
                                   || (ruleApplicable.WT_Include_Events__c && eventrecord.RecordType.developerName == 'WT_Wintrust_Event')
                                   || (ruleApplicable.WT_Include_Annual_Review__c && eventrecord.RecordType.developerName == 'WT_Annual_Review'))
                                {
                                    if(coveredAnnualStartDate<=eventrecord.ActivityDate &&  eventrecord.ActivityDate<=coveredAnnualEndDate)
                                    {
                                        noOfCoveredAnnual++;
                                    }
                                    if(coveredAnnualReportStartDate<=eventrecord.ActivityDate &&  eventrecord.ActivityDate<=coveredAnnualReportEndDate)
                                    {
                                        noOfCoveredAnnualReport++;
                                    }
                                    if(coveredLastYearStartDate<=eventrecord.ActivityDate &&  eventrecord.ActivityDate<=coveredLastYearEndDate)
                                    {
                                        noOfCoveredAnnualLast++;
                                    }
                                    if(coveredLastYearReportStartDate<=eventrecord.ActivityDate &&  eventrecord.ActivityDate<=coveredLastYearReportEndDate)
                                    {
                                        noOfCoveredAnnualReportLast++;
                                    }
                                }
                            }
                            
                            if(ruleApplicable.WT_Include_Emails__c)
                            {
                                listOfRelatedEmailMessages = mapOfAccountIDwithEmailMessages.get(accountRecord.Id);
                                if(listOfRelatedEmailMessages!=null && !listOfRelatedEmailMessages.isEmpty())
                                {
                                    for(emailMessage emailMessageRecord:listOfRelatedEmailMessages)
                                    {
                                        if(coveredAnnualStartDate<=emailMessageRecord.CreatedDate &&  emailMessageRecord.CreatedDate<=coveredAnnualEndDate)
                                        {
                                            noOfCoveredAnnual++;
                                        }
                                        if(coveredAnnualReportStartDate<=emailMessageRecord.CreatedDate &&  emailMessageRecord.CreatedDate<=coveredAnnualReportEndDate)
                                        {
                                            noOfCoveredAnnualReport++;
                                        }
                                        if(coveredLastYearStartDate<=emailMessageRecord.CreatedDate &&  emailMessageRecord.CreatedDate<=coveredLastYearEndDate)
                                        {
                                            noOfCoveredAnnualLast++;
                                        }
                                        if(coveredLastYearReportStartDate<=emailMessageRecord.CreatedDate &&  emailMessageRecord.CreatedDate<=coveredLastYearReportEndDate)
                                        {
                                            noOfCoveredAnnualReportLast++;
                                        }
                                    }
                                }
                            }
                            //Covered Annual
                            if(ruleApplicable.WT_Total_Number_of_Activities_Required__c<=noOfCoveredAnnual)
                            {
                                if(String.isBlank(accountRecord.WT_Covered_Annual__c) || !accountRecord.WT_Covered_Annual__c.equalsIgnoreCase('Covered'))
                                {
                                    accountRecord.WT_Covered_Annual__c = 'Covered';
                                    addRecord = true;
                                }
                            }
                            else if(String.isBlank(accountRecord.WT_Covered_Annual__c) || !accountRecord.WT_Covered_Annual__c.equalsIgnoreCase('Not Covered'))
                            {
                                accountRecord.WT_Covered_Annual__c = 'Not Covered';
                                addRecord = true;
                                if(mapOwnerwithAccounts.get(accountRecord.ownerid)!=null)
                                {
                                    listUncoveredAccount = mapOwnerwithAccounts.get(accountRecord.ownerid);
                                    if(listUncoveredAccount.size()>0 && !listUncoveredAccount.contains(accountRecord))
                                    {
                                        listUncoveredAccount.add(accountRecord);
                                        mapOwnerwithAccounts.put(accountRecord.ownerid,listUncoveredAccount);
                                    }
                                }
                                else
                                {
                                    listUncoveredAccount = new List<Account>();
                                    listUncoveredAccount.add(accountRecord);
                                    mapOwnerwithAccounts.put(accountRecord.ownerid,listUncoveredAccount);
                                }
                            }
                            //CoveredAnnualReport
                            if(ruleApplicable.WT_Total_Number_of_Activities_Required__c<=noOfCoveredAnnualReport)
                            {
                                if(String.isBlank(accountRecord.WT_Covered_Annual_Report__c) || !accountRecord.WT_Covered_Annual_Report__c.equalsIgnoreCase('Covered'))
                                {
                                    accountRecord.WT_Covered_Annual_Report__c = 'Covered';
                                    addRecord = true;
                                }
                            }
                            else if(String.isBlank(accountRecord.WT_Covered_Annual_Report__c) || !accountRecord.WT_Covered_Annual_Report__c.equalsIgnoreCase('Not Covered'))
                            {
                                accountRecord.WT_Covered_Annual_Report__c = 'Not Covered';
                                addRecord = true;
                            }
                            //CoveredAnnualLast
                            if(ruleApplicable.WT_Total_Number_of_Activities_Required__c<=noOfCoveredAnnualLast)
                            {
                                if(String.isBlank(accountRecord.WT_Covered_Last_Year__c) || !accountRecord.WT_Covered_Last_Year__c.equalsIgnoreCase('Covered'))
                                {
                                    accountRecord.WT_Covered_Last_Year__c = 'Covered';
                                    addRecord = true;
                                }
                            }
                            else if(String.isBlank(accountRecord.WT_Covered_Last_Year__c) || !accountRecord.WT_Covered_Last_Year__c.equalsIgnoreCase('Not Covered'))
                            {
                                accountRecord.WT_Covered_Last_Year__c = 'Not Covered';
                                addRecord = true;
                            }                    
                            //CoveredAnnualReportLast
                            if(ruleApplicable.WT_Total_Number_of_Activities_Required__c<=noOfCoveredAnnualReportLast)
                            {
                                if(String.isBlank(accountRecord.WT_Covered_Last_Year_Report__c) || !accountRecord.WT_Covered_Last_Year_Report__c.equalsIgnoreCase('Covered'))
                                {
                                    accountRecord.WT_Covered_Last_Year_Report__c = 'Covered';
                                    addRecord = true;
                                }
                            }
                            else if(String.isBlank(accountRecord.WT_Covered_Last_Year_Report__c) || !accountRecord.WT_Covered_Last_Year_Report__c.equalsIgnoreCase('Not Covered'))
                            {
                                accountRecord.WT_Covered_Last_Year_Report__c = 'Not Covered';
                                addRecord = true;
                            }                    
                        }                
                    }
                }
                if(!periodRulePresent )
                {
                    if(String.isBlank(accountRecord.WT_Covered_Period__c) || !accountRecord.WT_Covered_Period__c.equalsIgnoreCase('N/A'))
                    {
                        if(!String.isBlank(accountRecord.WT_Covered_Period__c) && accountRecord.WT_Covered_Period__c.equalsIgnoreCase('Covered'))
                        {
                            if(mapOwnerwithAccounts.get(accountRecord.ownerid)!=null)
                            {
                                listUncoveredAccount = mapOwnerwithAccounts.get(accountRecord.ownerid);
                                if(listUncoveredAccount.size()>0 && !listUncoveredAccount.contains(accountRecord))
                                {
                                    listUncoveredAccount.add(accountRecord);
                                    mapOwnerwithAccounts.put(accountRecord.ownerid,listUncoveredAccount);
                                }
                            }
                            else
                            {
                                listUncoveredAccount = new List<Account>();
                                listUncoveredAccount.add(accountRecord);
                                mapOwnerwithAccounts.put(accountRecord.ownerid,listUncoveredAccount);
                            }
                        }
                        accountRecord.WT_Covered_Period__c = 'N/A';
                        addRecord = true;
                    }
                    if(String.isBlank(accountRecord.WT_Covered_Period_Report__c) || !accountRecord.WT_Covered_Period_Report__c.equalsIgnoreCase('N/A'))
                    {
                        accountRecord.WT_Covered_Period_Report__c = 'N/A';
                        addRecord = true;
                    }
                    if(String.isBlank(accountRecord.WT_Covered_Last_Period__c) || !accountRecord.WT_Covered_Last_Period__c.equalsIgnoreCase('N/A'))
                    {
                        accountRecord.WT_Covered_Last_Period__c = 'N/A';
                        addRecord = true;
                    }
                    if(String.isBlank(accountRecord.WT_Covered_Last_Period_Report__c) || !accountRecord.WT_Covered_Last_Period_Report__c.equalsIgnoreCase('N/A'))
                    {
                        accountRecord.WT_Covered_Last_Period_Report__c = 'N/A';
                        addRecord = true;
                    }
                }
                if(!annualRulePresent)
                {
                    if(String.isBlank(accountRecord.WT_Covered_Annual__c) || !accountRecord.WT_Covered_Annual__c.equalsIgnoreCase('N/A'))
                    {
                        if(!String.isBlank(accountRecord.WT_Covered_Annual__c) && accountRecord.WT_Covered_Annual__c.equalsIgnoreCase('Covered'))
                        {
                            if(mapOwnerwithAccounts.get(accountRecord.ownerid)!=null)
                            {
                                listUncoveredAccount = mapOwnerwithAccounts.get(accountRecord.ownerid);
                                if(listUncoveredAccount.size()>0 && !listUncoveredAccount.contains(accountRecord))
                                {
                                    listUncoveredAccount.add(accountRecord);
                                    mapOwnerwithAccounts.put(accountRecord.ownerid,listUncoveredAccount);
                                }
                            }
                            else
                            {
                                listUncoveredAccount = new List<Account>();
                                listUncoveredAccount.add(accountRecord);
                                mapOwnerwithAccounts.put(accountRecord.ownerid,listUncoveredAccount);
                            }
                        }
                        accountRecord.WT_Covered_Annual__c = 'N/A';
                        addRecord = true;
                    }
                    if(String.isBlank(accountRecord.WT_Covered_Annual_Report__c) || !accountRecord.WT_Covered_Annual_Report__c.equalsIgnoreCase('N/A'))
                    {
                        accountRecord.WT_Covered_Annual_Report__c = 'N/A';
                        addRecord = true;
                    }
                    if(String.isBlank(accountRecord.WT_Covered_Last_Year__c) || !accountRecord.WT_Covered_Last_Year__c.equalsIgnoreCase('N/A'))
                    {
                        accountRecord.WT_Covered_Last_Year__c = 'N/A';
                        addRecord = true;
                    }
                    if(String.isBlank(accountRecord.WT_Covered_Last_Year_Report__c) || !accountRecord.WT_Covered_Last_Year_Report__c.equalsIgnoreCase('N/A'))
                    {
                        accountRecord.WT_Covered_Last_Year_Report__c = 'N/A';
                        addRecord = true;
                    }
                } 
                if(addRecord)
                {
                    listUpdateCoverageAccount.add(accountRecord);
                }
            }    
        }
        for(account accountRecord:listNAAccounts)
        {
            addRecord = false;
            if(String.isBlank(accountRecord.WT_Covered_Period__c) || !accountRecord.WT_Covered_Period__c.equalsIgnoreCase('N/A'))
            {
                if(!String.isBlank(accountRecord.WT_Covered_Period__c) && accountRecord.WT_Covered_Period__c.equalsIgnoreCase('Covered'))
                {
                    if(mapOwnerwithAccounts.get(accountRecord.ownerid)!=null)
                    {
                        listUncoveredAccount = mapOwnerwithAccounts.get(accountRecord.ownerid);
                        if(listUncoveredAccount.size()>0 && !listUncoveredAccount.contains(accountRecord))
                        {
                            listUncoveredAccount.add(accountRecord);
                            mapOwnerwithAccounts.put(accountRecord.ownerid,listUncoveredAccount);
                        }
                    }
                    else
                    {
                        listUncoveredAccount = new List<Account>();
                        listUncoveredAccount.add(accountRecord);
                        mapOwnerwithAccounts.put(accountRecord.ownerid,listUncoveredAccount);
                    }
                }
                accountRecord.WT_Covered_Period__c = 'N/A';
                addRecord = true;
            }
            if(String.isBlank(accountRecord.WT_Covered_Period_Report__c) || !accountRecord.WT_Covered_Period_Report__c.equalsIgnoreCase('N/A'))
            {
                accountRecord.WT_Covered_Period_Report__c = 'N/A';
                addRecord = true;
            }
            if(String.isBlank(accountRecord.WT_Covered_Last_Period__c) || !accountRecord.WT_Covered_Last_Period__c.equalsIgnoreCase('N/A'))
            {
                accountRecord.WT_Covered_Last_Period__c = 'N/A';
                addRecord = true;
            }
            if(String.isBlank(accountRecord.WT_Covered_Last_Period_Report__c) || !accountRecord.WT_Covered_Last_Period_Report__c.equalsIgnoreCase('N/A'))
            {
                accountRecord.WT_Covered_Last_Period_Report__c = 'N/A';
                addRecord = true;
            }
            if(String.isBlank(accountRecord.WT_Covered_Annual__c) || !accountRecord.WT_Covered_Annual__c.equalsIgnoreCase('N/A'))
            {
                if(!String.isBlank(accountRecord.WT_Covered_Annual__c) && accountRecord.WT_Covered_Annual__c.equalsIgnoreCase('Covered'))
                {
                    if(mapOwnerwithAccounts.get(accountRecord.ownerid)!=null)
                    {
                        listUncoveredAccount = mapOwnerwithAccounts.get(accountRecord.ownerid);
                        if(listUncoveredAccount.size()>0 && !listUncoveredAccount.contains(accountRecord))
                        {
                            listUncoveredAccount.add(accountRecord);
                            mapOwnerwithAccounts.put(accountRecord.ownerid,listUncoveredAccount);
                        }
                    }
                    else
                    {
                        listUncoveredAccount = new List<Account>();
                        listUncoveredAccount.add(accountRecord);
                        mapOwnerwithAccounts.put(accountRecord.ownerid,listUncoveredAccount);
                    }
                }
                accountRecord.WT_Covered_Annual__c = 'N/A';
                addRecord = true;
            }
            if(String.isBlank(accountRecord.WT_Covered_Annual_Report__c) || !accountRecord.WT_Covered_Annual_Report__c.equalsIgnoreCase('N/A'))
            {
                accountRecord.WT_Covered_Annual_Report__c = 'N/A';
                addRecord = true;
            }
            if(String.isBlank(accountRecord.WT_Covered_Last_Year__c) || !accountRecord.WT_Covered_Last_Year__c.equalsIgnoreCase('N/A'))
            {
                accountRecord.WT_Covered_Last_Year__c = 'N/A';
                addRecord = true;
            }
            if(String.isBlank(accountRecord.WT_Covered_Last_Year_Report__c) || !accountRecord.WT_Covered_Last_Year_Report__c.equalsIgnoreCase('N/A'))
            {
                accountRecord.WT_Covered_Last_Year_Report__c = 'N/A';
                addRecord = true;
            }
            if(addRecord){
                listUpdateCoverageAccount.add(accountRecord);
            }
        }
        if(!listUpdateCoverageAccount.isEmpty())
        {
            database.update(listUpdateCoverageAccount,false);
        }
    }   
    Public void finish(Database.BatchableContext bc)
    {
        if(!mapOwnerwithAccounts.isEmpty())
        {
            Map<id,User> mapOwnerDetails = New MaP<id,User>([Select id,email,isactive,Name from user where id IN:mapOwnerwithAccounts.keySet() and Isactive=true]);
            List<Messaging.SingleEmailMessage> listOfMail = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage mail;
            user userRecord;
            List<String> toAddresses;
            List<Account> listOfUncoveredAccounts = new List<Account>();
            string td1='"border:1px solid black; width=200px;"';
            string tdHead='"border:1px solid black; width=200px; font-weight:bold;"';
            Schema.DescribeFieldResult classificationField = account.WT_Classification__c.getDescribe();
            map<String,String> mapApiLabelValues = new Map<String,String>();
            String displayDate = ''; 
            for( Schema.PicklistEntry v : classificationField.getPicklistValues())
            { 
                mapApiLabelValues.put(v.getValue(),v.getLabel());                
            } 
            for(Id ownerId:mapOwnerDetails.keyset())
            {
                listOfUncoveredAccounts = mapOwnerwithAccounts.get(ownerId);
                mail = new Messaging.SingleEmailMessage();
                toAddresses = new List<String>();
                userRecord = mapOwnerDetails.get(ownerId);
                toAddresses.add(userRecord.email);
                mail.setToAddresses(toAddresses);
                mail.setSubject(System.label.WT_MissedCoverageEmailSubject);                
                string htmlBody = '<div><p>Dear '+userRecord.name+',</p></div>'
                    +'<p>You are no longer meeting coverage requirements for the following customers/prospects:</p>'
                    +'<center><table border="1" style="border-collapse: collapse">'
                    +'<tr><th style='+tdHead+'>Customer/Prospect Name</th>'
                    +'<th style='+tdHead+'>Classification</th>'
                    +'<th style='+tdHead+'>Last Date of Contact</th>'
                    +'<th style='+tdHead+'>Link to Customer/Prospect Record</th></tr>';
                for(Account accountRecord:listOfUncoveredAccounts)
                {
                    displayDate = accountRecord.WT_Last_Date_Of_Contact__c !=null? DateTime.newInstance(accountRecord.WT_Last_Date_Of_Contact__c.year(), accountRecord.WT_Last_Date_Of_Contact__c.month(), accountRecord.WT_Last_Date_Of_Contact__c.day()).format('MMMMM dd, yyyy'):'';  
                    htmlBody+= '<tr><td style='+td1+'>'+accountRecord.name+'</td>'
                        +'<td style='+td1+'>'+mapApiLabelValues.get(accountRecord.wt_Classification__c)+'</td>'
                        +'<td style='+td1+'>'+displayDate+'</td>'
                        +'<td style='+td1+'><a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+accountRecord.id+'">'+accountRecord.Name+'</a></td></tr>';
                }                    
                htmlBody+='</table></center><br/>'
                    +'<p>Please refer to the Coverage Rules for your LOB on the CRM Wintranet page: <a href="'+system.label.WT_CoverageRulesLink+'">Click Here</a></p><p>'
                    +'<span style="font-family:"Courier New", Courier, monospace; color:Black; font-weight:bold; font-size:larger;">Sincerely,<br/>CRM Support</br>crmsupport@wintrust.com</span></p></div>';
                mail.setHtmlBody(htmlBody);                
                listOfMail.add(mail);
            }
            //Messaging.sendEmail(listOfMail);
        }
    } 
}