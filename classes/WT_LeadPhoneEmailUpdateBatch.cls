/**
* --------------------------------------------------------------------------------------------------------------
* @Name             WT_LeadPhoneEmailUpdateBatch
* @Author           Krupa Chinthakindi
* @Version          v1.0
* @CreatedDate      03-29-2022
* @UsedBy      
* -----------------------------------------------------------------------------------------------------------------------------
* @Description      This batch is used to update Lead.Phone and Lead.WT_Account_Referred_Email__c with Account Phone and Email
* Test Class        WT_LeadPhoneEmailUpdateBatch_T
------------------------------------------------------------------------------------------------------------------------------------------
**/
public class WT_LeadPhoneEmailUpdateBatch implements Database.Batchable<sObject>, Database.Stateful
{
    Set<Id> setFailedLeadId = new Set<Id>();
    Set<Id> setLeadIdToReprocess = new Set<Id>();
    List<String> listToEmailAddress = new List<String>();
    public Integer countFailedLeadRecord = 0;
    public Integer countSuccessfulLeadRecord = 0;
    public WT_LeadPhoneEmailUpdateBatch(Set<Id> setLeadIdToReprocess, List<String> listToEmailAddress)
    {
        this.setLeadIdToReprocess = setLeadIdToReprocess;
        this.listToEmailAddress = listToEmailAddress;
    }
    public Database.QueryLocator start(Database.BatchableContext bc) 
    {
        String query = 'SELECT Id, Phone, WT_Account_Referred_Email__c, FinServ__RelatedAccount__c FROM Lead';
        if(!setLeadIdToReprocess.isEmpty())
        {
            query = 'SELECT Id, Phone, WT_Account_Referred_Email__c, FinServ__RelatedAccount__c FROM Lead WHERE Id IN :setLeadIdToReprocess';
        }
        return Database.getQueryLocator(query);        
    }
     public void execute(Database.BatchableContext bc, List<Lead> ListLead)
     {
        Set<Id> setAccountId = new Set<Id>();
        List<Lead> listLeadUpdate = new List<Lead>();
        Map<Id,Account> mapAccountIdAndAccount = new Map<Id,Account>();
        Id personAcountCustomerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Customer').getRecordTypeId();
        Id personAccountProspectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Prospect').getRecordTypeId();
        Id businessAccountCustomerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('BusinessAccount_Customer').getRecordTypeId();
        Id businessAccountProspectRecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('BusinessAccount_Prospect').getRecordTypeId();
      
        for(Lead leadRecord: ListLead)
        {
           if(leadRecord.FinServ__RelatedAccount__c !=null)
		    {
		        setAccountId.add(leadRecord.FinServ__RelatedAccount__c);
		    }
        }
        for(Account relatedAccount: [SELECT Id,
                                        RecordTypeId,
                                        PersonHomePhone,
                                        PersonEmail,Phone,
                                        WT_Primary_Email_Ranked__c 
                                        FROM Account 
                                        WHERE Id IN: setAccountId])
        {                         
            mapAccountIdAndAccount.put(relatedAccount.Id,relatedAccount);
        }
        for(Lead leadRecord: ListLead)
        {
            if(leadRecord.FinServ__RelatedAccount__c !=null && mapAccountIdAndAccount.containsKey(leadRecord.FinServ__RelatedAccount__c))
            {   
				Account relatedAccount = mapAccountIdAndAccount.get(leadRecord.FinServ__RelatedAccount__c);
				if((relatedAccount.RecordTypeId == personAcountCustomerRecordTypeId ||
				relatedAccount.RecordTypeId == personAccountProspectRecordTypeId) && (relatedAccount.PersonHomePhone!=null || relatedAccount.PersonEmail!=null))
				{
					leadRecord.Phone = relatedAccount.PersonHomePhone;
					leadRecord.WT_Account_Referred_Email__c = relatedAccount.PersonEmail;
				}
				else if(relatedAccount.RecordTypeId == businessAccountCustomerRecordTypeId ||
				relatedAccount.RecordTypeId == businessAccountProspectRecordTypeId && (relatedAccount.Phone!=null || relatedAccount.WT_Primary_Email_Ranked__c!=null))
				{
					leadRecord.Phone =  relatedAccount.Phone;
					leadRecord.WT_Account_Referred_Email__c =   relatedAccount.WT_Primary_Email_Ranked__c;
				}
			}
            listLeadUpdate.add(leadRecord);
        }
        if(listLeadUpdate.size()>0)
        {
            Integer saveResultIterator = 0;
            Database.SaveResult[] listLeadUpdateSaveResult  = Database.Update(listLeadUpdate,false);
            for (Database.SaveResult leadRecordUpdate : listLeadUpdateSaveResult) 
            {
                if (!leadRecordUpdate.isSuccess())
                {  
                    countFailedLeadRecord++;
                    setFailedLeadId.add(listLeadUpdate[saveResultIterator].Id);
                }
                else
                {
                    countSuccessfulLeadRecord++;
                }
                saveResultIterator++;
            }
         }
    }
    public void finish(Database.BatchableContext bc)
    {    
        if(!setFailedLeadId.isEmpty())
		{
            String csvHeader = 'FailedLeadId';
            String csvBody = '';
            for(Id failedLeadRecordId: setFailedLeadId)
            {
                csvBody += failedLeadRecordId + '\n';
            }
            if(!Test.isRunningTest())
            {
                WT_UtilityMethods.SendEmailWithCsvAttachment(listToEmailAddress, 'LeadRecord Failures.csv', 'Failures From WT_LeadPhoneEmailUpdateBatch batch',
                                                            'See attached for failures', csvHeader, csvBody);
            }
        }
    }
}