public class WT_LeadBeforeRequiredHandler extends TriggerHandler
{
    List<Lead> listNewReferral = new List<Lead>();
    public WT_LeadBeforeRequiredHandler()
    {
        listNewReferral = (List<Lead>)Trigger.new;       
    }
    public override void beforeInsert()
    {
        PopulatePhoneAndEmailFromReferredAccount();
    }
    public override void beforeUpdate()
    {
        
    }
    
    /**
* -----------------------------------------------------------------------------------------------------------------------
* @Description
* This method is used to populate the Phone & WT_Account_Referred_Email__c information from the related Account Referred
JIRA Ticket SGE-110
* -----------------------------------------------------------------------------------------------------------------------
* @Param  listNewReferrals     List of Referral
* @Return void                 Returns none
* ----------------------------------------------------------------------------------------------------------------------
**/    
    public void PopulatePhoneAndEmailFromReferredAccount()
    {
        Set<Id> setAccountId = new Set<Id>();
        map<Id, Account> mapAccountIdAndAccount = new map<Id, Account>();
        Id personAcountCustomerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Customer').getRecordTypeId();
        Id personAccountProspecttRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Prospect').getRecordTypeId();
        Id businessAccountCustomerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('BusinessAccount_Customer').getRecordTypeId();
        Id businessAccountProspectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('BusinessAccount_Prospect').getRecordTypeId();
        
        for(Lead newLead : listNewReferral)
        {
            setAccountId.add(newLead.FinServ__RelatedAccount__c);
        }
        
        List<Account> listAccount = [SELECT Id,
                                     RecordTypeId,
                                     PersonHomePhone,
                                     PersonEmail,Phone,
                                     WT_Primary_Email_Ranked__c 
                                     FROM Account 
                                     WHERE Id IN: setAccountId];
        
        for(Account relatedAccount : listAccount)
        {
            mapAccountIdAndAccount.put(relatedAccount.Id,relatedAccount);
        }
        
        for(Lead leadRecord: listNewReferral)
        {
            if(leadRecord.FinServ__RelatedAccount__c != null && mapAccountIdAndAccount.containsKey(leadRecord.FinServ__RelatedAccount__c))
            {                
                Account relatedAccount = mapAccountIdAndAccount.get(leadRecord.FinServ__RelatedAccount__c);
                
                if((relatedAccount.RecordTypeId == personAcountCustomerRecordTypeId ||
                    relatedAccount.RecordTypeId == personAccountProspecttRecordTypeId) && (relatedAccount.PersonHomePhone != null || relatedAccount.PersonEmail != null))
                {
                    leadRecord.Phone = relatedAccount.PersonHomePhone;
                    leadRecord.WT_Account_Referred_Email__c = relatedAccount.PersonEmail;
                }
                else if(relatedAccount.RecordTypeId == businessAccountCustomerRecordTypeId ||
                        relatedAccount.RecordTypeId == businessAccountProspectRecordTypeId && (relatedAccount.Phone != null || relatedAccount.WT_Primary_Email_Ranked__c != null))
                {
                    leadRecord.Phone =  relatedAccount.Phone;
                    leadRecord.WT_Account_Referred_Email__c = relatedAccount.WT_Primary_Email_Ranked__c;
                }
            }
        }
    }
}