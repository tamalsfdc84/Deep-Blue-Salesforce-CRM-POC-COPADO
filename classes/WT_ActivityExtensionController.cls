/**
* --------------------------------------------------------------------------------------------------------------
* @Name             WT_ActivityExtensionController
* @Author           Anoop           <abattini@wintrust.com>
* @ModifiedBy       Swaminathan E   <SEzhumal@wintrust.com>
* @Version          v1.0
* @CreatedDate      15-02-2021
* @UsedBy           Task Object
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is controller class to create Activity Extension records
* --------------------------------------------------------------------------------------------------------------
* @Changes
* v1.0
* 04-23-2021
* --------------------------------------------------------------------------------------------------------------
**/
// Code Coverage: WT_ActivityExtensionController_T
public class WT_ActivityExtensionController
{
/**
*-----------------------------------------------------------------------------------------------------------------------------
* @description
* This method auto populate default value on Task TM Call Records.
*-----------------------------------------------------------------------------------------------------------------------------
**/   
    @AuraEnabled
    public static String fetchRecordTypeID(String recordTypeName)
    {
        RecordType recordType = [SELECT id, DeveloperName FROM recordType Where DeveloperName =: recordTypeName and SobjectType = 'WT_Activity_Extension__c'];
        return recordType.id;
    }        
    @AuraEnabled
    public static Id updateTask(Id activityExtensionId,Id taskId) {
        WT_Activity_Extension__c activityExtension = new WT_Activity_Extension__c();
        activityExtension = [Select Id, WT_Doc_Timeline_Satisfact__c, WT_How_Would_You_Rate_Training__c, WT_Easy_To_Use_Our_Digital_Products__c,
                             WT_Did_You_Customize_DB_Views_Panels__c, WT_Favorite_Dashboard_Panel__c, WT_What_Do_We_Need_To_Improve_Upon__c,
                             WT_Document_Comments__c, WT_Training_Comments__c, WT_Digital_Products_Comments__c, WT_Dashboard_Comments__c,
                             WT_What_Did_We_Do_Really_Well__c, WT_Are_Fees_Set_Up_Correctly__c, WT_Other_Products_Services_To_Discuss__c, 
                             WT_Any_Changes_Over_Last_60_Days__c, WT_What_Can_We_Improve_On__c, WT_Fees_Comments__c, 
                             WT_Account_Activity_As_Initially_Said__c, WT_What_Has_Improved_Since_We_Last_Spoke__c, 
                             WT_TM_Onboarding_Call__c from WT_Activity_Extension__c where id =:activityExtensionId];
        if(activityExtension != null)
        {
            //if WT_TM_Onboarding_Call__c = 14 Days, all the 60 days field values should be null
            if(activityExtension.WT_TM_Onboarding_Call__c == '14 Days')
            {
                activityExtension.WT_Are_Fees_Set_Up_Correctly__c = '';
                activityExtension.WT_Other_Products_Services_To_Discuss__c = '';
                activityExtension.WT_Any_Changes_Over_Last_60_Days__c = '';
                activityExtension.WT_What_Can_We_Improve_On__c = '';
                activityExtension.WT_Fees_Comments__c = '' ;
                activityExtension.WT_Account_Activity_As_Initially_Said__c = '';
                activityExtension.WT_What_Has_Improved_Since_We_Last_Spoke__c = '';
            }
            
            //if WT_TM_Onboarding_Call__c = 60 Days, all the 14 days field values should be null
            if(activityExtension.WT_TM_Onboarding_Call__c == '60 Days')
            {
                activityExtension.WT_Doc_Timeline_Satisfact__c = '';
                activityExtension.WT_How_Would_You_Rate_Training__c = '';
                activityExtension.WT_Easy_To_Use_Our_Digital_Products__c = '';
                activityExtension.WT_Did_You_Customize_DB_Views_Panels__c = '';
                activityExtension.WT_Favorite_Dashboard_Panel__c = '';
                activityExtension.WT_What_Do_We_Need_To_Improve_Upon__c = '' ;
                activityExtension.WT_Document_Comments__c = '';
                activityExtension.WT_Training_Comments__c = '';
                activityExtension.WT_Digital_Products_Comments__c = '';
                activityExtension.WT_Dashboard_Comments__c = '';
                activityExtension.WT_What_Did_We_Do_Really_Well__c = '';
            }
            update activityExtension;
        }        
        return null;
    }    
    @AuraEnabled
    public static WT_Activity_Extension__c returnTaskDetails(Id taskRecordId)
    {
        WT_Activity_Extension__c returnRecord = null;
        if(taskRecordId != null )
        {
            List<WT_Activity_Extension__c> listActivityExtension = [SELECT Id, WT_TaskId__c, WT_Record_Type_Name__c, WT_TM_Onboarding_Call__c 
                                                                    FROM WT_Activity_Extension__c 
                                                                    WHERE WT_TaskId__c =:taskRecordId];
            
            if(!listActivityExtension.isEmpty() && listActivityExtension.size() > 0)
            {
                returnRecord = listActivityExtension[0];
            }
        }
        return returnRecord;      
    }
    @AuraEnabled
    public static WT_Activity_Extension__c returnEventDetails(String eventRecordId)
    {
        WT_Activity_Extension__c returnRecord = null;
        if(eventRecordId != null )
        {
            List<WT_Activity_Extension__c> listActivityExtension = [SELECT Id, WT_EventId__c, WT_Record_Type_Name__c 
                                                                    FROM WT_Activity_Extension__c 
                                                                    WHERE WT_EventId__c =:eventRecordId];
            
            if(!listActivityExtension.isEmpty() && listActivityExtension.size() > 0)
            {
                returnRecord = listActivityExtension[0];
            }
        }
        return returnRecord;   
    }    
}