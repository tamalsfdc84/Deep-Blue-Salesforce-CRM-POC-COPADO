/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name				WT_TaskSendEmailController
* @Author			Sivaranjani 	<sivaranjani.d2@tcs.com.tcsdev>	
* @ModifiedBy		Sivaranjani 	<sivaranjani.d2@tcs.com.tcsdev>
* @version 			v1.0 
* @CreatedDate		12-03-2020
* @UsedBy			Aura Component: WT_TaskSendEmail
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* this is used by Aura Component: WT_TaskSendEmail
* used to send email on task creation, when related to is a deposit Appliction Case 
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Changes
* vx.x				<user id>
* MM-DD-YYYY		<Explanation> 
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
// Test class: WT_TaskSendEmailController_T
public class WT_TaskSendEmailController 
{   
    /**
    * -------------------------------------------------------------------------------------------------------------------------------------------------
    * @Description
    * used to send email to task owner when it is assigned to deposit application case record  , only case owner will be able to send email.  
    * -------------------------------------------------------------------------------------------------------------------------------------------------
    * @param ---task record id is sent as input  
    * @return -- String -- success or error Message
    * -------------------------------------------------------------------------------------------------------------------------------------------------
    **/
    @AuraEnabled
    public static String fetchSendEmailToTaskOwner(String recordID)
    {         
        String returnString = '';
        List<String> ownerGroupMembersUserID =new List<String>();
        Task taskInstance = [SELECT Id, ownerid, WhatId , Subject,WT_send_email__c FROM Task where id=: recordID];
        case currentCaseRecord = [select id, ownerID from Case where id =: taskInstance.WhatId];
        if(!((String)currentCaseRecord.ownerID).startsWith('005'))
        {
          List<GroupMember> caseOwnerGroupMembers = [SELECT Id, GroupId, UserOrGroupId FROM GroupMember where GroupId=:currentCaseRecord.ownerID];
            for(GroupMember caseOwnerGroupMember : caseOwnerGroupMembers )
            {
                ownerGroupMembersUserID.add(caseOwnerGroupMember.UserOrGroupId);
            }
        }
        if(currentCaseRecord.ownerID == userinfo.getUserId() || ownerGroupMembersUserID.contains(userinfo.getUserId()))
        {
            taskInstance.WT_send_email__c = true;
            update taskInstance;// triggers an email alert
            taskInstance.WT_send_email__c = false;
            update taskInstance;// setting back send email to false for next email alert 
            returnString='Success';
            return returnString;
        }
        else
        {
            returnString ='Only owner of the request can send email to task owner';
            return returnString;
        }
    }
}