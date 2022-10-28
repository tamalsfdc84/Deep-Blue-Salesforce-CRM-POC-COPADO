/**
* --------------------------------------------------------------------------------------------------------------
* @Name             WT_UserBeforeHandler
* @Author           Himmat Patel   <hpatel@wintrust.com>
*  @Version         v1.0
* @CreatedDate      06-04-2022
* @UsedBy           User Object
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is handler class for User Object trigger.
* This handles all the before logic of the User Object trigger.
* --------------------------------------------------------------------------------------------------------------
* Ticket NO: SGE-205
* --------------------------------------------------------------------------------------------------------------
**/
// Code Coverage: WT_UserBeforeHandler_T
public class WT_UserBeforeHandler extends TriggerHandler 
{
    List<User> listNewUser = new List<User>();
    Map<Id, User> mapOldUserIdAndUser = new Map<Id, User>();    
  
    public WT_UserBeforeHandler() 
    {
        listNewUser = (List<User>) Trigger.new;
        mapOldUserIdAndUser = (Map<Id, User>) Trigger.oldMap;    
    }

    public override void beforeInsert()
    {
        UpdateDateOfLastStatusChange();
    }

    public override void beforeUpdate()
    {
        UpdateDateOfLastStatusChange();
    }

    /* --------------------------------------------------------------------------------------------------------------	
    * @Description	
    * This method is used to update the date of 'DateOfLastStatusChange' field if the status of the User is changed from Active/InActive/Create a New User
    * --------------------------------------------------------------------------------------------------------------	
    * @Param  isInsert                     Boolean	
    * @Param  listNewUser                  List of Insert User Records	
    * @Param  mapOldUserIdAndUser          List of Old User Records	
    * @Return void                         Returns none	
    * --------------------------------------------------------------------------------------------------------------	
    **/	
    public void UpdateDateOfLastStatusChange()
    {
        for(User newUser:listNewUser)
        {
            User oldUser = mapOldUserIdAndUser?.get(newUser.Id);
            if(Trigger.isInsert)
            {
              newUser.WT_Date_of_Last_Status_Change__c =  system.now();
            }
            else if(!Trigger.isInsert && newUser.IsActive != oldUser.IsActive)
            {
              newUser.WT_Date_of_Last_Status_Change__c = system.now();
            }
        }   
    }
}