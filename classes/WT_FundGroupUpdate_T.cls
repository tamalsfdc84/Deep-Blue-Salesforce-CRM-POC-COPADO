/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_FundGroupUpdate
* @Author			Swaminathan E	<SEzhumal@wintrust.com>
* @ModifiedBy		Swaminathan E	<SEzhumal@wintrust.com>
* @Version			v1.0
* @CreatedDate		10-18-2021
* @UsedBy			Financial Account Object
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is used for Update the Related Fund Group Status based on Financial Account.
* 
* --------------------------------------------------------------------------------------------------------------
* @Changes
* v1.0
* MM-DD-YYYY
* --------------------------------------------------------------------------------------------------------------
**/
@isTest
public class WT_FundGroupUpdate_T 
{
    @isTest
    public static void runExecute() 
    {
        
        User userCreateRecord = WT_DataFactory.createUser('System Administrator');
        insert userCreateRecord;
        WT_DataFactory.createRequiredCustomSetting();
        List <Account> listNewBusinessAccount = WT_DataFactory.createNonPersonAccounts(1,'IndustriesBusiness',userCreateRecord.id);
        listNewBusinessAccount[0].WT_Wintrust_Funds_Client__c = true;    
        insert listNewBusinessAccount;
        FinServ__FinancialAccount__c finAccount=new FinServ__FinancialAccount__c();
        finAccount.FinServ__FinancialAccountNumber__c='217981230';
        finAccount.FinServ__PrimaryOwner__c=listNewBusinessAccount[0].Id;
        insert finAccount;
        WT_Funds_Groups__c fundGroups = new WT_Funds_Groups__c();
        fundGroups.Name='Test';
        fundGroups.WT_Wintrust_Funds_Alternative_Fund__c = finAccount.Id;
        fundGroups.WT_Wintrust_Funds_Client__c = listNewBusinessAccount[0].Id;
        insert fundGroups;
        List<Id> finId = new List<Id>();
        finId.add(finAccount.Id);
        WT_FundGroupUpdate.updateFundGroup(finId);        
    }
}