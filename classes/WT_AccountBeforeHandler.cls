/**
* --------------------------------------------------------------------------------------------------------------
* @Name             WT_AccountBeforeHandler
* @Author           Karishma Keswani    <kkeswani@wintrust.com>
* @ModifiedBy       Karan Jugtawat  <KSinghJu@wintrust.com>
* @Version          v3.0
* @CreatedDate      10-12-2020
* @UsedBy           Account Object
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is handler class for account trigger.
* This handles all the before logic of the account trigger.
* --------------------------------------------------------------------------------------------------------------
* @Changes
* Vamsi Krishna    <VPulikal@wintrust.com>
* 23-12-2020       Added method DisplayErrorOnRecordTypeChange which doesn't allow changing of record type of customer account\
* Karan Jugtawat    <Ksinghju@wintrust.com>
* 03-04-2021    Added CheckRecordAccessToChangeOwner Method to restrict user to change the owner if they dont have edit access to the Account record
* --------------------------------------------------------------------------------------------------------------
**/
// Code Coverage: WT_AccountBeforeHandler_T
public class WT_AccountBeforeHandler extends TriggerHandler
{
    List<Account> listNewAccount = new List<Account>();
    Map<Id, Account> mapNewAccountIdandAccount = new Map<Id, Account>();
    Map<Id, Account> mapOldAccountIdandAccount = new Map<Id, Account>();
    public WT_AccountBeforeHandler()
    {              
        PopulateGlobalLists();        
    }    
    public override void beforeInsert()
    {
        GetPopulateSSNField(listNewAccount);
    }    
    public override void beforeUpdate()
    {
        CheckRecordAccessToChangeOwner(mapOldAccountIdandAccount,listNewAccount);
        GetUpdateSSNField(listNewAccount,mapOldAccountIdandAccount);
        DisplayErrorOnRecordTypeChange(listNewAccount,mapOldAccountIdandAccount);
    }  
    private void PopulateGlobalLists()
    {        
        listNewAccount = (List<Account>) Trigger.new;
        mapNewAccountIdandAccount = (Map<Id, Account>) Trigger.newMap;
        mapOldAccountIdandAccount = (Map<Id, Account>) Trigger.oldMap;
    }
/**
* --------------------------------------------------------------------------------------------------------------
* @Description
*This Method will restrict the user to change the owner if user is not having edit access on Account
* --------------------------------------------------------------------------------------------------------------
* @Param  mapOldAccountIdandAccount    List of Old Account Records
* @Param  listNewAccount    List of Insert Account Records
* @Return void           Returns none
* --------------------------------------------------------------------------------------------------------------
**/
    public void CheckRecordAccessToChangeOwner( Map<Id, Account> mapOldAccountIdandAccount, List<Account> listNewAccount)
    {
        Map<id,UserRecordAccess> mapAccountIdtoUserRecordAccess = new Map<id,UserRecordAccess>();
        List<UserRecordAccess> listUserAccess= [SELECT HasEditAccess,RecordId FROM UserRecordAccess WHERE RecordId in:mapNewAccountIdandAccount.keyset() AND UserId =: UserInfo.getUserId()];
        For(UserRecordAccess URA : listUserAccess )
        {
            mapAccountIdtoUserRecordAccess.put(URA.RecordId, URA);
        }
        For(Account acc : listNewAccount)
        {
            if(acc.OwnerId != mapOldAccountIdandAccount.get(acc.Id).OwnerId)
            {
                If(!mapAccountIdtoUserRecordAccess.get(acc.Id).HasEditAccess)
                {
                 acc.addError('You cannot change the Owner because you dont have edit access to this Account');   
                }
            }
        }
    }    
/**
* --------------------------------------------------------------------------------------------------------------
* @Description
* This method populate the SSN/TIN(Encrypted) field value account record.
*
* --------------------------------------------------------------------------------------------------------------
* @Param  listNewAccount    List of Insert Account Records
* @Return void           Returns none
* --------------------------------------------------------------------------------------------------------------
**/
    public void GetPopulateSSNField(List<Account> listNewAccount)
    {
        for(Account accountRecord :listNewAccount)
        {
            if(accountRecord.WT_SSN_TIN__pc == null && accountRecord.FinServ__TaxId__pc != null)
            {
                accountRecord.WT_SSN_TIN__pc = accountRecord.FinServ__TaxId__pc;
            }
            else if(accountRecord.FinServ__TaxId__pc == null && accountRecord.WT_SSN_TIN__pc != null)
            {
                accountRecord.FinServ__TaxId__pc = accountRecord.WT_SSN_TIN__pc;
            }
            else if(accountRecord.WT_SSN_TIN__c == null && accountRecord.WT_SSN_TIN_Encrypt__c != null)
            {
                accountRecord.WT_SSN_TIN__c = accountRecord.WT_SSN_TIN_Encrypt__c;
            }
            else if(accountRecord.WT_SSN_TIN_Encrypt__c == null && accountRecord.WT_SSN_TIN__c != null)
            {
                accountRecord.WT_SSN_TIN_Encrypt__c = accountRecord.WT_SSN_TIN__c;
            }
        }         
    }
    /**
* --------------------------------------------------------------------------------------------------------------
* @Description
* This method Update the SSN/TIN(Encrypted) field value account record.
*
* --------------------------------------------------------------------------------------------------------------
* @Param  listNewAccount    List of Insert Account Records
* @Param  mapOldAccountIdandAccount    List of Old Account Records
* @Return void           Returns none
* --------------------------------------------------------------------------------------------------------------
**/
    public void GetUpdateSSNField(List<Account> listNewAccount, Map<Id, Account> mapOldAccountIdandAccount)
    {
        String lastFourDigit ='';
        String maskedDigits ='';
        for(Account accountRecord :listNewAccount)
        {
            if(mapOldAccountIdandAccount.get(accountRecord.Id).FinServ__TaxId__pc != accountRecord.FinServ__TaxId__pc)
            {  
                if(accountRecord.FinServ__TaxId__pc == null)
                { 
                    accountRecord.WT_SSN_TIN__pc = null;
                }
                else
                {
                    accountRecord.WT_SSN_TIN__pc = accountRecord.FinServ__TaxId__pc ;
                }
            }            
            else if(mapOldAccountIdandAccount.get(accountRecord.Id).WT_SSN_TIN__c != accountRecord.WT_SSN_TIN__c)
            {  
                if(accountRecord.WT_SSN_TIN__c == null)
                { 
                    accountRecord.WT_SSN_TIN_Encrypt__c = null;
                }
                else
                {
                    accountRecord.WT_SSN_TIN_Encrypt__c = accountRecord.WT_SSN_TIN__c ;
                }
            }            
            else if(mapOldAccountIdandAccount.get(accountRecord.Id).WT_SSN_TIN__pc != accountRecord.WT_SSN_TIN__pc)
            {
                if(accountRecord.WT_SSN_TIN__pc == null)
                { 
                    accountRecord.FinServ__TaxId__pc = null;
                }
                else 
                {
                    lastFourDigit = accountRecord.WT_SSN_TIN__pc.right(4);           
                    maskedDigits = accountRecord.FinServ__TaxId__pc;
                    if(maskedDigits != null)
                    {
                        if(accountRecord.WT_SSN_TIN__pc.contains('X'))
                        {
                            maskedDigits = maskedDigits.left(maskedDigits.length()-4);
                            accountRecord.FinServ__TaxId__pc = maskedDigits + lastFourDigit;
                        }
                        else
                        {
                            accountRecord.FinServ__TaxId__pc = accountRecord.WT_SSN_TIN__pc;
                        }
                    }
                    else 
                    {
                        accountRecord.FinServ__TaxId__pc = accountRecord.WT_SSN_TIN__pc;
                    }
                }
            }            
            else if(mapOldAccountIdandAccount.get(accountRecord.Id).WT_SSN_TIN_Encrypt__c != accountRecord.WT_SSN_TIN_Encrypt__c)
            {
                if(accountRecord.WT_SSN_TIN_Encrypt__c == null)
                { 
                    accountRecord.WT_SSN_TIN__c = null;
                }
                else 
                {
                    lastFourDigit = accountRecord.WT_SSN_TIN_Encrypt__c.right(4);           
                    maskedDigits = accountRecord.WT_SSN_TIN__c;
                    if(maskedDigits != null)
                    {
                        if(accountRecord.WT_SSN_TIN_Encrypt__c.contains('X'))
                        {
                            maskedDigits = maskedDigits.left(maskedDigits.length()-4);
                            accountRecord.WT_SSN_TIN__c = maskedDigits + lastFourDigit;
                        }
                        else
                        {
                            accountRecord.WT_SSN_TIN__c = accountRecord.WT_SSN_TIN_Encrypt__c;
                        }
                    }
                    else 
                    {
                        accountRecord.WT_SSN_TIN__c = accountRecord.WT_SSN_TIN_Encrypt__c;
                    }
                }
            }           
        }
    }
    /**
* --------------------------------------------------------------------------------------------------------------
* @Description
* This method is used to display error if the record type is changed from Customer to Prospect
* --------------------------------------------------------------------------------------------------------------
* @Param  listNewAccount    List of Insert Account Records
* @Param  mapOldAccountIdandAccount    List of Old Account Records
* @Return void           Returns none
* --------------------------------------------------------------------------------------------------------------
**/
    public void DisplayErrorOnRecordTypeChange(List<Account> listNewAccount, Map<Id, Account> mapOldAccountIdandAccount)
    {
        Id customerAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Customer').getRecordTypeId();
        Id prospectAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Prospect').getRecordTypeId();        
        try{
            for(Account newAccount :listNewAccount)
            {
                Account oldAccount = mapOldAccountIdandAccount.get(newAccount.Id);
                if(oldAccount.RecordTypeId == customerAccountRecordTypeId && newAccount.RecordTypeId == prospectAccountRecordTypeId)
                {
                    newAccount.addError(System.label.WT_Account_Error_on_RecordType_Change);
                }
            }
        } 
        catch (Exception e)
        {
            System.debug('The following exception has occurred: AccountBeforeHandler>DisplayErrorOnRecordTypeChange> ' + e.getMessage());
        } 
    }
}