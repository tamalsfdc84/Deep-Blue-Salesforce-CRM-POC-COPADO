@isTest

public class WT_AccountMergeBatch_Test 
{
    @testSetup static void setUpData() 
    {
        List<account> dupList = new List<account>();
        Account acc1 = new Account();
        acc1.lastname = 'Test1';
        acc1.type = 'Prospect';
        acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Prospect').getRecordTypeId();
        
        Account acc2 = new Account();
        acc2.lastname = 'Test1';
        acc2.type = 'Prospect';
        acc2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Prospect').getRecordTypeId();
        
        Account acc3 = new Account();
        acc3.lastname = 'Test1';
        acc3.type = 'customer';
        acc3.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Customer').getRecordTypeId();
        
        Account acc4 = new Account();
        acc4.lastname = 'Test1';
        acc4.type = 'customer';
        acc4.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Customer').getRecordTypeId();
        
        dupList.add(acc1);
        dupList.add(acc2);
        dupList.add(acc3);
        dupList.add(acc4);
        insert dupList;
        
        
        Task task1 = new Task();
        task1.WhatId = dupList[0].id;
        task1.ActivityDate = Date.today() -800;
        task1.status = 'Completed';
        insert task1;
        
        Task task2= new Task();
        task2.WhatId = dupList[1].id;
        task2.ActivityDate = Date.today() -800;
        task2.status = 'Completed';
        insert task2;
        
        Task task3= new Task();
        task3.WhatId = dupList[2].id;
        task3.ActivityDate = Date.today() -800;
        task3.status = 'Completed';
        insert task3;
        
        Task task4= new Task();
        task4.WhatId = dupList[3].id;
        task4.ActivityDate = Date.today() -800;
        task4.status = 'Completed';
        insert task4;
        
        
    }
    
    
    
    static testMethod void validate2PACustomer() 
    {
        
        Test.startTest();
        
        List<Account> PAcusotmers = new List<Account> ([
            select id,
            name ,
            LastActivityDate,
            recordtypeid
            from Account
            Where recordTypeId = :Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Customer').getRecordTypeId()
        ]);
        
        
        List<Account> PAprospects = new List<Account> ([
            select id,
            name ,
            LastActivityDate,
            recordtypeid
            from Account
            Where recordTypeId = :Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Prospect').getRecordTypeId()
        ]);
        
        system.debug('\n !!!!!!!!!!!!!!!! PAcusotmers' + PAcusotmers);
        
        DuplicateRule rule = [ SELECT id FROM DuplicateRule 
                              WHERE DeveloperName = 'WNT_PA_Duplicate_Rule' LIMIT 1 ];
        
        system.debug('RULLLLLLLLLeeee ' +rule.id);
        
        //Database.SaveResult[] sr = Database.insert(contacts, insertDML);        
        DuplicateRecordSet drs = new DuplicateRecordSet(
            duplicateRuleId = rule.id
        );
        
        insert drs;
        
        system.debug('>>>>>>>>>>>>' +drs);
        
        List<DuplicateRecordItem> items = new List<DuplicateRecordItem>();
        
        for ( Account acctemp : PAcusotmers ) {
            items.add( new DuplicateRecordItem(
                duplicateRecordSetId = drs.id,
                recordId = acctemp.id
            ));
        }
        
        for ( Account acctemp : PAprospects ) {
            items.add( new DuplicateRecordItem(
                duplicateRecordSetId = drs.id,
                recordId = acctemp.id
            ));
        }
        system.debug('\n items' + items);
        insert items;
        
        Database.executeBatch(new WT_AccountMergeBatch());
        
        Test.stopTest();
        
        System.assertEquals(0, [
            select count()
            from Account
            Where recordTypeId = :Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Prospect').getRecordTypeId() 
            AND isdeleted = false
        ]);
        
    }
    
    static testMethod void validate2PACustomer1Prospect() 
    {
        
        Test.startTest();
        
        List<Account> PAcusotmers = new List<Account> ([
            select id,
            name ,
            LastActivityDate,
            recordtypeid
            from Account
            Where recordTypeId = :Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Customer').getRecordTypeId()
        ]);
        
        
        List<Account> PAprospects = new List<Account> ([
            select id,
            name ,
            LastActivityDate,
            recordtypeid
            from Account
            Where recordTypeId = :Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Prospect').getRecordTypeId()
            Limit 1
        ]);
        
        system.debug('\n !!!!!!!!!!!!!!!! PAcusotmers' + PAcusotmers);
        
        DuplicateRule rule = [ SELECT id FROM DuplicateRule 
                              WHERE DeveloperName = 'WNT_PA_Duplicate_Rule' LIMIT 1 ];
        
        system.debug('RULLLLLLLLLeeee ' +rule.id);
        
        //Database.SaveResult[] sr = Database.insert(contacts, insertDML);        
        DuplicateRecordSet drs = new DuplicateRecordSet(
            duplicateRuleId = rule.id
        );
        
        insert drs;
        
        system.debug('>>>>>>>>>>>>' +drs);
        
        List<DuplicateRecordItem> items = new List<DuplicateRecordItem>();
        
        for ( Account acctemp : PAcusotmers ) {
            items.add( new DuplicateRecordItem(
                duplicateRecordSetId = drs.id,
                recordId = acctemp.id
            ));
        }
        
        for ( Account acctemp : PAprospects ) {
            items.add( new DuplicateRecordItem(
                duplicateRecordSetId = drs.id,
                recordId = acctemp.id
            ));
        }
        system.debug('\n items' + items);
        insert items;
        
        Database.executeBatch(new WT_AccountMergeBatch());
        
        Test.stopTest();
        
        System.assertEquals(1, [
            select count()
            from Account
            Where recordTypeId = :Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Prospect').getRecordTypeId() 
            AND isdeleted = false
        ]);
        
    }
    
    
    static testMethod void validate1PACustomer() 
    {
        
        Test.startTest();
        
        List<Account> PAcusotmers = new List<Account> ([
            select id,
            name ,
            recordtypeid
            from Account
            Where recordTypeId = :Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Customer').getRecordTypeId()
            Limit 1 
        ]);
        
        
        List<Account> PAprospects = new List<Account> ([
            select id,
            name ,
            recordtypeid
            from Account
            Where recordTypeId = :Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Prospect').getRecordTypeId()
        ]);
        
        system.debug('\n PAcusotmers' + PAcusotmers);
        
        DuplicateRule rule = [ SELECT id FROM DuplicateRule 
                              WHERE DeveloperName = 'WNT_PA_Duplicate_Rule' LIMIT 1 ];
        
        system.debug('RULLLLLLLLLeeee ' +rule.id);
        
        //Database.SaveResult[] sr = Database.insert(contacts, insertDML);        
        DuplicateRecordSet drs = new DuplicateRecordSet(
            duplicateRuleId = rule.id
        );
        
        insert drs;
        
        system.debug('>>>>>>>>>>>>' +drs);
        
        List<DuplicateRecordItem> items = new List<DuplicateRecordItem>();
        
        for ( Account acctemp : PAcusotmers ) {
            items.add( new DuplicateRecordItem(
                duplicateRecordSetId = drs.id,
                recordId = acctemp.id
            ));
        }
        
        for ( Account acctemp : PAprospects ) {
            items.add( new DuplicateRecordItem(
                duplicateRecordSetId = drs.id,
                recordId = acctemp.id
            ));
        }
        system.debug('\n items' + items);
        insert items;
        
        Database.executeBatch(new WT_AccountMergeBatch());
        
        Test.stopTest();
        
        System.assertEquals(0, [
            select count()
            from Account
            Where recordTypeId = :Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Prospect').getRecordTypeId() 
            AND isdeleted = false
        ]);
        
    }
    
    static testMethod void validate2PAProspect() 
    {
        
        Test.startTest();
        
        List<Account> PAcusotmers = new List<Account> ([
            select id,
            name ,
            recordtypeid
            from Account
            Where recordTypeId = :Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Customer').getRecordTypeId()
        ]);
        
        
        List<Account> PAprospects = new List<Account> ([
            select id,
            name ,
            recordtypeid
            from Account
            Where recordTypeId = :Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Prospect').getRecordTypeId()
        ]);
        
        system.debug('\n prospects' + PAprospects);
        
        DuplicateRule rule = [ SELECT id FROM DuplicateRule 
                              WHERE DeveloperName = 'WNT_PA_Duplicate_Rule' LIMIT 1 ];
        
        system.debug('RULLLLLLLLLeeee ' +rule.id);
        
        //Database.SaveResult[] sr = Database.insert(contacts, insertDML);        
        DuplicateRecordSet drs = new DuplicateRecordSet(
            duplicateRuleId = rule.id
        );
        
        insert drs;
        
        system.debug('>>>>>>>>>>>>' +drs);
        
        List<DuplicateRecordItem> items = new List<DuplicateRecordItem>();
        
        for ( Account acctemp : PAprospects ) {
            items.add( new DuplicateRecordItem(
                duplicateRecordSetId = drs.id,
                recordId = acctemp.id
            ));
        }
        system.debug('\n items' + items);
        insert items;
        
        Database.executeBatch(new WT_AccountMergeBatch());
        
        Test.stopTest();
        
        System.assertEquals(1, [
            select count()
            from Account
            Where recordTypeId = :Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Prospect').getRecordTypeId() 
            AND isdeleted = false
        ]);
        
    }
    
    //------------------------------------------------------------------Fail tests
    
    
    static testMethod void validate2PACustomerInvalid() 
    {
        
        
        
        Test.startTest();
        
        List<Account> PAcusotmers = new List<Account> ([
            select id,
            name ,
            recordtypeid
            from Account
            Where recordTypeId = :Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Customer').getRecordTypeId()
        ]);
        
        
        List<Account> PAprospects = new List<Account> ([
            select id,
            name ,
            recordtypeid
            from Account
            Where recordTypeId = :Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Prospect').getRecordTypeId()
        ]);
        
        Task task1 = new Task();
        task1.WhatId = PAprospects[0].id;
        task1.ActivityDate = Date.today() -400;
        task1.status = 'Completed';
        insert task1;
        
        Task task2= new Task();
        task2.WhatId = PAprospects[1].id;
        task2.ActivityDate = Date.today() -400;
        task2.status = 'Completed';
        insert task2;
        
        system.debug('\n PAcusotmers' + PAcusotmers);
        
        DuplicateRule rule = [ SELECT id FROM DuplicateRule 
                              WHERE DeveloperName = 'WNT_PA_Duplicate_Rule' LIMIT 1 ];
        
        system.debug('RULLLLLLLLLeeee ' +rule.id);
        
        //Database.SaveResult[] sr = Database.insert(contacts, insertDML);        
        DuplicateRecordSet drs = new DuplicateRecordSet(
            duplicateRuleId = rule.id
        );
        
        insert drs;
        
        system.debug('>>>>>>>>>>>>' +drs);
        
        List<DuplicateRecordItem> items = new List<DuplicateRecordItem>();
        
        for ( Account acctemp : PAcusotmers ) {
            items.add( new DuplicateRecordItem(
                duplicateRecordSetId = drs.id,
                recordId = acctemp.id
            ));
        }
        
        for ( Account acctemp : PAprospects ) {
            items.add( new DuplicateRecordItem(
                duplicateRecordSetId = drs.id,
                recordId = acctemp.id
            ));
        }
        system.debug('\n items' + items);
        insert items;
        
        Database.executeBatch(new WT_AccountMergeBatch());
        
        Test.stopTest();
        
        System.assertEquals(2, [
            select count()
            from Account
            Where recordTypeId = :Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Prospect').getRecordTypeId() 
            AND isdeleted = false
        ]);
        
    }
    
    static testMethod void validate1PACustomerInvalid() 
    {
        
        Test.startTest();
        
        List<Account> PAcusotmers = new List<Account> ([
            select id,
            name ,
            recordtypeid
            from Account
            Where recordTypeId = :Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Customer').getRecordTypeId()
            Limit 1 
        ]);
        
        
        List<Account> PAprospects = new List<Account> ([
            select id,
            name ,
            recordtypeid
            from Account
            Where recordTypeId = :Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Prospect').getRecordTypeId()
        ]);
        
        
        Task task1 = new Task();
        task1.WhatId = PAprospects[0].id;
        task1.ActivityDate = Date.today();
        task1.status = 'Completed';
        insert task1;
        
        Task task2= new Task();
        task2.WhatId = PAprospects[1].id;
        task2.ActivityDate = Date.today();
        task2.status = 'Completed';
        insert task2;
        system.debug('\n PAcusotmers' + PAcusotmers);
        
        DuplicateRule rule = [ SELECT id FROM DuplicateRule 
                              WHERE DeveloperName = 'WNT_PA_Duplicate_Rule' LIMIT 1 ];
        
        system.debug('RULLLLLLLLLeeee ' +rule.id);
        
        //Database.SaveResult[] sr = Database.insert(contacts, insertDML);        
        DuplicateRecordSet drs = new DuplicateRecordSet(
            duplicateRuleId = rule.id
        );
        
        insert drs;
        
        system.debug('>>>>>>>>>>>>' +drs);
        
        List<DuplicateRecordItem> items = new List<DuplicateRecordItem>();
        
        for ( Account acctemp : PAcusotmers ) {
            items.add( new DuplicateRecordItem(
                duplicateRecordSetId = drs.id,
                recordId = acctemp.id
            ));
        }
        
        for ( Account acctemp : PAprospects ) {
            items.add( new DuplicateRecordItem(
                duplicateRecordSetId = drs.id,
                recordId = acctemp.id
            ));
        }
        system.debug('\n items' + items);
        insert items;
        
        Database.executeBatch(new WT_AccountMergeBatch());
        
        Test.stopTest();
        
        System.assertEquals(2, [
            select count()
            from Account
            Where recordTypeId = :Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Prospect').getRecordTypeId() 
            AND isdeleted = false
        ]);
        
    }
    
    static testMethod void validate2PAProspectInvalid() 
    {
        
        Test.startTest();
        
        List<Account> PAcusotmers = new List<Account> ([
            select id,
            name ,
            recordtypeid
            from Account
            Where recordTypeId = :Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Customer').getRecordTypeId()
        ]);
        
        
        List<Account> PAprospects = new List<Account> ([
            select id,
            name ,
            recordtypeid
            from Account
            Where recordTypeId = :Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Prospect').getRecordTypeId()
        ]);
        Task task1 = new Task();
        task1.WhatId = PAprospects[0].id;
        task1.ActivityDate = Date.today() -400;
        task1.status = 'Completed';
        insert task1;
        
        Task task2= new Task();
        task2.WhatId = PAprospects[1].id;
        task2.ActivityDate = Date.today() -400;
        task2.status = 'Completed';
        insert task2;
        system.debug('\n prospects' + PAprospects);
        
        DuplicateRule rule = [ SELECT id FROM DuplicateRule 
                              WHERE DeveloperName = 'WNT_PA_Duplicate_Rule' LIMIT 1 ];
        
        system.debug('RULLLLLLLLLeeee ' +rule.id);
        
        //Database.SaveResult[] sr = Database.insert(contacts, insertDML);        
        DuplicateRecordSet drs = new DuplicateRecordSet(
            duplicateRuleId = rule.id
        );
        
        insert drs;
        
        system.debug('>>>>>>>>>>>>' +drs);
        
        List<DuplicateRecordItem> items = new List<DuplicateRecordItem>();
        
        for ( Account acctemp : PAprospects ) {
            items.add( new DuplicateRecordItem(
                duplicateRecordSetId = drs.id,
                recordId = acctemp.id
            ));
        }
        system.debug('\n items' + items);
        insert items;
        
        Database.executeBatch(new WT_AccountMergeBatch());
        
        Test.stopTest();
        
        //System.assertEquals(2, [
        //    select count()
        //    from Account
        //    Where recordTypeId = :Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Prospect').getRecordTypeId() 
        //    AND isdeleted = false
        //]);
        
    }
    
    
    static testMethod void validate2PACustomer1ProspectInvalid() 
    {
        
        Test.startTest();
        
        List<Account> PAcusotmers = new List<Account> ([
            select id,
            name ,
            LastActivityDate,
            recordtypeid
            from Account
            Where recordTypeId = :Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Customer').getRecordTypeId()
        ]);
        
        
        List<Account> PAprospects = new List<Account> ([
            select id,
            name ,
            LastActivityDate,
            recordtypeid
            from Account
            Where recordTypeId = :Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Prospect').getRecordTypeId()
            Limit 1
        ]);
        
        Task task1 = new Task();
        task1.WhatId = PAprospects[0].id;
        task1.ActivityDate = Date.today() -400;
        task1.status = 'Completed';
        insert task1;
        
        
        system.debug('\n !!!!!!!!!!!!!!!! PAcusotmers' + PAcusotmers);
        
        DuplicateRule rule = [ SELECT id FROM DuplicateRule 
                              WHERE DeveloperName = 'WNT_PA_Duplicate_Rule' LIMIT 1 ];
        
        system.debug('RULLLLLLLLLeeee ' +rule.id);
        
        //Database.SaveResult[] sr = Database.insert(contacts, insertDML);        
        DuplicateRecordSet drs = new DuplicateRecordSet(
            duplicateRuleId = rule.id
        );
        
        insert drs;
        
        system.debug('>>>>>>>>>>>>' +drs);
        
        List<DuplicateRecordItem> items = new List<DuplicateRecordItem>();
        
        for ( Account acctemp : PAcusotmers ) {
            items.add( new DuplicateRecordItem(
                duplicateRecordSetId = drs.id,
                recordId = acctemp.id
            ));
        }
        
        for ( Account acctemp : PAprospects ) {
            items.add( new DuplicateRecordItem(
                duplicateRecordSetId = drs.id,
                recordId = acctemp.id
            ));
        }
        system.debug('\n items' + items);
        insert items;
        
        Database.executeBatch(new WT_AccountMergeBatch());
        
        Test.stopTest();
        
        System.assertEquals(2, [
            select count()
            from Account
            Where recordTypeId = :Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Prospect').getRecordTypeId() 
            AND isdeleted = false
        ]);
        
    }
    
    /*------------ Different owner ----------------*/
    static testMethod void validate1PACustomerDiffOwner() 
    {   
        List<Account> PAcusotmers = new List<Account> ([
            select id,
            name ,
            recordtypeid
            from Account
            Where recordTypeId = :Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Customer').getRecordTypeId()
            Limit 1 
        ]);      
        List<Account> PAprospects = new List<Account> ([
            select id,           
            OwnerId ,
            recordtypeid
            from Account
            Where recordTypeId = :Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Prospect').getRecordTypeId()
        ]);        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User usr = new User(Alias = 'stdtes', Email='standarduser123@libertyvillebank.com', 
                            EmailEncodingKey='UTF-8', LastName='Test12345', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = p.Id, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='stdtest12345@test1.com');
        insert usr ;       
        System.runAs(usr)
        {            
            PAprospects[0].OwnerId = usr.id;
            update PAprospects[0];
        }    
        Test.startTest();
        DuplicateRule rule = [ SELECT id FROM DuplicateRule 
                              WHERE DeveloperName = 'WNT_PA_Duplicate_Rule' LIMIT 1 ];       
        DuplicateRecordSet drs = new DuplicateRecordSet(
            duplicateRuleId = rule.id
        );      
        insert drs;
        
        List<DuplicateRecordItem> items = new List<DuplicateRecordItem>();
        
        for ( Account acctemp : PAcusotmers ) {
            items.add( new DuplicateRecordItem(
                duplicateRecordSetId = drs.id,
                recordId = acctemp.id
            ));
        }        
        for ( Account acctemp : PAprospects ) {
            items.add( new DuplicateRecordItem(
                duplicateRecordSetId = drs.id,
                recordId = acctemp.id
            ));
        }
        system.debug('\n items' + items);
        insert items;
        
        Database.executeBatch(new WT_AccountMergeBatch());
        
        Test.stopTest();       
        System.assertEquals(0, [
            select count()
            from Account
            Where recordTypeId = :Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Prospect').getRecordTypeId() 
            AND isdeleted = false
        ]);   
    }
   static testMethod void validate1PACustomerSameOwner() 
    {   
        List<Account> PAcusotmers = new List<Account> ([
            select id,
            OwnerId ,
            recordtypeid
            from Account
            Where recordTypeId = :Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Customer').getRecordTypeId()
            Limit 1 
        ]);      
        List<Account> PAprospects = new List<Account> ([
            select id,           
            OwnerId ,
            recordtypeid
            from Account
            Where recordTypeId = :Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Prospect').getRecordTypeId()
        ]);        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User usr = new User(Alias = 'stdtes', Email='standarduser123@libertyvillebank.com', 
                            EmailEncodingKey='UTF-8', LastName='Test12345', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = p.Id, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='stdtest12345@test1.com');
        insert usr ;       
        System.runAs(usr)
        {            
            PAprospects[0].OwnerId = usr.id;
            PAcusotmers[0].OwnerId = usr.id;
            update PAprospects[0];
            update PAcusotmers[0];
        }    
        Test.startTest();
        DuplicateRule rule = [ SELECT id FROM DuplicateRule 
                              WHERE DeveloperName = 'WNT_PA_Duplicate_Rule' LIMIT 1 ];       
        DuplicateRecordSet drs = new DuplicateRecordSet(
            duplicateRuleId = rule.id
        );      
        insert drs;
        
        List<DuplicateRecordItem> items = new List<DuplicateRecordItem>();
        
        for ( Account acctemp : PAcusotmers ) {
            items.add( new DuplicateRecordItem(
                duplicateRecordSetId = drs.id,
                recordId = acctemp.id
            ));
        }        
        for ( Account acctemp : PAprospects ) {
            items.add( new DuplicateRecordItem(
                duplicateRecordSetId = drs.id,
                recordId = acctemp.id
            ));
        }
        system.debug('\n items' + items);
        insert items;
        
        Database.executeBatch(new WT_AccountMergeBatch());
        
        Test.stopTest();       
        System.assertEquals(0, [
            select count()
            from Account
            Where recordTypeId = :Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Prospect').getRecordTypeId() 
            AND isdeleted = false
        ]);   
    } 
    
}