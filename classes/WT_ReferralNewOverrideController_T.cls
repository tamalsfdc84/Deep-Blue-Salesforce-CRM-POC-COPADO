/**
 * -------------------------------------------------------------------------------------------------------------------------------------------------
 * @Name			WT_ReferralNewOverrideController_T
 * @Author			Swaminathan E	<SEzhumal@wintrust.com>
 * @version 		v1.0 
 * @CreatedDate		08-12-2020
 * ---------------------------------------------------------------------------------------------------------------------------------------------------
 * @Description 
 * Class is used as test class for WT_ReferralNewOverrideController 
 * ---------------------------------------------------------------------------------------------------------------------------------------------------
 * FUNCTIONAL TEST LOGIC
 *  executeHandler()
 * 	> used to run the Apex class for the WT_DatePaidController , generally for code coverage.
 * ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
@isTest
public class WT_ReferralNewOverrideController_T 
{
    static testMethod void executeHandler() 
    {
        List<Lead> recordList = new List<Lead>();        
        Profile p = [SELECT Id FROM Profile WHERE Name='WT Retail']; 
        User user = new User(Alias = 'stdtes', Email='standarduser123@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Test12345', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = p.Id, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='stdtest12345@test1.com' ,
                            WT_Business_Unit_Entity__c='118-1');
        insert user ;
        WT_Business_Unit_Entity__c businessUnitRecord = new WT_Business_Unit_Entity__c(Name = '118-1', WT_Bank_Number__c = '118',
                                                                                       WT_Branch__c = '1');
        insert businessUnitRecord;
        Account accountRecord = new Account();
        accountRecord.LastName = 'Test1';
        accountRecord.type = 'Prospect';
        accountRecord.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Prospect').getRecordTypeId();
        Lead leadRecord2 = new Lead();
        leadRecord2.FinServ__ReferredByUser__c = user.Id;
        leadRecord2.LastName = 'Referral Record2';
        leadRecord2.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('WT_Wealth').getRecordTypeId();
        Lead leadRecord3 = new Lead();
        leadRecord3.FinServ__ReferredByUser__c = user.Id;
        leadRecord3.LastName = 'Referral Record3';
        leadRecord3.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('WT_Wealth').getRecordTypeId();
        leadRecord3.WT_Referral_Business_Unit__c = businessUnitRecord.id;
        recordList.add(leadRecord2);
        recordList.add(leadRecord3);
        insert accountRecord;       
        insert recordList;
        Test.startTest();
        WT_ReferralNewOverrideController.getPrePopulateValue();
        WT_ReferralNewOverrideController.populateName(accountRecord.id);
        WT_ReferralNewOverrideController.findRecords('t','User','');
        Test.stopTest();
    }
}