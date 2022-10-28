/**
* -----------------------------------------------------------------------------------------------------------------------------------------
* @Name           WT_TestSetupHelper
* @Author         Himanshu Patel
* @ModifiedBy     Himanshu Patel
* @Version        v1.0
* @CreatedDate    05-17-2021
* @UsedBy         Test classes
* @TestClass      WT_TestSetupHelper_T
* -----------------------------------------------------------------------------------------------------------------------------------------
* @Description
* This class serves as a test data bank. It has methods that takes in specific attributes and returns the object
* -----------------------------------------------------------------------------------------------------------------------------------------
* @Changes
* -----------------------------------------------------------------------------------------------------------------------------------------
**/
public class WT_TestSetupHelper 
{
/**
* -----------------------------------------------------------------------------------------------------------------------------------------
* @Description
* Method to return an instance of an Account
* -----------------------------------------------------------------------------------------------------------------------------------------
* @param     recordTypeName     				String attribute for record type name
* @return    Account   							An instance a test Account
* -----------------------------------------------------------------------------------------------------------------------------------------
**/
	public static Account GetAccount(String recordTypeName)
    {
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
        
        Account testAccount = new Account();
        testAccount.RecordTypeId = recordTypeId;
        testAccount.FirstName = 'TesterFirstName';
        testAccount.MiddleName = 'TesterMiddleName';
        testAccount.LastName = 'TesterLastName';
        testAccount.PersonAssistantPhone = '1111111111';
        testAccount.Phone = '2222222222';
        testAccount.PersonHomePhone = '3333333333';
        testAccount.PersonMobilePhone = '4444444444';
        testAccount.PersonOtherPhone = '5555555555';
        testAccount.PersonEmail = 'test@test.com';
        testAccount.FinServ__Status__c = 'Active';
        testAccount.FinServ__TaxId__pc = '123121234';
        testAccount.BillingStreet = '123 Test St';
        testAccount.BillingCity = 'Salt Lake City';
        testAccount.BillingState = 'UT';
        testAccount.BillingPostalCode = '84123';
        testAccount.BillingCountry = 'USA';
        
        return testAccount;
    }
    
/**
* -----------------------------------------------------------------------------------------------------------------------------------------
* @Description
* Method to return an instance of a Financial Account
* -----------------------------------------------------------------------------------------------------------------------------------------
* @param     recordTypeName     				String attribute for record type name
* @param     primaryOwnerAccountId     				Person Account Id attribute for Primary Owner of the Financial Account
* @param     jointOwnerAccountId     				Person Account Id attribute for Joint Owner of the Financial Account
* @return    Account   							An instance a test Financial Account
* -----------------------------------------------------------------------------------------------------------------------------------------
**/
    public static FinServ__FinancialAccount__c GetFinancialAccount(String recordTypeName, Id primaryOwnerAccountId, Id jointOwnerAccountId)
    {
        Id recordTypeId = Schema.SObjectType.FinServ__FinancialAccount__c.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
        
        FinServ__FinancialAccount__c testFinancialAccount = new FinServ__FinancialAccount__c();
        testFinancialAccount.RecordTypeId = recordTypeId;
        testFinancialAccount.Name = 'Financial Account Name';
        testFinancialAccount.FinServ__PrimaryOwner__c = primaryOwnerAccountId;
        testFinancialAccount.FinServ__JointOwner__c = jointOwnerAccountId;
        testFinancialAccount.FinServ__FinancialAccountNumber__c = '123456';
        testFinancialAccount.FinServ__Balance__c = 123123.12;
        testFinancialAccount.FinServ__Status__c = 'Open';
        
        return testFinancialAccount;
    }
    
    /**
* -----------------------------------------------------------------------------------------------------------------------------------------
* @Description
* Method to return an instance of a User
* -----------------------------------------------------------------------------------------------------------------------------------------
* @param     firstName     				First Name of the test user
* @param     lastName     				Last Name of the test user
* @param     email     					Email of the test user
* @param     userName     				User Name of the test user
* @param     profileName     			Profile Name of the test user
* @return    User   					An instance a test User
* -----------------------------------------------------------------------------------------------------------------------------------------
**/
    public static User GetUser(String firstName, String lastName, String email, String userName, String profileName)
    {
        List<Profile> listProfile = [SELECT Id, Name
                                     FROM Profile
                                     WHERE Name =: profileName];
        User newUser = new User();
        newUser.ProfileId = listProfile[0].Id;
        newUser.Email = email;
        newUser.UserName = userName;
        newUser.alias = 'test1';
        newUser.CommunityNickName = 'testUser1';        
        newUser.TimeZoneSidKey = 'America/New_York';
        newUser.LocaleSidKey = 'en_US';
        newUser.EmailEncodingKey = 'ISO-8859-1';        
        newUser.LanguageLocaleKey = 'en_US';
        newUser.FirstName = firstName;
        newUser.LastName = lastName;
        newUser.Phone = '5555555555';
        newUser.MobilePhone = '5555555555';
        
        return newUser;
    }

    /**
* -----------------------------------------------------------------------------------------------------------------------------------------
* @Description
* Method to return an instance of a WT_Switch_Settings__c
* -----------------------------------------------------------------------------------------------------------------------------------------
* @return    WT_Switch_Settings__c   					An instance a test WT_Switch_Settings__c
* -----------------------------------------------------------------------------------------------------------------------------------------
**/    
    public static WT_Switch_Settings__c GetCustomSetting()
    {
        WT_Switch_Settings__c switchRecord = new WT_Switch_Settings__c();
        switchRecord.WT_Is_Process_Builder_Active__c = true;
        switchRecord.WT_Is_Trigger_Active__c = true;
        switchRecord.WT_Is_Validation_Rule_Active__c = true;
        switchRecord.WT_Is_Workflow_Rule_Active__c = true;
        
        return switchRecord;
    }
    
/**
* -----------------------------------------------------------------------------------------------------------------------------------------
* @Description
* Method to return an instance of a Lead
* -----------------------------------------------------------------------------------------------------------------------------------------
* @return    Lead   					An instance a test Lead
* -----------------------------------------------------------------------------------------------------------------------------------------
**/    
    public static Lead GetReferral(Id personAccountId, String status, Id referredToUserId)
    {
        Lead referralRecord = new Lead();
        referralRecord.LastName = 'Test';
        referralRecord.FinServ__ReferredByUser__c = UserInfo.getUserId();
        referralRecord.FinServ__ExpressedInterest__c = 'Retail Banking';
        referralRecord.Status = status;
        referralRecord.WT_Referred_To__c = referredToUserId;
        referralRecord.FinServ__RelatedAccount__c = personAccountId;
        referralRecord.WT_Date_Referred__c = System.today();
        
        return referralRecord;
    }
}