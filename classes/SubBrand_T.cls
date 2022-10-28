@isTest
public class SubBrand_T 
{  
    @isTest(SeeAllData=true)
    public static void runGetPopulateSSNField()
    {                
		SubBrand__c brand = new SubBrand__c();
        brand = [SELECT Id, Name, ShowInEmail__c 
                FROM SubBrand__c 
                WHERE ExternalId__c = '167_Barrington Bank & Trust'];
        Test.startTest();
        brand.SortOrder__c = 1;
        update brand;
        brand.SortOrder__c = 0;
        update brand;
        Test.stopTest();       
    }
}