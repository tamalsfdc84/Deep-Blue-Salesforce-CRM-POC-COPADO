public class WT_FAQHomeController 
{
    @AuraEnabled
    public static FaqCategoryResponseModel GetFaqCategories(String categoryId, String articleName)
    {
        FaqCategoryResponseModel responseModel = new FaqCategoryResponseModel();
        Boolean isSandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
        responseModel.IsSandbox = isSandbox;

        List<FaqCategoryModel> listCategory = new List<FaqCategoryModel>();
        DateTime now = System.now();
        
        if(String.isBlank(categoryId) && String.isNotBlank(articleName))
        {
            List<Knowledge__kav> listArticle = [SELECT Id,
                                                UrlName,
                                                WT_Knowledge_Category__c
                                                FROM Knowledge__kav
                                                WHERE UrlName = :articleName
                                                AND PublishStatus = 'Online'
                                                AND (WT_Knowledge_Category__r.WT_Date_Published__c <= :now AND
                                                     (WT_Knowledge_Category__r.WT_Date_Unpublished__c = NULL OR WT_Knowledge_Category__r.WT_Date_Unpublished__c > :now))];
            
            if(listArticle != null && !listArticle.isEmpty())
            {
                categoryId = listArticle[0].WT_Knowledge_Category__c;
            }
        }
        
        for(WT_Knowledge_Category__c activeCategory : [SELECT Id,
                                                       Name,
                                                       WT_Date_Published__c,
                                                       WT_Date_Unpublished__c,
                                                       WT_Portal_Icon_Name__c,
                                                       WT_Display_Order__c
                                                       FROM WT_Knowledge_Category__c
                                                       WHERE WT_Date_Published__c <= :now AND
                                                       (WT_Date_Unpublished__c = NULL OR WT_Date_Unpublished__c > :now)
                                                       ORDER BY WT_Display_Order__c])
        {
            Boolean isActive = false;
            if(String.isNotBlank(categoryId) && activeCategory.Id == categoryId)
            {
                isActive = true;
                responseModel.ActiveCategoryName = activeCategory.Name;
            }
            listCategory.add(new FaqCategoryModel(activeCategory.Name, activeCategory.WT_Portal_Icon_Name__c, isActive, isSandbox, activeCategory.Id));
        }
        
        responseModel.ListCategory = listCategory;
        responseModel.IsSuccess = true;
        return responseModel;
    }
    
    public class FaqCategoryResponseModel
    {
        @AuraEnabled public String ActiveCategoryName;
        @AuraEnabled public List<FaqCategoryModel> ListCategory;
        @AuraEnabled public Boolean IsSandbox;
        @AuraEnabled public Boolean IsSuccess;
    }

    public class FaqCategoryModel
    {
        @AuraEnabled public String CategoryName;
        @AuraEnabled public String CategoryIcon;
        @AuraEnabled public String CategoryIconFullPath;
        @AuraEnabled public String CategoryRedirectUrlPath;
        @AuraEnabled public Boolean IsActive;
        
        public FaqCategoryModel(String name, String iconName, Boolean isActive, Boolean isSandbox, Id categoryId)
        {
            this.CategoryName = name;
            this.CategoryIcon = iconName;
            this.CategoryIconFullPath = '';
            this.IsActive = isActive;
            if(isSandbox)
            {
                this.CategoryRedirectUrlPath = '/s/article-category/' + categoryId;
            }
            else
            {
                this.CategoryRedirectUrlPath = '/s/article-category/' + categoryId;
            }
        }
    }
}