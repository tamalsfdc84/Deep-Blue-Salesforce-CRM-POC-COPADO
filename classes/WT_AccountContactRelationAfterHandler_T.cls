/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_AccountContactRelationAfterHandler_T
* @Author			Anoop B	<abattini@wintrust.com>
* @Version			v1.0
* @CreatedDate		18-12-2020
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is test class for before handler class for WT_AccountContactRelationAfterHandler_T.
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* FUNCTIONAL TEST LOGIC
*  ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
@isTest
public class WT_AccountContactRelationAfterHandler_T {
    static testmethod void  testAccountContactRelationafterHandler(){
        User userCreateRecord = WT_DataFactory.createUser('System Administrator');
        insert userCreateRecord;
        WT_DataFactory.createRequiredCustomSetting();
        system.runAs(userCreateRecord)
        {
            
            List <Account> listNewClassifiedAccount = WT_DataFactory.createNonPersonAccounts(1,'IndustriesHousehold',userCreateRecord.id);
            listNewClassifiedAccount[0].WT_First_Date_Of_Contact__c=Date.today()+2;
            listNewClassifiedAccount[0].WT_Last_Date_Of_Contact__c=Date.today()+2;
            insert listNewClassifiedAccount[0];
            List <Account> listNewPersonAccount = WT_DataFactory.createAccounts(2,'PersonAccount_Prospect',userCreateRecord.id);
            insert listNewPersonAccount;
            listNewPersonAccount[0].FinServ__LastInteraction__c=Date.today()+5;
            listNewPersonAccount[0].FinServ__NextInteraction__c=Date.today()-5;
            listNewPersonAccount[1].FinServ__LastInteraction__c=Date.today()+7;
            listNewPersonAccount[1].FinServ__NextInteraction__c=Date.today()-7;
            update listNewPersonAccount[0];
            
           
            Contact con=[Select Id,AccountId from contact where AccountId=:listNewPersonAccount[0].Id];
            Contact cont=[Select Id,AccountId from contact where AccountId=:listNewPersonAccount[1].Id];
            
            AccountContactRelation acr = new AccountContactRelation(); 
            acr.Accountid = listNewClassifiedAccount[0].id;
            acr.Contactid = con.Id;
            insert acr;
            acr.isActive = false;
            update acr;
            AccountContactRelation acrel = new AccountContactRelation(); 
            acrel.Accountid = listNewClassifiedAccount[0].id;
            acrel.Contactid = cont.Id;
            insert acrel;
            Test.startTest();
            delete acr;
            Test.stopTest();
        }
    }
    
    static testmethod void  testAccountContactRelationafterHandlerDelete(){
        User userCreateRecord = WT_DataFactory.createUser('System Administrator');
        insert userCreateRecord;
        WT_DataFactory.createRequiredCustomSetting();
        system.runAs(userCreateRecord)
        {
            List <Account> listNewClassifiedAccount = WT_DataFactory.createNonPersonAccounts(1,'IndustriesHousehold',userCreateRecord.id);
            listNewClassifiedAccount[0].WT_First_Date_Of_Contact__c=Date.today()+2;
            listNewClassifiedAccount[0].WT_Last_Date_Of_Contact__c=Date.today()+2;
            insert listNewClassifiedAccount[0];
            List <Account> listNewPersonAccount = WT_DataFactory.createAccounts(1,'PersonAccount_Prospect',userCreateRecord.id);
            insert listNewPersonAccount;
            listNewPersonAccount[0].FinServ__LastInteraction__c=Date.today()+5;
            listNewPersonAccount[0].FinServ__NextInteraction__c=Date.today()-5;
            update listNewPersonAccount[0];
            
            Contact con=[Select Id,AccountId from contact where AccountId=:listNewPersonAccount[0].Id];
            
            AccountContactRelation acr = new AccountContactRelation(); 
            acr.Accountid = listNewClassifiedAccount[0].id;
            acr.Contactid = con.Id;
            insert acr;
            Test.startTest();
            delete acr;
            Test.stopTest();
        }
    }
}