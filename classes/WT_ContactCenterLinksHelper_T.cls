/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name         WT_ContactCenterLinksHelper_T
* @Author       Venkatareddy Somireddy
* @version      v1.0 
* @CreatedDate  02-24-2021
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* This Class is used as test class for WT_ContactCenterLinksHelper
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Changes
* v1.1				Venkatareddy Somireddy
* 03-10-2021		Code Review Changes done.
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
@isTest
public class WT_ContactCenterLinksHelper_T {
     @isTest static void getUniversalLinks_Test()
    {
        Test.startTest();
        List<WT_Contact_Center_Link__c> listUniversalLinks = WT_ContactCenterLinksHelper.getUniversalLinks();        

        List<WT_Contact_Center_Link__c> listUniversalLinksUpdated = [SELECT WT_Title__c,WT_Category__c,WT_URL__c,WT_Icon__c,WT_SortOrder__c 
                                                                from WT_Contact_Center_Link__c 
                                                                where WT_Category__c='Universal Links' AND WT_Status__c ='Active' order by WT_SortOrder__c];

        System.debug('UniversalLinks List Count-' + listUniversalLinks.size()); 
        System.assertEquals(listUniversalLinks.size(), listUniversalLinksUpdated.size());        
        Test.stopTest();
    }

    @isTest static void getFXDLinks_Test()
    {
        Test.startTest();
        List<WT_Contact_Center_Link__c> listFXDLinks = WT_ContactCenterLinksHelper.getFXDLinks();        

        List<WT_Contact_Center_Link__c> listFXDLinksUpdated = [SELECT WT_Title__c,WT_Category__c,WT_URL__c,WT_Icon__c,WT_SortOrder__c 
                                                            from WT_Contact_Center_Link__c 
                                                            where WT_Category__c='FXD Links' AND WT_Status__c ='Active' order by WT_SortOrder__c];

        System.debug('FXDLinks List Count-' + listFXDLinks.size()); 
        System.assertEquals(listFXDLinks.size(), listFXDLinksUpdated.size());
        Test.stopTest();     
    }

    @isTest static void getVisionContentLinks_Test()
    {
        Test.startTest();
        List<WT_Contact_Center_Link__c> listVisionContentLinks = WT_ContactCenterLinksHelper.getVisionContentLinks();        

        List<WT_Contact_Center_Link__c> listVisionContentLinksUpdated = [SELECT WT_Title__c,WT_Category__c,WT_URL__c,WT_Icon__c,WT_SortOrder__c 
                                                                    from WT_Contact_Center_Link__c 
                                                                    where WT_Category__c='Vision Content Links' AND WT_Status__c ='Active' order by WT_SortOrder__c];

        System.debug('UniversalLinks List Count-' + listVisionContentLinks.size()); 
        System.assertEquals(listVisionContentLinks.size(), listVisionContentLinksUpdated.size());         
        Test.stopTest();
    }
}