/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_ReferralEmailProcess
* @Author			Krupa Chinthakindi<KChintha@wintrust.com>
* @ModifiedBy		Krupa Chinthakindi<KChintha@wintrust.com>
* @Version			v1.0
* @CreatedDate		05-04-2022
* @UsedBy			Lead Object
* -----------------------------------------------------------------------------------------------------------------------------
* @Description
* This class to send an email to Loan Officer and Assistant. And it is called from process builder "Referrals Process Automation"

* --------------------------------------------------------------------------------------------------------------------------------
* @Changes
* vX.X
* MM-DD-YYYY
* --------------------------------------------------------------------------------------------------------------
**/
public without sharing class WT_ReferralEmailProcess 
{  
    /**
*-----------------------------------------------------------------------------------------------------------------------------
* @description
*This method used to send an email to Loan officer and Load Assistant on New Referral Creation.
*-----------------------------------------------------------------------------------------------------------------------------
* @param    ListLeadIds   This contains list of Lead RecordId from process builder 
@author   Krupa Chinthakindi
@Date     04/26/2022
*-----------------------------------------------------------------------------------------------------------------------------
**/
    @InvocableMethod
    public static List<string> SendEmailOnReferralCreation(List<Id> listLeadId)
    {
        system.debug('inside the class');
        List<string> listLead = new List<string>();
        SendEmailToLoanOfficerAndLoadAssistant(listLeadId,'New_Referral_Email_Notification');
        return null;
    } 
    /**
*-----------------------------------------------------------------------------------------------------------------------------
* @description
*This method used to send an email to Loan officer and Load Assistant on Referral Update
*-----------------------------------------------------------------------------------------------------------------------------
* @param    listLeadId,EmailTemplateName    
@author   Krupa Chinthakindi
@Date     04/26/2022
*-----------------------------------------------------------------------------------------------------------------------------
**/
    public static void SendEmailToLoanOfficerAndLoadAssistant(List<Id> listLeadId,String EmailTemplateName)
    {
        Set<Id> setUserIds = new Set<Id>();
        Map<Id,List<String>> mapOfLoanAssistant= new Map<Id,List<String>>(); 
        List<Messaging.SingleEmailMessage> listOfEmailMessage = new List<Messaging.SingleEmailMessage>();
        List<String> listToEmailAddress = new List<String>(); 
        List<String> listCcEmailAddress = new List<String>();
        List<Lead>  ListOfLead = [SELECT id, 
                                  Name, 
                                  WT_Referred_To__c,
                                  OwnerId,
                                  Status,
                                  CreatedDate,
                                  WT_Date_Qualified__c,
                                  WT_Referred_To__r.Email,
                                  WT_Referred_To__r.Name,
                                  WT_Non_CRM_Referred_By__r.Name,
                                  RecordType.DeveloperName,
                                  FinServ__ReferredByUser__r.Name 
                                  FROM Lead 
                                  WHERE Id IN:listLeadId];
        for(Lead leadRecord: ListOfLead)
        {
            setUserIds.add(leadRecord.WT_Referred_To__c);       
        }
        
        List<WT_Assistant_Lookup__c> ListAssistantLookUp = [SELECT Id, 
                                                            Name, 
                                                            WT_Assisting_User__c,
                                                            WT_Assisting_Workstream__c,
                                                            WT_User_To_Assist__c,
                                                            WT_Assisting_User__r.Email
                                                            FROM WT_Assistant_Lookup__c
                                                            WHERE WT_User_To_Assist__c IN: setUserIds and WT_Assisting_Workstream__c = 'Referral'];
        if(!ListAssistantLookUp.isEmpty())
        {
            for(WT_Assistant_Lookup__c LoanAssistant: ListAssistantLookUp)
            {
                if(mapOfLoanAssistant.containsKey(LoanAssistant.WT_User_To_Assist__c)) 
                {
                    mapOfLoanAssistant.get(LoanAssistant.WT_User_To_Assist__c).add(LoanAssistant.WT_Assisting_User__r.Email);
                } 
                else 
                {
                    mapOfLoanAssistant.put(LoanAssistant.WT_User_To_Assist__c, new List<string> { LoanAssistant.WT_Assisting_User__r.Email});
                }
            }
        }
        List<EmailTemplate> listEmailTemplate = [SELECT Id, 
                                                 Name
                                                 FROM EmailTemplate
                                                 WHERE DeveloperName =:EmailTemplateName];   
        for(Lead leadRecord : ListOfLead)
        {
            if(mapOfLoanAssistant.containsKey(leadRecord.WT_Referred_To__c))
            {
                listCcEmailAddress = mapOfloanAssistant.get(leadRecord.WT_Referred_To__c);
            }
            listToEmailAddress.add(leadRecord.WT_Referred_To__r.Email);
            Messaging.SingleEmailMessage emailMessage = WT_UtilityMethods.SendEmailToRecordWhatId(listToEmailAddress,listCcEmailAddress,LeadRecord.OwnerId,false,listEmailTemplate[0].Id,LeadRecord.Id);
            listOfEmailMessage.add(emailMessage);
        }
        Messaging.SendEmailResult[] emailResult = Messaging.sendEmail(listOfEmailMessage);
    }    
}