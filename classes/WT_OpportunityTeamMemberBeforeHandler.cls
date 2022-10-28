/**
* @Name             WT_OpportunityTeamMemberBeforeHandler 
* @Author           Karan Jugtawat      <KSinghJu@Wintrust.com>
* @ModifiedBy
* @Version          v1.0
* @CreatedDate      16-FEB-2021
* @UsedBy           WT_OpportunityTeamMemberTrigger
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* this is used by trigger WT_OpportunityTeamMemberTrigger
* validateOpportunityTeam() this method will make sure every opportunity team member(User) on inserting is having a unique Line of business(User Field) value.
* --------------------------------------------------------------------------------------------------------------
* @Changes
* --------------------------------------------------------------------------------------------------------------
**/
// Code Coverage: WT_OpportunityTeamMemberTriggerHandler_T
public class WT_OpportunityTeamMemberBeforeHandler Extends TriggerHandler
{
    List<OpportunityTeamMember> listNewOpportunityTeamMember = new List<OpportunityTeamMember>();
    Map<Id, Opportunity> mapRelatedOpportunityIdAndOpportunity = new Map<Id, Opportunity>();
    Map<Id, OpportunityTeamMember> mapOldOpportunityTeamMemberIdAndOpportunityTeamMember = new Map<Id, OpportunityTeamMember>();
    
    public WT_OpportunityTeamMemberBeforeHandler()
    {
        listNewOpportunityTeamMember = (List<OpportunityTeamMember>)Trigger.new;
        mapOldOpportunityTeamMemberIdAndOpportunityTeamMember = (Map<Id, OpportunityTeamMember>)Trigger.oldMap;
        PopulateOpportunityData();
    }
    public override void beforeInsert () 
    {
        ValidateOpportunityTeamRole();
    }
    public override void beforeUpdate () 
    {
        ValidateOpportunityTeamRole();
    }
        
    /**
* --------------------------------------------------------------------------------------------------------------
* @Description
* This method will query all related Opportunities and grab the Owner data
* This can be used in any method for this class so that we do not have to query Opportunity records in multiple
* places
* --------------------------------------------------------------------------------------------------------------
* @Return void           Returns none
* --------------------------------------------------------------------------------------------------------------
**/
    private void PopulateOpportunityData()
    {
        Set<Id> setOpportunityIdToQuery = new Set<Id>();
        if(listNewOpportunityTeamMember != null && !listNewOpportunityTeamMember.isEmpty())
        {
            for(OpportunityTeamMember newOpportunityTeamMember : listNewOpportunityTeamMember)
            {
                if(newOpportunityTeamMember.OpportunityId != null)
                {
                    setOpportunityIdToQuery.add(newOpportunityTeamMember.OpportunityId);
                }
            }
        }
        
        if(!setOpportunityIdToQuery.isEmpty())
        {
            for(Opportunity relatedOpportunity : [SELECT Id,
                                                  OwnerId
                                                  FROM Opportunity
                                                  WHERE Id IN :setOpportunityIdToQuery])
            {
                mapRelatedOpportunityIdAndOpportunity.put(relatedOpportunity.Id, relatedOpportunity);
            }
        }
    }
    
    /**
* --------------------------------------------------------------------------------------------------------------
* @Description
* This method will make sure every opportunity team member(User) on Team Role.
* --------------------------------------------------------------------------------------------------------------
* @Return void           Returns none
* --------------------------------------------------------------------------------------------------------------
**/
    private void ValidateOpportunityTeamRole()
    {
        for(OpportunityTeamMember opportunityTeamMember : listNewOpportunityTeamMember)
        {
            if(mapRelatedOpportunityIdAndOpportunity != null && mapRelatedOpportunityIdAndOpportunity.containsKey(opportunityTeamMember.OpportunityId))
            {
                Opportunity relatedOpportunity = mapRelatedOpportunityIdAndOpportunity.get(opportunityTeamMember.OpportunityId);
                if(relatedOpportunity.OwnerId != opportunityTeamMember.UserId)
                { 
                    if(opportunityTeamMember.TeamMemberRole == 'Product Partner' && opportunityTeamMember.OpportunityAccessLevel == 'Read')
                    {
                        opportunityTeamMember.addError('Product Partners should have their access set to Read/Write');
                    }
                    else if(opportunityTeamMember.TeamMemberRole == 'Share Credit' && opportunityTeamMember.OpportunityAccessLevel == 'Edit')
                    {
                        opportunityTeamMember.addError('Shared Credit users should have their access set to Read Only');
                    }
                }
            }            
        }
    }
}