/**
* --------------------------------------------------------------------------------------------------------------
* @Name          WT_GetRecordLockStatus
* @Author        Vasavi K    <VKolusu@wintrust.com> 
* @ModifiedBy    Vasavi K    <VKolusu@wintrust.com> 
* @Version       v1.0
* @CreatedDate   2/22/2022
* @UsedBy        Class to get the lock status of record
* --------------------------------------------------------------------------------------------------------------
* @Description
* Class to get the lock status of record
* --------------------------------------------------------------------------------------------------------------
* @Changes
* vX.X
* MM-DD-YYYY
* --------------------------------------------------------------------------------------------------------------
**/
// Code Coverage: WT_GetRecordLockStatus_T 
public with sharing class WT_GetRecordLockStatus {
    @InvocableMethod
    public static List<Response> GetStatus(List<Request> requests) {
        String recordId = requests[0].recordId;
        Boolean lockStatus = Approval.isLocked(recordId);
        Response response = new Response();
        response.locked = lockStatus;
        List<Response> responseWrapper= new List<Response>();
        responseWrapper.add(response);
        return responseWrapper;
    }
    public class Request {
        @InvocableVariable
        public String recordId;
    }
    public class Response {
        @invocableVariable
        public Boolean locked; 
    }
    public class InvocableErrorException extends Exception{}
    public class InvocableActionException extends Exception {}
}