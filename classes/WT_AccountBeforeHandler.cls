/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_AccountBeforeHandler
* @Author			Karishma Keswani	<kkeswani@wintrust.com>
* @ModifiedBy		Karishma Keswani	<kkeswani@wintrust.com>
* @Version			v1.0
* @CreatedDate		10-12-2020
* @UsedBy			Account Object
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is handler class for account trigger.
* This handles all the before logic of the account trigger.
* --------------------------------------------------------------------------------------------------------------
* @Changes
* Vamsi Krishna    <VPulikal@wintrust.com>
* 23-12-2020       Added method DisplayErrorOnRecordTypeChange which doesn't allow changing of record type of customer account\
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