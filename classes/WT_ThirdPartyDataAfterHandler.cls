public class WT_ThirdPartyDataAfterHandler extends TriggerHandler
{
	List<WT_Third_Party_Data__c> listNewThirdPartyData = new List<WT_Third_Party_Data__c>();
    Map<Id, WT_Third_Party_Data__c> mapNewThirdPartyDataIdandThirdPartyData = new Map<Id, WT_Third_Party_Data__c>();
    Map<Id, WT_Third_Party_Data__c> mapOldThirdPartyDataIdandThirdPartyData = new Map<Id, WT_Third_Party_Data__c>();
    
    public WT_ThirdPartyDataAfterHandler()
    {
        PopulateGlobalLists();        
    }
    public override void afterInsert()
    {
        MapThirdPartyDataToAccount(listNewThirdPartyData);
    }
    public override void afterUpdate()
    {
        MapThirdPartyDataToAccount(listNewThirdPartyData);
    }
    private void PopulateGlobalLists()
    {        
        listNewThirdPartyData = (List<WT_Third_Party_Data__c>) Trigger.new;
        mapNewThirdPartyDataIdandThirdPartyData = (Map<Id, WT_Third_Party_Data__c>) Trigger.newMap;
        mapOldThirdPartyDataIdandThirdPartyData = (Map<Id, WT_Third_Party_Data__c>) Trigger.oldMap;
    }
    
    private void MapThirdPartyDataToAccount(List<WT_Third_Party_Data__c> listThirdParty)
    {
        List<WT_Third_Party_Data__c> listThirdPartyDataToMapToAccount = new List<WT_Third_Party_Data__c>();
        for(WT_Third_Party_Data__c thirdPartyData : listThirdParty)
        {
            if(thirdPartyData.WT_Account__c == null)
            {
                listThirdPartyDataToMapToAccount.add(thirdPartyData);
            }
        }
        
        if(!listThirdPartyDataToMapToAccount.isEmpty())
        {
            WT_ThirdPartyDataToAccountMatchUtility.MatchThirdPartyDataToAccount(listThirdPartyDataToMapToAccount);
        }
    }
}