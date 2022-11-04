/**
* --------------------------------------------------------------------------------------------------------------
* @Name             WT_LeadPhoneEmailUpdateBatch_T
* @Author           Krupa Chinthakindi
* @Version          v1.0
* @CreatedDate      03-29-2022
* @UsedBy      
* -----------------------------------------------------------------------------------------------------------------------------
* @Description      This test class is for WT_LeadPhoneEmailUpdateBatch
------------------------------------------------------------------------------------------------------------------------------------------
**/
@isTest
public class WT_LeadPhoneEmailUpdateBatch_T 
{
    static testMethod void phoneAndEmailFromReferredPersonAccountTest() 
    {
        User userRecord1 = WT_DataFactory.createUser('System Administrator'); 
        insert userRecord1;
        User userRecord2 = WT_DataFactory.createUser('System Administrator');
        insert userRecord2;
        User userRecord3 = WT_DataFactory.createUser('System Administrator');
        insert userRecord3;
        WT_Business_Unit_Entity__c businessUnitRecord = new WT_Business_Unit_Entity__c(Name = '118-1', WT_Bank_Number__c = '118', WT_Branch__c = '1');
        insert businessUnitRecord;
        List<Account> listPersonAccount = WT_DataFactory.createAccounts(1, 'PersonAccount_Customer', userRecord1.Id);
        listPersonAccount[0].PersonEmail = 'abc@gmail.com';
        listPersonAccount[0].PersonHomePhone = '1112223333';
        insert listPersonAccount;
        List<Lead> listLead = WT_DataFactory.createLead(1, userRecord1.Id, userRecord2.Id, userRecord3.Id);
        listLead[0].FinServ__RelatedAccount__c = listPersonAccount[0].Id;
        insert listLead;
        Test.startTest();  
        Database.executeBatch(new WT_LeadPhoneEmailUpdateBatch(new Set<Id>(), new List<String>()));
        Test.stopTest();
    }
    static testMethod void phoneAndEmailFromReferredBusinessAccountTest() 
    {
        User userRecord1 = WT_DataFactory.createUser('System Administrator'); 
        insert userRecord1;
        User userRecord2 = WT_DataFactory.createUser('System Administrator');
        insert userRecord2;
        User userRecord3 = WT_DataFactory.createUser('System Administrator');
        insert userRecord3;
        WT_Business_Unit_Entity__c businessUnitRecord = new WT_Business_Unit_Entity__c(Name = '118-1', WT_Bank_Number__c = '118', WT_Branch__c = '1');
        insert businessUnitRecord;
        List<Account> listBusinessAccount = WT_DataFactory.createNonPersonAccounts(1,'BusinessAccount_Customer',userRecord1.Id);
        listBusinessAccount[0].WT_Primary_Email_DNB__c = 'abc2@gmail.com';
        listBusinessAccount[0].Phone = '2223334444';
        insert listBusinessAccount;
        List<Lead> listLead = WT_DataFactory.createLead(1,userRecord1.Id,userRecord2.Id,userRecord3.Id);
        listLead[0].FinServ__RelatedAccount__c = listBusinessAccount[0].Id;
        insert listLead;
        Test.startTest();  
        Database.executeBatch(new WT_LeadPhoneEmailUpdateBatch(new Set<Id>(), new List<String>()));
        Test.stopTest();
    }  
}