/**
* --------------------------------------------------------------------------------------------------------------
* @Name             WT_OpportunityPageController
* @Author           Venkat Somireddy <vsomireddy@wintrust.com>
* @Version          v1.0
* @CreatedDate      06-15-2022
* @UsedBy           wT_OpportunityPage LWC Component
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is controller class is used in wT_OpportunityPage LWC Component.
* --------------------------------------------------------------------------------------------------------------
* @Changes
* vx.x				<user id>
* MM-DD-YYYY		<Explanation> 
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
// Test class: WT_OpportunityPageController_T
public without sharing class WT_OpportunityPageController {   
    /**
    *-----------------------------------------------------------------------------------------------------------------------------
    * @description
    * This method is used to get Opportunity details based on recordId.
    *-----------------------------------------------------------------------------------------------------------------------------
    **/ 
        @AuraEnabled
        public static Opportunity returnOpportunityDetails(String opportunityId)
        { 
            Opportunity relatedOpportunity = null;
            DescribeSObjectResult describeResult = Opportunity.getSObjectType().getDescribe();
            List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
            String stringQuery = 'SELECT ' + String.join( fieldNames, ',' ) +
                                    ' FROM ' +
                                    describeResult.getName() +
                                    ' WHERE ' +
                                    ' Id =: opportunityId';
    
            List<Opportunity> listOpportunity = Database.query(stringQuery);
            if(listOpportunity != null && !listOpportunity.isEmpty())
            {
                relatedOpportunity = listOpportunity[0];
            }        
            return relatedOpportunity;
        }
    /**
    *-----------------------------------------------------------------------------------------------------------------------------
    * @description
    * This method is used to check If User has Opportunity Edit Access or not.
    *-----------------------------------------------------------------------------------------------------------------------------
    **/ 
        @AuraEnabled
        public static Boolean checkOpportunityEditAccess(String opportunityId)
        {       
            Boolean opportunityEditAccess = false;
            UserRecordAccess userRecordAccess = [SELECT HasEditAccess,RecordId 
                                                FROM UserRecordAccess 
                                                WHERE RecordId =: opportunityId AND UserId =: UserInfo.getUserId()];                                                
            if(userRecordAccess != null)
            {           
                opportunityEditAccess = userRecordAccess.HasEditAccess;            
            }     
            return opportunityEditAccess;
        }        
    }