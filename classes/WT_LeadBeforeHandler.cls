/**
* --------------------------------------------------------------------------------------------------------------
* @Name             WT_LeadBeforeHandler
* @Author           Swaminathan E   <SEzhumal@wintrust.com>
* @ModifiedBy       Swaminathan E   <SEzhumal@wintrust.com>
* @Version          v1.0
* @CreatedDate      20-11-2020
* @UsedBy           Lead Object
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is handler class for Lead trigger.
* This handles all the before logic of the Lead trigger.
* --------------------------------------------------------------------------------------------------------------
* @Changes
* vX.X
* MM-DD-YYYY
* --------------------------------------------------------------------------------------------------------------
**/
// Code Coverage: WT_LeadBeforeHandler_T
public class WT_LeadBeforeHandler extends TriggerHandler
{
    List<Lead> listNewReferrals = new List<Lead>();
    Map<Id,Lead> mapOldReferral = new Map<Id,Lead>();
    Map<Id, List<UserRole>> mapUserRoleIdAndListUserRole = new Map<Id, List<UserRole>>();
    public WT_LeadBeforeHandler()
    { 
        listNewReferrals = (List<Lead>) Trigger.new;
        mapOldReferral = (Map<Id,Lead>)Trigger.oldMap;
    }
    public override void beforeInsert()
    {
        populateContactID(listNewReferrals);
        populateOwnerID(listNewReferrals);
        populateRelationshiproupId(listNewReferrals);
        SetReferredByMeOrTeam();
    }
    public override void beforeUpdate()
    {
        populateContactID(listNewReferrals);
        populateOwnerID(listNewReferrals);
        populateRelationshiproupId(listNewReferrals);
        SetReferredByMeOrTeam();
    }

/**
* --------------------------------------------------------------------------------------------------------------
* @Description
* This method is used to populate the Relationship Group ID for the Task linked to Business accounts
*
* --------------------------------------------------------------------------------------------------------------
* @Param  listNewReferrals    List of Referral
* @Return void                 Returns none
* --------------------------------------------------------------------------------------------------------------
**/
    public void populateRelationshiproupId(List<Lead> listNewReferrals)
    {
        Set<Id> setAccountId = new Set<Id>();
        Map<Id,Id> mapAccountId = new Map<Id,Id>();
        for(Lead leadRecord: listNewReferrals)
        {
            setAccountId.add(leadRecord.FinServ__RelatedAccount__c);  
        }
        List<WT_RelationshipGroup_Relation__c> listRelationRecord = [SELECT Id, WT_Account__c, WT_RelatedAccount__c FROM WT_RelationshipGroup_Relation__c WHERE WT_Active__c = true AND WT_RelatedAccount__c IN :setAccountId ];
        if (listRelationRecord.size() > 0)
        {
            for(WT_RelationshipGroup_Relation__c relation :listRelationRecord )
            {
                mapAccountId.put(relation.WT_RelatedAccount__c,relation.WT_Account__c);
            }
        }
        for(Lead leadRecord: listNewReferrals)
        {
            if(mapAccountId.containsKey(leadRecord.FinServ__RelatedAccount__c))
            {
                leadRecord.WT_Relationship_Group__c = mapAccountId.get(leadRecord.FinServ__RelatedAccount__c);
            }
            else
            {
                leadRecord.WT_Relationship_Group__c = Null; 
            }
        }
    } 
/**
*-----------------------------------------------------------------------------------------------------------------------------
* @Description
*This method Poulate the Contact Id based on Referred By field
*-----------------------------------------------------------------------------------------------------------------------------
* @Param    listNewReferrals   This contains list of Lead Records from beforeInsert Trigger
*-----------------------------------------------------------------------------------------------------------------------------
**/
    public void populateOwnerID(List<Lead> listNewReferrals)
    {
        for(Lead leadRecord: listNewReferrals)
        {
          if(leadRecord.WT_Referred_To__c != null)
          {
              leadRecord.OwnerId = leadRecord.WT_Referred_To__c;
          }
        }
    }   
/**
*-----------------------------------------------------------------------------------------------------------------------------
* @Description
*This method Poulate the Contact Id based on Referred By field
*-----------------------------------------------------------------------------------------------------------------------------
* @Param    listNewReferrals   This contains list of Lead Records from beforeInsert Trigger
*-----------------------------------------------------------------------------------------------------------------------------
**/
    public void populateContactID(List<Lead> listNewReferrals)
    {
        //update contactID on case based on the account id
        Set<String> setPersonAccountID = new Set<String>();
        for(Lead leadRecord: listNewReferrals)
        {
          if(leadRecord.FinServ__RelatedAccount__c != null)
          {
            setPersonAccountID.add(leadRecord.FinServ__RelatedAccount__c);  
          }
        }
        List<Contact> listContact = [select id, AccountID from Contact where AccountID IN: setPersonAccountID];
        Map<String,String> mapAccountContact = new Map<String,String>();
        for (Contact contactRecord: listContact)
        {
            if(contactRecord.AccountID != null)
            {
              mapAccountContact.put(contactRecord.AccountID,contactRecord.id); 
            }
        }
        for(Lead leadRecord: listNewReferrals)
        {
           leadRecord.FinServ__ReferredByContact__c = mapAccountContact.get(leadRecord.FinServ__RelatedAccount__c);
        }
    }
/*
* --------------------------------------------------------------------------------------------------------------
* @Description
* This method is used to update the "Referred by Me/My Team"
* The field will allow for a report/dashboard components to provide dynamic results based 
* on the individual viewing the report/dashboard or list filters
* @Param  listNewReferrals          List of Referral
* @Return void 
* Added by Vamshi Papisetty      06/14/2022   for SGE-96
* --------------------------------------------------------------------------------------------------------------
**/
    //verify Set by me or my team user role 
    public void SetReferredByMeOrTeam()
    { 
        //using context variable to minimize operations of SOQL for insert and update
        boolean isChanged = false;
        if(!listNewReferrals.isEmpty())
        {  
            if(mapOldReferral != null && !mapOldReferral.isEmpty() )
            {
                for(Lead leadRecord : listNewReferrals)
                {
                    if(mapOldReferral.containsKey(leadRecord.Id)) 
                    {         
                       if(mapOldReferral.get(leadRecord.Id).FinServ__ReferredByUser__c != leadRecord.FinServ__ReferredByUser__c || 
                           mapOldReferral.get(leadRecord.Id).ownerId != leadRecord.ownerId) 
                       {
                           isChanged = true;
                           break;
                       }
                    }
                }                
            }
            else
            {
               isChanged = true;                
            }         
            if(isChanged)
            {
                //preparing Map with Parent Role and SubRoles
                for (UserRole role : [SELECT Id,ParentRoleId FROM UserRole])
                  {
                       //Preparing Map of Parent Role as key and child roles as value
                       if (mapUserRoleIdAndListUserRole.containsKey(role.ParentRoleId))
                           {
                               mapUserRoleIdAndListUserRole.get(role.ParentRoleId).add(role);	
                           }
                           else
                           {
                               mapUserRoleIdAndListUserRole.put(role.ParentRoleId, new List<UserRole>{role});
                           }                               
                  } 
                  User currentUser = [Select Id, UserRoleId FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
                //Retreiving subordinates users for the current user(if it has any)
                Set<Id> setUserIdUnderCurrentUser = GetRoleSubordinateUsers(currentUser.UserRoleId);
                for(Lead leadRecord : listNewReferrals)
                {
                    if(leadRecord.FinServ__ReferredByUser__c == currentUser.Id)
                    {
                        leadRecord.WT_Referred_by_Me_My_Team__c = True;
 
                    }
                    else if(leadRecord.FinServ__ReferredByUser__c != null && !setUserIdUnderCurrentUser.isEmpty())
                    {   
                        if(setUserIdUnderCurrentUser.contains(leadRecord.FinServ__ReferredByUser__c))
                        {
                            leadRecord.WT_Referred_by_Me_My_Team__c = True;    
                        }
                        else
                        {
                            leadRecord.WT_Referred_by_Me_My_Team__c = False;
                        }
                    }
                    else
                    {
                        leadRecord.WT_Referred_by_Me_My_Team__c = False; 
                    }                
                } 
        	}
        }
    }    
    public Set<Id> GetRoleSubordinateUsers(Id userRoleId) 
    {  	  
        // get all of the roles underneath the user
        Set<Id> setChildUserRoleId = GetSubHierarchyExclusive(userRoleId);
        // get all of the ids for the users in those roles
        Map<Id,User> mapUserIdAndSubRoleId = new Map<Id, User>([Select Id, Name FROM User WHERE UserRoleId IN :setChildUserRoleId]);
        // return the ids 
          return mapUserIdAndSubRoleId.keySet();  	
    }          
    public Set<Id> GetSubHierarchyExclusive(Id userRoleId)
    {
        Set<Id> roleIds = new Set<Id>();
        List<UserRole> tempUserRoleList = mapUserRoleIdAndListUserRole.containsKey(userRoleId) ?  mapUserRoleIdAndListUserRole.get(userRoleId) : new List<UserRole>();
        for (UserRole childRole : tempUserRoleList)
        {
            roleIds.add(childRole.Id);
            roleIds.addAll(GetSubHierarchyExclusive(childRole.Id));
        }           
        return roleIds;
    }                     
}