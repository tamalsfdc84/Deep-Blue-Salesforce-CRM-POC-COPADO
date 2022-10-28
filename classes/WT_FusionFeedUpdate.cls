/**
* ----------------------------------------------------------------------------------------------------------------------------------------------------------------
* @Name WT_FusionFeedUpdate
* @Author Sita Sakhinetipalli  <SSakhinetipalli@wintrust.com>
* @ModifiedBy Sita Sakhinetipalli <SSakhinetipalli@wintrust.com>
* @Version V1.0
* @Created Date 11/18/2020
* @UsedBy  WT_Employee,User
* ----------------------------------------------------------------------------------------------------------------------------------------------------------------
* @Description
* This class will recieve Employee data from the .Net middleware in the form of JSon request. It process the request into Employee and User records.
* It will Upsert Employee records and update User records with the specified fields on the recquirement of User Story of Sprint 2A - DBSFCRM- 47 and DBSFCRM- 307
*----------------------------------------------------------------------------------------------------------------------------------------------------------------
*@Changes
*vX.X  
*MM-DD-YYY <Explaination of the change>
*----------------------------------------------------------------------------------------------------------------------------------------------------------------
**/
@RestResource(urlMapping='/FusionFeed/EmployeeAndUser/*')
global with sharing class WT_FusionFeedUpdate 
{
/**
* --------------------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* This is a Post method which will accept the request via API call, processes the Employee records and User records and returns the list of Employee ID's 
* Inserted/Updated via REST API response back to the calling method which .Net middleware in this case
* --------------------------------------------------------------------------------------------------------------------------------------------------------------
**/
    @HttpPost
    global static void doPost() 
    {
        String requestString = RestContext.request.requestBody.toString();
        List<FusionFeedRecord> listFusionFeedRecords = new List<FusionFeedRecord>();
        List<WT_Employee__c> listEmployees = new List<WT_Employee__c>();
        List<User> listUsers = new List<User>();
        List<EmployeeResponse> listEmployeeResponses = new List<EmployeeResponse>();
        List<UserResponse> listUserResponses = new List<UserResponse>();
        string returnMsg = '';
        EmployeeResponse employeeResponse;
        UserResponse userResponse;
        ResponseModel responseModel = new ResponseModel();
        try
        {
            listFusionFeedRecords = (List<FusionFeedRecord>)JSON.deserialize(requestString,List<FusionFeedRecord>.class);
            Map<string,string> mapExistingEmployeesFusionIDAndId= new Map<string,string>();
            Map<string,string> mapExistingUsersEmailAndId = new Map<string,string>();
            /*if(listFusionFeedRecords == null)
        	{
            returnMsg = 'requeststring is null ' + requestString;
            }
            else
            {
				returnMsg = 'requeststring is not null ' + listFusionFeedRecords.size();                
            }*/
            if( listFusionFeedRecords != null && listFusionFeedRecords.size()>0)
            {
                //Get a Map of existing Employee records to use for update purpose
                for(WT_Employee__C employee : [Select Id,WT_Employee_ID__c from WT_Employee__c])
                {
                    mapExistingEmployeesFusionIDAndId.put(employee.WT_Employee_ID__c,employee.Id);
                    
                }
                
                for(User existingUser : [SELECT Id,email FROM User])
                {
                    mapExistingUsersEmailAndId.put(existingUser.email,existingUser.Id);
                    
                }
                
                for(FusionFeedRecord fusionFeedRecord : listFusionFeedRecords)
                {
					returnMsg = returnMsg + 'inside for';
                    if(fusionFeedRecord != null && listFusionFeedRecords.size()>0)
                    {
                        
                       WT_Employee__c employee = new WT_Employee__c();
                       if(mapExistingEmployeesFusionIDAndId.containsKey(fusionFeedRecord.empNumber))
                       {
                           employee.ID = mapExistingEmployeesFusionIDAndId.get(fusionFeedRecord.empNumber);
                       }
                       if(mapExistingUsersEmailAndId.containsKey(fusionFeedRecord.emailAddress))
                       {
                           employee.WT_User_Exist__c = true;
                           User user = new User();
                           user.id = mapExistingUsersEmailAndId.get(fusionFeedRecord.emailAddress);
                           user.WT_Employee_ID__c = fusionFeedRecord.empNumber;
                           user.WT_Location_Code__c = fusionFeedRecord.locationCode;
                           user.WT_Location__c = fusionFeedRecord.location;
                           user.WT_Bank__c = fusionFeedRecord.crmBank;
                           user.WT_Branch__c = fusionFeedRecord.crmBranch;
                           listUsers.Add(user);
                           //userResponse.EmployeeID  =fusionFeedRecord.empNumber;
                           //listUserResponses.Add(userResponse);
                           //returnMsg = returnMsg + fusionFeedRecord.empNumber + employee.ID + fusionFeedRecord.firstName;
                       }
                       else
                       {
                           employee.WT_User_Exist__c = false;
                           //returnMsg = returnMsg + 'map user' + mapExistingUsersEmailAndId;
                       }
                       employee.WT_Employee_ID__c = fusionFeedRecord.empNumber;
                       employee.WT_First_Name__c = fusionFeedRecord.firstName;
                       employee.WT_Middle_Initial__c = fusionFeedRecord.middleInitial;
                       employee.WT_Last_Name__c = fusionFeedRecord.lastName;
                       employee.WT_Location_Code__c = fusionFeedRecord.locationCode;
                       employee.WT_Location__c = fusionFeedRecord.location;
                       employee.WT_Division__c = fusionFeedRecord.division;
                       employee.WT_Email__c = fusionFeedRecord.emailAddress;
                       employee.WT_Bank__c = fusionFeedRecord.crmBank;
                       employee.WT_Branch__c = fusionFeedRecord.crmBranch;
                       employee.WT_Employee_Status__c = fusionFeedRecord.empStatus;
                       employee.Name = fusionFeedRecord.firstName + ' ' + fusionFeedRecord.lastName;
                       listEmployees.Add(employee);
                    }
                }
                try
                {
                    Database.UpsertResult[] saveResultEmployees = Database.upsert(listEmployees,false); 
                    Database.SaveResult[] saveresultUsers = Database.update(listUsers,false);
                    for (Database.UpsertResult saveResultEmployee : saveResultEmployees) 
					{			
                         employeeResponse = new EmployeeResponse();
                         
                        if (saveResultEmployee.isSuccess()) 
                        {
                            // Operation was successful, so get the ID of the record that was processed
                            employeeResponse.EmployeeID = saveResultEmployee.getId();
                            
                            employeeResponse.errorMessage = 'Success';
                            if(saveResultEmployee.isCreated() == true)
                            {
                                employeeResponse.IsInsert = true;
                                employeeResponse.IsUpdate = false;
                            }
                            else
                            {
                                employeeResponse.IsUpdate = true;
                                employeeResponse.IsInsert = false;
                            }
                        }
                        else 
                        {
                            // Operation failed, so get all errors                
                            for(Database.Error error : saveResultEmployee.getErrors()) 
                            {
                                employeeResponse.errorMessage = 'Error Status Code:' + error.getStatusCode() + ' Error Message: '  
                                    + error.getMessage() +' Employee fields that affected this error: ' + error.getFields();
                            }
                        }	
                        listEmployeeResponses.Add(employeeResponse);
                	}
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
                    responseModel.Message = 'Successfully updated users and Employees';
                    responseModel.IsSuccess = true;
                }
                catch(DMLException ex)
                {
                    responseModel.IsSuccess = false;
                    responseModel.Message += 'ERROR: Error occured while executing DML statements: ' + ex.getMessage();
                }
				responseModel.EmployeeResponses = new List<EmployeeResponse>();
                responseModel.EmployeeResponses = listEmployeeResponses;
                responseModel.UserResponses = new List<UserResponse>();
                responseModel.UserResponses = listUserResponses; 
                //returnMsg = 'success';
            }
            else
            {
                responseModel.Message = 'No records were found to process';
                responseModel.EmployeeResponses = new List<EmployeeResponse>();
                responseModel.UserResponses = new List<UserResponse>();
                responseModel.IsSuccess = true;
            }
        }
        catch(Exception ex)
        {
            responseModel.Message += 'ERROR: Update failed with following error: ' + ex.getMessage();
            responseModel.IsSuccess = false;
            //returnMsg = 'ERROR: Update failed with following error: ' + ex.getMessage();
        }
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(responseModel));
        //return returnMsg;
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
        public List<EmployeeResponse> EmployeeResponses;
        public List<UserResponse> UserResponses;
    }
    //Global class to hold Employee related data in the Response
    global class EmployeeResponse
    {
        public string EmployeeID;
        public Boolean IsInsert;
        public Boolean IsUpdate;
        public string errorMessage;
    }
    //Global class to hold User related data in the Response
    global class UserResponse
    {
        public string UserID;
        public string errorMessage;
    }
}