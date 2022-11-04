public class WT_OpportunityAfterRequiredHandler extends TriggerHandler
{
    private List<Opportunity> listNewOpportunity = new List<Opportunity>();
    private Map<Id, Opportunity> mapNewOpportunityIdandOpportunity = new Map<Id, Opportunity>();
    private Map<Id, Opportunity> mapOldOpportunityIdandOpportunity = new Map<Id, Opportunity>();
    public WT_OpportunityAfterRequiredHandler()
    {              
        PopulateGlobalLists();        
    }
    public override void afterInsert()
    {
        CreateOpportunityTeamMember();     
        CreateOpporunityStageTimeTracking();
    }    
    public override void afterUpdate()
    {
        UpdateOpportunityTeamMemberOnOwnerChange();
        UpdateOpportunityStageTimeTracking();
    } 
    private void PopulateGlobalLists()
    {        
        listNewOpportunity = (List<Opportunity>)Trigger.new;
        mapNewOpportunityIdandOpportunity = (Map<Id, Opportunity>)Trigger.newMap;
        mapOldOpportunityIdandOpportunity = (Map<Id, Opportunity>)Trigger.oldMap;
    }

    private void CreateOpportunityTeamMember()
    {
        Id opportunityTMRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('WT_TM').getRecordTypeId();
        Id opportunityLeasingRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('WT_Leasing').getRecordTypeId();
        Id opportunityInternationalRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('WT_International').getRecordTypeId();
        Id opportunityInvestmentRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('WT_Investment').getRecordTypeId();
        List<Id> listOpportunityRecordTypeIdToCheck = new List<Id>();
        listOpportunityRecordTypeIdToCheck.add(opportunityTMRecordTypeId);
        listOpportunityRecordTypeIdToCheck.add(opportunityLeasingRecordTypeId);
        listOpportunityRecordTypeIdToCheck.add(opportunityInternationalRecordTypeId);
        listOpportunityRecordTypeIdToCheck.add(opportunityInvestmentRecordTypeId);

        List<OpportunityTeamMember> listOpportunityTeamMemberToInsert = new List<OpportunityTeamMember>();
        for(Opportunity newOpportunity : listNewOpportunity)
        {
            OpportunityTeamMember newOpportunityTeamMember = new OpportunityTeamMember();
            newOpportunityTeamMember.OpportunityId = newOpportunity.Id;
            newOpportunityTeamMember.OpportunityAccessLevel = 'Edit';
            newOpportunityTeamMember.UserId = newOpportunity.OwnerId;
            newOpportunityTeamMember.TeamMemberRole = 'Opportunity Owner';
            listOpportunityTeamMemberToInsert.add(newOpportunityTeamMember);

            if(listOpportunityRecordTypeIdToCheck.contains(newOpportunity.RecordTypeId) && newOpportunity.CreatedById != newOpportunity.OwnerId)
            {
                OpportunityTeamMember newOpportunityProductPartnerTeamMember = new OpportunityTeamMember();
                newOpportunityProductPartnerTeamMember.OpportunityId = newOpportunity.Id;
                newOpportunityProductPartnerTeamMember.OpportunityAccessLevel = 'Edit';
                newOpportunityProductPartnerTeamMember.UserId = newOpportunity.CreatedById;
                newOpportunityProductPartnerTeamMember.TeamMemberRole = 'Product Partner';
                listOpportunityTeamMemberToInsert.add(newOpportunityProductPartnerTeamMember);
            }
        }

        if(!listOpportunityTeamMemberToInsert.isEmpty())
        {
            insert listOpportunityTeamMemberToInsert;
        }
    }

    //Update the Opportunity Team Member when the Owner of the Opportunity changes
    //Grab any opportunity team member record that has the user Id of the new Owner and Team Role = Share Credit
    //Then update the team member role to Opportunity Owner
   private void UpdateOpportunityTeamMemberOnOwnerChange()
    {
        Map<Id, Id> mapOpportunityIdAndOwnerId = new Map<Id, Id>();
        Set<Id> setOpportunityIdToQueryOpportunityTeamMember = new Set<Id>();
        List<OpportunityTeamMember> listOpportunityTeamMemberToUpdate = new List<OpportunityTeamMember>();
        for(Opportunity updatedOpportunity : listNewOpportunity)
        {            
            Opportunity oldOpportunity = mapOldOpportunityIdandOpportunity.get(updatedOpportunity.Id);
            if(updatedOpportunity.OwnerId != oldOpportunity.OwnerId)
            {
                setOpportunityIdToQueryOpportunityTeamMember.add(updatedOpportunity.Id);
                mapOpportunityIdAndOwnerId.put(updatedOpportunity.Id, updatedOpportunity.OwnerId);
            }
        }

        if(!setOpportunityIdToQueryOpportunityTeamMember.isEmpty())
        {
            for(OpportunityTeamMember relatedOpportunityTeamMember : [SELECT Id,
                                                                        OpportunityId,
                                                                        UserId,
                                                                        TeamMemberRole
                                                                        FROM OpportunityTeamMember
                                                                        WHERE OpportunityId IN :setOpportunityIdToQueryOpportunityTeamMember])
            {
                Id relatedOpportunityOwnerId = mapOpportunityIdAndOwnerId.get(relatedOpportunityTeamMember.OpportunityId);
                if(relatedOpportunityTeamMember.UserId == relatedOpportunityOwnerId && relatedOpportunityTeamMember.TeamMemberRole == 'Share Credit')
                {
                    relatedOpportunityTeamMember.TeamMemberRole = 'Opportunity Owner';
                    listOpportunityTeamMemberToUpdate.add(relatedOpportunityTeamMember);
                }
            }
        }
        if(!listOpportunityTeamMemberToUpdate.isEmpty())
        {
            update listOpportunityTeamMemberToUpdate;
        }
    }  
        //Handle Time Tracking/ Opportunity Stage Tracking 
        //Implemented as part of SGE-1581(Creates a record on Opportunity Stage Tracking object when Opportunity stage is new/updated)
        private void CreateOpporunityStageTimeTracking()
        {
            List<WT_Opportunity_Stage_Tracking__c> listOpportunityStageTrackingToInsert = new List<WT_Opportunity_Stage_Tracking__c>();
            for(Opportunity newOpportunity : listNewOpportunity)
            {
                WT_Opportunity_Stage_Tracking__c timeTrackingRecord  = new WT_Opportunity_Stage_Tracking__c();
                timeTrackingRecord.WT_Date_Started__c = System.now();
                timeTrackingRecord.WT_Previous_Stage__c = newOpportunity.StageName;
                timeTrackingRecord.WT_Modified_User__c = newOpportunity.CreatedById;
                timeTrackingRecord.Name = newOpportunity.StageName;
                timeTrackingRecord.WT_Opportunity__c = newOpportunity.Id;
                listOpportunityStageTrackingToInsert.add(timeTrackingRecord);
            }
            if(!listOpportunityStageTrackingToInsert.isEmpty())
            {
                insert listOpportunityStageTrackingToInsert;
            }
        }
         private void UpdateOpportunityStageTimeTracking()
        {
            List<WT_Opportunity_Stage_Tracking__c> listOpportunityStageTimeTrackingToUpdate = new List<WT_Opportunity_Stage_Tracking__c>();
            Map<String,List<WT_Opportunity_Stage_Tracking__c>> mapOpportunityIdAndListOpportunityStageTracking = new Map<String,List<WT_Opportunity_Stage_Tracking__c>>();
            Set<Id> setOpportunityIds = new Set<Id>();
            for(Opportunity newOpportunity : listNewOpportunity)
            {
                if(newOpportunity.StageName != mapOldOpportunityIdandOpportunity.get(newOpportunity.Id).StageName)
                {
                    setOpportunityIds.add(newOpportunity.Id);
                }    
            } 
            for(Opportunity opportunityRecord : [SELECT Id,
                                                        Name, 
                                                        StageName,
                                                        (SELECT Id,
                                                        Name,
                                                        WT_Date_Completed__c,
                                                        WT_Date_Started__c,
                                                        WT_Previous_Stage__c,
                                                        WT_Modified_User__c,
                                                        WT_New_Stage__c,
                                                        WT_Opportunity__c 
                                                        FROM Opportunity_Stage_Trackings__r) 
                                                        FROM Opportunity WHERE Id IN :setOpportunityIds])  //store opty Ids     
            {   
                mapOpportunityIdAndListOpportunityStageTracking.put(opportunityRecord.Id,opportunityRecord.Opportunity_Stage_Trackings__r);
            }
            for(String opportunityRecordId : mapOpportunityIdAndListOpportunityStageTracking.keySet())
            {
                for(WT_Opportunity_Stage_Tracking__c timeTrackingRecord : mapOpportunityIdAndListOpportunityStageTracking.get(opportunityRecordId))
                {
                    if(mapOldOpportunityIdandOpportunity.get(opportunityRecordId).StageName == timeTrackingRecord.WT_Previous_Stage__c)
                    {
                        timeTrackingRecord.WT_Date_Completed__c = System.now();
                        timeTrackingRecord.WT_New_Stage__c  = mapNewOpportunityIdandOpportunity.get(opportunityRecordId).StageName;
                        listOpportunityStageTimeTrackingToUpdate.add(timeTrackingRecord);  
                    }
                }   
            }
            if(!listOpportunityStageTimeTrackingToUpdate.isEmpty())
            {
                update listOpportunityStageTimeTrackingToUpdate;
                List<WT_Opportunity_Stage_Tracking__c> listOpportunityStageTrackingToUpdate = new List<WT_Opportunity_Stage_Tracking__c>();
                for(String opportunityId : mapOpportunityIdAndListOpportunityStageTracking.keySet())
                {
                    Opportunity newOpportunityRecord  =  mapNewOpportunityIdandOpportunity.get(opportunityId);
                    WT_Opportunity_Stage_Tracking__c timeTrackingRecord  = new WT_Opportunity_Stage_Tracking__c();
                    timeTrackingRecord.WT_Date_Started__c = System.now();
                    timeTrackingRecord.WT_Previous_Stage__c = newOpportunityRecord.StageName;
                    timeTrackingRecord.WT_Modified_User__c = newOpportunityRecord.LastModifiedById;
                    timeTrackingRecord.Name = newOpportunityRecord.StageName;
                    timeTrackingRecord.WT_Opportunity__c = newOpportunityRecord.Id;
                    listOpportunityStageTrackingToUpdate.add(timeTrackingRecord);
                }           
                if(!listOpportunityStageTrackingToUpdate.isEmpty())
                {
                    insert listOpportunityStageTrackingToUpdate;
                }
            }
        }
}