/**
* --------------------------------------------------------------------------------------------------------------
* @Name             WT_PowerBiEmbedManager_T
* @Author           Venkat Somireddy <vsomireddy@wintrust.com>
* @Version          v1.0
* @CreatedDate      09-02-2021
* @UsedBy           Power Bi Reports LWC Components
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is test class for WT_PowerBiEmbedManager
* --------------------------------------------------------------------------------------------------------------
* @Changes
* @LastModifiedBy   Venkat Somireddy
* 03-23-2022 - Added new input Parameters in getEmbeddingDataForReport method for sending Role Name for CRE & MM Score Card Reports
* --------------------------------------------------------------------------------------------------------------
**/
@isTest
public class WT_PowerBiEmbedManager_T {
    /**
*-----------------------------------------------------------------------------------------------------------------------------
* @description
* This method interacts with Azure AD to acquire an app-only access token.
*-----------------------------------------------------------------------------------------------------------------------------
**/ 
    @isTest
    public static void getPowerBiAccessToken()
    {
        test.setMock(HttpCalloutMock.class, new WT_PowerBIHttpMockCalloutTest());
        test.startTest();        
        string accessToken =  WT_PowerBiEmbedManager.getPowerBiAccessToken();
        System.debug('accessToken: ' + accessToken);
        System.assertEquals(true, String.isNotBlank(accessToken));
        test.stopTest();
    }
    /**
*-----------------------------------------------------------------------------------------------------------------------------
* @description
* This method used to retrieve the embedding data and the embed token for a specific report
*-----------------------------------------------------------------------------------------------------------------------------
**/ 
    @isTest
    public static void getEmbeddingDataForReport()
    {
        test.setMock(HttpCalloutMock.class, new WT_PowerBIHttpMockCalloutTest());
        test.startTest();        
        WT_PowerBiEmbedManager.PowerBiReportData reportData = new WT_PowerBiEmbedManager.PowerBiReportData();                
        reportData =  WT_PowerBiEmbedManager.getEmbeddingDataForReport('601a8328-3b9b-4667-9811-308e718feb88','11f27d1e-511d-4bb0-b820-a013645e19df','SSRS','No','false','true');
        System.assertEquals(true, String.isNotBlank(reportData.workspaceId));
        
        reportData =  WT_PowerBiEmbedManager.getEmbeddingDataForReport('601a8328-3b9b-4667-9811-308e718feb88','11f27d1e-511d-4bb0-b820-a013645e19df','SSRS','No','true','false');
        System.assertEquals(true, String.isNotBlank(reportData.workspaceId));
        test.stopTest();      
    }
    
    @isTest
    public static void getEmbeddingDataForNonStandardReport()
    {
        test.setMock(HttpCalloutMock.class, new WT_PowerBIHttpMockCalloutTest());
        test.startTest();        
        WT_PowerBiEmbedManager.PowerBiReportData reportData = new WT_PowerBiEmbedManager.PowerBiReportData();                
        reportData =  WT_PowerBiEmbedManager.getNonDefaultReportDataForEmbedding('601a8328-3b9b-4667-9811-308e718feb88','11f27d1e-511d-4bb0-b820-a013645e19df','SSRS','No','false','true', true, null);
        System.assertEquals(true, String.isNotBlank(reportData.workspaceId));
        test.stopTest();      
    }
    /**
*-----------------------------------------------------------------------------------------------------------------------------
* @description
* This method is used to get Power Bi all Report details from object WT_Power_BI_Report__c.
*-----------------------------------------------------------------------------------------------------------------------------
**/ 
    @isTest
    public static void getPowerBIRereports()
    {
        test.startTest();        
        List<WT_Power_BI_Report__c> reportList=  WT_PowerBiEmbedManager.getPowerBIRereports();
        System.assertEquals(reportList.size(), [select count() from WT_Power_BI_Report__c]);
        test.stopTest();
    }
    /**
*-----------------------------------------------------------------------------------------------------------------------------
* @description
* This method is used to get User details based on User Id.
*-----------------------------------------------------------------------------------------------------------------------------
**/
    @isTest
    public static void getUserDetails()
    {
        test.startTest();
        List<User> userList=  WT_PowerBiEmbedManager.getUserDetails(UserInfo.getUserId());
        System.assertEquals(userList.size(), [select count() from User Where id= :UserInfo.getUserId()]);
        test.stopTest();
    }
    /**
*-----------------------------------------------------------------------------------------------------------------------------
* @description
* This method is used to get Power Bi Report details from object WT_Power_BI_Report__c based on Record Id.
*-----------------------------------------------------------------------------------------------------------------------------
**/
    @isTest
    public static void getPowerBIRecordDetails()
    {
        test.startTest();
        string recordId='a0n2g000000JDDzAAO';     
        WT_PowerBiEmbedManager.getPowerBIRecordDetails(recordId);
        test.stopTest();
    }
}