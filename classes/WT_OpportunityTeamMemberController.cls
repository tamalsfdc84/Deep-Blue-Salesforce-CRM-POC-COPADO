public without sharing class WT_OpportunityTeamMemberController 
{
    @AuraEnabled
    public static Boolean GetIsCurrentUserSmallBusinessOperationUser()
    {
        Boolean isSmallBusinessUser = false;
        Set<Id> setOperationsUserRoleId = new Set<Id>();
        Set<String> setUserRoleName = new Set<String>
        {
            'Small Business Operations',
            'Small Business Operations Closer (Employee)',
            'Small Business Operations Credit Analyst (Employee)',
            'Small Business Operations Processor And Closer Supervisor',
            'Small Business Operations Processor (Employee)'
        };
        for(UserRole userRoleToValidate : [SELECT Id
                                            FROM UserRole
                                            WHERE Name IN :setUserRoleName])
        {
            setOperationsUserRoleId.add(userRoleToValidate.Id);
        }

        if(setOperationsUserRoleId.contains(UserInfo.getUserRoleId()))
        {
            isSmallBusinessUser = true;
        }

        return isSmallBusinessUser;
    }

    @AuraEnabled
    public static Boolean AddOpportunityTeamMember(String opportunityId, String teamMemberRole, String userId, String opportunityAccessLevel)
    {
        Boolean isSuccess = false;
        try 
        {
            OpportunityTeamMember newTeamMember = new OpportunityTeamMember();
            newTeamMember.OpportunityId = opportunityId;
            newTeamMember.TeamMemberRole = teamMemberRole;
            newTeamMember.UserId = userId;
            newTeamMember.OpportunityAccessLevel = opportunityAccessLevel;

            insert newTeamMember;
            isSuccess = true;
        } 
        catch (Exception e) 
        {
            
        }

        return isSuccess;
    }

    @AuraEnabled
    public static List<OpportunityTeamMember> GetOpportunityTeamMember(String opportunityId)
    {
        return [SELECT Id,
                OpportunityId,
                TeamMemberRole,
                Name,
                OpportunityAccessLevel
                FROM OpportunityTeamMember
                WHERE OpportunityId = :opportunityId
                ORDER BY CreatedDate DESC];
    }

    @AuraEnabled
    public static Boolean DeleteOpportunityTeamMember(String opportunityTeamMemberId)
    {
        Boolean isSuccess = false;
        OpportunityTeamMember teamMemberToDelete = new OpportunityTeamMember();
        teamMemberToDelete.Id = opportunityTeamMemberId;

        try
        {
            delete teamMemberToDelete;
            isSuccess = true;
        }
        catch(Exception ex)
        {

        }

        return isSuccess;
    }
}