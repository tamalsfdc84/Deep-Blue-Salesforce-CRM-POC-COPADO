/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_AccountContactRelationBeforeHandler_T
* @Author			Anoop B	<abattini@wintrust.com>
* @Version			v1.0
* @CreatedDate		08-07-2021
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is test class for before handler class for WT_AccountContactRelationBeforeHandler.
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* FUNCTIONAL TEST LOGIC
*  ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
@isTest
public class WT_AccountContactRelationBeforeHandler_T {
    static testmethod void  testAccountContactRelationHandler(){
        User userCreateRecord = WT_DataFactory.createUser('System Administrator');
        insert userCreateRecord;
        WT_DataFactory.createRequiredCustomSetting();
        system.runAs(userCreateRecord)
        {
            List <Account> listNewClassifiedAccount = WT_DataFactory.createNonPersonAccounts(1,'IndustriesHousehold',userCreateRecord.id);
            insert listNewClassifiedAccount[0];
            List <Account> listNewPersonAccount = WT_DataFactory.createAccounts(1,'PersonAccount_Prospect',userCreateRecord.id);
            insert listNewPersonAccount;
            listNewPersonAccount[0].FinServ__LastInteraction__c=Date.today();
            listNewPersonAccount[0].FinServ__NextInteraction__c=Date.today();
            update listNewPersonAccount[0];
            
            Contact con=[Select Id,AccountId from contact where AccountId=:listNewPersonAccount[0].Id];
            
            AccountContactRelation acr = new AccountContactRelation(); 
            acr.Accountid = listNewClassifiedAccount[0].id;
            acr.Contactid = con.Id;
            Test.startTest();
            insert acr;
            update acr;
            delete acr;
            Test.stopTest();
        }
    }
    
}