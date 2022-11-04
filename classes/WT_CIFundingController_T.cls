@isTest
public class WT_CIFundingController_T 
{
    static testMethod void testMethod1()
    {
        Account newAccount = new Account();
        newAccount.Name = 'Test';
        newAccount.WT_Primary_Contact_Name_Banker_Entered__c ='Test';
        insert newAccount;
        WT_CI_Funding_History__c FundingHistoryRecord = new WT_CI_Funding_History__c();
        FundingHistoryRecord.WT_Account__c = newAccount.Id;
        FundingHistoryRecord.WT_Split_Payment__c = 'test';
        FundingHistoryRecord.WT_Date_of_Payment__c =system.today();
        insert FundingHistoryRecord;
        WT_CIFundingController.getFundingList(newAccount.Id);
    } 
}