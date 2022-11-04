public with sharing class WT_LookupController 
{
    private final static Integer MAX_RESULTS = 5;

    @AuraEnabled(cacheable=true scope='global')
    public static List<WT_LookupSearchResult> Search(String searchTerm, List<String> selectedIds, String queryName) 
    {
        List<WT_LookupSearchResult> listResult = new List<WT_LookupSearchResult>();
        searchTerm += '*';

        WT_Utility_Lookup_Record_Setting__mdt lookupRecordSetting = WT_Utility_Lookup_Record_Setting__mdt.getInstance(queryName);

        if(lookupRecordSetting != null)
        {
            String soslSearchString = 'FIND :searchTerm ' + 
                                        'IN ALL FIELDS ' + 
                                        'RETURNING ' +
                                        lookupRecordSetting.WT_Object_1_Query__c +
                                        ' LIMIT :MAX_RESULTS';

            List<List <sObject>> listOfListSearchResult = search.query(soslSearchString);

            String userIcon = lookupRecordSetting.WT_Object_1_Icon_Name__c;
            User[] listUser = (List<User>) listOfListSearchResult[0];
            for (User relatedUser : listUser) 
            {
                String subtitle = '';
                if(queryName == 'Opportunity_Team_Member_User')
                {
                    subtitle = '';
                }
                else
                {
                    subtitle = 'User • ' + relatedUser.WT_Operations_Role__c;
                }
                
                listResult.add(new WT_LookupSearchResult(relatedUser.Id, lookupRecordSetting.WT_Object_1_API_Name__c, userIcon, relatedUser.Name, subtitle));
            }

            listResult.sort();
        }

        return listResult;
    }

    @AuraEnabled(cacheable=true scope='global')
    public static List<WT_LookupSearchResult> GetRecentlyViewed(String queryName) 
    {
        WT_Utility_Lookup_Record_Setting__mdt lookupRecordSetting = WT_Utility_Lookup_Record_Setting__mdt.getInstance(queryName);
        List<WT_LookupSearchResult> listResult = new List<WT_LookupSearchResult>();

        List<RecentlyViewed> listRecentRecord = new List<RecentlyViewed>();
        
        if(queryName == 'Opportunity_Team_Member_User')
        {
            listRecentRecord = [SELECT Id, 
                                Name, 
                                Type,
                                IsActive
                                FROM RecentlyViewed
                                WHERE Type = 'User' AND IsActive = true
                                ORDER BY LastViewedDate DESC
                                LIMIT 5];
        }
        

        String userIcon = lookupRecordSetting.WT_Object_1_Icon_Name__c;
        for (RecentlyViewed recentRecord : listRecentRecord) 
        {            
            listResult.add(new WT_LookupSearchResult(recentRecord.Id, lookupRecordSetting.WT_Object_1_API_Name__c, userIcon, recentRecord.Name, ''));
        }
        return listResult;
    }
}