/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_AccountAfterHandler_T
* @Author			Karishma Keswani	<kkeswani@wintrust.com>
* @ModifiedBy		Karishma Keswani	<kkeswani@wintrust.com>
* @Version			v1.0
* @CreatedDate		07-12-2020
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is test class for after handler class for WT_AccountAfterHandler.
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* FUNCTIONAL TEST LOGIC
* 1- runCreateCoveragePlan() 
* 	> used to test the creation of Coverage Plan on the account classification.
* 2- runCreateCoveragePlanAccountUpdate()
*   > used to test the update of account record by populating classfication. This should create action plan.
* 3- runRestrictAccountsMerge()
*   > used to test the restriction of merging of Customer Account into Prospect
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
@isTest
public class WT_AccountAfterHandler_T 
{
    @isTest(SeeAllData=true)     
    public static void runCreateCoveragePlan() 
    {        
        User userRecord = WT_DataFactory.createUser('WT Retail');
        insert userRecord;
        List <Account> listNewClassifiedAccount = WT_DataFactory.createNonPersonAccounts(10,'IndustriesBusiness',userRecord.Id);
        for(Account accountRecord: listNewClassifiedAccount)
        {
            accountRecord.WT_Classification__c = 'P1';
        }
        test.startTest();
        insert listNewClassifiedAccount;
        test.stopTest();
        List<ActionPlan> listactionPlanRecords = new List<ActionPlan>();
        listactionPlanRecords = [Select id from actionplan where TargetId in:listNewClassifiedAccount];
        //system.assertNotEquals(0, listactionPlanRecords.size());
    }
    @isTest(SeeAllData=true)     
    public static void runCreateCoveragePlanAccountUpdate() 
    {
        User userRecord = WT_DataFactory.createUser('WT Retail');
        insert userRecord;
        List <Account> listNewClassifiedAccount = WT_DataFactory.createNonPersonAccounts(10,'IndustriesBusiness',userRecord.Id);
        insert listNewClassifiedAccount;
        List<ActionPlan> listactionPlanRecords = new List<ActionPlan>();
        listactionPlanRecords = [Select id from actionplan where TargetId in:listNewClassifiedAccount];
        system.assertEquals(0, listactionPlanRecords.size());
        for(Account accountRecord: listNewClassifiedAccount)
        {
            accountRecord.WT_Classification__c = 'P1';
        }
        test.startTest();
        update listNewClassifiedAccount;
        test.stopTest();
        listactionPlanRecords = [Select id from actionplan where TargetId in:listNewClassifiedAccount];
        //system.assertNotEquals(0, listactionPlanRecords.size());
    }
    //Krupa added
     @isTest
    public static void updateMapAccountToReferral() 
    {
        User userRecord1 = WT_DataFactory.createUser('System Administrator');
        insert userRecord1;
        User userRecord2 = WT_DataFactory.createUser('System Administrator');
        insert userRecord2;
        User userRecord3 = WT_DataFactory.createUser('System Administrator');
        insert userRecord3;
        
        List<Account> listPersonAccount = WT_DataFactory.createAccounts(1,'PersonAccount_Customer',userRecord1.Id);
        listPersonAccount[0].PersonEmail = 'abc@gmail.com';
        insert listPersonAccount;
        
        List<Lead> listLead = WT_DataFactory.createLead(1,userRecord1.Id,userRecord2.Id,userRecord3.Id);
        listLead[0].FinServ__RelatedAccount__c = listPersonAccount[0].Id;
        insert listLead;
        
        listPersonAccount[0].PersonHomePhone = '7899876787';
        listPersonAccount[0].PersonEmail = 'abc123@gmail.com';
        update listPersonAccount;
        
        Lead insertedLead = [SELECT Id,
                             Phone,
                             WT_Account_Referred_Email__c
                             FROM Lead
                             WHERE Id = :listLead[0].Id];
        
        System.assertEquals('7899876787', insertedLead.Phone, 'Phone Matched');
        System.assertEquals('abc123@gmail.com', insertedLead.WT_Account_Referred_Email__c, 'Email Matched');
    }
    
    //Krupa added
    @isTest
    public static void updateMapBusinessAccountToReferral() 
    {
        User userRecord1 = WT_DataFactory.createUser('System Administrator'); 
        insert userRecord1;
        User userRecord2 = WT_DataFactory.createUser('System Administrator');
        insert userRecord2;
        User userRecord3 = WT_DataFactory.createUser('System Administrator');
        insert userRecord3;
        
        List<Account> listBusinessAccount = WT_DataFactory.createNonPersonAccounts(1,'BusinessAccount_Customer', userRecord1.Id);
        listBusinessAccount[0].WT_Primary_Email_DNB__c = 'abc2@gmail.com'; 
        insert listBusinessAccount;
        
        List<Lead> listLead = WT_DataFactory.createLead(1,userRecord1.Id,userRecord2.Id,userRecord3.Id);
        listLead[0].FinServ__RelatedAccount__c = listBusinessAccount[0].Id;
        insert listLead; 
        
        listBusinessAccount[0].Phone = '7890987898';
        listBusinessAccount[0].WT_Primary_Email_DNB__c = 'fjjf@gmail.com';
        update listBusinessAccount;
        
        Lead insertedLead = [SELECT Id,
                             Phone,
                             WT_Account_Referred_Email__c
                             FROM Lead
                             WHERE Id = :listLead[0].Id];
        
        System.assertEquals('7890987898', insertedLead.Phone, 'Phone Matched');
        System.assertEquals('fjjf@gmail.com', insertedLead.WT_Account_Referred_Email__c, 'Email Matched');
    }
    
    @isTest
    public static void runRestrictAccountsMerge() 
    {
        User userRecord = WT_DataFactory.createUser('System Administrator');
        insert userRecord;
        List<Account> listCustomerAccount = WT_DataFactory.createAccounts(1,'PersonAccount_Customer',userRecord.Id);
        insert listCustomerAccount;
        List<Account> listProspectAccount = WT_DataFactory.createAccounts(1,'PersonAccount_Prospect',userRecord.Id);
        insert listProspectAccount;        
        WT_DataFactory.createRequiredCustomSetting();
        try
        {
            test.startTest();
            merge listProspectAccount[0] listCustomerAccount;
            test.stopTest();
        }
        catch(exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains(System.Label.WT_Account_Error_on_Merge) ? true : false;
            system.assertEquals(expectedExceptionThrown,true);
        }        
    }
    
    @isTest
    public static void runupdateInteractionDatesonAccount() 
    {
        
        User userRecord = WT_DataFactory.createUser('WT Retail');
        insert userRecord;
        List <Account> listAccounts = WT_DataFactory.createAccounts(1,'PersonAccount_Customer',userRecord.Id);
        insert listAccounts;
        List<Account> listCustomerAccount = WT_DataFactory.createNonPersonAccounts(2,'IndustriesHousehold',userRecord.Id);
        listCustomerAccount[1].FinServ__NextReview__c=Date.today()-5;
        insert listCustomerAccount;
        
        FinServ__FinancialAccount__c finAccount=new FinServ__FinancialAccount__c();
        finAccount.FinServ__FinancialAccountNumber__c='217981230';
        finAccount.FinServ__PrimaryOwner__c=listAccounts[0].Id;
        insert finAccount;
        
        FinServ__FinancialAccountRole__c FinAccountRole=new FinServ__FinancialAccountRole__c();
        FinAccountRole.FinServ__RelatedAccount__c=listCustomerAccount[1].id;
        FinAccountRole.FinServ__FinancialAccount__c=finAccount.Id;
        FinAccountRole.FinServ__Role__c='Beneficiary';
        insert FinAccountRole;
        
        FinServ__ReciprocalRole__c finRole=new FinServ__ReciprocalRole__c();
        finRole.FinServ__CreateInverseRole__c=true;
        finRole.FinServ__InverseRole__c='Client';
        insert finRole;
        
        FinServ__AccountAccountRelation__c finAcc=new FinServ__AccountAccountRelation__c();
        finAcc.FinServ__Account__c=listCustomerAccount[0].Id;
        finAcc.FinServ__RelatedAccount__c=listCustomerAccount[1].Id;
        finAcc.FinServ__Role__c=finRole.Id;
        insert finAcc;
        
        WT_DataFactory.createRequiredCustomSetting();
        test.startTest();
        listCustomerAccount[0].FinServ__NextReview__c=Date.today();
        update listCustomerAccount[0];
        test.stopTest();
        Account testAccount=[Select Id,FinServ__NextReview__c from Account where Id=:listCustomerAccount[1].Id];
        system.assertEquals(testAccount.FinServ__NextReview__c,Date.today()-5);
        
    }
    
    @isTest
    public static void runupdateInteractionDatesonHouseHold() 
    {
        
        User userCreateRecord = WT_DataFactory.createUser('System Administrator');
        insert userCreateRecord;
        WT_DataFactory.createRequiredCustomSetting();
        system.runAs(userCreateRecord)
        {
            List <Account> listNewClassifiedAccount = WT_DataFactory.createNonPersonAccounts(1,'IndustriesHousehold',userCreateRecord.id);
            insert listNewClassifiedAccount[0];
            List <Account> listNewPersonAccount = WT_DataFactory.createAccounts(1,'PersonAccount_Customer',userCreateRecord.id);
            insert listNewPersonAccount;
            listNewPersonAccount[0].FinServ__LastInteraction__c=Date.today();
            listNewPersonAccount[0].FinServ__NextInteraction__c=Date.today();
            listNewPersonAccount[0].WT_Parent_Household__pc=listNewClassifiedAccount[0].Id;
            listNewPersonAccount[0].WT_First_Date_Of_Contact__c=Date.today();
            listNewPersonAccount[0].WT_Last_Date_Of_Contact__c=Date.today();
            update listNewPersonAccount[0];
            
            Contact con=[Select Id,AccountId from contact where AccountId=:listNewPersonAccount[0].Id];
            
            AccountContactRelation acr = new AccountContactRelation(); 
            acr.Accountid = listNewClassifiedAccount[0].id;
            acr.Contactid = con.Id;
            insert acr;
            Test.startTest();
            listNewPersonAccount[0].FinServ__LastInteraction__c=Date.today()+5;
            listNewPersonAccount[0].FinServ__NextInteraction__c=Date.today()-5;
            listNewPersonAccount[0].PersonHomePhone='9999999999';
            listNewPersonAccount[0].Phone='9999999999';
            update listNewPersonAccount[0];
            Test.stopTest();
        }
    }
    
    @isTest
    public static void runupdateInteractionDatesOnRelationGroup() 
    {
        User userCreateRecord = WT_DataFactory.createUser('System Administrator');
        insert userCreateRecord;
        WT_DataFactory.createRequiredCustomSetting();
        system.runAs(userCreateRecord)
        {
            List <Account> listNewClassifiedAccount = WT_DataFactory.createNonPersonAccounts(1,'Relationship_Group',userCreateRecord.id);
            insert listNewClassifiedAccount[0];
            List <Account> listNewBusinessAccount = WT_DataFactory.createNonPersonAccounts(1,'IndustriesBusiness',userCreateRecord.id);
            insert listNewBusinessAccount;
            
            listNewBusinessAccount[0].FinServ__LastInteraction__c=Date.today();
            listNewBusinessAccount[0].FinServ__NextInteraction__c=Date.today();
            update listNewBusinessAccount[0];
            
            FinServ__FinancialAccount__c finAccount=new FinServ__FinancialAccount__c();
            finAccount.FinServ__FinancialAccountNumber__c='217981230';
            finAccount.FinServ__PrimaryOwner__c=listNewClassifiedAccount[0].Id;
            insert finAccount;
            
            FinServ__FinancialAccountRole__c FinAccountRole=new FinServ__FinancialAccountRole__c();
            FinAccountRole.FinServ__RelatedAccount__c=listNewBusinessAccount[0].id;
            FinAccountRole.FinServ__FinancialAccount__c=finAccount.Id;
            FinAccountRole.FinServ__Role__c='Beneficiary';
            insert FinAccountRole;
            
            FinServ__ReciprocalRole__c finRole=new FinServ__ReciprocalRole__c();
            finRole.FinServ__CreateInverseRole__c=true;
            finRole.FinServ__InverseRole__c='Client';
            insert finRole;
            
            FinServ__AccountAccountRelation__c AAR = new FinServ__AccountAccountRelation__c(); 
            AAR.FinServ__Account__c = listNewClassifiedAccount[0].id;
            AAR.FinServ__RelatedAccount__c = listNewBusinessAccount[0].Id;
            AAR.FinServ__Role__c=finRole.Id;
            insert AAR;
            
            Test.startTest();
            listNewBusinessAccount[0].FinServ__LastInteraction__c=Date.today()+5;
            listNewBusinessAccount[0].FinServ__NextInteraction__c=Date.today()-5;
            update listNewBusinessAccount[0];
            Test.stopTest();
        }
    }
}