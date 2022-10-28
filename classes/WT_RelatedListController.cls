/**
* --------------------------------------------------------------------------------------------------------------
* @Name          WT_RelatedListController
* @Author        Vasavi Kolusu   <VKolusu@wintrust.com> 
* @ModifiedBy    Vasavi Kolusu   <VKolusu@wintrust.com> 
* @Version       v1.0
* @CreatedDate   08-22-2022
* @UsedBy        Account, Finacial Account, Financial Account Roles Object
* --------------------------------------------------------------------------------------------------------------
* @Description
* This class dynamically gets the related list records and also return the parent relationship name.    
* --------------------------------------------------------------------------------------------------------------
* @Changes
* v1.0
* 08-22-2022
* --------------------------------------------------------------------------------------------------------------
**/
// Code Coverage:  WT_RelatedListController_T

public with sharing class WT_RelatedListController 
{
    public static final String FIELDS_PARAM = 'fields';
    public static final String NUMBER_OF_RECORDS_PARAM = 'numberOfRecords';
    public static final String RECORD_ID_PARAM = 'recordId';
    public static final String SOBJECT_API_NAME_PARAM = 'sobjectApiName';
    public static final String SOBJECT_LABEL_PARAM = 'sobjectLabel';
    public static final String SOBJECT_LABEL_PLURAL_PARAM = 'sobjectLabelPlural';
    public static final String PARENT_RELATIONSHIP_API_NAME_PARAM = 'parentRelationshipApiName';
    public static final String RELATED_FIELD_API_NAME_PARAM = 'relatedFieldApiName';
    public static final String IS_ADMIN_PROFILE = 'isAdminProfile';
    public static final String RECORDS_PARAM = 'records';
    public static final String CUSTOM_CONDITION = 'whereConditions';

    @AuraEnabled
    public static String initData(String jsonData)
    {
        Map<String, Object> mapParamsNameAndRequestObject = (Map<String, Object>)JSON.deserializeUntyped(jsonData);  
        Map<String, Object> mapParamsNameAndResponseObject = new Map<String, Object>();
        mapParamsNameAndResponseObject.put(RECORDS_PARAM, getRecords(jsonData));

        String sobjectApiName = (String)mapParamsNameAndRequestObject.get(SOBJECT_API_NAME_PARAM);
        String recordId = (String)mapParamsNameAndRequestObject.get(RECORD_ID_PARAM);
        String relatedFieldApiName = (String)mapParamsNameAndRequestObject.get(RELATED_FIELD_API_NAME_PARAM);
        mapParamsNameAndResponseObject.put(PARENT_RELATIONSHIP_API_NAME_PARAM, getParentRelationshipName(recordId, sobjectApiName, relatedFieldApiName));
        mapParamsNameAndResponseObject.put(IS_ADMIN_PROFILE, getUserProfileInfo());

        Schema.SObjectType sobjectType = Schema.getGlobalDescribe().get(sobjectApiName);
        Schema.DescribeSObjectResult sobjectDescribe = sobjectType.getDescribe();
        mapParamsNameAndResponseObject.put(SOBJECT_LABEL_PARAM, sobjectDescribe.getLabel());
        mapParamsNameAndResponseObject.put(SOBJECT_LABEL_PLURAL_PARAM, sobjectDescribe.getLabelPlural());
        return JSON.serialize(mapParamsNameAndResponseObject);
    }

	@AuraEnabled
    public static List<Sobject> getRecords(String jsonData)
    {
		Map<String, Object> mapParamsNameAndObjects = (Map<String, Object>)JSON.deserializeUntyped(jsonData);  
        String fields = (String)mapParamsNameAndObjects.get(FIELDS_PARAM);
		Integer numberOfRecords = (Integer)mapParamsNameAndObjects.get(NUMBER_OF_RECORDS_PARAM);
        String recordId = (String)mapParamsNameAndObjects.get(RECORD_ID_PARAM);
		String relatedFieldApiName = (String)mapParamsNameAndObjects.get(RELATED_FIELD_API_NAME_PARAM);
		String sobjectApiName = (String)mapParamsNameAndObjects.get(SOBJECT_API_NAME_PARAM); 
        String customCondition = (String)mapParamsNameAndObjects.get(CUSTOM_CONDITION);
        String whereCondition = '';
        if(customCondition != 'Test')
        {
            whereCondition = 'FinServ__FinancialAccount__r.FinServ__Status__c = \'Active\' AND FinServ__Active__c = true AND ';
        }
        String query = 'SELECT ' + fields + ' FROM ' + sobjectApiName +
                       ' WHERE '+ whereCondition + relatedFieldApiName + ' = :recordId LIMIT :numberOfRecords';
        return Database.query(query);
	}

    private static String getParentRelationshipName(Id recordId, String childSobjectApiName, String relatedFieldApiName)
    {
        Schema.DescribeSObjectResult result = recordId.getSObjectType().getDescribe();
        String name;
        for (Schema.ChildRelationship childRelationship: result.getChildRelationships())
        { 
            if(childRelationship.getChildSObject().getDescribe().getName() == childSobjectApiName && 
               childRelationship.getField().getDescribe().getName() == relatedFieldApiName)
            {
          	 	name = childRelationship.getRelationshipName();
                break;
            }
        }     
        return name;
    }       
    
   private static Boolean getUserProfileInfo()
    {
        String userProfileName = [SELECT Name FROM Profile 
                                  WHERE Id = :userInfo.getProfileId()].Name;
        if( userProfileName.contains('Administrator') )
        {
            return true;
        }
        return false;
    } 
}