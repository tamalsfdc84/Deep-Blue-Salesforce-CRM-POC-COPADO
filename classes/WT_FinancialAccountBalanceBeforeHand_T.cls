@isTest
public class WT_FinancialAccountBalanceBeforeHand_T 
{
    static testmethod void  testAccountContactRelationHandler(){
        User userCreateRecord = WT_DataFactory.createUser('System Administrator');
        insert userCreateRecord;
        WT_DataFactory.createRequiredCustomSetting();
        system.runAs(userCreateRecord)
        {                       
            String householdRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
            List <Account> listNewPersonAccount = WT_DataFactory.createAccounts(1,'PersonAccount_Customer',userCreateRecord.id);
            insert listNewPersonAccount;
            
            FinServ__FinancialAccount__c newFinancialAccount = new FinServ__FinancialAccount__c();
            newFinancialAccount.FinServ__PrimaryOwner__c = listNewPersonAccount[0].Id;
            insert newFinancialAccount;
            
            Account newHousehold = new Account();
            newHousehold.Name = 'Test Household';
            newHousehold.RecordTypeId = householdRecordTypeId;
            insert newHousehold;
            
            Account createdAccount = [SELECT Id, PersonContactId 
                                      FROM Account
                                      WHERE Id =: listNewPersonAccount[0].Id];
            
            AccountContactRelation newAccountContactRelation = new AccountContactRelation();
            newAccountContactRelation.AccountId = newHousehold.Id;
            newAccountContactRelation.ContactId = createdAccount.PersonContactId;
            newAccountContactRelation.FinServ__Rollups__c = 'All';
            insert newAccountContactRelation;
                        
            Test.startTest();
            newFinancialAccount.FinServ__Household__c = newHousehold.Id;
            update newFinancialAccount;
            Test.stopTest();
        }
    }
}