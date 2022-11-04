/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name             WT_ListViewExportController_T
* @Author           Francis Xavier     <fxavierd@wintrust.com> 
* @version          v1.0 
* @CreatedDate      04-20-2022
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* Class is used as test class for WT_ListViewExportController 
* ---------------------------------------------------------------------------------------------------------------------------------------------------
**/

@isTest
public class WT_ListViewExportController_T 
{
    @isTest
    static void testListView()
    {   
        Test.setMock(HttpCalloutMock.class, new WT_ListViewExportMockClass());
        
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
            .get('Relationship_Group')
            .getRecordTypeId();
        
        Account acc = new Account(Name = 'TestAcc', RecordTypeId = recordTypeId);
        insert acc;
        
        Contact con = new Contact(LastName = 'TestContact', AccountId = acc.Id);
        insert con;
        
        Test.startTest();
        WT_ListViewExportController.fetchRecords('Contact');
        Test.stopTest();   
    }
}