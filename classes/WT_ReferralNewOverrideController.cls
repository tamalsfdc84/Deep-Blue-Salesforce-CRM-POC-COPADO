/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_ReferralNewOverrideController
* @Author			Swaminathan E	<SEzhumal@wintrust.com>
* @ModifiedBy		Vasavi K	<vkolusu@wintrust.com>
* @Version			v1.0
* @CreatedDate		30-11-2020
* @UsedBy			Lead Object
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is controller class for Override the New Button on Referral Records.
* This handles based on RecordType, Prepopulate value on Referral Records.
* --------------------------------------------------------------------------------------------------------------
* @Changes
* v2.0
* 05-31-2022
* --------------------------------------------------------------------------------------------------------------
**/
// Code Coverage: WT_ReferralNewOverrideController_T
public without sharing class WT_ReferralNewOverrideController 
{
    /**
*-----------------------------------------------------------------------------------------------------------------------------
* @description
*This method auto populate default value on Referral Records.
*-----------------------------------------------------------------------------------------------------------------------------
**/
    @AuraEnabled(cacheable=true)
    public static Map<String,Id> getPrePopulateValue()
    {     
        List<Schema.RecordTypeInfo> listRecordType = Lead.SObjectType.getDescribe().getRecordTypeInfos();
        Map<String ,Id> mapRecordType = new Map<String ,Id>(); 
        Id currentUserId =  UserInfo.getUserId();
        for(Schema.RecordTypeInfo recordType : listRecordType )
        {
            if(recordType.isAvailable() && recordType.Name != 'Master')
            {
                mapRecordType.put(recordType.Name,recordType.getRecordTypeId());
            }
        }
        mapRecordType.put('CurrentUser',currentUserId);
        Id businessUnitRecordId = populateBusinessReferralUnit(currentUserId);
        if(businessUnitRecordId != null)
        {
            mapRecordType.put('BUId',businessUnitRecordId);
        }
        return mapRecordType;
    }
    /**
*-----------------------------------------------------------------------------------------------------------------------------
* @description
*This method get Branch Factor Id on Referral record based on Referredby selected.
*-----------------------------------------------------------------------------------------------------------------------------
* @param    userId   This contains User Id.
*-----------------------------------------------------------------------------------------------------------------------------
**/    
    @AuraEnabled
    public static Id populateBusinessReferralUnit(Id userId)
    {       
        List<WT_User_Branch_Factor_Lookup__c> businessUnitRecord = [SELECT Id, WT_Branch_Factor__c, WT_User__c FROM WT_User_Branch_Factor_Lookup__c WHERE WT_User__c = : userId Limit 1];
        if(businessUnitRecord.size() > 0)
        {
            return businessUnitRecord[0].WT_Branch_Factor__c;
        }
        else
        {
            return null;
        }
    }
    /**
*-----------------------------------------------------------------------------------------------------------------------------
* @description
*This method get Name on Referral record based on Account Referred selected.
*-----------------------------------------------------------------------------------------------------------------------------
* @param    referredAccountId   This contains Account Referred Id.
*-----------------------------------------------------------------------------------------------------------------------------
**/
    @AuraEnabled
    public static Account populateName(Id referredAccountId)
    {
        Account accountRecord = [SELECT Id, Name, FirstName, MiddleName, LastName ,RecordType.Name FROM Account WHERE Id = :referredAccountId];
        if(!accountRecord.RecordType.Name.contains('Person'))
        {
            accountRecord.LastName = accountRecord.Name;
        }
        return  accountRecord;
    }
    /**
*-----------------------------------------------------------------------------------------------------------------------------
* @description
*This method get User records based on Referral Type selected.
*-----------------------------------------------------------------------------------------------------------------------------
* @param    searchKey   This contains search value.
* @param    objectName   This contains Object-Api-Name.
* @param    filterValue   This contains filter value.
*-----------------------------------------------------------------------------------------------------------------------------
**/
    @AuraEnabled(cacheable=true)  
    public static List<sobject> findRecords(String searchKey, String objectName, String filterValue) 
    {  
        string searchText = '\'' + String.escapeSingleQuotes(searchKey) + '%\'';  
        objectName = String.escapeSingleQuotes(objectName);
        filterValue = String.escapeSingleQuotes(filterValue);
        string query = 'SELECT Id,Phone,Name,WT_Referrals_Type__c  FROM ' +objectName+ ' WHERE Name LIKE '+searchText+' AND WT_Referrals_Type__c includes '+'(\''+filterValue+'\')'+' LIMIT 6';           
        if(String.isNotBlank(objectName) && objectName.toLowerCase() == 'user' && filterValue!=''  && filterValue != null)
        {
            query = 'SELECT Id,Phone,Name,WT_Referrals_Type__c FROM ' +objectName+ ' WHERE IsActive = true AND Name LIKE '+searchText+'AND WT_Referrals_Type__c!=null AND WT_Referrals_Type__c includes '+'(\''+filterValue+'\')'+' LIMIT 6';
        } 
        else
        { 
            query = 'SELECT Id,Phone,Name,WT_Referrals_Type__c FROM ' +objectName+ ' WHERE IsActive = true AND WT_Referrals_Type__c!=null AND Name LIKE '+searchText+' LIMIT 6';
        } 
        return Database.query(query);  
    }  
}