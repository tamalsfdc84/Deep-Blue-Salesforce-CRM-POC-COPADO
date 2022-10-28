/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name             WT_CaseOwnerUpdate
* @Author           Francis Xavier     <fxavierd@wintrust.com> 
* @ModifiedBy       Francis Xavier     <fxavierd@wintrust.com> 
* @version          v1.0 
* @CreatedDate      04-20-2022
* @UsedBy           LWC_Component:  wT_AssignCaseOwnerTo_HR_Queue
* ---------------------------------------------------------------------------------------------------------------------------------------------------
**/
// Test class: WT_CaseOwnerUpdate_T

public class WT_CaseOwnerUpdate 
{
    @AuraEnabled
    public static String setOwnerId ( String recordId ) 
    {
        Id queueId = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperNAME = 'WT_HR'].Id;
        Case caseRecord = New Case();
        caseRecord.Id = recordId;
        caseRecord.OwnerId = queueId;
        update caseRecord;
        return caseRecord.Id;
    }
}