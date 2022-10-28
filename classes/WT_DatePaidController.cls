/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_DatePaidController
* @Author			Swaminathan E	<SEzhumal@wintrust.com>
* @ModifiedBy		Swaminathan E	<SEzhumal@wintrust.com>
* @Version			v1.0
* @CreatedDate		30-11-2020
* @UsedBy			Lead Object
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is controller class for Date Paid Automation on Referral Records.
*
* This handles based on User input, update Date Paid field on Referral Records.
* --------------------------------------------------------------------------------------------------------------
* @Changes
* vX.X
* MM-DD-YYYY
* --------------------------------------------------------------------------------------------------------------
**/
// Code Coverage: WT_DatePaidController_T
public class WT_DatePaidController 
{
    @AuraEnabled(cacheable=true) 
    public static List<Lead> getDatePaidDetails() 
    {
        List<Lead> listLeadsToReturn = new List<Lead>();
        List<String> listValidProfile = new List<String>
        {
          'WT Business Administrator',
          'WT Technical Administrator',
          'System Administrator'
        };
        Boolean isValidUser = false;
        String currentProfileId = UserInfo.getProfileId();
        List<Profile> listProfile = [SELECT Id, Name
                                     FROM Profile
                                     WHERE Id =: currentProfileId];
        
        if(listProfile != null & listProfile.size() > 0)
        {
        	String profileName = listProfile[0].Name;
            
            if(String.isNotBlank(profileName) && listValidProfile.Contains(profileName))
            {
                listLeadsToReturn =  [SELECT Id,Name, WT_Date_Paid__c, WT_Date_Qualified__c, Status FROM Lead WHERE WT_Date_Paid__c = null AND RecordType.Name = 'Wealth'
                                      AND WT_Date_Qualified__c != null AND FinServ__ExpressedInterest__c = 'Wintrust Wealth Management'];
            }
        }
		return listLeadsToReturn;
    }
    @AuraEnabled
    public static String updateDatePaidDetails(List<Lead> updateLeadRecord) 
    {   
        String resultStatus = 'success';
        for(Lead recordDetail : updateLeadRecord)
        {
            recordDetail.WT_Date_Paid__c= system.Today();
        }
        try 
        {
            update updateLeadRecord;
        }
        catch (Exception e)
        {
            resultStatus = e.getMessage().split('first error:')[1].split(',')[0];
            return resultStatus;
        }   
        return resultStatus;
    }
}