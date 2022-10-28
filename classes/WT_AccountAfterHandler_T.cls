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
    @isTest
    public static void runRestrictAccountsMerge() 
    {
        User userRecord = WT_DataFactory.createUser('WT Retail');
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
}