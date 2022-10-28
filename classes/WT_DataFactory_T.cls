/**
 * -------------------------------------------------------------------------------------------------------------------------------------------------
 * @Name            WT_DataFactory_T
 * @Author          Sivaranjani     <sivaranjani.d2@tcs.com.tcsdev> 
 * @ModifiedBy      Sivaranjani     <sivaranjani.d2@tcs.com.tcsdev>
 * @version         v1.0 
 * @CreatedDate     11-18-2020
 * @UsedBy          All objects , test class for WT_TestDatafactory
 * ---------------------------------------------------------------------------------------------------------------------------------------------------
 * @Description 
 * Class is used to test the WT_TestDataFactory class. Used to cover code on WT_TestDataFactory
 * ---------------------------------------------------------------------------------------------------------------------------------------------------
 * FUNCTIONAL TEST LOGIC
 * 1- runCreateBusinessUnitEntity() 
 *  > used to test the creation of WT_Business_Unit_Entity_Staging__c,WT_Business_Unit_Entity__c using WT_DataFactory
 * ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
@isTest
private class WT_DataFactory_T 
{
    static WT_Business_Unit_Entity_Staging__c businessUnitEntityStagingRecord;
    static WT_Business_Unit_Entity_Staging__c businessUnitEntityStagingRecordWTFC;
    static WT_Business_Unit_Entity__c businessUnitEntityRecord;
    static WT_Business_Unit_Entity__c businessUnitEntityRecordWTFC;
    @isTest static void runCreateBusinessUnitEntity()
    {
        businessUnitEntityStagingRecord = WT_DataFactory.createBusinessUnitEntityStagging();
        insert businessUnitEntityStagingRecord;
        businessUnitEntityStagingRecordWTFC = WT_DataFactory.createBusinessUnitEntityStaggingWTFC();
        insert businessUnitEntityStagingRecordWTFC;
        businessUnitEntityRecord = WT_DataFactory.createBusinessUnitEntity();
        insert businessUnitEntityRecord;
        businessUnitEntityRecordWTFC = WT_DataFactory.createBusinessUnitEntityWTFC();
        insert businessUnitEntityRecordWTFC;
        User userrecord = WT_DataFactory.createUser('System Administrator');
        List<Account> listPersonAccounts = WT_DataFactory.createAccounts(10,'PersonAccount_Prospect',UserInfo.getUserId());
        List<Account> listAccounts = WT_DataFactory.createAccounts(10,'IndustriesBusiness',UserInfo.getUserId());
        WT_DataFactory.createRequiredCustomSetting();
    }  
       @isTest(SeeAllData=true)     
    public static void runCreateCoveragePlan() 
    {        
        User userRecord = WT_DataFactory.createUser('WT Retail');
        insert userRecord;
        List <Account> listNewClassifiedAccount = WT_DataFactory.createNonPersonAccounts(10,'IndustriesBusiness',userRecord.Id);
        for(Account accountRecord: listNewClassifiedAccount)
        {
            accountRecord.WT_Classification__c = 'P1';
        }
        test.startTest();
        insert listNewClassifiedAccount;
        test.stopTest();
        List<ActionPlan> listactionPlanRecords = new List<ActionPlan>();
        listactionPlanRecords = [Select id from actionplan where TargetId in:listNewClassifiedAccount];
        //system.assertNotEquals(0, listactionPlanRecords.size());
    }
    @isTest(SeeAllData=true)     
    public static void runCreateCoveragePlanAccountUpdate() 
    {
        User userRecord = WT_DataFactory.createUser('WT Retail');
        insert userRecord;
        List <Account> listNewClassifiedAccount = WT_DataFactory.createNonPersonAccounts(10,'IndustriesBusiness',userRecord.Id);
        insert listNewClassifiedAccount;
        List<ActionPlan> listactionPlanRecords = new List<ActionPlan>();
        listactionPlanRecords = [Select id from actionplan where TargetId in:listNewClassifiedAccount];
        system.assertEquals(0, listactionPlanRecords.size());
        for(Account accountRecord: listNewClassifiedAccount)
        {
            accountRecord.WT_Classification__c = 'P1';
        }
        test.startTest();
        update listNewClassifiedAccount;
        test.stopTest();
        listactionPlanRecords = [Select id from actionplan where TargetId in:listNewClassifiedAccount];
        //system.assertNotEquals(0, listactionPlanRecords.size());
    }
    @isTest
    public static void runRestrictAccountsMerge() 
    {
        User userRecord = WT_DataFactory.createUser('WT Retail');
        insert userRecord;
        List<Account> listCustomerAccount = WT_DataFactory.createAccounts(1,'PersonAccount_Customer',userRecord.Id);
        insert listCustomerAccount;
        List<Account> listProspectAccount = WT_DataFactory.createAccounts(1,'PersonAccount_Prospect',userRecord.Id);
        insert listProspectAccount;        
        WT_DataFactory.createRequiredCustomSetting();
        try
        {
            test.startTest();
            merge listProspectAccount[0] listCustomerAccount;
            test.stopTest();
        }
        catch(exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains(System.Label.WT_Account_Error_on_Merge) ? true : false;
            system.assertEquals(expectedExceptionThrown,true);
        }        
    }
     @isTest static void runBatchBusinessUnitUpdate()
    {
        WT_Business_Unit_Entity_Staging__c businessUnitStagingRecord =  WT_DataFactory.createBusinessUnitEntityStagging();
        insert businessUnitStagingRecord;
        WT_Business_Unit_Entity_Staging__c businessUnitStagingRecordWTFC =  WT_DataFactory.createBusinessUnitEntityStaggingWTFC();
        insert businessUnitStagingRecordWTFC;
        WT_Business_Unit_Entity__c businessUnitRecord = WT_DataFactory.createBusinessUnitEntity();
        insert businessUnitRecord;
        WT_Business_Unit_Entity__c businessUnitRecordWTFC = WT_DataFactory.createBusinessUnitEntityWTFC();
        insert businessUnitRecordWTFC;
        WT_Business_Unit_Entity_Staging__c businessUnitStagingRecord2 = WT_DataFactory.createBusinessUnitEntityStagging2();
        insert businessUnitStagingRecord2;
        System.assertEquals(businessUnitStagingRecord.WT_Is_Processed__c, false);
        System.assertEquals(businessUnitStagingRecordWTFC.WT_Is_Processed__c, false);
        Test.startTest();
        WT_BatchBusinessUnitUpdate batchBusinessUnitUpdate= new WT_BatchBusinessUnitUpdate();
        Database.executeBatch(batchBusinessUnitUpdate);
        Test.stopTest();
        WT_Business_Unit_Entity_Staging__c businessUnitEntityStagingRecordQuery = [select Id, WT_Is_Processed__c from WT_Business_Unit_Entity_Staging__c where id =: businessUnitStagingRecord.id];
        System.assertEquals(businessUnitEntityStagingRecordQuery.WT_Is_Processed__c, true);
        WT_Business_Unit_Entity_Staging__c businessUnitEntityStagingRecordQuery2 = [select Id, WT_Is_Processed__c from WT_Business_Unit_Entity_Staging__c where id =: businessUnitStagingRecord2.id];
        System.assertEquals(businessUnitEntityStagingRecordQuery2.WT_Is_Processed__c, false);
        
        WT_Business_Unit_Entity_Staging__c businessUnitEntityStagingRecordWTFCQuery = [select Id, WT_Is_Processed__c from WT_Business_Unit_Entity_Staging__c where id =: businessUnitStagingRecordWTFC.id];
        System.assertEquals(businessUnitEntityStagingRecordWTFCQuery.WT_Is_Processed__c, true);
    }
     @isTest static void runBatchBusinessUnitEntityUpdate()
    {
        WT_Business_Unit_Entity_Staging__c businessUnitStagingRecord =  WT_DataFactory.createBusinessUnitEntityStagging();
        insert businessUnitStagingRecord;
        WT_Business_Unit_Entity__c businessUnitRecord = WT_DataFactory.createBusinessUnitEntity();
        insert businessUnitRecord;
            
        System.assertEquals(businessUnitStagingRecord.WT_Is_Processed__c, false);
        Test.startTest();
        WT_BatchBusinessUnitEntityUpdate batchBusinessUnitEntityUpdate= new WT_BatchBusinessUnitEntityUpdate();
        Database.executeBatch(batchBusinessUnitEntityUpdate);
        Test.stopTest();
        
        WT_Business_Unit_Entity_Staging__c businessUnitEntityStagingRecordQuery = [select Id, WT_Is_Processed__c from WT_Business_Unit_Entity_Staging__c where id =: businessUnitStagingRecord.id];
        System.assertEquals(businessUnitEntityStagingRecordQuery.WT_Is_Processed__c, true);
    }
    
      @isTest static void runBatchEventsCacelled()
    {
        List<Event> listEventRecords =  WT_DataFactory.createEventRecords(5,'WT_CRA_Event');
        insert listEventRecords;
        Test.startTest();
        WT_BatchMarkEventsCancelled batchEventsUpdate= new WT_BatchMarkEventsCancelled();
        Database.executeBatch(batchEventsUpdate);
        Test.stopTest();
    }
        @isTest static void runBatchTasksCacelled()
    {
        List<Task> listTaskRecords =  WT_DataFactory.createTaskRecords(5,'WT_Standard_Call');
        insert listTaskRecords;
        Test.startTest();
        WT_BatchMarkTasksCancelled batchTasksUpdate= new WT_BatchMarkTasksCancelled();
        Database.executeBatch(batchTasksUpdate);
        Test.stopTest();
    }
    @isTest
    static void setResolutionTargetTest()
    {
      RecordType complianceRecordType= [select id, developerName, Name from RecordType where Name='Compliance Complaint' and SobjectType='Case'];
      WT_DataFactory.createRequiredCustomSetting();
      Case caseRecord = new Case();
      caseRecord.RecordTypeId=complianceRecordType.Id;
      caseRecord.WT_Exception__c='Complex Issue';
      caseRecord.WT_Date_Received__c=Date.Today();
      caseRecord.WT_Case_Title__c='Test Case';
      caseRecord.WT_Non_Customer_Complainant__c='Test';  
      insert caseRecord;
      caseRecord.WT_Exception__c='';
      update caseRecord;
    }
    @isTest
    static void testValidations()
    { 
      RecordType complianceRecordType= [select id, developerName, Name from RecordType where Name='Compliance Complaint' and SobjectType='Case'];
      WT_DataFactory.createRequiredCustomSetting();
      Case caseRecord = new Case();
      caseRecord.RecordTypeId=complianceRecordType.Id;
      caseRecord.WT_Exception__c='Complex Issue';
      caseRecord.WT_Date_Received__c=Date.Today();
      caseRecord.WT_Case_Title__c='Test Case';
      caseRecord.WT_Non_Customer_Complainant__c='Test'; 
      caseRecord.Status = 'Pending';
      insert caseRecord;
      CaseRecord.Status = 'Resolved';
      try
        {
           update caseRecord; 
        }
        catch(DmlException e)
        {
            System.debug(e.getMessage());
            System.assertEquals('Update failed. First exception on row 0 with id '+ caseRecord.id +'; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, '+System.Label.WT_Error_on_Case_Resolved+': []',e.getMessage());
        }
        WT_Case_Note__c newCaseNote = new WT_Case_Note__c();
        newCaseNote.WT_Case__c = caseRecord.id;
        newCaseNote.WT_Note_Category__c = 'Status Update';
        newCaseNote.WT_Type__c ='Resolving';
        newCaseNote.WT_Notes__c='test';
        insert newCaseNote;
        update caseRecord;
    }
    @isTest
    static void testValidations2()
    { 
      RecordType complianceRecordType= [select id, developerName, Name from RecordType where Name='Compliance Complaint' and SobjectType='Case'];
      WT_DataFactory.createRequiredCustomSetting();
      Case caseRecord = new Case();
      caseRecord.RecordTypeId=complianceRecordType.Id;
      caseRecord.WT_Exception__c='Complex Issue';
      caseRecord.WT_Date_Received__c=Date.Today();
      caseRecord.WT_Case_Title__c='Test Case';
      caseRecord.WT_Non_Customer_Complainant__c='Test'; 
      caseRecord.Status = 'Pending';
      insert caseRecord;
      CaseRecord.Status = 'Cancelled';
      try
        {
           update caseRecord; 
        }
        catch(DmlException e)
        {
            System.debug(e.getMessage());
            System.assertEquals('Update failed. First exception on row 0 with id '+ caseRecord.id +'; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, '+System.Label.WT_Error_on_Cancellation+': []',e.getMessage());
        }
        WT_Case_Note__c newCaseNote = new WT_Case_Note__c();
        newCaseNote.WT_Case__c = caseRecord.id;
        newCaseNote.WT_Note_Category__c = 'Status Update';
        newCaseNote.WT_Type__c ='Cancellation';
        newCaseNote.WT_Notes__c='test';
        insert newCaseNote;
        update caseRecord;
    }
@isTest(SeeAllData=true)
    static void updateEmployeeIndicatorTest()
    {
        WT_DataFactory.createRequiredCustomSetting();
        Account primaryAccount = new Account();
        primaryAccount.FirstName = 'Firstnameone';
        primaryAccount.LastName = 'LastNametest';
        primaryAccount.BillingStreet = 'Test';
        primaryAccount.BillingState = 'OH';
        primaryAccount.BillingCity = 'Chicago';
        primaryAccount.BillingCountry = 'United States';
        primaryAccount.BillingPostalCode = '12345';
        primaryAccount.Phone = '1122334455';
        primaryAccount.ownerid = UserInfo.getUserId();
        primaryAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Customer').getRecordTypeId();
        insert primaryAccount;
        
        String recordTypeId = Schema.SObjectType.FinServ__FinancialAccount__c.getRecordTypeInfosByDeveloperName().get('CheckingAccount').getRecordTypeId();
        FinServ__FinancialAccount__c finAccount1 = new FinServ__FinancialAccount__c();
        finAccount1.WT_Employee_Indicator__c = 'Yes';
        finAccount1.RecordTypeId = recordTypeId;
        finAccount1.FinServ__PrimaryOwner__c = primaryAccount.id;
        insert finAccount1;
        
        Account primaryAccountCheck = [Select id, WT_Employee_Indicator__c from Account where id =: primaryAccount.id];
        //system.assertEquals('Yes', primaryAccountCheck.WT_Employee_Indicator__c);
        
        Account primaryAccount2 = new Account();
        primaryAccount2.FirstName = 'FirstNametwo';
        primaryAccount2.LastName = 'LastNametest';
        primaryAccount2.BillingStreet = 'Test';
        primaryAccount2.BillingState = 'OH';
        primaryAccount2.BillingCity = 'Chicago';
        primaryAccount2.BillingCountry = 'United States';
        primaryAccount2.BillingPostalCode = '12345';
        primaryAccount2.Phone = '1122334455';
        primaryAccount2.ownerid = UserInfo.getUserId();
        primaryAccount2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Customer').getRecordTypeId();
        insert primaryAccount2;
        
        finAccount1.FinServ__PrimaryOwner__c = primaryAccount2.id;
        update finAccount1;
        
        Account primaryAccountCheck2 = [Select id, WT_Employee_Indicator__c from Account where id =: primaryAccount2.id];
        //system.assertEquals('Yes', primaryAccountCheck2.WT_Employee_Indicator__c);
        Account primaryAccountCheck3 = [Select id, WT_Employee_Indicator__c from Account where id =: primaryAccount.id];
        //system.assertEquals('No', primaryAccountCheck3.WT_Employee_Indicator__c);
        
    }
    static testMethod void runLeadShareRecord()
    {
        WT_DataFactory.createRequiredCustomSetting();
        List<User> listUsers = new List<User>();
        User userRecord1 = WT_DataFactory.createUser('System Administrator');
        userRecord1.FirstName = 'Test 123User'; 
        userRecord1.WT_Referrals_Type__c = 'Retail Banking';
        User userRecord2 = WT_DataFactory.createUser('System Administrator');        
        userRecord2.FirstName = 'Test 124User';
        userRecord2.WT_Referrals_Type__c = 'Retail Banking';
        User userRecord3 = WT_DataFactory.createUser('System Administrator');
        userRecord3.WT_Referrals_Type__c = 'Retail Banking';
        userRecord3.FirstName = 'Test 125User';               
        User userRecord4 = WT_DataFactory.createUser('System Administrator');        
        userRecord4.FirstName = 'Test 126User';
        userRecord4.WT_Referrals_Type__c = 'Retail Banking';
        listUsers.add(userRecord1);
        listUsers.add(userRecord2);
        listUsers.add(userRecord3);
        listUsers.add(userRecord4);
        insert listUsers;               
        Id user1Id =userRecord1.Id;
        Id user2Id = userRecord2.Id;
        Id user3Id =userRecord3.Id;
        Id user4Id = userRecord4.Id;
        Lead leadRecord1 = new Lead();
        leadRecord1.LastName = 'Test Job1';
        leadRecord1.OwnerId = user1Id;
        leadRecord1.WT_Referred_To__c = user2Id;
        leadRecord1.FinServ__ReferredByUser__c = user3Id;
        leadRecord1.FinServ__ExpressedInterest__c = 'Retail Banking';
        insert leadRecord1;
        Lead leadRecord2 = new Lead();
        leadRecord2.LastName = 'Test Job2';
        leadRecord2.OwnerId = user1Id;
        leadRecord2.WT_Referred_To__c = user3Id;
        leadRecord2.FinServ__ReferredByUser__c = user4Id;
        leadRecord2.FinServ__ExpressedInterest__c = 'Retail Banking';        
        insert leadRecord2;  
        
        // Query job sharing records.
        List<leadShare> jShrs1 = [SELECT Id, leadId, UserOrGroupId, leadAccessLevel, 
                                 RowCause FROM leadShare WHERE leadId = :leadRecord1.Id AND UserOrGroupId= :user2Id];
        List<leadShare> jShrs2 = [SELECT Id, leadId, UserOrGroupId, leadAccessLevel, 
                                 RowCause FROM leadShare WHERE leadId = :leadRecord2.Id AND UserOrGroupId= :user3Id];
        
        // Test for only one manual share on job.
        System.assertEquals(jShrs1[0].leadId, leadRecord1.Id);
        System.assertEquals(jShrs2[0].leadId, leadRecord2.Id);
                
        leadRecord1.WT_Referred_To__c = User4Id;
        leadRecord1.FinServ__ReferredByUser__c = user2Id;       
        update leadRecord1;
        leadRecord2.WT_Referred_To__c = user1Id;
        update leadRecord2;
        //System.assertEquals();
    } 
}