/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_EventBeforeHandler
* @Author			Karishma Keswani	<kkeswani@wintrust.com>
* @ModifiedBy		Karishma Keswani	<kkeswani@wintrust.com>
* @Version			v1.0
* @CreatedDate		13-11-2020
* @UsedBy			Event Object
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is handler class for Event trigger.
* This handles all the before logic of the Event trigger.
* --------------------------------------------------------------------------------------------------------------
* @Changes
* Anoop Battini    <abattini@wintrust.com>
* 08-04-2021      Added method to validate Outcome Notes field When changing Event status to Completed
* --------------------------------------------------------------------------------------------------------------
**/
public class WT_EventBeforeHandler extends TriggerHandler
{
    List<Event> listNewEvent = new List<Event>();
    Map<Id, Event> mapNewEventIdandEvent = new Map<Id, Event>();
    Map<Id, Event> mapOldEventIdandEvent = new Map<Id, Event>();
    public WT_EventBeforeHandler()
    {
        PopulateGlobalLists();        
    }
    public override void beforeInsert()
    {
        RestrictOptOutCustomer(listNewEvent);
    }
    public override void beforeUpdate()
    {
         ValidateOutComeNotes(mapNewEventIdandEvent,mapOldEventIdandEvent);
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
        try
        {
            for(Event eventRecord : listNewEvent){
                if(eventRecord.WhatId.getsObjectType() == Account.sObjectType)
                {
                    setAccountIds.add(eventRecord.WhatId);
                    listAccountEvent.add(eventRecord);
                }                
            }
            if(!setAccountIds.isEmpty())
            {
                Map<id,Account> mapofCustomerAccounts = new Map<id,Account>([Select id, Ownerid,RecordType.DeveloperName,
                                                                           PersonDoNotCall, WT_Opt_Out_of_Info_Share__pc,FinServ__MarketingOptOut__pc,
                                                                             WT_Phone_Marketing__pc, WT_Mail_Marketing__pc,PersonHasOptedOutOfEmail
                                                                           from Account where id In: setAccountIds and RecordType.DeveloperName=:CUSTOMER_RECORD_TYPE]);
                if(!mapofCustomerAccounts.isEmpty())
                {
                    Account accountRecord;
                    for(Event eventRecord :listAccountEvent)
                    {
                        if(mapofCustomerAccounts.get(eventRecord.WhatId)!=null)
                        {
                            accountRecord = mapofCustomerAccounts.get(eventRecord.WhatId);
                            if(!eventRecord.WT_Override_DNC__c && 
                               (accountRecord.PersonDoNotCall || accountRecord.WT_Opt_Out_of_Info_Share__pc || accountRecord.FinServ__MarketingOptOut__pc
                               || accountRecord.WT_Phone_Marketing__pc || accountRecord.WT_Mail_Marketing__pc || accountRecord.PersonHasOptedOutOfEmail))
                            {
                                eventRecord.addError(System.Label.WT_OptOut_Customer_Error);
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
     /**
    * --------------------------------------------------------------------------------------------------------------
    * @Description
    * This method Validates the Task Record for Outcome Notes when changing the status to completed.
    * --------------------------------------------------------------------------------------------------------------
    * @Param  listNewTask    List of Task
    * @Return void           Returns none
    * --------------------------------------------------------------------------------------------------------------
    **/    
    private void ValidateOutComeNotes(Map<Id, Event> mapNewEventIdandEvent,Map<Id, Event> mapOldEventIdandEvent)
    {
        List<WT_Activity_Extension__c> listActivity=[Select Id, WT_EventId__c, WT_Outcome_Notes__c,	WT_Record_Type_Name__c from WT_Activity_Extension__c where WT_EventId__c=:mapNewEventIdandEvent.keyset()];
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
        List<WT_Activity_Extension__c> listActivityExt=[select Id, WT_EventId__c from WT_Activity_Extension__c where WT_EventId__c=:listActivityExtIds];       
        if(listActivityExt!=null && listActivityExt.size()>0)
        {      
            delete listActivityExt;  
        }
    }
}