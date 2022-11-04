public class WT_FAQArticleController 
{
    @AuraEnabled 
    public static ArticleResponseModel GetArticle(String articleName, String searchTerm)
    {
        ArticleResponseModel responseModel = new ArticleResponseModel();
        DateTime now = System.now();
        
        Boolean isSandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
        responseModel.IsSandbox = isSandbox;
        
        for(Knowledge__kav article : [SELECT Id,
                                      Title,
                                      WT_Question__c,
                                      UrlName,
                                      WT_Answer__c,
                                      WT_Knowledge_Category__r.WT_Category_Title__c,
                                      //WT_Knowledge_Category__r.WT_Sub_Title__c,
                                      WT_Disclaimer__c
                                      FROM Knowledge__kav
                                      WHERE UrlName = :articleName
                                      AND PublishStatus = 'Online'
                                      AND (WT_Knowledge_Category__r.WT_Date_Published__c <= :now AND
                                           (WT_Knowledge_Category__r.WT_Date_Unpublished__c = NULL OR WT_Knowledge_Category__r.WT_Date_Unpublished__c > :now))
                                      UPDATE VIEWSTAT])
        {
            responseModel.ArticleQuestion = article.WT_Question__c;
            responseModel.ArticleAnswer = article.WT_Answer__c;
            if(String.isNotBlank(article.WT_Disclaimer__c))
            {
                responseModel.HasDisclaimer = true;
                responseModel.ArticleDisclaimer = article.WT_Disclaimer__c;
            }
            else
            {
                responseModel.HasDisclaimer = false;    
            }
            
            if(String.isNotBlank(searchTerm))
            {
                LogSearchArticleFuture(article.Id, searchTerm);
            }
        }
        responseModel.IsSuccess = true;
        
        return responseModel;
    }
    
    @AuraEnabled 
    public static ArticleRatingResponseModel RateArticle(String articleName, Boolean isLike)
    {
        ArticleRatingResponseModel responseModel = new ArticleRatingResponseModel();
        responseModel.IsSuccess = false;
        DateTime now = System.now();
        WT_Knowledge_Vote__c voteRecord = null;
        
        for(Knowledge__kav article : [SELECT Id,
                                      KnowledgeArticleId
                                      FROM Knowledge__kav
                                      WHERE UrlName = :articleName
                                      AND PublishStatus = 'Online'
                                      AND (WT_Knowledge_Category__r.WT_Date_Published__c <= :now AND
                                           (WT_Knowledge_Category__r.WT_Date_Unpublished__c = NULL OR WT_Knowledge_Category__r.WT_Date_Unpublished__c > :now))
                                      LIMIT 1])
        {
            voteRecord = new WT_Knowledge_Vote__c();
            voteRecord.WT_Knowledge__c = article.Id;
            voteRecord.WT_Type__c = (isLike) ? 'Up' : 'Down';
        }
        
        if(voteRecord != null)
        {
            try
            {
                insert voteRecord;
                responseModel.IsSuccess = true;
            }
            catch(Exception ex)
            {
                responseModel.Message = ex.getMessage();
            }
        }
        
        return responseModel;
    }
    
    @Future
    public static void LogSearchArticleFuture(Id articleId, String searchTerm)
    {
        if(articleId != null)
        {
            WT_Knowledge_Search_Log__c newSearchLog = new WT_Knowledge_Search_Log__c();
            newSearchLog.WT_Search_Term__c = searchTerm;
            newSearchLog.WT_Knowledge__c = articleId;
            
            try
            {
                insert newSearchLog;
            }
            catch(Exception ex)
            {
                System.debug('ex: ' + ex.getMessage());
            }
        }
    }
    
    public class ArticleRatingResponseModel
    {
        @AuraEnabled public Boolean IsSuccess;
        @AuraEnabled public String Message;
    }
    
    public class ArticleResponseModel
    {
        @AuraEnabled public String ArticleQuestion;
        @AuraEnabled public String ArticleAnswer;
        @AuraEnabled public String ArticleDisclaimer;
        @AuraEnabled public Boolean HasDisclaimer;
        @AuraEnabled public Boolean IsSuccess;
        @AuraEnabled public Boolean IsSandbox;
    }
}