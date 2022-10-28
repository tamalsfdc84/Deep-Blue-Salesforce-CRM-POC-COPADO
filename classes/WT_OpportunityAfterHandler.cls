/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name				WT_OpportunityAfterHandler
* @Author			Vamsi Pulikallu 	<vpulikal@wintrust.com>	
* @ModifiedBy		Vamsi Pulikallu 	<vpulikal@wintrust.com>	
* @version 			v1.0 
* @CreatedDate		22 Feb 2021
* @UsedBy			trigger:  WT_OpportunityTrigger
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* this is used by trigger WT_OpportunityTrigger 
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Changes
* vx.x				<user id>
* MM-DD-YYYY		<Explanation> 
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
// Test class: WT_OpportunityAfterHandler_T
public class WT_OpportunityAfterHandler extends TriggerHandler
{
    public static integer tmOnboardingEligible =0;
    private List<Opportunity> listNewOpportunity = new List<Opportunity>();
    private Map<Id, Opportunity> mapNewOpportunityIdandOpportunity = new Map<Id, Opportunity>();
    private Map<Id, Opportunity> mapOldOpportunityIdandOpportunity = new Map<Id, Opportunity>();
    public WT_OpportunityAfterHandler()
    {              
        PopulateGlobalLists();        
    }
    public override void afterInsert()
    {
        if(tmOnboardingEligible == 0)
        {
            populateTMOnboardingEligibleField(listNewOpportunity);
        }
    }    
    public override void afterUpdate()
    {
        setOpportunityTeamRoleOnUpdate(listNewOpportunity, mapOldOpportunityIdandOpportunity);
        if(tmOnboardingEligible == 0)
        {
            populateTMOnboardingEligibleField(listNewOpportunity);
        }
        SendNotificationOnStageChange();
    } 
    private void PopulateGlobalLists()
    {        
        listNewOpportunity = (List<Opportunity>) Trigger.new;
        mapNewOpportunityIdandOpportunity = (Map<Id, Opportunity>) Trigger.newMap;
        mapOldOpportunityIdandOpportunity = (Map<Id, Opportunity>) Trigger.oldMap;
    }

    private void SendNotificationOnStageChange()
    {
        Map<Id, String> mapOpportunityIdAndRoleToNotify = new Map<Id, String>();        
        Set<String> setStageToNotify = new Set<String>
        {
            '3. Opportunity Sent For Processing',
            '6. Opportunity In Underwriting',
            '8. Opportunity In Pre-Close',
            '12. Loan Lost/Denied'
        };

        for(Opportunity updatedOpportunity : listNewOpportunity)
        {
            Opportunity oldOpportunity = mapOldOpportunityIdandOpportunity.get(updatedOpportunity.Id);

            if(setStageToNotify.contains(updatedOpportunity.StageName) && updatedOpportunity.StageName != oldOpportunity.StageName)
            {
                String opportunityRole = '';

                switch on updatedOpportunity.StageName
                {
                    when '3. Opportunity Sent For Processing'
                    {
                        opportunityRole = 'Processing';
                    }
                    when '6. Opportunity In Underwriting'
                    {
                        opportunityRole = 'Underwriting';
                    }
                    when '8. Opportunity In Pre-Close'
                    {
                        opportunityRole = 'Closing';
                    }
                    when '12. Loan Lost/Denied'
                    {
                        opportunityRole = 'DeniedProcessing';
                    }
                }
                mapOpportunityIdAndRoleToNotify.put(updatedOpportunity.Id, opportunityRole);
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
* This method opportunity Team member records when the opportunity owner is changes given the 'keep opportunity Team' check box is checked.
* --------------------------------------------------------------------------------------------------------------
* @Param  listNewOpportunity    List of Opportunity records
* @Param mapOldOpportunityIdandOpportunity  map of OportunityId and opporunity (old trigger data)
* @Return void           Returns none
* --------------------------------------------------------------------------------------------------------------
**/
    public static void  setOpportunityTeamRoleOnUpdate(List<Opportunity> listNewOpportunity, Map<id, Opportunity> mapOldOpportunityIdandOpportunity)
    {
        List<OpportunityTeamMember> listOpportunityTeamdelete = new List<OpportunityTeamMember>();
        set<id> opportunityIDSet = new set<id>();
        for(Opportunity opp : listNewOpportunity)
        {
            if(opp.OwnerId != mapOldOpportunityIdandOpportunity.get(opp.Id).OwnerID)
            {
                opportunityIDSet.add(opp.Id);
            }
        }
         List<OpportunityTeamMember> OpportunityTeamMemberListDelete = [select id ,opportunity.recordType.developerName, UserID, TeamMemberRole, OpportunityID, opportunity.OwnerID, Opportunity.createdByID
                                                                        from OpportunityTeamMember 
                                                                   		where opportunityID IN:opportunityIDSet and TeamMemberRole ='Opportunity Owner'];
        for(OpportunityTeamMember otm:OpportunityTeamMemberListDelete)
        {
            if(otm.userID != otm.opportunity.OwnerID)
            {
                listOpportunityTeamdelete.add(otm);
            }            
        }
        delete listOpportunityTeamdelete;
    }
    
    /**
* --------------------------------------------------------------------------------------------------------------
* @Description
* This method is used to Update the TM Onboarding Eligible field value on Opportunity based on certain criteria.
*
* --------------------------------------------------------------------------------------------------------------
* @Param  - listNewOpportunity    - List of Insert Opportunity Records
* @Param  - mapOldOpportunityIdandOpportunity    - List of Old Opportunity Records
* @Return void           Returns none
* --------------------------------------------------------------------------------------------------------------
**/
    public void PopulateTMOnboardingEligibleField(List<Opportunity> listNewOpportunity/*, Map<Id, Opportunity> mapOldOpportunityIdandOpportunity*/)
    {
        Id tmOpportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('WT_TM').getRecordTypeId();
        list<id> listIds = new list<id>();
        for(Opportunity newOpportunity :listNewOpportunity)
        {
            if(newOpportunity.RecordTypeId == tmOpportunityRecordTypeId)
            {
                listIds.add(newOpportunity.Id);
            }
        }
        if(listIds.size()>0)
        {
            if(!System.isFuture() && !System.isBatch())
            {
                updateTMOnboardingField(listIds);
            }
        }
    }
    
    /**
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is a future method is used to Update the TM Onboarding Eligible field value on Opportunity based on certain criteria.
*
* --------------------------------------------------------------------------------------------------------------
* @Param  - listNewOpportunity    - List of Insert Opportunity Records
* @Param  - mapOldOpportunityIdandOpportunity    - List of Old Opportunity Records
* @Return void           Returns none
* --------------------------------------------------------------------------------------------------------------
**/
    @future
    public static void UpdateTMOnboardingField(list<Id> listOpportunityIds)
    {
        if(listOpportunityIds != null && listOpportunityIds.size()>0)
        {
            Id tmOpportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('WT_TM').getRecordTypeId();
            string products = System.label.TM_Onboarding_Eligible_Products;
            List<String> listProducts = products.split(',');
            list<Opportunity> listUpdateOpportunity = new list<Opportunity>();
            list<Opportunity> listOpportunity= new list<Opportunity>();
            Opportunity TMopportunity = new Opportunity();
            listOpportunity = [SELECT Id, WT_Fee__c, WT_TMOnboarding_Eligible__c,Owner.WT_Line_of_Business__c, WT_Product__r.Name from Opportunity 
                               where id IN: listOpportunityIds and recordtypeid=:tmOpportunityRecordTypeId];
            if(listOpportunity != null && listOpportunity.size()>0)
            {
                TMopportunity = listOpportunity[0];                
                if(TMopportunity != null)
                {
                    boolean isTMOnboardingEligibleBefore = false;
                    if(TMopportunity.WT_TMOnboarding_Eligible__c)
                    {
                        isTMOnboardingEligibleBefore = true;
                    }
                    boolean isTMProduct = false;
                    boolean isLOB = false;
                    boolean isProductPartner = false;
                    if(listProducts.contains(TMopportunity.WT_Product__r.Name))
                    {
                        isTMProduct = true;
                    }
                    if((TMopportunity.Owner.WT_Line_of_Business__c =='Middle Market' && TMopportunity.WT_Fee__c >= 10000) ||
                       (TMopportunity.Owner.WT_Line_of_Business__c !='Middle Market' && TMopportunity.WT_Fee__c >= 5000))
                    {
                        isLOB = true;
                    }
                    if(isTMProduct && isLOB)
                    {
                        list<OpportunityTeamMember> listOpportunityTeamMember = [SELECT Id, OpportunityId, UserId,TeamMemberRole, User.WT_Line_of_Business__c FROM OpportunityTeamMember 
                                                                                 WHERE OpportunityId IN: listOpportunityIds AND TeamMemberRole = 'Product Partner' AND User.WT_Line_of_Business__c = 'Treasury Management'];
                        if(listOpportunityTeamMember != null && listOpportunityTeamMember.size()>0)
                        {
                            isProductPartner = true;
                        }
                    }
                    if(isTMProduct && isLOB && isProductPartner)
                    {
                        TMopportunity.WT_TMOnboarding_Eligible__c = true;
                    }
                    else 
                    {
                        TMopportunity.WT_TMOnboarding_Eligible__c = false;                      
                    }
                    ++tmOnboardingEligible;
                    if(TMopportunity.WT_TMOnboarding_Eligible__c != isTMOnboardingEligibleBefore)
                    {
                        update TMopportunity;
                    }                    
                }                
            }
        }        
    }
}