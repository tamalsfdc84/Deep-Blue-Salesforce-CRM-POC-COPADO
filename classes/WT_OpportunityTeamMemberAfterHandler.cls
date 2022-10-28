/**
* --------------------------------------------------------------------------------------------------------------
* @Name        WT_OpportunityTeamMemberAfterHandler
* @Author      Pushpa Mopuru  <PMopuru@wintrust.com>
* @ModifiedBy  Vamsi Pulikallu  <vpulikal@wintrust.com>
* @Version      v1.0
* @CreatedDate    2-18-2021
* @ModifiedDate    2-23-2021
* @UsedBy      OpportunityTeamMember Object
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is handler class for OpportunityTeamMember Object trigger.
*
* This handles all the After logic of the OpportunityTeamMember Object trigger.
* --------------------------------------------------------------------------------------------------------------
* @Changes
* vX.X
* MM-DD-YYYY
* --------------------------------------------------------------------------------------------------------------
**/
// Code Coverage: WT_OpportunityTeamMemberAfterHandler_T
public class WT_OpportunityTeamMemberAfterHandler  extends TriggerHandler
{
    List<OpportunityTeamMember> listNewOpportunityTeamMember = new List<OpportunityTeamMember>();
    List<OpportunityTeamMember> listOldOpportunityTeamMember = new List<OpportunityTeamMember>();
    Map<Id, OpportunityTeamMember> mapNewOpportunityTeamMemberIdAndOpportunityNewMember = new Map<Id, OpportunityTeamMember>();
    Map<Id, OpportunityTeamMember> mapOldOpportunityTeamMemberIdAndOpportunityNewMember = new Map<Id, OpportunityTeamMember>();
    public Map<Id, UserRole> mapUserRoleIdAndUserRole = new Map<Id, UserRole>();
    Map<Id, List<Id>> mapUserRoleIdAndListUserId = new Map<Id, List<Id>>();

    public WT_OpportunityTeamMemberAfterHandler()
    {
        listNewOpportunityTeamMember = (List<OpportunityTeamMember>)Trigger.new;
        listOldOpportunityTeamMember = (List<OpportunityTeamMember>)Trigger.old;
        mapNewOpportunityTeamMemberIdAndOpportunityNewMember = (Map<Id, OpportunityTeamMember>)Trigger.newMap;
        mapOldOpportunityTeamMemberIdAndOpportunityNewMember = (Map<Id, OpportunityTeamMember>)Trigger.oldMap;
        PopulateUserRole();
    }
    public override void afterInsert()
    {
        UpdateOpportunity(true);
        SendOpportunityNotification();
    }    
    public override void afterUpdate()
    {
        UpdateOpportunity(false);
    }
    public override void afterDelete()
    {
        UpdateOpportunity(false);
    }

    private void PopulateUserRole()
    {
        for(UserRole existingUserRole : [SELECT 
                                            Id, 
                                            Name, 
                                            ParentRoleId 
                                            FROM UserRole])
        {
            mapUserRoleIdAndUserRole.put(existingUserRole.Id, existingUserRole); 
        }

        for(User currentActiveUser : [SELECT 
                                        Id, 
                                        Name, 
                                        UserRoleId 
                                        FROM User
                                        WHERE IsActive = true
                                        LIMIT 10000])
        {
            List<Id> listUserId = new List<Id>();

            if(mapUserRoleIdAndListUserId.containsKey(currentActiveUser.UserRoleId))
            {
                listUserId = mapUserRoleIdAndListUserId.get(currentActiveUser.UserRoleId);
            }
            listUserId.add(currentActiveUser.Id);

            mapUserRoleIdAndListUserId.put(currentActiveUser.UserRoleId, listUserId);
        }
    }

    private void SendOpportunityNotification()
    {
        Map<Id, String> mapOpportunityIdAndRoleToNotify = new Map<Id, String>();  
        Map<Id, Opportunity> mapOpportunityIdAndOpportunity = new Map<Id, Opportunity>();
        Set<Id> setRelatedOpportunityId = new Set<Id>();

        Set<String> setStageToNotify = new Set<String>
        {
            '3. Opportunity Sent For Processing',
            '6. Opportunity In Underwriting',
            '8. Opportunity In Pre-Close',
            '12. Loan Lost/Denied'
        };

        for(OpportunityTeamMember newOpportunityTeamMember : listNewOpportunityTeamMember)
        {
            setRelatedOpportunityId.add(newOpportunityTeamMember.OpportunityId);
        }

        if(!setRelatedOpportunityId.isEmpty())
        {
            mapOpportunityIdAndOpportunity = GetRelatedOpportunityData(setRelatedOpportunityId);
        }

        if(!mapOpportunityIdAndOpportunity.isEmpty())
        {
            for(OpportunityTeamMember newOpportunityTeamMember : listNewOpportunityTeamMember)
            {
                if(mapOpportunityIdAndOpportunity.containsKey(newOpportunityTeamMember.OpportunityId))
                {
                    Opportunity relatedOpportunity = mapOpportunityIdAndOpportunity.get(newOpportunityTeamMember.OpportunityId);
                    if(setStageToNotify.contains(relatedOpportunity.StageName))
                    {
                        Boolean isValidNotification = false;
                        String opportunityRole = '';

                        switch on relatedOpportunity.StageName
                        {
                            when '3. Opportunity Sent For Processing'
                            {
                                opportunityRole = 'Processing';
                                if(newOpportunityTeamMember.TeamMemberRole == 'Processor')
                                {
                                    isValidNotification = true;
                                }
                            }
                            when '6. Opportunity In Underwriting'
                            {
                                opportunityRole = 'Underwriting';
                                if(newOpportunityTeamMember.TeamMemberRole == 'Credit Analyst')
                                {
                                    isValidNotification = true;
                                }
                            }
                            when '8. Opportunity In Pre-Close'
                            {
                                opportunityRole = 'Closing';
                                if(newOpportunityTeamMember.TeamMemberRole == 'Closer')
                                {
                                    isValidNotification = true;
                                }
                            }
                            when '12. Loan Lost/Denied'
                            {
                                opportunityRole = 'DeniedProcessing';
                                if(newOpportunityTeamMember.TeamMemberRole == 'Processor')
                                {
                                    isValidNotification = true;
                                }
                            }
                        }

                        if(isValidNotification)
                        {
                            mapOpportunityIdAndRoleToNotify.put(relatedOpportunity.Id, opportunityRole);
                        }
                    }
                }
            }
        }

        if(!mapOpportunityIdAndRoleToNotify.isEmpty())
        {
            System.enqueueJob(new WT_OpportunityNotificationQueueable(mapOpportunityIdAndRoleToNotify));
        }
    }

        /**
    * --------------------------------------------------------------------------------------------------------------
    * @Description
    * This method will query all related Opportunities and grab the Owner data
    * This can be used in any method for this class so that we do not have to query Opportunity records in multiple
    * places
    * --------------------------------------------------------------------------------------------------------------
    * @Return Map<Id, Opportunity>           
    * --------------------------------------------------------------------------------------------------------------
    **/
    public Map<Id, Opportunity> GetRelatedOpportunityData(Set<Id> setOpportunityIdToQuery)
    {
        Map<Id, Opportunity> mapRelatedOpportunityIdAndOpportunity = new Map<Id, Opportunity>();
        if(!setOpportunityIdToQuery.isEmpty())
        {
            for(Opportunity relatedOpportunity : [SELECT Id,
                                                    OwnerId,
                                                    RecordTypeId,
                                                    WT_Shared_Credit_User_Managers__c,
                                                    WT_Shared_Credit_Users__c,
                                                    WT_Product_Partners__c,
                                                    WT_Product_Partner_Name__c,
                                                    Owner.WT_Line_of_Business__c,
                                                    WT_Fee__c,
                                                    WT_Product__r.Name,
                                                    WT_Product__c,
                                                    WT_TMOnboarding_Eligible__c,
                                                    WT_Credit_Analyst_Manager_User_Role_Ids__c,
                                                    WT_Credit_Analyst_User_Ids__c,
                                                    WT_Credit_Analyst_Name__c,
                                                    WT_Processor_Manager_User_Role_Ids__c,
                                                    WT_Processor_Name__c,
                                                    WT_Processor_User_Ids__c,
                                                    WT_Closer_Manager_User_Role_Ids__c,
                                                    WT_Closer_Name__c,
                                                    WT_Closer_User_Ids__c,
                                                    StageName
                                                    FROM Opportunity
                                                    WHERE Id IN :setOpportunityIdToQuery])
            {
                mapRelatedOpportunityIdAndOpportunity.put(relatedOpportunity.Id, relatedOpportunity);
            }
        }

        return mapRelatedOpportunityIdAndOpportunity;
    }

        /**
    * --------------------------------------------------------------------------------------------------------------
    * @Description
    * This method will query all OpportunityTeamMember records related to a give Opportunity
    * This is needed so that we can contruct a full list of Product Partners and Shared Credit Users on the 
    * opportunity record
    * --------------------------------------------------------------------------------------------------------------
    * @Return Map<Id, List<OpportunityTeamMember>> Returns Map of Opportunity ID & all its related OpportunityTeamMember
    * --------------------------------------------------------------------------------------------------------------
    **/
    public Map<Id, List<OpportunityTeamMember>> GetListOfOpportunityTeamMemberRelatedToOpportunity(Set<Id> setOpportunityIdToQuery)
    {
        Map<Id, List<OpportunityTeamMember>> mapOpportunityIdAndListOpportunityTeamMember = new Map<Id, List<OpportunityTeamMember>>();
        if(!setOpportunityIdToQuery.isEmpty())
        {
            for(OpportunityTeamMember relatedOpportunityTeamMember : [SELECT Id,
                                                            UserId,
                                                            User.Name,
                                                            User.WT_Line_of_Business__c,
                                                            User.UserRoleId,
                                                            TeamMemberRole,
                                                            OpportunityId
                                                            FROM OpportunityTeamMember
                                                            WHERE OpportunityId IN :setOpportunityIdToQuery])
            {
                List<OpportunityTeamMember> listOpportunityTeamMember = new List<OpportunityTeamMember>();
                
                if(mapOpportunityIdAndListOpportunityTeamMember.containsKey(relatedOpportunityTeamMember.OpportunityId))
                {
                    listOpportunityTeamMember = mapOpportunityIdAndListOpportunityTeamMember.get(relatedOpportunityTeamMember.OpportunityId);
                }

                listOpportunityTeamMember.add(relatedOpportunityTeamMember);
                mapOpportunityIdAndListOpportunityTeamMember.put(relatedOpportunityTeamMember.OpportunityId, listOpportunityTeamMember);
            }
        }

        return mapOpportunityIdAndListOpportunityTeamMember;
    }

    private void UpdateOpportunity(Boolean isInsert)
    {        
        List<OpportunityTeamMember> listOpportunityTeamMemberToInsert = new List<OpportunityTeamMember>();
        List<Opportunity> listOpportunityToUpdate = new List<Opportunity>();
        Set<Id> setRelatedOpportunityId = new Set<Id>();
        Map<Id, User> mapRelatedUserIdAndUser = new Map<Id, User>();
        Map<Id, List<Id>> mapOpportunityIdAndListUserRoleId = new Map<Id, List<Id>>();
        Map<Id, List<Id>> mapOpportunityIdAndListProcessorUserRoleId = new Map<Id, List<Id>>();
        Map<Id, List<Id>> mapOpportunityIdAndListCloserUserRoleId = new Map<Id, List<Id>>();
        Map<Id, List<Id>> mapOpportunityIdAndListCreditAnalystUserRoleId = new Map<Id, List<Id>>();
        Map<Id, List<Id>> mapOpportunityIdAndListSharedCreditUserId = new Map<Id, List<Id>>();
        Map<Id, List<Id>> mapOpportunityIdAndListProductPartnerUserId = new Map<Id, List<Id>>();
        Map<Id, List<Id>> mapOpportunityIdAndListProcessorUserId = new Map<Id, List<Id>>();
        Map<Id, List<Id>> mapOpportunityIdAndListCloserUserId = new Map<Id, List<Id>>();
        Map<Id, List<Id>> mapOpportunityIdAndListCreditAnalystUserId = new Map<Id, List<Id>>();
        Map<Id, Set<String>> mapOpportunityIdAndSetProductPartnerUserName = new Map<Id, Set<String>>();
        Map<Id, Set<String>> mapOpportunityIdAndSetProcessorUserName = new Map<Id, Set<String>>();
        Map<Id, Set<String>> mapOpportunityIdAndSetCloserUserName = new Map<Id, Set<String>>();
        Map<Id, Set<String>> mapOpportunityIdAndSetCreditAnalystUserName = new Map<Id, Set<String>>();
        List<OpportunityTeamMember> listOpportunityTeamMember = new List<OpportunityTeamMember>();
        Id tmOpportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('WT_TM').getRecordTypeId();        
        List<String> listProduct = System.label.TM_Onboarding_Eligible_Products.split(',');
        Map<Id, List<OpportunityTeamMember>> mapOpportunityIdAndListOpportunityTeamMember = new Map<Id, List<OpportunityTeamMember>>();

        if(Trigger.isDelete)
        {
            listOpportunityTeamMember = listOldOpportunityTeamMember;
        }
        else 
        {
            listOpportunityTeamMember = listNewOpportunityTeamMember;
        }

        for(OpportunityTeamMember newOpportunityTeamMember : listOpportunityTeamMember)
        {
            if(Trigger.isDelete || Trigger.isInsert || 
            (Trigger.isUpdate && 
            (newOpportunityTeamMember.TeamMemberRole != mapOldOpportunityTeamMemberIdAndOpportunityNewMember.get(newOpportunityTeamMember.Id).TeamMemberRole ||
            newOpportunityTeamMember.OpportunityId != mapOldOpportunityTeamMemberIdAndOpportunityNewMember.get(newOpportunityTeamMember.Id).OpportunityId || 
            newOpportunityTeamMember.UserId != mapOldOpportunityTeamMemberIdAndOpportunityNewMember.get(newOpportunityTeamMember.Id).UserId)))
            {                
                setRelatedOpportunityId.add(newOpportunityTeamMember.OpportunityId);
            }
        }

        if(!setRelatedOpportunityId.isEmpty())
        {
            mapOpportunityIdAndListOpportunityTeamMember = GetListOfOpportunityTeamMemberRelatedToOpportunity(setRelatedOpportunityId);
        }

        for(Id relatedOpportunityId : mapOpportunityIdAndListOpportunityTeamMember.keySet())
        {
            for(OpportunityTeamMember relatedOpportunityTeamMember : mapOpportunityIdAndListOpportunityTeamMember.get(relatedOpportunityId))
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
                if(relatedOpportunityTeamMember.TeamMemberRole == 'Processor')
                {                
                    List<Id> listProcessorUserRoleId = new List<Id>();
                    if(mapOpportunityIdAndListProcessorUserRoleId.containsKey(relatedOpportunityTeamMember.OpportunityId))
                    {
                        listProcessorUserRoleId = mapOpportunityIdAndListProcessorUserRoleId.get(relatedOpportunityTeamMember.OpportunityId);
                    }
                    listProcessorUserRoleId.add(relatedOpportunityTeamMember.User.UserRoleId);
                    mapOpportunityIdAndListProcessorUserRoleId.put(relatedOpportunityTeamMember.OpportunityId, listProcessorUserRoleId);
                    
                    List<Id> listProcessorUserId = new List<Id>();
                    if(mapOpportunityIdAndListProcessorUserId.containsKey(relatedOpportunityTeamMember.OpportunityId))
                    {
                        listProcessorUserId = mapOpportunityIdAndListProcessorUserId.get(relatedOpportunityTeamMember.OpportunityId);
                    }
                    listProcessorUserId.add(relatedOpportunityTeamMember.UserId);
                    mapOpportunityIdAndListProcessorUserId.put(relatedOpportunityTeamMember.OpportunityId, listProcessorUserId);

                    Set<String> setProcessorUserName = new Set<String>();
                    if(mapOpportunityIdAndSetProcessorUserName.containsKey(relatedOpportunityTeamMember.OpportunityId))
                    {
                        setProcessorUserName = mapOpportunityIdAndSetProcessorUserName.get(relatedOpportunityTeamMember.OpportunityId);
                    }
                    setProcessorUserName.add(relatedOpportunityTeamMember.User.Name);
                    mapOpportunityIdAndSetProcessorUserName.put(relatedOpportunityTeamMember.OpportunityId, setProcessorUserName);
                }
                if(relatedOpportunityTeamMember.TeamMemberRole == 'Closer')
                {                
                    List<Id> listCloserUserRoleId = new List<Id>();
                    if(mapOpportunityIdAndListCloserUserRoleId.containsKey(relatedOpportunityTeamMember.OpportunityId))
                    {
                        listCloserUserRoleId = mapOpportunityIdAndListCloserUserRoleId.get(relatedOpportunityTeamMember.OpportunityId);
                    }
                    listCloserUserRoleId.add(relatedOpportunityTeamMember.User.UserRoleId);
                    mapOpportunityIdAndListCloserUserRoleId.put(relatedOpportunityTeamMember.OpportunityId, listCloserUserRoleId);
                    
                    List<Id> listCloserUserId = new List<Id>();
                    if(mapOpportunityIdAndListCloserUserId.containsKey(relatedOpportunityTeamMember.OpportunityId))
                    {
                        listCloserUserId = mapOpportunityIdAndListCloserUserId.get(relatedOpportunityTeamMember.OpportunityId);
                    }
                    listCloserUserId.add(relatedOpportunityTeamMember.UserId);
                    mapOpportunityIdAndListCloserUserId.put(relatedOpportunityTeamMember.OpportunityId, listCloserUserId);

                    Set<String> setCloserUserName = new Set<String>();
                    if(mapOpportunityIdAndSetCloserUserName.containsKey(relatedOpportunityTeamMember.OpportunityId))
                    {
                        setCloserUserName = mapOpportunityIdAndSetCloserUserName.get(relatedOpportunityTeamMember.OpportunityId);
                    }
                    setCloserUserName.add(relatedOpportunityTeamMember.User.Name);
                    mapOpportunityIdAndSetCloserUserName.put(relatedOpportunityTeamMember.OpportunityId, setCloserUserName);
                }
                if(relatedOpportunityTeamMember.TeamMemberRole == 'Credit Analyst')
                {                    
                    List<Id> listCreditAnalystUserRoleId = new List<Id>();
                    if(mapOpportunityIdAndListCreditAnalystUserRoleId.containsKey(relatedOpportunityTeamMember.OpportunityId))
                    {
                        listCreditAnalystUserRoleId = mapOpportunityIdAndListCreditAnalystUserRoleId.get(relatedOpportunityTeamMember.OpportunityId);
                    }
                    listCreditAnalystUserRoleId.add(relatedOpportunityTeamMember.User.UserRoleId);
                    mapOpportunityIdAndListCreditAnalystUserRoleId.put(relatedOpportunityTeamMember.OpportunityId, listCreditAnalystUserRoleId);

                    List<Id> listCreditAnalystUserId = new List<Id>();
                    if(mapOpportunityIdAndListCreditAnalystUserId.containsKey(relatedOpportunityTeamMember.OpportunityId))
                    {
                        listCreditAnalystUserId = mapOpportunityIdAndListCreditAnalystUserId.get(relatedOpportunityTeamMember.OpportunityId);
                    }
                    listCreditAnalystUserId.add(relatedOpportunityTeamMember.UserId);
                    mapOpportunityIdAndListCreditAnalystUserId.put(relatedOpportunityTeamMember.OpportunityId, listCreditAnalystUserId);

                    Set<String> setCreditAnalystUserName = new Set<String>();
                    if(mapOpportunityIdAndSetCreditAnalystUserName.containsKey(relatedOpportunityTeamMember.OpportunityId))
                    {
                        setCreditAnalystUserName = mapOpportunityIdAndSetCreditAnalystUserName.get(relatedOpportunityTeamMember.OpportunityId);
                    }
                    setCreditAnalystUserName.add(relatedOpportunityTeamMember.User.Name);
                    mapOpportunityIdAndSetCreditAnalystUserName.put(relatedOpportunityTeamMember.OpportunityId, setCreditAnalystUserName);
                }
            }
        }

        if(!setRelatedOpportunityId.isEmpty())
        {
            Map<Id, Opportunity> mapRelatedOpportunityIdAndOpportunity = GetRelatedOpportunityData(setRelatedOpportunityId);
            
            if(!mapRelatedOpportunityIdAndOpportunity.isEmpty())
            {
                //Go through TM Logic     
                List<WT_OpportunityUtility.OpportunityTMEligibileToCheckModel> listOpportunityToCheck = new List<WT_OpportunityUtility.OpportunityTMEligibileToCheckModel>(); 
                for(Id relatedOpportunityId : mapRelatedOpportunityIdAndOpportunity.keySet())
                {
                    Opportunity relatedOpportunityToCheck = mapRelatedOpportunityIdAndOpportunity.get(relatedOpportunityId);
                    WT_OpportunityUtility.OpportunityTMEligibileToCheckModel opportunityToCheckModel = new WT_OpportunityUtility.OpportunityTMEligibileToCheckModel();
                    opportunityToCheckModel.OpportunityId = relatedOpportunityToCheck.Id;
                    opportunityToCheckModel.OppportunityOwnerId = relatedOpportunityToCheck.OwnerId;
                    opportunityToCheckModel.OpportunityRecordTypeId = relatedOpportunityToCheck.RecordTypeId;
                    opportunityToCheckModel.OpportunityOwnerLineOfBusiness = relatedOpportunityToCheck.Owner.WT_Line_of_Business__c;
                    opportunityToCheckModel.OpportunityFee = relatedOpportunityToCheck.WT_Fee__c;
                    opportunityToCheckModel.OpportunityProductName = relatedOpportunityToCheck.WT_Product__r.Name;

                    listOpportunityToCheck.add(opportunityToCheckModel);
                }              
                
                Map<Id, Boolean> mapOpportunityIdAndIsOpportunityTMEligible = WT_OpportunityUtility.GetIsOpportunityTMOnboardingEligible(listOpportunityToCheck, 
                                                                                                                                            mapOpportunityIdAndListOpportunityTeamMember,
                                                                                                                                            listProduct);

                for(Id relatedOpportunityId : mapRelatedOpportunityIdAndOpportunity.keySet())
                {
                    Opportunity relatedOpportunity = mapRelatedOpportunityIdAndOpportunity.get(relatedOpportunityId);

                    List<Id> listUserRoleId = mapOpportunityIdAndListUserRoleId.get(relatedOpportunity.Id);
                    ParentRoleModel sharedCreditParentRoleModel = GetListParentRoleId(listUserRoleId, mapUserRoleIdAndUserRole);
                    
                    if(!sharedCreditParentRoleModel.SetParentRoleId.isEmpty())
                    {
                        relatedOpportunity.WT_Shared_Credit_User_Managers__c = String.join(new List<Id>(sharedCreditParentRoleModel.SetParentRoleId), ',');
                    }
                    else 
                    {
                        relatedOpportunity.WT_Shared_Credit_User_Managers__c = null;    
                    }

                    List<Id> listProcessorUserRoleId = mapOpportunityIdAndListProcessorUserRoleId.get(relatedOpportunity.Id);
                    ParentRoleModel processorParentRoleModel = GetListParentRoleId(listProcessorUserRoleId, mapUserRoleIdAndUserRole);
                    
                    if(!processorParentRoleModel.SetParentRoleId.isEmpty())
                    {
                        relatedOpportunity.WT_Processor_Manager_User_Role_Ids__c = String.join(new List<Id>(processorParentRoleModel.SetParentRoleId), ',');
                    }
                    else 
                    {
                        relatedOpportunity.WT_Processor_Manager_User_Role_Ids__c = null;    
                    }

                    List<Id> listCloserUserRoleId = mapOpportunityIdAndListCloserUserRoleId.get(relatedOpportunity.Id);
                    ParentRoleModel closerParentRoleModel = GetListParentRoleId(listCloserUserRoleId, mapUserRoleIdAndUserRole);
                    
                    if(!closerParentRoleModel.SetParentRoleId.isEmpty())
                    {
                        relatedOpportunity.WT_Closer_Manager_User_Role_Ids__c = String.join(new List<Id>(closerParentRoleModel.SetParentRoleId), ',');
                    }
                    else 
                    {
                        relatedOpportunity.WT_Closer_Manager_User_Role_Ids__c = null;    
                    }

                    List<Id> listCreditAnalystUserRoleId = mapOpportunityIdAndListCreditAnalystUserRoleId.get(relatedOpportunity.Id);
                    ParentRoleModel creditAnalystParentRoleModel = GetListParentRoleId(listCreditAnalystUserRoleId, mapUserRoleIdAndUserRole);
                    
                    if(!creditAnalystParentRoleModel.SetParentRoleId.isEmpty())
                    {
                        relatedOpportunity.WT_Credit_Analyst_Manager_User_Role_Ids__c = String.join(new List<Id>(creditAnalystParentRoleModel.SetParentRoleId), ',');
                    }
                    else 
                    {
                        relatedOpportunity.WT_Credit_Analyst_Manager_User_Role_Ids__c = null;    
                    }
                    
                    if(mapOpportunityIdAndListSharedCreditUserId.containsKey(relatedOpportunity.Id))
                    {
                        relatedOpportunity.WT_Shared_Credit_Users__c = String.join(mapOpportunityIdAndListSharedCreditUserId.get(relatedOpportunity.Id), ',');  
                    }
                    else
                    {
                        relatedOpportunity.WT_Shared_Credit_Users__c = null;
                    }

                    if(mapOpportunityIdAndListProductPartnerUserId.containsKey(relatedOpportunity.Id))
                    {
                        relatedOpportunity.WT_Product_Partners__c = String.join(mapOpportunityIdAndListProductPartnerUserId.get(relatedOpportunity.Id), ',');
                        relatedOpportunity.WT_Product_Partner_Name__c = String.join(new List<String>(mapOpportunityIdAndSetProductPartnerUserName.get(relatedOpportunity.Id)), ', ');
                    }
                    else
                    {
                        relatedOpportunity.WT_Product_Partners__c = null;
                        relatedOpportunity.WT_Product_Partner_Name__c = null;
                    }

                    if(mapOpportunityIdAndListProcessorUserId.containsKey(relatedOpportunity.Id))
                    {
                        relatedOpportunity.WT_Processor_User_Ids__c = String.join(mapOpportunityIdAndListProcessorUserId.get(relatedOpportunity.Id), ',');
                        relatedOpportunity.WT_Processor_Name__c = String.join(new List<String>(mapOpportunityIdAndSetProcessorUserName.get(relatedOpportunity.Id)), ', ');
                    }
                    else
                    {
                        relatedOpportunity.WT_Processor_User_Ids__c = null;
                        relatedOpportunity.WT_Processor_Name__c = null;
                    }

                    if(mapOpportunityIdAndListCloserUserId.containsKey(relatedOpportunity.Id))
                    {
                        relatedOpportunity.WT_Closer_User_Ids__c = String.join(mapOpportunityIdAndListCloserUserId.get(relatedOpportunity.Id), ',');
                        relatedOpportunity.WT_Closer_Name__c = String.join(new List<String>(mapOpportunityIdAndSetCloserUserName.get(relatedOpportunity.Id)), ', ');
                    }
                    else
                    {
                        relatedOpportunity.WT_Closer_User_Ids__c = null;
                        relatedOpportunity.WT_Closer_Name__c = null;
                    }

                    if(mapOpportunityIdAndListCreditAnalystUserId.containsKey(relatedOpportunity.Id))
                    {
                        relatedOpportunity.WT_Credit_Analyst_User_Ids__c = String.join(mapOpportunityIdAndListCreditAnalystUserId.get(relatedOpportunity.Id), ',');
                        relatedOpportunity.WT_Credit_Analyst_Name__c = String.join(new List<String>(mapOpportunityIdAndSetCreditAnalystUserName.get(relatedOpportunity.Id)), ', ');
                    }
                    else
                    {
                        relatedOpportunity.WT_Credit_Analyst_User_Ids__c = null;
                        relatedOpportunity.WT_Credit_Analyst_Name__c = null;
                    }

                    if(mapOpportunityIdAndIsOpportunityTMEligible.containsKey(relatedOpportunity.Id))
                    {
                        relatedOpportunity.WT_TMOnboarding_Eligible__c = mapOpportunityIdAndIsOpportunityTMEligible.get(relatedOpportunity.Id);
                    }

                    listOpportunityToUpdate.add(relatedOpportunity);
                }
            }
        }

        if(!listOpportunityToUpdate.isEmpty())
        {
            TriggerHandler.bypass('WT_OpportunityBeforeHandler');
            TriggerHandler.bypass('WT_OpportunityAfterHandler');
            update listOpportunityToUpdate;
            TriggerHandler.clearAllBypasses();
        }

        if(!listOpportunityTeamMemberToInsert.isEmpty())
        {
            insert listOpportunityTeamMemberToInsert;
        }
    }    

    public static ParentRoleModel GetListParentRoleId(List<Id> listRoleId, Map<Id, UserRole> mapUserRoleIdAndUserRole) 
    {
        ParentRoleModel returnModel = new ParentRoleModel();
        Set<Id> setParentRoleId = new Set<Id>();
        Id immediateParentRoleId = null;
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
                    if(String.isBlank(immediateParentRoleId))
                    {
                        immediateParentRoleId = parentRoleId;
                    }
                    
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

        returnModel.SetParentRoleId = setParentRoleId;
        returnModel.ImmediateParentRoleId = immediateParentRoleId;
        return returnModel;
    }

    public class ParentRoleModel
    {
        public Set<Id> SetParentRoleId;
        public Id ImmediateParentRoleId;
    }
}