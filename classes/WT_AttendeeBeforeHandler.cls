/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name				WT_AttendeeBeforeHandler
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
public class WT_AttendeeBeforeHandler extends TriggerHandler
{
    private List<WT_Attendee_Junction__c> listNewAttendee = new List<WT_Attendee_Junction__c>();
    private Map<Id, WT_Attendee_Junction__c> mapNewAttendeeIdandAttendee = new Map<Id, WT_Attendee_Junction__c>();
    private Map<Id, WT_Attendee_Junction__c> mapOldAttendeeIdandAttendee = new Map<Id, WT_Attendee_Junction__c>();
    public Map<Id, WT_Attendee_Junction__c> mapAttendeeIDandUserId = new  Map<Id, WT_Attendee_Junction__c>();
    public Map<Id, WT_Attendee_Junction__c> mapAttendeeIDandAccountId = new  Map<Id, WT_Attendee_Junction__c>();
    public Map<Id, WT_Attendee_Junction__c> mapAttendeeIDandContactId = new  Map<Id, WT_Attendee_Junction__c>();
    /**
    * -------------------------------------------------------------------------------------------------------------------------------------------------
    * @Description
    * used as the constructor function for this class.  
    * -------------------------------------------------------------------------------------------------------------------------------------------------
    * @param --no input  
    * @return -- no return 
    * -------------------------------------------------------------------------------------------------------------------------------------------------
    **/
    public WT_AttendeeBeforeHandler()
    {
        if(trigger.isInsert)
        { 
            this.listNewAttendee = (List<WT_Attendee_Junction__c>) Trigger.new;
        }
        if(trigger.isUpdate)
        {
            this.listNewAttendee = (List<WT_Attendee_Junction__c>) Trigger.new;
            this.mapNewAttendeeIdandAttendee = (Map<Id, WT_Attendee_Junction__c>) Trigger.newMap;
            this.mapOldAttendeeIdandAttendee = (Map<Id, WT_Attendee_Junction__c>) Trigger.oldMap;
        }
    }
    /**
    * -------------------------------------------------------------------------------------------------------------------------------------------------
    * @Description
    * override the existing function of TriggerHandler class. 
    * used to populate  Attendee name and Attendee junction id for uniqueness implementation 
    * -------------------------------------------------------------------------------------------------------------------------------------------------
    * @param --no input  
    * @return -- no return 
    * -------------------------------------------------------------------------------------------------------------------------------------------------
    **/
    public override void beforeInsert()
    {        
        for(WT_Attendee_Junction__c newAttendee:listNewAttendee)
        {
            if(newAttendee.WT_Attendee__c != null)
            {               
               newAttendee.WT_Attendee_Junction_ID__c= newAttendee.WT_Attendee__c+' '+newAttendee.WT_Event__c;
               mapAttendeeIDandUserId.put(newAttendee.WT_Attendee__c,newAttendee);
            }
            if(newAttendee.WT_Account__c != null)
            {              
               newAttendee.WT_Attendee_Junction_ID__c= newAttendee.WT_Account__c+' '+newAttendee.WT_Event__c;
               mapAttendeeIDandAccountId.put(newAttendee.WT_Account__c,newAttendee);
            }
            if(newAttendee.WT_Contact__c != null)
            {               
               newAttendee.WT_Attendee_Junction_ID__c= newAttendee.WT_Contact__c+' '+newAttendee.WT_Event__c;
               mapAttendeeIDandContactId.put(newAttendee.WT_Contact__c,newAttendee);
            }  
        }
        List<Account> listAccount = [select id, Name from Account where Id IN:mapAttendeeIDandAccountId.keySet() ];
        for(Account varAccount:listAccount)
        {
           WT_Attendee_Junction__c attendeeToUpdate=mapAttendeeIDandAccountId.get(varAccount.id);
           attendeeToUpdate.WT_Attendee_Name_Formula__c= varAccount.Name; 
        }
        List<User> listUser= [select id,FirstName, MiddleName, LastName, Name from User where Id IN: mapAttendeeIDandUserId.keySet()];
        for(User varUser:listUser)
        {
           WT_Attendee_Junction__c attendeeToUpdate=mapAttendeeIDandUserId.get(varUser.id);
           attendeeToUpdate.WT_Attendee_Name_Formula__c= varUser.Name; 
        }
        List<Contact> listContact= [select id,FirstName, MiddleName, LastName, Name from Contact where Id IN: mapAttendeeIDandContactId.keySet()];
        for(Contact varContact:listContact)
        {
           WT_Attendee_Junction__c attendeeToUpdate=mapAttendeeIDandContactId.get(varContact.id);
           attendeeToUpdate.WT_Attendee_Name_Formula__c= varContact.Name; 
        }       
    }
}