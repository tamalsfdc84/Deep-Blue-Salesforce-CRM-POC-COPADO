/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name			WT_ContactCenterSearchController_T
* @Author		Himanshu Patel
* @version 		v1.0 
* @CreatedDate	05-17-2021
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* Test class for WT_ContactCenterSearchController
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* FUNCTIONAL TEST LOGIC
*  Setup()
* 	> Creates a Person Account and a related Financial Account to use as test data

*  TestFormattedPhoneNumber()
* 	> Tests the FormatPhoneNumber method in WT_ContactCenterSearchController. This method should return a formatted phone number. 

*  TestGetAccount()
* 	> Tests the GetAccounts method in WT_ContactCenterSearchController. This method should return a list of custom search model. 

*  TestGetMulesoftData()
* 	> Tests the GetMulesoftData method in WT_ContactCenterSearchController. This method should return a custom Mulesoft model. 

*  TestGetAdditionalDetails()
* 	> Tests the GetAdditionalDetails method in WT_ContactCenterSearchController. This method should return a custom model with two lists. 
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
@isTest
public class WT_ContactCenterSearchController_T 
{
    @testSetup
    static void Setup()
    {
        Account newTestAccount = WT_TestSetupHelper.GetAccount('Person Account (Customer)');
        insert newTestAccount;
        
        FinServ__FinancialAccount__c financialAccount = WT_TestSetupHelper.GetFinancialAccount('Mortgage', newTestAccount.Id, null);
        insert financialAccount;
    }
    
    @isTest
    static void TestFormattedPhoneNumber()
    {
        Test.startTest();
        String formattedPhoneNumber = WT_ContactCenterSearchController.FormatPhoneNumber('1111111111');
        System.assertEquals(formattedPhoneNumber, '(111) 111-1111');
        
        String unFormattedPhoneNumber = WT_ContactCenterSearchController.FormatPhoneNumber('21111111111');
        System.assertEquals(unFormattedPhoneNumber, '21111111111');
        Test.stopTest();
    }
    
	@isTest
    static void TestGetAccount()
    {
        Test.startTest();
        List<WT_ContactCenterSearchController.AccountSearchResultModel> listSearchResult = WT_ContactCenterSearchController.GetAccounts('111-11111111', 'TesterFirstName', 'TesterLastName',
                                                                                                                                        '123121234', '123456');
        System.assertEquals(listSearchResult.size(), 1);
        Test.stopTest();
    }
    
    @isTest
    static void TestGetMulesoftData()
    {
        Test.startTest();
        List<Account> listExistingAccount = [SELECT Id FROM Account];
        WT_ContactCenterSearchController.MulesoftSearchResultModel mulesoftSearchResult = WT_ContactCenterSearchController.GetMulesoftData(listExistingAccount[0].Id, '(555) 555-5555');
        System.assertEquals(String.isNotBlank(mulesoftSearchResult.DriversLicense), true);
        System.assertEquals(mulesoftSearchResult.ListPasswordModel.size(), 2);
        Test.stopTest();
    }
    
    @isTest
    static void TestGetAdditionalDetails()
    {
        Test.startTest();
        List<Account> listExistingAccount = [SELECT Id FROM Account];
        WT_ContactCenterSearchController.AdditionalDetailSearchResultModel additionalSearchResult = WT_ContactCenterSearchController.GetAdditionalDetails(listExistingAccount[0].Id);
        System.assertEquals(additionalSearchResult.ListFinancialAccount.size(), 1);
        Test.stopTest();
    }
    
    @isTest
    static void TestSetApprovalOnCustomer()
    {
        Test.startTest();
        List<Account> listExistingAccount = [SELECT Id FROM Account];
        WT_ContactCenterSearchController.SavePermissionResultModel saveResult = WT_ContactCenterSearchController.SetApprovalOnCustomer(listExistingAccount[0].Id);
        System.assertEquals(saveResult.IsSuccess, true);
        Test.stopTest();
    }
    
    @isTest
    static void TestGetPenleyQuestion()
    {
        Test.startTest();
        List<Account> listExistingAccount = [SELECT Id FROM Account];
        WT_ContactCenterSearchController.GetPenleyQuestion(listExistingAccount[0].Id);
        Test.stopTest();
    }
    
    @isTest
    static void TestGetPenleyDecision()
    {
        Test.startTest();
        String listQuestion = '[{"AnswerId":"","ListAnswer":[{"label":"BILLY HARRISON","value":"04719648"},{"label":"HARVEY MOBLEY","value":"04251653"},{"label":"ARTHUR DAVIS","value":"00528387"}' +
            ',{"label":"BRENDA EBERHART","value":"04221187"},{"label":"None of the above","value":"00548871"}],"QuestionId":"00547076","QuestionText":"Which of the following people do you' + 'know?"},{"AnswerId":"","ListAnswer":[{"label":"2002","value":"04775938"},{"label":"2003","value":"04739079"},' +
            '{"label":"2004","value":"00056614"},{"label":"2005","value":"00560130"},{"label":"None of the above","value":"00019494"}],' +
            '"QuestionId":"00562435","QuestionText":"What year is your Acura 3.2 TL?"},{"AnswerId":"","ListAnswer":[{"label":"North Carolina","value":"00539653"},' +
            '{"label":"Rhode Island","value":"04253988"},{"label":"Illinois","value":"04214017"},{"label":"New Mexico","value":"04201761"},{"label":"None of the above","value":"04241441"}],' +
            '"QuestionId":"00537893","QuestionText":"Where was your social security number issued?"},{"AnswerId":"","ListAnswer":[{"label":"October 2003","value":"00525601"},' +
            '{"label":"June 2005","value":"00550919"},{"label":"June 2009","value":"00048133"},{"label":"July 2010","value":"04216068"},' +
            '{"label":"None of the above","value":"04753700"}],"QuestionId":"04757761","QuestionText":"When did you purchase or lease your Acura 3.2 TL?"}]';
        List<Account> listExistingAccount = [SELECT Id FROM Account];
        WT_ContactCenterSearchController.GetPenleyDecision(listExistingAccount[0].Id, 'test', 'test', listQuestion);
        Test.stopTest();
    }
    
    @isTest
    static void TestSendVerificationCode()
    {
        Test.startTest();
        List<Account> listExistingAccount = [SELECT Id FROM Account];
        WT_ContactCenterSearchController.VerificationCodeGenerationModel smsCodeResult = WT_ContactCenterSearchController.SendVerificationCode(listExistingAccount[0].Id, 'sms', '5555555555');
        WT_ContactCenterSearchController.VerificationCodeGenerationModel emailCodeResult = WT_ContactCenterSearchController.SendVerificationCode(listExistingAccount[0].Id, 'email', 'test@wintrust.com');
        Test.stopTest();
    }
    
    @isTest
    static void TestVerifyCode()
    {
        Test.startTest();
        List<Account> listExistingAccount = [SELECT Id FROM Account];
        WT_ContactCenterSearchController.VerifyCodeResponseModel smsVerifyCodeResult = WT_ContactCenterSearchController.VerifyCode(listExistingAccount[0].Id, 'sms', '5555555555', '1234');
        WT_ContactCenterSearchController.VerifyCodeResponseModel emailVerifyCodeResult = WT_ContactCenterSearchController.VerifyCode(listExistingAccount[0].Id, 'email', 'test@wintrust.com', '1234');
        Test.stopTest();
    }
    
    @isTest
    static void TestGetD3ChangeFlag()
    {
        Test.startTest();
        WT_ContactCenterSearchController.GetD3ChangeFlag();
        Test.stopTest();
    }
}