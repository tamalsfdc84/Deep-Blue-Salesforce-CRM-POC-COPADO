/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name			WT_ContactCenterMulesoftHelper_T
* @Author		Himanshu Patel
* @version 		v1.0 
* @CreatedDate	05-17-2021
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* Test class for WT_ContactCenterMulesoftHelper
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* FUNCTIONAL TEST LOGIC
*  MakeMulesoftCallOut()
* 	> Attempts to make a callout to Mulesoft api. If that fails, returns mock json
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
@isTest
public class WT_ContactCenterMulesoftHelper_T 
{
	@isTest
    static void MakeMulesoftCallOut()
    {
        Test.startTest();
        String calloutResponse = WT_ContactCenterMulesoftHelper.MakeMulesoftCallout('testFirstName', 'testLastName', '123456789', '(555) 555-5555');
        System.assertEquals(true, String.isNotBlank(calloutResponse));
        Test.stopTest();
    }
    
    @isTest
    static void MakeTransactionAPIMulesoftCallout()
    {
        Test.startTest();
        String calloutResponse = WT_ContactCenterMulesoftHelper.MakeTransactionAPIMulesoftCallout('testFirstName');
        System.assertEquals(true, String.isNotBlank(calloutResponse));
        Test.stopTest();
    }
    
    @isTest
    static void MakeIdaQuestionAPIMulesoftCallout()
    {
        Test.startTest();
        String calloutResponse = WT_ContactCenterMulesoftHelper.MakeIdaAPIQuestionMulesoftCallout(WT_ContactCenterSearchController.GetIdaApiMockRequestString(), false);
        System.assertEquals(true, String.isNotBlank(calloutResponse));
        Test.stopTest();
    }
    
    @isTest
    static void MakeIdaDecisionAPIMulesoftCallout()
    {
        Test.startTest();
        String calloutResponse = WT_ContactCenterMulesoftHelper.MakeIdaAPIQuestionMulesoftCallout(WT_ContactCenterSearchController.GetIdaDecisionApiMockRequestString(), true);
        System.assertEquals(true, String.isNotBlank(calloutResponse));
        Test.stopTest();
    }
}