/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_EventController
* @Author			Swaminathan E	<SEzhumal@wintrust.com>
* @ModifiedBy		Swaminathan E	<SEzhumal@wintrust.com>
* @Version			v1.0
* @CreatedDate		30-11-2020
* @UsedBy			Event Object
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is controller class for Event Record Creation through Outlook.
* --------------------------------------------------------------------------------------------------------------
* @Changes
* vX.X
* MM-DD-YYYY
* --------------------------------------------------------------------------------------------------------------
**/
// Code Coverage: WT_EventController_T
public class WT_EventController 
{
    @AuraEnabled(cacheable=false)
    public static void createEventRecord(String subject,String activityTypeValue,String recordType,String relatedTo,DateTime startValue, DateTime endValue)
    {
        Event eventRecord = new Event(Subject =subject, WT_Activity_Type__c =activityTypeValue,
                                      StartDateTime = startValue, EndDateTime = endValue,whatId = relatedTo,
                                      RecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByDeveloperName().get(recordType).getRecordTypeId());
        insert eventRecord;
    }
    @AuraEnabled(cacheable=true)
    public static List<sobject> relatedToRecord(String searchKey,String objectName)
    {
        string searchText = '\'' + String.escapeSingleQuotes(searchKey) + '%\'';  
        objectName = String.escapeSingleQuotes(objectName);
        string query = 'SELECT Id, Name FROM ' +objectName+ ' WHERE Name LIKE '+searchText+' LIMIT 6';           
        return Database.query(query); 
    }
}