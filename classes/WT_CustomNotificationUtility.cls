public without sharing class WT_CustomNotificationUtility 
{
	public static void NotifyUsers(Set<String> setRecipientId, String notificationTitle, String notificationBody, Id notificationTypeId, String notificationTargetId, String customTabTargetPageReference)
    {
        Messaging.CustomNotification newNotification = new Messaging.CustomNotification();
        newNotification.setTitle(notificationTitle);
        newNotification.setBody(notificationBody);
        newNotification.setNotificationTypeId(notificationTypeId);
        
        if(String.isNotBlank(customTabTargetPageReference))
        {
        	String tabPageReference = '{type: "standard__component", attributes:{componentName:' +  customTabTargetPageReference + '}}';
            newNotification.setTargetPageRef(tabPageReference);
        }
        else if(String.isNotBlank(notificationTargetId))
        {
            newNotification.setTargetId(notificationTargetId);
        }
        
        try 
        {
            newNotification.send(setRecipientId);
        }
        catch (Exception e) 
        {
            System.debug('Problem sending notification: ' + e.getMessage());
        }
    }
}