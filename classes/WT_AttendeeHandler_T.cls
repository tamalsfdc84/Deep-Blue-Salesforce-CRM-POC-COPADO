/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name			WT_AttendeeHandler_T
* @Author			Sivaranjani 	<sivaranjani.d2@tcs.com.tcsdev>	
* @version 		v1.0 
* @CreatedDate		18-01-2021
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* Class is used as test class for WT_AttendeeAfterHandler,WT_AttendeeBeforeHandler , WT_AttendeeTrigger
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* FUNCTIONAL TEST LOGIC
* 1- runtestAttendeejunctionCreation() 
* 	> used to run test creation of attendee junction , list of attendees for an event both requied and optional  
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
@isTest
public class WT_AttendeeHandler_T 
{
    @isTest(SeeAllData=true) 
    static void  runtestAttendeejunctionCreation()
    {
        Account testAccount= (WT_DataFactory.createAccounts(1,'PersonAccount_Customer',userInfo.getUserId())).get(0);       
        Event testEvent = new Event();
        testEvent.WhatId=testAccount.id;
        testEvent.StartDateTime=system.today();
        testEvent.EndDateTime=system.today()+5;
        insert testEvent;
        WT_Attendee_Junction__c attendee = new WT_Attendee_Junction__c();
        attendee.WT_Attendee__c = userInfo.getUserId();
        attendee.WT_Attendee_Type__c= 'Users';
        attendee.WT_Event__c=testEvent.id;
        insert attendee;
        WT_Attendee_Junction__c attendee1 = [select id,WT_Attendee_Junction_ID__c,  WT_Attendee_Name_Formula__c from WT_Attendee_Junction__c where id=:attendee.id];
       // system.assert(attendee1.WT_Attendee_Junction_ID__c != null);
        //system.assert(attendee1.WT_Attendee_Name_Formula__c != null);
    }
}