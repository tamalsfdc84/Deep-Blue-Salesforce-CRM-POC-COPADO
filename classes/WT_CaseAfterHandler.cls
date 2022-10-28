/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name				WT_CaseAfterHandler
* @Author			Sivaranjani 	<sivaranjani.d2@tcs.com.tcsdev>	
* @ModifiedBy		Sivaranjani 	<sivaranjani.d2@tcs.com.tcsdev>
* @version 			v1.0 
* @CreatedDate		01-02-2020
* @UsedBy			trigger:  WT_CaseTrigger
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* this is used by trigger WT_CaseTrigger
* used to provide view access to the requestor and the creator of the case
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Changes
* vx.x				<user id>
* MM-DD-YYYY		<Explanation> 
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
// Test class: WT_CaseBeforeHandler_T
public class WT_CaseAfterHandler extends TriggerHandler
{
    private List<Case> newcaseList = new List<Case>();
    private Map<Id, Case> mapNewCaseIdandCase = new Map<Id, Case>();
    private Map<Id, Case> mapOldCaseIdandCase = new Map<Id, Case>();
    public WT_caseAfterHandler()
    {
        this.newcaseList = (List<case>) Trigger.new;	   
    }
    public override void afterInsert()
    {    
        List<caseShare>  caseShareList = new List<caseShare>();
        RecordType depositApplicationRecordType= [select id, developerName, Name from RecordType where developerName='WT_Deposit_Application'];
        for(Case caseRecord: newcaseList)
        {
            if(caseRecord.RecordTypeId == depositApplicationrecordType.id)
            {	
                caseShare caseRecordShare  = new caseShare();
                caseRecordShare.caseId = caseRecord.id;
                caseRecordShare.UserOrGroupId = caseRecord.WT_Requester_s_Name__c;
                caseRecordShare.caseAccessLevel = 'Read';
                caseRecordShare.RowCause = Schema.caseShare.RowCause.Manual;
                caseShareList.add(caseRecordShare); 
            }
            caseShare caseRecordShare  = new caseShare();
            caseRecordShare.caseId = caseRecord.id;
            caseRecordShare.UserOrGroupId = caseRecord.CreatedById;
            caseRecordShare.caseAccessLevel = 'Read';
            caseRecordShare.RowCause = Schema.caseShare.RowCause.Manual;
            caseShareList.add(caseRecordShare);
        }
        Database.SaveResult[] shareRecords = Database.insert(caseShareList,false);
        for (Database.SaveResult shareRecord : shareRecords) 
        {
            if (shareRecord.isSuccess() == false) 
            {
                for(Database.Error errorReturned : shareRecord.getErrors()) 
                {
                    System.debug(errorReturned.getStatusCode() + ': ' + errorReturned.getMessage());
                    System.debug('Account fields that affected this error: ' + errorReturned.getFields());
                }
            }
        }   
    }
    public override void afterUpdate(){
        List<caseShare>  caseShareList = new List<caseShare>();
        RecordType depositApplicationRecordType= [select id, developerName, Name from RecordType where developerName='WT_Deposit_Application'];
        for(Case caseRecord: newcaseList)
        {
            if(caseRecord.RecordTypeId == depositApplicationrecordType.id)
            {	
                caseShare caseRecordShare  = new caseShare();
                caseRecordShare.caseId = caseRecord.id;
                caseRecordShare.UserOrGroupId = caseRecord.WT_Requester_s_Name__c;
                caseRecordShare.caseAccessLevel = 'Read';
                caseRecordShare.RowCause = Schema.caseShare.RowCause.Manual;
                caseShareList.add(caseRecordShare); 
            }
            caseShare caseRecordShare  = new caseShare();
            caseRecordShare.caseId = caseRecord.id;
            caseRecordShare.UserOrGroupId = caseRecord.CreatedById;
            caseRecordShare.caseAccessLevel = 'Read';
            caseRecordShare.RowCause = Schema.caseShare.RowCause.Manual;
            caseShareList.add(caseRecordShare);
        }
        Database.SaveResult[] shareRecords = Database.insert(caseShareList,false);
        for (Database.SaveResult shareRecord : shareRecords) 
        {
            if (shareRecord.isSuccess() == false) 
            {
                for(Database.Error errorReturned : shareRecord.getErrors()) 
                {
                    System.debug(errorReturned.getStatusCode() + ': ' + errorReturned.getMessage());
                    System.debug('Account fields that affected this error: ' + errorReturned.getFields());
                }
            }
        }   
    }
}