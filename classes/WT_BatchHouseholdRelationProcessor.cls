//Code coverage: WT_BatchHouseholdRelationProcessor_T
global class WT_BatchHouseholdRelationProcessor implements Database.Batchable<sobject>, Database.Stateful
{
    global Database.QueryLocator start(Database.BatchableContext bc)
    {	
        DateTime time15MinutesBeforeNow = System.now().addMinutes(-15);
        return Database.getQueryLocator(
            [SELECT Id,
             WT_Household_Id__c,
             WT_Contact_Id__c,
             WT_Date_Added__c,
             WT_Date_Processed__c
             FROM WT_Household_Relation_To_Process_Log__c
             WHERE WT_Date_Processed__c = null
             AND WT_Date_Added__c <= :time15MinutesBeforeNow
             ORDER BY WT_Date_Added__c
            ]
        );
    }
    
    global void execute(Database.BatchableContext bc, List<WT_Household_Relation_To_Process_Log__c> scope) 
    {
        List<AccountContactRelation> listAccountContactRelationToProcess = new List<AccountContactRelation>();
        Set<Id> setPersonContactIdToProcess = new Set<Id>();
        Set<Id> setHouseholdIdToProcess = new Set<Id>();
        Set<Id> setAccountAccountRelationIdToQuery = new Set<Id>();
        for(WT_Household_Relation_To_Process_Log__c logToProcess : scope)
        {
            if(String.isNotBlank(logToProcess.WT_Contact_Id__c))
            {
                setPersonContactIdToProcess.add(logToProcess.WT_Contact_Id__c);
            }
            if(String.isNotBlank(logToProcess.WT_Household_Id__c))
            {
                setHouseholdIdToProcess.add(logToProcess.WT_Household_Id__c);
            }
            
            logToProcess.WT_Date_Processed__c = System.now();
        }
        
        if(!setPersonContactIdToProcess.isEmpty())
        {
            WT_PersonAccountHouseholdProcessor.ProcessAccountContactRelation(setPersonContactIdToProcess);
            WT_HouseholdActionPlanProcessor.ProcessAccountContactRelation(setPersonContactIdToProcess);
        }
        
        if(!setHouseholdIdToProcess.isEmpty())
        {
            WT_HouseholdProcessor.ProcessAccountContactRelation(setHouseholdIdToProcess);
        }
        
        update scope;
    }
    
    global void finish(Database.BatchableContext bc) 
    {
        Datetime time15MinutesFromNow = System.now().addMinutes(15);
        String chronExpression = '' + time15MinutesFromNow.second() + ' ' + time15MinutesFromNow.minute() + ' ' + time15MinutesFromNow.hour() + ' ' + time15MinutesFromNow.day() + ' ' + time15MinutesFromNow.month() + ' ? ' + time15MinutesFromNow.year();     
        if(!Test.isRunningTest())
        {
            WT_BatchHouseholdRelationProcessorSch batchToSchedule = new WT_BatchHouseholdRelationProcessorSch();
            
            //Schedule the next job, and give it the system time so name is unique
            System.schedule('WT_BatchRelationshipProcessor' + time15MinutesFromNow.getTime(), chronExpression, batchToSchedule);    
        }
    } 
}