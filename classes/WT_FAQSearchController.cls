public class WT_FAQSearchController 
{
    @AuraEnabled
    public static List<TrendingTopicResponseModel> GetTrendingTopics()
    {        
        List<TrendingTopicResponseModel> listReturnModel = new List<TrendingTopicResponseModel>();
       	Set<Id> setPublishedArticleId = new Set<Id>();
        Map<Id, Set<String>> mapArticleIdAndSetDataCategory = new Map<Id, Set<String>>();
        Map<Id, String> mapArticleIdAndUrlName = new Map<Id, String>();
        DateTime now = System.now();
        for(Knowledge__kav article : [SELECT Id,
                                      KnowledgeArticleId,
                                      UrlName,
                                      (SELECT Id, toLabel(DataCategoryName) FROM DataCategorySelections)
                                      FROM Knowledge__kav
                                      WHERE PublishStatus = 'Online'
                                      AND (WT_Knowledge_Category__r.WT_Date_Published__c <= :now AND
                                           (WT_Knowledge_Category__r.WT_Date_Unpublished__c = NULL OR WT_Knowledge_Category__r.WT_Date_Unpublished__c > :now))
                                      LIMIT 10000])
        {
            mapArticleIdAndUrlName.put(article.KnowledgeArticleId, article.UrlName);
            setPublishedArticleId.add(article.KnowledgeArticleId);
            
            System.debug('article.DataCategorySelections: ' + article.DataCategorySelections);
            if(article.DataCategorySelections != null && !article.DataCategorySelections.isEmpty())
            {
                Set<String> setRelatedDataCategory = new Set<String>();
                if(mapArticleIdAndSetDataCategory.containsKey(article.KnowledgeArticleId))
                {
                    setRelatedDataCategory = mapArticleIdAndSetDataCategory.get(article.KnowledgeArticleId);
                }
                
                for(Knowledge__DataCategorySelection relatedDataCategory : article.DataCategorySelections)
                {
                    setRelatedDataCategory.add(relatedDataCategory.dataCategoryName);
                }
            	System.debug('setRelatedDataCategory: ' + setRelatedDataCategory);    
                mapArticleIdAndSetDataCategory.put(article.KnowledgeArticleId, setRelatedDataCategory);
            }
        }
        
        Integer dataCategoryIndex = 0;
        Set<String> setExistingCategory = new Set<String>();
        for(KnowledgeArticleViewStat articleViewStat : [SELECT Id,
                                                        ViewCount,
                                                        Channel,
                                                        ParentId,
                                                        NormalizedScore
                                                        FROM KnowledgeArticleViewStat
                                                        WHERE Channel = 'Pkb'
                                                        AND ParentId IN :setPublishedArticleId
                                                        ORDER BY NormalizedScore DESC])
        {
            System.debug('articleViewStat: ' + articleViewStat);
            System.debug('dataCategoryIndex: ' + dataCategoryIndex);
            if(dataCategoryIndex < 4)
            {
                System.debug('mapArticleIdAndSetDataCategory.containsKey(articleViewStat.ParentId): ' + mapArticleIdAndSetDataCategory.containsKey(articleViewStat.ParentId));
                if(mapArticleIdAndSetDataCategory.containsKey(articleViewStat.ParentId))
                {
                    Set<String> setAssociatedDataCategory = mapArticleIdAndSetDataCategory.get(articleViewStat.ParentId);
                    if(setAssociatedDataCategory != null && !setAssociatedDataCategory.isEmpty())
                    {
                        for(String relatedDataCategory : setAssociatedDataCategory)
                        {
                            if(dataCategoryIndex < 4 && !setExistingCategory.contains(relatedDataCategory))
                            {
                                setExistingCategory.add(relatedDataCategory);
                                TrendingTopicResponseModel responseModel = new TrendingTopicResponseModel();
                                responseModel.ItemKey = dataCategoryIndex;
                                responseModel.TopicName = relatedDataCategory;
                                responseModel.RedirectUrl = '/s/article/' + mapArticleIdAndUrlName.get(articleViewStat.ParentId);
                                
                                listReturnModel.add(responseModel);
                                dataCategoryIndex++;
                                break;
                            }
                        }
                    }
                }
            }
            else
            {
                break;
            }
        }
        
        return listReturnModel;
    }
    
    @AuraEnabled
    public static AutoSuggestResponseModel GetSearchAutoSuggest(String searchTerm, Boolean isAutoSuggestSearch)
    {
        AutoSuggestResponseModel responseModel = new AutoSuggestResponseModel();
        List<AutoSuggestModel> listAutoSuggestModel = new List<AutoSuggestModel>();
        responseModel.IsSuccess = true;
        Integer maximumSearchRecord = 500;

        if(isAutoSuggestSearch)
        {
            maximumSearchRecord = 5;
        }

        Boolean isSandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
        responseModel.IsSandbox = isSandbox;
        
        if(String.isNotBlank(searchTerm))
        {
            Set<String> setSearchTermWithoutStrippingSingleCharacter = GetStringToSetOfString(searchTerm);
            Set<String> setStopKeyword = GetStopWords(setSearchTermWithoutStrippingSingleCharacter);
            //See if a search matches an autosuggest (New object: WT_Knowledge_Auto_Suggest__c)
            List<AutoSuggestModel> listPresetAutoSuggest = new List<AutoSuggestModel>();

            if(isAutoSuggestSearch)
            {
                listPresetAutoSuggest = GetAutoSuggestRecords(searchTerm, isSandbox, maximumSearchRecord, setStopKeyword);
            }
            
            if(listPresetAutoSuggest != null && !listPresetAutoSuggest.isEmpty())
            {
                //if the current request is an auto suggest search then add the result in the return list
                if(isAutoSuggestSearch)
                {
                    listAutoSuggestModel.addAll(listPresetAutoSuggest);
                }
                else
                {
                    //If the current request is part of the search button click, then iterate through the 
                    //Model returned from GetAutoSuggestRecords and get the list of Knowledge Article Id
                    //so that a SOQL query can be constructed to grab the Question & Answer from the Articles
                    Set<Id> setKnowledgeArticleIdToQuery = new Set<Id>();
                    for(AutoSuggestModel autoSuggestItem : listPresetAutoSuggest)
                    {
                        setKnowledgeArticleIdToQuery.add(autoSuggestItem.ArticleId);
                    }

                    if(!setKnowledgeArticleIdToQuery.isEmpty())
                    {
                        for(Knowledge__kav knowledgeArticle : [SELECT Id, 
                                                                WT_Question__c, 
                                                                WT_Answer__c, 
                                                                UrlName,
                                                                WT_Knowledge_Category__r.Name
                                                                FROM Knowledge__kav
                                                                WHERE PublishStatus = 'Online' AND IsLatestVersion = true])
                        {
                            listAutoSuggestModel.add(new AutoSuggestModel(knowledgeArticle.UrlName, knowledgeArticle.WT_Question__c, knowledgeArticle.Id, knowledgeArticle.WT_Answer__c, knowledgeArticle.WT_Knowledge_Category__r.Name, isSandbox));
                        }
                    }
                }
            }

            //Only go through and search for more results if the existing list is less than the max allowed result size
            if(listAutoSuggestModel.size() < maximumSearchRecord)
            {
                Set<String> setSearchTerm = GetStringToSetOfStringForGreaterThanSingleCharacter(searchTerm);

                //Get misspellings first so that they we can search for potential synonyms and hypernyms before moving to the general search
                Set<String> setMisspelling = GetMisspellings(setSearchTerm);
                if(setMisspelling != null && !setMisspelling.isEmpty())
                {
                    setSearchTerm.addAll(setMisspelling);
                }

                //Get hypernyms next since they're more broad than synonyms
                Set<String> setHypernym = GetHypernyms(setSearchTerm);
                if(setHypernym != null && !setHypernym.isEmpty())
                {
                    setSearchTerm.addAll(setHypernym);
                }

                //Get synonyms
                Set<String> setSynonym = GetSynonyms(setSearchTerm);
                if(setSynonym != null && !setSynonym.isEmpty())
                {
                    setSearchTerm.addAll(setSynonym);
                }
                
                if(setStopKeyword != null && !setStopKeyword.isEmpty() && setSearchTerm != null && !setSearchTerm.isEmpty())
                {
                    for(String stopKeyword : setStopKeyword)
                    {
                        if(setSearchTerm.contains(stopKeyword))
                        {
                            setSearchTerm.remove(stopKeyword);
                        }
                    }
                }
                
                String stringToSearch = GetSoslSearchTermFromSetString(setSearchTerm);
                
                //Do a SOSL search
                //Check if an article should be pinned to the top
                //TODO: Update string to search to also add (terms or terms or terms or "phrase")
                if(String.isNotBlank(stringToSearch))
                {
                    DateTime now = System.now();
                    List<List<sObject>> listOfListKnowledge = [FIND :stringToSearch
                                                               IN ALL FIELDS
                                                               RETURNING Knowledge__kav(Id, 
                                                                                        WT_Question__c, 
                                                                                        WT_Answer__c, 
                                                                                        UrlName,
                                                                                        WT_Knowledge_Category__r.Name 
                                                                                        WHERE PublishStatus = 'Online' 
                                                                                        AND IsLatestVersion = true
                                                                                        AND (WT_Knowledge_Category__r.WT_Date_Published__c <= :now AND
                                           												(WT_Knowledge_Category__r.WT_Date_Unpublished__c = NULL OR 
                                                                                         WT_Knowledge_Category__r.WT_Date_Unpublished__c > :now))
                                                                                        ORDER BY WT_Priority__c)
                                                               LIMIT :maximumSearchRecord];
                    if(listOfListKnowledge != null && !listOfListKnowledge.isEmpty())
                    {
                        List<Knowledge__kav> listKnowledge = listOfListKnowledge[0];
                        if(listKnowledge != null && !listKnowledge.isEmpty())
                        {
                            for(Knowledge__kav relatedArticle : listKnowledge)
                            {
                                listAutoSuggestModel.add(new AutoSuggestModel(relatedArticle.UrlName, relatedArticle.WT_Question__c, relatedArticle.Id, relatedArticle.WT_Answer__c, relatedArticle.WT_Knowledge_Category__r.Name, isSandbox));
                            }
                        }
                        else
                        {
                        	listAutoSuggestModel.add(new AutoSuggestModel(null, 'No search results found', null, null, null, isSandbox));
                        }
                    }
                    else
                    {
                        if(listAutoSuggestModel == null || listAutoSuggestModel.isEmpty())
                        {
                        	listAutoSuggestModel.add(new AutoSuggestModel(null, 'No search results found', null, null, null, isSandbox));
                        }
                    }
                }
                else
                {
                    if(listAutoSuggestModel == null || listAutoSuggestModel.isEmpty())
                    {
                        listAutoSuggestModel.add(new AutoSuggestModel(null, 'No search results found', null, null, null, isSandbox));
                    }
                }
            }
        }
        responseModel.ListAutoSuggest = listAutoSuggestModel;

        return responseModel;
    }

    public static List<AutoSuggestModel> GetAutoSuggestRecords(String searchTerm, Boolean isSandbox, Integer maxSearchResult, Set<String> setStopKeyword)
    {
        List<AutoSuggestModel> listAutoSuggestModel = new List<AutoSuggestModel>();
        
        if(String.isNotBlank(searchTerm))
        {
            Set<String> setSearchTerm = GetStringToSetOfStringForGreaterThanSingleCharacter(searchTerm);
            if(setStopKeyword != null && !setStopKeyword.isEmpty() && setSearchTerm != null && !setSearchTerm.isEmpty())
            {
                for(String stopKeyword : setStopKeyword)
                {
                    if(setSearchTerm.contains(stopKeyword))
                    {
                        setSearchTerm.remove(stopKeyword);
                    }
                }
            }
            
            String stringToSearch = GetSoslSearchTermFromSetString(setSearchTerm);
            
            List<List<sObject>> listOfListAutoSuggest = [FIND :stringToSearch
                                                         IN ALL FIELDS
                                                         RETURNING WT_Knowledge_Auto_Suggest__c(Id, 
                                                                                                WT_Auto_Suggest_Text__c, 
                                                                                                WT_Knowledge__c, 
                                                                                                WT_Knowledge_URL__c
                                                                                                WHERE WT_Knowledge_Status__c = 'Online')
                                                         LIMIT :maxSearchResult];
            if(listOfListAutoSuggest != null && !listOfListAutoSuggest.isEmpty())
            {
                List<WT_Knowledge_Auto_Suggest__c> listAutoSuggest = listOfListAutoSuggest[0];
                if(listAutoSuggest != null && !listAutoSuggest.isEmpty())
                {
                    for(WT_Knowledge_Auto_Suggest__c relatedAutoSuggest : listAutoSuggest)
                    {
                        listAutoSuggestModel.add(new AutoSuggestModel(relatedAutoSuggest.WT_Knowledge_URL__c, relatedAutoSuggest.WT_Auto_Suggest_Text__c, relatedAutoSuggest.WT_Knowledge__c, null, null, isSandbox));
                    }
                }
            }
        }

        return listAutoSuggestModel;
    }

    public static Set<String> GetMisspellings(Set<String> setSearchTerm)
    {
        Id misspellingRecordTypeId = Schema.SObjectType.WT_Knowledge_Keyword_Group__c.getRecordTypeInfosByDeveloperName().get('WT_Misspellings').getRecordTypeId();
        Set<String> setCorrectSpelling = new Set<String>();

        if(setSearchTerm != null && !setSearchTerm.isEmpty())
        {
            String stringToSearch = '';
            if(setSearchTerm.size() == 1)
            {
                stringToSearch = new List<String>(setSearchTerm)[0];
                stringToSearch += '*';
            }
            else
            {
                stringToSearch = GetSoslSearchTermFromSetString(setSearchTerm);    
            }
            
            List<List<sObject>> listOfListKeyword = [FIND :stringToSearch
                                                    IN ALL FIELDS
                                                    RETURNING WT_Knowledge_Keyword_Group__c(Id, 
                                                                                            RecordTypeId, 
                                                                                            WT_Correctly_Spelled_Keyword__c
                                                                                            WHERE RecordTypeId = :misspellingRecordTypeId
                                                                                            AND WT_Correctly_Spelled_Keyword__c != null)];

            if(listOfListKeyword != null && !listOfListKeyword.isEmpty())
            {
                List<WT_Knowledge_Keyword_Group__c> listKeywordGroup = listOfListKeyword[0];
                if(listKeywordGroup != null && !listKeywordGroup.isEmpty())
                {
                    for(WT_Knowledge_Keyword_Group__c relatedKeywordGroup : listKeywordGroup)
                    {
                        if(String.isNotBlank(relatedKeywordGroup.WT_Correctly_Spelled_Keyword__c))
                        {
                            setCorrectSpelling.add(relatedKeywordGroup.WT_Correctly_Spelled_Keyword__c);
                        }
                    }
                }
            }
        }

        return setCorrectSpelling;
    }

    public static Set<String> GetHypernyms(Set<String> setSearchTerm)
    {
        Id hypernymRecordTypeId = Schema.SObjectType.WT_Knowledge_Keyword_Group__c.getRecordTypeInfosByDeveloperName().get('WT_Hypernyms').getRecordTypeId();
        Set<String> setHypernym = new Set<String>();

        if(setSearchTerm != null && !setSearchTerm.isEmpty())
        {
            String stringToSearch = '';
            if(setSearchTerm.size() == 1)
            {
                stringToSearch = new List<String>(setSearchTerm)[0];
                stringToSearch += '*';
            }
            else
            {
                stringToSearch = GetSoslSearchTermFromSetString(setSearchTerm);    
            }
            
            List<List<sObject>> listOfListKeyword = [FIND :stringToSearch
                                                    IN ALL FIELDS
                                                    RETURNING WT_Knowledge_Keyword_Group__c(Id, RecordTypeId, 
                                                                                            WT_Hypernym_1__c, WT_Hypernym_2__c, WT_Hypernym_3__c, WT_Hypernym_4__c,
                                                                                            WT_Hypernym_5__c, WT_Hypernym_6__c, WT_Hypernym_7__c, WT_Hypernym_8__c,
                                                                                            WT_Hypernym_9__c, WT_Hypernym_10__c, WT_Correctly_Spelled_Keyword__c
                                                                                            WHERE RecordTypeId = :hypernymRecordTypeId)];

            if(listOfListKeyword != null && !listOfListKeyword.isEmpty())
            {
                List<WT_Knowledge_Keyword_Group__c> listKeywordGroup = listOfListKeyword[0];
                if(listKeywordGroup != null && !listKeywordGroup.isEmpty())
                {
                    for(WT_Knowledge_Keyword_Group__c relatedKeywordGroup : listKeywordGroup)
                    {
                        Set<String> setTemporaryHypernym = GetSetOfHypernym(relatedKeywordGroup);
                        if(setTemporaryHypernym != null && !setTemporaryHypernym.isEmpty())
                        {
                            setHypernym.addAll(setTemporaryHypernym);
                        }
                    }
                }
            }
        }

        return setHypernym;
    }
    
    public static Set<String> GetStopWords(Set<String> setSearchTerm)
    {
        Set<String> setStopKeyword = new Set<String>();
        Id stopWordsRecordTypeId = Schema.SObjectType.WT_Knowledge_Keyword_Group__c.getRecordTypeInfosByDeveloperName().get('WT_Stop_Words').getRecordTypeId();
        for(WT_Knowledge_Keyword_Group__c stopKeyword : [SELECT Id,
                                                        WT_Stop_Word__c
                                                        FROM WT_Knowledge_Keyword_Group__c
                                                        WHERE RecordTypeId = :stopWordsRecordTypeId
                                                        AND WT_Stop_Word__c IN :setSearchTerm])
        {
            setStopKeyword.add(stopKeyword.WT_Stop_Word__c);
        }
        
        return setStopKeyword;
    }

    public static Set<String> GetSynonyms(Set<String> setSearchTerm)
    {
        Id synonymRecordTypeId = Schema.SObjectType.WT_Knowledge_Keyword_Group__c.getRecordTypeInfosByDeveloperName().get('WT_Synonyms').getRecordTypeId();
        Set<String> setSynonym = new Set<String>();

        if(setSearchTerm != null && !setSearchTerm.isEmpty())
        {
            String stringToSearch = '';
            if(setSearchTerm.size() == 1)
            {
                stringToSearch = new List<String>(setSearchTerm)[0];
                stringToSearch += '*';
            }
            else
            {
                stringToSearch = GetSoslSearchTermFromSetString(setSearchTerm);    
            }
            
            List<List<sObject>> listOfListKeyword = [FIND :stringToSearch
                                                    IN ALL FIELDS
                                                    RETURNING WT_Knowledge_Keyword_Group__c(Id, RecordTypeId, WT_Synonym_1__c, WT_Synonym_2__c, WT_Synonym_3__c,
                                                                                            WT_Synonym_4__c, WT_Synonym_5__c, WT_Synonym_6__c,
                                                                                            WT_Synonym_7__c, WT_Synonym_8__c, WT_Synonym_9__c, WT_Synonym_10__c
                                                                                            WHERE RecordTypeId = :synonymRecordTypeId)];

            if(listOfListKeyword != null && !listOfListKeyword.isEmpty())
            {
                List<WT_Knowledge_Keyword_Group__c> listKeywordGroup = listOfListKeyword[0];
                if(listKeywordGroup != null && !listKeywordGroup.isEmpty())
                {
                    for(WT_Knowledge_Keyword_Group__c relatedKeywordGroup : listKeywordGroup)
                    {
                        Set<String> setTemporarySynonym = GetSetOfSynonym(relatedKeywordGroup);
                        if(setTemporarySynonym != null && !setTemporarySynonym.isEmpty())
                        {
                            setSynonym.addAll(setTemporarySynonym);
                        }
                    }
                }
            }
        }

        return setSynonym;
    }

    public static Set<String> GetSetOfSynonym(WT_Knowledge_Keyword_Group__c relatedSynonymGroup)
    {
        Set<String> setSynonymToReturn = new Set<String>();
        if(String.isNotBlank(relatedSynonymGroup.WT_Synonym_1__c))
        {
            setSynonymToReturn.add(relatedSynonymGroup.WT_Synonym_1__c);
        }
        if(String.isNotBlank(relatedSynonymGroup.WT_Synonym_2__c))
        {
            setSynonymToReturn.add(relatedSynonymGroup.WT_Synonym_2__c);
        }
        if(String.isNotBlank(relatedSynonymGroup.WT_Synonym_3__c))
        {
            setSynonymToReturn.add(relatedSynonymGroup.WT_Synonym_3__c);
        }
        if(String.isNotBlank(relatedSynonymGroup.WT_Synonym_4__c))
        {
            setSynonymToReturn.add(relatedSynonymGroup.WT_Synonym_4__c);
        }
        if(String.isNotBlank(relatedSynonymGroup.WT_Synonym_5__c))
        {
            setSynonymToReturn.add(relatedSynonymGroup.WT_Synonym_5__c);
        }
        if(String.isNotBlank(relatedSynonymGroup.WT_Synonym_6__c))
        {
            setSynonymToReturn.add(relatedSynonymGroup.WT_Synonym_6__c);
        }
        if(String.isNotBlank(relatedSynonymGroup.WT_Synonym_7__c))
        {
            setSynonymToReturn.add(relatedSynonymGroup.WT_Synonym_7__c);
        }
        if(String.isNotBlank(relatedSynonymGroup.WT_Synonym_8__c))
        {
            setSynonymToReturn.add(relatedSynonymGroup.WT_Synonym_8__c);
        }
        if(String.isNotBlank(relatedSynonymGroup.WT_Synonym_9__c))
        {
            setSynonymToReturn.add(relatedSynonymGroup.WT_Synonym_9__c);
        }
        if(String.isNotBlank(relatedSynonymGroup.WT_Synonym_10__c))
        {
            setSynonymToReturn.add(relatedSynonymGroup.WT_Synonym_10__c);
        }

        return setSynonymToReturn;
    }

    public static Set<String> GetSetOfHypernym(WT_Knowledge_Keyword_Group__c relatedHypernymGroup)
    {
        Set<String> setHypernymToReturn = new Set<String>();
        if(String.isNotBlank(relatedHypernymGroup.WT_Hypernym_1__c))
        {
            setHypernymToReturn.add(relatedHypernymGroup.WT_Hypernym_1__c);
        }
        if(String.isNotBlank(relatedHypernymGroup.WT_Hypernym_2__c))
        {
            setHypernymToReturn.add(relatedHypernymGroup.WT_Hypernym_2__c);
        }
        if(String.isNotBlank(relatedHypernymGroup.WT_Hypernym_3__c))
        {
            setHypernymToReturn.add(relatedHypernymGroup.WT_Hypernym_3__c);
        }
        if(String.isNotBlank(relatedHypernymGroup.WT_Hypernym_4__c))
        {
            setHypernymToReturn.add(relatedHypernymGroup.WT_Hypernym_4__c);
        }
        if(String.isNotBlank(relatedHypernymGroup.WT_Hypernym_5__c))
        {
            setHypernymToReturn.add(relatedHypernymGroup.WT_Hypernym_5__c);
        }
        if(String.isNotBlank(relatedHypernymGroup.WT_Hypernym_6__c))
        {
            setHypernymToReturn.add(relatedHypernymGroup.WT_Hypernym_6__c);
        }
        if(String.isNotBlank(relatedHypernymGroup.WT_Hypernym_7__c))
        {
            setHypernymToReturn.add(relatedHypernymGroup.WT_Hypernym_7__c);
        }
        if(String.isNotBlank(relatedHypernymGroup.WT_Hypernym_8__c))
        {
            setHypernymToReturn.add(relatedHypernymGroup.WT_Hypernym_8__c);
        }
        if(String.isNotBlank(relatedHypernymGroup.WT_Hypernym_9__c))
        {
            setHypernymToReturn.add(relatedHypernymGroup.WT_Hypernym_9__c);
        }
        if(String.isNotBlank(relatedHypernymGroup.WT_Hypernym_10__c))
        {
            setHypernymToReturn.add(relatedHypernymGroup.WT_Hypernym_10__c);
        }

        return setHypernymToReturn;
    }

    public static Set<String> GetStringToSetOfStringForGreaterThanSingleCharacter(String stringToConvert)
    {
        Set<String> setStringToReturn = new Set<String>();
        if(String.isNotBlank(stringToConvert))
        {
            List<String> listString = stringToConvert.split(' ');
            if(listString != null && !listString.isEmpty())
            {
                for(String stringItem : listString)
                {
                    if(stringItem.length() > 1)
                    {
                 		setStringToReturn.add(stringItem);   
                    }
                }
            }
        }

        return setStringToReturn;
    }
    
    public static Set<String> GetStringToSetOfString(String stringToConvert)
    {
        Set<String> setStringToReturn = new Set<String>();
        if(String.isNotBlank(stringToConvert))
        {
            List<String> listString = stringToConvert.split(' ');
            if(listString != null && !listString.isEmpty())
            {
                setStringToReturn.addAll(listString);
            }
        }

        return setStringToReturn;
    }

    public static String GetSoslSearchTermFromSetString(Set<String> setSearchTerm)
    {
        String searchToReturn = '';
        if(setSearchTerm != null && !setSearchTerm.isEmpty())
        {
            searchToReturn += '{';
            Boolean isFirstIteration = true;
            for(String searchTerm : setSearchTerm)
            {
                if(!isFirstIteration)
                {
                    searchToReturn += ' OR ' + searchTerm;
                }
                else
                {
                    searchToReturn += searchTerm;
                }
                isFirstIteration = false;
            }
            searchToReturn += '}';
        }

        return searchToReturn;
    }

    public class AutoSuggestResponseModel
    {
        @AuraEnabled public Boolean IsSuccess;
        @AuraEnabled public Boolean IsSandbox;
        @AuraEnabled public List<AutoSuggestModel> ListAutoSuggest;
    }

    public class AutoSuggestModel
    {
        @AuraEnabled public String RedirectUrl;
        @AuraEnabled public String ArticleTitle;
        @AuraEnabled public Id ArticleId;
        @AuraEnabled public String ArticleAnswer;
        @AuraEnabled public String ArticleCategoryName;

        public AutoSuggestModel(String url, String articleTitle, Id articleId, String answer, String articleCategoryName, Boolean isSandbox)
        {
            if(String.isNotBlank(url))
            {
                if(isSandbox)
                {
                    this.RedirectUrl = '/s/article/' + url;
                }
                else
                {
                    this.RedirectUrl = '/s/article/' + url;  
                }
            }
            this.ArticleTitle = (String.isNotBlank(articleTitle)) ? articleTitle.unescapeHtml4() : '';
            this.ArticleId = articleId;
            if(String.isNotBlank(answer))
            {
                if(answer.length() >= 450)
                {
                    this.ArticleAnswer = answer.substring(0, 450).unescapeHtml4() + '...';
                }
                else
                {
                    this.ArticleAnswer = answer.unescapeHtml4();
                }
                
                this.ArticleAnswer = this.ArticleAnswer.replaceAll('<br>', ' ');
            }
            this.ArticleCategoryName = articleCategoryName;
        }
    }
    
    public class TrendingTopicResponseModel
    {
        @AuraEnabled public String TopicName;
        @AuraEnabled public Integer ItemKey;
        @AuraEnabled public String RedirectUrl;
    }
}