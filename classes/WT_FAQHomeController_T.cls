@isTest
public class WT_FAQHomeController_T 
{
    @testSetup
    static void Setup()
    {
        WT_Knowledge_Category__c knowledgeCategory = new WT_Knowledge_Category__c();
        knowledgeCategory.Name = 'Test';
        knowledgeCategory.WT_Date_Published__c = System.now().addDays(-1);
        
        insert knowledgeCategory;
        
        Knowledge__kav newArticle = new Knowledge__kav();
        newArticle.WT_Question__c = 'Test Question';
        newArticle.WT_Answer__c = 'Test Answer';
        newArticle.IsVisibleInPkb = true;
        newArticle.Title = 'Test Title';
        newArticle.UrlName = 'test-article';
        newArticle.WT_Knowledge_Category__c = knowledgeCategory.Id;
        insert newArticle;
    }
	
    @isTest
    static void TestGetFaqCategories()
    {
        Test.startTest();        
        Knowledge__kav newArticle = [SELECT Id,
                                     UrlName,
                                     WT_Knowledge_Category__c,
                                     KnowledgeArticleId
                                     FROM Knowledge__kav
                                     LIMIT 1];
        
        KbManagement.PublishingService.publishArticle(newArticle.KnowledgeArticleId, true);   
        WT_FAQHomeController.GetFaqCategories(newArticle.WT_Knowledge_Category__c, newArticle.UrlName);
        Test.stopTest();
    }
}