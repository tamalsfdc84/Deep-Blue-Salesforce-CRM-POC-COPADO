/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_BatchOpportunityTreasuryManagement
* @Author			Vamsi Pulikallu	<VPulikal@wintrust.com>
* @ModifiedBy		Vamsi Pulikallu	<VPulikal@wintrust.com>
* @Version			v1.0
* @CreatedDate		15 Feb 2021
* @ModifiedDate		22 Nov 2021
* @UsedBy			
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is used to create TM Calls for TM opportunities and send emails regarding the same
* --------------------------------------------------------------------------------------------------------------
* @Changes
* v1.0
*--------------------------------------------------------------------------------------------------------------
**/
// Code Coverage: WT_BatchOpportunity_T
public class WT_BatchOpportunityTreasuryManagement implements Database.Batchable<sObject>, Database.Stateful
{
    Map<id,id> mapUserIds = new MaP<id,id>();
    List<Opportunity> listUpdateOpportunity = New List<Opportunity>();
    List<OpportunityTeamMember> listOpportunityTeamMember = New List<OpportunityTeamMember>();
    list<Task> listDay14tasks = new list<Task>();
    list<Task> listDay60tasks = new list<Task>();
    list<Task> insertedTasks = new list<Task>();    
    map<Id,Task> mapDay14Task = new map<Id,Task>();
    map<Id,Task> mapDay60Task = new map<Id,Task> ();
    list<WT_Activity_Extension__c> insertDay14activityExtension= new list<WT_Activity_Extension__c>();
    list<WT_Activity_Extension__c> insertDay60activityExtension= new list<WT_Activity_Extension__c>();
    map<Id,WT_Activity_Extension__c> mapDay14activityExtension = new map<Id,WT_Activity_Extension__c>();
    map<Id,WT_Activity_Extension__c> mapDay60activityExtension = new map<Id,WT_Activity_Extension__c> ();
    Id tmTaskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('TM_Call').getRecordTypeId();
    Id tmActivityExtensionRecordTypeId = Schema.SObjectType.WT_Activity_Extension__c.getRecordTypeInfosByDeveloperName().get('TM_Call').getRecordTypeId();
    public Database.QueryLocator start(Database.BatchableContext bc) 
    {
        String query = 'SELECT Id, name, CloseDate, Amount, WT_TMOnboarding_Eligible__c , WT_TM_Onboarding_Workflow_Executed__c, WT_Changes_to_TM_Onboarding_Process__c, StageName, WT_Actual_Close_Date__c, WT_New_Dollar__c,WT_Product__r.Name, Account.name , Owner.Name, Owner.Email, OwnerId,account.personcontactid,account.id  FROM Opportunity WHERE RecordType.DeveloperName =\'WT_TM\' AND ';
        query += 'WT_Status__c = \'Closed/Won\' AND (WT_Product__r.Name =\'Credit Card - Business\' OR WT_Product__r.Name =\'TM - Incremental Deposits - Non-Interest Bearing\' OR WT_Product__r.Name =\'TM - Merchant Services\' OR WT_Product__r.Name =\'TM - Incremental Deposits - Interest Bearing\' OR WT_Product__r.Name =\'TM - Treasury Management Services\' OR WT_Product__r.Name =\'TM - Recapture\') ';
        query += 'AND((WT_TMOnboarding_Eligible__c = true AND (WT_Changes_to_TM_Onboarding_Process__c =\'No Changes to Automatic Onboarding Process\' OR WT_Changes_to_TM_Onboarding_Process__c =\'Manual Change - Kick off process with fee under threshold\'))';
        query += ' OR (WT_TMOnboarding_Eligible__c = false AND WT_Changes_to_TM_Onboarding_Process__c =\'Manual Change - Kick off process with fee under threshold\')) AND WT_Actual_Close_Date__c = YESTERDAY ORDER BY WT_Actual_Close_Date__c';
        //String query = 'SELECT Id, name, CloseDate, Probability,Amount, WT_TMOnboarding_Eligible__c , WT_TM_Onboarding_Workflow_Executed__c, WT_Changes_to_TM_Onboarding_Process__c, StageName, WT_Actual_Close_Date__c, WT_New_Dollar__c,WT_Product__r.Name, Account.name , Owner.Name, Owner.Email, OwnerId,account.personcontactid,account.id  FROM Opportunity WHERE Id=\'0061800000DRPGPAA5\'';
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext bc, List<Opportunity> scope)
    {
        string primaryObjective = system.label.WT_TM_Primary_Objective_Of_Call;
        map<Id,Id> mapUserIds = new map<Id,Id>();
        List<OpportunityTeamMember> listOpportunityTeamMember = [SELECT Id, OpportunityId,TeamMemberRole, Name, UserId, User.Email,User.ManagerId FROM OpportunityTeamMember WHERE OpportunityId IN: scope AND TeamMemberRole='Product Partner' AND User.WT_Line_of_Business__c='Treasury Management'];
        if(listOpportunityTeamMember.size()>0)
        {
            for(OpportunityTeamMember opportunityTeamMemberRecord:listOpportunityTeamMember)
            {
                mapUserIds.put(opportunityTeamMemberRecord.opportunityId, opportunityTeamMemberRecord.UserId);
            }
        }
        for(Opportunity opportunityRecord : scope) 
        {
            if(mapUserIds.get(opportunityRecord.id) != null)
            {
                WT_Activity_Extension__c Day14activityExtension = new WT_Activity_Extension__c(
                    WT_TM_Onboarding_Call__c = '14 Days', WT_Activity_Type__c = 'Task', WT_Primary_Objective_Call__c = primaryObjective,
                    WT_TM_Onboarding_Due_Date__c = system.today()+13,OwnerId=mapUserIds.get(opportunityRecord.id),RecordTypeId = tmActivityExtensionRecordTypeId);
                mapDay14activityExtension.put(opportunityRecord.id,Day14activityExtension);
                WT_Activity_Extension__c Day60activityExtension = new WT_Activity_Extension__c(
                    WT_TM_Onboarding_Call__c = '60 Days', WT_Activity_Type__c = 'Task', WT_Primary_Objective_Call__c = primaryObjective,
                    WT_TM_Onboarding_Due_Date__c = system.today()+59,OwnerId=mapUserIds.get(opportunityRecord.id),RecordTypeId = tmActivityExtensionRecordTypeId);
                mapDay60activityExtension.put(opportunityRecord.id,Day60activityExtension);
                Task Day14Task = new Task(WhatId = opportunityRecord.Id, Subject = '14 Day TM Onboarding Call – '+opportunityRecord.Account.Name,
                                          RecordTypeId = tmTaskRecordTypeId,OwnerId = mapUserIds.get(opportunityRecord.id),ActivityDate = system.today()+13);
                if(opportunityRecord.Account.personContactId != null)
                {
                    Day14Task.WhoId = opportunityRecord.Account.personContactId;
                }
                listDay14tasks.add(Day14Task);
                mapDay14Task.put(opportunityRecord.id,Day14Task);
                Task Day60Task = new Task(WhatId = opportunityRecord.Id, Subject = '60 Day TM Onboarding Call – '+opportunityRecord.Account.Name,
                                          RecordTypeId = tmTaskRecordTypeId,OwnerId = mapUserIds.get(opportunityRecord.id),ActivityDate = system.today()+59);
                if(opportunityRecord.Account.personContactId != null)
                {
                    Day60Task.WhoId = opportunityRecord.Account.personContactId;
                }
                listDay60tasks.add(Day60Task);
                mapDay60Task.put(opportunityRecord.id,Day60Task);
                opportunityRecord.WT_TM_Onboarding_Workflow_Executed__c = true;
                listUpdateOpportunity.add(opportunityRecord);
            }
        }
        
        if(mapDay14Task!=null)
        {            
            list<Task> insert14DayTasks = new list<Task>();
            if(listDay14tasks.size()>0)
            {
                database.insert (listDay14tasks,false);
                insertedTasks.addAll(listDay14tasks);
                for(Task taskRecord:listDay14tasks)
                {
                    if(taskRecord.Id != null)
                    {   
                        for(Id OpportunityId: mapDay14Task.keySet())
                        {
                            if(mapDay14Task.get(OpportunityId)!= null)
                            {  
                                WT_Activity_Extension__c day14Activity = mapDay14activityExtension.get(OpportunityId);
                                if(day14Activity != null)
                                {
                                    day14Activity.WT_TaskId__c = taskRecord.Id;
                                    day14Activity.WT_Record_Type_Name__c = 'TM_Call';
                                    if(!insertDay14activityExtension.contains(day14Activity))
                                    {                                        
                                        insertDay14activityExtension.add(day14Activity);
                                    }
                                }                             
                            }
                        }
                    }
                }
                if(insertDay14activityExtension.size()>0)
                {
                    database.insert (insertDay14activityExtension,false);
                }
            }
        }
        if(mapDay60Task!=null)
        {            
            list<Task> insert60DayTasks = new list<Task>();
            if(listDay60tasks.size()>0)
            {
                database.insert (listDay60tasks,false);
                insertedTasks.addAll(listDay60tasks);
                for(Task taskRecord:listDay60tasks)
                {
                    if(taskRecord.Id != null)
                    {   
                        for(Id OpportunityId: mapDay60Task.keySet())
                        {
                            if(mapDay14Task.get(OpportunityId)!= null)
                            {  
                                WT_Activity_Extension__c day60Activity = mapDay60activityExtension.get(OpportunityId);
                                if(day60Activity != null)
                                {
                                    day60Activity.WT_TaskId__c = taskRecord.Id;
                                    day60Activity.WT_Record_Type_Name__c = 'TM_Call';
                                    if(!insertDay60activityExtension.contains(day60Activity))
                                    {                                        
                                        insertDay60activityExtension.add(day60Activity);
                                    }
                                }                              
                            }
                        }
                    }
                }
                if(insertDay60activityExtension.size()>0)
                {
                    database.insert(insertDay60activityExtension,false);
                }
            }
        }        
    }
    public void finish(Database.BatchableContext bc)
    {
        if(listUpdateOpportunity.size()>0)
        {
            Database.update(listUpdateOpportunity,false);
        }        
        Database.executeBatch(new WT_BatchOpportunityInsertTMSendEmail(insertedTasks), 50);        
    }
}