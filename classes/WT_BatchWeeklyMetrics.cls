/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_BatchWeeklyMetric
* @Author			Anitha jaini	<ajaini@wintrust.com>
* @ModifiedBy		Anitha Jaini	<ajaini@wintrust.com>
* @Version			v1.0
* @CreatedDate		07-15-2022
* @UsedBy			
* --------------------------------------------------------------------------------------------------------------
* @Description
* This job consolidates the various metrics that business is looking for and sends out an email with the summary
* on a weekly basis
*
*
* --------------------------------------------------------------------------------------------------------------
* @Changes
* v1.0
* 07-15-2022
* --------------------------------------------------------------------------------------------------------------
**/
// Code Coverage: WT_BatchWeeklyMetric_T
global class WT_BatchWeeklyMetrics implements Database.Batchable<sobject>, Database.Stateful
{
    global String newWeeklyMetricId;
    global Database.QueryLocator start(Database.BatchableContext bc)
    {	
        Date today = System.today();        
        DescribeSObjectResult describeResult = WT_Weekly_Metric__c.getSObjectType().getDescribe();	
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );	
        String query = ' SELECT ' + String.join( fieldNames, ',' ) +
            ' FROM ' +	      
            describeResult.getName() +
            ' ORDER BY CreatedDate Desc ' +
            ' LIMIT 1';
        
        return Database.getQueryLocator(
            query
        );
    }
    
    global void execute(Database.BatchableContext bc, List<sObject> scope) 
    {
        Id businessAccountCustomerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('BusinessAccount_Customer').getRecordTypeId();
        Id businessAccountProspectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('BusinessAccount_Prospect').getRecordTypeId();
        Id personAccountCustomerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Customer').getRecordTypeId();
        Id personAccountProspectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Prospect').getRecordTypeId();
        Id accountRelationshipGroupRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Relationship_Group').getRecordTypeId();
        Id accountHouseholdRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('IndustriesHousehold').getRecordTypeId();
        
        List<WT_Weekly_Metric__c> listMetricToUpsert = new List<WT_Weekly_Metric__c>();
        WT_Weekly_Metric__c previousMetrics = (WT_Weekly_Metric__c)scope[0];
        WT_Weekly_Metric__c metricToProcess = new WT_Weekly_Metric__c();
        DateTime lastBatchRunDate = previousMetrics.CreatedDate; 
        
        //# of Active User Logins
        Integer countActiveUsersCreated = [SELECT COUNT()
                                           FROM User
                                           WHERE IsActive = true];        
        metricToProcess.WT_Active_Users__c = countActiveUsersCreated;
        
        Integer countActiveUsersCreatedSinceLastRun = [SELECT COUNT()
                                                       FROM User
                                                       WHERE IsActive = true 
                                                       AND WT_Date_of_Last_Status_Change__c >=:lastBatchRunDate];
        metricToProcess.WT_Active_Users_Since_Last_Run__c = countActiveUsersCreatedSinceLastRun;
        
        //# of Activer Users with SF License
        Integer countActiverUserWithSalesforceLicense = [SELECT COUNT()
                                                         FROM User
                                                         WHERE IsActive = true 
                                                         AND Profile.UserLicense.Name='Salesforce'];
        metricToProcess.WT_Active_Users_With_SF_License__c = countActiverUserWithSalesforceLicense;
        
        Integer countActiverUserWithSalesforceLicenseSinceLastRun = [SELECT COUNT()
                                                                     FROM User
                                                                     WHERE IsActive = true 
                                                                     AND Profile.UserLicense.Name='Salesforce'
                                                                     AND CreatedDate >=:lastBatchRunDate];
        metricToProcess.WT_Active_Users_With_SF_License_Last_Run__c = countActiverUserWithSalesforceLicenseSinceLastRun;
        
        //# of Users who have logged in
        Integer countLoginTillNow = [SELECT COUNT()
                                     FROM User
                                     WHERE LastLoginDate != null];
        metricToProcess.WT_Users_Logged_In__c = countLoginTillNow;
        
        Integer countLoginSinceLastRun = [SELECT COUNT()
                                          FROM User
                                          WHERE LastLoginDate != null
                                          AND WT_Date_of_Last_Status_Change__c >=:lastBatchRunDate];
        metricToProcess.WT_Users_Logged_In_Since_Last_Run__c = countLoginSinceLastRun;
        
        // # of newly created users who have logged in
        Integer countNewLoginSinceLastRun = [SELECT COUNT()
                                             FROM User
                                             WHERE LastLoginDate != null
                                             AND WT_Date_of_Last_Status_Change__c >=:lastBatchRunDate];
        metricToProcess.WT_Newly_Created_Users_logged_In__c = countNewLoginSinceLastRun;
        
        //# of Accounts
        Integer countAccountCreated = [SELECT COUNT() 
                                       FROM Account];
        metricToProcess.WT_Accounts_Created__c = countAccountCreated;
        
        Integer countAccountCreatedSinceLastRun = [SELECT COUNT() 
                                                   FROM Account 
                                                   WHERE CreatedDate>=:lastBatchRunDate];
        metricToProcess.WT_Accounts_Created_Last_Run__c = countAccountCreatedSinceLastRun;
        
        //# of Business Account Customer
        Integer countBusinessAccountCustomer = [SELECT COUNT() 
                                                FROM Account 
                                                WHERE RecordTypeId=:businessAccountCustomerRecordTypeId];
        metricToProcess.WT_Business_Account_Customer__c = countBusinessAccountCustomer;
        
        Integer countBusinessAccountCustomerSinceLastRun = [SELECT COUNT() 
                                                            FROM Account 
                                                            WHERE RecordTypeId=:businessAccountCustomerRecordTypeId 
                                                            AND CreatedDate>=:lastBatchRunDate];
        metricToProcess.WT_Bus_Acc_Cust_Created_Last_Run__c = countBusinessAccountCustomerSinceLastRun;
        
        //# of Business Account Propsect
        Integer countBusinessAccountProspect = [SELECT COUNT() 
                                                FROM Account 
                                                WHERE RecordTypeId=:businessAccountProspectRecordTypeId];
        metricToProcess.WT_Business_Account_Prospect__c = countBusinessAccountProspect;
        
        Integer countBusinessAccountProspectSinceLastRun = [SELECT COUNT() 
                                                            FROM Account 
                                                            WHERE RecordTypeId=:businessAccountCustomerRecordTypeId 
                                                            AND CreatedDate>=:lastBatchRunDate];
        metricToProcess.WT_Bus_Acc_Prosp_Created_Last_Run__c = countBusinessAccountProspectSinceLastRun;
        
        //# of Person Account Customer
        Integer countPersonAccountCustomer = [SELECT COUNT() 
                                              FROM Account 
                                              WHERE RecordTypeId=:personAccountCustomerRecordTypeId];
        metricToProcess.WT_Person_Account_Customer__c = countPersonAccountCustomer;
        
        Integer countPersonAccountCustomerSinceLastRun = [SELECT COUNT() 
                                                          FROM Account 
                                                          WHERE RecordTypeId=:personAccountCustomerRecordTypeId 
                                                          AND CreatedDate>=:lastBatchRunDate];
        metricToProcess.WT_Person_Acc_Cust_Created_Last_Run__c = countPersonAccountCustomerSinceLastRun;
        
        //# of Person Account Prospect
        Integer countPersonAccountPropsect = [SELECT COUNT() 
                                              FROM Account 
                                              WHERE RecordTypeId=:personAccountProspectRecordTypeId];
        metricToProcess.WT_Person_Account_Prospect__c = countPersonAccountPropsect;
        
        Integer countPersonAccountProspectSinceLastRun = [SELECT COUNT() 
                                                          FROM Account 
                                                          WHERE RecordTypeId=:personAccountProspectRecordTypeId 
                                                          AND CreatedDate>=:lastBatchRunDate];
        metricToProcess.WT_Person_Acc_Prosp_Created_Last_Run__c = countPersonAccountProspectSinceLastRun;
        
        //# of Relationship groups
        Integer countAccountRelationshipGroup = [SELECT COUNT() 
                                                 FROM Account 
                                                 WHERE RecordTypeId=:accountRelationshipGroupRecordTypeId];
        metricToProcess.WT_Account_Relationship_Groups__c = countAccountRelationshipGroup;
        
        Integer countRelationshipGroupSinceLastRun = [SELECT COUNT() 
                                                      FROM Account 
                                                      WHERE RecordTypeId=:accountRelationshipGroupRecordTypeId 
                                                      AND CreatedDate>=:lastBatchRunDate];
        metricToProcess.WT_Acc_relationship_grp_Created_Last_Run__c = countRelationshipGroupSinceLastRun;
        
        //# of Household
        Integer countAccountHousehold = [SELECT COUNT() 
                                         FROM Account 
                                         WHERE RecordTypeId=:accountHouseholdRecordTypeId];
        metricToProcess.WT_Households__c = countAccountHousehold;
        
        Integer countAccountHouseholdSinceLastRun = [SELECT COUNT() 
                                                     FROM Account 
                                                     WHERE RecordTypeId=:accountHouseholdRecordTypeId  
                                                     AND CreatedDate>=:lastBatchRunDate];
        metricToProcess.WT_Acc_household_Created_Last_Run__c = countAccountHouseholdSinceLastRun;
        
        //# of Events
        Integer countEventCreatedTotal = [SELECT COUNT() 
                                          FROM EVENT 
                                          WHERE WT_Status__c  !='Cancelled'];
        metricToProcess.WT_Events_Created__c = countEventCreatedTotal;
        
        Integer countEventCreatedLastRun = [SELECT COUNT() 
                                            FROM EVENT 
                                            WHERE WT_Status__c  !='Cancelled' 
                                            AND CreatedDate>=:lastBatchRunDate];
        metricToProcess.WT_Events_Created_Since_last_Run__c = countEventCreatedLastRun;
        
        //# of Phone Calls
        Integer countPhoneCallCreatedTotal = [SELECT COUNT() 
                                              FROM Task 
                                              WHERE WT_Status__c  !='Cancelled' 
                                              AND WT_Activity_Type__c = 'Phone Call' ];
        metricToProcess.WT_Phone_Calls_Created__c = countPhoneCallCreatedTotal;
        
        Integer countPhoneCallCreatedLastRun = [SELECT COUNT() 
                                                FROM Task 
                                                WHERE WT_Status__c  !='Cancelled' 
                                                AND WT_Activity_Type__c = 'Phone Call' 
                                                AND CreatedDate>=:lastBatchRunDate];
        metricToProcess.WT_Phone_Calls_Since_Created_Last_Run__c = countPhoneCallCreatedLastRun;
        
        //# of Walk Ins
        Integer countWalkInsCreatedTotal = [SELECT COUNT() 
                                            FROM Task
                                            WHERE WT_Status__c  !='Cancelled' 
                                            AND WT_Activity_Type__c = 'Walk-in'];
        metricToProcess.WT_Walk_Ins_Created__c = countWalkInsCreatedTotal;
        
        Integer countWalkInsCreatedLastRun = [SELECT COUNT() 
                                              FROM Task
                                              WHERE WT_Status__c  !='Cancelled' 
                                              AND WT_Activity_Type__c = 'Walk-in' 
                                              AND CreatedDate>=:lastBatchRunDate];
        metricToProcess.WT_Walk_Ins_Created_Since_last_Run__c = countWalkInsCreatedLastRun;    
        
        //# of Commercial Onboarding
        Integer countCommercialActionPlansCreatedTotal = [SELECT COUNT() 
                                                          FROM ActionPlan 
                                                          WHERE ActionPlanTemplateVersion.Name='Commercial Onboarding'];
        metricToProcess.WT_Commercial_Action_Plans__c = countCommercialActionPlansCreatedTotal;
        
        Integer countCommercialActionPlansCreatedLastRun = [SELECT COUNT() 
                                                            FROM ActionPlan 
                                                            WHERE ActionPlanTemplateVersion.Name='Commercial Onboarding' 
                                                            AND CreatedDate>=:lastBatchRunDate];
        metricToProcess.WT_Commercial_Action_Plan_Since_Last_Run__c = countCommercialActionPlansCreatedLastRun;
        
        //# of Retail Customer Onboarding
        Integer countRetailActionPlansCreatedTotal = [SELECT COUNT() 
                                                      FROM ActionPlan 
                                                      WHERE ActionPlanTemplateVersion.Name='Retail Customer Onboarding'];
        metricToProcess.WT_Retail_Action_Plans__c = countRetailActionPlansCreatedTotal;
        
        Integer countRetailActionPlansCreatedLastRun = [SELECT COUNT() 
                                                        FROM ActionPlan 
                                                        WHERE ActionPlanTemplateVersion.Name='Retail Customer Onboarding' 
                                                        AND CreatedDate>=:lastBatchRunDate];
        metricToProcess.WT_Retail_Action_Plan_Since_Last_Run__c = countRetailActionPlansCreatedLastRun;
        
        //# of Other Activities
        Integer countOtherActivityCreatedTotal = [SELECT COUNT() 
                                                  FROM Task WHERE Status !='Cancelled' 
                                                  AND WT_Activity_Type__c NOT IN('Phone Call','Walk-in')];
        metricToProcess.WT_Other_Activities__c = countOtherActivityCreatedTotal;
        
        Integer countActivityCreatedLastRun = [SELECT COUNT() 
                                               FROM Task
                                               WHERE Status !='Cancelled' 
                                               AND WT_Activity_Type__c NOT IN('Phone Call','Walk-in') 
                                               AND CreatedDate>=:lastBatchRunDate];
        metricToProcess.WT_Other_Activities_Since_Last_Run__c = countActivityCreatedLastRun;
        
        //# of Referrals 
        Integer countLeadCreatedTotal = [SELECT COUNT() 
                                         FROM Lead];
        metricToProcess.WT_Referrals_Created__c = countLeadCreatedTotal;
        
        Integer countLeadCreatedLastRun = [SELECT COUNT() 
                                           FROM Lead
                                           WHERE CreatedDate>=:lastBatchRunDate];
        metricToProcess.WT_Referrals_Created_Since_Last_Run__c = countLeadCreatedLastRun;
        
        // # of Qualified Referrals
        Integer countLeadQualifiedTotal = [SELECT COUNT() 
                                           FROM Lead 
                                           WHERE Status LIKE '%Qualified%'];
        metricToProcess.WT_Referrals_Qualified__c = countLeadQualifiedTotal;
        
        Integer countLeadQualifiedLastRun = [SELECT COUNT() 
                                             FROM Lead 
                                             WHERE Status 
                                             LIKE '%Qualified%'                                              
                                             AND WT_Date_Qualified__c>=:date.valueof(lastBatchRunDate)
                                            ];
        metricToProcess.WT_Referrals_Qualified_Since_Last_Run__c = countLeadQualifiedLastRun;        
        
        //# of Referrals Qualified Converted
        Integer countLeadQualifiedConvertedTotal = [SELECT COUNT() 
                                                    FROM Lead 
                                                    WHERE Status = 'Qualified - Converted'];
        metricToProcess.WT_Referrals_Qualified_Converted__c = countLeadQualifiedConvertedTotal;
        
        Integer countLeadQualifiedConvertedLastRun = [SELECT COUNT() 
                                                      FROM Lead 
                                                      WHERE Status = 'Qualified - Converted'                                                       
                                                      AND WT_Date_Qualified__c>=:date.valueof(lastBatchRunDate)
                                                     ];
        metricToProcess.WT_Ref_Qualified_Converted_Last_Run__c = countLeadQualifiedConvertedLastRun;
        
        //# of Sales Opportunities
        Integer countOpportunityCreatedTotal = [SELECT COUNT() 
                                                FROM Opportunity];		
        metricToProcess.WT_Sales_Opportunities_Created__c = countOpportunityCreatedTotal;
        
        Integer countOpportunityCreatedLastRun = [SELECT COUNT() 
                                                  FROM Opportunity
                                                  WHERE CreatedDate>=:lastBatchRunDate];		
        metricToProcess.WT_Sales_Opp_Created_Since_last_Run__c = countOpportunityCreatedLastRun;
        
        //# of Sales Opportunities - Closed Won
        Integer countOpportunityCreatedClosedWonTotal = [SELECT COUNT() 
                                                         FROM Opportunity 
                                                         WHERE WT_Status__c = 'Closed/Won'];		
        metricToProcess.WT_Sales_Opportunities_Won__c = countOpportunityCreatedClosedWonTotal;
        
        Integer countOpportunityCreatedClosedWonLastRun = [SELECT COUNT() 
                                                           FROM Opportunity 
                                                           WHERE WT_Status__c = 'Closed/Won' 
                                                           AND WT_actual_close_date__c>=:lastBatchRunDate];
        metricToProcess.WT_Sales_Opp_Won_Since_Last_Run__c = countOpportunityCreatedClosedWonLastRun;
        
        //# of Sales Opportunities - Cloased Lost
        Integer countOpportunityCreatedClosedLostTotal = [SELECT COUNT() 
                                                          FROM Opportunity 
                                                          WHERE WT_Status__c = 'Closed/Lost'];		
        metricToProcess.WT_Sales_Opportunities_Lost__c = countOpportunityCreatedClosedLostTotal;
        
        Integer countOpportunityCreatedClosedLostLastRun = [SELECT COUNT() 
                                                            FROM Opportunity 
                                                            WHERE WT_Status__c = 'Closed/Lost'
                                                            AND WT_actual_close_date__c>=:lastBatchRunDate];		
        metricToProcess.WT_Opp_Lost_Since_Last_Run__c = countOpportunityCreatedClosedLostLastRun;
        
        //# of Cases
        Integer countCaseNotMyHRTotal = [SELECT COUNT() 
                                         FROM Case 
                                         WHERE recordtype.name != 'myHR'];
        metricToProcess.WT_Cases_Created__c = countCaseNotMyHRTotal;
        
        Integer countCaseNotMyHRLastRun = [SELECT COUNT() 
                                           FROM Case 
                                           WHERE recordtype.name != 'myHR' 
                                           AND CreatedDate>=:lastBatchRunDate];
        metricToProcess.WT_Cases_Created_Since_Last_Run__c = countCaseNotMyHRLastRun; 
        
        listMetricToUpsert.add(metricToProcess);
        
        if(listMetricToUpsert.size()>0) 
        {
        upsert listMetricToUpsert; 
        }
        newWeeklyMetricId = listMetricToUpsert[0].Id;
        
        WeeklyReferralMetrics(newWeeklyMetricId, lastBatchRunDate);
        WeeklyOpportunityMetrics(newWeeklyMetricId, lastBatchRunDate);       
    }

    global void finish(Database.BatchableContext b) 
    {
        if(newWeeklyMetricId != Null)
        {
        SendEmailNotification(newWeeklyMetricId);
        }
    }

    public void WeeklyReferralMetrics(Id weeklyMetricsId, DateTime lastBatchRunDate) 
    {
        List<AggregateResult> listLeadConverted = [SELECT COUNT(Id),
                                                   WT_Referred_To__r.WT_Line_of_Business__c,
                                                   Status
                                                   FROM Lead
                                                   WHERE Status IN('Qualified - Not Converted','Qualified - Converted')
                                                   AND WT_Date_Qualified__c>=:date.valueof(lastBatchRunDate)
                                                   GROUP BY WT_Referred_To__r.WT_Line_of_Business__c, Status];
        
        WT_Weekly_Referral_Metric__c WeeklyReferralMetric;        
        Map<String, WT_Weekly_Referral_Metric__c> lobReferalMetric = new Map<String, WT_Weekly_Referral_Metric__c>();
        String lineOfBusiness;
        
        for(AggregateResult result : listLeadConverted)
        {
            lineOfBusiness = result.get('WT_Line_of_Business__c') != null ? String.valueOf(result.get('WT_Line_of_Business__c')) : null;
            
            if(lobReferalMetric.containsKey(lineOfBusiness) && String.isNotBlank(lineOfBusiness)) 
            {
                WeeklyReferralMetric = lobReferalMetric.get(lineOfBusiness);
                WeeklyReferralMetric.WT_Referral_Qualified_By_LOB__c += result.get('expr0') != null ? Integer.valueOf(String.valueOf(result.get('expr0'))) : 0;
                if(result.get('Status') == 'Qualified - Converted') 
                {
                    WeeklyReferralMetric.WT_Referral_Qualified_Converted_By_LOB__c = result.get('expr0') != null ? Integer.valueOf(String.valueOf(result.get('expr0'))) : 0;
                }
            }
            else if(String.isNotBlank(lineOfBusiness))
            {
                WeeklyReferralMetric = new WT_Weekly_Referral_Metric__c();
                WeeklyReferralMetric.WT_Weekly_Metric__c = weeklyMetricsId;
                WeeklyReferralMetric.WT_Line_Of_Business__c = lineOfBusiness;
                WeeklyReferralMetric.WT_Referral_Qualified_Converted_By_LOB__c = 0;
                WeeklyReferralMetric.WT_Referral_Submitted_By_LOB__c = 0;
                if(result.get('Status') == 'Qualified - Converted')
                {
                    WeeklyReferralMetric.WT_Referral_Qualified_Converted_By_LOB__c = result.get('expr0') != null ? Integer.valueOf(String.valueOf(result.get('expr0'))) : 0;
                }
                WeeklyReferralMetric.WT_Referral_Qualified_By_LOB__c = WeeklyReferralMetric.WT_Referral_Qualified_Converted_By_LOB__c +
                    (result.get('expr0') != null ? Integer.valueOf(String.valueOf(result.get('expr0'))) : 0);
                lobReferalMetric.put(lineOfBusiness,WeeklyReferralMetric);
            }
        }
        List<AggregateResult> listLeadSubmitted = [SELECT COUNT(Id),
                                                   FinServ__ReferredByUser__r.WT_Line_of_Business__c
                                                   FROM Lead
                                                   WHERE CreatedDate>=:lastBatchRunDate
                                                   GROUP BY FinServ__ReferredByUser__r.WT_Line_of_Business__c];
        for(AggregateResult result : listLeadSubmitted) 
        {
            lineOfBusiness = result.get('WT_Line_of_Business__c') != null ? String.valueOf(result.get('WT_Line_of_Business__c')) : null;
            if(String.isNotBlank(lineOfBusiness) && lobReferalMetric.containsKey(lineOfBusiness)) 
            {
                WeeklyReferralMetric = lobReferalMetric.get(lineOfBusiness);
                WeeklyReferralMetric.WT_Referral_Submitted_By_LOB__c = result.get('expr0') != null ? Integer.valueOf(String.valueOf(result.get('expr0'))) : 0;
            } 
            else if(String.isNotBlank(lineOfBusiness)) 
            {
                WeeklyReferralMetric = new WT_Weekly_Referral_Metric__c();
                WeeklyReferralMetric.WT_Weekly_Metric__c = weeklyMetricsId;
                WeeklyReferralMetric.WT_Line_Of_Business__c = lineOfBusiness;                
                WeeklyReferralMetric.WT_Referral_Qualified_Converted_By_LOB__c = result.get('expr0') != null ? Integer.valueOf(String.valueOf(result.get('expr0'))) : 0;
                WeeklyReferralMetric.WT_Referral_Qualified_By_LOB__c = result.get('expr0') != null ? Integer.valueOf(String.valueOf(result.get('expr0'))) : 0;
                WeeklyReferralMetric.WT_Referral_Submitted_By_LOB__c = result.get('expr0') != null ? Integer.valueOf(String.valueOf(result.get('expr0'))) : 0;
                lobReferalMetric.put(lineOfBusiness,WeeklyReferralMetric);
            }
        }
        
        if(lobReferalMetric.size()>0) 
        {
            upsert lobReferalMetric.values();
        }
    }
    
    public void WeeklyOpportunityMetrics(Id weeklyMetricsId, DateTime lastBatchRunDate) 
    {
        List<AggregateResult> listSalesOppCreated = [SELECT COUNT(ID),
                                                     owner.WT_Line_Of_Business__c,
                                                     SUM(WT_New_Dollar__c) 
                                                     FROM Opportunity 
                                                     WHERE CreatedDate>=:lastBatchRunDate 
                                                     GROUP BY owner.WT_Line_Of_Business__c
                                                     ORDER BY Owner.WT_Line_Of_Business__c                                           
                                                    ];    
        WT_Weekly_Opportunity_Metric__c weeklyOpportunityMetric;        
        Map<String, WT_Weekly_Opportunity_Metric__c> mapLOBOpportunityMetric = new Map<String, WT_Weekly_Opportunity_Metric__c>();
        String lineOfBusiness;
        
        for(AggregateResult result : listSalesOppCreated) 
        {
            lineOfBusiness = result.get('WT_Line_of_Business__c') != null ? String.valueOf(result.get('WT_Line_of_Business__c')) : null;
            if(String.isNotBlank(lineOfBusiness)) 
            {
                weeklyOpportunityMetric = new WT_Weekly_Opportunity_Metric__c();
                weeklyOpportunityMetric.WT_Weekly_Metric__c = weeklyMetricsId;
                weeklyOpportunityMetric.WT_Line_Of_Business__c = lineOfBusiness;
                weeklyOpportunityMetric.WT_Sales_Opportunities__c = result.get('expr0') != null ? Integer.valueOf(String.valueOf(result.get('expr0'))) : 0;
                weeklyOpportunityMetric.WT_Opp_New_In_Dollar__c = result.get('expr1') != null ? Double.valueOf(Double.valueOf(result.get('expr1'))) : 0;
                mapLOBOpportunityMetric.put(lineOfBusiness,weeklyOpportunityMetric);
            }
        }
        List<AggregateResult> listOppClosedWonLostCreated = [SELECT count(Id), 
                                                             Owner.WT_Line_of_Business__c, 
                                                             SUM(WT_New_Dollar__c) , 
                                                             WT_Status__c 
                                                             FROM Opportunity
                                                             WHERE WT_Status__c IN ('Closed/Won','Closed/Lost')
                                                             AND WT_actual_close_date__c>=:lastBatchRunDate
                                                             GROUP BY Owner.WT_Line_of_Business__c,WT_Status__c    
                                                             ORDER BY Owner.WT_Line_Of_Business__c ];
        
        for(AggregateResult result : listOppClosedWonLostCreated) 
        {
            lineOfBusiness = result.get('WT_Line_of_Business__c') != null ? String.valueOf(result.get('WT_Line_of_Business__c')) : null;
            String statusValue = result.get('WT_Status__c') != null ? String.valueOf(result.get('WT_Status__c')) : null;
            if(String.isNotBlank(statusValue) && statusValue == 'Closed/Won') 
            {
                if(String.isNotBlank(lineOfBusiness) && mapLOBOpportunityMetric.containsKey(lineOfBusiness)) 
                {
                    weeklyOpportunityMetric = mapLOBOpportunityMetric.get(lineOfBusiness);
                    weeklyOpportunityMetric.WT_Opportunities_Won__c = result.get('expr0') != null ? Integer.valueOf(String.valueOf(result.get('expr0'))) : 0;
                    weeklyOpportunityMetric.WT_Opportunities_Won_In_Dollars__c = result.get('expr1') != null ? Double.valueOf(Double.valueOf(result.get('expr1'))) : 0;
                }
                else if(String.isNotBlank(lineOfBusiness))
                {
                    weeklyOpportunityMetric = new WT_Weekly_Opportunity_Metric__c();
                    weeklyOpportunityMetric.WT_Weekly_Metric__c = weeklyMetricsId;
                    weeklyOpportunityMetric.WT_Line_Of_Business__c = lineOfBusiness;
                    weeklyOpportunityMetric.WT_Opportunities_Won__c = result.get('expr0') != null ? Integer.valueOf(String.valueOf(result.get('expr0'))) : 0;
                    weeklyOpportunityMetric.WT_Opportunities_Won_In_Dollars__c = result.get('expr1') != null ? Double.valueOf(Double.valueOf(result.get('expr1'))) : 0;
                    mapLOBOpportunityMetric.put(lineOfBusiness,weeklyOpportunityMetric);
                }
            }
            if(String.isNotBlank(statusValue) && statusValue == 'Closed/Lost')
            {
                
                if(String.isNotBlank(lineOfBusiness) && mapLOBOpportunityMetric.containsKey(lineOfBusiness)) 
                {
                    weeklyOpportunityMetric = mapLOBOpportunityMetric.get(lineOfBusiness);
                    weeklyOpportunityMetric.WT_Opportunities_Lost__c = result.get('expr0') != null ? Integer.valueOf(String.valueOf(result.get('expr0'))) : 0;
                    weeklyOpportunityMetric.WT_Opportunities_Lost_In_Dollars__c = result.get('expr1') != null ? Double.valueOf(Double.valueOf(result.get('expr1'))) : 0;
                    
                }
                else if(String.isNotBlank(lineOfBusiness))
                {
                    weeklyOpportunityMetric = new WT_Weekly_Opportunity_Metric__c();
                    weeklyOpportunityMetric.WT_Weekly_Metric__c = weeklyMetricsId;
                    weeklyOpportunityMetric.WT_Line_Of_Business__c = lineOfBusiness;
                    weeklyOpportunityMetric.WT_Opportunities_Lost__c = result.get('expr0') != null ? Integer.valueOf(String.valueOf(result.get('expr0'))) : 0;
                    weeklyOpportunityMetric.WT_Opportunities_Lost_In_Dollars__c = result.get('expr1') != null ? Double.valueOf(Double.valueOf(result.get('expr1'))) : 0;
                    mapLOBOpportunityMetric.put(lineOfBusiness,weeklyOpportunityMetric);
                }
            }
            
        }        
        if(mapLOBOpportunityMetric.size()>0)
        {
            upsert mapLOBOpportunityMetric.values();
        } 											   
    }   
    
    public void SendEmailNotification(String weeklyMetricsId)
    {
        List<String> listEmailAddress = new List<String>();        

        WT_Weekly_Metric__c WeeklyMetricsList = [ SELECT Id, 
                                                 WT_Active_Users__c,                                                            
                                                 WT_Active_Users_Since_Last_Run__c,
                                                 WT_Active_Users_With_SF_License__c,
                                                 WT_Active_Users_With_SF_License_Last_Run__c,
                                                 WT_Users_Logged_In__c,
                                                 WT_Users_Logged_In_Since_Last_Run__c,
                                                 WT_Newly_Created_Users_logged_In__c,
                                                 WT_Accounts_Created__c,
                                                 WT_Accounts_Created_Last_Run__c,
                                                 WT_Business_Account_Customer__c,
                                                 WT_Bus_Acc_Cust_Created_Last_Run__c,
                                                 WT_Business_Account_Prospect__c,
                                                 WT_Bus_Acc_Prosp_Created_Last_Run__c,
                                                 WT_Person_Account_Customer__c,
                                                 WT_Person_Acc_Cust_Created_Last_Run__c,
                                                 WT_Person_Account_Prospect__c,
                                                 WT_Person_Acc_Prosp_Created_Last_Run__c,
                                                 WT_Events_Created__c,
                                                 WT_Events_Created_Since_Last_Run__c,
                                                 WT_Walk_Ins_Created__c,
                                                 WT_Walk_Ins_Created_Since_last_Run__c,
                                                 WT_Phone_Calls_Created__c,
                                                 WT_Phone_Calls_Since_Created_Last_Run__c,
                                                 WT_Commercial_Action_Plans__c,
                                                 WT_Commercial_Action_Plan_Since_Last_Run__c,
                                                 WT_Retail_Action_Plans__c,
                                                 WT_Retail_Action_Plan_Since_Last_Run__c,
                                                 WT_Other_Activities__c,
                                                 WT_Other_Activities_Since_Last_Run__c,
                                                 WT_Referrals_Created__c,
                                                 WT_Referrals_Created_Since_Last_Run__c,
                                                 WT_Referrals_Qualified__c,
                                                 WT_Referrals_Qualified_Since_Last_Run__c,
                                                 WT_Referrals_Qualified_Converted__c,
                                                 WT_Ref_Qualified_Converted_Last_Run__c,
                                                 WT_Account_Relationship_Groups__c,
                                                 WT_Acc_relationship_grp_Created_Last_Run__c,
                                                 WT_Households__c,
                                                 WT_Acc_household_Created_Last_Run__c,
                                                 WT_Sales_Opportunities_Created__c,
                                                 WT_Sales_Opp_Created_Since_last_Run__c,
                                                 WT_Sales_Opportunities_Won__c,
                                                 WT_Sales_Opp_Won_Since_Last_Run__c,
                                                 WT_Sales_Opportunities_Lost__c,
                                                 WT_Opp_Lost_Since_Last_Run__c,
                                                 WT_Cases_Created__c,
                                                 WT_Cases_Created_Since_Last_Run__c 
                                                 FROM WT_Weekly_Metric__c
                                                 WHERE Id =:weeklyMetricsId  
                                                 LIMIT 1                                           
                                                ]; 
        List<WT_Weekly_Referral_Metric__c> listWeeklyReferralMetrics = [SELECT Id, 
                                                                        WT_Line_Of_Business__c,
                                                                        WT_Referral_Submitted_By_LOB__c,
                                                                        WT_Referral_Qualified_Converted_By_LOB__c,
                                                                        WT_Referral_Qualified_By_LOB__c 
                                                                        FROM WT_Weekly_Referral_Metric__c
                                                                        WHERE WT_Weekly_Metric__c=:weeklyMetricsId
                                                                        ORDER BY WT_Line_Of_Business__c]; 
        
        List<WT_Weekly_Opportunity_Metric__c> listWeeklyOpportunityMetrics = [SELECT Id, 
                                                                              WT_Line_Of_Business__c,
                                                                              WT_Sales_Opportunities__c,
                                                                              WT_Opp_New_In_Dollar__c,
                                                                              WT_Opportunities_Won__c ,
                                                                              WT_Opportunities_Won_In_Dollars__c,
                                                                              WT_Opportunities_Lost__c,
                                                                              WT_Opportunities_Lost_In_Dollars__c
                                                                              FROM WT_Weekly_Opportunity_Metric__c
                                                                              WHERE WT_Weekly_Metric__c=:weeklyMetricsId
                                                                              ORDER BY WT_Line_Of_Business__c]; 
        
        List<EmailTemplate> listEmailTemplate = [SELECT Id, 
                                                 Body, 
                                                 HtmlValue, 
                                                 Subject,
                                                 DeveloperName
                                                 FROM EmailTemplate
                                                 WHERE DeveloperName = 'WT_Weekly_Metrics'];
        
        String subject = '';
        String htmlBody = '';
        
        if(listEmailTemplate != null && !listEmailTemplate.isEmpty())
        {
            subject = listEmailTemplate[0].Subject;
            htmlBody = listEmailTemplate[0].HtmlValue;
        }
        
        String referralInfoTableBody = '';
        String referralInfoTableBodyTemplate = '<tr>' +
            '<td>{{lineOfBusiness}}</td>' +
            '<td>{{submittedByLineOfBusiness}}</td>' +
            '<td>{{qualifiedByLineOfBusiness}}</td>' +
            '<td>{{qualifiedConvertedByLineOfBusiness}}</td>' +
            '</tr>';
        
        String opportunityInfoTableBody = '';
        String opportunityInfoTableBodyTemplate = '<tr>' +
            '<td>{{lineOfBusiness}}</td>' +
            '<td>{{totalRecordsCreated}}</td>' +
            '<td>{{NewDollarCreated}}</td>' +
            '<td>{{totalWon}}</td>' +
            '<td>{{totalDollarWon}}</td>' +
            '<td>{{totalLost}}</td>' +
            '<td>{{totalDollarLost}}</td>' +
            '</tr>';
        
        string activeUserPastWeek = String.valueof(WeeklyMetricsList.WT_Active_Users_Since_Last_Run__c);
        string activeUserTotal  = String.valueof(WeeklyMetricsList.WT_Active_Users__c);
        string activeUserWithSfPastWeek = String.valueof(WeeklyMetricsList.WT_Active_Users_With_SF_License_Last_Run__c);
        string activeUserWithSfTotal = String.valueof(WeeklyMetricsList.WT_Active_Users_With_SF_License__c);
        string userLoggedInPastWeek = String.valueof(WeeklyMetricsList.WT_Users_Logged_In_Since_Last_Run__c);
        string userLoggedInTotal = String.valueof(WeeklyMetricsList.WT_Users_Logged_In__c);
        string newlyCreatedUsersLoggedIn = String.valueof(WeeklyMetricsList.WT_Newly_Created_Users_logged_In__c);
        string accountsCreatedPastWeek = String.valueof(WeeklyMetricsList.WT_Accounts_Created_Last_Run__c);
        string accountsCreatedTotal = String.valueof(WeeklyMetricsList.WT_Accounts_Created__c);
        string businessAccountCustomerPastWeek = String.valueof(WeeklyMetricsList.WT_Bus_Acc_Cust_Created_Last_Run__c);
        string businessAccountCustomerTotal = String.valueof(WeeklyMetricsList.WT_Business_Account_Customer__c);
        string businessAccountProspectPastWeek = String.valueof(WeeklyMetricsList.WT_Bus_Acc_Prosp_Created_Last_Run__c);
        string businessAccountProspectTotal = String.valueof(WeeklyMetricsList.WT_Business_Account_Prospect__c);
        string personAccountCustomerPastWeek = String.valueof(WeeklyMetricsList.WT_Person_Acc_Cust_Created_Last_Run__c);
        string personAccountCustomerTotal = String.valueof(WeeklyMetricsList.WT_Person_Account_Customer__c);
        string personAccountProspectPastWeek = String.valueof(WeeklyMetricsList.WT_Person_Acc_Prosp_Created_Last_Run__c);
        string personAccountProspectTotal = String.valueof(WeeklyMetricsList.WT_Person_Account_Prospect__c);
        string relationshipGroupPastWeek = String.valueof(WeeklyMetricsList.WT_Acc_relationship_grp_Created_Last_Run__c);
        string relationshipGroupTotal = String.valueof(WeeklyMetricsList.WT_Account_Relationship_Groups__c);
        string householdPastWeek = String.valueof(WeeklyMetricsList.WT_Acc_household_Created_Last_Run__c);
        string householdTotal = String.valueof(WeeklyMetricsList.WT_Households__c);
        string eventsPaskWeek = String.valueof(WeeklyMetricsList.WT_Events_Created_Since_Last_Run__c);
        string eventsTotal = String.valueof(WeeklyMetricsList.WT_Events_Created__c);
        string phoneCallsPaskWeek = String.valueof(WeeklyMetricsList.WT_Phone_Calls_Since_Created_Last_Run__c);
        string phoneCallsTotal = String.valueof(WeeklyMetricsList.WT_Phone_Calls_Created__c);
        string walkInsPaskWeek = String.valueof(WeeklyMetricsList.WT_Walk_Ins_Created_Since_last_Run__c);
        string walkInsTotal = String.valueof(WeeklyMetricsList.WT_Walk_Ins_Created__c);
        string commercialActionPlanPastWeek = String.valueof(WeeklyMetricsList.WT_Commercial_Action_Plan_Since_Last_Run__c);
        string commercialActionPlanTotal = String.valueof(WeeklyMetricsList.WT_Commercial_Action_Plans__c);
        string retailActionPlanPastWeek = String.valueof(WeeklyMetricsList.WT_Retail_Action_Plan_Since_Last_Run__c);
        string retailActionPlanTotal = String.valueof(WeeklyMetricsList.WT_Retail_Action_Plans__c);
        string otherActivitiesPastWeek = String.valueof(WeeklyMetricsList.WT_Other_Activities_Since_Last_Run__c);
        string otherActivitiesTotal = String.valueof(WeeklyMetricsList.WT_Other_Activities__c);
        string referralsCreatedPastWeek = String.valueof(WeeklyMetricsList.WT_Referrals_Created_Since_Last_Run__c);
        string referralsCreatedTotal = String.valueof(WeeklyMetricsList.WT_Referrals_Created__c);
        string referralsQualifiedPastWeek = String.valueof(WeeklyMetricsList.WT_Referrals_Qualified_Since_Last_Run__c);
        string referralsQualifiedTotal = String.valueof(WeeklyMetricsList.WT_Referrals_Qualified__c);
        string referralsQualifiedConvertedPastWeek = String.valueof(WeeklyMetricsList.WT_Ref_Qualified_Converted_Last_Run__c);
        string referralQualifiedConvertedTotal = String.valueof(WeeklyMetricsList.WT_Referrals_Qualified_Converted__c);
        string opportunitiesCreatedPastWeek = String.valueof(WeeklyMetricsList.WT_Sales_Opp_Created_Since_last_Run__c);
        string opportunitiesCreatedTotal = String.valueof(WeeklyMetricsList.WT_Sales_Opportunities_Created__c);
        string opportunitiesWonPastWeek = String.valueof(WeeklyMetricsList.WT_Sales_Opp_Won_Since_Last_Run__c);
        string opportunitiesWonTotal = String.valueof(WeeklyMetricsList.WT_Sales_Opportunities_Won__c);
        string opportunitiesLostPastWeek = String.valueof(WeeklyMetricsList.WT_Opp_Lost_Since_Last_Run__c);
        string opportunitiesLostTotal = String.valueof(WeeklyMetricsList.WT_Sales_Opportunities_Lost__c);
        string casesCreatedPastWeek = String.valueof(WeeklyMetricsList.WT_Cases_Created_Since_Last_Run__c );
        string casesCreatedTotal = String.valueof(WeeklyMetricsList.WT_Cases_Created__c);
        
        htmlBody = htmlBody.replace('{{activeUserPastWeek}}',activeUserPastWeek);
        htmlBody = htmlBody.replace('{{activeUserTotal}}',activeUserTotal);
        htmlBody = htmlBody.replace('{{activeUserWithSfPastWeek}}',activeUserWithSfPastWeek);
        htmlBody = htmlBody.replace('{{activeUserWithSfTotal}}',activeUserWithSfTotal);
        htmlBody = htmlBody.replace('{{userLoggedInPastWeek}}',userLoggedInPastWeek);        
        htmlBody = htmlBody.replace('{{userLoggedInTotal}}',userLoggedInTotal);
        htmlBody = htmlBody.replace('{{newlyCreatedUsersLoggedIn}}',newlyCreatedUsersLoggedIn);
        htmlBody = htmlBody.replace('{{accountsCreatedPastWeek}}',accountsCreatedPastWeek);
        htmlBody = htmlBody.replace('{{accountsCreatedTotal}}',accountsCreatedTotal);
        htmlBody = htmlBody.replace('{{businessAccountCustomerPastWeek}}',businessAccountCustomerPastWeek);
        htmlBody = htmlBody.replace('{{businessAccountCustomerTotal}}',businessAccountCustomerTotal);
        htmlBody = htmlBody.replace('{{businessAccountProspectPastWeek}}',businessAccountProspectPastWeek);
        htmlBody = htmlBody.replace('{{businessAccountProspectTotal}}',businessAccountProspectTotal);
        htmlBody = htmlBody.replace('{{personAccountCustomerPastWeek}}',personAccountCustomerPastWeek);
        htmlBody = htmlBody.replace('{{personAccountCustomerTotal}}',personAccountCustomerTotal);
        htmlBody = htmlBody.replace('{{personAccountProspectPastWeek}}',personAccountProspectPastWeek);
        htmlBody = htmlBody.replace('{{personAccountProspectTotal}}',personAccountProspectTotal);
        htmlBody = htmlBody.replace('{{relationshipGroupPastWeek}}',relationshipGroupPastWeek);
        htmlBody = htmlBody.replace('{{relationshipGroupTotal}}',relationshipGroupTotal);
        htmlBody = htmlBody.replace('{{householdPastWeek}}',householdPastWeek);
        htmlBody = htmlBody.replace('{{householdTotal}}',householdTotal);
        htmlBody = htmlBody.replace('{{eventsPaskWeek}}',eventsPaskWeek);
        htmlBody = htmlBody.replace('{{eventsTotal}}',eventsTotal);
        htmlBody = htmlBody.replace('{{phoneCallsPaskWeek}}',phoneCallsPaskWeek);
        htmlBody = htmlBody.replace('{{phoneCallsTotal}}',phoneCallsTotal);
        htmlBody = htmlBody.replace('{{walkInsPaskWeek}}',walkInsPaskWeek);
        htmlBody = htmlBody.replace('{{walkInsTotal}}',walkInsTotal);
        htmlBody = htmlBody.replace('{{commercialActionPlanPastWeek}}',commercialActionPlanPastWeek);
        htmlBody = htmlBody.replace('{{commercialActionPlanTotal}}',commercialActionPlanTotal);
        htmlBody = htmlBody.replace('{{retailActionPlanPastWeek}}',retailActionPlanPastWeek);
        htmlBody = htmlBody.replace('{{retailActionPlanTotal}}',retailActionPlanTotal);
        htmlBody = htmlBody.replace('{{otherActivitiesPastWeek}}',otherActivitiesPastWeek);
        htmlBody = htmlBody.replace('{{otherActivitiesTotal}}',otherActivitiesTotal);
        htmlBody = htmlBody.replace('{{referralsCreatedPastWeek}}',referralsCreatedPastWeek);
        htmlBody = htmlBody.replace('{{referralsCreatedTotal}}',referralsCreatedTotal);
        htmlBody = htmlBody.replace('{{referralsQualifiedPastWeek}}',referralsQualifiedPastWeek);
        htmlBody = htmlBody.replace('{{referralsQualifiedTotal}}',referralsQualifiedTotal);
        htmlBody = htmlBody.replace('{{referralsQualifiedConvertedPastWeek}}',referralsQualifiedConvertedPastWeek);
        htmlBody = htmlBody.replace('{{referralQualifiedConvertedTotal}}',referralQualifiedConvertedTotal);
        htmlBody = htmlBody.replace('{{opportunitiesCreatedPastWeek}}',opportunitiesCreatedPastWeek);
        htmlBody = htmlBody.replace('{{opportunitiesCreatedTotal}}',opportunitiesCreatedTotal);
        htmlBody = htmlBody.replace('{{opportunitiesWonPastWeek}}',opportunitiesWonPastWeek);
        htmlBody = htmlBody.replace('{{opportunitiesWonTotal}}',opportunitiesWonTotal);
        htmlBody = htmlBody.replace('{{opportunitiesLostPastWeek}}',opportunitiesLostPastWeek);
        htmlBody = htmlBody.replace('{{opportunitiesLostTotal}}',opportunitiesLostTotal);
        htmlBody = htmlBody.replace('{{casesCreatedPastWeek}}',casesCreatedPastWeek);
        htmlBody = htmlBody.replace('{{casesCreatedTotal}}',casesCreatedTotal);
        
        for(WT_Weekly_Referral_Metric__c referralRecord : listWeeklyReferralMetrics)
        {
            String copyOfReferralBodyTemplate = referralInfoTableBodyTemplate;
            
            String referralLOB = referralRecord.WT_Line_Of_Business__c != null?String.valueOf(referralRecord.WT_Line_Of_Business__c):'';
            String submittedByLOB = referralRecord.WT_Referral_Submitted_By_LOB__c != null?String.valueOf(referralRecord.WT_Referral_Submitted_By_LOB__c):'';
            String qualifiedByLOB = referralRecord.WT_Referral_Qualified_By_LOB__c != null?String.valueOf(referralRecord.WT_Referral_Qualified_By_LOB__c):'';
            String qualifiedConvertedByLOB = referralRecord.WT_Referral_Qualified_Converted_By_LOB__c != null?
                                             String.valueOf(referralRecord.WT_Referral_Qualified_Converted_By_LOB__c):'';
            
            copyOfReferralBodyTemplate = copyOfReferralBodyTemplate.replace('{{lineOfBusiness}}', referralLOB);
            copyOfReferralBodyTemplate = copyOfReferralBodyTemplate.replace('{{submittedByLineOfBusiness}}', submittedByLOB);
            copyOfReferralBodyTemplate = copyOfReferralBodyTemplate.replace('{{qualifiedByLineOfBusiness}}', qualifiedByLOB);
            copyOfReferralBodyTemplate = copyOfReferralBodyTemplate.replace('{{qualifiedConvertedByLineOfBusiness}}', qualifiedConvertedByLOB);
            
            referralInfoTableBody += copyOfReferralBodyTemplate;
            
        }
        
        htmlBody = htmlBody.replace('{{additionalReferralInfoBody}}', referralInfoTableBody); 
        
        for(WT_Weekly_Opportunity_Metric__c OpportunityRecord : listWeeklyOpportunityMetrics)
        {
            String copyOfOpportunityBodyTemplate = OpportunityInfoTableBodyTemplate;
            
            String OpportunityLOB = OpportunityRecord.WT_Line_Of_Business__c != null?String.valueOf(OpportunityRecord.WT_Line_Of_Business__c):'';
            String opportunityTotalRecordsLOB = OpportunityRecord.WT_Sales_Opportunities__c != null?String.valueOf(OpportunityRecord.WT_Sales_Opportunities__c):string.valueof(0);
            String opportunityNewDollarLOB = OpportunityRecord.WT_Opp_New_In_Dollar__c != null?String.valueOf(OpportunityRecord.WT_Opp_New_In_Dollar__c):string.valueof(0);
            String OpportunityWonLOB = OpportunityRecord.WT_Opportunities_Won__c != null?String.valueOf(OpportunityRecord.WT_Opportunities_Won__c):string.valueof(0);
            String OpportunityDollarWonLOB = OpportunityRecord.WT_Opportunities_Won_In_Dollars__c != null?String.valueOf(OpportunityRecord.WT_Opportunities_Won_In_Dollars__c):string.valueof(0);
            String OpportunityLostLOB = OpportunityRecord.WT_Opportunities_Lost__c != null?String.valueOf(OpportunityRecord.WT_Opportunities_Lost__c):string.valueof(0);
            String OpportunityDollarLostLOB = OpportunityRecord.WT_Opportunities_Lost_In_Dollars__c != null?
                                              String.valueOf(OpportunityRecord.WT_Opportunities_Lost_In_Dollars__c):string.valueof(0);
            
            copyOfOpportunityBodyTemplate = copyOfOpportunityBodyTemplate.replace('{{lineOfBusiness}}', OpportunityLOB);
            copyOfOpportunityBodyTemplate = copyOfOpportunityBodyTemplate.replace('{{totalRecordsCreated}}', opportunityTotalRecordsLOB);
            copyOfOpportunityBodyTemplate = copyOfOpportunityBodyTemplate.replace('{{NewDollarCreated}}', opportunityNewDollarLOB);
            copyOfOpportunityBodyTemplate = copyOfOpportunityBodyTemplate.replace('{{totalDollarWon}}', OpportunityDollarWonLOB);
            copyOfOpportunityBodyTemplate = copyOfOpportunityBodyTemplate.replace('{{totalDollarLost}}', OpportunityDollarLostLOB);
            copyOfOpportunityBodyTemplate = copyOfOpportunityBodyTemplate.replace('{{totalWon}}', OpportunityWonLOB);
            copyOfOpportunityBodyTemplate = copyOfOpportunityBodyTemplate.replace('{{totalLost}}', OpportunityLostLOB);
            
            opportunityInfoTableBody += copyOfOpportunityBodyTemplate;
        }   
        
        htmlBody = htmlBody.replace('{{additionalOpportunityInfoBody}}', opportunityInfoTableBody);         
        
        WT_Weekly_Metric_Recipient__mdt[] setWeeklyMetricRecipient = [SELECT Recipient_Email__c
                                                                      FROM WT_Weekly_Metric_Recipient__mdt];
        List<String> listToEmail = new List<String>();
        
        for(WT_Weekly_Metric_Recipient__mdt recipient : setWeeklyMetricRecipient)
        {
            listToEmail.add(recipient.Recipient_Email__c);
        }
        
        Messaging.Singleemailmessage emailNotification = new Messaging.Singleemailmessage();    
        emailNotification.setReplyTo('noreply@salesforce.com');
        emailNotification.setSenderDisplayName('Wintrust CRM');
        emailNotification.setToAddresses(listToEmail);
        emailNotification.setSaveAsActivity(false);
        emailNotification.setSubject(subject);
        emailNotification.setHtmlBody(htmlBody); 
        
        if(!Test.isRunningTest())
        {
            Messaging.sendEmail(new Messaging.SingleEmailmessage[] {emailNotification});
        }
        
    }   
}