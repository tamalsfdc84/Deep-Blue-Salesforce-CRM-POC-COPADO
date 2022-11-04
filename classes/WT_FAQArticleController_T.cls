@isTest
public class WT_FAQArticleController_T 
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
        newArticle.WT_Disclaimer__c = 'test';
        newArticle.WT_Knowledge_Category__c = knowledgeCategory.Id;
        insert newArticle;
    }
    
    @isTest
    static void TestGetArticle()
    {
        Test.startTest();
        Knowledge__kav newArticle = [SELECT Id,
                                     KnowledgeArticleId,
                                     UrlName
                                     FROM Knowledge__kav
                                     LIMIT 1];
        
        KbManagement.PublishingService.publishArticle(newArticle.KnowledgeArticleId, true); 
        WT_FAQArticleController.GetArticle(newArticle.UrlName, 'test');
        Test.stopTest();
    }
    
    @isTest
    static void TestRateArticle()
    {
        Test.startTest();
        Knowledge__kav newArticle = [SELECT Id,
                                     KnowledgeArticleId,
                                     UrlName
                                     FROM Knowledge__kav
                                     LIMIT 1];
        
        KbManagement.PublishingService.publishArticle(newArticle.KnowledgeArticleId, true); 
        WT_FAQArticleController.RateArticle(newArticle.UrlName, true);
        Test.stopTest();
    }
}