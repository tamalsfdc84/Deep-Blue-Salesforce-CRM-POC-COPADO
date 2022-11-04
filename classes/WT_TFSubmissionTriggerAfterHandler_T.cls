@isTest
public class WT_TFSubmissionTriggerAfterHandler_T 
{
    @isTest
    static void TestInsert()
    {
        Test.startTest();
        tffa__Submission__c newSubmission = new tffa__Submission__c();
        newSubmission.tffa__Brand__c = '100';
        newSubmission.CZGoogleClickID__c = 'testgclid';
        insert newSubmission;
        
        List<Opportunity> listOpportunity = [SELECT Id, GCLID__c
                                             FROM Opportunity];
        
        System.assertEquals('testgclid', listOpportunity[0].GCLID__c);
        Test.stopTest();
    }
    
    @isTest
    static void TestLostUpdate()
    {
        Test.startTest();
        tffa__Submission__c newSubmission = new tffa__Submission__c();
        newSubmission.tffa__Brand__c = '100';
        newSubmission.CZGoogleClickID__c = 'testgclid';
        insert newSubmission;
        
        newSubmission.tffa__Status__c = 'ABANDONED';
        update newSubmission;
        
        List<Opportunity> listOpportunity = [SELECT Id, GCLID__c, StageName
                                             FROM Opportunity];
        
        System.assertEquals('Stage 7 - Deal Lost or Declined', listOpportunity[0].StageName);
        Test.stopTest();
    }
    
    @isTest
    static void TestWonUpdate()
    {
        Test.startTest();
        tffa__Submission__c newSubmission = new tffa__Submission__c();
        newSubmission.tffa__Brand__c = '100';
        newSubmission.CZGoogleClickID__c = 'testgclid';
        insert newSubmission;
        
        newSubmission.tffa__Status__c = 'COMPLETED';
        update newSubmission;
        
        List<Opportunity> listOpportunity = [SELECT Id, GCLID__c, StageName
                                             FROM Opportunity];
        
        System.assertEquals('Stage 6 - Deal Booked/Closed', listOpportunity[0].StageName);
        Test.stopTest();
    }
}