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
            
            EmailMessage emailMessage = new EmailMessage(); 
            emailMessage.status = '3'; 
            emailMessage.fromName = 'Test Tester';
            emailMessage.subject = 'This is the Subject!';  
            emailMessage.htmlBody = '<html><body><b>Hello</b></body></html>'; 
			emailMessage.RelatedToId=listNewClassifiedAccount[0].Id;
            emailMessage.toAddress = 'emailnotinsalesforce@toexample.com, anotherone@toexample.com'; 
            test.starttest();
            insert emailMessage; // insert 
            test.stopTest();
            
        }
    }
}