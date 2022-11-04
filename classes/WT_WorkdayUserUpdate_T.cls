/**
 * -------------------------------------------------------------------------------------------------------------------------------------------------
 * @Name      WT_WorkdayUserUpdate_T
 * @Author Sita Sakhinetipalli  <SSakhinetipalli@wintrust.com>
 * @ModifiedBy Sita Sakhinetipalli <SSakhinetipalli@wintrust.com> 
 * @version     v1.0 
 * @CreatedDate    2-1-2022
 * ---------------------------------------------------------------------------------------------------------------------------------------------------
 * @Description 
 * Class is used as test class for WT_WorkdayUserUpdate
 * ---------------------------------------------------------------------------------------------------------------------------------------------------
 * FUNCTIONAL TEST LOGIC
 * 1- runBatchWorkdayUserUpdate() 
 *   > used to test the insert/update of of User records
 * ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
@isTest
public class WT_WorkdayUserUpdate_T {
    @isTest 
    static void runBatchWorkdayUserUpdate()
    {
        List<WT_WorkdayUserUpdate.FusionFeedRecord> listFusionFeedRecords = new List<WT_WorkdayUserUpdate.FusionFeedRecord>();
        WT_WorkdayUserUpdate.FusionFeedRecord fusionFeedRecord = new WT_WorkdayUserUpdate.FusionFeedRecord();
        fusionFeedRecord.empNumber = '101';
        fusionFeedRecord.firstName = 'Sita';
        fusionFeedRecord.lastName = 'Sakhinetipalli';
        fusionFeedRecord.emailAddress = 'user000@wintrust.com';
        fusionFeedRecord.crmBank = '118';
        fusionFeedRecord.crmBranch = '118001';
        fusionFeedRecord.empstatus = 'inactive';
        listFusionFeedRecords.Add(fusionFeedRecord);
        string requestString = JSON.serialize(listFusionFeedRecords);
        
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/WorkdayFeed/User/';
        request.httpMethod = 'POST';
        request.requestBody= BLOb.valueOf(requestString);
        
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;
        //Test.startTest();
        //string responseString = WT_FusionFeedUpdate.doPost();
        WT_WorkdayUserUpdate.doPost();
        String responseString = RestContext.response.responseBody.toString();
        WT_WorkdayUserUpdate.ResponseModel responseModel = (WT_WorkdayUserUpdate.ResponseModel)JSON.deserialize(responseString,WT_WorkdayUserUpdate.ResponseModel.class);
        //Test.stopTest();
        System.assertEquals(responseModel.IsSuccess,true);
    }
    @istest
    static void runFusionFeedUpdateEmptyRequest()
    {
        List<WT_WorkdayUserUpdate.FusionFeedRecord> listFusionFeedRecordsEmpty = new List<WT_WorkdayUserUpdate.FusionFeedRecord>();
        string requestStringEmpty = JSON.serialize(listFusionFeedRecordsEmpty);
        
        RestRequest requestEmpty = new RestRequest();
        requestEmpty.requestURI = '/services/apexrest/WorkdayFeed/User/';
        requestEmpty.httpMethod = 'POST';
        requestEmpty.requestBody= BLOb.valueOf(requestStringEmpty);
        
        RestResponse responseEmpty = new RestResponse();
        RestContext.request = requestEmpty;
        RestContext.response = responseEmpty;
        WT_WorkdayUserUpdate.doPost();
        String responseStringEmpty = RestContext.response.responseBody.toString();
        WT_WorkdayUserUpdate.ResponseModel responseModelEmpty = (WT_WorkdayUserUpdate.ResponseModel)JSON.deserialize(responseStringEmpty,WT_WorkdayUserUpdate.ResponseModel.class);
        //Empty Response
        System.assertEquals(responseModelEmpty.Message, 'No records were found to process');
    }
    @TestSetup
    static void testSetUpUser()
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
        TimeZoneSidKey = 'America/Los_Angeles',
        EmailEncodingKey = 'UTF-8',
        LanguageLocaleKey = 'en_US',
        IsActive = true,
        LocaleSidKey = 'en_US');
        insert userTest;
    }

}