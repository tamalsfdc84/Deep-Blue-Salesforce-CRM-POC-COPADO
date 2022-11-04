public with sharing class WT_BlockedUserAutoProvisionController 
{
    @AuraEnabled(cacheable=true)
    public static CurrentLicenseUsageResponseModel GetLicenseUsageData()
    {
        CurrentLicenseUsageResponseModel returnModel = new CurrentLicenseUsageResponseModel();
        Set<String> setProfileNameToImplementBlockFor = new Set<String>();        
        for(WT_Profile_License_Configuration__mdt profileLicenseConfig : WT_Profile_License_Configuration__mdt.getAll().values())
        {
            setProfileNameToImplementBlockFor.add(profileLicenseConfig.WT_Profile_Name__c);
        }
        
        //Get map of UserLicense Id and UserLicense which would provide information for the current License usage
        Map<Id, UserLicense> mapUserLicenseIdAndUserLicense = new Map<Id, UserLicense>([SELECT Id, 
                                                                                        MasterLabel, 
                                                                                        Name, 
                                                                                        Status, 
                                                                                        TotalLicenses, 
                                                                                        UsedLicenses	
                                                                                        FROM UserLicense]);
        
        //Get current active users by Profile
        List<ProfileLicenseUsageResponseModel> listProfileLicenseUsageResponseModel = new List<ProfileLicenseUsageResponseModel>();
        List<AggregateResult> listUserByProfile = [SELECT Profile.Name, COUNT(Id)
                                                   FROM User
                                                   WHERE IsActive = true
                                                   GROUP BY Profile.Name];
        for(AggregateResult profileCountResult : listUserByProfile)
        {
            String profileName = String.valueOf(profileCountResult.get('Name'));
            
            if(setProfileNameToImplementBlockFor.contains(profileName))
            {
                ProfileLicenseUsageResponseModel profileLicenseUsage = new ProfileLicenseUsageResponseModel();
                Integer totalActiveCount = profileCountResult.get('expr0') != null ? Integer.valueOf(String.valueOf(profileCountResult.get('expr0'))) : 0;
                profileLicenseUsage.ProfileName = profileName;
                profileLicenseUsage.CountActiveUser = totalActiveCount;
                
                listProfileLicenseUsageResponseModel.add(profileLicenseUsage);
            }
        }
        
        for(Id userLicenseId : mapUserLicenseIdAndUserLicense.keySet())
        {            
            UserLicense relatedUserLicense = mapUserLicenseIdAndUserLicense.get(userLicenseId);
            if(relatedUserLicense.Name == 'Salesforce')
            {
                returnModel.CountUsedSalesforceLicenseUser = relatedUserLicense.UsedLicenses;
            }
            else if(relatedUserLicense.Name == 'Salesforce Platform')
            {
                returnModel.CountUsedSalesforcePlatformLicenseUser = relatedUserLicense.UsedLicenses;
            }
        }
        
        returnModel.ListProfileLicenseUsageResponseModel = listProfileLicenseUsageResponseModel;
        System.debug('returnModel: ' + returnModel);
        return returnModel;
    }
    
    @AuraEnabled
    public static List<BlockedUserResponseModel> GetBlockedUserData()
    {
        List<BlockedUserResponseModel> listResponseModel = new List<BlockedUserResponseModel>();
        for(WT_Auto_Provisioned_Blocked_User__c blockedUser : [SELECT Id,
                                                               WT_User__c,
                                                               WT_User__r.Email,
                                                               WT_User__r.Name,
                                                               WT_User__r.Profile.Name,
                                                               WT_User__r.Profile.UserLicense.Name,
                                                               WT_Date_Blocked__c
                                                               FROM WT_Auto_Provisioned_Blocked_User__c
                                                               WHERE WT_Date_Released__c = null
                                                               ORDER BY WT_Date_Blocked__c])
        {
            BlockedUserResponseModel newBlockedUserResponseModel = new BlockedUserResponseModel();
            newBlockedUserResponseModel.AutoProvisionedBlockedUserId = blockedUser.Id;
            newBlockedUserResponseModel.UserFullName = blockedUser.WT_User__r.Name;
            newBlockedUserResponseModel.DateBlocked = blockedUser.WT_Date_Blocked__c;
            newBlockedUserResponseModel.UserProfileName = blockedUser.WT_User__r.Profile.Name;
            newBlockedUserResponseModel.UserLicenseName = blockedUser.WT_User__r.Profile.UserLicense.Name;
            newBlockedUserResponseModel.UserEmail = blockedUser.WT_User__r.Email;
            
            listResponseModel.add(newBlockedUserResponseModel);
        }
        
        return listResponseModel;
    }
    
    @AuraEnabled
    public static Boolean ReleaseBlockedUser(Id autoProvisionedBlockedUserId)
    {
        List<WT_Block_User_Auto_Provision__e> listBlockedPlatformEvent = new List<WT_Block_User_Auto_Provision__e>();
        Boolean result = false;
        WT_Auto_Provisioned_Blocked_User__c blockedUser = [SELECT Id,
                                                           WT_User__c,
                                                           WT_Released_By_User__c,
                                                           WT_Date_Released__c
                                                           FROM WT_Auto_Provisioned_Blocked_User__c
                                                           WHERE Id = :autoProvisionedBlockedUserId
                                                           LIMIT 1];
        
        if(blockedUser != null)
        {
            blockedUser.WT_Released_By_User__c = UserInfo.getUserId();
            blockedUser.WT_Date_Released__c = System.now();
            
            try
            {
                update blockedUser;

                WT_Block_User_Auto_Provision__e newBlockEvent = new WT_Block_User_Auto_Provision__e();
                newBlockEvent.WT_Blocked_User_Id__c = blockedUser.WT_User__c;
                newBlockEvent.WT_Should_Deactivate_User__c = false;
                listBlockedPlatformEvent.add(newBlockEvent);

                result = true;
            }
            catch(Exception ex)
            {
                
            }
        }

        if(!listBlockedPlatformEvent.isEmpty())
        {
            EventBus.publish(listBlockedPlatformEvent);
        }
        
        return result;
    }
    
    public class CurrentLicenseUsageResponseModel
    {
        @AuraEnabled public Integer CountUsedSalesforceLicenseUser;
        @AuraEnabled public Integer CountUsedSalesforcePlatformLicenseUser;
        @AuraEnabled public List<ProfileLicenseUsageResponseModel> ListProfileLicenseUsageResponseModel;
    }
    
    public class ProfileLicenseUsageResponseModel
    {
        @AuraEnabled public String ProfileName;
        @AuraEnabled public Integer CountActiveUser;
    }
    
    public class BlockedUserResponseModel
    {
        @AuraEnabled public Id AutoProvisionedBlockedUserId;
        @AuraEnabled public String UserFullName;
        @AuraEnabled public DateTime DateBlocked;
        @AuraEnabled public String UserProfileName;
        @AuraEnabled public String UserLicenseName;
        @AuraEnabled public String UserEmail;
    }
}