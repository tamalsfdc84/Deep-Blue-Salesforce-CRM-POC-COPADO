/*----------------------------------------------------------
*ModifiedBy :  GuramritSingh Randhawa   <Grandhaw@wintrust.com>
    CreatedDate : 01-26-2021
    Description : Run Batch job over schedule time every day.
        Update Referral Status to "New-Overdue" When below criteria met
        Criteria :  Date Referred is Greater than 14 days from TODAY.
                    Referral Status is "New-Not Contacted"
                    RecordType Name is "Standard" or "Wealth"
    Test Class : WT_UpdateReferralStatusTest
------------------------------------------------------------*/
public class WT_UpdateReferralStatus implements Database.Batchable<sObject>, Database.Stateful {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        Date DateAfterDay14 = System.today().addDays(14);
        return Database.getQueryLocator(
            'SELECT ID, Status, WT_Date_Referred__c,RecordType.Name FROM Lead Where (RecordType.Name=\'Standard\' OR RecordType.Name=\'Wealth\') AND Status = \'New - Not Contacted\' AND WT_Date_Referred__c >:DateAfterDay14'
        );
    }
    public void execute(Database.BatchableContext bc, List<Lead> scope){
        Try{
            // process each batch of records
            list <Lead> updatedLeads=new List<Lead>();
            for(Lead ld: scope){
                ld.Status = 'New - Overdue';
                updatedLeads.add(Ld);
            }
            update updatedLeads;
        }Catch(Exception ex){
            System.debug('UpdateReferralStatus Error : '+ex.getMessage());
        }
    }
    public void finish(Database.BatchableContext bc){
        System.debug('UpdateReferralStatus Batch Complete Successfully');
    }
}