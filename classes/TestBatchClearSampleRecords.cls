//SGE 396 
//Tests: BatchClearSampleRecords
@isTest
private class TestBatchClearSampleRecords 
{
    @isTest static void testBatchWithAllSampleData()
    {
        //Initalize Variables 
        Date estimatedCloseDate = date.newInstance(2022, 8, 20); // Field Name: CloseDate
        String stage = 'Stage 4 - Deal Accepted/Commitment'; // FieldName: StageName
        String opportunityName;
       	List<Opportunity> FullSampleOpportunitiesList = new List<Opportunity>();
        
        //Loop generating List with 30 sample opportunities
        for(Integer i = 0; i<30; i++){
             opportunityName = 'Less Lucky Opportunity ' + i + '(Sample)';
             FullSampleOpportunitiesList.add(New Opportunity(Name = opportunityName, StageName = stage, CloseDate = estimatedCloseDate));
        }
        insert FullSampleOpportunitiesList;
        //Test
        Test.startTest();//Start Test
        BatchClearSampleRecords bd = new BatchClearSampleRecords();
        Id batchId = Database.executeBatch(bd);
        Test.stopTest();//Stop Test
        //Assertions
        System.assertEquals(0,[SELECT count() from Opportunity WHERE Name LIKE '%(Sample)']); //check if any sample data remains (checking using sample+wildcard)
        System.assertEquals(0,[SELECT count() from Opportunity WHERE Name LIKE 'Less Lucky Opportunity%']); //check if any sample data remains (checking using Less Lucky Oppertunity+wildcard)

    }
    @isTest static void testBatchWithSomeSampleData()
    {
        //Initalize Object Variables 
        Date estimatedCloseDate = date.newInstance(2022, 8, 20); // Field Name: CloseDate
        String stage = 'Stage 4 - Deal Accepted/Commitment'; // FieldName: StageName
        String opportunityName;
        List<Opportunity> PartialSampleOpportunitiesList = new List<Opportunity>();
        
        //Loop generating List with 15 sample & 15 non-sample opportunities 
        for(Integer i = 0; i<30; i++)  
        {
            if(i<15)
            {
                opportunityName = 'Less Lucky Opportunity ' + i + '(Sample)';
            }
            else
            {
             opportunityName = 'Lucky Opportunity ' + i ;   
            }
            PartialSampleOpportunitiesList.add(New Opportunity(Name = opportunityName, StageName = stage, CloseDate = estimatedCloseDate));
        }
        insert PartialSampleOpportunitiesList;
        
     	Test.startTest(); //Start Test
        BatchClearSampleRecords bd = new BatchClearSampleRecords();
        Id batchId = Database.executeBatch(bd);
        Test.stopTest();//Stop Test
        //Assertions
        System.assertEquals(0,[SELECT count() from Opportunity WHERE Name LIKE '%(Sample)']); //check if any sample data remains (checking using sample+wildcard)
        System.assertEquals(0,[SELECT count() from Opportunity WHERE Name LIKE 'Less Lucky Opportunity%']); //check if any sample data remains (checking using Less Lucky Oppertunity+wildcard)
        System.assertEquals(15,[SELECT count() from Opportunity WHERE Name LIKE 'Lucky Opportunity%']); // Check if non sample data remains
    }
    @isTest static void testBatchWithNoSampledata()
    {
        //Initalize Object Variables 
        Date estimatedCloseDate = date.newInstance(2022, 8, 20); // Field Name: CloseDate
        String stage = 'Stage 4 - Deal Accepted/Commitment'; // FieldName: StageName
        String opportunityName;
        List<Opportunity> noSampleOpportunitiesList = new List<Opportunity>();
        
        //Loop generating List with 15 sample & 15 non-sample opportunities 
        for(Integer i = 0; i<30; i++)  
        {
            opportunityName = 'Lucky Opportunity ' + i ;   
            noSampleOpportunitiesList.add(New Opportunity(Name = opportunityName, StageName = stage, CloseDate = estimatedCloseDate));
        }
        insert noSampleOpportunitiesList;
        //Test
        Test.startTest();//Start Test
        BatchClearSampleRecords bd = new BatchClearSampleRecords();
        Id batchId = Database.executeBatch(bd);
        Test.stopTest();//Stop Test
        System.assertEquals(30,[SELECT count() from Opportunity WHERE Name LIKE 'Lucky Opportunity%']); // Check if non sample data remains
    }
     @isTest static void testBatchWithNodata()
    {
        //Initalize Object Variables 
        List<Opportunity> emptyOpportunitiesList = new List<Opportunity>();
        //Test
        Test.startTest();//Start Test
        BatchClearSampleRecords bd = new BatchClearSampleRecords();
        Id batchId = Database.executeBatch(bd);
        Test.stopTest();//Stop Test
        System.assertEquals(0,[SELECT count() from Opportunity]); // Check if any data exists
    }
}