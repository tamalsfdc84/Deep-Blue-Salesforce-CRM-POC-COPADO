public class WT_OpportunityUtility 
{
    public static Id OPPORTUNITY_TM_RECORDTYPE_ID = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('WT_TM').getRecordTypeId();
    public static Map<Id, Boolean> GetIsOpportunityTMOnboardingEligible(List<OpportunityTMEligibileToCheckModel> listOpportunityToCheck,
                                                                        Map<Id, List<OpportunityTeamMember>> mapOpportunityIdAndListRelatedOpportunityTeamMember,
                                                                        List<String> listProduct)
    {
        Map<Id, Boolean> mapOpportunityIdAndIsOpportunityTMEligible = new Map<Id, Boolean>();
        if(listOpportunityToCheck != null && !listOpportunityToCheck.isEmpty())
        {
            for(OpportunityTMEligibileToCheckModel opportunityToCheck : listOpportunityToCheck)
            {
                Boolean isOpportunityTMEligible = false;
                Boolean isOpportunityTMProduct = false;
                Boolean isValidLineOfBusiness = false;
                Boolean isProductPartner = false;
                if(opportunityToCheck.OpportunityRecordTypeId == OPPORTUNITY_TM_RECORDTYPE_ID)
                {
                    if(listProduct.contains(opportunityToCheck.OpportunityProductName))
                    {
                        isOpportunityTMProduct = true;
                    }

                    if((opportunityToCheck.OpportunityOwnerLineOfBusiness == 'Middle Market' && opportunityToCheck.OpportunityFee >= 10000) ||
                        (opportunityToCheck.OpportunityOwnerLineOfBusiness != 'Middle Market' && opportunityToCheck.OpportunityFee >= 5000))
                    {
                        isValidLineOfBusiness = true;   
                    }

                    if(isOpportunityTMProduct && isValidLineOfBusiness)
                    {
                        if(mapOpportunityIdAndListRelatedOpportunityTeamMember != null && 
                            mapOpportunityIdAndListRelatedOpportunityTeamMember.containsKey(opportunityToCheck.OpportunityId))
                        {
                            for(OpportunityTeamMember relatedOpportunityTeamMember : mapOpportunityIdAndListRelatedOpportunityTeamMember.get(opportunityToCheck.OpportunityId))
                            {
                                if(relatedOpportunityTeamMember.User.WT_Line_of_Business__c == 'Treasury Management' &&
                                    relatedOpportunityTeamMember.TeamMemberRole == 'Product Partner')
                                {
                                    isProductPartner = true;
                                }
                            }
                        }

                        if(isProductPartner)
                        {
                            isOpportunityTMEligible = true;
                        }
                    }
                }
                mapOpportunityIdAndIsOpportunityTMEligible.put(opportunityToCheck.OpportunityId, isOpportunityTMEligible);
            }          
        }

        return mapOpportunityIdAndIsOpportunityTMEligible;
    }

    public class OpportunityTMEligibileToCheckModel
    {
        public Id OpportunityId;
        public Id OppportunityOwnerId;
        public Id OpportunityRecordTypeId;
        public String OpportunityOwnerLineOfBusiness;
        public double OpportunityFee;
        public String OpportunityProductName;
    }
}