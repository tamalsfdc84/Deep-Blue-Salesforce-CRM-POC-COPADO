/**
* --------------------------------------------------------------------------------------------------------------
* @Name        WT_AccountTasksAndEventsController
* @Author      Pushpa Mopuru  <PMopuru@wintrust.com>
* @ModifiedBy  Pushpa Mopuru  <PMopuru@wintrust.com>
* @Version      v1.0
* @CreatedDate    2-25-2021
* @ModifiedDate    MM-DD-YYY
* @UsedBy      OpportunityTeamMember Object
* --------------------------------------------------------------------------------------------------------------
* @Description
* This handles all the After logic of the OpportunityTeamMember Object trigger.
* --------------------------------------------------------------------------------------------------------------
* @Changes
* vX.X
* MM-DD-YYYY
* --------------------------------------------------------------------------------------------------------------
**/
// Code Coverage: WT_AccountTasksAndEventsController_T
public class WT_AccountTasksAndEventsController 
{
    @AuraEnabled(cacheable=true) 
    public static String getAccountTasks(Id accountId) 
    {  
        List<WrapTask> wrapTaskList =new  List<WrapTask>();
        Set<Id> ownerIdSet = new Set<id>();
        Map<Id,String> ownerMap= new Map<Id, String>(); 
        Date today = System.Today();
        List<Task> taskList= [Select Id, Subject, ActivityDate, OwnerId FROM Task where AccountId=: accountId AND ActivityDate >= :today];
        for (Task myTask:taskList)
        {
            ownerIdSet.add(myTask.OwnerId);
        }
        list<User> ownerList= [Select Id,Name FROM User Where Id in: ownerIdSet]; 
        for (User user:ownerList)
        {
            ownerMap.put(user.Id, user.Name);
        }
        for (Task myTask:taskList)
        {
            WrapTask wrapTask  = new WrapTask(myTask.Subject,myTask.ActivityDate,ownerMap.get(myTask.OwnerId));          
            wrapTaskList.add(wrapTask);
        }
        return JSON.serialize(wrapTaskList);   
    }  
    @AuraEnabled(cacheable=true) 
    public static String getAccountEvents(Id accountId) 
    {
        List<WrapTask> wrapEventList =new  List<WrapTask>();
        Set<Id> ownerIdSet = new Set<id>();
        Map<Id,String> ownerMap= new Map<Id, String>(); 
        Date today = System.Today();
        List<Event> eventList= [Select Id, Subject, ActivityDate, OwnerId FROM Event where AccountId=: accountId AND ActivityDate >= :today ];
        for (Event myEvent: eventList)
        {
            ownerIdSet.add(myEvent.OwnerId);
        }
        list<User> ownerList= [Select Id,Name FROM User Where Id in: ownerIdSet]; 
        for (User user:ownerList)
        {
            ownerMap.put(user.Id, user.Name);
        }
        for (Event myEvent: eventList)
        {
            WrapTask wrapEvent  = new WrapTask(myEvent.Subject,myEvent.ActivityDate,ownerMap.get(myEvent.OwnerId));
            wrapEventList.add(wrapEvent);
        }
        return JSON.serialize(wrapEventList);
    }
    public class WrapTask
    {
        public String subject {get; set;}
        public String assignedTo {get; set;}
        public Date actvityDate {get; set;}
        public WrapTask(String subject,Date actvityDate, String assignedTo)
        {
            this.subject = subject;
            this.actvityDate = actvityDate;
            this.assignedTo = assignedTo;
        }
    }
}