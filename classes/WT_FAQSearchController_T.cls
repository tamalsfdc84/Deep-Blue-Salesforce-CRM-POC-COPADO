@isTest
public class WT_FAQSearchController_T 
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
        
        Id synonymRecordTypeId = Schema.SObjectType.WT_Knowledge_Keyword_Group__c.getRecordTypeInfosByDeveloperName().get('WT_Synonyms').getRecordTypeId();
        WT_Knowledge_Keyword_Group__c synonymGroup = new WT_Knowledge_Keyword_Group__c();
        synonymGroup.RecordTypeId = synonymRecordTypeId;
        synonymGroup.WT_Synonym_1__c = 'test';
        synonymGroup.WT_Synonym_2__c = 'test1';
        synonymGroup.WT_Synonym_3__c = 'test2';
        synonymGroup.WT_Synonym_4__c = 'test3';
        synonymGroup.WT_Synonym_5__c = 'test4';
        synonymGroup.WT_Synonym_6__c = 'test5';
        synonymGroup.WT_Synonym_7__c = 'test6';
        synonymGroup.WT_Synonym_8__c = 'test7';
        synonymGroup.WT_Synonym_9__c = 'test8';
        synonymGroup.WT_Synonym_10__c = 'test9';
        insert synonymGroup;
        
        Id hypernymRecordTypeId = Schema.SObjectType.WT_Knowledge_Keyword_Group__c.getRecordTypeInfosByDeveloperName().get('WT_Hypernyms').getRecordTypeId();
        WT_Knowledge_Keyword_Group__c hypernymGroup = new WT_Knowledge_Keyword_Group__c();
        hypernymGroup.RecordTypeId = hypernymRecordTypeId;
        hypernymGroup.WT_Hypernym_1__c = 'test';
        hypernymGroup.WT_Hypernym_2__c = 'test1';
        hypernymGroup.WT_Hypernym_3__c = 'test2';
        hypernymGroup.WT_Hypernym_4__c = 'test3';
        hypernymGroup.WT_Hypernym_5__c = 'test4';
        hypernymGroup.WT_Hypernym_6__c = 'test5';
        hypernymGroup.WT_Hypernym_7__c = 'test6';
        hypernymGroup.WT_Hypernym_8__c = 'test7';
        hypernymGroup.WT_Hypernym_9__c = 'test8';
        hypernymGroup.WT_Hypernym_10__c = 'test9';
        insert hypernymGroup;
        
        Id stopWordsRecordTypeId = Schema.SObjectType.WT_Knowledge_Keyword_Group__c.getRecordTypeInfosByDeveloperName().get('WT_Stop_Words').getRecordTypeId();
        WT_Knowledge_Keyword_Group__c stopWord = new WT_Knowledge_Keyword_Group__c();
        stopWord.RecordTypeId = hypernymRecordTypeId;
        stopWord.WT_Stop_Word__c = 'NotTest';
        insert stopWord;
        
        Id misspellingRecordTypeId = Schema.SObjectType.WT_Knowledge_Keyword_Group__c.getRecordTypeInfosByDeveloperName().get('WT_Misspellings').getRecordTypeId();
        WT_Knowledge_Keyword_Group__c misspellingRecord = new WT_Knowledge_Keyword_Group__c();
        misspellingRecord.RecordTypeId = misspellingRecordTypeId;
        misspellingRecord.WT_Correctly_Spelled_Keyword__c = 'test';
        misspellingRecord.WT_Misspelling_1__c = 'test';
        insert misspellingRecord;
    }
	
    @isTest
    static void TestGetTrendingTopics()
    {
        Test.startTest();
        Knowledge__kav newArticle = [SELECT Id,
                                     KnowledgeArticleId
                                     FROM Knowledge__kav
                                     LIMIT 1];
        KbManagement.PublishingService.publishArticle(newArticle.KnowledgeArticleId, true);   
        WT_FAQSearchController.GetTrendingTopics();
        Test.stopTest();
    }
    
    @isTest
    static void TestGetSearchAutoSuggest()
    {
        Test.startTest();
        Id synonymRecordTypeId = Schema.SObjectType.WT_Knowledge_Keyword_Group__c.getRecordTypeInfosByDeveloperName().get('WT_Synonyms').getRecordTypeId();
        List<WT_Knowledge_Keyword_Group__c> listKeyword = [SELECT Id
                                                           FROM WT_Knowledge_Keyword_Group__c];
                
        Knowledge__kav newArticle = [SELECT Id,
                                     KnowledgeArticleId
                                     FROM Knowledge__kav
                                     LIMIT 1];
        
        Id [] fixedSearchResults = new Id[5];
        fixedSearchResults[0] = listKeyword[0].Id;
        fixedSearchResults[1] = listKeyword[1].Id;
        fixedSearchResults[2] = listKeyword[2].Id;
        fixedSearchResults[3] = listKeyword[3].Id;
        fixedSearchResults[4] = newArticle.Id;
        Test.setFixedSearchResults(fixedSearchResults);
        
        KbManagement.PublishingService.publishArticle(newArticle.KnowledgeArticleId, true);   
        WT_FAQSearchController.GetSearchAutoSuggest('test', false);
        WT_FAQSearchController.GetSearchAutoSuggest('test', true);
        Test.stopTest();
    }
}