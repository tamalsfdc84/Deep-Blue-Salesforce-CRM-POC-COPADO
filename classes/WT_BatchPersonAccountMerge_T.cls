/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name             WT_BatchPersonAccountMerge_T
* @Author           Vamsi Pulikallu <vpulikal@wintrust.com> 
* @version          v1.0 
* @CreatedDate      2 Nov 2021
* @ModifiedDate     2 Nov 2021
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* Class is used as test class for WT_BatchPersonAccountMerge
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
@isTest
public class WT_BatchPersonAccountMerge_T 
{
    public static id customerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Customer').getRecordTypeId();
    public static id prospectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Prospect').getRecordTypeId();
    @isTest 
    public static void testMerge() 
    {
        test.startTest();
        List<account> listAccount = new List<account>();
        Account accountRecord1 = new Account();
        accountRecord1.lastname = 'Test1';
        accountRecord1.type = 'Prospect';
        accountRecord1.FinServ__SourceSystemId__pc = '123456';
        accountRecord1.RecordTypeId = prospectRecordTypeId;
        
        Account accountRecord2 = new Account();
        accountRecord2.lastname = 'Test1';
        accountRecord2.type = 'Prospect';
        accountRecord2.FinServ__SourceSystemId__pc = '234567';
        accountRecord2.RecordTypeId = prospectRecordTypeId;
        
        Account accountRecord3 = new Account();
        accountRecord3.lastname = 'Test1';
        accountRecord3.type = 'Customer';
        accountRecord3.FinServ__SourceSystemId__pc = '123456';
        accountRecord3.RecordTypeId = customerRecordTypeId;
        
        Account accountRecord4 = new Account();
        accountRecord4.lastname = 'Test1';
        accountRecord4.type = 'Prospect';
        accountRecord4.FinServ__SourceSystemId__pc = '234567';
        accountRecord4.RecordTypeId = prospectRecordTypeId;
        
        listAccount.add(accountRecord1);
        listAccount.add(accountRecord2);
        listAccount.add(accountRecord3);
        listAccount.add(accountRecord4);
        insert listAccount;
        Database.executeBatch(new WT_BatchPersonAccountMerge());
        Test.stopTest();
        System.assertEquals(1, [select count() from Account Where recordTypeId = :customerRecordTypeId AND isdeleted = false]);    
        
    }
}