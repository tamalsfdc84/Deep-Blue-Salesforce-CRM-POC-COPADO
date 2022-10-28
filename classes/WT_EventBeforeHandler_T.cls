/*
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_EventBeforeHandler_T
* @Author			Sowmya Sunkara	    <SSunkara@wintrust.com>
* @ModifiedBy		Swaminathan E	    <SEzhumal@wintrust.com>
* @Version			v1.0
* @CreatedDate		23-12-2020
* -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@Description
* This is test class for after handler class for WT_EventBeforeHandler.
--------------------------------------------------------------------------------------
* FUNCTIONAL TEST LOGIC
* 1- runRestrictedOptOutOwnerPositive()
* 	> used to test the event creation on OptOutCustomers when Wt_Override_DNC__c is true.
* 2- runRestrictedOptOutOwnerNegative() 
* 	> used to test the Event creation on OptOut Customers when WT_Override_DNC__c is False.
* 3- ValidateOutComeNotesTest()
*   > used to test the Outcome Notes is Required and Delete Activity Extension Record.
* --------------------------------------------------------------------------------- ---*/
@isTest
public class WT_EventBeforeHandler_T
{  
    @isTest
    public static void runRestrictedOptOutOwnerPositive()
    {   
        WT_DataFactory.createRequiredCustomSetting();
        User userRecord = WT_DataFactory.createUser('System Administrator');       
        insert userRecord;
        List <Account> listNewClassifiedAccount = WT_DataFactory.createAccounts(1,'PersonAccount_Customer',userRecord.id);
        listNewClassifiedAccount[0].PersonDoNotCall=True;
        listNewClassifiedAccount[0].WT_SSN_TIN__pc='123456789';          
        insert listNewClassifiedAccount;        
        Event eventRecord =new Event(Subject='Send Letter',StartDateTime=System.now(),EndDateTime= System.now(),whatId=listNewClassifiedAccount[0].Id,Wt_Override_DNC__c=true);
        test.startTest();
        insert eventRecord;
        test.stopTest();
        System.assertNotEquals(eventRecord.Id,null);
    }   
    @isTest
    public static void runRestrictedOptOutOwnerNegative()
    {   
        WT_DataFactory.createRequiredCustomSetting();
        User userRecord = WT_DataFactory.createUser('System Administrator');       
        insert userRecord;
        List <Account> listNewClassifiedAccount = WT_DataFactory.createAccounts(1,'PersonAccount_Customer',userRecord.id);
        listNewClassifiedAccount[0].PersonDoNotCall=True;
        listNewClassifiedAccount[0].WT_SSN_TIN__pc='123456789';       
        insert listNewClassifiedAccount;      
        Event eventRecord =new Event(Subject='Send Letter',StartDateTime=System.now(),EndDateTime= System.now(),whatId=listNewClassifiedAccount[0].Id,Wt_Override_DNC__c=false);        
        test.startTest();
        try
        {                  
            insert eventRecord;             
        }        
        catch(DmlException e)
        {    
            Boolean expectedExceptionThrown =  e.getMessage().contains(System.Label.WT_OptOut_Customer_Error) ? true : false;
            system.assertEquals(expectedExceptionThrown,true);
            System.assertNotEquals(eventRecord.Id!=null,true);
        } 
        test.stopTest();
    }  
    
    @isTest
    public static void ValidateOutComeNotesTest()
    {   
        WT_DataFactory.createRequiredCustomSetting();
        User userRecord = WT_DataFactory.createUser('System Administrator');       
        insert userRecord;
        List <Account> listNewClassifiedAccount = WT_DataFactory.createAccounts(1,'PersonAccount_Customer',userRecord.id);      
        insert listNewClassifiedAccount;      
        Event eventRecord =new Event(Subject='Send Letter',StartDateTime=System.now(),EndDateTime= System.now(),whatId=listNewClassifiedAccount[0].Id,WT_Status__c='Open');        
        eventRecord.RecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByDeveloperName().get('WT_Wintrust_Event').getRecordTypeId();
        insert eventRecord; 
        test.startTest();
		try
        {                 
			eventRecord.WT_Status__c='Completed';
            update eventRecord;            
        }        
        catch(DmlException e)
        {    
            Boolean expectedExceptionThrown =  e.getMessage().contains('Outcome Note field should be mandatory.') ? true : false;
            system.assertEquals(expectedExceptionThrown,true);
        } 
        delete eventRecord;
        test.stopTest();
    }   
}