/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_AccountSSNBatch_T
* @Author			Vamsi Pulikallu	<VPulikal@wintrust.com>
* @Version			v1.0
* @CreatedDate		08 July 2021
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is test class for before handler class for WT_AccountSSNBatch.
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* FUNCTIONAL TEST LOGIC
* runGetPopulateSSNField()
* 	> used to run the batch class for the WT_AccountSSNBatch , generally for code coverage.
*  ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
@isTest
public class WT_AccountSSNBatch_T 
{
    @isTest
    public static void runGetPopulateSSNField()
    {                
        User userRecord = WT_DataFactory.createUser('System Administrator');
        insert userRecord;
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
        Database.executeBatch(new WT_AccountSSNBatch());
        System.assertEquals(7, [select count() from Account]);        
        Test.stopTest();       
    }
}