/**
* --------------------------------------------------------------------------------------------------------------
* @Name             WT_EventBeforeHandler
* @Author           Karishma Keswani    <kkeswani@wintrust.com>
* @ModifiedBy       Swaminathan E       <SEzhumal@wintrust.com>
* @Version          v1.0
* @CreatedDate      13-11-2020
* @UsedBy           Event Object
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is handler class for Event trigger.
* This handles all the before logic of the Event trigger.
* --------------------------------------------------------------------------------------------------------------
* @Changes
* v2.0
* 08-31-2021
* Anitha Jaini    <ajaini@wintrust.com>	
* 02-09-2022      Added the validation for the RG and HH Account Restriction as per SGE - 124
* 03-11-2022      Added the validation for restricting Inactive Accounts as per SGE - 167
* Updated 59-83 by Vamshi Papisetty for SGE-90
* --------------------------------------------------------------------------------------------------------------
**/
public class WT_EventBeforeHandler extends TriggerHandler
{
    List<Event> listNewEvent = new List<Event>();
    Map<Id, Event> mapNewEventIdandEvent = new Map<Id, Event>();
    Map<Id, Event> mapOldEventIdandEvent = new Map<Id, Event>();
    Boolean isInsertTrigger;       //Added the boolean for SGE-124	    
    public WT_EventBeforeHandler()
    {
        PopulateGlobalLists();        
    }
    public override void beforeInsert()
    {
        SetRecordTypeIdFromGlobalLayout();
        SetActivityType();
        RestrictOptOutCustomer(listNewEvent);
        populateRelationshiproupId(listNewEvent);
        RestrictOptOutCustomer(listNewEvent);     //--added for new event SGE-124    
    }
    public override void beforeUpdate()
    {
        ValidateOutComeNotes(mapNewEventIdandEvent,mapOldEventIdandEvent);
        populateRelationshiproupId(listNewEvent);
        RestrictOptOutCustomer(listNewEvent);     //--added for new event SGE-124  
    }
    public override void beforeDelete()
    {
        DeleteActivityExtesionRecords(mapOldEventIdandEvent);
    }
    private void PopulateGlobalLists()
    {        
        listNewEvent = (List<Event>) Trigger.new;
        mapNewEventIdandEvent= (Map<Id, Event>) Trigger.newMap;
        mapOldEventIdandEvent = (Map<Id, Event>) Trigger.oldMap;
        isInsertTrigger = Trigger.isInsert; //added SGE-124
    }
    //recordtypes for event creation from Activity Component
    private void SetRecordTypeIdFromGlobalLayout()
    {
        for(Event newEvent : listNewEvent)
        {
        Id annualReviewEventRecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByDeveloperName().get('WT_Annual_Review').getRecordTypeId();
        Id craEventRecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByDeveloperName().get('WT_CRA_Event').getRecordTypeId();
        Id wintrustEventRecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByDeveloperName().get('WT_Wintrust_Event').getRecordTypeId();
        Id annualReviewTestEventRecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByDeveloperName().get('WT_Annual_Review_New').getRecordTypeId();
        Id craEventTestRecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByDeveloperName().get('WT_CRA_Event_New').getRecordTypeId();
        Id wintrustEventTestRecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByDeveloperName().get('WT_Wintrust_Event_New').getRecordTypeId();
        
            if(newEvent.RecordTypeId == annualReviewTestEventRecordTypeId)
            {
                newEvent.RecordTypeId = annualReviewEventRecordTypeId;            
            }
            if(newEvent.RecordTypeId == craEventTestRecordTypeId)
            {
                newEvent.RecordTypeId = craEventRecordTypeId;
            }
            if(newEvent.RecordTypeId == wintrustEventTestRecordTypeId)
            {
                newEvent.RecordTypeId = wintrustEventRecordTypeId;
            }
        }    
    }
    private void SetActivityType()
    {
        Id annualReviewEventRecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByDeveloperName().get('WT_Annual_Review').getRecordTypeId();
        Id craEventRecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByDeveloperName().get('WT_CRA_Event').getRecordTypeId();
        Id standardEventRecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByDeveloperName().get('WT_Event').getRecordTypeId();
        Id wintrustEventRecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByDeveloperName().get('WT_Wintrust_Event').getRecordTypeId();
        for(Event newEvent : listNewEvent)
        {
            if((newEvent.RecordTypeId == annualReviewEventRecordTypeId || newEvent.RecordTypeId == annualReviewEventRecordTypeId ||
                newEvent.RecordTypeId == annualReviewEventRecordTypeId || newEvent.RecordTypeId == annualReviewEventRecordTypeId) && 
                newEvent.WT_Activity_Type__c == null)
            {
                newEvent.WT_Activity_Type__c = 'Appointment';
            }
        }
    }
    /**
* --------------------------------------------------------------------------------------------------------------
* @Description
* This method is used to populate the Relationship Group ID for the Task linked to Business accounts
*
* --------------------------------------------------------------------------------------------------------------
* @Param  listNewEvent          List of Event
* @Return void                 Returns none
* --------------------------------------------------------------------------------------------------------------
**/
    public void populateRelationshiproupId(List<Event> listNewEvent)
    {
        Set<Id> setAccountId = new Set<Id>();
        Map<Id,Id> mapAccountId = new Map<Id,Id>();
        for(Event eventRecord: listNewEvent)
        {
            setAccountId.add(eventRecord.WhatId);  
        }
        List<WT_RelationshipGroup_Relation__c> listRelationRecord = [SELECT Id, 
                                                                     WT_Account__c, 
                                                                     WT_RelatedAccount__c 
                                                                     FROM WT_RelationshipGroup_Relation__c 
                                                                     WHERE WT_Active__c = true 
                                                                     AND WT_RelatedAccount__c IN :setAccountId];
        if (listRelationRecord.size() > 0)
        {
            for(WT_RelationshipGroup_Relation__c relation :listRelationRecord )
            {
                mapAccountId.put(relation.WT_RelatedAccount__c,relation.WT_Account__c);
            }
        }
        for(Event eventRecord: listNewEvent)
        {
            if(mapAccountId.containsKey(eventRecord.WhatId))
            {
                eventRecord.WT_Relationship_Group__c = mapAccountId.get(eventRecord.WhatId);
            }
            else
            {
                eventRecord.WT_Relationship_Group__c = Null; 
            }   
        }    
    }   
    /**
* --------------------------------------------------------------------------------------------------------------
* @Description
* This method restrict the Event creation on OptOut Customers.
*
* --------------------------------------------------------------------------------------------------------------
* @Param  listNewEvent    List of Event
* @Return void           Returns none
* --------------------------------------------------------------------------------------------------------------
**/
    private void RestrictOptOutCustomer(List<Event> listNewEvent)
    {
        Set<Id> setAccountIds = new Set<Id>();
        List<Event> listAccountEvent = New List<Event>();  
        Final String CUSTOMER_RECORD_TYPE = 'PersonAccount_Customer';
         //added for the record types HH and RG Accounts SGE-124	
        Final String HOUSEHOLD_RECORD_TYPE_DEVELOPER_NAME = 'IndustriesHousehold';	
        Final String RELATIONSHIPGROUP_RECORD_TYPE_DEVELOPER_NAME = 'Relationship_Group'; 	
        try
        {
            for(Event eventRecord : listNewEvent)
            {
                if(eventRecord.WhatId.getsObjectType() == Account.sObjectType)
                {
                    setAccountIds.add(eventRecord.WhatId);
                    listAccountEvent.add(eventRecord);
                }                
            }
            if(!setAccountIds.isEmpty())
            {
                Map<Id,Account> mapofCustomerAccounts = new Map<Id,Account>([SELECT Id, 
                                                                             Ownerid,
                                                                             RecordType.DeveloperName,
                                                                             FinServ__Status__c,
                                                                             PersonDoNotCall, 
                                                                             WT_Opt_Out_of_Info_Share__pc,
                                                                             FinServ__MarketingOptOut__pc,
                                                                             WT_Phone_Marketing__pc, 
                                                                             WT_Mail_Marketing__pc,
                                                                             PersonHasOptedOutOfEmail
                                                                             FROM Account 
                                                                             WHERE Id IN: setAccountIds]); 
                /*commented for adding the filter account level
and RecordType.DeveloperName=:CUSTOMER_RECORD_TYPE*/
                if(!mapofCustomerAccounts.isEmpty())
                {
                    Account accountRecord;
                    for(Event eventRecord :listAccountEvent)
                    {
                        if(mapofCustomerAccounts.get(eventRecord.WhatId)!=null)
                        {
                            accountRecord = mapofCustomerAccounts.get(eventRecord.WhatId);
                            if(!eventRecord.WT_Override_DNC__c &&
                               //added to include the record type filter condition		
                               isInsertTrigger && accountRecord.RecordType.DeveloperName== CUSTOMER_RECORD_TYPE && 
                               (accountRecord.PersonDoNotCall || accountRecord.WT_Opt_Out_of_Info_Share__pc || accountRecord.FinServ__MarketingOptOut__pc
                                || accountRecord.WT_Phone_Marketing__pc || accountRecord.WT_Mail_Marketing__pc || accountRecord.PersonHasOptedOutOfEmail))
                            {
                                eventRecord.addError(System.Label.WT_OptOut_Customer_Error);
                            }// Start of change SGE 124	
                            else if(accountRecord.RecordType.DeveloperName==HOUSEHOLD_RECORD_TYPE_DEVELOPER_NAME || 	
                                    accountRecord.RecordType.DeveloperName==RELATIONSHIPGROUP_RECORD_TYPE_DEVELOPER_NAME)
                            {	
                                /* Created a custom label for error handling SGE 124*/	
                                eventRecord.addError(system.Label.WT_Event_RG_HH_Account_Error);	
                            } // end of change SGE 124
                            //added SGE - 167
                            else if(accountRecord.FinServ__Status__c == 'Inactive') 
                            {
                                eventRecord.addError(system.Label.WT_Inactive_Accounts);
                            }
                        }    
                    }
                }                
            }
        }
        catch(Exception e)
        {
            System.debug('The following exception has occurred: EventBeforeHandler>RestrictOptOutCustomer> ' + e.getMessage());
        }  
    }
    /** --------------------------------------------------------------------------------------------------------------
* @Description
* This method Validates the Task Record for Outcome Notes when changing the status to completed.
* --------------------------------------------------------------------------------------------------------------
* @Param  listNewTask    List of Task
* @Return void           Returns none
* --------------------------------------------------------------------------------------------------------------
**/    
    private void ValidateOutComeNotes(Map<Id, Event> mapNewEventIdandEvent,Map<Id, Event> mapOldEventIdandEvent)
    {
        List<WT_Activity_Extension__c> listActivity=[SELECT Id, 
                                                     WT_EventId__c, 
                                                     WT_Outcome_Notes__c, 
                                                     WT_Record_Type_Name__c 
                                                     FROM WT_Activity_Extension__c 
                                                     WHERE WT_EventId__c=:mapNewEventIdandEvent.keyset()];
        for(WT_Activity_Extension__c ActivityRecord:listActivity)
        {           
            Event newEventRecord=mapNewEventIdandEvent.get(ActivityRecord.WT_EventId__c);
            if(newEventRecord.WT_Status__c=='Completed' && ActivityRecord.WT_Outcome_Notes__c == null && (ActivityRecord.WT_Record_Type_Name__c=='WT_Wintrust_Event'||ActivityRecord.WT_Record_Type_Name__c=='WT_CRA_Event'))
            {
                newEventRecord.addError('Outcome Note field should be mandatory.'); 
            }
        }
    }
    /**
* --------------------------------------------------------------------------------------------------------------
* @Description
* This method deletes the Activity Extension Records when associated event record gets deleted.
* --------------------------------------------------------------------------------------------------------------
* @Param  mapOldEventIdandEvent    map of Event Id and Event 
* @Return void           Returns none
* --------------------------------------------------------------------------------------------------------------
**/    
    private void DeleteActivityExtesionRecords(Map<Id, Event> mapOldEventIdandEvent)
    {           
        List<Id> listActivityExtIds=new List<Id>();
        for(Event deletedEvents : mapOldEventIdandEvent.Values())
        {
            listActivityExtIds.add(deletedEvents.Id);           
        }       
        List<WT_Activity_Extension__c> listActivityExt=[SELECT Id, 
                                                        WT_EventId__c 
                                                        FROM WT_Activity_Extension__c 
                                                        WHERE WT_EventId__c=:listActivityExtIds];       
        if(listActivityExt!=null && listActivityExt.size()>0)
        {      
            delete listActivityExt;  
        }
    }
    /**
* --------------------------------------------------------------------------------------------------------------
* @Description
* This method update organizer name on attendee list also.
* --------------------------------------------------------------------------------------------------------------
* @Param  oldEventRecordMap    map of old Event Id and Event 
    * @Param  oldEventRecordMap    map of old Event Id and Event 
* @Param  oldEventRecordMap    map of old Event Id and Event 
* @Param  newEventRecordMap    map of new Event Id and Event 
    * @Param  newEventRecordMap    map of new Event Id and Event 
* @Param  newEventRecordMap    map of new Event Id and Event 
* @Return void           Returns none
* --------------------------------------------------------------------------------------------------------------
**/ 
    
    public static void updateAttendeeWithOrganizer(Map<Id,Event> newEventRecordMap,Map<Id, Event> oldEventRecordMap)
    {
        system.debug('newEventRecordMap :::'+newEventRecordMap);
        system.debug('oldEventRecordMap :::'+oldEventRecordMap);
        map<Id,Id> eventIdVsOrganizerIdMap = new map<Id,Id>();
        list<EventRelation> eventRelationRecListToInsert = new list<EventRelation>();
        
        /** Get Organizer Name from event if Assigned To and Organizer are different and save it in a map.*/
        for(Event eventRec : newEventRecordMap.values())
        {
            if(eventRec.OwnerId != eventRec.WT_Organizer_User__c)
            {
                eventIdVsOrganizerIdMap.put(eventRec.Id,eventRec.WT_Organizer_User__c);
            }
        }
        
        /** Create Event Relation object record for every organizer to add them as attendee in an event*/
        for(Id eventId : eventIdVsOrganizerIdMap.keyset())
        {
            Id organizerId = eventIdVsOrganizerIdMap.get(eventId);
            EventRelation eventRelationRec = new EventRelation();
            eventRelationRec.eventId = eventId;
            eventRelationRec.relationId = organizerId;
            eventRelationRec.IsParent = false;
            eventRelationRec.IsInvitee = true;
            eventRelationRec.IsWhat = false;
            eventRelationRec.Status = 'New';
            eventRelationRecListToInsert.add(eventRelationRec);
        }

        try
        {
            if(eventRelationRecListToInsert.size()>0)
            {
                insert eventRelationRecListToInsert;
            }
        }
        catch(Exception e)
        {
            system.debug('Error Message :::'+e.getMessage());
            system.debug('Error at line :::'+e.getLineNumber());
        }
    }
}