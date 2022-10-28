/* ----------------------------------------------------------
* @Name             WT_CIFundingController
* @Author           Vamshi Papisetty
* @ModifiedBy       Vamshi Papisetty    <vpapiset@wintrust.com>
* @Version          v1.0
* @CreatedDate      08/31/2022          
* Code Coverage: WT_CIFundingController_T
* The is Apex Controller for wT_CIFundingDetailNiche Component
* @Changes v2.0
* ---------------------------------------------------------*/
public class WT_CIFundingController 
{
        @AuraEnabled(cacheable=true)        
        public static List<WT_CI_Funding_History__c> getFundingList(String accountId)
        { 
            return
            [SELECT Id, WT_Funding_Amount__c, WT_Date_of_Payment__c, WT_Split_Payment__c,WT_Account__c, CreatedById FROM WT_CI_Funding_History__c 
             WHERE WT_Account__c =:accountId ORDER by CreatedDate desc LIMIT 5];
         }        
}