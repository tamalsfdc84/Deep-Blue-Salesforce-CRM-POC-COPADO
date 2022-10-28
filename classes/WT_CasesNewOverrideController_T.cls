/**
 * -------------------------------------------------------------------------------------------------------------------------------------------------
 * @Name			WT_CasesNewOverrideController_T
 * @Author			Sivaranjani 	<sivaranjani.d2@tcs.com.tcsdev>	
 * @version 		v1.0 
 * @CreatedDate		11-26-2020
 * ---------------------------------------------------------------------------------------------------------------------------------------------------
 * @Description 
 * Class is used as test class for WT_CasesNewOverrideController 
 * ---------------------------------------------------------------------------------------------------------------------------------------------------
 * FUNCTIONAL TEST LOGIC
 * 1- runFetchChangedUser() 
 * 	> use to run test and code coverage of fetchChangedUser() function on WT_CasesNewOverrideController
 * 
 * 2- runFetchRecordTypeID() 
 * 	> use to run test and code coverage of FetchRecordTypeID() function on WT_CasesNewOverrideController
 * 
 * 3- runfetchMailingAddress() 
 * 	> use to run test and code coverage of fetchMailingAddress() function on WT_CasesNewOverrideController
 * 
 * 4- runCaseAssignmentRule()
 * 	> use to run test and code coverage of runCaseAssignmentRule() function on WT_CasesNewOverrideController 
 *  
 * 5- runFetchUser() 
 * 	> use to run test and code coverage of fetchUser() function on WT_CasesNewOverrideController
 * 
 * ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
@isTest
public class WT_CasesNewOverrideController_T 
{
    @isTest static void runFetchUser()
    {
        User userRecord = WT_CasesNewOverrideController.fetchUser();
        System.assertEquals(userRecord.id, UserInfo.getUserId());
    }    
    @isTest static void runFetchChangedUser()
    {
        User userRecord = WT_CasesNewOverrideController.fetchChangedUser(UserInfo.getUserId());
        System.assertEquals(userRecord.id, UserInfo.getUserId());
    }    
    @isTest static void runFetchRecordTypeID()
    {
        String recordTypeId = WT_CasesNewOverrideController.fetchRecordTypeID('CCPA');
        //WT_CasesNewOverrideController.getPrePopulateValue();
        WT_CasesNewOverrideController.setReportByDate();
        recordType varRecordType = [select id,Name FROM recordType Where Name =: 'CCPA' and SobjectType = 'Case'];
        system.assertEquals(varRecordType.id,recordTypeId);
    }
    @isTest static void runfetchMailingAddress()
    {                 
        Account accountRec = new Account (FirstName='test', LastName='user',billingstreet='Hebbal Kempapura',billingcity='Bengaluru',billingstate='Karnataka',billingPostalCode='560024',BillingCountry='India');
        accountRec.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Prospect').getRecordTypeId();
        insert accountRec;
        String accountDataRecord = WT_CasesNewOverrideController.fetchMailingAddress(accountRec.id);
        String CaseTitle=WT_CasesNewOverrideController.setCaseTitle(accountRec.id);
        String accountMailingAddress = accountRec.billingstreet+ accountRec.billingcity + accountRec.billingstate + accountRec.billingPostalCode+ accountRec.BillingCountry;
        system.assertEquals(accountDataRecord, accountMailingAddress);       
    }
    @isTest static void runCaseAssignmentRule()
    {               
        Case caseRecord = new Case();
        insert caseRecord;
        WT_CasesNewOverrideController.runCaseAssignmentRule(caseRecord.id, 'Deposit Application');
        WT_CasesNewOverrideController.runCaseAssignmentRule(caseRecord.id, 'CCPA');
        WT_CasesNewOverrideController.calculateResolutionTarget('Balancing','Deposit Application');
        WT_CasesNewOverrideController.calculateResolutionTarget('Balancing','CCPA');
    }    
}