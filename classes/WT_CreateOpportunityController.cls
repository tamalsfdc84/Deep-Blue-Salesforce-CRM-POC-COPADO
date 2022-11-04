public without sharing class WT_CreateOpportunityController 
{
    @AuraEnabled
    public static OpportunityMetadataReturnModel GetOpportunityMetadata()
    {
        OpportunityMetadataReturnModel returnModel = new OpportunityMetadataReturnModel();
        List<CustomPicklistModel> listValidProduct = new List<CustomPicklistModel>();
        Map<String, Id> mapProductIdAndOpportunityRecordTypeId = new Map<String, Id>();
        Map<Id, String> mapOpportunityRecordTypeIdAndRecordTypeName = new Map<Id, String>();
        Boolean isEasyAccessPilotUser = false;

        //Check if the current running user is a pilot user for Easy Access Loans
        Set<String> setPilotUserRoleDeveloperName = new Set<String>();
        for(WT_Easy_Access_Loan_Pilot_Group__mdt pilotUserRole : WT_Easy_Access_Loan_Pilot_Group__mdt.getAll().values())
        {
            setPilotUserRoleDeveloperName.add(pilotUserRole.WT_User_Role_Developer_Name__c);
        }

        Id currentRunningUserRoleId = UserInfo.getUserRoleId();
        String currentRunningUserRoleDeveloperName = '';
        if(currentRunningUserRoleId != null)
        {
            currentRunningUserRoleDeveloperName = [SELECT Id,
                                                    DeveloperName
                                                    FROM UserRole
                                                    WHERE Id = :currentRunningUserRoleId].DeveloperName; 

            if(setPilotUserRoleDeveloperName.contains(currentRunningUserRoleDeveloperName))
            {
                isEasyAccessPilotUser = true;
            }
        }
        
        //Get the opportunity RecordTypes
        Map<String, Schema.RecordTypeInfo> mapOpportunityRecordTypeNameAndRecordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName();
        Map<String, Id> mapOpportunityRecordTypeNameAndId = new Map<String, Id>();
        for(Schema.RecordTypeInfo opportunityRecordType : mapOpportunityRecordTypeNameAndRecordType.values())
        {
            mapOpportunityRecordTypeNameAndId.put(opportunityRecordType.getName(), opportunityRecordType.getRecordTypeId());
            mapOpportunityRecordTypeIdAndRecordTypeName.put(opportunityRecordType.getRecordTypeId(), opportunityRecordType.getName());
        }

        for(Product2 activeProduct : [SELECT Id,
                                        Name,
                                        IsActive,
                                        WT_Is_Easy_Access_Pilot_Product__c,
                                        WT_Should_Exclude_For_Easy_Access_Pilot__c,
                                        Family
                                        FROM Product2
                                        WHERE IsActive = true
                                        ORDER BY Name])
        {
            if(isEasyAccessPilotUser)
            {
                if(!activeProduct.WT_Should_Exclude_For_Easy_Access_Pilot__c)
                {
                    listValidProduct.add(new CustomPicklistModel(activeProduct.Id, activeProduct.Name));
                    mapProductIdAndOpportunityRecordTypeId.put(activeProduct.Id, mapOpportunityRecordTypeNameAndId.get(activeProduct.Family));
                }
            }
            else
            {
                if(!activeProduct.WT_Is_Easy_Access_Pilot_Product__c)
                {
                    listValidProduct.add(new CustomPicklistModel(activeProduct.Id, activeProduct.Name));
                    mapProductIdAndOpportunityRecordTypeId.put(activeProduct.Id, mapOpportunityRecordTypeNameAndId.get(activeProduct.Family));
                }
            }
        }

        returnModel.ListProduct = listValidProduct;
        returnModel.MapProductIdAndOpportunityRecordTypeId = mapProductIdAndOpportunityRecordTypeId;
        returnModel.IsEasyAccessPilotUser = isEasyAccessPilotUser;
        returnModel.CurrentRunningUserId = UserInfo.getUserId();
        returnModel.MapOpportunityRecordTypeIdAndRecordTypeName = mapOpportunityRecordTypeIdAndRecordTypeName;
        returnModel.CurrentRunningUserProfileName = [SELECT Name
                                                    FROM Profile
                                                    WHERE Id = :UserInfo.getProfileId()].Name;
        return returnModel;
    }

    public class OpportunityMetadataReturnModel
    {
        @AuraEnabled public List<CustomPicklistModel> ListProduct;
        @AuraEnabled public Map<String, Id> MapProductIdAndOpportunityRecordTypeId;
        @AuraEnabled public Map<Id, String> MapOpportunityRecordTypeIdAndRecordTypeName;
        @AuraEnabled public Boolean IsEasyAccessPilotUser;
        @AuraEnabled public Id CurrentRunningUserId;
        @AuraEnabled public String CurrentRunningUserProfileName;
    }

    public class CustomPicklistModel
    {
        @AuraEnabled public String value;
        @AuraEnabled public String label;

        public CustomPicklistModel(String value, String label)
        {
            this.value = value;
            this.label = label;
        }
    }
}