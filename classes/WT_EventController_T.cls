/**
* --------------------------------------------------------------------------------------------------------------
* @Name             WT_EventController_T
* @Author           Swaminathan E   <SEzhumal@wintrust.com>
* @ModifiedBy       Swaminathan E   <SEzhumal@wintrust.com>
* @Version          v1.0
* @CreatedDate      09-08-2021
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is test class used for WT_EventController.
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* FUNCTIONAL TEST LOGIC
* 1- runExcuteLogic() 
*   > used to create the Event records through Outlook.
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
@isTest
public class WT_EventController_T 
{
 @isTest
    public Static void runExcuteLogic()
    {
        User userRecord = WT_DataFactory.createUser('System Administrator');       
        insert userRecord;
       List<Account> listBusinessAccount = WT_DataFactory.createNonPersonAccounts(2,'BusinessAccount_Prospect',userRecord.Id);
        insert listBusinessAccount; 
        Test.startTest();
        WT_EventController.createEventRecord('Test Subject','Appointment','WT_Event',listBusinessAccount[0].Id,system.now(),system.now());
        WT_EventController.relatedToRecord('Test','Account');
        Test.stopTest();
    }       
}