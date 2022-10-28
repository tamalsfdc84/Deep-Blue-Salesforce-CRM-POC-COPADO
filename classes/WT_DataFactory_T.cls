/**
 * -------------------------------------------------------------------------------------------------------------------------------------------------
 * @Name			WT_DataFactory_T
 * @Author			Sivaranjani 	<sivaranjani.d2@tcs.com.tcsdev>	
 * @ModifiedBy		Sivaranjani 	<sivaranjani.d2@tcs.com.tcsdev>
 * @version 		v1.0 
 * @CreatedDate		11-18-2020
 * @UsedBy			All objects , test class for WT_TestDatafactory
 * ---------------------------------------------------------------------------------------------------------------------------------------------------
 * @Description 
 * Class is used to test the WT_TestDataFactory class. Used to cover code on WT_TestDataFactory
 * ---------------------------------------------------------------------------------------------------------------------------------------------------
 * FUNCTIONAL TEST LOGIC
 * 1- runCreateBusinessUnitEntity() 
 * 	> used to test the creation of WT_Business_Unit_Entity_Staging__c,WT_Business_Unit_Entity__c using WT_DataFactory
 * ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
@isTest
private class WT_DataFactory_T 
{
 	static WT_Business_Unit_Entity_Staging__c businessUnitEntityStagingRecord;
    static WT_Business_Unit_Entity_Staging__c businessUnitEntityStagingRecordWTFC;
    static WT_Business_Unit_Entity__c businessUnitEntityRecord;
    static WT_Business_Unit_Entity__c businessUnitEntityRecordWTFC;
    @isTest static void runCreateBusinessUnitEntity()
    {
        businessUnitEntityStagingRecord = WT_DataFactory.createBusinessUnitEntityStagging();
        insert businessUnitEntityStagingRecord;
        businessUnitEntityStagingRecordWTFC = WT_DataFactory.createBusinessUnitEntityStaggingWTFC();
        insert businessUnitEntityStagingRecordWTFC;
        businessUnitEntityRecord = WT_DataFactory.createBusinessUnitEntity();
        insert businessUnitEntityRecord;
        businessUnitEntityRecordWTFC = WT_DataFactory.createBusinessUnitEntityWTFC();
        insert businessUnitEntityRecordWTFC;
        User userRecord = WT_DataFactory.createUser('System Administrator');
        List<Account> listPersonAccounts = WT_DataFactory.createAccounts(10,'PersonAccount_Prospect',UserInfo.getUserId());
        List<Account> listAccounts = WT_DataFactory.createAccounts(10,'IndustriesBusiness',UserInfo.getUserId());
        List <Account> listNewClassifiedAccount = WT_DataFactory.createNonPersonAccounts(1,'PersonAccount_Customer',userRecord.id);
        List<WT_Activity_Extension__c> listActivityExtension = WT_DataFactory.createActivityExtRecords(1);
        Case caseRecord = WT_DataFactory.caseRecordCreation();
        WT_DataFactory.createRequiredCustomSetting();
    }  
}