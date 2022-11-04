/**
* --------------------------------------------------------------------------------------------------------------
* @Name        WT_AccountTasksAndEventsController_T
* @Author      Pushpa Mopuru  <PMopuru@wintrust.com>
* @ModifiedBy  Pushpa Mopuru  <PMopuru@wintrust.com>
* @Version      v1.0
* @CreatedDate   2-25-2021
* @UsedBy      Task , Event Object
* --------------------------------------------------------------------------------------------------------------
* @Description
* Class is used as test class for WT_AccountTasksAndEventsController.
* --------------------------------------------------------------------------------------------------------------
* @Changes
* vX.X
* MM-DD-YYYY
* --------------------------------------------------------------------------------------------------------------
**/
@isTest
public class WT_AccountTasksAndEventsController_T {
    static testMethod void runAccountTasksAndEventsController()
    {
        WT_DataFactory.createRequiredCustomSetting();
        User userRecord = WT_DataFactory.createUser('System Administrator');       
        insert userRecord;
        List <Account> listAccounts = WT_DataFactory.createAccounts(1,'PersonAccount_Customer',userRecord.Id);        
        Account accountRecord = new Account();
        accountRecord = listAccounts[0];
        insert accountRecord;
        List<Task> listTaskRecords =  WT_DataFactory.createTaskRecords(2,'WT_Standard_Call');
        for(Task t: listTaskRecords)
        {
            t.OwnerId= userRecord.Id;
            t.WhatId=accountRecord.Id;
        }
        insert listTaskRecords;
        List<Event> listEventRecords =  WT_DataFactory.createEventRecords(2,'WT_CRA_Event');
        for(Event evt: listEventRecords)
        {
            evt.OwnerId= userRecord.Id;
            evt.WhatId=accountRecord.Id;
        }
        insert listEventRecords;
        
        Test.startTest();
        String wrapTask=WT_AccountTasksAndEventsController.getAccountTasks(accountRecord.Id);
        String wrapEvent=WT_AccountTasksAndEventsController.getAccountEvents(accountRecord.Id);
        System.AssertNotEquals(True,wrapTask.equals('TestFirst1 Testlast1'));        
        Test.stopTest();
    }
}