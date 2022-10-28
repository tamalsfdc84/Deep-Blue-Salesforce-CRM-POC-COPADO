/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name         WT_ContentVersionBeforeHandler_Test
* @Author       Anitha Jaini     
* @Email        <ajaini@wintrust.com> 
* @version      v1.0 
* @ModifiedDate 12-13-2021
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* Class is used as test class for WT_ContentVersionBeforeHandler,WT_ContentVersionTrigger 
* ---------------------------------------------------------------------------------------------------------------------------------------------------
**/
@isTest
class WT_ContentVersionBeforeHandler_Test {
    @TestSetup
    static void makeData() {
        
        Case wtCase = WT_TestSetupHelper.getCase(Schema.SObjectType.Case
                                                 .getRecordTypeInfosByDeveloperName()
                                                 .get('WT_Compliance_Complaint')
                                                 .getRecordTypeId()
                                                 );
        insert wtCase;
    }
    @isTest
    static void contentVersionOwnerTest() {
        
        List<Case> caseRecords = [SELECT Id FROM Case LIMIT 1];
        system.assert(caseRecords != null && caseRecords.size() > 0);
        
        ContentVersion contentVersion_1 = WT_TestSetupHelper.getContentVersion(caseRecords[0].Id);
        insert contentVersion_1;
    }
}