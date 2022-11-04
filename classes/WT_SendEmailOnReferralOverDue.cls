/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_ReferralEmailProcess
* @Author			Krupa Chinthakindi<KChintha@wintrust.com>
* @ModifiedBy		Krupa Chinthakindi<KChintha@wintrust.com>
* @Version			v1.0
* @CreatedDate		05-04-2022
* @UsedBy			Lead Object
* -----------------------------------------------------------------------------------------------------------------------------
* @Description
* This class to send an email to Loan Officer and Assistant. And it is called from process builder "Referrals Process Automation"
* --------------------------------------------------------------------------------------------------------------------------------
* @Changes
* vX.X
* MM-DD-YYYY
* --------------------------------------------------------------------------------------------------------------
**/
public with sharing class WT_SendEmailOnReferralOverDue {
    
    /**
*-----------------------------------------------------------------------------------------------------------------------------
* @description
*This method used to send an email to Loan officer and Load Assistant on Referral Overdue
*-----------------------------------------------------------------------------------------------------------------------------
* @param    ListLeadIds   This contains list of Lead RecordId from process builder    
  @author   Krupa Chinthakindi
  @Date     04/26/2022
*-----------------------------------------------------------------------------------------------------------------------------
**/
@InvocableMethod
public static List<string> SendEmailOnReferralUpdate(List<Id> ListLeadIds)
{
    List<string> listLead = new List<string>();
    WT_ReferralEmailProcess.SendEmailToLoanOfficerAndLoadAssistant(ListLeadIds,'Overdue_Referral_Email_Notification');
    return null;
} 

}