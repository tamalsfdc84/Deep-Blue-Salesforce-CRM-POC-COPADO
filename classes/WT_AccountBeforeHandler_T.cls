/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_AccountBeforeHandler_T
* @Author			Swaminathan E	<SEzhumal@wintrust.com>
* @Version			v1.0
* @CreatedDate		18-12-2020
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is test class for before handler class for WT_AccountBeforeHandler.
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* FUNCTIONAL TEST LOGIC
* runGetPopulateSSNField()
 * 	> used to run the Trigger class for the WT_AccountBeforeHandler , generally for code coverage.
* runMergeAccountDisplayError
 *  > used to restrict changing the recod type from customer to prospect
*  ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
@isTest
public class WT_AccountBeforeHandler_T 
{  
    @isTest 
    public static void runGetPopulateSSNField()
    {                
        User userRecord = WT_DataFactory.createUser('System Administrator');
        insert userRecord;
        WT_DataFactory.createRequiredCustomSetting();
        List <Account> listAccounts = WT_DataFactory.createAccounts(7,'PersonAccount_Prospect',userRecord.Id);        
        listAccounts[0].WT_SSN_TIN__pc = '123456789';                       
        listAccounts[1].FinServ__TaxId__pc = '123456080';
        listAccounts[5].FinServ__TaxId__pc = '123456080';
        listAccounts[6].FinServ__TaxId__pc = '120056080';
        Test.startTest();
        insert listAccounts;        
        listAccounts[0].WT_SSN_TIN__pc = null;
        listAccounts[1].FinServ__TaxId__pc = null;
        listAccounts[2].WT_SSN_TIN__pc = '123456789';
        listAccounts[3].FinServ__TaxId__pc = '123456009';
        listAccounts[4].WT_SSN_TIN__pc = 'xxxxx8955';                       
        listAccounts[5].WT_SSN_TIN__pc = 'xxxxx6910';
        listAccounts[6].WT_SSN_TIN__pc = 'xxxxx6980';
        listAccounts[6].FinServ__TaxId__pc = '120056080';
        update listAccounts;        
        Test.stopTest();       
    }
    @isTest
    public static void runMergeAccountDisplayError() 
    {
        User userRecord = WT_DataFactory.createUser('WT Retail');
        insert userRecord;
        List <Account> listAccounts = WT_DataFactory.createAccounts(1,'PersonAccount_Customer',userRecord.Id);        
        Account accountRecord = new Account();
        accountRecord = listAccounts[0];
        insert accountRecord;
        accountRecord.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Prospect').getRecordTypeId();
        WT_DataFactory.createRequiredCustomSetting();
        try
        {
            test.startTest();
            update accountRecord;
            test.stopTest();
        }
        catch(exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains(System.Label.WT_Account_Error_on_RecordType_Change) ? true : false;
            system.assertEquals(expectedExceptionThrown,true);
        }
    }    
}