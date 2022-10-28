@isTest(isParallel=true)
public class WT_LookupController_T 
{
    @isTest
    static void search_should_return_Account_and_Opportunity() 
    {
        List<Id> fixedResults = new Id[2];
        Account account = createAccount('Account');
        fixedResults.add(account.Id);
        Test.setFixedSearchResults(fixedResults);
        List<String> selectedIds = new List<String>();

        List<WT_LookupSearchResult> results = WT_LookupController.search('Acc', selectedIds, '');
    }

    @isTest
    static void search_should_not_return_selected_item() 
    {
        List<Id> fixedResults = new Id[2];
        Account account1 = createAccount('Account1');
        fixedResults.add(account1.Id);
        Account account2 = createAccount('Account2');
        fixedResults.add(account2.Id);
        Test.setFixedSearchResults(fixedResults);
        List<String> selectedIds = new List<String>();
        selectedIds.add(account2.Id);

        List<WT_LookupSearchResult> results = WT_LookupController.search('Acc', selectedIds, '');
    }

    private static Account createAccount(String name) 
    {
        Account account = new Account(Name = name);
        insert account;
        return account;
    }
}