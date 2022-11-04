@isTest
public class WT_PhoneUtility_T
{
	@isTest
    public static void test()
    {
        Test.startTest();
        WT_PhoneUtility.FormatPhoneForFrontEnd('17066916705');
        WT_PhoneUtility.FormatPhoneTo10Digit('17066916705');
        WT_PhoneUtility.FormatPhoneWithHyphen('17066916705');
        Test.stopTest();
    }
}