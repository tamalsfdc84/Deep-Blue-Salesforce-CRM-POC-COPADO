//Code coverage: WT_BatchHouseholdRelationProcessor_T
public class WT_HouseholdProcessor
{
	public static void ProcessAccountContactRelation(Set<Id> setHouseholdIdToProcess)
    {
        Map<Id, List<Account>> mapHouseholdIdAndListAssociatedAccount = new map<Id, List<Account>>();
        Map<Id, Account> mapHouseholdIdAndHouseholdToUpdate = new Map<Id, Account>();
        Map<Id, Account> mapHouseholdIdAndHousehold = new Map<Id, Account>();
        if(!setHouseholdIdToProcess.isEmpty())
        {
            mapHouseholdIdAndHousehold = new Map<Id, Account>([SELECT Id,
                                                               WT_First_Date_Of_Contact__c,
                                                               WT_Last_Date_Of_Contact__c
                                                               FROM Account
                                                               WHERE Id IN :setHouseholdIdToProcess]);
            
            for(AccountContactRelation relatedAccountContactRelation : [SELECT Id,
                                                                        AccountId,
                                                                        ContactId,
                                                                        Contact.AccountId,
                                                                        Contact.Account.WT_First_Date_Of_Contact__c,
                                                                        Contact.Account.WT_Last_Date_Of_Contact__c
                                                                        FROM AccountContactRelation
                                                                        WHERE EndDate = null 
                                                                        AND IsActive = true
                                                                        AND IsDeleted = false
                                                                        AND ContactId != null
                                                                        AND AccountId IN :mapHouseholdIdAndHousehold.keySet()
                                                                        ORDER BY CreatedDate])
            {
                List<Account> listRelatedAccount = new List<Account>();
                
                Account relatedAccount = new Account();
                relatedAccount.Id = relatedAccountContactRelation.Contact.AccountId;
                relatedAccount.WT_First_Date_Of_Contact__c = relatedAccountContactRelation.Contact.Account.WT_First_Date_Of_Contact__c;
                relatedAccount.WT_Last_Date_Of_Contact__c = relatedAccountContactRelation.Contact.Account.WT_Last_Date_Of_Contact__c;
                
                if(mapHouseholdIdAndListAssociatedAccount.containsKey(relatedAccountContactRelation.AccountId))
                {
                    listRelatedAccount = mapHouseholdIdAndListAssociatedAccount.get(relatedAccountContactRelation.AccountId);
                }
                listRelatedAccount.add(relatedAccount);
                
                mapHouseholdIdAndListAssociatedAccount.put(relatedAccountContactRelation.AccountId, listRelatedAccount);
            }
            
            if(!mapHouseholdIdAndListAssociatedAccount.isEmpty())
            {
                for(Id householdOrRelationshipGroupId : mapHouseholdIdAndListAssociatedAccount.keySet())
                {
                    Account householdOrRelationshipGroupToUpdate = new Account();
                    householdOrRelationshipGroupToUpdate.Id = householdOrRelationshipGroupId;
                    householdOrRelationshipGroupToUpdate.WT_First_Date_Of_Contact__c = null;
                    householdOrRelationshipGroupToUpdate.WT_Last_Date_Of_Contact__c = null;
                    
                    List<Account> listRelatedAccount = mapHouseholdIdAndListAssociatedAccount.get(householdOrRelationshipGroupId);
                    if(!listRelatedAccount.isEmpty())
                    {
                        for(Account relatedAccount : listRelatedAccount)
                        {
                            if((householdOrRelationshipGroupToUpdate.WT_First_Date_Of_Contact__c != null && relatedAccount.WT_First_Date_Of_Contact__c != null &&
                                relatedAccount.WT_First_Date_Of_Contact__c < householdOrRelationshipGroupToUpdate.WT_First_Date_Of_Contact__c) || 
                               (relatedAccount.WT_First_Date_Of_Contact__c != null && householdOrRelationshipGroupToUpdate.WT_First_Date_Of_Contact__c == null))
                            {
                                householdOrRelationshipGroupToUpdate.WT_First_Date_Of_Contact__c = relatedAccount.WT_First_Date_Of_Contact__c;
                            }
                            if((householdOrRelationshipGroupToUpdate.WT_Last_Date_Of_Contact__c != null && relatedAccount.WT_Last_Date_Of_Contact__c != null &&
                                relatedAccount.WT_Last_Date_Of_Contact__c > householdOrRelationshipGroupToUpdate.WT_Last_Date_Of_Contact__c) || 
                               (relatedAccount.WT_Last_Date_Of_Contact__c != null && householdOrRelationshipGroupToUpdate.WT_Last_Date_Of_Contact__c == null))
                            {
                                householdOrRelationshipGroupToUpdate.WT_Last_Date_Of_Contact__c = relatedAccount.WT_Last_Date_Of_Contact__c;
                            }
                        }
                    }
                    mapHouseholdIdAndHouseholdToUpdate.put(householdOrRelationshipGroupToUpdate.Id, householdOrRelationshipGroupToUpdate);
                }
            }
        }
        
        if(!mapHouseholdIdAndHouseholdToUpdate.isEmpty())
        {
            update mapHouseholdIdAndHouseholdToUpdate.values();
        }
    }
}