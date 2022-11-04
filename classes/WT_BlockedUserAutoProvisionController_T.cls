@isTest
public class WT_BlockedUserAutoProvisionController_T 
{
    @TestSetup
    static void CreateTestData()
    {
        WT_Auto_Provisioned_Blocked_User__c newBlockedUser = new WT_Auto_Provisioned_Blocked_User__c();
        newBlockedUser.WT_Date_Blocked__c = System.now();
        newBlockedUser.WT_User__c = UserInfo.getUserId();
        
        insert newBlockedUser;
    }
    
    @isTest
    static void TestGetLicenseUsageData()
    {
        Test.startTest();
        WT_BlockedUserAutoProvisionController.GetLicenseUsageData();
        Test.stopTest();
    }
    
    @isTest
    static void TestGetBlockedUserData()
    {
        Test.startTest();
        WT_BlockedUserAutoProvisionController.GetBlockedUserData();
        Test.stopTest();
    }
    
    @isTest
    static void TestReleaseBlockedUser()
    {
        WT_Auto_Provisioned_Blocked_User__c blockedUser = [SELECT Id,
                                                           WT_User__c,
                                                           WT_Released_By_User__c,
                                                           WT_Date_Released__c
                                                           FROM WT_Auto_Provisioned_Blocked_User__c
                                                           LIMIT 1];
        
        Test.startTest();
        WT_BlockedUserAutoProvisionController.ReleaseBlockedUser(blockedUser.Id);
        Test.stopTest();
    }
}