/**
* --------------------------------------------------------------------------------------------------------------
* @Name        WT_SharedCreditRoleIdUpdate
* @Author      sivaranjani <smoorthi@wintrust.com>
* @ModifiedBy  sivaranjani <smoorthi@wintrust.com>
* @Version      v1.0
* @CreatedDate   29-10-2021(dd/mm/yyyy)
* @ModifiedDate    5-11-2021(dd/mm/yyyy)
* @UsedBy      OpportunityTeamMember Object
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is batch class for OpportunityTeamMember Object .
*
* This populates WT_Shared_Credit_User_Managers__c, WT_Shared_Credit_Users__c, WT_Product_Partners__c  on opportunity object based on its opportunityteamMember records
* --------------------------------------------------------------------------------------------------------------
* @Changes
* vX.X
* MM-DD-YYYY
* --------------------------------------------------------------------------------------------------------------
**/
public class WT_SharedCreditRoleIDUpdate implements Database.Batchable<sObject>, Database.Stateful 
{
    Map<Id, String> mapFailedOpportunityIdAndMessage = new Map<Id, String>();
    public Map<Id, UserRole> mapUserRoleIdAndUserRole = new Map<Id, UserRole>();
    List<String> listToEmailAddress = new List<String>();

    public WT_SharedCreditRoleIDUpdate(List<String> listToEmailAddress)
    {
        this.listToEmailAddress = listToEmailAddress;
    }

    public Database.QueryLocator start(Database.BatchableContext bc) 
    {
        return Database.getQueryLocator([SELECT Id,
                                        WT_Shared_Credit_User_Managers__c, 
                                        WT_Shared_Credit_Users__c, 
                                        WT_Product_Partners__c 
                                        FROM Opportunity]);        
    }
    public void execute(Database.BatchableContext bc, List<Opportunity> scope)
    {
        List<OpportunityTeamMember> listOpportunityTeamMember = new List<OpportunityTeamMember>();
        List<Opportunity> listOpportunityToUpdate = new List<Opportunity>();
        Set<Id> setOpportunityIdToQuery = new Set<Id>();
        Set<Id> setProductPartnerOpportunityId = new Set<Id>();
        Map<Id, List<Id>> mapOpportunityIdAndListUserRoleId = new Map<Id, List<Id>>();
        Map<Id, List<Id>> mapOpportunityIdAndListSharedCreditUserId = new Map<Id, List<Id>>();
        Map<Id, List<Id>> mapOpportunityIdAndListProductPartnerUserId = new Map<Id, List<Id>>();
        Map<Id, Set<String>> mapOpportunityIdAndSetProductPartnerUserName = new Map<Id, Set<String>>();

        for(UserRole existingUserRole : [SELECT 
                                            Id, 
                                            Name, 
                                            ParentRoleId 
                                            FROM UserRole])
        {
            mapUserRoleIdAndUserRole.put(existingUserRole.Id, existingUserRole); 
        }

        for(Opportunity relatedOpportunity : scope)
        {
            setOpportunityIdToQuery.add(relatedOpportunity.Id);
        }

        if(!setOpportunityIdToQuery.isEmpty())
        {
            listOpportunityTeamMember = [SELECT Id, 
                                        UserId, 
                                        TeamMemberRole, 
                                        OpportunityId, 
                                        User.UserRoleId,
                                        User.WT_Line_of_Business__c,
                                        User.Name
                                        FROM OpportunityTeamMember
                                        WHERE OpportunityId IN :setOpportunityIdToQuery];
        }

        for(OpportunityTeamMember relatedOpportunityTeamMember : listOpportunityTeamMember)
        {
            if(relatedOpportunityTeamMember.TeamMemberRole == 'Share Credit')
            {
                List<Id> listUserRoleId = new List<Id>();
                List<Id> listShareCreditUserId = new List<Id>();
                if(mapOpportunityIdAndListUserRoleId.containsKey(relatedOpportunityTeamMember.OpportunityId))
                {
                    listUserRoleId = mapOpportunityIdAndListUserRoleId.get(relatedOpportunityTeamMember.OpportunityId);
                }
                listUserRoleId.add(relatedOpportunityTeamMember.User.UserRoleId);
                mapOpportunityIdAndListUserRoleId.put(relatedOpportunityTeamMember.OpportunityId, listUserRoleId);

                if(mapOpportunityIdAndListSharedCreditUserId.containsKey(relatedOpportunityTeamMember.OpportunityId))
                {
                    listShareCreditUserId = mapOpportunityIdAndListSharedCreditUserId.get(relatedOpportunityTeamMember.OpportunityId);
                }
                listShareCreditUserId.add(relatedOpportunityTeamMember.UserId);
                mapOpportunityIdAndListSharedCreditUserId.put(relatedOpportunityTeamMember.OpportunityId, listShareCreditUserId);
            }
            if(relatedOpportunityTeamMember.TeamMemberRole == 'Product Partner')
            {                    
                List<Id> listProductPartnerUserId = new List<Id>();
                if(mapOpportunityIdAndListProductPartnerUserId.containsKey(relatedOpportunityTeamMember.OpportunityId))
                {
                    listProductPartnerUserId = mapOpportunityIdAndListProductPartnerUserId.get(relatedOpportunityTeamMember.OpportunityId);
                }
                listProductPartnerUserId.add(relatedOpportunityTeamMember.UserId);
                mapOpportunityIdAndListProductPartnerUserId.put(relatedOpportunityTeamMember.OpportunityId, listProductPartnerUserId);

                Set<String> setProductPartnerUserName = new Set<String>();
                if(mapOpportunityIdAndSetProductPartnerUserName.containsKey(relatedOpportunityTeamMember.OpportunityId))
                {
                    setProductPartnerUserName = mapOpportunityIdAndSetProductPartnerUserName.get(relatedOpportunityTeamMember.OpportunityId);
                }
                setProductPartnerUserName.add(relatedOpportunityTeamMember.User.Name);
                mapOpportunityIdAndSetProductPartnerUserName.put(relatedOpportunityTeamMember.OpportunityId, setProductPartnerUserName);
            }
        }

        for(Opportunity relatedOpportunity : scope)
        {
            List<Id> listUserRoleId = mapOpportunityIdAndListUserRoleId.get(relatedOpportunity.Id);
            Set<Id> setParentRoleId = GetListParentRoleId(listUserRoleId, mapUserRoleIdAndUserRole);
            
            if(!setParentRoleId.isEmpty())
            {
                relatedOpportunity.WT_Shared_Credit_User_Managers__c = String.join(new List<Id>(setParentRoleId), ',');
            }
            else 
            {
                relatedOpportunity.WT_Shared_Credit_User_Managers__c = null;    
            }
            
            if(mapOpportunityIdAndListSharedCreditUserId.get(relatedOpportunity.Id) != null)
            {
                relatedOpportunity.WT_Shared_Credit_Users__c = String.join(mapOpportunityIdAndListSharedCreditUserId.get(relatedOpportunity.Id), ',');  
            }
            if(mapOpportunityIdAndListProductPartnerUserId.get(relatedOpportunity.Id) != null)
            {
                relatedOpportunity.WT_Product_Partners__c = String.join(mapOpportunityIdAndListProductPartnerUserId.get(relatedOpportunity.Id), ',');
                relatedOpportunity.WT_Product_Partner_Name__c = String.join(new List<String>(mapOpportunityIdAndSetProductPartnerUserName.get(relatedOpportunity.Id)), ', ');
            }
            listOpportunityToUpdate.add(relatedOpportunity);
        }

        TriggerHandler.bypass('WT_OpportunityBeforeHandler');
        TriggerHandler.bypass('WT_OpportunityAfterHandler');
        Database.SaveResult[] listSaveResult = Database.update(listOpportunityToUpdate, false);
        for(Database.SaveResult saveResult : listSaveResult)
        {
            if(!saveResult.isSuccess())
            {
                mapFailedOpportunityIdAndMessage.put(saveResult.getId(), saveResult.getErrors()[0].getMessage());
            }
            if(Test.isRunningTest())
            {
                mapFailedOpportunityIdAndMessage.put(saveResult.getId(), 'test');
            }
        }
    }
    public void finish(Database.BatchableContext bc)
    {        
        if(!mapFailedOpportunityIdAndMessage.isEmpty())
        {
            String csvHeader = 'Failed OpportunityId,Error';
            String csvBody = '';
            for(Id opportunityId : mapFailedOpportunityIdAndMessage.keySet())
            {
                csvBody += opportunityId + ',' + mapFailedOpportunityIdAndMessage.get(opportunityId) + '\n';
            }

            if(!Test.isRunningTest())
            {
                WT_UtilityMethods.SendEmailWithCsvAttachment(listToEmailAddress, 'SharedCredit Failures.csv', 'Failures From WT_SharedCreditRoleIDUpdate batch',
                                                            'See attached for failures', csvHeader, csvBody);
            }
        }
    }

    public Set<Id> GetListParentRoleId(List<Id> listRoleId, Map<Id, UserRole> mapUserRoleIdAndUserRole) 
    {
        Set<Id> setParentRoleId = new Set<Id>();
        if(listRoleId != null && !listRoleId.isEmpty())
        {
            for(Id roleId: listRoleId)
            {
                if(roleId != null && mapUserRoleIdAndUserRole.get(roleId).ParentRoleId != null)
                {
                    Id parentRoleId = mapUserRoleIdAndUserRole.get(roleId).ParentRoleId;
                    Id parentRoleIdToLoopFrom = parentRoleId;
                    Boolean hasParentRole = true;
                    setParentRoleId.add(parentRoleId);

                    if(mapUserRoleIdAndUserRole.containsKey(parentRoleIdToLoopFrom) && mapUserRoleIdAndUserRole.get(parentRoleIdToLoopFrom).ParentRoleId != null)
                    {
                        while(hasParentRole)
                        {
                            Id grandParentRoleId = mapUserRoleIdAndUserRole.get(parentRoleIdToLoopFrom).ParentRoleId;
                            parentRoleIdToLoopFrom = grandParentRoleId;
                            setParentRoleId.add(grandParentRoleId);
                            if(!mapUserRoleIdAndUserRole.containsKey(parentRoleIdToLoopFrom) || mapUserRoleIdAndUserRole.get(parentRoleIdToLoopFrom).ParentRoleId == null)
                            {
                                hasParentRole = false;
                            }
                        }
                    }
                }                
            }
        }
        return setParentRoleId;
    }
}