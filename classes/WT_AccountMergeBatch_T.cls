@isTest

public class WT_AccountMergeBatch_T 
{
    public static id customerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Customer').getRecordTypeId();
    public static id prospectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Prospect').getRecordTypeId();
    @testSetup static void setUpData() 
    {
        List<account> listAccount = new List<account>();
        Account accountRecord1 = new Account();
        accountRecord1.lastname = 'Test1';
        accountRecord1.type = 'Prospect';
        accountRecord1.RecordTypeId = prospectRecordTypeId;
        
        Account accountRecord2 = new Account();
        accountRecord2.lastname = 'Test1';
        accountRecord2.type = 'Prospect';
        accountRecord2.RecordTypeId = prospectRecordTypeId;
        
        Account accountRecord3 = new Account();
        accountRecord3.lastname = 'Test1';
        accountRecord3.type = 'customer';
        accountRecord3.RecordTypeId = customerRecordTypeId;
        
        Account accountRecord4 = new Account();
        accountRecord4.lastname = 'Test1';
        accountRecord4.type = 'customer';
        accountRecord4.RecordTypeId = customerRecordTypeId;
        
        listAccount.add(accountRecord1);
        listAccount.add(accountRecord2);
        listAccount.add(accountRecord3);
        listAccount.add(accountRecord4);
        insert listAccount;
        
        Task task1 = new Task();
        task1.WhatId = listAccount[0].id;
        task1.ActivityDate = Date.today() -800;
        task1.status = 'Completed';
        insert task1;
        
        Task task2= new Task();
        task2.WhatId = listAccount[1].id;
        task2.ActivityDate = Date.today() -800;
        task2.status = 'Completed';
        insert task2;
        
        Task task3= new Task();
        task3.WhatId = listAccount[2].id;
        task3.ActivityDate = Date.today() -800;
        task3.status = 'Completed';
        insert task3;
        
        Task task4= new Task();
        task4.WhatId = listAccount[3].id;
        task4.ActivityDate = Date.today() -800;
        task4.status = 'Completed';
        insert task4;
    }
    static testMethod void validate2PACustomer() 
    {
        Test.startTest();
        List<Account> listCustomerAccount = new List<Account> ([select id, name, LastActivityDate, recordtypeid from Account Where recordTypeId = :customerRecordTypeId]);
        List<Account> listProspectAccount = new List<Account> ([select id, name, LastActivityDate, recordtypeid from Account Where recordTypeId = :prospectRecordTypeId]);
        DuplicateRule rule = [ SELECT id FROM DuplicateRule WHERE DeveloperName = 'Standard_Account_Duplicate_Rule' LIMIT 1 ];
        DuplicateRecordSet duplicateRecord = new DuplicateRecordSet(duplicateRuleId = rule.id);
        insert duplicateRecord;
        List<DuplicateRecordItem> listDuplicateRecordItems = new List<DuplicateRecordItem>();
        for ( Account accountRecord : listCustomerAccount ) 
        {
            listDuplicateRecordItems.add( new DuplicateRecordItem(duplicateRecordSetId = duplicateRecord.id, recordId = accountRecord.id));
        }
        for ( Account accountRecord : listProspectAccount ) 
        {
            listDuplicateRecordItems.add( new DuplicateRecordItem(duplicateRecordSetId = duplicateRecord.id,recordId = accountRecord.id));
        }
        insert listDuplicateRecordItems;
        Database.executeBatch(new WT_AccountMergeBatch());
        Test.stopTest();
        System.assertEquals(0, [select count() from Account Where recordTypeId = :prospectRecordTypeId AND isdeleted = false]);    
    }
    
    static testMethod void validate2PACustomer1Prospect() 
    {
        Test.startTest();
        List<Account> listCustomerAccount = new List<Account> ([select id, name ,LastActivityDate,recordtypeid from Account Where recordTypeId = :customerRecordTypeId ]);
        List<Account> listProspectAccount = new List<Account> ([select id, name ,LastActivityDate,recordtypeid from Account Where recordTypeId = :prospectRecordTypeId Limit 1]);  
        DuplicateRule rule = [ SELECT id FROM DuplicateRule WHERE DeveloperName = 'Standard_Account_Duplicate_Rule' LIMIT 1 ];
        DuplicateRecordSet duplicateRecord = new DuplicateRecordSet(duplicateRuleId = rule.id);
        insert duplicateRecord;
        List<DuplicateRecordItem> listDuplicateRecordItems = new List<DuplicateRecordItem>();
        for ( Account accountRecord : listCustomerAccount ) 
        {
            listDuplicateRecordItems.add( new DuplicateRecordItem(duplicateRecordSetId = duplicateRecord.id, recordId = accountRecord.id ));
        }
        for ( Account accountRecord : listProspectAccount ) 
        {
            listDuplicateRecordItems.add( new DuplicateRecordItem( duplicateRecordSetId = duplicateRecord.id, recordId = accountRecord.id));
        }
        insert listDuplicateRecordItems;
        Database.executeBatch(new WT_AccountMergeBatch());
        Test.stopTest();
        System.assertEquals(1, [select count() from Account Where recordTypeId = :prospectRecordTypeId AND isdeleted = false ]);
    }
    
    static testMethod void validate3PACustomer1Prospect() 
    {   
        Test.startTest();
        List<Account> listCustomerAccount = new List<Account> ([select id, name, LastActivityDate, recordtypeid from Account Where recordTypeId = :customerRecordTypeId Limit 1]);
        List<Account> listProspectAccount = new List<Account> ([select id, name, LastActivityDate, recordtypeid from Account Where recordTypeId = :prospectRecordTypeId Limit 1]);
        DuplicateRule rule = [ SELECT id FROM DuplicateRule  WHERE DeveloperName = 'Standard_Account_Duplicate_Rule' LIMIT 1 ];
        DuplicateRecordSet duplicateRecord = new DuplicateRecordSet(duplicateRuleId = rule.id);
        insert duplicateRecord;
        List<DuplicateRecordItem> listDuplicateRecordItems = new List<DuplicateRecordItem>();
        for ( Account accountRecord : listCustomerAccount ) 
        {
            listDuplicateRecordItems.add( new DuplicateRecordItem(duplicateRecordSetId = duplicateRecord.id,recordId = accountRecord.id));
        }
        for ( Account accountRecord : listProspectAccount ) 
        {
            listDuplicateRecordItems.add( new DuplicateRecordItem(duplicateRecordSetId = duplicateRecord.id,recordId = accountRecord.id));
        }
        insert listDuplicateRecordItems;
        Database.executeBatch(new WT_AccountMergeBatch());
        Test.stopTest();
        System.assertEquals(1, [select count() from Account Where recordTypeId = :prospectRecordTypeId AND isdeleted = false]);
    }
    
    static testMethod void validate4PACustomer1Prospect() 
    {   
        Test.startTest();
        Account accountRecord5 = new Account(lastname = 'Test1',type = 'Prospect',RecordTypeId = prospectRecordTypeId);
        List<Account> listProspectAccount = new List<Account> ();
        listProspectAccount.add(accountRecord5);
        insert listProspectAccount;
        List<Account> listCustomerAccount = new List<Account> ([select id, name,LastActivityDate,recordtypeid from Account Where recordTypeId = :customerRecordTypeId Limit 1]);
        DuplicateRule rule = [ SELECT id FROM DuplicateRule WHERE DeveloperName = 'Standard_Account_Duplicate_Rule' LIMIT 1 ];
        DuplicateRecordSet duplicateRecord = new DuplicateRecordSet(duplicateRuleId = rule.id);
        insert duplicateRecord;
        List<DuplicateRecordItem> listDuplicateRecordItems = new List<DuplicateRecordItem>();
        for ( Account accountRecord : listCustomerAccount ) 
        {
            listDuplicateRecordItems.add( new DuplicateRecordItem(duplicateRecordSetId = duplicateRecord.id,recordId = accountRecord.id));
        }
        for ( Account accountRecord : listProspectAccount ) 
        {
            listDuplicateRecordItems.add( new DuplicateRecordItem(duplicateRecordSetId = duplicateRecord.id,recordId = accountRecord.id));
        }
        insert listDuplicateRecordItems;
        Database.executeBatch(new WT_AccountMergeBatch());
        Test.stopTest();
        System.assertEquals(2, [select count() from Account Where recordTypeId = :prospectRecordTypeId AND isdeleted = false]);        
    }
    static testMethod void validate5PACustomer1Prospect() 
    {   
        Test.startTest();
        Account accountRecord5 = new Account(lastname = 'Test1',type = 'Prospect',RecordTypeId = prospectRecordTypeId);
        List<Account> listProspectAccount = new List<Account> ();
        listProspectAccount.add(accountRecord5);
        User userRecord = WT_DataFactory.createUser('WT Retail');
        insert userRecord;
        system.runAs(userRecord)
        {
            insert listProspectAccount;
        }
        List<Account> listCustomerAccount = new List<Account> ([select id, name,LastActivityDate,recordtypeid from Account Where recordTypeId = :customerRecordTypeId Limit 1]);
        DuplicateRule rule = [ SELECT id FROM DuplicateRule WHERE DeveloperName = 'Standard_Account_Duplicate_Rule' LIMIT 1 ];
        DuplicateRecordSet duplicateRecord = new DuplicateRecordSet(duplicateRuleId = rule.id);
        insert duplicateRecord;
        List<DuplicateRecordItem> listDuplicateRecordItems = new List<DuplicateRecordItem>();
        for ( Account accountRecord : listCustomerAccount ) 
        {
            listDuplicateRecordItems.add( new DuplicateRecordItem(duplicateRecordSetId = duplicateRecord.id,recordId = accountRecord.id));
        }
        for ( Account accountRecord : listProspectAccount ) 
        {
            listDuplicateRecordItems.add( new DuplicateRecordItem(duplicateRecordSetId = duplicateRecord.id,recordId = accountRecord.id));
        }
        insert listDuplicateRecordItems;
        Database.executeBatch(new WT_AccountMergeBatch());
        Test.stopTest();
        System.assertEquals(3, [select count() from Account Where recordTypeId = :prospectRecordTypeId AND isdeleted = false]);        
    }
    static testMethod void validate1PACustomer() 
    {
        Test.startTest();
        List<Account> listCustomerAccount = new List<Account> ([select id,name ,recordtypeid from Account Where recordTypeId = :customerRecordTypeId Limit 1]);
        List<Account> listProspectAccount = new List<Account> ([select id,name ,recordtypeid from Account Where recordTypeId = :prospectRecordTypeId]);
        DuplicateRule rule = [ SELECT id FROM DuplicateRule WHERE DeveloperName = 'Standard_Account_Duplicate_Rule' LIMIT 1 ];
        DuplicateRecordSet duplicateRecord = new DuplicateRecordSet(duplicateRuleId = rule.id);
        insert duplicateRecord;
        List<DuplicateRecordItem> listDuplicateRecordItems = new List<DuplicateRecordItem>();
        for ( Account accountRecord : listCustomerAccount ) 
        {
            listDuplicateRecordItems.add( new DuplicateRecordItem(duplicateRecordSetId = duplicateRecord.id,recordId = accountRecord.id));
        }
        
        for ( Account accountRecord : listProspectAccount ) 
        {
            listDuplicateRecordItems.add( new DuplicateRecordItem(duplicateRecordSetId = duplicateRecord.id,recordId = accountRecord.id));
        }
        insert listDuplicateRecordItems;
        Database.executeBatch(new WT_AccountMergeBatch());
        Test.stopTest();
        System.assertEquals(0, [select count() from Account Where recordTypeId = :prospectRecordTypeId  AND isdeleted = false]);
        
    }
    
    static testMethod void validate2PAProspect() 
    {
        Test.startTest();
        List<Account> listCustomerAccount = new List<Account> ([select id,name,recordtypeid from Account Where recordTypeId = :customerRecordTypeId]);
        List<Account> listProspectAccount = new List<Account> ([select id,name,recordtypeid from Account Where recordTypeId = :prospectRecordTypeId]);
        DuplicateRule rule = [ SELECT id FROM DuplicateRule WHERE DeveloperName = 'Standard_Account_Duplicate_Rule' LIMIT 1 ];
        DuplicateRecordSet duplicateRecord = new DuplicateRecordSet(duplicateRuleId = rule.id);
        insert duplicateRecord;
        List<DuplicateRecordItem> listDuplicateRecordItems = new List<DuplicateRecordItem>();
        for ( Account accountRecord : listProspectAccount ) 
        {
            listDuplicateRecordItems.add( new DuplicateRecordItem(duplicateRecordSetId = duplicateRecord.id,recordId = accountRecord.id));
        }
        insert listDuplicateRecordItems;
        Database.executeBatch(new WT_AccountMergeBatch());
        Test.stopTest();
        System.assertEquals(1, [select count() from Account Where recordTypeId = :prospectRecordTypeId AND isdeleted = false]);
    }
    
    static testMethod void validate3PAProspect() 
    {
        Test.startTest();
        Account accountRecord5 = new Account(lastname = 'Test1',type = 'Prospect',RecordTypeId = prospectRecordTypeId);
        Account accountRecord6 = new Account(lastname = 'Test1',type = 'Prospect',RecordTypeId = prospectRecordTypeId);
        Account accountRecord8 = new Account(lastname = 'Test2',type = 'Prospect',RecordTypeId = prospectRecordTypeId);
        Account accountRecord9 = new Account(lastname = 'Test2',type = 'Prospect',RecordTypeId = prospectRecordTypeId);
        List<Account> listProspectAccount = new List<Account> ();
        listProspectAccount.add(accountRecord5);
        listProspectAccount.add(accountRecord6);
        listProspectAccount.add(accountRecord8);
        listProspectAccount.add(accountRecord9);
        insert listProspectAccount;
        Account accountRecord7 = new Account(lastname = 'Test1',type = 'Prospect',RecordTypeId = prospectRecordTypeId);
        
        List<Account> listCustomerAccount = new List<Account> ();
        listCustomerAccount.add(accountRecord7);
        insert listCustomerAccount;
        
        Task task1 = new Task(WhatId = listProspectAccount[0].id,ActivityDate = Date.today() -800,status = 'Completed');
        insert task1;
        Task task2 = new Task(WhatId = listProspectAccount[1].id,ActivityDate = Date.today() -700,status = 'Completed');
        insert task2;
        Task task3 = new Task(WhatId = listProspectAccount[2].id,ActivityDate = Date.today() -700,status = 'Completed');
        insert task3;
        Task task4 = new Task(WhatId = listProspectAccount[3].id,ActivityDate = Date.today() -800,status = 'Completed');
        insert task4;
        
        DuplicateRule rule = [ SELECT id FROM DuplicateRule WHERE DeveloperName = 'Standard_Account_Duplicate_Rule' LIMIT 1 ];
        DuplicateRecordSet duplicateRecord = new DuplicateRecordSet(duplicateRuleId = rule.id);
        insert duplicateRecord;
        List<DuplicateRecordItem> listDuplicateRecordItems = new List<DuplicateRecordItem>();
        for ( Account accountRecord : listProspectAccount ) 
        {
            listDuplicateRecordItems.add( new DuplicateRecordItem(duplicateRecordSetId = duplicateRecord.id,recordId = accountRecord.id));
        }
        insert listDuplicateRecordItems;
        Database.executeBatch(new WT_AccountMergeBatch());
        Test.stopTest();
        System.assertEquals(4, [select count() from Account Where recordTypeId = :prospectRecordTypeId AND isdeleted = false]);
    }
    
    static testMethod void validate3PAProspect1() 
    {
        Test.startTest();
        Account accountRecord5 = new Account(lastname = 'Test1',type = 'Prospect',RecordTypeId = prospectRecordTypeId);
        Account accountRecord6 = new Account(lastname = 'Test1',type = 'Prospect',RecordTypeId = prospectRecordTypeId);
        List<Account> listProspectAccount = new List<Account> ();
        listProspectAccount.add(accountRecord5);
        listProspectAccount.add(accountRecord6);
        insert listProspectAccount;
        Account accountRecord7 = new Account(lastname = 'Test1',type = 'Prospect',RecordTypeId = prospectRecordTypeId);
        
        List<Account> listCustomerAccount = new List<Account> ();
        listCustomerAccount.add(accountRecord7);
        insert listCustomerAccount;
        
        Task task1 = new Task(WhatId = listProspectAccount[0].id,ActivityDate = Date.today() -800,status = 'Completed');
        insert task1;
        Task task2 = new Task(WhatId = listProspectAccount[1].id,ActivityDate = Date.today() -700,status = 'Completed');
        insert task2;
        
        DuplicateRule rule = [ SELECT id FROM DuplicateRule WHERE DeveloperName = 'Standard_Account_Duplicate_Rule' LIMIT 1 ];
        DuplicateRecordSet duplicateRecord = new DuplicateRecordSet(duplicateRuleId = rule.id);
        insert duplicateRecord;
        List<DuplicateRecordItem> listDuplicateRecordItems = new List<DuplicateRecordItem>();
        for ( Account accountRecord : listProspectAccount ) 
        {
            listDuplicateRecordItems.add( new DuplicateRecordItem(duplicateRecordSetId = duplicateRecord.id,recordId = accountRecord.id));
        }
        insert listDuplicateRecordItems;
        Database.executeBatch(new WT_AccountMergeBatch());
        Test.stopTest();
        System.assertEquals(4, [select count() from Account Where recordTypeId = :prospectRecordTypeId AND isdeleted = false]);
    }
    
    static testMethod void validate3PAProspect2() 
    {
        Test.startTest();
        Account accountRecord5 = new Account(lastname = 'Test1',type = 'Prospect',RecordTypeId = prospectRecordTypeId);
        Account accountRecord6 = new Account(lastname = 'Test1',type = 'Prospect',RecordTypeId = prospectRecordTypeId);
        List<Account> listProspectAccount = new List<Account> ();
        listProspectAccount.add(accountRecord5);
        listProspectAccount.add(accountRecord6);
        insert listProspectAccount;
        Account accountRecord7 = new Account(lastname = 'Test1',type = 'Prospect',RecordTypeId = prospectRecordTypeId);
        
        List<Account> listCustomerAccount = new List<Account> ();
        listCustomerAccount.add(accountRecord7);
        insert listCustomerAccount;
        
        Task task1 = new Task(WhatId = listProspectAccount[0].id,ActivityDate = Date.today() -700,status = 'Completed');
        insert task1;
        Task task2 = new Task(WhatId = listProspectAccount[1].id,ActivityDate = Date.today() -800,status = 'Completed');
        insert task2;
        
        DuplicateRule rule = [ SELECT id FROM DuplicateRule WHERE DeveloperName = 'Standard_Account_Duplicate_Rule' LIMIT 1 ];
        DuplicateRecordSet duplicateRecord = new DuplicateRecordSet(duplicateRuleId = rule.id);
        insert duplicateRecord;
        List<DuplicateRecordItem> listDuplicateRecordItems = new List<DuplicateRecordItem>();
        for ( Account accountRecord : listProspectAccount ) 
        {
            listDuplicateRecordItems.add( new DuplicateRecordItem(duplicateRecordSetId = duplicateRecord.id,recordId = accountRecord.id));
        }
        insert listDuplicateRecordItems;
        Database.executeBatch(new WT_AccountMergeBatch());
        Test.stopTest();
        System.assertEquals(4, [select count() from Account Where recordTypeId = :prospectRecordTypeId AND isdeleted = false]);
    }
    
    static testMethod void validate2PACustomerInvalid() 
    {   
        Test.startTest();
        List<Account> listCustomerAccount = new List<Account> ([select id,name ,recordtypeid from Account Where recordTypeId = :customerRecordTypeId]);
        List<Account> listProspectAccount = new List<Account> ([select id,name ,recordtypeid from Account Where recordTypeId = :prospectRecordTypeId]);
        
        Task task1 = new Task();
        task1.WhatId = listProspectAccount[0].id;
        task1.ActivityDate = Date.today() -400;
        task1.status = 'Completed';
        insert task1;
        
        Task task2= new Task();
        task2.WhatId = listProspectAccount[1].id;
        task2.ActivityDate = Date.today() -400;
        task2.status = 'Completed';
        insert task2;
        DuplicateRule rule = [ SELECT id FROM DuplicateRule WHERE DeveloperName = 'Standard_Account_Duplicate_Rule' LIMIT 1 ];
        DuplicateRecordSet duplicateRecord = new DuplicateRecordSet(duplicateRuleId = rule.id);
        insert duplicateRecord;
        List<DuplicateRecordItem> listDuplicateRecordItems = new List<DuplicateRecordItem>();
        
        for ( Account accountRecord : listCustomerAccount ) 
        {
            listDuplicateRecordItems.add( new DuplicateRecordItem(duplicateRecordSetId = duplicateRecord.id,recordId = accountRecord.id));
        }
        
        for ( Account accountRecord : listProspectAccount ) 
        {
            listDuplicateRecordItems.add( new DuplicateRecordItem(duplicateRecordSetId = duplicateRecord.id,recordId = accountRecord.id));
        }
        insert listDuplicateRecordItems;
        Database.executeBatch(new WT_AccountMergeBatch());
        Test.stopTest();
        System.assertEquals(2, [select count() from Account Where recordTypeId = :prospectRecordTypeId AND isdeleted = false]);
        
    }
    
    static testMethod void validate1PACustomerInvalid() 
    {   
        Test.startTest();
        List<Account> listCustomerAccount = new List<Account> ([select id,name ,recordtypeid from Account Where recordTypeId = :customerRecordTypeId Limit 1]);
        List<Account> listProspectAccount = new List<Account> ([select id,name ,recordtypeid from Account Where recordTypeId = :prospectRecordTypeId]);
        
        Task task1 = new Task();
        task1.WhatId = listProspectAccount[0].id;
        task1.ActivityDate = Date.today();
        task1.status = 'Completed';
        insert task1;
        
        Task task2= new Task();
        task2.WhatId = listProspectAccount[1].id;
        task2.ActivityDate = Date.today();
        task2.status = 'Completed';
        insert task2;
        
        DuplicateRule rule = [ SELECT id FROM DuplicateRule WHERE DeveloperName = 'Standard_Account_Duplicate_Rule' LIMIT 1 ];
        DuplicateRecordSet duplicateRecord = new DuplicateRecordSet(duplicateRuleId = rule.id);
        insert duplicateRecord;
        List<DuplicateRecordItem> listDuplicateRecordItems = new List<DuplicateRecordItem>();
        for ( Account accountRecord : listCustomerAccount ) 
        {
            listDuplicateRecordItems.add( new DuplicateRecordItem(duplicateRecordSetId = duplicateRecord.id,recordId = accountRecord.id));
        }
        
        for ( Account accountRecord : listProspectAccount ) 
        {
            listDuplicateRecordItems.add( new DuplicateRecordItem(duplicateRecordSetId = duplicateRecord.id,recordId = accountRecord.id));
        }
        insert listDuplicateRecordItems;
        Database.executeBatch(new WT_AccountMergeBatch());
        Test.stopTest();
        System.assertEquals(2, [select count() from Account Where recordTypeId = :prospectRecordTypeId AND isdeleted = false]);
        
    }
    
    static testMethod void validate2PAProspectInvalid() 
    {   
        Test.startTest();
        List<Account> listCustomerAccount = new List<Account> ([select id,name ,recordtypeid from Account Where recordTypeId = :customerRecordTypeId]);
        List<Account> listProspectAccount = new List<Account> ([select id,name ,recordtypeid from Account Where recordTypeId = :prospectRecordTypeId]);
        Task task1 = new Task();
        task1.WhatId = listProspectAccount[0].id;
        task1.ActivityDate = Date.today() -400;
        task1.status = 'Completed';
        insert task1;
        
        Task task2= new Task();
        task2.WhatId = listProspectAccount[1].id;
        task2.ActivityDate = Date.today() -400;
        task2.status = 'Completed';
        insert task2;
        DuplicateRule rule = [ SELECT id FROM DuplicateRule WHERE DeveloperName = 'Standard_Account_Duplicate_Rule' LIMIT 1 ];
        DuplicateRecordSet duplicateRecord = new DuplicateRecordSet(duplicateRuleId = rule.id);
        insert duplicateRecord;
        List<DuplicateRecordItem> listDuplicateRecordItems = new List<DuplicateRecordItem>();
        for ( Account accountRecord : listProspectAccount ) 
        {
            listDuplicateRecordItems.add( new DuplicateRecordItem(duplicateRecordSetId = duplicateRecord.id,recordId = accountRecord.id));
        }
        insert listDuplicateRecordItems;
        Database.executeBatch(new WT_AccountMergeBatch());
        Test.stopTest();
        System.assertEquals(1, [select count() from Account Where recordTypeId = :prospectRecordTypeId AND isdeleted = false]);
    }
    
    
    static testMethod void validate2PACustomer1ProspectInvalid() 
    {        
        Test.startTest();        
        List<Account> listCustomerAccount = new List<Account> ([select id,name ,LastActivityDate,recordtypeid from Account Where recordTypeId = :customerRecordTypeId ]);
        List<Account> listProspectAccount = new List<Account> ([select id,name ,LastActivityDate,recordtypeid from Account Where recordTypeId = :prospectRecordTypeId Limit 1 ]);
        
        Task task1 = new Task();
        task1.WhatId = listProspectAccount[0].id;
        task1.ActivityDate = Date.today() -400;
        task1.status = 'Completed';
        insert task1;
        DuplicateRule rule = [ SELECT id FROM DuplicateRule WHERE DeveloperName = 'Standard_Account_Duplicate_Rule' LIMIT 1 ];
        DuplicateRecordSet duplicateRecord = new DuplicateRecordSet(duplicateRuleId = rule.id);
        insert duplicateRecord;
        List<DuplicateRecordItem> listDuplicateRecordItems = new List<DuplicateRecordItem>();
        for ( Account accountRecord : listCustomerAccount ) 
        {
            listDuplicateRecordItems.add( new DuplicateRecordItem(duplicateRecordSetId = duplicateRecord.id,recordId = accountRecord.id));
        }
        for ( Account accountRecord : listProspectAccount ) 
        {
            listDuplicateRecordItems.add( new DuplicateRecordItem(duplicateRecordSetId = duplicateRecord.id,recordId = accountRecord.id));
        }
        insert listDuplicateRecordItems;
        Database.executeBatch(new WT_AccountMergeBatch());
        Test.stopTest();
        System.assertEquals(2, [select count() from Account Where recordTypeId = :prospectRecordTypeId AND isdeleted = false]);
    }
    
    /*------------ Different owner ----------------*/
    
    static testMethod void validate1PACustomerDiffOwner() 
    {   
        List<Account> listCustomerAccount = new List<Account> ([select id,name ,LastActivityDate,recordtypeid from Account Where recordTypeId = :customerRecordTypeId Limit 1 ]);      
        List<Account> listProspectAccount = new List<Account> ([select id,OwnerId,recordtypeid from Account Where recordTypeId = :prospectRecordTypeId ]);        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User usr = new User(Alias = 'stdtes', Email='standarduser123@barringtonbank.com', 
                            EmailEncodingKey='UTF-8', LastName='Test12345', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = p.Id, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='stdtest12345@test1.com');
        insert usr ;       
        System.runAs(usr)
        {            
            listProspectAccount[0].OwnerId = usr.id;
            update listProspectAccount[0];
        }    
        Test.startTest();
        DuplicateRule rule = [ SELECT id FROM DuplicateRule  WHERE DeveloperName = 'Standard_Account_Duplicate_Rule' LIMIT 1 ];       
        DuplicateRecordSet duplicateRecord = new DuplicateRecordSet(duplicateRuleId = rule.id);      
        insert duplicateRecord;
        List<DuplicateRecordItem> listDuplicateRecordItems = new List<DuplicateRecordItem>();
        for ( Account accountRecord : listCustomerAccount ) 
        {
            listDuplicateRecordItems.add( new DuplicateRecordItem(duplicateRecordSetId = duplicateRecord.id,recordId = accountRecord.id));
        }        
        for ( Account accountRecord : listProspectAccount ) 
        {
            listDuplicateRecordItems.add( new DuplicateRecordItem(duplicateRecordSetId = duplicateRecord.id,recordId = accountRecord.id));
        }
        insert listDuplicateRecordItems;
        Database.executeBatch(new WT_AccountMergeBatch());
        Test.stopTest();       
        System.assertEquals(0, [select count() from Account Where recordTypeId = :prospectRecordTypeId AND isdeleted = false]);      
    }
    
    static testMethod void validate1PACustomerSameOwner() 
    {   
        List<Account> listCustomerAccount = new List<Account> ([select id, OwnerId , recordtypeid from Account Where recordTypeId = :customerRecordTypeId Limit 1]);      
        List<Account> listProspectAccount = new List<Account> ([select id, OwnerId ,recordtypeid from Account Where recordTypeId = :prospectRecordTypeId]);
        User userRecord = WT_DataFactory.createUser('System Administrator');
        insert userRecord;   
        System.runAs(userRecord)
        {            
            listProspectAccount[0].OwnerId = userRecord.id;
            listCustomerAccount[0].OwnerId = userRecord.id;
            update listProspectAccount[0];
            update listCustomerAccount[0];
        }    
        Test.startTest();
        DuplicateRule rule = [ SELECT id FROM DuplicateRule WHERE DeveloperName = 'Standard_Account_Duplicate_Rule' LIMIT 1 ];       
        DuplicateRecordSet duplicateRecord = new DuplicateRecordSet(duplicateRuleId = rule.id);      
        insert duplicateRecord;
        List<DuplicateRecordItem> listDuplicateRecordItems = new List<DuplicateRecordItem>();
        for ( Account accountRecord : listCustomerAccount ) 
        {
            listDuplicateRecordItems.add( new DuplicateRecordItem(duplicateRecordSetId = duplicateRecord.id, recordId = accountRecord.id));
        }        
        for ( Account accountRecord : listProspectAccount ) 
        {
            listDuplicateRecordItems.add( new DuplicateRecordItem(duplicateRecordSetId = duplicateRecord.id,recordId = accountRecord.id));
        }
        insert listDuplicateRecordItems;
        Database.executeBatch(new WT_AccountMergeBatch());
        Test.stopTest();       
        System.assertEquals(0, [select count() from Account Where recordTypeId = :prospectRecordTypeId AND isdeleted = false]);   
    }
    
    static testMethod void validate3ProspectDifferentOwner() 
    {
        Test.startTest();
        Account accountRecords5 = new Account(lastname = 'Test1',type = 'Prospect',RecordTypeId = prospectRecordTypeId);
        Account accountRecords6 = new Account(lastname = 'Test1',type = 'Prospect',RecordTypeId = prospectRecordTypeId);
        List<Account> listProspectAccount = new List<Account> ();
        listProspectAccount.add(accountRecords5);
        listProspectAccount.add(accountRecords6);
        User userRecord = WT_DataFactory.createUser('System Administrator');
        insert userRecord;   
        System.runAs(userRecord)
        {
            insert listProspectAccount;
            Task task1 = new Task(WhatId = listProspectAccount[0].id,ActivityDate = Date.today() -800,status = 'Completed');
            insert task1;
            Task task2 = new Task(WhatId = listProspectAccount[1].id,ActivityDate = Date.today() -700,status = 'Completed');
            insert task2;
        }
        
        Account accountRecord7 = new Account(lastname = 'Test1',type = 'Prospect',RecordTypeId = prospectRecordTypeId);
        insert accountRecord7;
        Task task3 = new Task(WhatId = accountRecord7.Id,ActivityDate = Date.today() -800,status = 'Completed');
        insert task3;
        
        DuplicateRule rule = [ SELECT id FROM DuplicateRule WHERE DeveloperName = 'Standard_Account_Duplicate_Rule' LIMIT 1 ];
        DuplicateRecordSet duplicateRecord = new DuplicateRecordSet(duplicateRuleId = rule.id);
        insert duplicateRecord;
        List<DuplicateRecordItem> listDuplicateRecordItems = new List<DuplicateRecordItem>();
        for ( Account accountRecord : listProspectAccount ) 
        {
            listDuplicateRecordItems.add( new DuplicateRecordItem(duplicateRecordSetId = duplicateRecord.id,recordId = accountRecord.id));
        }
        listDuplicateRecordItems.add( new DuplicateRecordItem(duplicateRecordSetId = duplicateRecord.id,recordId = accountRecord7.id));
        insert listDuplicateRecordItems;
        Database.executeBatch(new WT_AccountMergeBatch());
        Test.stopTest();
        System.assertEquals(4, [select count() from Account Where recordTypeId = :prospectRecordTypeId AND isdeleted = false]);
    }
    
    @isTest static void runBatchAccountMergeSchedule()
    {
        Test.StartTest();
        WT_AccountMergeBatchSchedule batchemergeSchedule = new WT_AccountMergeBatchSchedule();
        String scheduleTime = '0 0 23 * * ?'; 
        system.schedule('Test Business Unit scheduler', scheduleTime, batchemergeSchedule); 
        Test.stopTest(); 
    }

    @isTest
    static void TestEmailNotification()
    {        
        WT_AccountMergeBatch accountMergeBatchClass = new WT_AccountMergeBatch();
        List<Account> listAccount = [SELECT Id, Name
                                    FROM Account LIMIT 1]; 
        Map<Id, String> mapAccountIdAndStringMessage = new Map<Id, String>();
        mapAccountIdAndStringMessage.put(listAccount[0].Id, 'Test');
        
        accountMergeBatchClass.SendEmailNotification(mapAccountIdAndStringMessage);
    }
}