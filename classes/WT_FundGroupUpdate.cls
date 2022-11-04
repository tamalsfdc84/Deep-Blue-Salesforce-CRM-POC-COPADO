/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_FundGroupUpdate
* @Author			Swaminathan E	<SEzhumal@wintrust.com>
* @ModifiedBy		Swaminathan E	<SEzhumal@wintrust.com>
* @Version			v1.0
* @CreatedDate		10-18-2021
* @UsedBy			Financial Account Object
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is used for Update the Related Fund Group Status based on Financial Account.
* 
* --------------------------------------------------------------------------------------------------------------
* @Changes
* v1.0
* MM-DD-YYYY
* --------------------------------------------------------------------------------------------------------------
**/
public class WT_FundGroupUpdate 
{
    @InvocableMethod
    public static void updateFundGroup(List<Id> recordId)
    {
        List<WT_Funds_Groups__c> listFundGroup = [SELECT Id, WT_Status__c FROM WT_Funds_Groups__c WHERE WT_Wintrust_Funds_Alternative_Fund__c =: recordId];
        for(WT_Funds_Groups__c fundGroup : listFundGroup)
        {
            fundGroup.WT_Status__c = 'Inactive';
        }
        try
        {
            update listFundGroup;
        }
        catch(DmlException e) 
        {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
    }
}