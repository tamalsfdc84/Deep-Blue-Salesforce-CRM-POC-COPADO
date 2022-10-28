@isTest
public class WT_CustomNotificationUtility_T 
{
	@isTest
    static void TestNotifyUsers()
    {
        CustomNotificationType autoProvisionedNotificationType = [SELECT Id, DeveloperName 
                                                                    FROM CustomNotificationType 
                                                                    WHERE DeveloperName='WT_Auto_Provisioned_User_Blocked_Event'];
        
        WT_CustomNotificationUtility.NotifyUsers(new Set<String>{UserInfo.getUserId()}, 'test', 'test', autoProvisionedNotificationType.Id, UserInfo.getUserId(), null);
    }
}