@isTest
public class WT_BatchHouseholdRelationProcessor_T 
{
    @isTest
    static void TestAccountContactRelationafterHandler()
    {
        User userCreateRecord = WT_DataFactory.createUser('System Administrator');
        insert userCreateRecord;
        WT_DataFactory.createRequiredCustomSetting();
        system.runAs(userCreateRecord)
        {            
            List <Account> listNewClassifiedAccount = WT_DataFactory.createNonPersonAccounts(1, 'IndustriesHousehold', userCreateRecord.Id);
            listNewClassifiedAccount[0].WT_First_Date_Of_Contact__c = Date.today()+2;
            listNewClassifiedAccount[0].WT_Last_Date_Of_Contact__c = Date.today()+2;
            insert listNewClassifiedAccount[0];
            
            List <Account> listNewPersonAccount = WT_DataFactory.createAccounts(2, 'PersonAccount_Customer', userCreateRecord.Id);
            insert listNewPersonAccount;         
           
            Contact newContact1 = [Select Id, AccountId FROM Contact WHERE AccountId = :listNewPersonAccount[0].Id];
            Contact newContact2 = [Select Id, AccountId FROM Contact WHERE AccountId = :listNewPersonAccount[1].Id];
                       
            AccountContactRelation newAccountContactRelation = new AccountContactRelation(); 
            newAccountContactRelation.AccountId = listNewClassifiedAccount[0].id;
            newAccountContactRelation.Contactid = newContact1.Id;
            newAccountContactRelation.FinServ__PrimaryGroup__c = true;
            insert newAccountContactRelation;
                        
            AccountContactRelation newAccountContactRelation2 = new AccountContactRelation(); 
            newAccountContactRelation2.AccountId = listNewClassifiedAccount[0].id;
            newAccountContactRelation2.Contactid = newContact2.Id;
            newAccountContactRelation.FinServ__PrimaryGroup__c = true;
            insert newAccountContactRelation2;
            
            delete newAccountContactRelation2;
            
            ActionPlan newActionPlan = new ActionPlan();
            newActionPlan.WT_Household__c = null;
            newActionPlan.WT_ContactID__c = newContact1.Id;
            
            Map<Id, Id> mapContactIdAndHouseholdId = new Map<Id, Id>();
            WT_HouseholdActionPlanProcessor.UpdateActionPlan(newActionPlan, mapContactIdAndHouseholdId);
            
            mapContactIdAndHouseholdId.put(newContact1.Id, listNewClassifiedAccount[0].id);
            WT_HouseholdActionPlanProcessor.UpdateActionPlan(newActionPlan, mapContactIdAndHouseholdId);
            
            List<WT_Household_Relation_To_Process_Log__c> listLogToUpdate = [SELECT Id, WT_Date_Added__c
                                                                             FROM WT_Household_Relation_To_Process_Log__c];
            for(WT_Household_Relation_To_Process_Log__c logToUpdate : listLogToUpdate)
            {
                logToUpdate.WT_Date_Added__c = System.now().addMinutes(-20);
            }
            update listLogToUpdate;
            
            Test.startTest();
            WT_BatchHouseholdRelationProcessor batchProcessor = new WT_BatchHouseholdRelationProcessor();
            Database.executeBatch(batchProcessor);        
            Test.stopTest();
        }
    }
}