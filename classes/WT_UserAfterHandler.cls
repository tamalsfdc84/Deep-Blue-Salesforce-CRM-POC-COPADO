/**
* --------------------------------------------------------------------------------------------------------------
* @Name             WT_UserAfterHandler
* @Author           Swaminathan E   <SEzhumal@wintrust.com>
* @ModifiedBy       Swaminathan E   <SEzhumal@wintrust.com>
* @ModifiedBy       Vasavi K        <VKolusu@wintrust.com> 
* @Version          v1.0
* @CreatedDate      12-28-2020
* @UsedBy           User Object
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is handler class for User Object trigger.
* This handles all the before logic of the User Object trigger.
* --------------------------------------------------------------------------------------------------------------
* @Changes
* v2.0
* 02-24-2021
* v2.1
* 02-9-2022/Ticket NO: SGE-116
* --------------------------------------------------------------------------------------------------------------
**/
// Code Coverage: WT_UserAfterHandler_T
public class WT_UserAfterHandler extends TriggerHandler
{
    List<User> listNewUser = new List<User>();
    Map<Id, User> mapOldUserIdAndUser = new Map<Id, User>();    
    Set<Id> setUserIdToBlockFromAutoProvision = new Set<Id>();
    String jsonOldUserMap; 
    String jsonNewUser; 
    
    public WT_UserAfterHandler()
    {
        listNewUser = (List<User>) Trigger.new;
        mapOldUserIdAndUser = (Map<Id, User>) Trigger.oldMap; 
        jsonOldUserMap = json.serialize(mapOldUserIdAndUser); 
        jsonNewUser = json.serialize(listNewUser);  
                
    }
    public override void afterInsert()
    {
        userBranchFactorAdded(listNewUser);
        CheckIfUserShouldBeBlockedFromAutoProvision();
        SendWelcomeEmail(listNewUser, setUserIdToBlockFromAutoProvision);
        //This calling of method assign Public Group based on MM Scorecard Access and CRE Scorecard Access value
        
        AssignPublicGroupBasedOnScorecardAccess(jsonNewUser,jsonOldUserMap); 
    }    
    public override void afterUpdate()
    {
        userBranchFactorUpdated(listNewUser,mapOldUserIdAndUser);
        SendWelcomeEmailForUpdatedUser(listNewUser, mapOldUserIdAndUser, setUserIdToBlockFromAutoProvision);
        //This calling of method assign and delete(if any) assignment of Public Group based on update of MM Scorecard Access and CRE Scorecard Access value
        AssignPublicGroupBasedOnScorecardAccess(jsonNewUser,jsonOldUserMap); 
      
    }
    
    //This method checks to see if a user needs to be blocked from auto-provision based on the current license count in the system
    private void CheckIfUserShouldBeBlockedFromAutoProvision()
    {
        User integrationServiceAccountUser = [SELECT Id,
                                              UserName
                                              FROM User
                                              WHERE Name = 'Integration Service Account'
                                              LIMIT 1];
        
        //Get map of Salesforce License Configuration (WT_Salesforce_License_Configuration__mdt) custom metadata type
        //This custom metadata is the top level container that sets the total limit for a given Salesforce license
        Map<String, WT_Salesforce_License_Configuration__mdt> mapSalesforceLicenseAndSalesforceLicenseConfig = new Map<String, WT_Salesforce_License_Configuration__mdt>();
        for(WT_Salesforce_License_Configuration__mdt licenseConfig : WT_Salesforce_License_Configuration__mdt.getAll().values())
        {
            mapSalesforceLicenseAndSalesforceLicenseConfig.put(licenseConfig.WT_License_Type__c, licenseConfig);
        }
        
        //Get map of Profile License Configuration (WT_Profile_License_Configuration) custom metadata type
        //This custom metadata contains information that sets the total limit for a given Salesforce license per Profile
        Map<String, WT_Profile_License_Configuration__mdt> mapProfileLicenseConfigIdAndProfileLicenseConfig = WT_Profile_License_Configuration__mdt.getAll();
        
        //Get map of Profile Id and Profile which would be used to check which profile and license a given user belongs to
        Map<Id, Profile> mapProfileIdAndProfileName = new Map<Id, Profile>([SELECT Id, 
                                                                            Name, 
                                                                            UserLicenseId,
                                                                            UserLicense.Name
                                                                            FROM Profile]);
        
        //Get map of UserLicense Id and UserLicense which would provide information for the current License usage
        Map<Id, UserLicense> mapUserLicenseIdAndUserLicense = new Map<Id, UserLicense>([SELECT Id, 
                                                                                        MasterLabel, 
                                                                                        Name, 
                                                                                        Status, 
                                                                                        TotalLicenses, 
                                                                                        UsedLicenses    
                                                                                        FROM UserLicense]);
        
        //Get current active users by Profile
        Map<String, Integer> mapProfileNameAndActiveUserCount = new Map<String, Integer>();
        List<AggregateResult> listUserByProfile = [SELECT Profile.Name, COUNT(Id)
                                                   FROM User
                                                   WHERE IsActive = true
                                                   GROUP BY Profile.Name];
        for(AggregateResult profileCountResult : listUserByProfile)
        {
            Integer totalActiveCount = profileCountResult.get('expr0') != null ? Integer.valueOf(String.valueOf(profileCountResult.get('expr0'))) : 0;
            mapProfileNameAndActiveUserCount.put(String.valueOf(profileCountResult.get('Name')), totalActiveCount);
        }
        
        for(User newUser : listNewUser)
        {
            //Check is user is active and created by Integration Service Account user (Sailpoint uses this user to create new users)
            if((newUser.IsActive && newUser.CreatedById == integrationServiceAccountUser.Id) || Test.isRunningTest())
            {
                if(mapProfileIdAndProfileName.containsKey(newUser.ProfileId))
                {
                    Profile currentUserProfile = mapProfileIdAndProfileName.get(newUser.ProfileId);
                    String currentUserLicenseName = currentUserProfile.UserLicense.Name;
                    
                    if(mapSalesforceLicenseAndSalesforceLicenseConfig.containsKey(currentUserLicenseName))
                    {
                        WT_Salesforce_License_Configuration__mdt relatedLicenseConfig = mapSalesforceLicenseAndSalesforceLicenseConfig.get(currentUserLicenseName);
                        Integer currentUsedUserLicenseCount = mapUserLicenseIdAndUserLicense.get(currentUserProfile.UserLicenseId).UsedLicenses;
                        
                        if(relatedLicenseConfig.WT_Count_License_To_Start_Blocking__c != null &&
                           relatedLicenseConfig.WT_Count_License_To_Start_Blocking__c > currentUsedUserLicenseCount)
                        {
                            //Master container License check passed
                            //Check to see if the Profile check passes next
                            WT_Profile_License_Configuration__mdt relatedProfileLicenseConfig = null;
                            for(WT_Profile_License_Configuration__mdt profileConfig : mapProfileLicenseConfigIdAndProfileLicenseConfig.values())
                            {
                                if(profileConfig.WT_Profile_Name__c == currentUserProfile.Name)
                                {
                                    relatedProfileLicenseConfig = profileConfig;
                                    break;
                                }
                            }
                            
                            if(relatedProfileLicenseConfig != null)
                            {
                                if(mapProfileNameAndActiveUserCount.containsKey(relatedProfileLicenseConfig.WT_Profile_Name__c))
                                {
                                    Integer currentProfileActiveUserCount = mapProfileNameAndActiveUserCount.get(relatedProfileLicenseConfig.WT_Profile_Name__c);
                                    if(relatedProfileLicenseConfig.WT_Count_License_To_Start_Blocking__c != null &&
                                       relatedProfileLicenseConfig.WT_Count_License_To_Start_Blocking__c < currentProfileActiveUserCount)
                                    {
                                        //Block the current user from being auto-provisioned
                                        setUserIdToBlockFromAutoProvision.add(newUser.Id);
                                    }
                                }
                            }
                        }
                        else
                        {
                            //Block the current user from being auto-provisioned
                            setUserIdToBlockFromAutoProvision.add(newUser.Id);
                        }
                    }
                }
            }
        }
        
        //Fire a platform event so that deactivation of the user can be done in a new transaction
        //This gets around the Salesforce limitation of not allowing Mixed DML Operation (User object + any standard or custom object)
        if(!setUserIdToBlockFromAutoProvision.isEmpty())
        {
            List<WT_Auto_Provisioned_Blocked_User__c> listAutoProvisionedBlockedUserToInsert = new List<WT_Auto_Provisioned_Blocked_User__c>();
            List<WT_Block_User_Auto_Provision__e> listBlockedPlatformEvent = new List<WT_Block_User_Auto_Provision__e>();
            for(Id blockedUserId : setUserIdToBlockFromAutoProvision)
            {
                WT_Block_User_Auto_Provision__e newBlockEvent = new WT_Block_User_Auto_Provision__e();
                newBlockEvent.WT_Blocked_User_Id__c = blockedUserId;
                newBlockEvent.WT_Should_Deactivate_User__c = true;
                listBlockedPlatformEvent.add(newBlockEvent);
                
                WT_Auto_Provisioned_Blocked_User__c newAutoProvisionedBlockedUser = new WT_Auto_Provisioned_Blocked_User__c();
                newAutoProvisionedBlockedUser.WT_Date_Blocked__c = System.now();
                newAutoProvisionedBlockedUser.WT_User__c = newBlockEvent.WT_Blocked_User_Id__c;
                listAutoProvisionedBlockedUserToInsert.add(newAutoProvisionedBlockedUser);
            }   
            
            if(!listAutoProvisionedBlockedUserToInsert.isEmpty())
            {
                InsertListAutoProvisionAsync(JSON.serialize(listAutoProvisionedBlockedUserToInsert));
            }
            if(!listBlockedPlatformEvent.isEmpty())
            {
                EventBus.publish(listBlockedPlatformEvent);
            }
        }
    }
    
    //This method assign and delete(if any) assignment of Public Group based on MM Scorecard Access and CRE Scorecard Access value
    
    @future 
    private static void AssignPublicGroupBasedOnScorecardAccess(string jsonNewUser,string jsonOldUserMap)
    {    
        set<string> groupName = new set<String>{'MM Scorecard Executive','MM Scorecard Individual','MM Scorecard Manager','CRE Scorecard Manager','CRE Scorecard Individual','CRE Scorecard Executive'};
        Map<string,Id> mapGroupNameWithId = new Map<string,Id>();
        for(Group  g :  [SELECT Id,name  FROM Group where name in :groupName]){
                mapGroupNameWithId.put(g.name,g.Id);
        }
        Map<Id,User> mapOldUserIdUser= (Map<Id,User>)Json.deserialize(jsonOldUserMap,Map<Id,User>.class);
        List<User> userList = (List<User>)Json.deserialize(jsonNewUser,List<User>.class);
        for(User newUser : userList)
        {   
            User oldUser;
            String oldUserMMScorecardAccess;
            String oldUserCREScorecardAccess;
            if(mapOldUserIdUser!=null){
                oldUser = mapOldUserIdUser.get(newUser.Id);
            }
            //Scorecard Access values variable
            String newUserMMScorecardAccess=newUser.WT_MM_Scorecard_Access__c;
            String newUserCREScorecardAccess=newUser.WT_CRE_Scorecard_Access__c;
            
            if(oldUser!=null){
                oldUserMMScorecardAccess=oldUser.WT_MM_Scorecard_Access__c;
                oldUserCREScorecardAccess=oldUser.WT_CRE_Scorecard_Access__c;
            }
            Id groupId;
            Id oldGroupId;
            //Check if the user is active and created by Integration Service Account user (Sailpoint uses this user to create new users)
            if(newUser.IsActive || Test.isRunningTest())
            {
                if(String.isBlank(newUserMMScorecardAccess) || String.isBlank(newUserCREScorecardAccess))
                {
                    if(oldUserMMScorecardAccess=='Executive')
                    {
                        oldGroupId=mapGroupNameWithId.get('MM Scorecard Executive');
                    }
                    else if(oldUserMMScorecardAccess=='Individual')
                    {
                        oldGroupId=mapGroupNameWithId.get('MM Scorecard Individual');
                    }
                    else if(oldUserMMScorecardAccess=='Manager/Team Lead')
                    {
                        oldGroupId=mapGroupNameWithId.get('MM Scorecard Manager');
                    }
                    else if(oldUserCREScorecardAccess=='Executive')
                    {
                        oldGroupId=mapGroupNameWithId.get('CRE Scorecard Executive');
                    }
                    else if(oldUserCREScorecardAccess=='Individual')
                    {
                        oldGroupId=mapGroupNameWithId.get('CRE Scorecard Individual');
                    }
                    else if(oldUserCREScorecardAccess=='Manager/Team Lead')
                    {
                        oldGroupId=mapGroupNameWithId.get('CRE Scorecard Manager');
                    }
                    deleteGroupMember(newUser.Id,oldGroupId);
                }
               
                
                //New User created with MM Scorecard Access not empty
                if(((String.isNotBlank(newUserMMScorecardAccess) && String.isNotEmpty(newUserMMScorecardAccess))
                    &&(String.isBlank(oldUserMMScorecardAccess) || String.isEmpty(oldUserMMScorecardAccess))
                   ) 
                  ) {
                      if(newUserMMScorecardAccess=='Executive')
                      {
                          groupId=mapGroupNameWithId.get('MM Scorecard Executive');
                      }
                      else if(newUserMMScorecardAccess=='Individual')
                      {
                          groupId=mapGroupNameWithId.get('MM Scorecard Individual');
                      }
                      else if(newUserMMScorecardAccess=='Manager/Team Lead')
                      {
                          groupId=mapGroupNameWithId.get('MM Scorecard Manager');
                      }
                      createGroupMember(newUser.Id,groupId);
                  }
                //New User created with CRE Scorecard Access not empty
                if(((String.isNotBlank(newUserCREScorecardAccess) || String.isNotEmpty(newUserCREScorecardAccess))
                    &&(String.isBlank(oldUserCREScorecardAccess) || String.isEmpty(oldUserCREScorecardAccess))
                   )
                  ){
                      if(newUserCREScorecardAccess=='Executive')
                      {
                          groupId=mapGroupNameWithId.get('CRE Scorecard Executive');
                      }
                      else if(newUserCREScorecardAccess=='Individual')
                      {
                          groupId=mapGroupNameWithId.get('CRE Scorecard Individual');
                      }
                      else if(newUserCREScorecardAccess=='Manager/Team Lead')
                      {
                          groupId=mapGroupNameWithId.get('CRE Scorecard Manager');
                      }
                      createGroupMember(newUser.Id,groupId);
                  }
                
                //Old User switched from one MM Scorecard Access to another
                if(((String.isNotBlank(newUserMMScorecardAccess) && String.isNotEmpty(newUserMMScorecardAccess))
                    &&(String.isNotBlank(oldUserMMScorecardAccess) && String.isNotEmpty(oldUserMMScorecardAccess))
                   )){
                           if(newUserMMScorecardAccess=='Executive')
                           {
                               groupId=mapGroupNameWithId.get('MM Scorecard Executive');
                           }
                           else if(newUserMMScorecardAccess=='Individual')
                           {
                               groupId=mapGroupNameWithId.get('MM Scorecard Individual');
                           }
                           else if(newUserMMScorecardAccess=='Manager/Team Lead')
                           {
                               groupId=mapGroupNameWithId.get('MM Scorecard Manager');
                           }
                           
                           if(oldUserMMScorecardAccess=='Executive')
                           {
                            oldGroupId=mapGroupNameWithId.get('CRE Scorecard Executive');
                            }
                           else if(oldUserMMScorecardAccess=='Individual')
                           {
                            oldGroupId=mapGroupNameWithId.get('CRE Scorecard Individual');
                            }
                            else if(oldUserMMScorecardAccess=='Manager/Team Lead')
                           {
                            oldGroupId=mapGroupNameWithId.get('CRE Scorecard Manager');
                            }
                           deleteGroupMember(newUser.Id,oldGroupId);
                            createGroupMember(newUser.Id,groupId);
                       }
                   if((String.isNotBlank(newUserCREScorecardAccess) && String.isNotEmpty(newUserCREScorecardAccess))
                        &&(String.isNotBlank(oldUserCREScorecardAccess) || String.isNotBlank(oldUserCREScorecardAccess))
                       ){  
                         if(newUserCREScorecardAccess=='Executive')
                          {
                              groupId=mapGroupNameWithId.get('CRE Scorecard Executive');
                          }
                          else if(newUserCREScorecardAccess=='Individual')
                          {
                              groupId=mapGroupNameWithId.get('CRE Scorecard Individual');
                          }
                          else if(newUserCREScorecardAccess=='Manager/Team Lead')
                          {
                                  groupId=mapGroupNameWithId.get('CRE Scorecard Manager');
                          }
                          if(oldUserCREScorecardAccess=='Executive')
                          {
                                oldGroupId=mapGroupNameWithId.get('CRE Scorecard Executive');
                          }
                          else if(oldUserCREScorecardAccess=='Individual')
                          {
                                oldGroupId=mapGroupNameWithId.get('CRE Scorecard Individual');
                          }
                          else if(oldUserCREScorecardAccess=='Manager/Team Lead')
                          {
                                oldGroupId=mapGroupNameWithId.get('CRE Scorecard Manager');
                          }
                           deleteGroupMember(newUser.Id,oldGroupId);
                           createGroupMember(newUser.Id,groupId);
                    }
            }
        }
    }
    
    //This method been called from AssignPublicGroupBasedOnScorecardAccess to create Group Member record 
    
    @Testvisible 
    private static void CreateGroupMember(Id userId,Id groupId)
    {
        List<GroupMember> groupMemberList= [Select id from GroupMember where UserOrGroupId=:userId and groupId=:groupId];
        if(groupMemberList.isEmpty() || groupMemberList.size() < 1 || groupMemberList == null ){
            GroupMember grpMember= new GroupMember();
            grpMember.UserOrGroupId=userId;
            grpMember.groupId=groupId;
           try{
            insert grpMember;
           }catch(exception e){
               
           }
        }
    }
    @Testvisible 
    private static void DeleteGroupMember(Id userId,Id oldgroupId){
        List<GroupMember> groupMemberList= [Select id from GroupMember where UserOrGroupId=:userId and groupId =:oldgroupId];
        if(!groupMemberList.isEmpty()){
            
            delete groupMemberList;
        }
    }
    
    @future
    public static void InsertListAutoProvisionAsync(String stringAutoProvisionToInsert)
    {
        List<WT_Auto_Provisioned_Blocked_User__c> listAutoProvisionedBlockedUserToInsert = (List<WT_Auto_Provisioned_Blocked_User__c>)JSON.deserialize(stringAutoProvisionToInsert, List<WT_Auto_Provisioned_Blocked_User__c>.class);
        
        if(!listAutoProvisionedBlockedUserToInsert.isEmpty())
        {
            insert listAutoProvisionedBlockedUserToInsert;
        }
    }
    
    public static void SendWelcomeEmailForUpdatedUser(List<User> listNewUser, Map<Id, User> mapOldUserIdAndUser, Set<Id> setUserIdToBlockFromAutoProvision)
    {
        List<User> listUserToEmail = new List<User>();
        for(User userRecord : listNewUser)
        {
            User oldRecord = null;
            if(mapOldUserIdAndUser.containsKey(userRecord.Id))
            {
                oldRecord = mapOldUserIdAndUser.get(userRecord.Id);
            }            
            
            if(oldRecord != null && userRecord.IsActive && 
               ((userRecord.WT_Date_User_Released_From_Auto_Block__c != null && userRecord.WT_Date_User_Released_From_Auto_Block__c != oldRecord.WT_Date_User_Released_From_Auto_Block__c) ||
                (userRecord.Should_Send_Phase_3_Welcome_Email__c && userRecord.Should_Send_Phase_3_Welcome_Email__c != oldRecord.Should_Send_Phase_3_Welcome_Email__c)))
            {
                listUserToEmail.add(userRecord);
            }
        }
        
        if(!listUserToEmail.isEmpty())
        {
            SendWelcomeEmail(listUserToEmail, setUserIdToBlockFromAutoProvision);
        }
    }
    
    /**
*-----------------------------------------------------------------------------------------------------------------------------
* @description
*This sends the welcome email on any new user creation as long as the user is active.
*-----------------------------------------------------------------------------------------------------------------------------
* @param    listNewUser   This contains list of User Records from beforeInsert Trigger
*-----------------------------------------------------------------------------------------------------------------------------
**/   
    public static void SendWelcomeEmail(List<User> listNewUser, Set<Id> setUserIdToBlockFromAutoProvision)
    {
        List<EmailTemplate> listEmailTemplate = [SELECT Id, Name
                                                 FROM EmailTemplate
                                                 WHERE Name = 'Welcome Email (Internal)'];
        List<Messaging.SingleEmailMessage> listEmailToSend = new List<Messaging.SingleEmailMessage>();
        for(User userRecord : listNewUser)
        {
            if(!setUserIdToBlockFromAutoProvision.contains(userRecord.Id))
            {
                if((String.isNotBlank(userRecord.Email) && userRecord.IsActive == true && listEmailTemplate != null && listEmailTemplate.size() > 0)|| Test.isrunningTest())
                {
                    List<String> listToEmail = new List<String>();
                    listToEmail.add(userRecord.Email);
                    
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setToAddresses(listToEmail);
                    mail.setTemplateId(listEmailTemplate[0].Id);
                    mail.setBccSender(false);
                    mail.setUseSignature(false);
                    mail.setReplyTo('noreply@salesforce.com');
                    mail.setSenderDisplayName('Wintrust Bank');
                    mail.setSaveAsActivity(false); 
                    mail.setTargetObjectId(userRecord.Id);
                    
                    listEmailToSend.add(mail);
                }
            }
        }
        
        if(!listEmailToSend.isEmpty() && !Test.isRunningTest())
        {
            Messaging.sendEmail(listEmailToSend);
        }
    }
    /**
*-----------------------------------------------------------------------------------------------------------------------------
* @description
*This method pass User Id based on Branch# field on User to UpdateBranchFactor.
*-----------------------------------------------------------------------------------------------------------------------------
* @param    listNewUser   This contains list of User Records from beforeInsert Trigger
*-----------------------------------------------------------------------------------------------------------------------------
**/
    public static void userBranchFactorAdded(List<User> listNewUser)
    {        
        Map<Id,String> mapUserRecord = new Map<Id,String>();
        Set<Id> setUserIdDelete = new Set<Id>();
        for(User userRecord : listNewUser)
        {
            if(userRecord.WT_Branch__c != null)
            {
                mapUserRecord.put(userRecord.Id,userRecord.WT_Branch__c);
            }
        }
        updateBranchFactor(mapUserRecord ,setUserIdDelete);      
    }
    /**
*-----------------------------------------------------------------------------------------------------------------------------
* @description
*This method pass User Id based on Branch# field on User to UpdateBranchFactor.
*-----------------------------------------------------------------------------------------------------------------------------
* @param    listNewUser   This contains list of User Records from beforeInsert Trigger
mapOldUserIdAndUser  This contains map of old User Record from beforeInsert Trigger
*-----------------------------------------------------------------------------------------------------------------------------
**/ 
    public static void userBranchFactorUpdated(List<User> listNewUser,Map<Id, User> mapOldUserIdAndUser)
    {        
        Map<Id,String> mapUserRecord = new Map<Id,String>();
        Set<Id> setUserIdDelete = new Set<Id>();
        for(User userRecord : listNewUser)
        {
            if(userRecord.WT_Branch__c != null && mapOldUserIdAndUser.get(userRecord.Id).WT_Branch__c != userRecord.WT_Branch__c)
            {
                mapUserRecord.put(userRecord.Id,userRecord.WT_Branch__c);                     
            }
            else if(userRecord.WT_Branch__c == null && mapOldUserIdAndUser.get(userRecord.Id).WT_Branch__c != userRecord.WT_Branch__c)
            {
                setUserIdDelete.add(userRecord.Id); 
            }
        }
        /* Added as part of SGE-116*/
        if(!System.isBatch() &&  !system.IsFuture()){
            //This will invoke future
            updateBranchFactorAsync(mapUserRecord ,setUserIdDelete);  
        }else{
            //This will invoke non Async method
            updateBranchFactor(mapUserRecord ,setUserIdDelete);
        }
        
    }
    
    public static void updateBranchFactor(Map<Id,String> mapUserRecord , Set<Id> setRemoveBranchFactor)
    {
        updateBranchFactorLogic(mapUserRecord,setRemoveBranchFactor);
    }
    /**
*-----------------------------------------------------------------------------------------------------------------------------
* @description
*This method update User Branch Factor Lookup Object based on Branch# field on User.
*-----------------------------------------------------------------------------------------------------------------------------
* @param    mapUserRecord   This contains map of User Id and Branch# from beforeInsert Trigger
setRemoveBranchFactor  This contains Set of User Id from beforeInsert Trigger
*-----------------------------------------------------------------------------------------------------------------------------
**/ 
    @future
    public static void updateBranchFactorAsync(Map<Id,String> mapUserRecord , Set<Id> setRemoveBranchFactor){
        updateBranchFactorLogic(mapUserRecord,setRemoveBranchFactor);
    }
    
    public static void updateBranchFactorLogic(Map<Id,String> mapUserRecord , Set<Id> setRemoveBranchFactor){
        List<WT_User_Branch_Factor_Lookup__c> listuserBranchFactorRecord = new List<WT_User_Branch_Factor_Lookup__c>();
        Map<String,Id> mapBusinessUnitName = new Map<String,Id>();
        List<WT_User_Branch_Factor_Lookup__c> listUserBranchFactorInsert = new List<WT_User_Branch_Factor_Lookup__c>(); 
        setRemoveBranchFactor.addAll(mapUserRecord.keySet());
        if(!setRemoveBranchFactor.isEmpty()) 
        {
            List<WT_User_Branch_Factor_Lookup__c> listUserBranchFactorDelete = [SELECT Id, WT_User__c FROM WT_User_Branch_Factor_Lookup__c WHERE WT_User__c = :setRemoveBranchFactor];                        
            listUserBranchFactorDelete.addAll(listuserBranchFactorRecord);
            if(!listUserBranchFactorDelete.isEmpty())
            {
                delete listUserBranchFactorDelete;
            } 
        }           
        if(!mapUserRecord.isEmpty()) 
        {
            List<WT_Business_Unit_Entity__c> listBranchFactorRecord = [SELECT Id, WT_Fusion_Feed_Branch__c FROM WT_Business_Unit_Entity__c WHERE WT_Fusion_Feed_Branch__c =:mapUserRecord.values()];            
            List<User> listNewUser= [SELECT Id, Name, WT_Branch__c FROM User WHERE Id =:mapUserRecord.keySet()];
            if(listBranchFactorRecord.size()>0)
            {
                String getName='';
                for(WT_Business_Unit_Entity__c branchFactor : listBranchFactorRecord)
                {
                    mapBusinessUnitName.put(branchFactor.WT_Fusion_Feed_Branch__c, branchFactor.Id);
                }
                for(User userRecord : listNewUser)
                {
                    if( mapBusinessUnitName.get(userRecord.WT_Branch__c) != null)
                    {
                        getName = userRecord.Name != null ? userRecord.Name+userRecord.WT_Branch__c :userRecord.WT_Branch__c;
                        WT_User_Branch_Factor_Lookup__c userBranchFactorRecord = new WT_User_Branch_Factor_Lookup__c(Name=getName, WT_User__c=userRecord.Id,
                                                                                                                     WT_Branch_Factor__c=mapBusinessUnitName.get(userRecord.WT_Branch__c));
                        listUserBranchFactorInsert.add(userBranchFactorRecord);
                    }
                }
                insert listUserBranchFactorInsert;
            }
        }        
    }
}