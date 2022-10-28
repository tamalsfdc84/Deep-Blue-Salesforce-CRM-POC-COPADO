/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name           WT_GetRecordLockStatus_T
* @Author         Vasavi K    <VKolusu@wintrust.com> 
* @ModifiedBy     Vasavi K    <VKolusu@wintrust.com> 
* @version        v1.0 
* @CreatedDate    3/1/2022
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* Class is used as test class for WT_GetRecordLockStatus and WT_UnlockRecord
* ---------------------------------------------------------------------------------------------------------------------------------------------------
 ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
@isTest
public with sharing class WT_GetRecordLockStatus_T {
    @testSetup
    static void Setup(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User user = new User(Alias = 'stdtes', Email='standarduser123@libertyvillebank.com', 
                            EmailEncodingKey='UTF-8', LastName='Test12345', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = p.Id, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='stdtest12345@test1.com' ,
                            WT_Business_Unit_Entity__c='118-1');
        insert user ;

        Lead leadRecord2 = new Lead();
        leadRecord2.FinServ__ReferredByUser__c = user.Id;
        leadRecord2.LastName = 'Referral Record2';
        leadRecord2.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('WT_Wealth').getRecordTypeId();
        insert leadRecord2;
    }

    @isTest
    public static void CanGetRecordLockStatus () {
        lead ld=[SELECT id 
                    FROM lead
                    LIMIT 1 ];
        Approval.lock(ld.Id);
        WT_GetRecordLockStatus.Request testReq = new WT_GetRecordLockStatus.Request();
        testReq.recordId = ld.Id;
        List<WT_GetRecordLockStatus.Request> reqList = new List<WT_GetRecordLockStatus.Request>();
        reqList.add(testReq);
        test.startTest();
        List<WT_GetRecordLockStatus.Response> getstatusResponseList = WT_GetRecordLockStatus.GetStatus(reqList);
        test.stopTest();
        System.assertEquals(getstatusResponseList[0].locked,true);
    }
     @isTest
    public static void CanUnlockRecord () {
       lead ld=[SELECT id 
                    FROM lead
                    LIMIT 1 ];
        Approval.lock(ld.Id);
        WT_UnlockRecord.Request testReq = new WT_UnlockRecord.Request();
        testReq.recordId = ld.Id;
        test.startTest();
        List<WT_UnlockRecord.Request> reqList = new List<WT_UnlockRecord.Request>();
        reqList.add(testReq);
        List<WT_UnlockRecord.Response> unlockResponseList = WT_UnlockRecord.Unlock(reqList);
        test.stopTest();
        System.assertEquals(unlockResponseList[0].isSuccess,true);
        System.assertEquals(Approval.isLocked(ld.Id), false);
    }
}