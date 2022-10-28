/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name				WT_ContactCenterLinksHelper
* @Author			Venkatareddy Somireddy
* @ModifiedBy		Venkatareddy Somireddy
* @version 			v1.0 
* @CreatedDate		02-24-2021
* @UsedBy			LWC Component:  wT_ContactCenterExternalPage.html
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* This is used in Contact Center External Page for binding all favourite links.
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Changes
* v1.1				Venkatareddy Somireddy
* 03-10-2021		Code Review Changes done.
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
// Test class: WT_ContactCenterLinksHelper_Test
public with sharing class WT_ContactCenterLinksHelper 
{    
    /**
* --------------------------------------------------------------------------------------------------------------
* @Description
* This method return all Universal Links
* --------------------------------------------------------------------------------------------------------------
* @Param  WT_Contact_Center_Link__c List  List of WT_Contact_Center_Link__c
* --------------------------------------------------------------------------------------------------------------
**/
    @AuraEnabled(cacheable=true)
    public static List<WT_Contact_Center_Link__c> getUniversalLinks() 
    {
        return  [SELECT WT_Title__c,WT_Category__c,WT_URL__c,WT_Icon__c,WT_SortOrder__c 
                 from WT_Contact_Center_Link__c 
                 where WT_Category__c='Universal Links' AND WT_Status__c ='Active' order by WT_SortOrder__c];
        
    }
    /**
* --------------------------------------------------------------------------------------------------------------
* @Description
* This method return all FXD Links
* --------------------------------------------------------------------------------------------------------------
* @Param  WT_Contact_Center_Link__c List  List of WT_Contact_Center_Link__c
* --------------------------------------------------------------------------------------------------------------
**/
    @AuraEnabled(cacheable=true)
    public static List<WT_Contact_Center_Link__c> getFXDLinks() 
    {
        return [SELECT WT_Title__c,WT_Category__c,WT_URL__c,WT_Icon__c,WT_SortOrder__c 
                from WT_Contact_Center_Link__c 
                where WT_Category__c='FXD Links' AND WT_Status__c ='Active' order by WT_SortOrder__c];
    }
    /**
* --------------------------------------------------------------------------------------------------------------
* @Description
* This method return all Vision Content Links
* --------------------------------------------------------------------------------------------------------------
* @Param  WT_Contact_Center_Link__c List  List of WT_Contact_Center_Link__c
* --------------------------------------------------------------------------------------------------------------
**/
    @AuraEnabled(cacheable=true)
    public static List<WT_Contact_Center_Link__c> getVisionContentLinks() 
    {
        return [SELECT WT_Title__c,WT_Category__c,WT_URL__c,WT_Icon__c,WT_SortOrder__c 
                from WT_Contact_Center_Link__c 
                where WT_Category__c='Vision Content Links' AND WT_Status__c ='Active' order by WT_SortOrder__c];
    }
}