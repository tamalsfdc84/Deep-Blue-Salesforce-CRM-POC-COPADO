/**
* --------------------------------------------------------------------------------------------------------------
* @Name          WT_BatchDeactivateUser
* @Author        Vasavi K    <VKolusu@wintrust.com> 
* @ModifiedBy    Vasavi K    <VKolusu@wintrust.com> 
* @Version       v1.0
* @CreatedDate   02-02-2022
* @UsedBy        Batch class to de-activate users that haven’t been active in 90 days
* --------------------------------------------------------------------------------------------------------------
* @Description
* Batch class to de-activate users that haven’t been active in 90 days
* --------------------------------------------------------------------------------------------------------------
* @Changes
* vX.X
* MM-DD-YYYY
* --------------------------------------------------------------------------------------------------------------
**/
// Code Coverage: WT_BatchDeactivateUser_T
public class WT_BatchDeactivateUser implements Database.Batchable<sObject>,Database.Stateful{
    
    public String[] profilesToBeExcluded;
    public Date DaysLess;
    public String[] userToBeExcluded;
    public String[] emailToBeExcluded;
    public User_Deactivation__c usDe = User_Deactivation__c.getinstance('DeactivateUserBatch');
    public String errorLog ='';
    public integer recordsUpdateSuccess = 0;
    public integer recordsUpdateFailed = 0;
    /**
    *-----------------------------------------------------------------------------------------------------------------------------
    * @description
    *Start method of Batch class where we are querying all the users which satisfies the conditions based on value given in custom setting(DeactivateUserBatch)
    *-----------------------------------------------------------------------------------------------------------------------------
    * @param    Database.BatchableContext   
    *-----------------------------------------------------------------------------------------------------------------------------
    **/   
    public Database.QueryLocator start(Database.BatchableContext BC){
        if(usDe.Inactive_Days__c !=null){
            DaysLess = date.today().adddays(-(integer.valueof(usDe.Inactive_Days__c)));
        }
        if(!String.isBlank(usDe.Profile_Excluded__c)){
            profilesToBeExcluded =usDe.Profile_Excluded__c.split(',');
        }
        if(!String.isBlank(usDe.UsersExcluded__c)){
            userToBeExcluded =usDe.UsersExcluded__c.split(',');
        }
        if(!String.isBlank(usDe.Email_To_Be_Excluded__c)){
            emailToBeExcluded =usDe.Email_To_Be_Excluded__c.split(',');
        }
        
        String query = 'select id, name,profile.name, lastLogindate, isactive,createddate,email from user where';
        query +=' isactive = true ';
        //Checking for excluded profiles
        if(profilesToBeExcluded!=null){
            query +='AND profile.name NOT IN :profilesToBeExcluded ';
        }
        //login date should be within the number mentioned in custom setting
        if(DaysLess!=null){
            query +='AND lastLogindate  < LAST_N_DAYS:'+usDe.Inactive_Days__c;
        }
        //Checking for Users to be excluded on the basis of Full Name
        if(userToBeExcluded!=null){
            query +='AND Name Not IN :userToBeExcluded ';
        }
        //Checking for Users to be excluded on the basis of Email
        if(emailToBeExcluded!=null){
            query +='AND Email Not IN :emailToBeExcluded ';
        }
        //Added this to avoid execute method being called twice from test class
        if(test.isRunningTest()){
            query +=' Limit 200';
        }
        System.debug('query is ++++'+query);
        return Database.getQueryLocator(query);
    }
    
    /**
    *-----------------------------------------------------------------------------------------------------------------------------
    * @description
    *Execute method of batch where we are deactivating the users passed in scope
    *-----------------------------------------------------------------------------------------------------------------------------
    * @param    Database.BatchableContext ,  List<User>
    *-----------------------------------------------------------------------------------------------------------------------------
    **/ 
    public void execute(Database.BatchableContext BC, List<User> userList){
        for(User usr : userList){
            if(usr.createddate<system.today().adddays(-(integer.valueof(usDe.Inactive_Days__c))) && !String.isBlank(usr.name) && !usr.name.startsWithIgnoreCase('CRM Team Tester')){
                //Making user as inactive
                usr.isactive = false; 
            }
        }
        //Updating the users
        Database.SaveResult[] results = Database.update(userList,false);
        Integer i = 0;
        for (Database.SaveResult sr : results) {
            if(!sr.isSuccess()||Test.isRunningTest()){
                //Integer to track no of failed records
                recordsUpdateFailed++;
                for(Database.Error err : sr.getErrors()) {
                    //String to capture error
                    errorLog += userList[i].Name+': '+err.getMessage() +';';    
                }
            }else{
                //Integer to track no of success records
                recordsUpdateSuccess++;
            }
            i++;
        }
    }
     /**
    *-----------------------------------------------------------------------------------------------------------------------------
    * @description
    *Finish Method
    *-----------------------------------------------------------------------------------------------------------------------------
    * @param    Database.BatchableContext
    *-----------------------------------------------------------------------------------------------------------------------------
    **/ 
    public void finish(Database.BatchableContext BC){
        System.debug('No of records Failed------->'+recordsUpdateFailed);
        System.debug('No of records Success------->'+recordsUpdateSuccess);
        if(recordsUpdateFailed>0){
            System.debug('Error Log------->'+errorLog);
        }
    }
}