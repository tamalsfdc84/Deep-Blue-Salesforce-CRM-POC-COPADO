public class WT_FAQArticleCategoryController 
{
    @AuraEnabled 
    public static ArticleCategoryResponseModel GetListArticleInArticleCategory(String articleCategoryId, List<Id> listExistingArticleId, Boolean isFirstRequest)
    {
        ArticleCategoryResponseModel responseModel = new ArticleCategoryResponseModel();
        List<ArticleModel> listArticle = new List<ArticleModel>();
        DateTime now = System.now();
        Boolean isSandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
        responseModel.IsSandbox = isSandbox;
        responseModel.HasMoreResults = false;
        Map<Id, ArticleModel> mapKnowledgeArticleIdAndArticleModel = new Map<Id, ArticleModel>();
        Map<Id, Id> mapKnowledgeArticleIdAndKnowledgeArticleVersionId = new Map<Id, Id>();
        if(listExistingArticleId == null)
        {
            listExistingArticleId = new List<Id>();
        }
        
        //Get the list of Knowledge Article Versions that are Published and match the Category
        //From them query KnowledgeArticleViewStat object using the master Knowledge Article Id to get the view stat for each article so it can be ordered correctly
        for(Knowledge__kav article : [SELECT Id,
                                      Title,
                                      WT_Question__c,
                                      UrlName,
                                      WT_Knowledge_Category__r.WT_Category_Title__c,
                                      //WT_Knowledge_Category__r.WT_Sub_Title__c,
                                      KnowledgeArticleId,
                                      WT_Knowledge_Category__r.Name
                                      FROM Knowledge__kav
                                      WHERE WT_Knowledge_Category__c = :articleCategoryId
                                      AND PublishStatus = 'Online'
                                      AND (WT_Knowledge_Category__r.WT_Date_Published__c <= :now AND
                                           (WT_Knowledge_Category__r.WT_Date_Unpublished__c = NULL OR WT_Knowledge_Category__r.WT_Date_Unpublished__c > :now))
                                      AND Id NOT IN :listExistingArticleId
                                      LIMIT 10000])
        {
            mapKnowledgeArticleIdAndKnowledgeArticleVersionId.put(article.KnowledgeArticleId, article.Id);
            mapKnowledgeArticleIdAndArticleModel.put(article.KnowledgeArticleId, new ArticleModel(article.WT_Question__c, article.Title, article.UrlName, article.WT_Knowledge_Category__r.Name, isSandbox));
            responseModel.Title = article.WT_Knowledge_Category__r.WT_Category_Title__c;
            //responseModel.SubTitle = article.WT_Knowledge_Category__r.WT_Sub_Title__c;
        }
        
        if(!mapKnowledgeArticleIdAndArticleModel.isEmpty())
        {
            Integer maxResultCount = 10;
            if(isFirstRequest)
            {
                maxResultCount = 6;
            }
            Integer iterationCount = 0;
            for(KnowledgeArticleViewStat articleViewStat : [SELECT Id,
                                                            ViewCount,
                                                            Channel,
                                                            ParentId,
                                                            NormalizedScore
                                                            FROM KnowledgeArticleViewStat
                                                            WHERE Channel = 'Pkb'
                                                            AND ParentId IN :mapKnowledgeArticleIdAndArticleModel.keySet()
                                                            ORDER BY NormalizedScore DESC])
            {
                if(iterationCount < maxResultCount)
                {
                    listArticle.add(mapKnowledgeArticleIdAndArticleModel.get(articleViewStat.ParentId));
                    listExistingArticleId.add(mapKnowledgeArticleIdAndKnowledgeArticleVersionId.get(articleViewStat.ParentId));
                }
                else
                {
                    responseModel.HasMoreResults = true;
                    break;
                }
                iterationCount++;
            }
        }
        
        responseModel.ListArticle = listArticle;
        responseModel.IsSuccess = true;
        responseModel.ListExistingArticleId = listExistingArticleId;
        
        return responseModel;
    }
    
    public class ArticleCategoryResponseModel
    {
        @AuraEnabled public String Title;
        @AuraEnabled public String SubTitle;
        @AuraEnabled public Boolean IsSuccess;
        @AuraEnabled public Boolean IsSandbox;
        @AuraEnabled public Boolean HasMoreResults;
        @AuraEnabled public List<ArticleModel> ListArticle;
        @AuraEnabled public List<Id> ListExistingArticleId;
    }
    
    public class ArticleModel
    {
        @AuraEnabled public String ArticleQuestion;
        @AuraEnabled public String ArticleTitle;
        @AuraEnabled public String ArticleUrl;
        @AuraEnabled public String ArticleRedirectUrl;
        
        public ArticleModel(String question, String title, String url, String articleCategoryName, Boolean isSandbox)
        {
            this.ArticleQuestion = (String.isNotBlank(question)) ? question.unescapeHtml4() : '';
            this.ArticleTitle = title;
            this.ArticleUrl = url;
            if(isSandbox)
            {
                this.ArticleRedirectUrl = '/s/article/' + url + '?categoryName=' + articleCategoryName.replace('&', '~');
            }
            else
            {
             	this.ArticleRedirectUrl = '/s/article/' + url + '?categoryName=' + articleCategoryName.replace('&', '~');  
            }
        }
    }
}