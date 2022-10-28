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
* @Changes
* vx.x              <user id>
* MM-DD-YYYY        <Explanation> 
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
// Test class: WT_CaseBeforeHandler_T

public class WT_CaseBeforeHandler extends TriggerHandler
{
    private List<Case> newcaseList = new List<Case>();
    private Map<Id, Case> mapNewCaseIdandCase = new Map<Id, Case>();
    private Map<Id, Case> mapOldCaseIdandCase = new Map<Id, Case>();
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
    }
    public override void beforeInsert()
    {   
        updateAccountID(newcaseList);
        setResolutionTarget(newcaseList);
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
            if(newCase.RecordTypeId==ccpaRecordType.Id)
            {
                newCase.WT_Resolution_Target__c=newCase.WT_Date_of_Request_Received__c+46;  
            }
        }
    }
}