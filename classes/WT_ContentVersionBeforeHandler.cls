/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name             WT_ContentVersionTrigger
* @Author           Anitha Jaini    <ajaini@wintrust.com.wtajaini>  
* @ModifiedBy           
* @version          v1.0 
* @CreatedDate      12-16-2021
* @UsedBy           trigger:  WT_ContentVersionTrigger
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* this is used by trigger WT_ContentVersionTrigger
* used to provide view access to the requestor and the creator of the case
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Changes
* vx.x              <user id>
* MM-DD-YYYY        <Explanation> 
* Anitha Jaini      Added as part of SGE-9 -Update the fileowner to case owner when case owner is changed   
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
// Test class: WT_ContentVersionBeforeHandler_Test
public class WT_ContentVersionBeforeHandler extends TriggerHandler{
    
    private List<ContentVersion> newContentVersionList = new List<ContentVersion>();
    
    public WT_ContentVersionBeforeHandler(){
        this.newContentVersionList = (List<ContentVersion>) Trigger.new;
        
    }
    public override void beforeInsert(){
        
        contentVersionOwnerUpdate(newContentVersionList);  
        
    }
    
    public static void contentVersionOwnerUpdate(List<contentVersion> contentVersionList ) {
        
        Set<Id> caseIds = new Set<Id>();
        for(ContentVersion cv : contentVersionList) {
            if((cv.FirstPublishLocationId!= null) && (Case.SObjectType == cv.FirstPublishLocationId.getSObjectType())) {
                caseIds.add(cv.FirstPublishLocationId );
            }
        }
        
        Map<Id, Case> caseMap = new Map<Id, Case>(
            [SELECT Id, OwnerId FROM Case WHERE Id IN: caseIds AND RecordType.Name = :system.label.WT_Compliance_Complaint_Record_Type]
        );
        for(ContentVersion cv : contentVersionList) {
            if(cv.PathOnClient.endsWith('.exe')) {
                cv.addError('You cannot upload exe file. Please contact your Administrator.');
            }
            if((cv.FirstPublishLocationId != null) && (Case.SObjectType == cv.FirstPublishLocationId.getSObjectType()) && !caseMap.isEmpty() && caseMap.containsKey(cv.FirstPublishLocationId)) {
                cv.OwnerId = caseMap.get(cv.FirstPublishLocationId).OwnerId;
            }
        }
    }
}