/**
 * -------------------------------------------------------------------------------------------------------------------------------------------------
 * @Name      WT_FusionFeedUpdate_T
 * @Author Sita Sakhinetipalli  <SSakhinetipalli@wintrust.com>
 * @ModifiedBy Sita Sakhinetipalli <SSakhinetipalli@wintrust.com> 
 * @version     v1.0 
 * @CreatedDate    11-18-2020
 * ---------------------------------------------------------------------------------------------------------------------------------------------------
 * @Description 
 * Class is used as test class for WT_FusionFeedUpdate
 * ---------------------------------------------------------------------------------------------------------------------------------------------------
 * FUNCTIONAL TEST LOGIC
 * 1- runBatchFusionFeedUpdate() 
 *   > used to test the insert/update of Employees and update of User records
 * ----------------------------------------------------------------------------------------------------------------------------------------------------
**/

@isTest
global class WT_FusionFeedUpdate_T
{
    @isTest 
    static void runFusionFeedUpdate()
    {
        List<WT_FusionFeedUpdate.FusionFeedRecord> listFusionFeedRecords = new List<WT_FusionFeedUpdate.FusionFeedRecord>();
        //For Employee update
        WT_Employee__C employee = new WT_Employee__c();
        employee.WT_First_Name__c = 'Sita';
        employee.WT_Last_Name__c = 'Sakhinetipalli';
        employee.WT_Employee_ID__c = '101';
        employee.WT_Email__c = 'user000@wintrust.com';
        employee.WT_Employee_Status__c = 'Active';
        insert employee;
       
        //Update Employee 
        WT_FusionFeedUpdate.FusionFeedRecord fusionFeedRecord = new WT_FusionFeedUpdate.FusionFeedRecord();
        fusionFeedRecord.empNumber = '101';
        fusionFeedRecord.firstName = 'Sita';
        fusionFeedRecord.lastName = 'Sakhinetipalli';
        fusionFeedRecord.emailAddress = 'user000@wintrust.com';
        fusionFeedRecord.crmBank = '118';
        fusionFeedRecord.crmBranch = '118001';
        fusionFeedRecord.locationCode = '111';
        fusionFeedRecord.location = 'BBT';
      
                
        listFusionFeedRecords.add(fusionFeedRecord);
        //Insert Employee
        fusionFeedRecord = new WT_FusionFeedUpdate.FusionFeedRecord();
        fusionFeedRecord.empNumber = '102';
        fusionFeedRecord.firstName = 'Test first name';
        fusionFeedRecord.lastName = 'Test last name';
        fusionFeedRecord.crmBank = '158';
        fusionFeedRecord.crmBranch = '158001';
        fusionFeedRecord.locationCode = '112';
        fusionFeedRecord.location = 'VBT';
        listFusionFeedRecords.add(fusionFeedRecord);
        
        string requestString = JSON.serialize(listFusionFeedRecords);
        
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/FusionFeed/EmployeeAndUser';
        request.httpMethod = 'POST';
        request.requestBody= BLOb.valueOf(requestString);
        
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;
        //Test.startTest();
        //string responseString = WT_FusionFeedUpdate.doPost();
        WT_FusionFeedUpdate.doPost();
        String responseString = RestContext.response.responseBody.toString();
        WT_FusionFeedUpdate.ResponseModel responseModel = (WT_FusionFeedUpdate.ResponseModel)JSON.deserialize(responseString,WT_FusionFeedUpdate.ResponseModel.class);
        //Test.stopTest();
        System.assertEquals(responseModel.IsSuccess,true);
        List<WT_FusionFeedUpdate.EmployeeResponse> EmployeeResponses = new List<WT_FusionFeedUpdate.EmployeeResponse>();
        
        List<WT_FusionFeedUpdate.UserResponse> UserResponses = new List<WT_FusionFeedUpdate.UserResponse>();
        UserResponses = responseModel.UserResponses;
        if(EmployeeResponses.size()>0)
        {
            System.assertEquals(EmployeeResponses[0].errorMessage,'Success');
            System.assertEquals(EmployeeResponses[0].IsUpdate,true);
            
            System.assertEquals(EmployeeResponses[1].errorMessage,'Success');
            System.assertEquals(EmployeeResponses[1].IsInsert,true);
        }
        if(UserResponses.size()>0)
        {
            System.assertEquals(UserResponses[0].errorMessage,'Success');
        }
    }
    
    @istest
    static void runFusionFeedUpdateEmptyRequest()
    {
        List<WT_FusionFeedUpdate.FusionFeedRecord> listFusionFeedRecordsEmpty = new List<WT_FusionFeedUpdate.FusionFeedRecord>();
        //listFusionFeedRecordsEmpty.setData(Collections.<WT_FusionFeedUpdate.FusionFeedRecord>emptyList());
        string requestStringEmpty = JSON.serialize(listFusionFeedRecordsEmpty);
        
        RestRequest requestEmpty = new RestRequest();
        requestEmpty.requestURI = '/services/apexrest/FusionFeed/EmployeeAndUser';
        requestEmpty.httpMethod = 'POST';
        requestEmpty.requestBody= BLOb.valueOf(requestStringEmpty);
        
        RestResponse responseEmpty = new RestResponse();
        RestContext.request = requestEmpty;
        RestContext.response = responseEmpty;
        WT_FusionFeedUpdate.doPost();
        String responseStringEmpty = RestContext.response.responseBody.toString();
        WT_FusionFeedUpdate.ResponseModel responseModelEmpty = (WT_FusionFeedUpdate.ResponseModel)JSON.deserialize(responseStringEmpty,WT_FusionFeedUpdate.ResponseModel.class);
        //Empty Response
        System.assertEquals(responseModelEmpty.Message, 'No records were found to process');
    }
    
    @TestSetup
    static void testSetUpEmployeeUser()
    {
        //For Employee 
        //For User Update
        User userTest = new User(
        ProfileId = '00e3t000001g6DoAAI',
        FirstName = 'Sita',
        LastName = 'Sakhinetipalli',
        Email = 'user000@wintrust.com',
        Username = 'user000@wintrust.com' + System.currentTimeMillis(),
        CompanyName = 'TEST',
        Title = 'title',
        Alias = 'alias',
        FederationIdentifier = '101',
        TimeZoneSidKey = 'America/Los_Angeles',
        EmailEncodingKey = 'UTF-8',
        LanguageLocaleKey = 'en_US',
        LocaleSidKey = 'en_US');
        insert userTest;
             
    }
 }