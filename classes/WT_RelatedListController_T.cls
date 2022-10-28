/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name           WT_RelatedListController_T
* @Author         Vasavi K    <VKolusu@wintrust.com> 
* @ModifiedBy     Vasavi K    <VKolusu@wintrust.com> 
* @version        v1.0 
* @CreatedDate    08-23-2022
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* Class is used as test class for WT_RelatedListController.apxc
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* FUNCTIONAL TEST LOGIC
* > Get the related list records by passing the params into the WT_RelatedListController
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
@isTest
public with sharing class WT_RelatedListController_T 
{
    @isTest public static void testInit()
    {
        Account newAccount = new Account(Name = 'test');
        insert newAccount;
        Contact newContact = new Contact(LastName = 'test', AccountId = newAccount.Id);
        insert newContact;

        Map<String, Object> mapParamsNameAndRequestObject = new Map<String, Object>(); 
        mapParamsNameAndRequestObject.put(WT_RelatedListController.FIELDS_PARAM, 'Name, Title, Email, Phone');
        mapParamsNameAndRequestObject.put(WT_RelatedListController.RELATED_FIELD_API_NAME_PARAM, 'AccountId');
        mapParamsNameAndRequestObject.put(WT_RelatedListController.RECORD_ID_PARAM, newAccount.Id);
        mapParamsNameAndRequestObject.put(WT_RelatedListController.NUMBER_OF_RECORDS_PARAM, 1);
        mapParamsNameAndRequestObject.put(WT_RelatedListController.SOBJECT_API_NAME_PARAM, 'Contact');
        mapParamsNameAndRequestObject.put(WT_RelatedListController.Custom_Condition, 'Test');

        String jsonData = WT_RelatedListController.initData(JSON.serialize(mapParamsNameAndRequestObject));
        Map<String, Object> mapParamsNameAndResponseObject = (Map<String, Object>)JSON.deserializeUntyped(jsonData);
        List<Object> records = (List<Object>)mapParamsNameAndResponseObject.get(WT_RelatedListController.RECORDS_PARAM);
        System.assert(!records.isEmpty());
    }
}