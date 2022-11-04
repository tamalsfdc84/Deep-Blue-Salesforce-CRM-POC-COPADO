/**
* ----------------------------------------------------------------------------------------------------------------------
* @Name				WT_OpportunityTeamMemberBeforeHandler_T
* @Author			Karan Jugtawat		<KSinghJu@Wintrust.com>
* @Version			v1.0
* @CreatedDate		18-FEB-2021
* ---------------------------------------------------------------------------------------------------------------------
* @Description
* This is test class for before handler class for WT_OpportunityTeamMemberTriggerHandler.
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* FUNCTIONAL TEST LOGIC
* testMethod1()
* 	> to Check for validation on opportunity Team it should block the user to be added as a team member if the users Line of business(User Field) matches the line of business of an existing team member
----------------------------------------------------------------
**/
@isTest
public class WT_OpportunityTeamMemberBeforeHandler_T 
{
    @isTest
    public static void testMethod1()
    {
        WT_Switch_Settings__c switchRecord = new WT_Switch_Settings__c();
        switchRecord.WT_Is_Process_Builder_Active__c=true;
        switchRecord.WT_Is_Trigger_Active__c=true;
        switchRecord.WT_Is_Validation_Rule_Active__c=true;
        switchRecord.WT_Is_Workflow_Rule_Active__c=true;
        insert switchRecord;
        
        Account accountRecord = New Account();
        accountRecord.FirstName = 'First NameA';
        accountRecord.LastName = 'Last NameA';
        accountRecord.BillingStreet = 'TestA';
        accountRecord.BillingState = 'Illinois';
        accountRecord.BillingCity = 'Chicago';
        accountRecord.BillingCountry = 'United States';
        accountRecord.BillingPostalCode = '12345';
        accountRecord.Phone = '1122334455';
        accountRecord.ownerid = userInfo.getUserId();
        insert accountRecord;
        
        Product2 product1= new Product2();
        product1.Name= 'Testing ServicesA';
        product1.Family= 'TM';
        product1.IsActive= True;
        insert product1;
        
        Opportunity varOpportunity = new Opportunity();
        varOpportunity.name = 'Test Name One';
        varOpportunity.AccountId = accountRecord.Id;
        varOpportunity.WT_Product_for_Flow__c = product1.Id;
        varOpportunity.StageName = 'Stage 1 - Opportunity Identified';
        varOpportunity.CloseDate = Date.newInstance(2021, 12, 31);
        insert varOpportunity;
        
        Id varProfileID =  [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        List<User> listUser = new List<User>();
        for(Integer i =0 ; i<=5 ; i++)
        {
            listUser.add
                (
                    new User(
                        ProfileId = varProfileID,
                        LastName = 'lastName'+ i ,
                        Email = 'UserName'+i+'@wintrustwealth.com',
                        Username = 'UserName'+i+'@TestMethod.com',
                        Title = 'title',
                        Alias = 'alias',
                        TimeZoneSidKey = 'America/Los_Angeles',
                        EmailEncodingKey = 'UTF-8',
                        LanguageLocaleKey = 'en_US',
                        LocaleSidKey = 'en_US',
                        WT_Line_of_Business__c = 'Agricultural Lending'
                    )
                );
        }
        insert listUser;
        
        OpportunityTeamMember otm1= new OpportunityTeamMember
            (
                OpportunityAccessLevel = 'Read',
                UserId = listUser.get(0).id,
                TeamMemberRole = 'Product Partner',
                OpportunityId = varOpportunity.id
            );
        try
        {
            insert otm1;
        }
        catch(Exception error)
        {
            system.assert(error.getMessage().contains('Product Partners should have their access set to Read/Write'));
        }
        
        OpportunityTeamMember otm2= new OpportunityTeamMember
            (
                OpportunityAccessLevel = 'Edit',
                UserId = listUser.get(1).id,
                TeamMemberRole = 'Share Credit',
                OpportunityId = varOpportunity.id
            );
        
        try{
            insert otm2;
        }
        catch(Exception error)
        {
            system.assert(error.getMessage().contains('Shared Credit users should have their access set to Read Only'));
        }
        
        OpportunityTeamMember otm3= new OpportunityTeamMember
            (
                OpportunityAccessLevel = 'Edit',
                UserId = listUser.get(0).id,
                TeamMemberRole = 'Product Partner',
                OpportunityId = varOpportunity.id
            );
        insert otm3;
        OpportunityTeamMember otm4= new OpportunityTeamMember
            (
                OpportunityAccessLevel = 'Read',
                UserId = listUser.get(1).id,
                TeamMemberRole = 'Share Credit',
                OpportunityId = varOpportunity.id
            );
        insert otm4;
        otm4.TeamMemberRole = 'Product Partner';
        otm4.OpportunityAccessLevel = 'Edit';
        try
        {
            update otm4;
        }
        catch(Exception error)
        {
            system.assert(error.getMessage().contains('Only one product partner can be added per opportunity'));
        }
        OpportunityTeamMember otm5= new OpportunityTeamMember
            (
                OpportunityAccessLevel = 'Edit',
                UserId = listUser.get(1).id,
                TeamMemberRole = 'Product Partner',
                OpportunityId = varOpportunity.id
            );
        try
        {
            insert otm5;
        }
        catch(Exception error)
        {
            system.assert(error.getMessage().contains('Only one product partner can be added per opportunity'));
        }
    }
}