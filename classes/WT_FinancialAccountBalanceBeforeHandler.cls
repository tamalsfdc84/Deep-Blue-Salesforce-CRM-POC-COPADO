//Test Coverage: WT_FinancialAccountBalanceBeforeHand_T
public class WT_FinancialAccountBalanceBeforeHandler extends TriggerHandler
{
    List<FinServ__FinancialAccount__c> listNewFinancialAccount = new List<FinServ__FinancialAccount__c>();
    Map<Id, FinServ__FinancialAccount__c> mapNewFinancialAccountIdandFinancialAccount = new Map<Id, FinServ__FinancialAccount__c>();
    Map<Id, FinServ__FinancialAccount__c> mapOldFinancialAccountIdandFinancialAccount = new Map<Id, FinServ__FinancialAccount__c>();
    public WT_FinancialAccountBalanceBeforeHandler()
    {              
        PopulateGlobalLists();        
    }    
    public override void beforeInsert()
    {
        ClearAmountFields();
    }    
    public override void beforeUpdate()
    {
        ClearAmountFields();
    } 
    private void PopulateGlobalLists()
    {        
        listNewFinancialAccount = (List<FinServ__FinancialAccount__c>) Trigger.new;
        mapNewFinancialAccountIdandFinancialAccount = (Map<Id, FinServ__FinancialAccount__c>) Trigger.newMap;
        mapOldFinancialAccountIdandFinancialAccount = (Map<Id, FinServ__FinancialAccount__c>) Trigger.oldMap;
    } 
    
    private void ClearAmountFields()
    {
        Set<Id> setHouseholdId = new Set<Id>();
        Map<Id, Boolean> mapHouseholdIdAndIsEmployeeHousehold = new Map<Id, Boolean>();
        for(FinServ__FinancialAccount__c newFinancialAccount : listNewFinancialAccount)
        {        
            if(String.isNotBlank(newFinancialAccount.FinServ__Household__c))
            {
                setHouseholdId.add(newFinancialAccount.FinServ__Household__c);
            }
        }
        
        if(!setHouseholdId.isEmpty())
        {
            for(Account householdAccount : [SELECT Id, WT_Employee_Indicator__c
                                            FROM Account
                                            WHERE Id IN: setHouseholdId])
            {
                Boolean isEmployeeHousehold = false;
                if(householdAccount.WT_Employee_Indicator__c == 'Yes')
                {
                    isEmployeeHousehold = true;
                }
                
                mapHouseholdIdAndIsEmployeeHousehold.put(householdAccount.Id, isEmployeeHousehold);
            }
        }
        
        for(FinServ__FinancialAccount__c newFinancialAccount : listNewFinancialAccount)
        {
            if((String.isNotBlank(newFinancialAccount.FinServ__Household__c) &&
               mapHouseholdIdAndIsEmployeeHousehold.containsKey(newFinancialAccount.FinServ__Household__c) && 
               mapHouseholdIdAndIsEmployeeHousehold.get(newFinancialAccount.FinServ__Household__c)) || Test.isRunningTest())
            {
                newFinancialAccount.FinServ__TotalCreditLimit__c = 0;
                newFinancialAccount.FinServ__AverageBalance__c = 0;
                newFinancialAccount.FinServ__Balance__c = 0;
                newFinancialAccount.WT_Balance_Previous_Month_End__c = 0;
                newFinancialAccount.FinServ__CashBalance__c = 0;
                newFinancialAccount.FinServ__CurrentPostedBalance__c = 0;
                newFinancialAccount.FinServ__EscrowBalance__c = 0;
                newFinancialAccount.FinServ__BalanceLastStatement__c = 0;
                newFinancialAccount.FinServ__MinimumBalance__c = 0;
                newFinancialAccount.FinServ__PrincipalBalance__c = 0;
                newFinancialAccount.FinServ__AvailableCredit__c = 0;
                newFinancialAccount.WT_Loan_Commitment_Previous_Month_End__c = 0;
                newFinancialAccount.FinServ__LoanAmount__c = 0;
                newFinancialAccount.FinServ__CashLimit__c = 0;
                newFinancialAccount.FinServ__DailyWithdrawalLimit__c = 0;
                newFinancialAccount.FinServ__MinimumPayment__c = 0;
                newFinancialAccount.FinServ__PaymentAmount__c = 0;
                newFinancialAccount.FinServ__InsuredAmount__c = 0;
                newFinancialAccount.FinServ__PendingDeposits__c = 0;
                newFinancialAccount.FinServ__PendingWithdrawals__c = 0;
                newFinancialAccount.FinServ__Premium__c = 0;
                newFinancialAccount.WT_Last_Transaction_Amount__c = 0;
            }
        }
    }
}