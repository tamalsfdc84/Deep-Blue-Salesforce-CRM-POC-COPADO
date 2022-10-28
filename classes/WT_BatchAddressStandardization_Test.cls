@isTest
public class WT_BatchAddressStandardization_Test 
{
    
    @testSetup static void setUpData() 
    {
        List<account> dupList = new List<account>();
        Account acc1 = new Account();
        acc1.lastname = 'Test1';
        acc1.type = 'Prospect';
        acc1.WT_Address_Flag__c = 'Address Not Standardized';
        acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Prospect').getRecordTypeId();
        
        Account acc3 = new Account();
        acc3.lastname = 'bond2s';
        acc3.type = 'customer';
        acc3.WT_Address_Flag__c = 'Address Not Standardized';
        acc3.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Customer').getRecordTypeId();
        
        dupList.add(acc1);
        dupList.add(acc3);
        insert dupList;
        
    }
    
    static testMethod void successFulCallout() 
    {
        Test.setMock(HttpCalloutMock.class, new WT_Add_Mock());
        List<Account> accList1 = [Select id, name , WT_Latitude__c from Account ];
        system.debug('**acc' + accList1);
        Test.startTest();
        Database.executeBatch(new WT_BatchAddressStandardization());
        Test.stopTest();
        List<Account> accList = [Select id, name , WT_Latitude__c,WT_Address_Flag__c from Account ];
        
        System.assertEquals('36.1125269', accList[0].WT_Latitude__c);
        System.assertEquals('36.1125269', accList[1].WT_Latitude__c);
        
        
        
        
    }
    
    static testMethod void fail200() 
    {
        Test.setMock(HttpCalloutMock.class, new WT_Fail_Callout_Mock());
        List<Account> accList1 = [Select id, name , WT_Latitude__c from Account ];
        system.debug('**acc' + accList1);
        Test.startTest();
        Database.executeBatch(new WT_BatchAddressStandardization());
        Test.stopTest();
        List<Account> accList = [Select id, name , WT_Latitude__c from Account ];
        
        System.assertEquals(null, accList[0].WT_Latitude__c);
        System.assertEquals(null, accList[1].WT_Latitude__c);
        
    }
    
    static testMethod void fail400() 
    {
        Test.setMock(HttpCalloutMock.class, new WT_Fail_Callout_Mock_Status());
        List<Account> accList1 = [Select id, name , WT_Latitude__c from Account ];
        system.debug('**acc' + accList1);
        Test.startTest();
        Database.executeBatch(new WT_BatchAddressStandardization());
        Test.stopTest();
        List<Account> accList = [Select id, name , WT_Latitude__c from Account ];
        
        System.assertEquals(null, accList[0].WT_Latitude__c);
        System.assertEquals(null, accList[1].WT_Latitude__c);
        
    }
    
    
}