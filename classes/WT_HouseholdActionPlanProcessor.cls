//Code coverage: WT_BatchHouseholdRelationProcessor_T
public class WT_HouseholdActionPlanProcessor
{
    public static void ProcessAccountContactRelation(Set<Id> setPersonContactIdToProcess)
    {
        List<ActionPlan> listActionPlanToUpdate = new List<ActionPlan>();
        Map<Id, Id> mapContactIdAndHouseholdId = new Map<Id, Id>();
        if(!setPersonContactIdToProcess.isEmpty())
        {
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
                                                                        AND ContactId IN :setPersonContactIdToProcess
                                                                        ORDER BY CreatedDate])
            {
                mapContactIdAndHouseholdId.put(relatedAccountContactRelation.ContactId, relatedAccountContactRelation.AccountId);
            }
            
            for(ActionPlan relatedActionPlan : [SELECT Id, 
                                                WT_ContactId__c,
                                                WT_Household__c
                                                FROM ActionPlan
                                                WHERE WT_ContactId__c IN :setPersonContactIdToProcess])
            {                
                ActionPlan actionPlanToUpdate = UpdateActionPlan(relatedActionPlan, mapContactIdAndHouseholdId);
                listActionPlanToUpdate.add(actionPlanToUpdate);
            }
            
            if(!listActionPlanToUpdate.isEmpty())
            {
                Database.update(listActionPlanToUpdate, false);
            }
        }
    }
    
    public static ActionPlan UpdateActionPlan(ActionPlan actionPlanToUpdate, Map<Id, Id> mapContactIdAndHouseholdId)
    {
        if(!mapContactIdAndHouseholdId.containsKey(actionPlanToUpdate.WT_ContactId__c))
        {
            actionPlanToUpdate.WT_Household__c = null;
        }                
        if(mapContactIdAndHouseholdId.containsKey(actionPlanToUpdate.WT_ContactId__c))
        {
            actionPlanToUpdate.WT_Household__c = mapContactIdAndHouseholdId.get(actionPlanToUpdate.WT_ContactId__c);
        }
        
        return actionPlanToUpdate;
    }
}