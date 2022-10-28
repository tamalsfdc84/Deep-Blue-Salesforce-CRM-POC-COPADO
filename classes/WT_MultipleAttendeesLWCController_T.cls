/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name			WT_MultipleAttendeesLWCController_T
* @Author			Swaminathan E	<SEzhumal@wintrust.com>
* @version 		v1.0 
* @CreatedDate		22-12-2020
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* Class is used as test class for WT_MultipleAttendeesLWCController 
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* FUNCTIONAL TEST LOGIC
*  executeAttendees()
* 	> used to run the Apex class for the WT_MultipleAttendeesLWCController , generally for code coverage.
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
@isTest
public class WT_MultipleAttendeesLWCController_T 
{
    static testMethod void executeAttendees() 
    {
        Event newEvent = new Event( Subject = 'Send Letter', StartDateTime = System.now(), EndDateTime = System.now() );
        insert newEvent;
        WT_Attendee_Junction__c newAttendee = new WT_Attendee_Junction__c( WT_Event__c = newEvent.Id, WT_Optional__c = true );
        insert newAttendee;                        
        Test.startTest();
        WT_MultipleAttendeesLWCController.FetchAttendees(newEvent.Id);
        WT_MultipleAttendeesLWCController.GetAttendeeName(newAttendee.Id);        
        String getSuccessMessage = WT_MultipleAttendeesLWCController.RemoveAttendees(newAttendee); 
        System.assertEquals('success', getSuccessMessage);
        String getErrorMessage = WT_MultipleAttendeesLWCController.RemoveAttendees(newAttendee);
        System.assertNotEquals('success', getErrorMessage);
        Test.stopTest();
    }
}