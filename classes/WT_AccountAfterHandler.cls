/**
* ----------------------------------------------------------------------------------------------------------------
* @Name             WT_AccountAfterHandler
* @Author           Karishma Keswani    <kkeswani@wintrust.com>
* @ModifiedBy       Karishma Keswani    <kkeswani@wintrust.com>
* @Version          v1.0
* @CreatedDate      13-11-2020
* @UsedBy           Account Object
* -----------------------------------------------------------------------------------------------------------------
* @Description
* This is handler class for account trigger.
*
* This handles all the after logic of the account trigger.
* ------------------------------------------------------------------------------------------------------------------
* @Changes
* v1.1             Vamsi Pulikalli  <VPulikal@wintrust.com>
* 23-12-2020       Added method RestrictAccountsMerge which doesn't allow merging of customer account into Prospect.
* v1.2             Anoop B  <abattini@wintrust.com>
* 02-07-2021       Added method updateInteractionDatesonHouseHold which will calculate Roll up od First and last interaction dates
* 20-sep-2021       Added updateInteractionDatesonRelationshipGroup method to calculate First and last interaction dates or relationgroup account.
* -------------------------------------------------------------------------------------------------------------------
**/
public class WT_AccountAfterHandler extends TriggerHandler
{
    List<Account> listNewAccount = new List<Account>();
    Map<Id, Account> mapNewAccountIdandAccount = new Map<Id, Account>();
    Map<Id, Account> mapOldAccountIdandAccount = new Map<Id, Account>();
    public static Boolean isFirstTime = true;
    public static Boolean isFirstTimeRun = true;
    public WT_AccountAfterHandler()
    {
        //this.setMaxLoopCount(1);
        PopulateGlobalLists();        
    }
    public override void afterInsert()
    {
        CreateCoveragePlan(mapNewAccountIdandAccount,null);
    }
    public override void afterUpdate()
    {
        CreateCoveragePlan(mapNewAccountIdandAccount,mapOldAccountIdandAccount);
        UpdateInteractionOnHousehold(mapNewAccountIdandAccount, mapOldAccountIdandAccount);
        updateInteractionDatesonRelationshipGroup(mapNewAccountIdandAccount,mapOldAccountIdandAccount);
    }
    public override void afterDelete()
    {
        RestrictAccountsMerge(mapOldAccountIdandAccount);
    }
    private void PopulateGlobalLists()
    {        
        listNewAccount = (List<Account>) Trigger.new;
        mapNewAccountIdandAccount = (Map<Id, Account>) Trigger.newMap;
        mapOldAccountIdandAccount = (Map<Id, Account>) Trigger.oldMap;
    }
  
    /**
* --------------------------------------------------------------------------------------------------------------
* @Description
* This method Coverage action plan to account.
* --------------------------------------------------------------------------------------------------------------
* @Param  mapNewAccountIdandAccount    Map of new Account
* @Param  mapOldAccountIdandAccount    Map of old Account
* @Return void                         none
* --------------------------------------------------------------------------------------------------------------
**/
    private void CreateCoveragePlan(Map<Id, Account> mapNewAccountIdandAccount,Map<Id, Account> mapOldAccountIdandAccount)
    {
        try
        {
            List <Account> listNewClassifiedAccount = new List<Account>();
            FINAL Id businnessAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('IndustriesBusiness').getRecordTypeId();
            for(Account accountRec:mapNewAccountIdandAccount.values())
            {                
                if(accountRec.RecordTypeId == businnessAccountRecordTypeId && 
                   ((mapOldAccountIdandAccount!=null && accountRec.WT_Classification__c!=null 
                     && accountRec.WT_Classification__c!=mapOldAccountIdandAccount.get(accountRec.id).WT_Classification__c) 
                    || (mapOldAccountIdandAccount==null && accountRec.WT_Classification__c!=null)
                   ))
                {
                    listNewClassifiedAccount.add(accountRec);
                }
            }
            if(listNewClassifiedAccount!=null && !listNewClassifiedAccount.isEmpty())
            {
                List<ActionPlan> listCreateActionPlan = new List<ActionPlan>();
                ActionPlan actionPlanRecord;
                map<string,String> mapClassificationToActionPlanTemplateName = new map<string,String>();
                map<String,Id> mapTemplateNametoVersionId = new map<String,Id>();  
                List<ActionPlanTemplateVersion> coveragePlanTempalteVersion;
                String actionPlanTemplateName = System.Label.WT_Coverage_Action_Plan_Template_Name+'%';
                Id useTemplateVersionid;
                for(WT_Coverage_Action_Plan_Task__mdt coverageActionPlan: [Select MasterLabel,WT_Classification__c,WT_Days_for_Due_Date_for_Next_Task__c,WT_Number_of_Tasks__c,Action_Plan_Template__c 
                                                                           from WT_Coverage_Action_Plan_Task__mdt])
                {
                    mapClassificationToActionPlanTemplateName.put(coverageActionPlan.WT_Classification__c,coverageActionPlan.Action_Plan_Template__c);                                   
                }
                coveragePlanTempalteVersion = [Select id,ActionPlanTemplate.Name from ActionPlanTemplateVersion where ActionPlanTemplateVersion.ActionPlanTemplate.Name like: actionPlanTemplateName and ActionPlanTemplateVersion.status='Final'];
                if(coveragePlanTempalteVersion!=null && !coveragePlanTempalteVersion.isEmpty())
                {
                    for(ActionPlanTemplateVersion templateRecord: coveragePlanTempalteVersion)
                    {
                        mapTemplateNametoVersionId.put(templateRecord.ActionPlanTemplate.Name,templateRecord.id);
                    }
                    for(Account accountRec:mapNewAccountIdandAccount.values())
                    {                    
                        useTemplateVersionid = mapTemplateNametoVersionId.get(mapClassificationToActionPlanTemplateName.get(accountRec.WT_Classification__c));
                        if(useTemplateVersionid!=null)
                        {
                            actionPlanRecord = new ActionPlan(ActionPlanTemplateVersionId=useTemplateVersionid,
                                                              TargetId=accountRec.Id,StartDate=System.today(), ActionPlanType='Industries',
                                                              ActionPlanState='Not Started',OwnerId =accountRec.OwnerId,
                                                              Name='Coverage Plan'
                                                             );                        
                            listCreateActionPlan.add(actionPlanRecord);
                        }                
                    }
                    if(!listCreateActionPlan.isEmpty())
                    {
                        insert listCreateActionPlan;
                    }
                }
            }            
        }
        catch(Exception e)
        {
            System.debug('The following exception has occurred: AccountAfterHandler>createCoveragePlan> ' + e.getMessage());
        }               
    }
    /**
* --------------------------------------------------------------------------------------------------------------
* @Description
* This method is used to throw error if we are merging two accounts of record types Customer and Prospect
* and the master record is selected as Prospect
* --------------------------------------------------------------------------------------------------------------
* @Param  mapOldAccountIdandAccount    Map of old Account
* @Return void                         none
* --------------------------------------------------------------------------------------------------------------
**/    
    private void RestrictAccountsMerge(Map<Id, Account> mapOldAccountIdandAccount)
    {        
        Id customerAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Customer').getRecordTypeId();
        Id prospectAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Prospect').getRecordTypeId();        
        Set<ID> setMasterIds = new Set<Id>();        
        try
        {
            for(Account oldAccount: mapOldAccountIdandAccount.values())
            {
                if(oldAccount.MasterRecordId != null && oldAccount.recordTypeId == customerAccountRecordTypeId)
                {
                    setMasterIds.add(oldAccount.MasterRecordId);             
                }
            }
            if(!setMasterIds.isempty()){
                list<account> listOldMasterAccount = [Select id, recordTypeId from account where id IN: setMasterIds];           
                for(Account masterAccount : listOldMasterAccount){
                    if(masterAccount.recordTypeId == prospectAccountRecordTypeId){
                        for(Account oldAccount: mapOldAccountIdandAccount.values())
                        {
                            oldAccount.addError(System.Label.WT_Account_Error_on_Merge);
                        }
                    }
                }
            }
        }
        catch(Exception e)
        {
            System.debug('The following exception has occurred: AccountAfterHandler>RestrictAccountsMerge> ' + e.getMessage());
        } 
    }
    /**
* --------------------------------------------------------------------------------------------------------------
* @Description
* This method is used to calculate interaction dates for HouseHold Accounts
* 
* --------------------------------------------------------------------------------------------------------------
* @Param  mapNewAccountIdandAccount    Map of new Account
* @Return void                         none
* --------------------------------------------------------------------------------------------------------------
**/
    private void UpdateInteractionOnHousehold(Map<Id, Account> mapNewAccountIdandAccount, Map<Id, Account> mapOldAccountIdandAccount)
    {
        Set<Id> setHouseholdIdToQueryAccountContactRelation = new Set<Id>();
        List<Account> listHouseholdToUpdate = new List<Account>();
        Map<Id, Date> mapHouseholdIdAndFirstDateOfContact = new Map<Id, Date>();
        Map<Id, Date> mapHouseholdIdAndLastDateOfContact = new Map<Id, Date>();
        Id personAccountCustomerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account (Customer)').getRecordTypeId();
        
        for(Account newAccount : mapNewAccountIdandAccount.values())
        {
            Account oldAccount = null;
            if(mapOldAccountIdandAccount.containsKey(newAccount.Id))
            {
                oldAccount = mapOldAccountIdandAccount.get(newAccount.Id);
            }
            if( String.isNotBlank(newAccount.WT_Parent_Household__pc))
            {  setHouseholdIdToQueryAccountContactRelation.add(newAccount.WT_Parent_Household__pc);   }
            if(oldAccount != null && 
               (oldAccount.WT_Last_Date_Of_Contact__c != newAccount.WT_Last_Date_Of_Contact__c || oldAccount.WT_First_Date_Of_Contact__c != newAccount.WT_First_Date_Of_Contact__c) &&
               String.isNotBlank(newAccount.WT_Parent_Household__pc) && newAccount.RecordTypeId == personAccountCustomerRecordTypeId)
            {
                setHouseholdIdToQueryAccountContactRelation.add(newAccount.WT_Parent_Household__pc); 
            }
        }
        
        if(!setHouseholdIdToQueryAccountContactRelation.isEmpty())
        {
            for(AccountContactRelation relatedRelation : [SELECT Id, Contact.Account.WT_First_Date_Of_Contact__c, Contact.Account.WT_Last_Date_Of_Contact__c, 
                                                          AccountId, ContactId
                                                          FROM AccountContactRelation
                                                          WHERE AccountId IN: setHouseholdIdToQueryAccountContactRelation
                                                          AND EndDate = NULL])
            {
                if(relatedRelation.Contact.Account.WT_First_Date_Of_Contact__c != null)
                {
                    Date firstDateOfContact = relatedRelation.Contact.Account.WT_First_Date_Of_Contact__c;
                    if(mapHouseholdIdAndFirstDateOfContact.containsKey(relatedRelation.AccountId))
                    {
                        Date existingFirstDateOfContact = mapHouseholdIdAndFirstDateOfContact.get(relatedRelation.AccountId);
                        if(existingFirstDateOfContact < firstDateOfContact)
                        {
                            firstDateOfContact = existingFirstDateOfContact;
                        }
                    }
                    
                    mapHouseholdIdAndFirstDateOfContact.put(relatedRelation.AccountId, firstDateOfContact);
                }
                if(relatedRelation.Contact.Account.WT_Last_Date_Of_Contact__c != null)
                {
                    Date lastDateOfContact = relatedRelation.Contact.Account.WT_Last_Date_Of_Contact__c;
                    if(mapHouseholdIdAndLastDateOfContact.containsKey(relatedRelation.AccountId))
                    {
                        Date existingLastDateOfContact = mapHouseholdIdAndLastDateOfContact.get(relatedRelation.AccountId);
                        if(existingLastDateOfContact > lastDateOfContact)
                        {
                            lastDateOfContact = existingLastDateOfContact;
                        }
                    }
                    
                    mapHouseholdIdAndLastDateOfContact.put(relatedRelation.AccountId, lastDateOfContact);
                }
            }
            
            for(Id householdId : setHouseholdIdToQueryAccountContactRelation)
            {
                Account householdAccount = new Account();
                householdAccount.Id = householdId;
                householdAccount.WT_Last_Date_Of_Contact__c = null;
                householdAccount.WT_First_Date_Of_Contact__c = null;
                
                if(mapHouseholdIdAndLastDateOfContact.containsKey(householdId))
                {
                    householdAccount.WT_Last_Date_Of_Contact__c = mapHouseholdIdAndLastDateOfContact.get(householdId);
                }
                if(mapHouseholdIdAndFirstDateOfContact.containsKey(householdId))
                {
                    householdAccount.WT_First_Date_Of_Contact__c = mapHouseholdIdAndFirstDateOfContact.get(householdId);
                }
                listHouseholdToUpdate.add(householdAccount);
            }
        }
        
        if(!listHouseholdToUpdate.isEmpty())
        {
            update listHouseholdToUpdate;
        }
    }
    /**
* --------------------------------------------------------------------------------------------------------------
* @Description
* This method is used to calculate interaction dates for Relationship Group Accounts
* 
* --------------------------------------------------------------------------------------------------------------
* @Param  mapNewAccountIdandAccount    Map of new Account
* @Return void                         none
* --------------------------------------------------------------------------------------------------------------
**/
    private void updateInteractionDatesonRelationshipGroup(Map<Id, Account> mapNewAccountIdandAccount, Map<Id, Account> mapOldAccountIdandAccount)
    {
        List<ID> listAccountFiltered = new List<Id>();
        for (ID accountIdVar : mapNewAccountIdandAccount.keyset())
        {
            if(mapNewAccountIdandAccount.get(accountIdVar).WT_First_Date_Of_Contact__c != mapOldAccountIdandAccount.get(accountIdVar).WT_First_Date_Of_Contact__c ||
               mapNewAccountIdandAccount.get(accountIdVar).WT_Last_Date_Of_Contact__c != mapOldAccountIdandAccount.get(accountIdVar).WT_Last_Date_Of_Contact__c )
            {
                listAccountFiltered.add(accountIdVar);
            }
        }
        if(listAccountFiltered.size()<=0)
            return;
        
        List<WT_RelationshipGroup_Relation__c> listRelationGrpRel = [SELECT Id,WT_Account__c 
                                                                     FROM WT_RelationshipGroup_Relation__c 
                                                                     WHERE WT_RelatedAccount__c in:listAccountFiltered AND
                                                                     WT_Active__c =true ];
        if(listRelationGrpRel.size()>0)
        {
            WT_RelationshipGroupRelationAfterHandler.SetInteractionDateOnRelationshipGroup(listRelationGrpRel);
        }
    }
}