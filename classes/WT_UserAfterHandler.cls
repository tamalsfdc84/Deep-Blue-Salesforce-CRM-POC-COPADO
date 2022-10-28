/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_UserAfterHandler
* @Author			Swaminathan E	<SEzhumal@wintrust.com>
* @ModifiedBy		Swaminathan E	<SEzhumal@wintrust.com>
* @Version			v1.0
* @CreatedDate		12-28-2020
* @UsedBy			User Object
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is handler class for User Object trigger.
* This handles all the before logic of the User Object trigger.
* --------------------------------------------------------------------------------------------------------------
* @Changes
* v2.0
* 02-24-2021
* --------------------------------------------------------------------------------------------------------------
**/
// Code Coverage: WT_UserAfterHandler_T
public class WT_UserAfterHandler extends TriggerHandler
{
    List<User> listNewUser = new List<User>();
    Map<Id, User> mapOldUserIdAndUser = new Map<Id, User>();    
    public WT_UserAfterHandler()
    {
        listNewUser = (List<User>) Trigger.new;
        mapOldUserIdAndUser = (Map<Id, User>) Trigger.oldMap;           
    }
    public override void afterInsert()
    {
        userBranchFactorAdded(listNewUser);
        SendWelcomeEmail(listNewUser);
    }    
    public override void afterUpdate()
    {
        userBranchFactorUpdated(listNewUser,mapOldUserIdAndUser);
    }
    
/**
*-----------------------------------------------------------------------------------------------------------------------------
* @description
*This sends the welcome email on any new user creation as long as the user is active.
*-----------------------------------------------------------------------------------------------------------------------------
* @param    listNewUser   This contains list of User Records from beforeInsert Trigger
*-----------------------------------------------------------------------------------------------------------------------------
**/   
    public static void SendWelcomeEmail(List<User> listNewUser)
    {
        List<EmailTemplate> listEmailTemplate = [SELECT Id, Name
                                                 FROM EmailTemplate
                                                 WHERE Name = 'Welcome Email (Internal)'];
        List<Messaging.SingleEmailMessage> listEmailToSend = new List<Messaging.SingleEmailMessage>();
        for(User userRecord : listNewUser)
        {
            if(String.isNotBlank(userRecord.Email) && userRecord.IsActive == true && listEmailTemplate != null && listEmailTemplate.size() > 0)
            {
                List<String> listToEmail = new List<String>();
                listToEmail.add(userRecord.Email);
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(listToEmail);
                mail.setTemplateId(listEmailTemplate[0].Id);
                mail.setBccSender(false);
                mail.setUseSignature(false);
                mail.setReplyTo('noreply@salesforce.com');
                mail.setSenderDisplayName('Wintrust Bank');
                mail.setSaveAsActivity(false); 
                mail.setTargetObjectId(userRecord.Id);
                
                listEmailToSend.add(mail);
            }
        }
        
        if(!listEmailToSend.isEmpty())
        {
            Messaging.sendEmail(listEmailToSend);
        }
    }
    /**
*-----------------------------------------------------------------------------------------------------------------------------
* @description
*This method pass User Id based on Branch# field on User to UpdateBranchFactor.
*-----------------------------------------------------------------------------------------------------------------------------
* @param    listNewUser   This contains list of User Records from beforeInsert Trigger
*-----------------------------------------------------------------------------------------------------------------------------
**/
    public static void userBranchFactorAdded(List<User> listNewUser)
    {        
        Map<Id,String> mapUserRecord = new Map<Id,String>();
        Set<Id> setUserIdDelete = new Set<Id>();
        for(User userRecord : listNewUser)
        {
            if(userRecord.WT_Branch__c != null)
            {
                mapUserRecord.put(userRecord.Id,userRecord.WT_Branch__c);
            }
        }
        updateBranchFactor(mapUserRecord ,setUserIdDelete);      
    }
    /**
*-----------------------------------------------------------------------------------------------------------------------------
* @description
*This method pass User Id based on Branch# field on User to UpdateBranchFactor.
*-----------------------------------------------------------------------------------------------------------------------------
* @param    listNewUser   This contains list of User Records from beforeInsert Trigger
mapOldUserIdAndUser  This contains map of old User Record from beforeInsert Trigger
*-----------------------------------------------------------------------------------------------------------------------------
**/ 
    public static void userBranchFactorUpdated(List<User> listNewUser,Map<Id, User> mapOldUserIdAndUser)
    {        
        Map<Id,String> mapUserRecord = new Map<Id,String>();
        Set<Id> setUserIdDelete = new Set<Id>();
        for(User userRecord : listNewUser)
        {
            if(userRecord.WT_Branch__c != null && mapOldUserIdAndUser.get(userRecord.Id).WT_Branch__c != userRecord.WT_Branch__c)
            {
                mapUserRecord.put(userRecord.Id,userRecord.WT_Branch__c);                     
            }
            else if(userRecord.WT_Branch__c == null)
            {
                setUserIdDelete.add(userRecord.Id); 
            }
        }
        updateBranchFactor(mapUserRecord ,setUserIdDelete);        
    }
    /**
*-----------------------------------------------------------------------------------------------------------------------------
* @description
*This method update User Branch Factor Lookup Object based on Branch# field on User.
*-----------------------------------------------------------------------------------------------------------------------------
* @param    mapUserRecord   This contains map of User Id and Branch# from beforeInsert Trigger
setRemoveBranchFactor  This contains Set of User Id from beforeInsert Trigger
*-----------------------------------------------------------------------------------------------------------------------------
**/ 
    @future
    public static void updateBranchFactor(Map<Id,String> mapUserRecord , Set<Id> setRemoveBranchFactor)
    {
        List<WT_User_Branch_Factor_Lookup__c> listuserBranchFactorRecord = new List<WT_User_Branch_Factor_Lookup__c>();
        Map<String,Id> mapBusinessUnitName = new Map<String,Id>();
        List<WT_User_Branch_Factor_Lookup__c> listUserBranchFactorInsert = new List<WT_User_Branch_Factor_Lookup__c>(); 
        setRemoveBranchFactor.addAll(mapUserRecord.keySet());
        if(!setRemoveBranchFactor.isEmpty()) 
        {
            List<WT_User_Branch_Factor_Lookup__c> listUserBranchFactorDelete = [SELECT Id, WT_User__c FROM WT_User_Branch_Factor_Lookup__c WHERE WT_User__c = :setRemoveBranchFactor];                        
            listUserBranchFactorDelete.addAll(listuserBranchFactorRecord);
            if(!listUserBranchFactorDelete.isEmpty())
            {
                delete listUserBranchFactorDelete;
            } 
        }           
        if(!mapUserRecord.isEmpty()) 
        {
            List<WT_Business_Unit_Entity__c> listBranchFactorRecord = [SELECT Id, WT_Fusion_Feed_Branch__c FROM WT_Business_Unit_Entity__c WHERE WT_Fusion_Feed_Branch__c =:mapUserRecord.values()];            
            List<User> listNewUser= [SELECT Id, Name, WT_Branch__c FROM User WHERE Id =:mapUserRecord.keySet()];
            if(listBranchFactorRecord.size()>0)
            {
                String getName='';
                for(WT_Business_Unit_Entity__c branchFactor : listBranchFactorRecord)
                {
                    mapBusinessUnitName.put(branchFactor.WT_Fusion_Feed_Branch__c, branchFactor.Id);
                }
                for(User userRecord : listNewUser)
                {
                    if( mapBusinessUnitName.get(userRecord.WT_Branch__c) != null)
                    {
                        getName = userRecord.Name != null ? userRecord.Name+userRecord.WT_Branch__c :userRecord.WT_Branch__c;
                        WT_User_Branch_Factor_Lookup__c userBranchFactorRecord = new WT_User_Branch_Factor_Lookup__c(Name=getName, WT_User__c=userRecord.Id,
                                                                                                                     WT_Branch_Factor__c=mapBusinessUnitName.get(userRecord.WT_Branch__c));
                        listUserBranchFactorInsert.add(userBranchFactorRecord);
                    }
                }
                insert listUserBranchFactorInsert;
            }
        }        
    }
}