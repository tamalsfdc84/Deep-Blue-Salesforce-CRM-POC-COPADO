/**
* --------------------------------------------------------------------------------------------------------------
* @Name             WT_IndividualGoalBatch
* @Author           Krupa Chinthakindi
* @Version          v1.0
* @CreatedDate      01-03-2022
* @UsedBy      
* -----------------------------------------------------------------------------------------------------------------------------
* @Description      This batch is used to process all the Goal Records and 
                    send an email to the CRMSupport team if there are any failed records.
------------------------------------------------------------------------------------------------------------------------------------------
**/

global class WT_IndividualGoalBatch implements Database.Batchable<sObject>, Database.stateful {
    
    List<String> errors = new List<String>();
   
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
        String query = 'SELECT Id,WT_Goal_Metric__c,WT_Date_From__c,WT_Goal_Owner__c,WT_Run_Rate_To_Goal__c,WT_Date_To__c,WT_Target__c,WT_Date_Last_In_Progress_Rolled_Up__c,LastModifiedDate,WT_Percentage_Achieved__c,WT_Actual__c,WT_In_Progress__c FROM WT_Goal__c Order By WT_Parent_Goal__c DESC NULLS LAST';
        return Database.getQueryLocator(query);
    }
        // This method collects the failed records from WT_GoalPopulationLogic.
    global void execute(Database.BatchableContext BC, List<WT_Goal__c> scope) {
       
        List<Id> goalIdLst = new List<Id>();
        for(WT_Goal__c gl : scope){
            goalIdLst.add(gl.Id);
        }
        if(goalIdLst.size()>0 || !goalIdLst.isEmpty()){
            system.debug('goalIdLst'+goalIdLst);
            List<String> errLst = WT_GoalPopulationLogic.updateGoal(goalIdLst);
            if(errLst != null && errLst.size() > 0) errors.addAll(errLst);
            system.debug('errors**'+errors);
        }
    }   
        // This method is to send error list to the support team.
    global void finish(Database.BatchableContext BC) {
        
        system.debug('errorsFinish**'+errors);
        String htmlBody = '';
        htmlBody = '<br></br><table border="1" style="border-collapse: collapse"><tr><th>RecordIDs</th></tr>';
        for(String ers: errors){
            String recordIDs = ers;
            htmlBody += '<tr><td>' + recordIDs + '</td></tr>';
        }
        
        if(!errors.isEmpty()){
            String toaddressList = System.Label.WT_Goal_UserEmailIDs;
            String[] toaddressSplit = toaddressList.split(',');
            String[] toAddress = toaddressSplit;
            system.debug('toAddress'+toAddress);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(toAddress);
            mail.setSubject('GoalRecords ' + 'Failed');
            Integer numberOfErros = errors.size();
            String  messageBody =  'There are '+ numberOfErros +' Failed Records.';
            messageBody += htmlBody;
            mail.setHtmlBody(messageBody);
            Messaging.Email[] emails = new Messaging.Email[]{mail};
            Messaging.sendEmail(emails);
            
        }

    }

}