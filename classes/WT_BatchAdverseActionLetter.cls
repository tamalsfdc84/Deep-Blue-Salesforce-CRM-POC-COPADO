global class WT_BatchAdverseActionLetter implements Database.Batchable<sObject>
{
    global Database.QueryLocator start(Database.BatchableContext batchContext) 
    {
        return Database.getQueryLocator([SELECT Id,
                                         PartyId__c,
                                         DateProcessed__c
                                         FROM WT_AdverseActionNotice__c
                                         WHERE DateProcessed__c = null
                                         ORDER BY CreatedDate
                                         LIMIT 2]);
    }
    
    global void execute(Database.BatchableContext batchContext, List<WT_AdverseActionNotice__c> scope)
    {
        Set<Id> setPartyId = new Set<Id>();
        List<WT_AdverseActionNotice__c> listNoticeToUpdate = new List<WT_AdverseActionNotice__c>();
        for(WT_AdverseActionNotice__c notice : scope)
        {
            setPartyId.add(notice.PartyId__c);
            notice.DateProcessed__c = System.now();
            listNoticeToUpdate.add(notice);
        }
        
        Map<Id, tffa__Application__c> mapPartyIdAndApplication = new Map<Id, tffa__Application__c>();
        
        for(tffa__ApplicationPartyXref__c partyXref : [SELECT Id,
                                                       tffa__Application__c,
                                                       tffa__Application__r.Name,
                                                       tffa__Application__r.tffa__Status__c,
                                                       tffa__Party__c
                                                       FROM tffa__ApplicationPartyXref__c
                                                       WHERE tffa__Party__c IN :setPartyId])
        {
            tffa__Application__c relatedApplication = new tffa__Application__c();
            relatedApplication.Id = partyXref.tffa__Application__c;
            relatedApplication.Name = partyXref.tffa__Application__r.Name;
            relatedApplication.tffa__Status__c = partyXref.tffa__Application__r.tffa__Status__c;
            
            mapPartyIdAndApplication.put(partyXref.tffa__Party__c, relatedApplication);
        }
        
        for(tffa__Party__c partyToEmail : [SELECT Id,
                                           Name,
                                           tffa__PrimaryEmail__c,
                                           tffa__PrimaryPhone__c,
                                           tffa__Suffix__c,
                                           tffa__FirstName__c,
                                           tffa__LastName__c,
                                           tffa__OTP__c,
                                           tffa__KYCDecisionOutcome__c
                                           FROM tffa__Party__c
                                           WHERE Id IN :setPartyId])
        {
            if(mapPartyIdAndApplication.containsKey(partyToEmail.Id))
            {
                new CZWTFCPartyEventExtensionOld('Application_Declined_Adverse').sendAdverseActionMail(partyToEmail, mapPartyIdAndApplication.get(partyToEmail.Id));   
            }
            else
            {
                new CZWTFCPartyEventExtensionOld('Application_Declined_Adverse').post(partyToEmail);   
            }
        }
        
        update listNoticeToUpdate;
    }
    
    global void finish(Database.BatchableContext batchContext)
    {
        List<WT_AdverseActionNotice__c> listNotice = [SELECT Id,
                                                      PartyId__c,
                                                      DateProcessed__c
                                                      FROM WT_AdverseActionNotice__c
                                                      WHERE DateProcessed__c = null
                                                      ORDER BY CreatedDate];
        
        if(!listNotice.isEmpty() && listNotice.size() > 0)
        {
            Database.executeBatch(new WT_BatchAdverseActionLetter(), 2);
        }
    }
}