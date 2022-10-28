@isTest
public class WT_UtilityMethods_T 
{
    @isTest 
    static void testSendEmailWithCsvAttachment()
    {
        WT_UtilityMethods.SendEmailWithCsvAttachment(new List<String>{'test@test.com'}, 'test.csv', 'testSubject', 'testBody', 'testHeader', 'testCsvBody');
    }
}