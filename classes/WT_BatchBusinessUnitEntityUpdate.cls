/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name			WT_BatchBusinessUnitEntityUpdate
* @Author			Sivaranjani 	<sivaranjani.d2@tcs.com.tcsdev>	
* @ModifiedBy		Sivaranjani 	<sivaranjani.d2@tcs.com.tcsdev>
* @version 		v1.0 
* @CreatedDate		11-18-2020
* @UsedBy			WT_Business_Unit_Entity__c,WT_Business_Unit_Entity_Staging__c
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* Class is used to load data from WT_Business_Unit_Entity_Staging__c object to WT_Business_Unit_Entity__c based on the unique key 
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Changes
* vx.x				<user id>
* MM-DD-YYYY		<Explanation> 
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
// Test class: WT_BatchBusinessUnitEntityUpdate_T

global class WT_BatchBusinessUnitEntityUpdate implements Database.Batchable<sObject>
{
    //Query all the unprocesssed staging record
    public Database.QueryLocator start(Database.BatchableContext BC)
    {
        String queryString = 'Select Id, WT_Bank_Number__c, WT_Branch_Number__c, WT_New_Customers__c, WT_Total_Foot_Traffic__c, WT_Is_Processed__c From WT_Business_Unit_Entity_Staging__c where WT_Is_Processed__c = false';
        return Database.getQueryLocator(queryString);	
    }
    //iterates over BU staging and updates BU entity records and as well as BU Staging isprocessed field to true.
    public void execute(Database.BatchableContext bc, List<WT_Business_Unit_Entity_Staging__c> listBusinessUnitEntityStaging)
    {
        set<String> setUniqueID = new set<String>();
        List<WT_Business_Unit_Entity__c> listBusinessUnitRecord = new List<WT_Business_Unit_Entity__c>();
        List<WT_Business_Unit_Entity__c> listUpdatedBusinessUnitRecord = new List<WT_Business_Unit_Entity__c>();
        List<WT_Business_Unit_Entity_Staging__c>listUpdatedBusinessUnitStagingRecord = new List<WT_Business_Unit_Entity_Staging__c>();
        Map<String, WT_Business_Unit_Entity_Staging__c> mapUniqueIdAndBusinessUnitStagingRecord = new Map<String,WT_Business_Unit_Entity_Staging__c>();
        List<WT_Business_Unit_Entity__c> listSuccessfullyUpdatedBusinessUnitRecord = new List<WT_Business_Unit_Entity__c>();
        try
        {
            if(listBusinessUnitEntityStaging != null && listBusinessUnitEntityStaging.size() != 0)
            {
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
                    listBusinessUnitRecord =[SELECT Id, WT_Unique_Key__c, WT_Bank_Number__c, WT_Branch_Number__c, WT_New_Customers__c, WT_Total_Foot_Traffic__c, WT_WM_Charter_Factor__c FROM WT_Business_Unit_Entity__c where WT_Unique_Key__c IN: setUniqueID];
                    WT_Business_Unit_Entity_Staging__c businessUnitStaging = new WT_Business_Unit_Entity_Staging__c();
                    if(listBusinessUnitRecord != null && listBusinessUnitRecord.size() != 0)
                    {
                        for(WT_Business_Unit_Entity__c businessUnitRecord:listBusinessUnitRecord)
                        {
                            businessUnitStaging = mapUniqueIdAndBusinessUnitStagingRecord.get(businessUnitRecord.WT_Unique_Key__c);
                            businessUnitRecord.WT_New_Customers__c = businessUnitStaging.WT_New_Customers__c;
                            businessUnitRecord.WT_Total_Foot_Traffic__c = businessUnitStaging.WT_Total_Foot_Traffic__c;
                            listUpdatedBusinessUnitRecord.add(businessUnitRecord);
                        } 
                    }
                }
                Database.SaveResult[] listResultBusinessUnitUpdate= database.Update(listUpdatedBusinessUnitRecord,false);
                set<Id> setUpdateSuccessRecordId = new set<Id>();
                for(Database.SaveResult businessUnitUpdateResult: listResultBusinessUnitUpdate)
                {
                    if (businessUnitUpdateResult.isSuccess()) 
                    {
                        setUpdateSuccessRecordId.add(businessUnitUpdateResult.getId());
                    }
                }
                listSuccessfullyUpdatedBusinessUnitRecord =[SELECT Id, WT_Unique_Key__c, WT_Bank_Number__c, WT_Branch_Number__c, WT_New_Customers__c, WT_Total_Foot_Traffic__c, WT_WM_Charter_Factor__c FROM WT_Business_Unit_Entity__c where id IN: setUpdateSuccessRecordId];
                WT_Business_Unit_Entity_Staging__c businessUnitStagingRecord = new WT_Business_Unit_Entity_Staging__c();
                if(listSuccessfullyUpdatedBusinessUnitRecord != null && listSuccessfullyUpdatedBusinessUnitRecord.size() != 0 )
                {
                    for(WT_Business_Unit_Entity__c successfullyUpdatedBusinessUnitRecord:listSuccessfullyUpdatedBusinessUnitRecord)  
                    {
                        businessUnitStagingRecord = mapUniqueIdAndBusinessUnitStagingRecord.get(successfullyUpdatedBusinessUnitRecord.WT_Unique_Key__c);
                        businessUnitStagingRecord.WT_Is_Processed__c = true;
                        listUpdatedBusinessUnitStagingRecord.add(businessUnitStagingRecord);
                    }  
                    update listUpdatedBusinessUnitStagingRecord;
                }
            }           
        }
        catch(Exception e)
        {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
        
    }
    public void finish(Database.BatchableContext bc)
    {
        // execute any post-processing operations
    }
}