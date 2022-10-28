/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name             WT_MultipleAttendeesLWCController
* @Author           Sivaranjani     <sivaranjani.d2@tcs.com.tcsdev> 
* @ModifiedBy       Sivaranjani     <sivaranjani.d2@tcs.com.tcsdev>
* @version          v1.0 
* @CreatedDate      12-22-2020
* @UsedBy           LWC:  WT_MultipleAttendeesLWC
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* this is used as an controller class for WT_MultipleAttendeesLWC
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Changes
* vx.x              <user id>
* MM-DD-YYYY        <Explanation> 
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
// Test class: WT_MultipleAttendeesLWCController_T
public class  WT_MultipleAttendeesLWCController
{
    /**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Description
* function returns list of attendees for the event  
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @param --- event id 
* @return -- List<attendees>
* -------------------------------------------------------------------------------------------------------------------------------------------------
**/
    @AuraEnabled(cacheable=true)
    public static  List<WT_Attendee_Junction__c> FetchAttendees(String eventID)
    {         
        List<WT_Attendee_Junction__c> listAttendees = [SELECT Id,WT_Attendee__c,WT_Account__c, WT_Contact__c, WT_Event__c, WT_Optional__c,WT_Attendee_Name_Formula__c,WT_Attendee_Type__c FROM WT_Attendee_Junction__c where WT_Event__c =: eventID];       
        return listAttendees;
    }
     /**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Description
* function deletes the attendee
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @param --- attendee record
* @return -- Success String 
* -------------------------------------------------------------------------------------------------------------------------------------------------
**/
    @AuraEnabled
    public static String RemoveAttendees(WT_Attendee_Junction__c attendees)
    {
        String resultStatus='success';
        if(attendees != null)
        {
            try
            {                
                delete attendees;
            }
            catch (Exception e)
            {
                resultStatus = e.getMessage().split('first error:')[1].split(',')[0];
                return resultStatus;
            }   
        }
        return resultStatus;
    }
     /**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Description
* function gets the attendee record ,return the attendee name to be dipalyed in the layout 
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @param --- attendee record iD
* -------------------------------------------------------------------------------------------------------------------------------------------------
**/
    @AuraEnabled
    public static WT_Attendee_Junction__c GetAttendeeName(String attendeeRecordID )
    {
        WT_Attendee_Junction__c attendeeRecord = [select id, WT_Attendee_Name_Formula__c, WT_Optional__c,WT_Attendee_Type__c from WT_Attendee_Junction__c where id=: attendeeRecordID]; 
        return attendeeRecord;
    }
}