/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name             WT_LeadAfterHandler
* @Author           Swaminathan E   <SEzhumal@wintrust.com>
* @version          v1.0 
* @CreatedDate      20-11-2020
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @description 
* Class is used as test class for WT_LeadAfterHandler. 
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* FUNCTIONAL TEST LOGIC
*  runLeadShareRecord()
*   > used to run the Trigger class for the WT_LeadAfterHandler , generally for code coverage.
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
@isTest
public class WT_LeadAfterHandler_T 
{
    static testMethod void runLeadShareRecord()
    {
        WT_DataFactory.createRequiredCustomSetting();
        List<User> listUsers = new List<User>();
        User userRecord1 = WT_DataFactory.createUser('System Administrator');
        userRecord1.FirstName = 'Test 123User'; 
        userRecord1.WT_Referrals_Type__c = 'Retail Banking';
        User userRecord2 = WT_DataFactory.createUser('System Administrator');        
        userRecord2.FirstName = 'Test 124User';
        userRecord2.WT_Referrals_Type__c = 'Retail Banking';
        User userRecord3 = WT_DataFactory.createUser('System Administrator');
        userRecord3.WT_Referrals_Type__c = 'Retail Banking';
        userRecord3.FirstName = 'Test 125User';               
        User userRecord4 = WT_DataFactory.createUser('System Administrator');        
        userRecord4.FirstName = 'Test 126User';
        userRecord4.WT_Referrals_Type__c = 'Retail Banking';
        listUsers.add(userRecord1);
        listUsers.add(userRecord2);
        listUsers.add(userRecord3);
        listUsers.add(userRecord4);
        insert listUsers;               
        Id user1Id =userRecord1.Id;
        Id user2Id = userRecord2.Id;
        Id user3Id =userRecord3.Id;
        Id user4Id = userRecord4.Id;
        Lead leadRecord1 = new Lead();
        leadRecord1.LastName = 'Test Job1';
        leadRecord1.OwnerId = user1Id;
        leadRecord1.WT_Referred_To__c = user2Id;
        leadRecord1.FinServ__ReferredByUser__c = user3Id;
        leadRecord1.FinServ__ExpressedInterest__c = 'Retail Banking';
        insert leadRecord1;
        Lead leadRecord2 = new Lead();
        leadRecord2.LastName = 'Test Job2';
        leadRecord2.OwnerId = user1Id;
        leadRecord2.WT_Referred_To__c = user3Id;
        leadRecord2.FinServ__ReferredByUser__c = user4Id;
        leadRecord2.FinServ__ExpressedInterest__c = 'Retail Banking';        
        insert leadRecord2;  
        
        // Query job sharing records.
        List<leadShare> jShrs1 = [SELECT Id, leadId, UserOrGroupId, leadAccessLevel, 
                                 RowCause FROM leadShare WHERE leadId = :leadRecord1.Id AND UserOrGroupId= :user2Id];
        List<leadShare> jShrs2 = [SELECT Id, leadId, UserOrGroupId, leadAccessLevel, 
                                 RowCause FROM leadShare WHERE leadId = :leadRecord2.Id AND UserOrGroupId= :user3Id];
        
        // Test for only one manual share on job.
        System.assertEquals(jShrs1[0].leadId, leadRecord1.Id);
        System.assertEquals(jShrs2[0].leadId, leadRecord2.Id);
                
        leadRecord1.WT_Referred_To__c = User4Id;
        leadRecord1.FinServ__ReferredByUser__c = user2Id;       
        update leadRecord1;
        leadRecord2.WT_Referred_To__c = user1Id;
        update leadRecord2;
        //System.assertEquals();
    }  
}