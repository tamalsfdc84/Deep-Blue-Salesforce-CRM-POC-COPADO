/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name			WT_DataFactory
* @Author			Sivaranjani 	<sivaranjani.d2@tcs.com.tcsdev>	
* @ModifiedBy		Sivaranjani 	<sivaranjani.d2@tcs.com.tcsdev>
* @version 		v1.0 
* @CreatedDate		11-18-2020
* @UsedBy			All object , to create test data 
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* Data factory for all test classes
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Changes
* vx.x				<user id>
* MM-DD-YYYY		<Explanation> 
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
//test Classes: WT_DataFactory_T
public abstract class WT_DataFactory 
{    
    //WT_Business_Unit_Entity_Staging__c record creation 
    Public Static WT_Business_Unit_Entity_Staging__c createBusinessUnitEntityStagging()
    {
        WT_Business_Unit_Entity_Staging__c businessUnitStagingRecord = new WT_Business_Unit_Entity_Staging__c();
        businessUnitStagingRecord.WT_Bank_Number__c = '118';
        businessUnitStagingRecord.WT_Branch_Number__c ='2';
        businessUnitStagingRecord.WT_New_Customers__c = 4;
        businessUnitStagingRecord.WT_Total_Foot_Traffic__c = 112.0;
        businessUnitStagingRecord.WT_Foot_Traffic_Level__c = 'H';
        businessUnitStagingRecord.WT_Market__c = 'TestA';
        businessUnitStagingRecord.WT_Fusion_Location__c  = 'TestAL';
        businessUnitStagingRecord.WT_Factor__c   = 0.9999;
         
        Return businessUnitStagingRecord;
    }
    Public Static WT_Business_Unit_Entity_Staging__c createBusinessUnitEntityStagging2()
    {
        WT_Business_Unit_Entity_Staging__c businessUnitStagingRecord = new WT_Business_Unit_Entity_Staging__c();
        businessUnitStagingRecord.WT_Bank_Number__c = '118';
        businessUnitStagingRecord.WT_Branch_Number__c = '3';
        businessUnitStagingRecord.WT_New_Customers__c = 4;
        businessUnitStagingRecord.WT_Total_Foot_Traffic__c = 112.0;
        businessUnitStagingRecord.WT_Foot_Traffic_Level__c = 'H';
        businessUnitStagingRecord.WT_Market__c = 'TestA';
        businessUnitStagingRecord.WT_Fusion_Location__c  = 'TestAL';
        businessUnitStagingRecord.WT_Factor__c   = 0.9999;         
        Return businessUnitStagingRecord;
    }
     //WT_Business_Unit_Entity_Staging__c WTFC record creation 
     Public Static WT_Business_Unit_Entity_Staging__c createBusinessUnitEntityStaggingWTFC()
     {
         WT_Business_Unit_Entity_Staging__c businessUnitStagingRecordWTFC = new WT_Business_Unit_Entity_Staging__c();
         businessUnitStagingRecordWTFC.WT_Bank_Number__c = 'WTFC';
         businessUnitStagingRecordWTFC.WT_Branch_Number__c = 'WTFC';
         businessUnitStagingRecordWTFC.WT_New_Customers__c = 1700;
         businessUnitStagingRecordWTFC.WT_Total_Foot_Traffic__c = 112.0;
         businessUnitStagingRecordWTFC.WT_Foot_Traffic_Level__c = 'H';
         businessUnitStagingRecordWTFC.WT_Factor__c   = 0.9999;        
                  
         Return businessUnitStagingRecordWTFC;
     }
    //WT_Business_Unit_Entity__c record creation 
    Public Static WT_Business_Unit_Entity__c createBusinessUnitEntity()
    {
        WT_Business_Unit_Entity__c businessUnitRecord = new WT_Business_Unit_Entity__c();
        businessUnitRecord.WT_Bank_Number__c = '118';
        businessUnitRecord.WT_Branch_Number__c ='2';
        businessUnitRecord.WT_New_Customers__c = 3;
        businessUnitRecord.WT_Total_Foot_Traffic__c = 110.0;
        businessUnitRecord.WT_Unique_Key__c = '118-2';
        businessUnitRecord.WT_Foot_Traffic_Level__c = 'L';
        businessUnitRecord.WT_Market__c  = 'TestB';
        businessUnitRecord.WT_Fusion_Location__c = 'TestBL';
        businessUnitRecord.WT_WM_Branch_Factor__c = 0.1111;
        Return businessUnitRecord;
    }
    //WT_Business_Unit_Entity__c record creation 
    Public Static WT_Business_Unit_Entity__c createBusinessUnitEntityWTFC()
    {
        WT_Business_Unit_Entity__c businessUnitRecordWTFC = new WT_Business_Unit_Entity__c();
        businessUnitRecordWTFC.WT_Bank_Number__c = 'WTFC';
        businessUnitRecordWTFC.WT_Branch_Number__c ='WTFC';
        businessUnitRecordWTFC.WT_New_Customers__c = 3;
        businessUnitRecordWTFC.WT_Total_Foot_Traffic__c = 110.0;
        businessUnitRecordWTFC.WT_Unique_Key__c = 'WTFC-WTFC';
        businessUnitRecordWTFC.WT_Foot_Traffic_Level__c = 'L';
        businessUnitRecordWTFC.WT_Market__c  = 'TestW';
        businessUnitRecordWTFC.WT_Fusion_Location__c = 'TestBW';
        businessUnitRecordWTFC.WT_WM_Branch_Factor__c = 0.1111;
        Return businessUnitRecordWTFC;
    }
    // case record creation 
    public Static Case caseRecordCreation()
    {
        Case caseRecord = new Case();
        caseRecord.Type='Deposit Application';
        caseRecord.Status='Submitted';
        Return caseRecord;
    }
    //Person Accounts record creation
    public static List<Account> createAccounts(Integer numberOfAccounts, String recordTypeName,Id userId)
    {
        List<Account> listAccounts = New List<Account>();
        Account accountRecord;
        for(integer i=0;i<numberOfAccounts;i++)
        {
            accountRecord = new account();
            accountRecord.FirstName = 'First Name';
            accountRecord.LastName = 'Last Name';
            accountRecord.BillingStreet = 'Test'+i;
            accountRecord.BillingState = 'OH';
            accountRecord.BillingCity = 'Chicago';
            accountRecord.BillingCountry = 'United States';
            accountRecord.BillingPostalCode = '12345';
            accountRecord.PersonHomePhone = '1122334455';
            accountRecord.ownerid = userId ;
            if(String.isNotEmpty(recordTypeName))
            {
                accountRecord.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(recordTypeName).getRecordTypeId();
            }
            listAccounts.add(accountRecord);
        }
        return listAccounts;
    }
    //Krupa added
     public static List<Lead> createLead(Integer numberOfLead,Id user1Id, Id user2Id, Id user3Id)
    {
        List<Lead> listLead = New List<Lead>();
        for(integer i=0;i<numberOfLead;i++)
        { 
            Lead leadRecord = new Lead();
            leadRecord.LastName = 'Test Job1';
            leadRecord.OwnerId = user1Id;
            leadRecord.WT_Referred_To__c = user2Id;
            leadRecord.Phone = '6789878987';
            leadRecord.WT_Account_Referred_Email__c = 'fgfg@gmail.com';
            leadRecord.FinServ__ReferredByUser__c = user3Id;
            leadRecord.FinServ__ExpressedInterest__c = 'Retail Banking';
            listLead.add(leadRecord);
        }
        return listLead;
    }
   public static List<Opportunity> createOppty(Integer numberOfOppties)
    {
     List<Opportunity> optyList = new List<Opportunity>();
     Opportunity optyRecord;
        for(integer i=0;i<numberOfOppties;i++){}
        {  
           optyRecord = new Opportunity();   
           optyRecord.Name ='00New mAWS Deal';
           //optyRecord.AccountID =aList[0].id,
           optyRecord.StageName = 'Customer Won';
           optyRecord.Amount = 2000;
           optyRecord.CloseDate = Date.today() - 10;
           optyList.add(optyRecord); 
        
    }
        return optyList;
    }
    // non person account creation 
    public static List<Account> createNonPersonAccounts(Integer numberOfAccounts, String recordTypeName,Id userId)
    {
        List<Account> listAccounts = New List<Account>();
        Account accountRecord;
        for(integer i=0;i<numberOfAccounts;i++)
        {
            accountRecord = new account();
            accountRecord.Name = 'Account Name '+i;
            accountRecord.BillingStreet = 'Test';
            accountRecord.BillingState = 'Illinois';
            accountRecord.BillingCity = 'Chicago';
            accountRecord.BillingCountry = 'United States';
            accountRecord.BillingPostalCode = '12345';
            accountRecord.Phone = '1122334455';
            accountRecord.ownerid = userId ;
            if(String.isNotEmpty(recordTypeName))
            {
                accountRecord.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(recordTypeName).getRecordTypeId();
            }
            listAccounts.add(accountRecord);
        }
        return listAccounts;
    }
    // custom setting record creation 
    public static void createRequiredCustomSetting()
    {
        WT_Switch_Settings__c switchRecord = new WT_Switch_Settings__c();
        switchRecord.WT_Is_Process_Builder_Active__c=true;
        switchRecord.WT_Is_Trigger_Active__c=true;
        switchRecord.WT_Is_Validation_Rule_Active__c=true;
        switchRecord.WT_Is_Workflow_Rule_Active__c=true;
        Database.insert(switchRecord,false);
    }
    // user record creation
    public static user createUser(String profileName) 
    {
        Profile profileRecord = [SELECT id, Name FROM Profile  WHERE Name=: profileName];
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        User userRec = new User();
        userRec.ProfileId = profileRecord.id;
        userRec.FirstName = 'TestFirst1';
        userRec.LastName = 'Testlast1';
        userRec.email = uniqueName + '@wintrust.com';
        userRec.username = uniqueName + '@test' + orgId + '.org';
        userRec.Alias = 'wintrust';        
        userRec.TimeZoneSidKey = 'America/Los_Angeles';
        userRec.languagelocalekey='en_US';
        userRec.emailencodingkey='UTF-8';
        userRec.localesidkey='en_US';
        return userRec;
    }
    // event record creation 
    public static List<Event> createEventRecords(Integer numberOfEvents, String recordTypeName){
        List<Event> listEvents = New List<Event>();
        Event eventRecord;
        for(integer i=0;i<numberOfEvents;i++)
        {	
            eventRecord = new Event(subject = 'Meeting'+i,WT_Status__c='Open',ActivityDateTime=System.now()+1,DurationInMinutes=30);
            if(String.isNotEmpty(recordTypeName))
            {
                eventRecord.RecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByDeveloperName().get(recordTypeName).getRecordTypeId();
            }
            listEvents.add(eventRecord);
        }
        return listEvents;
    }
    // task record creation
    public static List<Task> createTaskRecords(Integer numberOfTasks, String recordTypeName){
        List<Task> listTasks = New List<Task>();
        Task taskRecord;
        for(integer i=0;i<numberOfTasks;i++)
        {            
            taskRecord = new Task(subject = 'Meeting'+i,Status='Open',Priority='Normal',CallType='Outbound',ActivityDate=Date.today());
            if(String.isNotEmpty(recordTypeName))
            {
                taskRecord.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get(recordTypeName).getRecordTypeId();
            }
            listTasks.add(taskRecord);
        }
        return listTasks;
    } 
     // Activity Extension records creation
    public static List<WT_Activity_Extension__c> createActivityExtRecords(Integer numberOfExtRecords){
        List<WT_Activity_Extension__c> createActivityExtRecords = New List<WT_Activity_Extension__c>();
        WT_Activity_Extension__c activityExtRecord;
        for(integer i=0;i<numberOfExtRecords;i++)
        {            
            activityExtRecord = new WT_Activity_Extension__c(WT_14Day_TMOnboarding_Call__c = 'Yes',WT_Admin_Attendees__c='Test'+i,WT_Dashboard_Comments__c='TestComment');
            createActivityExtRecords.add(activityExtRecord);
        }
        return createActivityExtRecords;
    }
}