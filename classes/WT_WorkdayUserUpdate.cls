/**
* ----------------------------------------------------------------------------------------------------------------------------------------------------------------
* @Name WT_WorkdayUserUpdate
* @Author Sita Sakhinetipalli  <SSakhinetipalli@wintrust.com>
* @ModifiedBy Sita Sakhinetipalli <SSakhinetipalli@wintrust.com>
* @Version V1.0
* @Created Date 02/01/2022
* @UsedBy  User
* ----------------------------------------------------------------------------------------------------------------------------------------------------------------
* @Description
* This class will receive Employee data from the .Net middleware in the form of JSon request. It process the request User records.
* It will Upsert Employee records and update User records with the specified fields on the recquirement of User Story of SGE-117 
*----------------------------------------------------------------------------------------------------------------------------------------------------------------
*@Changes
*vX.X  
*MM-DD-YYY <Explaination of the change>
*----------------------------------------------------------------------------------------------------------------------------------------------------------------
**/
@RestResource(urlMapping='/WorkdayFeed/User/*')
global with sharing class WT_WorkdayUserUpdate 
{
/**
* --------------------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* This is a Post method which will accept the request via API call, processes the User records and returns the list of User ID's 
* updated via REST API response back to the calling method which .Net middleware in this case
* --------------------------------------------------------------------------------------------------------------------------------------------------------------
**/
     @HttpPost
    global static void doPost() 
    {
        String requestString = RestContext.request.requestBody.toString();
        List<FusionFeedRecord> listFusionFeedRecords = new List<FusionFeedRecord>();
        List<User> listUsers = new List<User>();
        List<UserResponse> listUserResponses = new List<UserResponse>();
        string returnMsg = '';
        UserResponse userResponse;
        ResponseModel responseModel = new ResponseModel();
        try
        {
            listFusionFeedRecords = (List<FusionFeedRecord>)JSON.deserialize(requestString,List<FusionFeedRecord>.class);
            Map<string,string> mapExistingUsersEmailAndId = new Map<string,string>();
            if( listFusionFeedRecords != null && listFusionFeedRecords.size()>0)
            {
                              
                for(User existingUser : [SELECT Id,FederationIdentifier FROM User])
                {
                    mapExistingUsersEmailAndId.put(existingUser.FederationIdentifier,existingUser.Id);
                }
                
                for(FusionFeedRecord fusionFeedRecord : listFusionFeedRecords)
                {
					if(fusionFeedRecord != null && listFusionFeedRecords.size()>0)
                    {
                       if(mapExistingUsersEmailAndId.containsKey(fusionFeedRecord.empNumber))
                       {
                           User user = new User();
                           user.id = mapExistingUsersEmailAndId.get(fusionFeedRecord.empNumber);
                           if(fusionFeedRecord.empstatus == 'Inactive')
                           {
                               user.IsActive = false;
                           }
                           listUsers.Add(user);
                       }
                    }
                }
                try
                {
                    
                    Database.SaveResult[] saveresultUsers = Database.update(listUsers,false);
                    for (Database.SaveResult saveResultUser : saveresultUsers) 
					{	
                        userResponse = new UserResponse();
                        if (saveResultUser.isSuccess()) 
                        {
                            // Operation was successful, so get the ID of the record that was processed
                            userResponse.UserID  = saveResultUser.getId();
                            userResponse.errorMessage = 'Success';
                            listUserResponses.Add(userResponse);
                        }
                        else 
                        {
                            // Operation failed, so get all errors                
                            for(Database.Error error : saveResultUser.getErrors()) 
                            {
                                userResponse.errorMessage = 'Error Status Code:' + error.getStatusCode() + ' Error Message: ' 
                                    + error.getMessage() + ' User fields that affected this error: ' + error.getFields();
                            }
                        }	
                        listUserResponses.Add(userResponse);
                	}
                    responseModel.Message = 'Successfully updated users';
                    responseModel.IsSuccess = true;
                }
                catch(DMLException ex)
                {
                    responseModel.IsSuccess = false;
                    responseModel.Message += 'ERROR: Error occured while executing DML statements: ' + ex.getMessage();
                }
				responseModel.UserResponses = new List<UserResponse>();
                responseModel.UserResponses = listUserResponses; 
            }
            else
            {
                responseModel.Message = 'No records were found to process';
                responseModel.UserResponses = new List<UserResponse>();
                responseModel.IsSuccess = true;
            }
        }
        catch(Exception ex)
        {
            responseModel.Message += 'ERROR: Update failed with following error: ' + ex.getMessage();
            responseModel.IsSuccess = false;
        }
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(responseModel));
    }
    //Global class to hold Employee Records from Fusion
    global class FusionFeedRecord 
    {
        public string empNumber;
        public string firstName;
        public string middleInitial;
        public string lastName;
        public string locationCode;
        public string location;
        public string division;
        public string emailAddress;
        public string crmBank;
        public string crmBranch;
        public string empStatus;
        public DateTime termDate;
    }
    //Global class to hold Response from the REST API to middleware
    global class ResponseModel
    {
        public String Message;
        public Boolean IsSuccess;
        public List<UserResponse> UserResponses;
    }
    //Global class to hold User related data in the Response
    global class UserResponse
    {
        public string UserID;
        public string errorMessage;
    }
}