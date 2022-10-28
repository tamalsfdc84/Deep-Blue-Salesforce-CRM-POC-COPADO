public class WT_KnowledgeArticleAfterHandler extends TriggerHandler
{
	List<Knowledge__kav> listNewKnowledgeArticle = new List<Knowledge__kav>();
    Map<Id, Knowledge__kav> mapNewKnowledgeArticleandKnowledgeArticle = new Map<Id, Knowledge__kav>();
    Map<Id, Knowledge__kav> mapOldKnowledgeArticleandKnowledgeArticle = new Map<Id, Knowledge__kav>();
    
    public WT_KnowledgeArticleAfterHandler()
    {
        PopulateGlobalLists();        
    }
    
    public override void afterInsert()
    {
        CheckIfPublishWithoutApprovalChecked(true);
    }
    
    public override void afterUpdate()
    {
        CheckIfPublishWithoutApprovalChecked(false);
    }
    
    private void PopulateGlobalLists()
    {        
        listNewKnowledgeArticle = (List<Knowledge__kav>) Trigger.new;
        mapNewKnowledgeArticleandKnowledgeArticle = (Map<Id, Knowledge__kav>) Trigger.newMap;
        mapOldKnowledgeArticleandKnowledgeArticle = (Map<Id, Knowledge__kav>) Trigger.oldMap;
    }
    
    private void CheckIfPublishWithoutApprovalChecked(Boolean isInsert)
    {
        for(Knowledge__kav updatedArticle : listNewKnowledgeArticle)
        {
            Knowledge__kav oldArticle = null;
            if(!isInsert)    
            {
            	oldArticle = mapOldKnowledgeArticleandKnowledgeArticle.get(updatedArticle.Id);    
            }
            
            if(!isInsert && updatedArticle.WT_Publish_Without_Compliance_Approval__c && !oldArticle.WT_Publish_Without_Compliance_Approval__c)
            {
                if(String.isBlank(updatedArticle.WT_Publication_Comment__c))
                {
                    updatedArticle.addError('Error: Cannot publish an article without a publication comment');
                }
                else if(updatedArticle.WT_Publication_Comment__c == oldArticle.WT_Publication_Comment__c)
                {
                    updatedArticle.addError('Error: Publication comment should be updated in order to "Publish Without Compliance Approval"');
                }
                else
                {
                    KbManagement.PublishingService.publishArticle(updatedArticle.KnowledgeArticleId, true);
                }
            }
            else if(isInsert && updatedArticle.WT_Publish_Without_Compliance_Approval__c)
            {
                if(String.isBlank(updatedArticle.WT_Publication_Comment__c))
                {
                    updatedArticle.addError('Error: Cannot publish an article without a publication comment');
                }
                else
                {
                    KbManagement.PublishingService.publishArticle(updatedArticle.KnowledgeArticleId, true);
                }
            }
        }
    }
}