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
    
    //Setting the Is Validation Rule Active flag to false for Business Admin Setting
    //This would make it so that the Validation Rules aren't fired for this context
    //Validation rules should start firing after this update has made 
    @AuraEnabled
    public static String updateDatePaidDetails(List<Lead> updateLeadRecord) 
    {   
        String resultStatus = 'success';
        WT_Switch_Settings__c businessAdminSwitchSetting = null;
        
        List<WT_Switch_Settings__c> listSwitchSetting = [SELECT Id, WT_Is_Validation_Rule_Active__c
                                                         FROM WT_Switch_Settings__c
                                                         WHERE SetupOwner.Name = 'WT Business Administrator'];
        
        if(listSwitchSetting != null && !listSwitchSetting.isEmpty())
        {
            businessAdminSwitchSetting = listSwitchSetting[0];
            businessAdminSwitchSetting.WT_Is_Validation_Rule_Active__c = false;
            
            update businessAdminSwitchSetting;
        }
            
        
        for(Lead recordDetail : updateLeadRecord)
        {
            recordDetail.WT_Date_Paid__c = system.Today();
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
        
        if(businessAdminSwitchSetting != null)
        {
            businessAdminSwitchSetting.WT_Is_Validation_Rule_Active__c = true;
            
            update businessAdminSwitchSetting;
        }
        
        
        return resultStatus;
    }
}