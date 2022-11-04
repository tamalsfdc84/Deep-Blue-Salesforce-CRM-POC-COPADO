/* --------------------------------------------------------------------------------------------------------------
* @Name             WT_ActivityTimeLineController
* @Author           Vamshi Papisetty
* @ModifiedBy       Vamshi Papisetty    <vpapiset@wintrust.com>
* @Version          v2.0
* @CreatedDate      05/24/2022          
* Code Coverage: WT_ActivitytimeLineController_T
* The is Apex Controller for Activity History LWC Component
* @Changes v2.0
*Adds list of recordtype for Person And Business Accounts--listRecord
* task of <recordtype> based on Account<recordtype>--includes Person And Business accounts 
* event  of <recordtype> based on Account<recordtype>--includes Person And Business accounts 
* Line -89  tasks/events<recordtypes> for  Opportunities (Conditions set to negative as create action is false
* Line-176 Mapping TaskId from Task to TaskId(field) of Activity Extension to get Outcome notes from ActivityExtension Object
* Line 184 Mapping eventId from Event to EventId(field) from  Activity Extension to get Outcome notes from ActivityExtension Object 
* Sort or display order of recordtypes based on Custom Meta data object Display Activity RecordTypes
* 05/24/2022-------------------------------------------------------------------------------------------------------
* Updated 8/25/2022--------------------------------------------------------------------------------------------**/
public with sharing class WT_ActivityTimeLineController
{
 @AuraEnabled(cacheable=true)
    Public static List<listRecordTypes> getRecordTypesInfo(Id recId)
    {
       //get recordtypes for Task and Event
        Schema.DescribeSObjectResult taskRecords = Task.SObjectType.getDescribe();
        Schema.DescribeSObjectResult eventRecords = Event.SObjectType.getDescribe();
        //list for storing the values
        List<listRecordTypes> listBusinessRecordTypes = new List<listRecordTypes>();
        List<listRecordTypes> listPersonRecordTypes  = new List<listRecordTypes>();
        List<listRecordTypes> listOpportunityRecordTypes = new List<listRecordTypes>();
        List<listRecordTypes> listSortedRecordTestType = new List<listRecordTypes>();

        //Business Logic Start
        Map<String,WT_Display_Activity_RecordType__mdt> mapBusinesstaskSortOrderMetaData = new Map<String,WT_Display_Activity_RecordType__mdt>();
        Map<Integer,WT_Display_Activity_RecordType__mdt> mapBusinessIntegerSortOrderMetaData = new Map<Integer,WT_Display_Activity_RecordType__mdt>();
        Map<String,listRecordTypes> mapBusinessTaskSortedRecordTestType = new Map<String,listRecordTypes>();
        
        List<WT_Display_Activity_RecordType__mdt> listBusinessSortRecordsMetadata =[Select Id, DeveloperName,ObjectRecordType__c,Sort_Order__c, Label from WT_Display_Activity_RecordType__mdt where ObjectRecordType__c ='Business'];
        for(WT_Display_Activity_RecordType__mdt sortMetadataRecords : listBusinessSortRecordsMetadata)
        {
            mapBusinesstaskSortOrderMetaData.put(sortMetadataRecords.Label,sortMetadataRecords);   
            mapBusinessIntegerSortOrderMetaData.put(Integer.valueOf(sortMetadataRecords.Sort_Order__c),sortMetadataRecords);
        }
        //Business Logic end

        //Person Logic Start
        Map<String,WT_Display_Activity_RecordType__mdt> mapPersonTaskSortOrderMetaData = new Map<String,WT_Display_Activity_RecordType__mdt>();
        Map<Integer,WT_Display_Activity_RecordType__mdt> mapPersonIntegerSortOrderMetaData = new Map<Integer,WT_Display_Activity_RecordType__mdt>();
        Map<String,listRecordTypes> mapPersonTaskSortRecordType = new Map<String,listRecordTypes>();
        
        List<WT_Display_Activity_RecordType__mdt> listPersonSortRecordsMetadata =[Select Id, DeveloperName,ObjectRecordType__c,Sort_Order__c, Label from WT_Display_Activity_RecordType__mdt where ObjectRecordType__c ='Person'];
        for(WT_Display_Activity_RecordType__mdt sortMetadataRecords : listPersonSortRecordsMetadata)
        {
            mapPersonTaskSortOrderMetaData.put(sortMetadataRecords.Label,sortMetadataRecords);   
            mapPersonIntegerSortOrderMetaData.put(Integer.valueOf(sortMetadataRecords.Sort_Order__c),sortMetadataRecords);
        }
        //Business Logic end

        Id recordId = recId;
        //Getting Object name
        String objName = String.valueOf(recordId.getSobjectType());
        if(objName == 'Account' || objName == 'account')
        {
         Account accountRecord  = [Select Id ,RecordType.DeveloperName FROM Account WHERE Id =:recordId];
           //recordtypes for Person account
            if(accountRecord.RecordType.DeveloperName =='PersonAccount_Customer'||accountRecord.RecordType.DeveloperName =='PersonAccount_Prospect')
            {
                for(Schema.RecordTypeInfo recordType: taskRecords.getRecordTypeInfos())
                {
                    //adding these record types for Person Account --basing standard activity/global actions
                    if(recordType.DeveloperName == 'WT_Standard_Call'||
                      recordType.DeveloperName == 'WT_Wintrust_Task'||
                      recordType.DeveloperName =='WT_CRA_Call')
                       {
                        listRecordTypes recType = new listRecordTypes();
                        recType.name = recordType.Name;
                        recType.id =  recordType.RecordTypeId;
                        recType.isTask = true;
                        listPersonRecordTypes.add(recType);
                        mapPersonTaskSortRecordType.put(recType.Name,recType);
                       }
                }
                for(Schema.RecordTypeInfo recordType: eventRecords.getRecordTypeInfos())
                {
                    if(recordType.DeveloperName == 'WT_Wintrust_Event')
                    {
                        listRecordTypes recType = new listRecordTypes();
                        recType.name = recordType.Name;
                        recType.id = recordType.RecordTypeId;
                        recType.isTask = false;
                        listPersonRecordTypes.add(recType);
                        mapPersonTaskSortRecordType.put(recType.Name,recType);
                    }
                }
                List<Integer> listSortOrder = new List<Integer>();
                for(listRecordTypes recType : listPersonRecordTypes)
                {                   
                    if(mapPersonTaskSortOrderMetaData.containsKey(recType.Name))
                    {                        
                        listSortOrder.add(Integer.valueOf(mapPersonTaskSortOrderMetaData.get(recType.Name).Sort_Order__c));                             
                    }
                }             
                listSortOrder.sort();
                for(Integer sortOrder : listSortOrder)
                {   
                    if(mapPersonIntegerSortOrderMetaData.containsKey(sortOrder))
                    {                        
                        listSortedRecordTestType.add(mapPersonTaskSortRecordType.get(mapPersonIntegerSortOrderMetaData.get(sortOrder).Label));                           
                    }
                }   
            }
            //adding these record types for Business Account --basing standard activity/global actions
            else if(accountRecord.RecordType.DeveloperName =='BusinessAccount_Customer'||accountRecord.RecordType.DeveloperName =='BusinessAccount_Prospect')
            {
                for(Schema.RecordTypeInfo recordType: taskRecords.getRecordTypeInfos())
                {
                    if(recordType.isAvailable())
                    {
                    if(recordType.DeveloperName == 'WT_Wintrust_Task'||recordType.DeveloperName == 'WT_CRA_Call'||
                           recordType.DeveloperName == 'WT_WFG_Call'||recordType.DeveloperName =='TM_Call'||
                           recordType.DeveloperName == 'WT_Standard_Call') 
                    {
                    listRecordTypes recType  = new listRecordTypes();
                     recType.name = recordType.Name;
                     recType.id = recordType.RecordTypeId;
                     recType.isTask = true;
                     listBusinessRecordTypes.add(recType);
                     mapBusinessTaskSortedRecordTestType.put(recType.Name,recType); //map to store rec name with recordtype details
                    }
                }
                }
                for(Schema.RecordTypeInfo recordType: eventRecords.getRecordTypeInfos())
                {
                    if(recordType.DeveloperName == 'WT_Wintrust_Event'||recordType.DeveloperName =='WT_Annual_Review'||
                         recordType.DeveloperName =='WT_CRA_Event') 
                   {
                    listRecordTypes recType = new listRecordTypes();
                    recType.name = recordType.Name;
                    recType.id = recordType.RecordTypeId;
                    recType.isTask =false;
                    listBusinessRecordTypes.add(recType);
                    mapBusinessTaskSortedRecordTestType.put(recType.Name,recType);
                   }   
                }
                List<Integer> listSortOrder = new List<Integer>();
                for(listRecordTypes recType : listBusinessRecordTypes)
                {                   
                    if(mapBusinesstaskSortOrderMetaData.containsKey(recType.Name))
                    {                        
                        listSortOrder.add(Integer.valueOf(mapBusinesstaskSortOrderMetaData.get(recType.Name).Sort_Order__c));                             
                    }
                }             
                listSortOrder.sort();
                for(Integer sortOrder : listSortOrder)
                {   
                    if(mapBusinessIntegerSortOrderMetaData.containsKey(sortOrder))
                    {                        
                        listSortedRecordTestType.add(mapBusinessTaskSortedRecordTestType.get(mapBusinessIntegerSortOrderMetaData.get(sortOrder).Label));                           
                    }
                }                
            }
        } 
        //getting recordtype for opportunity and also for tasks and events
        else if(objName == 'Opportunity'|| objName == 'opportunity')
       {
        Opportunity opportunityRecord = [select Id, RecordType.DeveloperName from Opportunity where Id =:recordId];
        if(opportunityRecord.RecordType.DeveloperName == 'Master')
         {
            for(Schema.RecordTypeInfo recordType : taskRecords.getRecordTypeInfos())
            {
            if(recordType.DeveloperName != 'Master'|| recordType.DeveloperName != 'ClientAssociateTask'||
                recordType.DeveloperName != 'WT_Task'|| recordType.DeveloperName != 'AdvisorTask'|| recordType.DeveloperName != 'WT_CRA_Call'||
                recordType.DeveloperName != 'TM_Call'||recordType.DeveloperName != 'WT_Standard_Call'||
                recordType.DeveloperName != 'WT_WFG_Call'|| recordType.DeveloperName != 'WT_Wintrust_Task')
            {
                listRecordTypes recType = new listRecordTypes();
                recType.name = recordType.Name;
                recType.isTask = true;  
                recType.id = recordType.RecordTypeId;
                listOpportunityRecordTypes.add(recType);
            }
            }
            for(Schema.RecordTypeInfo recordType : eventRecords.getRecordTypeInfos())
            {
                    if(recordType.DeveloperName != 'Master'||recordType.DeveloperName != 'WT_Event'||
                       recordType.DeveloperName != 'ClientAssociateEvent'|| recordType.DeveloperName != 'AdvisorEvent'|| 
                       recordType.DeveloperName != 'WT_Annual_Review'||
                       recordType.DeveloperName != 'WT_CRA_Event' || 
                recordType.DeveloperName != 'WT_Wintrust_Event' )
                {
                    listRecordTypes recType = new listRecordTypes();
                    recType.name = recordType.Name;
                    recType.isTask = false;
                    recType.id = recordType.RecordTypeId;
                    listOpportunityRecordTypes.add(recType);
                }
            } 
         }
        }
                   return listSortedRecordTestType; 
    }
    //Retreiving Test Task and event Record types(replicating page layouts for Global action layouts)
    @AuraEnabled(cacheable=true)
    Public static List<listRecordTypes> getTestRecordTestTypeInfo()
    {
        Schema.DescribeSObjectResult taskRecords = Task.SObjectType.getDescribe();
        Schema.DescribeSObjectResult eventRecords = Event.SObjectType.getDescribe();
        List<listRecordTypes> listRecordTestType = new List<listRecordTypes>();
        for(Schema.RecordTypeInfo recordType: taskRecords.getRecordTypeInfos())
        {
            //adding these record types test for navigating to page layout/global action
            if(recordType.DeveloperName.contains('_New'))
            {
                listRecordTypes recType = new listRecordTypes();
                recType.name = recordType.Name;
                recType.id =  recordType.RecordTypeId;
                listRecordTestType.add(recType);
            }
        }
        for(Schema.RecordTypeInfo recordType: eventRecords.getRecordTypeInfos())
        {
            //adding these record types test for navigating to page layout/global action
            if(recordType.DeveloperName.contains('_New') && recordType.isAvailable())
            {
                listRecordTypes recType = new listRecordTypes();
                recType.name = recordType.Name;
                recType.id =  recordType.RecordTypeId;
                listRecordTestType.add(recType);
            }
        }
        return listRecordTestType;
    }   
     @AuraEnabled(cacheable=true)
     Public static activity getActivites(Id recId)
      {
        String objName = String.valueOf(recId.getSobjectType());
        Set<Id> whatIds = new Set<Id>();
        //Set of account Id's for maps to have it associated with account
        whatIds.add(recId);
        if(objName  == 'Account')
        { 
            for(opportunity Opp : [Select Id FROM Opportunity WHERE accountId = :recId])
            {  
                whatIds.add(Opp.Id);
            }
        }        
            //Task values and Event maps
        Map<Id, Task> mapTaskIdAndTask = new Map<Id,Task>([Select Id,Subject,WT_TM_Activity_Lkp__c,WT_TM_Activity_Lkp__r.WT_Outcome_Notes__c,
                                                           ActivityDate,WT_Activity_Type__c,RecordType.Name,OwnerId,Owner.Name,
                                                           Status FROM Task WHERE whatId IN :whatIds]);
        Map<Id,Event> mapEventIdAndEvent = new Map<Id,Event>([Select Id,StartDateTime,Subject,WT_TM_Activity_Lkp__c,WT_Activity_Type__c,
                                                              WT_TM_Activity_Lkp__r.WT_Outcome_Notes__c, WhoId, Who.Name,WT_Organizer_User__r.Name,
                                                              WT_Organizer_User__c, WT_Contact_Type__c,IsChild,ActivityDate,
                                                              ActivityDateTime,EndDateTime,OwnerId,
                                                              RecordType.Name,Owner.Name,WT_Status__c FROM Event 
                                                              WHERE whatId IN : whatIds
                                                              AND IsChild=FALSE]);
        Map<String, WT_Activity_Extension__c> MapTaskIdActivityExtension = new Map<String, WT_Activity_Extension__c>();                
                //search for taskIds and eventIds in Actextn
        for(WT_Activity_Extension__c actExt : [Select Id, WT_TaskId__c,WT_EventId__c ,
                                               WT_Outcome_Notes__c FROM WT_Activity_Extension__c  
                                                WHERE WT_TaskId__c IN :mapTaskIdAndTask.keySet() OR WT_EventId__c IN :mapEventIdAndEvent.keySet()])
        {          
            if(actExt.WT_TaskId__c != null)
            {
                MapTaskIdActivityExtension.put(actExt.WT_TaskId__c,actExt);
            }
            if(actExt.WT_EventId__c != null)
            {
                MapTaskIdActivityExtension.put(actExt.WT_EventId__c,actExt);
            }
        }
        //temporary task and event lists to map it to activities
        List<Task> tempTskList = new List<Task>();
        List<Event> tempEvtList = new List<Event>();
       //checking for key=value pair
            for(Task tsk : mapTaskIdAndTask.values())
            {
                if(MapTaskIdActivityExtension.containsKey(tsk.Id))
                {
                    tsk.WT_Outcome_Notes__c = MapTaskIdActivityExtension.get(tsk.Id).WT_Outcome_Notes__c;
                }
                tempTskList.add(tsk);
            }
            for(Event evt : mapEventIdAndEvent.values())
            {
                if(MapTaskIdActivityExtension.containsKey(evt.Id))
                {
                evt.WT_Outcome_Notes__c = MapTaskIdActivityExtension.get(evt.Id).WT_Outcome_Notes__c;
            }
            tempEvtList.add(evt);
        }
        Activity activity = new Activity();
        activity.tasks = tempTskList;
        activity.events = tempEvtList;
        return activity;     
    }   
    public class listRecordTypes
    {
        @AuraEnabled
        public string name;
        @AuraEnabled
        public string id;
        @AuraEnabled
        public boolean isTask;      
    }
    Public class activity
    {
        @AuraEnabled
        public List<Task> tasks;
        @AuraEnabled
        public List<Event> events;    
    }
}