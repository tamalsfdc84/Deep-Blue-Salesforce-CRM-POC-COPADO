/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name             WT_CaseBeforeHandler
* @Author           Himanshu Patel     <hpatel1@wintrust.com> 
* @ModifiedBy       Himanshu Patel     <hpatel1@wintrust.com>
* @version          v1.0 
* @CreatedDate      06-17-2021
* @UsedBy           trigger:  WT_BankOfficerLookupTrigger
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* This is the before handler class which gets called from WT_BankOfficerLookupTrigger
* Primary function for this class is to validate that user is not inputing a duplicate code & also to write the formula fields in a text field
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Changes
* v1.0              Himanshu Patel (hpatel1@wintrust.com)
* MM-DD-YYYY        06-17-2021 
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
// Test class: WT_BankOfficerLookupBeforeHandler_T
public class WT_BankOfficerLookupBeforeHandler extends TriggerHandler
{
    List<WT_Bank_Officer_Lookup__c> listNewBankOfficerLookup = new List<WT_Bank_Officer_Lookup__c>();
    Map<Id, WT_Bank_Officer_Lookup__c> mapOldBankOfficerLookupIdAndBankOfficerLookup = new Map<Id, WT_Bank_Officer_Lookup__c>();
    
    public WT_BankOfficerLookupBeforeHandler()
    {
        populateGlobalLists();
    }
    
    public override void beforeInsert()
    {    
        ValidateCodeIsUnique(true, false);
        ConvertFormulaFieldsToText(true, false);
    }
    
    public override void beforeUpdate()
    {    
        ValidateCodeIsUnique(false, true);
        ConvertFormulaFieldsToText(false, true);
    } 
    
    private void populateGlobalLists()
    {
        listNewBankOfficerLookup = (List<WT_Bank_Officer_Lookup__c>) Trigger.new;  
        mapOldBankOfficerLookupIdAndBankOfficerLookup = (Map<Id, WT_Bank_Officer_Lookup__c>) Trigger.oldMap;
    }
    
    /**
* -----------------------------------------------------------------------------------------------------------------------------------------
* @Description
* Method to validate that the code is unique and doesn't exist on any other active user in the system
* Method grabs the new Unique code from either insert or update
* If the code exists already and is active, then the record is not committed to database
* User would get a validate error stating: Sorry, there is already an active lookup in the system with this unique officer code.
* -----------------------------------------------------------------------------------------------------------------------------------------
* @param     isInsert     		Boolean attribute used to determine if the trigger context is Insert
* @param     isUpdate     		Boolean attribute used to determine if the trigger context is Update
* @return    void
* -----------------------------------------------------------------------------------------------------------------------------------------
**/
    private void ValidateCodeIsUnique(Boolean isInsert, Boolean isUpdate)
    {
        Set<String> setUniqueCodeToCheck = new Set<String>();
        for(WT_Bank_Officer_Lookup__c bankOfficerLookup : listNewBankOfficerLookup)
        {
            if(isInsert && String.isNotBlank(bankOfficerLookup.WT_Unique_Officer_Code__c) && !setUniqueCodeToCheck.contains(bankOfficerLookup.WT_Unique_Officer_Code__c))
            {
                setUniqueCodeToCheck.add(bankOfficerLookup.WT_Unique_Officer_Code__c);
            }
            if(isUpdate)
            {
                WT_Bank_Officer_Lookup__c oldBankOfficerLookup = mapOldBankOfficerLookupIdAndBankOfficerLookup.get(bankOfficerLookup.Id);
                if(oldBankOfficerLookup.WT_Unique_Officer_Code__c != bankOfficerLookup.WT_Unique_Officer_Code__c && !setUniqueCodeToCheck.contains(bankOfficerLookup.WT_Unique_Officer_Code__c))
                {
                    setUniqueCodeToCheck.add(bankOfficerLookup.WT_Unique_Officer_Code__c);
                }
            }
        }
        
        if(!setUniqueCodeToCheck.isEmpty())
        {
            Map<String, WT_Bank_Officer_Lookup__c> mapUniqueCodeAndBankOfficerLookup = new Map<String, WT_Bank_Officer_Lookup__c>();
            for(WT_Bank_Officer_Lookup__c existingLookup : [SELECT Id, Name, WT_Unique_Officer_Code__c
                                                            FROM WT_Bank_Officer_Lookup__c
                                                            WHERE WT_Unique_Officer_Code__c IN: setUniqueCodeToCheck
                                                            AND WT_Is_User_Active__c = true])
            {
                mapUniqueCodeAndBankOfficerLookup.put(existingLookup.WT_Unique_Officer_Code__c, existingLookup);
            }
            
            if(!mapUniqueCodeAndBankOfficerLookup.isEmpty())
            {
                for(WT_Bank_Officer_Lookup__c bankOfficerLookup : listNewBankOfficerLookup)
                {
                    if(mapUniqueCodeAndBankOfficerLookup.containsKey(bankOfficerLookup.WT_Unique_Officer_Code__c))
                    {
                        bankOfficerLookup.addError('Sorry, there is already an active lookup in the system with this unique officer code.');
                    }
                }
            }
        }
    }
    
        /**
* -----------------------------------------------------------------------------------------------------------------------------------------
* @Description
* Method to set the text fields on the object
* The reason for setting the text fields is so that the end user can use the search box on list view to search for records
* with values from either fields. Salesforce limitation doesn't allow a formula field to be searchable so this is a workaround 
* for the limitation. 
* -----------------------------------------------------------------------------------------------------------------------------------------
* @param     isInsert     		Boolean attribute used to determine if the trigger context is Insert
* @param     isUpdate     		Boolean attribute used to determine if the trigger context is Update
* @return    void
* -----------------------------------------------------------------------------------------------------------------------------------------
**/
    private void ConvertFormulaFieldsToText(Boolean isInsert, Boolean isUpdate)
    {
        for(WT_Bank_Officer_Lookup__c bankOfficerLookup : listNewBankOfficerLookup)
        {
            bankOfficerLookup.WT_User_Full_Name_Text__c = bankOfficerLookup.WT_User_Full_Name_Formula__c;
            bankOfficerLookup.WT_Unique_Officer_Code_Text__c = bankOfficerLookup.WT_Unique_Officer_Code__c;
        }
    }
}