public class WT_TFSubmissionTriggerAfterHandler extends TriggerHandler
{
	List<tffa__Submission__c> listNewSubmission = new List<tffa__Submission__c>();
    Map<Id, tffa__Submission__c> mapNewSubmissionIdAndSubmission = new Map<Id, tffa__Submission__c>();
    Map<Id, tffa__Submission__c> mapOldSubmissionIdAndSubmission = new Map<Id, tffa__Submission__c>();
    List<Opportunity> listOpportunityToUpsert = new List<Opportunity>();
    
    public WT_TFSubmissionTriggerAfterHandler() 
    {
        this.listNewSubmission = (List<tffa__Submission__c>) Trigger.new;         
        this.mapNewSubmissionIdAndSubmission = (Map<Id, tffa__Submission__c>) Trigger.newMap;
        this.mapOldSubmissionIdAndSubmission = (Map<Id, tffa__Submission__c>) Trigger.oldMap;        
    }
    public override void afterInsert()
    {
        //TODO: BEB Referral
        //Get info on how to identify these types of referrals
        //Submission will have a flag (IsBEB or something similar) to identify the Referral submissions
        CreateOpportunity();
        PerformDml();
    }
    public override void afterUpdate()
    { 
        UpdateOpportunity();
        PerformDml();
    }  

    private void PerformDml()
    {
        if(!listOpportunityToUpsert.isEmpty())
        {
            try
            {
            	upsert listOpportunityToUpsert;
            }
            catch(Exception ex)
            {
                System.debug('Exception: ' + ex.getMessage());
            }
        }
    }
    
    private void CreateOpportunity()
    {
        Id terafinaOpportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('WT_Terafina').getRecordTypeId();
        for(tffa__Submission__c newSubmission : listNewSubmission)
        {
            if(String.isNotBlank(newSubmission.CZGoogleClickID__c))
            {
                Opportunity newOpportunity = new Opportunity();
                newOpportunity.RecordTypeId = terafinaOpportunityRecordTypeId;
                newOpportunity.Name = newSubmission.Name;
                newOpportunity.CloseDate = System.today().addDays(90);
                newOpportunity.StageName = 'Stage 1 - Opportunity Identified';
                newOpportunity.GCLID__c = newSubmission.CZGoogleClickID__c;
                newOpportunity.WT_Status__c = 'Open';
                
                listOpportunityToUpsert.add(newOpportunity);
            }
        }
    }
    
    private void UpdateOpportunity()
    {
        Set<String> setValidStatus = new Set<String>
        {
            'ABANDONED',
                'CANCELLED',
                'EXPIRED',
                'COMPLETED'
        };
            
        Set<String> setGoogleClickIdToQuery = new Set<String>();
        Map<String, tffa__Submission__c> mapGoogleClickIdAndSubmission = new Map<String, tffa__Submission__c>();
        for(tffa__Submission__c newSubmission : listNewSubmission)
        {
            tffa__Submission__c oldSubmission = mapOldSubmissionIdAndSubmission.get(newSubmission.Id);
            if(String.isNotBlank(newSubmission.CZGoogleClickID__c) && newSubmission.tffa__Status__c != oldSubmission.tffa__Status__c)
            {
                if(setValidStatus.contains(newSubmission.tffa__Status__c))
                {
                	setGoogleClickIdToQuery.add(newSubmission.CZGoogleClickID__c);
                    mapGoogleClickIdAndSubmission.put(newSubmission.CZGoogleClickID__c, newSubmission);    
                }                
            }
        }
        
        if(!setGoogleClickIdToQuery.isEmpty())
        {
            for(Opportunity relatedOpportunity : [SELECT Id,
                                                  StageName,
                                                  GCLID__c,
                                                  WT_Status_Reason__c,
                                                  WT_Status__c
                                                  FROM Opportunity
                                                  WHERE GCLID__c IN :setGoogleClickIdToQuery])
            {
                tffa__Submission__c relatedSubmission = mapGoogleClickIdAndSubmission.get(relatedOpportunity.GCLID__c);
                
                if(relatedSubmission.tffa__Status__c == 'ABANDONED' || relatedSubmission.tffa__Status__c == 'CANCELLED' ||
                   relatedSubmission.tffa__Status__c == 'EXPIRED')
                {
                    relatedOpportunity.StageName = 'Stage 7 - Deal Lost or Declined';
                    relatedOpportunity.WT_Status_Reason__c = null;           
                    relatedOpportunity.WT_Status__c = 'Closed/Lost';
                    listOpportunityToUpsert.add(relatedOpportunity);
                }
                else if(relatedSubmission.tffa__Status__c == 'COMPLETED')
                {
                    relatedOpportunity.StageName = 'Stage 6 - Deal Booked/Closed';
                    relatedOpportunity.WT_Status_Reason__c = null;
                    relatedOpportunity.WT_Status__c = 'Closed/Won';
                    listOpportunityToUpsert.add(relatedOpportunity);
                }
            }
        }
    }
}