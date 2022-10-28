/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name           WT_BatchDeactivateUser_T
* @Author         Vasavi K    <VKolusu@wintrust.com> 
* @ModifiedBy     Vasavi K    <VKolusu@wintrust.com> 
* @version        v1.0 
* @CreatedDate    03-02-2022
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* Class is used as test class for WT_BatchDeactivateUser
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* FUNCTIONAL TEST LOGIC
* > used to deactivate the users based on condition mentioned in custom settings
* 
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
@isTest(SeeAllData = false)
public class WT_BatchDeactivateUser_T {
    @testSetup
    static void testSetupData() {
        User_Deactivation__c custmSettng = new User_Deactivation__c();
        custmSettng.Name='DeactivateUserBatch';
        custmSettng.inactive_days__c='90';
        custmSettng.Profile_Excluded__c='System Administrator';
        custmSettng.UsersExcluded__c='Test LastName';
        custmSettng.Email_To_Be_Excluded__c ='teststanarduser120983@bankalgonquin.com';
        insert custmSettng;
    }
    @isTest
    static void  runtestDeactivateUser(){
        test.startTest();
        String schTime = '0 0 12 * * ?';
        WT_BatchDeactivateUserSchedule schJob = new WT_BatchDeactivateUserSchedule();
        system.schedule('TestUpdateUser', schTime, schJob);
        test.stopTest();
    }
}