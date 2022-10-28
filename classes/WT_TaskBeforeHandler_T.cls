/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_TaskBeforeHandler_T
* @Author			Karishma Keswani	<kkeswani@wintrust.com>
* @ModifiedBy		Swaminathan E	    <SEzhumal@wintrust.com>
* @Version			v2.0
* @CreatedDate		07-12-2020
* * --------------------------------------------------------------------------------------------------------------------
* @Description
* This is test class for before handler class for WT_TaskBeforeHandler.
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* FUNCTIONAL TEST LOGIC
* 1- DeleteActivityExtesionRecords() 
* 	> used to test the update of Task and delete of Task Record.
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
@isTest
public class WT_TaskBeforeHandler_T 
{
    @isTest
    public Static void DeleteActivityExtesionRecords()
    {        
        WT_DataFactory.createRequiredCustomSetting();
        User userRecord = WT_DataFactory.createUser('System Administrator');       
        insert userRecord;
        List <Account> listNewClassifiedAccount = WT_DataFactory.createAccounts(1,'PersonAccount_Customer',userRecord.id);
        listNewClassifiedAccount[0].PersonDoNotCall=True;
        listNewClassifiedAccount[0].WT_SSN_TIN__pc='453627813';
        insert listNewClassifiedAccount;      
        Task newTask = new Task(subject='Send Letter' , Priority='Normal' , Status='Completed' , WhatId=listNewClassifiedAccount[0].Id ,WT_Override_DNC__c=true);
        Task newTaskRecord = new Task(subject='Send Letter' , Priority='Normal' , Status='Open' , WhatId=listNewClassifiedAccount[0].Id );
        insert newTaskRecord;               
        test.startTest();                    
        newTaskRecord.Status = 'Completed';   
        try
        {
        insert newTask;
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Outcome Notes field should be mandatory.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
        try
        {
            update newTaskRecord; 
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Outcome Notes field should be mandatory.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
        delete newTaskRecord;
        test.stopTest();        
    }
    }