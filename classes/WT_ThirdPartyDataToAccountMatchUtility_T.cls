@isTest
public class WT_ThirdPartyDataToAccountMatchUtility_T 
{
    @TestSetup
    static void setup()
    {
        Id businessAccountProspectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('BusinessAccount_Prospect').getRecordTypeId();
        List<Account> listAccountToInsert = New List<Account>();
        
        Account newAccount = new Account();
        newAccount.Name = 'Test 1';
        newAccount.BillingStreet = '123 W Main St Suite 200';
        newAccount.BillingState = 'UT';
        newAccount.BillingCity = 'Salt Lake City';
        newAccount.BillingCountry = 'United States';
        newAccount.BillingPostalCode = '84096';
        newAccount.Phone = '1112223333';
        newAccount.RecordTypeId = businessAccountProspectRecordTypeId;
        listAccountToInsert.add(newAccount);
        
        Account newInfoUsaAccount = new Account();
        newInfoUsaAccount.Name = 'Test InfoUSAId';
        newInfoUsaAccount.BillingStreet = '123 InfoUsa';
        newInfoUsaAccount.BillingState = 'UT';
        newInfoUsaAccount.BillingCity = 'Salt Lake City';
        newInfoUsaAccount.BillingCountry = 'United States';
        newInfoUsaAccount.BillingPostalCode = '84096';
        newInfoUsaAccount.Phone = '1112223333';
        newInfoUsaAccount.RecordTypeId = businessAccountProspectRecordTypeId;
        newInfoUsaAccount.WT_InfoUSA_Prospect_ID__c = '96358';
        listAccountToInsert.add(newInfoUsaAccount);
        
        Account newDunsAccount = new Account();
        newDunsAccount.Name = 'Test Duns';
        newDunsAccount.BillingStreet = '123 InfoUsa';
        newDunsAccount.BillingState = 'UT';
        newDunsAccount.BillingCity = 'Salt Lake City';
        newDunsAccount.BillingCountry = 'United States';
        newDunsAccount.BillingPostalCode = '84096';
        newDunsAccount.Phone = '1112223333';
        newDunsAccount.RecordTypeId = businessAccountProspectRecordTypeId;
        newDunsAccount.WT_DUNS_Number__c = '562785';
        listAccountToInsert.add(newDunsAccount);
        
        Id[] arraySearchResults= new Id[3];
        arraySearchResults[0] = listAccountToInsert[0].Id;
        arraySearchResults[1] = listAccountToInsert[1].Id;
        arraySearchResults[2] = listAccountToInsert[2].Id;
        Test.setFixedSearchResults(arraySearchResults);
        
        insert listAccountToInsert;
    }
    
    @isTest
    static void testInfoUSAIdMatch()
    {
        Test.startTest();
        List<WT_Third_Party_Data__c> listThirdPartyDataToInsert = new List<WT_Third_Party_Data__c>();
        WT_Third_Party_Data__c newThirdPartyData = new WT_Third_Party_Data__c();
        newThirdPartyData.Name = 'Test';
        newThirdPartyData.WT_Primary_Address__c = '123 W Main St';
        newThirdPartyData.WT_Primary_City__c = 'Salt Lake City';
        newThirdPartyData.WT_Primary_state__c = 'UT';
        newThirdPartyData.WT_Primary_Zip_Code__c = '84096';
        newThirdPartyData.WT_Country_Region__c = 'United States';
        newThirdPartyData.WT_INFOUSAID__c = '96358';
        newThirdPartyData.WT_Employees_Single_Site__c = '888';
        newThirdPartyData.WT_Revenue_USD__c = 5000;
        listThirdPartyDataToInsert.add(newThirdPartyData);
        
        insert listThirdPartyDataToInsert;
        
        Account relatedAccount = [SELECT Id,
                                  WT_Annual_Revenue_InfoUSA__c,
                                  WT_Employees_InfoUSA__c,
                                  WT_Primary_Contact_Name_InfoUSA__c,
                                  WT_Primary_Email_InfoUSA__c,
                                  WT_InfoUSA_Prospect_ID__c
                                  FROM Account
                                  WHERE WT_InfoUSA_Prospect_ID__c = '96358'
                                  LIMIT 1];
        
        System.assertEquals(newThirdPartyData.WT_Revenue_USD__c, relatedAccount.WT_Annual_Revenue_InfoUSA__c);
        System.assertEquals(Integer.valueOf(newThirdPartyData.WT_Employees_Single_Site__c), relatedAccount.WT_Employees_InfoUSA__c);
        System.assertEquals(newThirdPartyData.WT_INFOUSAID__c, relatedAccount.WT_InfoUSA_Prospect_ID__c);
        System.assertEquals(newThirdPartyData.WT_Contact_Name__c, relatedAccount.WT_Primary_Contact_Name_InfoUSA__c);
        System.assertEquals(newThirdPartyData.WT_Email__c, relatedAccount.WT_Primary_Email_InfoUSA__c);
        
        WT_Third_Party_Data__c relatedThirdPartyData = [SELECT Id,
                                                        WT_Account__c
                                                        FROM WT_Third_Party_Data__c
                                                        LIMIT 1];
        
        System.assertEquals(relatedAccount.Id, relatedThirdPartyData.WT_Account__c);
        
        Test.stopTest();
    }
    
    @isTest
    static void testDunsIdMatch()
    {
        Test.startTest();
        List<WT_Third_Party_Data__c> listThirdPartyDataToInsert = new List<WT_Third_Party_Data__c>();
        WT_Third_Party_Data__c newThirdPartyData = new WT_Third_Party_Data__c();
        newThirdPartyData.Name = 'Test';
        newThirdPartyData.WT_Primary_Address__c = '123 W Main St';
        newThirdPartyData.WT_Primary_City__c = 'Salt Lake City';
        newThirdPartyData.WT_Primary_state__c = 'UT';
        newThirdPartyData.WT_Primary_Zip_Code__c = '84096';
        newThirdPartyData.WT_Country_Region__c = 'United States';
        newThirdPartyData.WT_D_U_N_S_Number__c = '562785';
        newThirdPartyData.WT_Employees_Single_Site__c = '888';
        newThirdPartyData.WT_Revenue_USD__c = 6000;
        listThirdPartyDataToInsert.add(newThirdPartyData);
        
        insert listThirdPartyDataToInsert;
        
        Account relatedAccount = [SELECT Id,
                                  WT_Annual_Revenue_DNB__c,
                                  WT_Primary_Contact_Name_DNB__c,
                                  WT_Primary_Email_DNB__c,
                                  WT_DUNS_Number__c
                                  FROM Account
                                  WHERE WT_DUNS_Number__c = '562785'
                                  LIMIT 1];
        
        System.assertEquals(newThirdPartyData.WT_Revenue_USD__c, relatedAccount.WT_Annual_Revenue_DNB__c);
        System.assertEquals(newThirdPartyData.WT_D_U_N_S_Number__c, relatedAccount.WT_DUNS_Number__c);
        System.assertEquals(newThirdPartyData.WT_Contact_Name__c, relatedAccount.WT_Primary_Contact_Name_DNB__c);
        System.assertEquals(newThirdPartyData.WT_Email__c, relatedAccount.WT_Primary_Email_DNB__c);
        
        WT_Third_Party_Data__c relatedThirdPartyData = [SELECT Id,
                                                        WT_Account__c
                                                        FROM WT_Third_Party_Data__c
                                                        LIMIT 1];
        
        System.assertEquals(relatedAccount.Id, relatedThirdPartyData.WT_Account__c);
        
        Test.stopTest();
    }
    
    @isTest
    static void testAddressWithName85PercentMatch()
    {
        Test.startTest();
        Account relatedAccount = [SELECT Id,
                                  WT_Annual_Revenue_InfoUSA__c,
                                  WT_Employees_InfoUSA__c,
                                  WT_Primary_Contact_Name_InfoUSA__c,
                                  WT_Primary_Email_InfoUSA__c,
                                  WT_InfoUSA_Prospect_ID__c
                                  FROM Account
                                  LIMIT 1];
        
        Id[] arraySearchResults= new Id[1];
        arraySearchResults[0] = relatedAccount.Id;
        Test.setFixedSearchResults(arraySearchResults);
        
        List<WT_Third_Party_Data__c> listThirdPartyDataToInsert = new List<WT_Third_Party_Data__c>();
        WT_Third_Party_Data__c newThirdPartyData = new WT_Third_Party_Data__c();
        newThirdPartyData.Name = 'Test';
        newThirdPartyData.WT_Primary_Address__c = '123 W Main St Suite 200';
        newThirdPartyData.WT_Primary_City__c = 'Salt Lake City';
        newThirdPartyData.WT_Primary_state__c = 'UT';
        newThirdPartyData.WT_Primary_Zip_Code__c = '84096';
        newThirdPartyData.WT_Country_Region__c = 'United States';
        newThirdPartyData.WT_INFOUSAID__c = '1234';
        newThirdPartyData.WT_Employees_Single_Site__c = '504';
        newThirdPartyData.WT_Revenue_USD__c = 500;
        listThirdPartyDataToInsert.add(newThirdPartyData);
        
        insert listThirdPartyDataToInsert;
        
        relatedAccount = [SELECT Id,
                          WT_Annual_Revenue_InfoUSA__c,
                          WT_Employees_InfoUSA__c,
                          WT_Primary_Contact_Name_InfoUSA__c,
                          WT_Primary_Email_InfoUSA__c,
                          WT_InfoUSA_Prospect_ID__c
                          FROM Account
                          LIMIT 1];
        
        System.assertEquals(newThirdPartyData.WT_Revenue_USD__c, relatedAccount.WT_Annual_Revenue_InfoUSA__c);
        System.assertEquals(Integer.valueOf(newThirdPartyData.WT_Employees_Single_Site__c), relatedAccount.WT_Employees_InfoUSA__c);
        System.assertEquals(newThirdPartyData.WT_INFOUSAID__c, relatedAccount.WT_InfoUSA_Prospect_ID__c);
        System.assertEquals(newThirdPartyData.WT_Contact_Name__c, relatedAccount.WT_Primary_Contact_Name_InfoUSA__c);
        System.assertEquals(newThirdPartyData.WT_Email__c, relatedAccount.WT_Primary_Email_InfoUSA__c);
        
        WT_Third_Party_Data__c relatedThirdPartyData = [SELECT Id,
                                                        WT_Account__c
                                                        FROM WT_Third_Party_Data__c
                                                        LIMIT 1];
        
        System.assertEquals(relatedAccount.Id, relatedThirdPartyData.WT_Account__c);
        
        Test.stopTest();
    }
    
    @isTest
    static void testAddressWithName85PercentAddress85PercentAndPhoneMatch()
    {
        Test.startTest();
        Account relatedAccount = [SELECT Id,
                                  WT_Annual_Revenue_InfoUSA__c,
                                  WT_Employees_InfoUSA__c,
                                  WT_Primary_Contact_Name_InfoUSA__c,
                                  WT_Primary_Email_InfoUSA__c,
                                  WT_InfoUSA_Prospect_ID__c
                                  FROM Account
                                  LIMIT 1];
        
        Id[] arraySearchResults= new Id[1];
        arraySearchResults[0] = relatedAccount.Id;
        Test.setFixedSearchResults(arraySearchResults);
        
        List<WT_Third_Party_Data__c> listThirdPartyDataToInsert = new List<WT_Third_Party_Data__c>();
        WT_Third_Party_Data__c newThirdPartyData = new WT_Third_Party_Data__c();
        newThirdPartyData.Name = 'Test 1';
        newThirdPartyData.WT_Primary_Address__c = '123 W Main St Suite 20';
        newThirdPartyData.WT_Primary_City__c = 'Salt Lake City';
        newThirdPartyData.WT_Primary_state__c = 'UT';
        newThirdPartyData.WT_Primary_Zip_Code__c = '84096';
        newThirdPartyData.WT_Country_Region__c = 'United States';
        newThirdPartyData.WT_PHONE__c = '1112223333';
        newThirdPartyData.WT_INFOUSAID__c = '1234';
        newThirdPartyData.WT_Employees_Single_Site__c = '504';
        listThirdPartyDataToInsert.add(newThirdPartyData);
        
        insert listThirdPartyDataToInsert;
        
        relatedAccount = [SELECT Id,
                          WT_Annual_Revenue_InfoUSA__c,
                          WT_Employees_InfoUSA__c,
                          WT_Primary_Contact_Name_InfoUSA__c,
                          WT_Primary_Email_InfoUSA__c,
                          WT_InfoUSA_Prospect_ID__c
                          FROM Account
                          LIMIT 1];
        
        System.assertEquals(newThirdPartyData.WT_Revenue_USD__c, relatedAccount.WT_Annual_Revenue_InfoUSA__c);
        System.assertEquals(Integer.valueOf(newThirdPartyData.WT_Employees_Single_Site__c), relatedAccount.WT_Employees_InfoUSA__c);
        System.assertEquals(newThirdPartyData.WT_INFOUSAID__c, relatedAccount.WT_InfoUSA_Prospect_ID__c);
        System.assertEquals(newThirdPartyData.WT_Contact_Name__c, relatedAccount.WT_Primary_Contact_Name_InfoUSA__c);
        System.assertEquals(newThirdPartyData.WT_Email__c, relatedAccount.WT_Primary_Email_InfoUSA__c);
        
        WT_Third_Party_Data__c relatedThirdPartyData = [SELECT Id,
                                                        WT_Account__c
                                                        FROM WT_Third_Party_Data__c
                                                        LIMIT 1];
        
        System.assertEquals(relatedAccount.Id, relatedThirdPartyData.WT_Account__c);
        Test.stopTest();
    }
    
    @isTest
    static void testNoMatchInfoUsa()
    {
        Test.startTest();
        List<WT_Third_Party_Data__c> listThirdPartyDataToInsert = new List<WT_Third_Party_Data__c>();
        WT_Third_Party_Data__c newThirdPartyData = new WT_Third_Party_Data__c();
        newThirdPartyData.Name = 'Test123';
        newThirdPartyData.WT_Primary_Address__c = '123 W Main St';
        newThirdPartyData.WT_Primary_City__c = 'Salt Lake City';
        newThirdPartyData.WT_Primary_state__c = 'UT';
        newThirdPartyData.WT_Primary_Zip_Code__c = '84096';
        newThirdPartyData.WT_Country_Region__c = 'United States';
        newThirdPartyData.WT_PHONE__c = '1112223333';
        newThirdPartyData.WT_INFOUSAID__c = '1234';
        newThirdPartyData.WT_Employees_Single_Site__c = '504';
        listThirdPartyDataToInsert.add(newThirdPartyData);
        
        insert listThirdPartyDataToInsert;
        
        Account relatedAccount = [SELECT Id,
                                  WT_Annual_Revenue_InfoUSA__c,
                                  WT_Employees_InfoUSA__c,
                                  WT_Primary_Contact_Name_InfoUSA__c,
                                  WT_Primary_Email_InfoUSA__c,
                                  WT_InfoUSA_Prospect_ID__c
                                  FROM Account
                                  WHERE WT_InfoUSA_Prospect_ID__c = :newThirdPartyData.WT_INFOUSAID__c
                                  LIMIT 1];
        
        System.assertEquals(newThirdPartyData.WT_Revenue_USD__c, relatedAccount.WT_Annual_Revenue_InfoUSA__c);
        System.assertEquals(Integer.valueOf(newThirdPartyData.WT_Employees_Single_Site__c), relatedAccount.WT_Employees_InfoUSA__c);
        System.assertEquals(newThirdPartyData.WT_INFOUSAID__c, relatedAccount.WT_InfoUSA_Prospect_ID__c);
        System.assertEquals(newThirdPartyData.WT_Contact_Name__c, relatedAccount.WT_Primary_Contact_Name_InfoUSA__c);
        System.assertEquals(newThirdPartyData.WT_Email__c, relatedAccount.WT_Primary_Email_InfoUSA__c);
        
        WT_Third_Party_Data__c relatedThirdPartyData = [SELECT Id,
                                                        WT_Account__c
                                                        FROM WT_Third_Party_Data__c
                                                        LIMIT 1];
        
        System.assertEquals(relatedAccount.Id, relatedThirdPartyData.WT_Account__c);
        Test.stopTest();
    }
    
    @isTest
    static void testNoMatchDuns()
    {
        Test.startTest();
        List<WT_Third_Party_Data__c> listThirdPartyDataToInsert = new List<WT_Third_Party_Data__c>();
        WT_Third_Party_Data__c newThirdPartyData = new WT_Third_Party_Data__c();
        newThirdPartyData.WT_Primary_Address__c = '123 W Main St';
        newThirdPartyData.WT_Primary_City__c = 'Salt Lake City';
        newThirdPartyData.WT_Primary_state__c = 'UT';
        newThirdPartyData.WT_Primary_Zip_Code__c = '84096';
        newThirdPartyData.WT_Country_Region__c = 'United States';
        newThirdPartyData.WT_PHONE__c = '1112223333';
        newThirdPartyData.WT_D_U_N_S_Number__c = '1234';
        newThirdPartyData.WT_Employees_Single_Site__c = '504';
        listThirdPartyDataToInsert.add(newThirdPartyData);
        
        insert listThirdPartyDataToInsert;
        
        Account relatedAccount = [SELECT Id,
                                  WT_Annual_Revenue_InfoUSA__c,
                                  WT_Employees_InfoUSA__c,
                                  WT_Primary_Contact_Name_InfoUSA__c,
                                  WT_Primary_Email_InfoUSA__c,
                                  WT_DUNS_Number__c
                                  FROM Account
                                  WHERE WT_DUNS_Number__c = :newThirdPartyData.WT_D_U_N_S_Number__c
                                  LIMIT 1];
        
        System.assertEquals(newThirdPartyData.WT_Revenue_USD__c, relatedAccount.WT_Annual_Revenue_InfoUSA__c);
        System.assertEquals(newThirdPartyData.WT_D_U_N_S_Number__c, relatedAccount.WT_DUNS_Number__c);
        System.assertEquals(newThirdPartyData.WT_Contact_Name__c, relatedAccount.WT_Primary_Contact_Name_InfoUSA__c);
        System.assertEquals(newThirdPartyData.WT_Email__c, relatedAccount.WT_Primary_Email_InfoUSA__c);
        
        WT_Third_Party_Data__c relatedThirdPartyData = [SELECT Id,
                                                        WT_Account__c
                                                        FROM WT_Third_Party_Data__c
                                                        LIMIT 1];
        
        System.assertEquals(relatedAccount.Id, relatedThirdPartyData.WT_Account__c);
        Test.stopTest();
    }
    
    @isTest
    static void testStringCompare()
    {
        Test.startTest();
        Boolean areMatch1 = WT_ThirdPartyDataToAccountMatchUtility.GetAreStrings85PercentFuzzyMatch('', '');
        System.assertEquals(true, areMatch1);
        
        Boolean areMatch2 = WT_ThirdPartyDataToAccountMatchUtility.GetAreStrings85PercentFuzzyMatch('Test', 'Test');
        System.assertEquals(true, areMatch2);
        
        Boolean areMatch3 = WT_ThirdPartyDataToAccountMatchUtility.GetAreStrings85PercentFuzzyMatch('Test', 'Tes');
        System.assertEquals(false, areMatch3);
        
        Boolean areMatch4 = WT_ThirdPartyDataToAccountMatchUtility.GetAreStrings85PercentFuzzyMatch('TestTest', 'TestTes');
        System.assertEquals(true, areMatch4);
        Test.stopTest();
    }
}