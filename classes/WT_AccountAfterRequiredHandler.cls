public class WT_AccountAfterRequiredHandler extends TriggerHandler
{
    List<Account> listNewAccount = new List<Account>();
    Map<Id, Account> mapNewAccountIdandAccount = new Map<Id, Account>();
    Map<Id, Account> mapOldAccountIdandAccount = new Map<Id, Account>();
    public WT_AccountAfterRequiredHandler()
    {
        PopulateGlobalLists();        
    }
    public override void afterInsert()
    {
        
    }
    public override void afterUpdate()
    {
        OnUpdateMapAccountToReferral(mapNewAccountIdandAccount,mapOldAccountIdandAccount);
    }
    public override void afterDelete()
    {
        
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
* This method is to map Account Phone, Email to Referral Phone and WT_Account_Referred_Email__c 
JIRA Ticket - SGE-110
* --------------------------------------------------------------------------------------------------------------
* @Param  mapNewAccountIdandAccount    Map of new Account
* @Param  mapOldAccountIdandAccount    Map of old Account
* @Return void                         none
@CreatedBy                           Krupa Chinthakindi
* --------------------------------------------------------------------------------------------------------------
**/
    
    public void OnUpdateMapAccountToReferral(Map<Id, Account> mapNewAccountIdandAccount,Map<Id, Account> mapOldAccountIdandAccount)
    {
        try
        {
            List<Lead> listReferral = new List<Lead>();
            Map <Id, Account> mapAccountIdAndAccount = new Map <Id, Account>();
            Id personAccountCustomerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Customer').getRecordTypeId();
            Id personAccountProspectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Prospect').getRecordTypeId();
            Id businessAccountCustomerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('BusinessAccount_Customer').getRecordTypeId();
            Id businessAccountProspectRecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('BusinessAccount_Prospect').getRecordTypeId();
            
            for(Account accountRecord : mapNewAccountIdandAccount.values())
            {
                if((accountRecord.RecordTypeId == personAccountCustomerRecordTypeId || accountRecord.RecordTypeId == personAccountProspectRecordTypeId) &&
                   (accountRecord.PersonHomePhone != mapOldAccountIdandAccount.get(accountRecord.Id).PersonHomePhone ||
                    accountRecord.PersonEmail != mapOldAccountIdandAccount.get(accountRecord.Id).PersonEmail))
                {
                    mapAccountIdAndAccount.put(accountRecord.Id, accountRecord);   
                    
                }
                else if((accountRecord.RecordTypeId == businessAccountCustomerRecordTypeId ||
                         accountRecord.RecordTypeId == businessAccountProspectRecordTypeId) &&
                        (accountRecord.Phone != mapOldAccountIdandAccount.get(accountRecord.Id).Phone ||
                         accountRecord.WT_Primary_Email_Ranked__c != mapOldAccountIdandAccount.get(accountRecord.Id).WT_Primary_Email_Ranked__c))
                {
                    mapAccountIdAndAccount.put(accountRecord.Id, accountRecord);          
                }
            }
            
            List<Lead> listLead = [SELECT Id, 
                                   Phone, 
                                   WT_Account_Referred_Email__c,
                                   FinServ__RelatedAccount__c FROM  Lead 
                                   WHERE FinServ__RelatedAccount__c IN: mapAccountIdAndAccount.keyset()];
            
            for(Lead relatedLead : listLead)
            {
                Account relatedAccount = mapAccountIdAndAccount.get(relatedLead.FinServ__RelatedAccount__c);
                if(relatedAccount.RecordTypeId == personAccountCustomerRecordTypeId || relatedAccount.RecordTypeId == personAccountProspectRecordTypeId)
                {
                    relatedLead.Phone = relatedAccount.PersonHomePhone;
                    relatedLead.WT_Account_Referred_Email__c = relatedAccount.PersonEmail;
                }
                else if(relatedAccount.RecordTypeId == businessAccountCustomerRecordTypeId || relatedAccount.RecordTypeId == businessAccountProspectRecordTypeId)
                {
                    relatedLead.Phone = relatedAccount.Phone;
                    relatedLead.WT_Account_Referred_Email__c = relatedAccount.WT_Primary_Email_Ranked__c;
                }
                
                listReferral.add(relatedLead);    
            }
            
            if(!listReferral.isEmpty())
            {
                update listReferral;
            }
        }
        catch(Exception e)
        {
            System.debug('The following exception has occurred: AccountAfterHandler>onUpdateMapAccountToReferral> ' + e.getMessage());
        }   
    }
}