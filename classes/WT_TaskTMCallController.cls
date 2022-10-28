/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_TaskTMCallController
* @Author			Anoop 	<abattini@wintrust.com>
* @ModifiedBy		Anoop	<abattini@wintrust.com>
* @Version			v1.0
* @CreatedDate		15-02-2021
* @UsedBy			Task Object
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is controller class to create Activity Extension records
* --------------------------------------------------------------------------------------------------------------
* @Changes
* vX.X
* MM-DD-YYYY
* --------------------------------------------------------------------------------------------------------------
**/
// Code Coverage: WT_TaskTMCallController_T
public class WT_TaskTMCallController 
{
    /**
*-----------------------------------------------------------------------------------------------------------------------------
* @description
* This method auto populate default value on Task TM Call Records.
*-----------------------------------------------------------------------------------------------------------------------------
**/
    @AuraEnabled(cacheable=true)
    public static Map<String,Id> getRecordType()
    {     
        List<Schema.RecordTypeInfo> listRecordType = Task.SObjectType.getDescribe().getRecordTypeInfos();
        Map<String ,Id> mapRecordType = new Map<String ,Id>();
        for(Schema.RecordTypeInfo recordType : listRecordType )
        {
            mapRecordType.put(recordType.Name,recordType.getRecordTypeId());
        }
        return mapRecordType;
    }
    
    @AuraEnabled
    public static String fetchRecordTypeID(String recordTypeName)
    {
        RecordType recordType = [select id,Name FROM recordType Where Name =: recordTypeName and SobjectType = 'Task'];
        return recordType.id;
    }
    
    @AuraEnabled
    public static string TMcallType(Id activityExtensionId){
        WT_Activity_Extension__c activityExtension = [Select Id, WT_TM_Onboarding_Call__c from WT_Activity_Extension__c where id =:activityExtensionId];
        return activityExtension.WT_TM_Onboarding_Call__c;
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
        Task taskToUpdate=[select Id,WT_TM_Activity_Lkp__c from Task where Id=:taskId];
        try {
            taskToUpdate.WT_TM_Activity_Lkp__c=activityExtensionId;
            update taskToUpdate;
            return taskToUpdate.Id;
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
        return null;
    }
    
    @AuraEnabled
    public static Task returnTaskDetails(Id taskrecordId)
    {
        Task fetchTask=[select Id, WT_TM_Activity_Lkp__c, recordtype.DeveloperName from Task where Id=:taskrecordId];
        return fetchTask;
    }
    
    @AuraEnabled
    public static String getTaskRecordTypeName(String recordTypeName)
    {
        RecordType recordType = [select id,Name FROM recordType Where Name =: recordTypeName and SobjectType = 'Task'];
        return recordType.id;
    }
    
}