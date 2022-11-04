//Code coverage: WT_BatchHouseholdRelationProcessor_T
public class WT_PersonAccountHouseholdProcessor 
{
    public static void ProcessAccountContactRelation(Set<Id> setPersonContactIdToProcess)
    {
        Map<Id, Account> mapAccountIdAndAccountToUpdate = new Map<Id, Account>();
        Map<Id, Account> mapAccountIdAndAccount = new Map<Id, Account>();
        if(!setPersonContactIdToProcess.isEmpty())
        {
            mapAccountIdAndAccount = new Map<Id, Account>([SELECT Id,
                                                           WT_Parent_Household__pc
                                                           FROM Account
                                                           WHERE PersonContactId IN :setPersonContactIdToProcess]);
            
            for(AccountContactRelation relatedAccountContactRelation : [SELECT Id,
                                                                        AccountId,
                                                                        ContactId,
                                                                        Contact.AccountId,
                                                                        FinServ__PrimaryGroup__c
                                                                        FROM AccountContactRelation
                                                                        WHERE EndDate = null 
                                                                        AND IsActive = true
                                                                        AND IsDeleted = false
                                                                        AND ContactId != null
                                                                        AND FinServ__PrimaryGroup__c = true
                                                                        AND Contact.AccountId IN :mapAccountIdAndAccount.keySet()
                                                                        ORDER BY CreatedDate])
            {
                Account accountToUpdate = new Account();
                accountToUpdate.Id = relatedAccountContactRelation.Contact.AccountId;
                accountToUpdate.WT_Parent_Household__pc = relatedAccountContactRelation.AccountId;
                mapAccountIdAndAccountToUpdate.put(accountToUpdate.Id, accountToUpdate);
            }
            
            //Interate through the existing account list
            //If an existing account doesn't already exist in the map to update then that means that 
            //there's no active AccountContactRelation for that given account. In that scenario, we need to null out the parent household on the person account
            if(!mapAccountIdAndAccount.isEmpty())
            {
                for(Account existingAccount : mapAccountIdAndAccount.values())
                {
                    if(!mapAccountIdAndAccountToUpdate.containsKey(existingAccount.Id))
                    {
                        Account accountToUpdate = new Account();
                        accountToUpdate.Id = existingAccount.Id;
                        accountToUpdate.WT_Parent_Household__pc = null;
                        mapAccountIdAndAccountToUpdate.put(accountToUpdate.Id, accountToUpdate);
                    }
                }
            }
        }
        
        if(!mapAccountIdAndAccountToUpdate.isEmpty())
        {
            update mapAccountIdAndAccountToUpdate.values();
        }
    }
}