@isTest
public class WT_TwilioHelper_T 
{
    @isTest
    public static void test()
    {
        Test.startTest();
        WT_TwilioHelper.SendVerificationCode('7066916705', 'sms');
        WT_TwilioHelper.VerifyCode('7066916705', '123456');
        Test.stopTest();
    }
}