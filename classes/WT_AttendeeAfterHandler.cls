/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name				WT_AttendeeAfterHandler
* @Author			Sivaranjani 	<sivaranjani.d2@tcs.com.tcsdev>	
* @ModifiedBy		Sivaranjani 	<sivaranjani.d2@tcs.com.tcsdev>
* @version 			v1.0 
* @CreatedDate		18-01-2021
* @UsedBy			Aura Component: WT_TaskSendEmail
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* this is used as trigger handler class for Attendee junction object
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Changes
* vx.x				<user id>
* MM-DD-YYYY		<Explanation> 
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
// Test class: WT_AttendeeHandler_T
public class WT_AttendeeAfterHandler extends TriggerHandler
{
    private List<WT_Attendee_Junction__c> listNewAttendee = new List<WT_Attendee_Junction__c>();
    public Set<String> uniqueKeyString= new set<String>();
    public Map<String,WT_Attendee_Junction__c> mapAttendeeUniqueKeyAndAttendee= new Map<String,WT_Attendee_Junction__c>();
    public Map<id,WT_Attendee_Junction__c> MapAttendeeIdAndAttendee= new Map<id,WT_Attendee_Junction__c>();
    /**
    * -------------------------------------------------------------------------------------------------------------------------------------------------
    * @Description
    * used as the constructor function for this class.  
    * -------------------------------------------------------------------------------------------------------------------------------------------------
    * @param --no input  
    * @return -- no return 
    * -------------------------------------------------------------------------------------------------------------------------------------------------
    **/
    public WT_AttendeeAfterHandler()
    {
        if(trigger.isInsert)
        { 
            this.listNewAttendee = (List<WT_Attendee_Junction__c>) Trigger.new;
        }
    }
    /**
    * -------------------------------------------------------------------------------------------------------------------------------------------------
    * @Description
    * override the existing function of TriggerHandler class. 
    * used to run validation for uniqueness.Throws error when same attendee exist on the particular event already.
    * -------------------------------------------------------------------------------------------------------------------------------------------------
    * @param --no input  
    * @return -- no return 
    * -------------------------------------------------------------------------------------------------------------------------------------------------
    **/
    public override void afterInsert()
    {
        for(WT_Attendee_Junction__c newAttendee:listNewAttendee)
        {
            uniqueKeyString.add(newAttendee.WT_Attendee_Junction_ID__c);
            MapAttendeeIdAndAttendee.put(newAttendee.id,newAttendee);
        }
    	List<WT_Attendee_Junction__c> existingAttendees = [select id, WT_Attendee_Junction_ID__c from WT_Attendee_Junction__c where WT_Attendee_Junction_ID__c IN: uniqueKeyString and ID not IN:MapAttendeeIdAndAttendee.keySet()];
        for(WT_Attendee_Junction__c existingAttendee: existingAttendees)
        {
            mapAttendeeUniqueKeyAndAttendee.put(existingAttendee.WT_Attendee_Junction_ID__c,existingAttendee);
        }
        for(WT_Attendee_Junction__c newAttendee:listNewAttendee)
        {
          If(mapAttendeeUniqueKeyAndAttendee.get(newAttendee.WT_Attendee_Junction_ID__c) != null)
          {
              newAttendee.addError('Attendee exist already');
          }           
        }
    }
}