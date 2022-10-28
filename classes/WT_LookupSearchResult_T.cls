@isTest(isParallel=true)
public class WT_LookupSearchResult_T 
{
    @isTest
    static void compareTo_should_work_with_two_null_titles() 
    {
        WT_LookupSearchResult r1 = getSearchResult(null);
        WT_LookupSearchResult r2 = getSearchResult(null);

        Integer compareResult = r1.compareTo(r2);

        System.assertEquals(0, compareResult);
    }

    @isTest
    static void compareTo_should_work_with_this_null_title() 
    {
        WT_LookupSearchResult r1 = getSearchResult(null);
        WT_LookupSearchResult r2 = getSearchResult('a');

        Integer compareResult = r1.compareTo(r2);

        System.assertEquals(1, compareResult);
    }

    @isTest
    static void compareTo_should_work_with_other_null_title() 
    {
        WT_LookupSearchResult r1 = getSearchResult('a');
        WT_LookupSearchResult r2 = getSearchResult(null);

        Integer compareResult = r1.compareTo(r2);

        System.assertEquals(-1, compareResult);
    }

    @isTest
    static void compareTo_should_work_with_non_null_titles() 
    {
        WT_LookupSearchResult r1 = getSearchResult('a');
        WT_LookupSearchResult r2 = getSearchResult('b');

        Integer compareResult = r1.compareTo(r2);

        System.assertEquals(-1, compareResult);
    }

    @isTest
    static void getters_should_work() 
    {
        // For the sake of code coverage
        WT_LookupSearchResult r = new WT_LookupSearchResult('0010R00000yvEyRQAU', 'type', 'icon', 'title', 'subtitle');

        System.assertEquals('0010R00000yvEyRQAU', r.getId());
        System.assertEquals('type', r.getSObjectType());
        System.assertEquals('icon', r.getIcon());
        System.assertEquals('title', r.getTitle());
        System.assertEquals('subtitle', r.getSubtitle());
    }

    private static WT_LookupSearchResult getSearchResult(String title) 
    {
        return new WT_LookupSearchResult(null, null, null, title, null);
    }
}