public class WT_BlockUserAutoProvisionAfterHandler extends TriggerHandler
{
    List<WT_Block_User_Auto_Provision__e> listNewBlockUserAutoProvision = new List<WT_Block_User_Auto_Provision__e>();

    public WT_BlockUserAutoProvisionAfterHandler()
    {
        listNewBlockUserAutoProvision = (List<WT_Block_User_Auto_Provision__e>) Trigger.new;        
    }
    public override void afterInsert()
    {
        UpdateUser();
    }    

    private void UpdateUser()
    {
        Set<Id> setUserIdToQuery = new Set<Id>();
        Map<Id, User> mapUserIdAndUser = new Map<Id, User>();
        CustomNotificationType autoProvisionedNotificationType = [SELECT Id, DeveloperName 
                                                                    FROM CustomNotificationType 
                                                                    WHERE DeveloperName='WT_Auto_Provisioned_User_Blocked_Event'];

        Group notificationGroup = [SELECT Id
                                    FROM Group
                                    WHERE DeveloperName = 'WT_Auto_Provisioned_User_Blocked_Group'
                                    LIMIT 1];

        Set<String> setRecipientId = new Set<String>();
        setRecipientId.add(notificationGroup.Id);

        for(WT_Block_User_Auto_Provision__e newBlockEvent : listNewBlockUserAutoProvision)
        {
            if(newBlockEvent.WT_Should_Deactivate_User__c)
            {
                setUserIdToQuery.add(newBlockEvent.WT_Blocked_User_Id__c);
            }
        }

        if(!setUserIdToQuery.isEmpty())
        {
            mapUserIdAndUser = new Map<Id, User>([SELECT Id,
                                                    Name,
                                                    Email,
                                                    Profile.Name
                                                    FROM User
                                                    WHERE Id IN :setUserIdToQuery]);
        }

        List<User> listUserToUpdate = new List<User>();
        for(WT_Block_User_Auto_Provision__e newBlockEvent : listNewBlockUserAutoProvision)
        {
            Boolean isUserActive = false;
            User userToUpdate = new User();
            if(!newBlockEvent.WT_Should_Deactivate_User__c)
            {
                isUserActive = true;
                userToUpdate.WT_Date_User_Released_From_Auto_Block__c = System.now();
            }

            userToUpdate.Id = newBlockEvent.WT_Blocked_User_Id__c;
            userToUpdate.IsActive = isUserActive;
            listUserToUpdate.add(userToUpdate);

            if(!isUserActive)
            {
                User blockedUser = null;
                if(mapUserIdAndUser.containsKey(newBlockEvent.WT_Blocked_User_Id__c))
                {
                    blockedUser = mapUserIdAndUser.get(newBlockEvent.WT_Blocked_User_Id__c);
                
                    String title = blockedUser.Name + ' has been blocked from being auto provisioned';
                    String body = 'User Email: ' + blockedUser.Email + '\n' + 'User Profile: ' + blockedUser.Profile.Name;
                    WT_CustomNotificationUtility.NotifyUsers(setRecipientId, title, body, autoProvisionedNotificationType.Id, null, 'c__WT_BlockedUserAutoProvisionWrapper');
                }
            }
        }

        if(!listUserToUpdate.isEmpty())
        {
            update listUserToUpdate;
        }
    }
}