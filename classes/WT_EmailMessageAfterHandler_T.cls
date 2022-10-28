/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_EmailMessageAfterHandler_T
* @Author			Anoop B	<ABattini@wintrust.com>
* @ModifiedBy		Anoop B	<ABattini@wintrust.com>
* @Version			v1.0
* @CreatedDate		25-05-2021
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is test class for after handler class for WT_EmailMessageAfterHandler.
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* FUNCTIONAL TEST LOGIC
* 1- runUpdateBody() 
* 	> used to test setting up Task Owner Id on Email Message.
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
@isTest
public class WT_EmailMessageAfterHandler_T 
{
    @isTest
    public static void runUpdateBody() 
    {
        UserRole roleRecord = [select id,name from UserRole where name = 'Banking'];
        User userRecord = WT_DataFactory.createUser('System Administrator'); 
        userRecord.UserRoleId = roleRecord.Id;
        insert userRecord;
        system.runAs(userRecord)
        {
            WT_DataFactory.createRequiredCustomSetting();
            List <Account> listNewClassifiedAccount = WT_DataFactory.createAccounts(1,'PersonAccount_Customer',userRecord.id);
            listNewClassifiedAccount[0].PersonDoNotCall=True;
            listNewClassifiedAccount[0].WT_SSN_TIN__pc='453627813';
            insert listNewClassifiedAccount;  
            
            Case caseRecord = new Case();
            caseRecord.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('WT_MyHR').getRecordTypeId();
            caseRecord.WT_Exception__c='Complex Issue';
            caseRecord.WT_Date_Received__c=Date.Today();
            caseRecord.WT_Case_Title__c='Test Case';
            caseRecord.WT_Non_Customer_Complainant__c='Test';  
            caseRecord.OwnerId = userRecord.Id;  
            caseRecord.AccountId = listNewClassifiedAccount[0].Id;
            caseRecord.Origin = 'Email';
            caseRecord.SuppliedEmail = 'test@wt.com';
            insert caseRecord;
            
            EmailMessage emailMessage = new EmailMessage(); 
            emailMessage.status = '3'; 
            emailMessage.fromName = 'Test Tester';
            emailMessage.subject = 'This is the Subject!';  
            emailMessage.htmlBody = '<html><body><b>Hello</b></body></html>'; 
			emailMessage.RelatedToId=listNewClassifiedAccount[0].Id;
            emailMessage.toAddress = 'emailnotinsalesforce@toexample.com, anotherone@toexample.com'; 
            test.starttest();
            insert emailMessage; // insert 
            
            EmailMessage emailMessage2 = new EmailMessage(); 
            emailMessage2.status = '3'; 
            emailMessage2.fromName = 'Test Tester';
            emailMessage2.subject = 'This is the Subject!';  
            emailMessage2.htmlBody = '<html><body><b>Hello</b></body></html>'; 
			emailMessage2.RelatedToId = caseRecord.Id;
            emailMessage2.toAddress = 'emailnotinsalesforce@toexample.com, anotherone@toexample.com'; 

            insert emailMessage2; // insert 
            emailMessage2.Subject = caseRecord.Id;
            emailMessage2.TextBody = emailMessage.Id;
            update emailMessage2;
            test.stopTest();
            
        }
    }
}