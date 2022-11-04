/**
* --------------------------------------------------------------------------------------------------------------
* @Name          WT_UnlockRecord
* @Author        Vasavi K    <VKolusu@wintrust.com> 
* @ModifiedBy    Vasavi K    <VKolusu@wintrust.com> 
* @Version       v1.0
* @CreatedDate   2/22/2022
* @UsedBy        Class to unlock the record
* --------------------------------------------------------------------------------------------------------------
* @Description
* Class to unlock the record
* --------------------------------------------------------------------------------------------------------------
* @Changes
* vX.X
* MM-DD-YYYY
* --------------------------------------------------------------------------------------------------------------
**/
// Code Coverage: WT_GetRecordLockStatus_T
public with sharing class WT_UnlockRecord {
    @InvocableMethod
    public static List<Response> Unlock(List<Request> requests) {
        String recordId = requests[0].recordId;
        Approval.UnlockResult unlockResult = Approval.unlock(recordId);
        Response response = new Response();
        response.isSuccess = unlockResult.isSuccess();
        response.errors = packErrorString(unlockResult);
        List<Response> responseWrapper= new List<Response>();
        responseWrapper.add(response);
        return responseWrapper;
    }
    
    public static String packErrorString(Approval.UnlockResult unlockResult) {
        String errorString = '';
        for(Database.Error err : unlockResult.getErrors()) {
            errorString = errorString + (' The following error has occurred. '+err.getStatusCode() + ': ' + err.getMessage());                   
        }
        return errorString;
    }
    public class Request {
        @InvocableVariable
        public String recordId;
    }
    public class Response {
        @invocableVariable
        public Boolean isSuccess; 
        @invocableVariable
        public String errors;
    }
    public class InvocableActionException extends Exception {}
    public class InvocableErrorException extends Exception{}

}