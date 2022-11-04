/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name             WT_BatchCampaignMembersLoadExecute
* @Author           Pushpa Mopuru   <PMopuru@wintrust.com>
* @ModifiedBy       Pushpa Mopuru   <PMopuru@wintrust.com>
* @version          v1.0 
* @CreatedDate      03-25-2021
* @UsedBy           CampaignMembe,Accounts
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* Class is used to execute Batch classWT_BatchCampaignMembersLoad.
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Changes
* vx.x              <user id>
* MM-DD-YYYY        <Explanation> 
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
global class WT_CampaignMembersLoadBatchExecute {
@AuraEnabled(cacheable=true)
global static void runCampaignMembersLoadBatch() 
    {
        WT_BatchCampaignMembersLoad campaignMemberBatch= new WT_BatchCampaignMembersLoad(); 
        Id batchId= Database.executeBatch(campaignMemberBatch); 
    }
   
}