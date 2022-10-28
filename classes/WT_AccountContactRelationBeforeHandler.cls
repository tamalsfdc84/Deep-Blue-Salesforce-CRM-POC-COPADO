/**
* @Name             WT_AccountContactRelationBeforeHandler 
* @Author           
* @ModifiedBy
* @Version          v1.0
* @CreatedDate      16-FEB-2021
* @UsedBy           WT_AccountContactTrigger
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* this is used by trigger WT_AccountContactTrigger
*  --------------------------------------------------------------------------------------------------------------
* @Changes
* --------------------------------------------------------------------------------------------------------------
**/
// Code Coverage: WT_AccountContactRelationBeforeHandler_T
public class WT_AccountContactRelationBeforeHandler extends TriggerHandler
{
    private List<AccountContactRelation> listNewAccountContactRelation = new List<AccountContactRelation>();
    private List<AccountContactRelation> listOldAccountContactRelation = new List<AccountContactRelation>();
    private Map<Id, AccountContactRelation> mapNewAccountContactRelationIdandAccountContactRelation = new Map<Id, AccountContactRelation>();
    private Map<Id, AccountContactRelation> mapOldAccountContact = null;
    public static Boolean isFirstTime = true;
    //constructor 
    public WT_AccountContactRelationBeforeHandler()
    {              
        PopulateGlobalLists();        
    }    
    public override void beforeInsert()
    {
        SetRelationToInactiveOnEndDate();
        SetRelationToActiveOnNoEndDate();
    }    
    public override void beforeUpdate()
    {
        SetRelationToInactiveOnEndDate();
        SetRelationToActiveOnNoEndDate();
    }  
     public override void beforeDelete()
    {
        
    }
    private void PopulateGlobalLists()
    {        
       if(trigger.isUpdate)
        {
            this.listNewAccountContactRelation = (List<AccountContactRelation>) Trigger.new;
            this.mapNewAccountContactRelationIdandAccountContactRelation = (Map<Id, AccountContactRelation>) Trigger.newMap;
            this.mapOldAccountContact = (Map<Id, AccountContactRelation>) Trigger.oldMap;
        }
        if(trigger.isInsert)
        {
            this.listNewAccountContactRelation = (List<AccountContactRelation>) Trigger.new;            
        }
        if(trigger.isDelete)
        {
            this.listOldAccountContactRelation = (List<AccountContactRelation>) Trigger.old;
        }
    }      
    
    private void SetRelationToInactiveOnEndDate()
    {
        for(AccountContactRelation newRelation : listNewAccountContactRelation)
        {
            if(newRelation.EndDate != null && newRelation.IsActive)
            {
                newRelation.IsActive = false;
            }
        }
    }
    
    private void SetRelationToActiveOnNoEndDate()
    {
        for(AccountContactRelation newRelation : listNewAccountContactRelation)
        {
            if(newRelation.EndDate == null && !newRelation.IsActive)
            {
                newRelation.IsActive = true;
            }
        }
    }
}