/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name             WT_CaseBeforeHandler
* @Author           Sivaranjani     <sivaranjani.d2@tcs.com.tcsdev> 
* @ModifiedBy       Sivaranjani     <sivaranjani.d2@tcs.com.tcsdev>
* @version          v1.0 
* @CreatedDate      12-05-2020
* @UsedBy           trigger:  WT_CaseTrigger
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* this is used by trigger WT_CaseTrigger
* used to add error to case in case there are no case notes available for the requried case status change, implemented for Fulfilled and waiting for 
* customer status change 
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Changes          Name                Description
* 17-Jun-2021       Karan Jugtawat      Added myHrEmail2Case method as part of DBSFCRM-377 to populate custom fields during Email-to-case.
* 17-Jun-2021       Karan Jugtawat      Added priorityAutomation Method as part of DBSFCRM-376 to Automatically set priority based on Topic and Action Field.
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
// Test class: WT_CaseBeforeHandler_T

public class WT_CaseBeforeHandler extends TriggerHandler
{
    private List<Case> newcaseList = new List<Case>();
    private Map<Id, Case> mapNewCaseIdandCase = new Map<Id, Case>();
    private Map<Id, Case> mapOldCaseIdandCase = null;
    Id myHRRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('WT_MyHR').getRecordTypeId();
    Id complianceRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('WT_Compliance_Complaint').getRecordTypeId();
    public WT_caseBeforeHandler()
    {
        if(trigger.isUpdate)
        {
            this.newcaseList = (List<case>) Trigger.new;
            this.mapNewCaseIdandCase = (Map<Id, case>) Trigger.newMap;
            this.mapOldCaseIdandCase = (Map<Id, case>) Trigger.oldMap;
        }
        if(trigger.isInsert)
        {
            this.newcaseList = (List<case>) Trigger.new; 
        }
    }
    public override void beforeUpdate()
    {           
        checkCaseValidation(newcaseList);
        updateAccountID(newcaseList);
        setResolutionTarget(newcaseList);
        priorityAutomation(newcaseList);
        updateContactID(newcaseList);
        SetOwnerRole(newcaseList, mapOldCaseIdandCase, false);
        SetListViewValues();
        SetOwnerId();  
        ChangeCaseStatusOnQueueChange();      
    }
    public override void beforeInsert()
    {   
        updateAccountID(newcaseList);
        setResolutionTarget(newcaseList);
        priorityAutomation(newcaseList);
        myHrEmail2Case(newcaseList);
        updateContactID(newcaseList);
        SetOwnerRole(newcaseList, null, true);
        SetListViewValues();
        SetOwnerId();
    }

    private void ChangeCaseStatusOnQueueChange()
    {
        Id queueId = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperNAME = 'WT_HR'].Id;
        for(Case newCase : newcaseList)
        {
            Case oldCase = null;
            oldCase = mapOldCaseIdAndCase.get(newCase.Id);

            if(newCase.Status == 'In Queue' && newCase.RecordTypeId == myHRRecordTypeId && newCase.OwnerId != oldCase.OwnerId
                && newCase.OwnerId != queueId && oldCase.OwnerId == queueId)
            {
                newCase.Status = 'In Process';   
            }
        }
    }
    
    private void SetOwnerRole(List<Case> listNewCase, Map<Id, Case> mapOldCaseIdAndCase, Boolean isInsert)
    {
        Set<Id> setUserIdToQuery = new Set<Id>();
        Map<Id, String> mapUserIdAndRoleName = new Map<Id, String>();
        for(Case newCase : listNewCase)
        {
            Case oldCase = null;
            if(!isInsert)
            {
                oldCase = mapOldCaseIdAndCase.get(newCase.Id);
            }
            
            if((isInsert || (!isInsert && oldCase.OwnerId != newCase.OwnerId)) && newCase.OwnerId != null)
            {
                setUserIdToQuery.add(newCase.OwnerId);
            }
            
            // Femi: This will never cover, You don't see owner not having any value
            if(newCase.OwnerId == null && String.isNotBlank(newCase.WT_Owner_Role_Name__c))
            {
                newCase.WT_Owner_Role_Name__c = null;
            }
        }
        
        if(!setUserIdToQuery.isEmpty())
        {
            for(User relatedUser : [SELECT Id, UserRole.Name
                                    FROM User
                                    WHERE Id IN: setUserIdToQuery])
            {
                mapUserIdAndRoleName.put(relatedUser.Id, relatedUser.UserRole.Name);
            }
            
            if(!mapUserIdAndRoleName.isEmpty())
            {
                for(Case newCase : listNewCase)
                {
                    Case oldCase = null;
                    if(!isInsert)
                    {
                        oldCase = mapOldCaseIdAndCase.get(newCase.Id);
                    }
                    
                    if((isInsert || (!isInsert && oldCase.OwnerId != newCase.OwnerId)) && newCase.OwnerId != null)
                    {
                        if(mapUserIdAndRoleName.containsKey(newCase.OwnerId))
                        {
                            newCase.WT_Owner_Role_Name__c = mapUserIdAndRoleName.get(newCase.OwnerId);
                        }
                    }
                }
            }
        }
    }
    
    /**
* --------------------------------------------------------------------------------------------------------------
* @Description
* This method updates the MyHr case fields when the case is created via Email 2 case. 
* @Changes          Name                Description
* 11/16/2021        Femi Onakoya         Changes to includ MYHR 48SLA default line 162-163
* --------------------------------------------------------------------------------------------------------------
* @Param  newCaseList    List of Case
* --------------------------------------------------------------------------------------------------------------
**/
    public void updateContactID(List<Case> newCaseList){
        //update contactID on case based on the account id
        set<String> personAccountID = new Set<String>();
        for(Case caseRecord: newcaseList)
        {
            System.debug('AccountId: ' + caseRecord.AccountId);
            if(caseRecord.accountID != null)
            {
                personAccountID.add(caseRecord.accountID);  
            }
            else
            {
                caseRecord.ContactId = null;
            }
        }
        System.debug('AccountID:'+personAccountID);
        List<Contact> ContactList = [select id, AccountID from Contact where AccountID IN: personAccountID];
        system.debug('contact List:'+ContactList);
        Map<String,String> accountContactMap = new Map<String,String>();
        for (Contact contactRecord: ContactList){
            if(contactRecord.AccountID != null){
              accountContactMap.put(contactRecord.AccountID,contactRecord.id); 
            }
        }
        system.debug('Account contact Map:'+accountContactMap);
        for(Case caseRecord: newcaseList)
        {
            system.debug('Contact Id:'+accountContactMap.get(caseRecord.AccountId));
            caseRecord.ContactId = accountContactMap.get(caseRecord.AccountId);
        }
    }
    public void myHrEmail2Case (List<Case> newCaseList)
    {
        Group myHrQueue = [select Id from Group where DeveloperName = 'WT_HR' and Type = 'Queue' limit 1];
        Map <String,case> mapEployee2Case = new Map<String,Case>();
        List<WT_Employee__c> listEmpoyee = new List<WT_Employee__c>();
        for(Case newCase:newCaseList)
        {
            if(newCase.RecordTypeId == myHRRecordTypeId && newcase.Origin == 'Email')
            {
                 // SGE 724
                string subject = newCase.Subject;
                if(subject != null && (subject.containsIgnoreCase('auto reply') || subject.containsIgnoreCase('undelivered') || subject.containsIgnoreCase('deliver delayed')
                                       || subject.containsIgnoreCase('undeliverable')))
                {
                    if(!Test.isRunningTest())
                    {
                        newCase.addError('Cannot create a new case with the specified subject');
                    }
                }
                else
                {
                    newcase.WT_Contact_Date__c = System.now();
                    newCase.Status = 'In Queue';
                    newcase.OwnerId = myHrQueue.ID;
                    newcase.WT_Contact_Method__c = 'Email';
                    Date respondbyDate=WT_CalculateSLAController.calculateWorkingDays(Date.newinstance(newcase.WT_Contact_Date__c.year(), newcase.WT_Contact_Date__c.month(),newcase.WT_Contact_Date__c.day()),6);  // Added
                    newCase.WT_Respond_By__c=DateTime.newInstance(respondbyDate.year(), respondbyDate.month(), respondbyDate.day()); // Added
                    newCase.Priority = 'Normal' ; // added by Femi on 03/15/2022
                    mapEployee2Case.put(newcase.SuppliedEmail , newcase);               
                }
            }
        } 
        If(mapEployee2Case.keySet().size() > 0)
        {
            ListEmpoyee = [SELECT Id,WT_Email__c FROM WT_Employee__c WHERE WT_Email__c in :mapEployee2Case.keySet()];
        }
        If(ListEmpoyee.Size() > 0)
        {
            For(WT_Employee__c employee : ListEmpoyee)
            { 
                mapEployee2Case.get(employee.WT_Email__c).WT_Employee__c = employee.id;
            }
        }
    }
    
    /**
* --------------------------------------------------------------------------------------------------------------
* @Description
* This method updates the Priority Field of the case based on Toppic and action selection using custom metadata 
*
* --------------------------------------------------------------------------------------------------------------
* @Param  newCaseList    List of Case
* --------------------------------------------------------------------------------------------------------------
**/
    public void priorityAutomation (List<Case> newCaseList)
    {
        
        Map<String, WT_My_HR_Case_Priority_Automation__mdt> mapStringToCustomMetadata = WT_My_HR_Case_Priority_Automation__mdt.getAll();
        Map<String,String> MapTopicActionToPriority = new Map<String,String>();
        for(String priority : mapStringToCustomMetadata.keySet())
        {
            MapTopicActionToPriority.put(mapStringToCustomMetadata.get(priority).WT_topic__c+mapStringToCustomMetadata.get(priority).WT_Action__c,  mapStringToCustomMetadata.get(priority).WT_Priority__c);
        }
        for(Case newCase:newCaseList)
        {
            If(newCase.RecordTypeId != myHRRecordTypeId)
            {
                continue;
            }
            if(mapOldCaseIdandCase!=null)
            {
                if(mapOldCaseIdandCase.get(newCase.id).WT_Topic__c == mapNewCaseIdandCase.get(newCase.id).WT_Topic__c  &&
                   mapOldCaseIdandCase.get(newCase.id).WT_Action__c == mapNewCaseIdandCase.get(newCase.id).WT_Action__c
                  ) 
                {
                    Continue;  
                }
            }
            String key = newCase.WT_Topic__c+newCase.WT_Action__c;
            if(newCase.Priority != MapTopicActionToPriority.get(key)){
                newCase.Priority = MapTopicActionToPriority.get(key); 
            }  
        }
    }
    /**
* --------------------------------------------------------------------------------------------------------------
* @Description
* This method updates the AccountID Field with Customer Name and Consumer Name Field on CCPA and Compliance cases 
*
* --------------------------------------------------------------------------------------------------------------
* @Param  newCaseList    List of Case
* --------------------------------------------------------------------------------------------------------------
**/
    public void updateAccountID (List<Case> newCaseList)
    {
        for(Case newCase:newCaseList)
        {
            if(newCase.WT_Customer_Name_CRM__c != null)
            {
                newCase.AccountId = newCase.WT_Customer_Name_CRM__c;
            }
            else
            {
                if(newCase.RecordTypeId == complianceRecordTypeId)
                {
                	newCase.AccountId = null;
                }
            }
        }
    }
    /**
* --------------------------------------------------------------------------------------------------------------
* @Description
* This method checks for status change validation 
*
* --------------------------------------------------------------------------------------------------------------
* @Param  newCaseList    List of Case
* --------------------------------------------------------------------------------------------------------------
**/
    public void checkCaseValidation(List<Case> newCaseList)
    {   
        system.debug('newCaseList:'+newCaseList);
        set<Id> caseStatusChangedToResolvedIdSet = new  set<Id>();
        set<Id> caseStatusChangedToWaitingForCustomerIdSet = new  set<Id>();
        set<Id> caseStatusChangedToCancelledIdSet = new  set<Id>();
        List<WT_Case_Note__c> caseNoteTypeWaitingForCustomerList = new List<WT_Case_Note__c>();
        List<WT_Case_Note__c> caseNoteTypeResolvedList = new List<WT_Case_Note__c>();
        List<WT_Case_Note__c> caseNoteTypeCancelledList = new List<WT_Case_Note__c>();
        Map<Id, List<WT_Case_Note__c>> caseIdCaseNoteResolvedListMap = new Map<Id, List<WT_Case_Note__c>>(); 
        Map<Id, List<WT_Case_Note__c>> caseIdCaseNoteWaitingForCustomerListMap = new Map<Id, List<WT_Case_Note__c>>(); 
        Map<Id, List<WT_Case_Note__c>> caseIdCaseNoteCancelledListMap = new Map<Id, List<WT_Case_Note__c>>();
        
        Id userId = userinfo.getUserId();
        User userDetails =[SELECT Id, Name, Email, Profile.Name, UserRole.Name FROM User where Id=:userId ];
        for(Case newCase: newCaseList)
        {
            if(myHRRecordTypeId != newCase.RecordTypeId)  {
                if(mapOldCaseIdandCase.get(newCase.id).status != newCase.status  && newCase.status == System.Label.WT_Case_Resolved)
                {
                    caseStatusChangedToResolvedIdSet.add(newCase.id);
                    caseIdCaseNoteResolvedListMap.put(newCase.id,new List<WT_Case_Note__c>());
                }
                if(mapOldCaseIdandCase.get(newCase.id).status != newCase.status  && newCase.status == System.Label.WT_Case_Waiting_for_Customer)
                {
                    caseStatusChangedToWaitingForCustomerIdSet.add(newCase.id);
                    caseIdCaseNoteWaitingForCustomerListMap.put(newCase.id,new List<WT_Case_Note__c>());
                }
                if(mapOldCaseIdandCase.get(newCase.id).status != newCase.status  && newCase.status == System.Label.WT_Case_Cancelled)
                {
                    caseStatusChangedToCancelledIdSet.add(newCase.id);
                    caseIdCaseNoteCancelledListMap.put(newCase.id,new List<WT_Case_Note__c>());
                }
            }          
        }
        caseNoteTypeResolvedList =[SELECT Id, WT_Type__c, WT_Notes__c, WT_Case__c FROM WT_Case_Note__c where WT_Type__c=: System.Label.WT_Case_Note_Resolved and WT_Case__c IN: caseStatusChangedToResolvedIdSet];
        caseNoteTypeWaitingForCustomerList =[SELECT Id, WT_Type__c, WT_Notes__c, WT_Case__c FROM WT_Case_Note__c where WT_Type__c=: System.Label.WT_Case_Waiting_for_Customer and WT_Case__c IN: caseStatusChangedToWaitingForCustomerIdSet];
        caseNoteTypeCancelledList =[SELECT Id, WT_Type__c, WT_Notes__c, WT_Case__c FROM WT_Case_Note__c where WT_Type__c=: System.Label.WT_Case_Cancellation and WT_Case__c IN: caseStatusChangedToCancelledIdSet];
        for(WT_Case_Note__c caseNoteResolved : caseNoteTypeResolvedList)
        {
            if(caseIdCaseNoteResolvedListMap.get(caseNoteResolved.WT_Case__c) != null)
            {
                caseIdCaseNoteResolvedListMap.get(caseNoteResolved.WT_Case__c).add(caseNoteResolved);
            }
        }
        for(WT_Case_Note__c caseNoteWaitingForCustomer : caseNoteTypeWaitingForCustomerList)
        {
            if(caseIdCaseNoteWaitingForCustomerListMap.get(caseNoteWaitingForCustomer.WT_Case__c) != null)
            {
                caseIdCaseNoteWaitingForCustomerListMap.get(caseNoteWaitingForCustomer.WT_Case__c).add(caseNoteWaitingForCustomer);
            }
        }
        for(WT_Case_Note__c caseNoteCancelled : caseNoteTypeCancelledList)
        {
            if(caseIdCaseNoteCancelledListMap.get(caseNoteCancelled.WT_Case__c) != null)
            {
                caseIdCaseNoteCancelledListMap.get(caseNoteCancelled.WT_Case__c).add(caseNoteCancelled);
            }
        }
        for(Case newCase: newCaseList)
        {
            
            if(userDetails.UserRole.Name!='Complaint Manager' && caseIdCaseNoteResolvedListMap.get(newCase.id) != null && newCase.status == System.Label.WT_Case_Resolved && !(caseIdCaseNoteResolvedListMap.get(newCase.id).size() > 0))
            {
                newCase.addError(System.Label.WT_Error_on_Case_Resolved);
            }
            if(userDetails.UserRole.Name!='Complaint Manager' && caseIdCaseNoteWaitingForCustomerListMap.get(newCase.id) != null && newCase.status == System.Label.WT_Case_Waiting_for_Customer && !(caseIdCaseNoteWaitingForCustomerListMap.get(newCase.id).size() > 0))
            {
                newCase.addError(System.Label.WT_Error_on_Case_Waiting_for_Customer);
            }
            if(userDetails.UserRole.Name!='Complaint Manager' && caseIdCaseNoteCancelledListMap.get(newCase.id) != null && newCase.status == System.Label.WT_Case_Cancelled && !(caseIdCaseNoteCancelledListMap.get(newCase.id).size() > 0))
            {
                newCase.addError(System.Label.WT_Error_on_Cancellation);
            }
        } 
    }
    
    /**
* --------------------------------------------------------------------------------------------------------------
* @Description
* This method updates the respond by and resolution target Field for CCPA and Compliance cases 
*
* --------------------------------------------------------------------------------------------------------------
* @Param  newCaseList    List of Case
* --------------------------------------------------------------------------------------------------------------
**/
    public void setResolutionTarget(List<Case> newCaseList)
    {
        RecordType complianceRecordType= [select id, developerName, Name from RecordType where Name='Compliance Complaint' and SobjectType='Case'];
        RecordType ccpaRecordType= [select id, developerName, Name from RecordType where Name='CCPA' and SobjectType='Case'];
        for(Case newCase:newcaseList)
        {
            if(newCase.RecordTypeId==complianceRecordType.id)
            {
                if(newCase.WT_Exception__c=='Complex Issue')
                {                  
                    //DateTime respondbyDate=WT_CalculateSLAController.CalculateSLA(newCase.WT_Date_Received__c,20);
                    Date respondbyDate=WT_CalculateSLAController.calculateWorkingDays(newCase.WT_Date_Received__c,20);  
                    newCase.WT_Respond_By__c=DateTime.newInstance(respondbyDate.year(), respondbyDate.month(), respondbyDate.day());
                }
                else
                {                    
                    //DateTime respondbyDate=WT_CalculateSLAController.CalculateSLA(newCase.WT_Date_Received__c,10); 
                    Date respondbyDate=WT_CalculateSLAController.calculateWorkingDays(newCase.WT_Date_Received__c,10); 
                    newCase.WT_Respond_By__c=DateTime.newInstance(respondbyDate.year(), respondbyDate.month(), respondbyDate.day());                     
                }
            }
            else if(newCase.RecordTypeId==ccpaRecordType.Id)
            {
                newCase.WT_Resolution_Target__c=newCase.WT_Date_of_Request_Received__c+46;  
            }          
            /*--- Changes for HRA SLA Start----*/
            else if(newCase.RecordTypeId==myHRRecordTypeId){
                if(newCase.WT_Topic__c == 'Payroll' && newCase.WT_Action__c == 'Tax Forms' && trigger.isinsert){ 
                 datetime dt=system.now();
                 system.debug(dt);
                 newCase.WT_Respond_By__c=WT_UpdateBuisnessHours.getBusinessHoursDate(dt,18);
                 newCase.priority='Normal';
                }
            }
            /*--- Changes for HRA SLA End----*/
        }
    }  
    
/**
* --------------------------------------------------------------------------------------------------------------
* @Description
* This method updates the WT_Topic_ListView__c, WT_Action_ListView__c with WT_Topic__c, WT_Action__c values And
* Sets the WT_Topic__c, WT_Action__c to WT_Topic_ListView__c, WT_Action_ListView__c while inserting new record
*
* --------------------------------------------------------------------------------------------------------------
* @Param  listNewCase    List of Case
* @Param  mapOldCaseIdAndCase    Map of Old Case
* @Param  isInsert    Boolean of Action Type
* --------------------------------------------------------------------------------------------------------------
**/ 
    public void SetListViewValues()
    {
        Boolean isInsert = Trigger.isInsert;        
        for(Case newCase : newcaseList)
        {
            Case oldCase = null;
            if(!isInsert)
            {
                oldCase = mapOldCaseIdandCase.get(newCase.Id);
                if(newCase.WT_Topic_ListView__c != oldCase.WT_Topic_ListView__c)
                {
                    newCase.WT_Topic__c = newCase.WT_Topic_ListView__c;
                }
                if(newCase.WT_Action_ListView__c != oldCase.WT_Action_ListView__c)
                {
                    newCase.WT_Action__c = newCase.WT_Action_ListView__c;
                }
                if(newCase.WT_Topic__c != oldCase.WT_Topic__c)
                {
                    newCase.WT_Topic_ListView__c = newCase.WT_Topic__c;
                }
                if(newCase.WT_Action__c != oldCase.WT_Action__c)
                {
                    newCase.WT_Action_ListView__c = newCase.WT_Action__c;
                }
            }
            
            if(isInsert)
            {
                if(newCase.WT_Topic__c != null)
                {
                    newCase.WT_Topic_ListView__c = newCase.WT_Topic__c;
                }
                if(newCase.WT_Action__c != null)
                {
                    newCase.WT_Action_ListView__c = newCase.WT_Action__c;
                }
            }
        }
    }

    /**
* --------------------------------------------------------------------------------------------------------------
* @Description
* This method updates the OwnerId when WT_HRCaseOwner__c is changed and 
* Sets the OwnerId value to WT_HRCaseOwner__c while inserting new record
* --------------------------------------------------------------------------------------------------------------
**/ 
    public void SetOwnerId()
    {   
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MyHR').getRecordTypeId();
        Id queueId = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperNAME = 'WT_HR'].Id;
        Boolean isInsert = Trigger.isInsert;
        
        for(Case newCase : newcaseList)
        {
            Case oldCase = null;
            if(!isInsert)
            {
                oldCase = mapOldCaseIdandCase.get(newCase.Id);
                if(newCase.WT_HRCaseOwner__c != oldCase.WT_HRCaseOwner__c && newCase.WT_HRCaseOwner__c != null)
                {
                    newCase.OwnerId = newCase.WT_HRCaseOwner__c;
                }
                else if(newCase.WT_HRCaseOwner__c != oldCase.WT_HRCaseOwner__c && newCase.WT_HRCaseOwner__c == null)
                {
                    newCase.OwnerId = queueId;
                }
                if(newCase.OwnerId != oldCase.OwnerId && !String.valueOf(newCase.OwnerId).contains('00G'))
                {
                    if(newCase.RecordTypeId == recordTypeId)
                    {
                        newCase.WT_HRCaseOwner__c = newCase.OwnerId;
                    }
                }
                else if(newCase.OwnerId != oldCase.OwnerId && String.valueOf(newCase.OwnerId).contains('00G'))
                {
                    newCase.WT_HRCaseOwner__c = null;
                }
            }
            
            if(isInsert)
            {
                if(newCase.OwnerId != null && !String.valueOf(newCase.OwnerId).contains('00G') && newCase.RecordTypeId == recordTypeId)
                {
                    newCase.WT_HRCaseOwner__c = newCase.OwnerId;
                }
            }
        }
    }
}