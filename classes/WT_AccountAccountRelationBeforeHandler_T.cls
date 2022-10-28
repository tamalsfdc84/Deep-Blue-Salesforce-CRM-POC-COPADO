/**
* ----------------------------------------------------------------------------------------------------------------
* @Name				WT_AccountAccountRelationBeforeHandler_T
* @Author			Anoop B	<abattini@wintrust.com>
* @Version			v1.0
* @CreatedDate		30-07-2021
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is test class for after handler class for WT_AccountAccountRelationBeforeHandler.
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* FUNCTIONAL TEST LOGIC

* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
@isTest
public class WT_AccountAccountRelationBeforeHandler_T 
{
	static testmethod void  testAccountAccountRelationHandler(){
        User userCreateRecord = WT_DataFactory.createUser('System Administrator');
        insert userCreateRecord;
        WT_DataFactory.createRequiredCustomSetting();
        system.runAs(userCreateRecord)
        {
            List <Account> listNewClassifiedAccount = WT_DataFactory.createNonPersonAccounts(1,'Relationship_Group',userCreateRecord.id);
            insert listNewClassifiedAccount[0];
            List <Account> listNewPersonAccount = WT_DataFactory.createAccounts(1,'PersonAccount_Prospect',userCreateRecord.id);
            insert listNewPersonAccount;
            listNewPersonAccount[0].FinServ__LastInteraction__c=Date.today();
            listNewPersonAccount[0].FinServ__NextInteraction__c=Date.today();
            update listNewPersonAccount[0];
            
            FinServ__FinancialAccount__c finAccount=new FinServ__FinancialAccount__c();
            finAccount.FinServ__FinancialAccountNumber__c='217981230';
            finAccount.FinServ__PrimaryOwner__c=listNewClassifiedAccount[0].Id;
            insert finAccount;
            
            FinServ__FinancialAccountRole__c FinAccountRole=new FinServ__FinancialAccountRole__c();
            FinAccountRole.FinServ__RelatedAccount__c=listNewPersonAccount[0].id;
            FinAccountRole.FinServ__FinancialAccount__c=finAccount.Id;
            FinAccountRole.FinServ__Role__c='Beneficiary';
            insert FinAccountRole;
            
            FinServ__ReciprocalRole__c finRole=new FinServ__ReciprocalRole__c();
            finRole.FinServ__CreateInverseRole__c=true;
            finRole.FinServ__InverseRole__c='Client';
            insert finRole;
            
            FinServ__AccountAccountRelation__c AAR = new FinServ__AccountAccountRelation__c(); 
            AAR.FinServ__Account__c = listNewClassifiedAccount[0].id;
            AAR.FinServ__RelatedAccount__c = listNewPersonAccount[0].Id;
            AAR.FinServ__Role__c=finRole.Id;
           
            Test.startTest();
            insert AAR;
            update AAR;
            delete AAR;
            Test.stopTest();
        }
    }
}