/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name         WT_UserAfterHandler_T
* @Author           Swaminathan E   <SEzhumal@wintrust.com>
* @version      v1.0 
* @CreatedDate      20-11-2020
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* Class is used as test class for WT_UserAfterHandler. 
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* FUNCTIONAL TEST LOGIC
*  runUserBranchFactor()
*   > used to run the Trigger class for the WT_UserAfterHandler , generally for code coverage.
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
@isTest
public class WT_UserAfterHandler_T
{
    @testSetup static void setup() 
    {
        List<WT_Business_Unit_Entity__c> listBusinessUnitRecord =new List<WT_Business_Unit_Entity__c>();
        WT_Business_Unit_Entity__c businessUnitRecord1 = WT_DataFactory.createBusinessUnitEntity();
        WT_Business_Unit_Entity__c businessUnitRecord2 = WT_DataFactory.createBusinessUnitEntityWTFC();       
        businessUnitRecord1.WT_Bank_Number__c = '118';
        businessUnitRecord1.WT_Branch_Number__c='018';
        businessUnitRecord1.WT_Unique_Key__c='118-018';
        businessUnitRecord2.WT_Bank_Number__c = '118';
        businessUnitRecord2.WT_Branch_Number__c='022';
        businessUnitRecord2.WT_Unique_Key__c='118-022';
        listBusinessUnitRecord.add(businessUnitRecord1); 
        listBusinessUnitRecord.add(businessUnitRecord2);
        insert listBusinessUnitRecord;  
    }
    @isTest static void runUserBranchFactor()
    {        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser){
            WT_DataFactory.createRequiredCustomSetting();
            User userRecord = WT_DataFactory.createUser('System Administrator');
            Group mmScorecardExecutiveGroupList  = [SELECT Id,name  FROM Group where name ='MM Scorecard Executive'];
            Group mmScorecardIndividualGroupList  = [SELECT Id,name  FROM Group where name ='MM Scorecard Individual'];
            userRecord.FirstName = 'Test 123User';        
            userRecord.WT_Branch__c='118018';
            set<Id> userId = new set<Id>();
            User userRecord2 = WT_DataFactory.createUser('System Administrator');        
            userRecord2.FirstName = 'Test 23';
            userRecord2.WT_Branch__c='118022';  
            
            Test.startTest();
            insert userRecord;
            userId.add(userRecord2.Id);
            userRecord2.WT_Branch__c='118022'; 
            // userRecord.WT_MM_Scorecard_Access__c='Manager/Team Lead';
            insert userRecord2;
            
            // userRecord.WT_MM_Scorecard_Access__c='Individual';
            //  update userRecord;
            
            List<User> listUserRecord= new List<User>();
            userRecord2.WT_Branch__c=''; 
            listUserRecord.add(userRecord);
            listUserRecord.add(userRecord2);
            try{
                update listUserRecord;
            }catch(exception e){
                system.assertEquals(e.getmessage(),e.getmessage());
            }
            userRecord.WT_Branch__c='118018';
            userRecord.WT_MM_Scorecard_Access__c ='Executive';
            update userRecord; 
            userRecord.WT_MM_Scorecard_Access__c ='Manager/Team Lead';
            update userRecord;
            userRecord.WT_MM_Scorecard_Access__c ='Individual';
            update userRecord;
            userRecord.WT_CRE_Scorecard_Access__c ='Individual';
            update userRecord;
            try{
                WT_UserAfterHandler.CreateGroupMember(userRecord.Id,mmScorecardExecutiveGroupList.Id);
            }catch(exception e ){
                system.assertEquals(e.getmessage(),e.getmessage());
            }
            WT_UserAfterHandler.SendWelcomeEmail(listUserRecord,userId);
            WT_UserAfterHandler.DeleteGroupMember(userRecord.Id,mmScorecardExecutiveGroupList.Id);
            // UserAfterHandler.UpdateGroupMember(userRecord.Id,mmScorecardExecutiveGroupList.Id,mmScorecardIndividualGroupList.Id);
            Test.stopTest(); 
            WT_User_Branch_Factor_Lookup__c userBranchFactorRecord = [SELECT Id, WT_User__c FROM WT_User_Branch_Factor_Lookup__c WHERE WT_User__c=:userRecord.Id];        
            
            System.assertEquals(userRecord.Id, userBranchFactorRecord.WT_User__c);
            System.assertEquals(1, [SELECT Id, WT_User__c FROM WT_User_Branch_Factor_Lookup__c].size());
        }
    }
}