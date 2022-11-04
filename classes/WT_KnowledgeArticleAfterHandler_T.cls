@isTest
public class WT_KnowledgeArticleAfterHandler_T 
{
    @testSetup
    static void Setup()
    {
        WT_DataFactory.createRequiredCustomSetting();
        
        WT_Knowledge_Category__c knowledgeCategory = new WT_Knowledge_Category__c();
        knowledgeCategory.Name = 'Test';
        knowledgeCategory.WT_Date_Published__c = System.now().addDays(-1);
        
        insert knowledgeCategory;
    }
    
    @isTest
    static void TestArticlePublishOnCreationWithComment()
    {
        Test.startTest(); 
        WT_Knowledge_Category__c knowledgeCategory = [SELECT Id FROM WT_Knowledge_Category__c LIMIT 1];
        
        Knowledge__kav newArticle = new Knowledge__kav();
        newArticle.WT_Question__c = 'Test Question';
        newArticle.WT_Answer__c = 'Test Answer';
        newArticle.IsVisibleInPkb = true;
        newArticle.Title = 'Test Title';
        newArticle.UrlName = 'test-article';
        newArticle.WT_Knowledge_Category__c = knowledgeCategory.Id;
        newArticle.WT_Publish_Without_Compliance_Approval__c = true;
        newArticle.WT_Publication_Comment__c = 'test';
        insert newArticle;
        Test.stopTest();
    }
    
    @isTest
    static void TestArticlePublishOnCreationWithoutComment()
    {
        Test.startTest(); 
        WT_Knowledge_Category__c knowledgeCategory = [SELECT Id FROM WT_Knowledge_Category__c LIMIT 1];
        
        Knowledge__kav newArticle = new Knowledge__kav();
        newArticle.WT_Question__c = 'Test Question';
        newArticle.WT_Answer__c = 'Test Answer';
        newArticle.IsVisibleInPkb = true;
        newArticle.Title = 'Test Title';
        newArticle.UrlName = 'test-article';
        newArticle.WT_Knowledge_Category__c = knowledgeCategory.Id;
        newArticle.WT_Publish_Without_Compliance_Approval__c = true;
        try
        {
            insert newArticle;
        }
        catch(Exception ex)
        {
            
        }
        Test.stopTest();
    }
    
    @isTest
    static void TestArticlePublishOnUpdateWithoutComment()
    {
        Test.startTest(); 
        WT_Knowledge_Category__c knowledgeCategory = [SELECT Id FROM WT_Knowledge_Category__c LIMIT 1];
        
        Knowledge__kav newArticle = new Knowledge__kav();
        newArticle.WT_Question__c = 'Test Question';
        newArticle.WT_Answer__c = 'Test Answer';
        newArticle.IsVisibleInPkb = true;
        newArticle.Title = 'Test Title';
        newArticle.UrlName = 'test-article';
        newArticle.WT_Knowledge_Category__c = knowledgeCategory.Id;        
        insert newArticle;
        
        Knowledge__kav articleToUpdate = new Knowledge__kav();
        articleToUpdate.Id = newArticle.Id;
        articleToUpdate.WT_Publish_Without_Compliance_Approval__c = true;
        try
        {
            update articleToUpdate;
        }
        catch(Exception ex)
        {
            
        }
        
        Test.stopTest();
    }
    
    @isTest
    static void TestArticlePublishOnUpdateWithComment()
    {
        Test.startTest(); 
        WT_Knowledge_Category__c knowledgeCategory = [SELECT Id FROM WT_Knowledge_Category__c LIMIT 1];
        
        Knowledge__kav newArticle = new Knowledge__kav();
        newArticle.WT_Question__c = 'Test Question';
        newArticle.WT_Answer__c = 'Test Answer';
        newArticle.IsVisibleInPkb = true;
        newArticle.Title = 'Test Title';
        newArticle.UrlName = 'test-article';
        newArticle.WT_Knowledge_Category__c = knowledgeCategory.Id;        
        insert newArticle;
        
        Knowledge__kav articleToUpdate = new Knowledge__kav();
        articleToUpdate.Id = newArticle.Id;
        articleToUpdate.WT_Publish_Without_Compliance_Approval__c = true;
        articleToUpdate.WT_Publication_Comment__c = 'test';
        try
        {
            update articleToUpdate;
        }
        catch(Exception ex)
        {
            
        }
        
        Test.stopTest();
    }
}