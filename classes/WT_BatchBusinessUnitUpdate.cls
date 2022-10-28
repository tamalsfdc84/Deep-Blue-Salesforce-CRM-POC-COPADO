/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name         WT_BatchBusinessUnitUpdate
* @Author           Sivaranjani     <sivaranjani.d2@tcs.com.tcsdev> 
* @ModifiedBy       Sivaranjani     <sivaranjani.d2@tcs.com.tcsdev>
* @version      v1.0 
* @CreatedDate      11-18-2020
* @UsedBy           WT_Business_Unit_Entity__c,WT_Business_Unit_Entity_Staging__c
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* Class is used to load data from WT_Business_Unit_Entity_Staging__c object to WT_Business_Unit_Entity__c based on the unique key 
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Changes          
* vx.x              Pushpa Mopuru  <PMopuru@wintrust.com>
* MM-DD-YYYY        4-14-2020 
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
// Test class: WT_BatchBusinessUnitUpdate_T
global class WT_BatchBusinessUnitUpdate implements Database.Batchable<sObject>,Database.Stateful
{
    global List<String> listError = new List<String>();
    global WT_Business_Unit_Entity_Staging__c wtfcBusinessUnitEntityStagingRecord;
    global Decimal wtfcNewCustomers = 0;
    global List<AggregateResult> listFootTrafficSumByBank = new List<AggregateResult>();
    global Map<String, Decimal> mapFootTrafficSumByBank  = new Map<String, Decimal>();
    global list<WT_Business_Unit_Entity_Staging__c>  listMissingBankBranchRecords= new list<WT_Business_Unit_Entity_Staging__c>();
    global Integer totalInputRecords=0;
    global Integer totalProcessedRecords=0;
    global Integer totalMissingRecords=0;
    //Query all the unprocesssed staging record
    public Database.QueryLocator start(Database.BatchableContext BC)
    {
        String queryString = 'Select Id, WT_Bank_Number__c, WT_Branch_Number__c,WT_Factor__c, WT_Foot_Traffic_Level__c, WT_New_Customers__c, WT_Total_Foot_Traffic__c, WT_Is_Processed__c, WT_Market__c, WT_Fusion_Location__c,WT_Charter_Factor__c From WT_Business_Unit_Entity_Staging__c where WT_Is_Processed__c = false AND CreatedDate = Today';
        return Database.getQueryLocator(queryString);   
    }
    //iterates over BU staging and updates BU entity records and as well as BU Staging isprocessed field to true.
    public void execute(Database.BatchableContext bc, List<WT_Business_Unit_Entity_Staging__c> listBusinessUnitEntityStaging)
    {
        set<String> setUniqueID = new set<String>();
        set<String> setBusinessUnitUniqueKey = new set<String>();
        List<WT_Business_Unit_Entity__c> listBusinessUnitRecord = new List<WT_Business_Unit_Entity__c>();
        List<WT_Business_Unit_Entity__c> listUpdatedBusinessUnitRecord = new List<WT_Business_Unit_Entity__c>();
        List<WT_Business_Unit_Entity_Staging__c> listUpdatedBusinessUnitStagingRecord = new List<WT_Business_Unit_Entity_Staging__c>();
        Map<String, WT_Business_Unit_Entity_Staging__c> mapUniqueIdAndBusinessUnitStagingRecord = new Map<String,WT_Business_Unit_Entity_Staging__c>();
        try
        {
            if(listBusinessUnitEntityStaging != null && listBusinessUnitEntityStaging.size() != 0)
            {
                totalInputRecords = totalInputRecords + listBusinessUnitEntityStaging.size();
                if(wtfcNewCustomers == 0)
                {
                    wtfcBusinessUnitEntityStagingRecord = [SELECT WT_New_Customers__c FROM WT_Business_Unit_Entity_Staging__c Where WT_Bank_Number__c ='WTFC' AND  WT_Is_Processed__c = false AND CreatedDate = Today limit 1];
                    wtfcNewCustomers = wtfcBusinessUnitEntityStagingRecord.WT_New_Customers__c;
                }
                if(listFootTrafficSumByBank.size() == 0)
                {
                    List<AggregateResult> listFootTrafficSumByBank =[SELECT WT_Bank_Number__c bankNo, SUM(WT_Total_Foot_Traffic__c) totalFootTrafficSum FROM WT_Business_Unit_Entity_Staging__c where WT_Is_Processed__c = false AND CreatedDate = Today Group by WT_Bank_Number__c];                
                    if(listFootTrafficSumByBank != null & listFootTrafficSumByBank.size()!=0)
                    {
                        for(AggregateResult aggResult : listFootTrafficSumByBank)
                        { 
                            mapFootTrafficSumByBank.put((String)aggResult.get('bankNo'), wtfcNewCustomers/(Decimal)aggResult.get('totalFootTrafficSum'));
                        }
                    }
                    else
                    {
                        listError.add('Error in aggregate results');
                    }
                }                
                for(WT_Business_Unit_Entity_Staging__c businessUnitEntityStaging: listBusinessUnitEntityStaging)
                {
                    if(businessUnitEntityStaging.WT_Bank_Number__c != null && businessUnitEntityStaging.WT_Branch_Number__c != null)
                    {
                        setUniqueID.add(businessUnitEntityStaging.WT_Bank_Number__c+'-'+businessUnitEntityStaging.WT_Branch_Number__c);
                        mapUniqueIdAndBusinessUnitStagingRecord.put(businessUnitEntityStaging.WT_Bank_Number__c+'-'+businessUnitEntityStaging.WT_Branch_Number__c, businessUnitEntityStaging);
                    }
                }
                if(setUniqueID != null && setUniqueID.size() != 0)
                {
                    listBusinessUnitRecord =[SELECT Id, WT_Unique_Key__c, WT_Bank_Number__c, WT_Branch_Number__c, WT_New_Customers__c, WT_Total_Foot_Traffic__c, WT_Fusion_Location__c, WT_Market__c, WT_WM_Branch_Factor__c, WT_Foot_Traffic_Level__c, WT_Charter_Factor__c FROM WT_Business_Unit_Entity__c where WT_Unique_Key__c IN: setUniqueID];
                    if(listBusinessUnitRecord != null && listBusinessUnitRecord.size() != 0)
                    {
                        for(WT_Business_Unit_Entity__c businessUnitEntity: listBusinessUnitRecord)
                        {
                            setBusinessUnitUniqueKey.add(businessUnitEntity.WT_Unique_Key__c);
                        }
                    }    
                    WT_Business_Unit_Entity_Staging__c businessUnitStaging = new WT_Business_Unit_Entity_Staging__c();
                    if(listBusinessUnitRecord != null && listBusinessUnitRecord.size() != 0)
                    { 
                        for(WT_Business_Unit_Entity__c businessUnitRecord:listBusinessUnitRecord)
                        {
                            businessUnitStaging = mapUniqueIdAndBusinessUnitStagingRecord.get(businessUnitRecord.WT_Unique_Key__c);
                            businessUnitRecord.WT_New_Customers__c = businessUnitStaging.WT_New_Customers__c;
                            businessUnitRecord.WT_Total_Foot_Traffic__c = businessUnitStaging.WT_Total_Foot_Traffic__c;
                            businessUnitRecord.WT_WM_Branch_Factor__c = businessUnitStaging.WT_Factor__c;
                            businessUnitRecord.WT_Foot_Traffic_Level__c= businessUnitStaging.WT_Foot_Traffic_Level__c;
                            businessUnitRecord.WT_Charter_Factor__c = mapFootTrafficSumByBank.get(businessUnitStaging.WT_Bank_Number__c);
                            listUpdatedBusinessUnitRecord.add(businessUnitRecord);
                        } 
                    }
                }
                if(setUniqueID.size() != listBusinessUnitRecord.size())
                {
                    for (String bankBranch:setUniqueID)
                    {
                        if(!setBusinessUnitUniqueKey.contains(bankBranch))
                        {
                            listMissingBankBranchRecords.add(mapUniqueIdAndBusinessUnitStagingRecord.get(bankBranch));
                            totalMissingRecords++;
                        }
                    }
                }
                Database.SaveResult[] listBusinessUnitUpdateResult= database.Update(listUpdatedBusinessUnitRecord,false);
                Integer index=0;                
                List<String> listUpdateSuccessRecords = new List<String>();
                for(Database.SaveResult businessUnitUpdateResult: listBusinessUnitUpdateResult)
                {
                    if (businessUnitUpdateResult.isSuccess()) 
                    {
                        if(listUpdatedBusinessUnitRecord.get(index)!=null)
                        {
                            WT_Business_Unit_Entity__c updatedBusinessUnitRecord = listUpdatedBusinessUnitRecord.get(index);
                            listUpdateSuccessRecords.add(updatedBusinessUnitRecord.WT_Unique_Key__c);
                            totalProcessedRecords++;
                        }
                    }
                    else
                    {
                        Database.Error error = businessUnitUpdateResult.getErrors().size()>0?businessUnitUpdateResult.getErrors().get(0):null;
                        if(error !=null) 
                        { 
                            // Error Messages List
                            listError.add(error.getMessage());
                        }                        
                    }
                    index++;
                }
                WT_Business_Unit_Entity_Staging__c businessUnitStagingRecord = new WT_Business_Unit_Entity_Staging__c();
                if(listUpdateSuccessRecords != null && listUpdateSuccessRecords.size() != 0 )
                {
                    for(string successfullyUpdatedBusinessUnitRecordKey:listUpdateSuccessRecords)  
                    {
                        businessUnitStagingRecord = mapUniqueIdAndBusinessUnitStagingRecord.get(successfullyUpdatedBusinessUnitRecordKey);
                        businessUnitStagingRecord.WT_Is_Processed__c = true;
                        listUpdatedBusinessUnitStagingRecord.add(businessUnitStagingRecord);
                    }  
                    try
                    {   
                        update listUpdatedBusinessUnitStagingRecord;
                    } 
                    catch (Exception e)
                    {  
                        listError.add(e.getMessage());                  
                    }                   
                }
            }           
        }
        catch(Exception e)
        {
            listError.add(e.getMessage()); 
        }        
    }
    public void finish(Database.BatchableContext bc)
    {
        String toUserEmail = System.Label.Branch_Factor_Update_Email;
        String[] toAddress = new String[] {toUserEmail};
        Id jobId =bc.getJobId();
        AsyncApexJob asyncResults= [SELECT NumberofErrors, JobType, Status,TotalJobItems, JobItemsProcessed FROM AsyncApexJob WHERE id=: jobId];
        Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
        emailMessage.setToAddresses(toAddress);
        String body =           'Total Number of Input Records                  :' + totalInputRecords; 
        body = body+ '<br/><br/> Total Number of successfully Processed Records :' + totalProcessedRecords;
        body = body+ '<br/><br/> Total Number of Mis Matched Records            :' + totalMissingRecords; 
        if (listMissingBankBranchRecords.size() !=0  && listMissingBankBranchRecords.size() !=null )
        {
            body = body + '<br/><br/> <b> Missing BusinessUnit Entity Record Details  :</b> <br/>';
            for(WT_Business_Unit_Entity_Staging__c missingBusinessUnitEntityRecord : listMissingBankBranchRecords)
            {                
                body = body + missingBusinessUnitEntityRecord + '<br/>';            
            }
        }
        if(listError.size()!=0  && listError.size() != null)
        {
            body = body + '<br/><br/> <b> List of Errors  :</b>';
            for(String error : listError)
            {
                body = body+ '<br/>   Error  :' + error;
            }     
        } 
        emailMessage.setSubject('BusinessUnit Entity Update Batch Job :' + jobId + asyncResults.Status);
        emailMessage.setHtmlBody(body);
        emailMessage.setSenderDisplayName('Batch Business Unit Update');
        Messaging.Email[] emails = new Messaging.Email[]{emailMessage};
        Messaging.sendEmail(emails);
    }
}