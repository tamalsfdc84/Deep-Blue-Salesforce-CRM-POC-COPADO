/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_ActionPlanAfterHandler
* @Author			Karishma Keswani	<kkeswani@wintrust.com>
* @ModifiedBy		Vamsi Krishna	<vpulikal@wintrust.com>
* @Version			v1.0
* @CreatedDate		13-11-2020
* @UsedBy			Action Plan Object
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is handler class for action plan trigger.
*
* This handles all the after logic of the action plan trigger.
* --------------------------------------------------------------------------------------------------------------
* @Changes
* vX.X
* 29-06-2021
* --------------------------------------------------------------------------------------------------------------
**/
public class WT_ActionPlanAfterHandler extends TriggerHandler
{
    List<ActionPlan> listNewActionPlan = new List<ActionPlan>();
    Map<Id, ActionPlan> mapNewActionPlan = new Map<Id, ActionPlan>();
    Map<Id, ActionPlan> mapOldActionPlan = new Map<Id, ActionPlan>();
    public WT_ActionPlanAfterHandler()
    {
        PopulateGlobalLists();        
    }
    public override void afterInsert()
    {
        restrictCommercialTemplateForHousehold(listNewActionPlan);
    }
    public override void afterUpdate()
    {
    }
    private void PopulateGlobalLists()
    {        
        listNewActionPlan = (List<ActionPlan>) Trigger.new;
        mapNewActionPlan = (Map<Id, ActionPlan>) Trigger.newMap;
        mapOldActionPlan = (Map<Id, ActionPlan>) Trigger.oldMap;
    }
    /**
* --------------------------------------------------------------------------------------------------------------
* @Description
* This method restricts the user to select Commercial Onboarding template for HouseHold accounts
*
* --------------------------------------------------------------------------------------------------------------
* @Param  listNewActionPlan    List of Action Plans
* @Return void                 Returns none
* --------------------------------------------------------------------------------------------------------------
**/
    public static void restrictCommercialTemplateForHousehold(List<ActionPlan> listNewActionPlan)
    {
        Set<Id> setAccountIds = new Set<Id>();
        List<ActionPlan> listIncorrectActionPlans = new List<ActionPlan>();
        list<ActionPlanTemplateVersion> listActionPlanTemplateVersionRecord = new list<ActionPlanTemplateVersion>();
        listActionPlanTemplateVersionRecord = [SELECT Id, Name, ActionPlanTemplateId, Status FROM ActionPlanTemplateVersion WHERE Name ='Commercial Onboarding' AND Status = 'Final'];
        for(ActionPlan actionPlanRecord :listNewActionPlan)
        {
            if(actionPlanRecord.TargetId.getsObjectType() == Account.sObjectType && listActionPlanTemplateVersionRecord.size()>0 && actionPlanRecord.ActionPlanTemplateVersionId == listActionPlanTemplateVersionRecord[0].Id)
            {
                setAccountIds.add(actionPlanRecord.TargetId);
            }                
        }
        if(!setAccountIds.isEmpty())
        {
            list<Account> listHouseholdAccounts = new list<Account>();
            listHouseholdAccounts = [Select id, Ownerid,recordtype.name from Account where id In: setAccountIds and recordtype.developername ='IndustriesHousehold'];
            if(listHouseholdAccounts.size()>0)
            {
                for(ActionPlan actionPlanRecord :listNewActionPlan)
                {
                    actionPlanRecord.addError('You cannot select Commercial Onboarding action plan template for Household accounts');
                }
            }                
        }
    }
}