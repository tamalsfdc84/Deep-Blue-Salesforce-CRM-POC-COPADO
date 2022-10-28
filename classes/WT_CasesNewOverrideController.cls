/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name         WT_CasesNewOverrideController
* @Author           Sivaranjani     <sivaranjani.d2@tcs.com.tcsdev> 
* @ModifiedBy       Sivaranjani     <sivaranjani.d2@tcs.com.tcsdev>
* @version          v1.0 
* @CreatedDate      11-24-2020
* @UsedBy           Aura component: WT_CasesNewOverride 
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* this is used as an controller class for WT_CasesNewOverride
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Changes
* v1.0              Swaminathan  <e.swaminathan@tcs.com.tcsdev>
* 02-02-2021        <Added prePopulate method for Dynamic Record type visibility> 
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
// Test class: WT_CasesNewOverrideController_T
public without Sharing class WT_CasesNewOverrideController 
{  
    /**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Description
* function returns the current logged in user details 
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @param --- no input parameter
* @return -- returns the logged in user record
* -------------------------------------------------------------------------------------------------------------------------------------------------
**/
    @AuraEnabled
    public static user fetchUser()
    {         
        User userRecord = [select id,Name,Email,Phone,UserRole.Name,Profile.Name FROM User Where id =: userInfo.getUserId()];
        return userRecord;
    }
    /**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Description
* function returns the selected user details 
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @param --- the changed user or the currently selected requester's user id 
* @return -- returns user record
* -------------------------------------------------------------------------------------------------------------------------------------------------
**/
    @AuraEnabled
    public static user fetchChangedUser(String userRecordParameter)
    {
        User userRecord = [select id,Name,Email,Phone FROM User Where id =: userRecordParameter];   
        return userRecord;
    }
    /**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Description
* accepts the record type nme selected on the UI and retruns the record type id  
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @param --- record type name for case object
* @return -- returns the record type id 
* -------------------------------------------------------------------------------------------------------------------------------------------------
**/
    @AuraEnabled
    public static String fetchRecordTypeID(String recordTypeName)
    {
        RecordType recordType = [select id,Name FROM recordType Where Name =: recordTypeName and SobjectType = 'Case'];
        return recordType.id;
    }
    /**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Description
* functions returns the record type info 
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @param --- no input parameter
* @return -- returns map of the record type info
* -------------------------------------------------------------------------------------------------------------------------------------------------
**/   
    @AuraEnabled
    public static Map<String,Id> getRecordTypeDetails()
    {     
        List<Schema.RecordTypeInfo> listRecordType = Case.SObjectType.getDescribe().getRecordTypeInfos();
        Map<String ,Id> mapRecordType = new Map<String ,Id>();         
        for(Schema.RecordTypeInfo recordType : listRecordType )
        {
            if(recordType.isAvailable() && recordType.Name != 'Master')
            {
                mapRecordType.put(recordType.Name,recordType.getRecordTypeId());
            }
        }
        system.debug('record type:'+mapRecordType);
        return mapRecordType;
    }
    /**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Description
* used to populate the mailing address of the account selected on the CCPA layout  
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @param --- selected account record id
* @return -- returns the concatenated address string
* -------------------------------------------------------------------------------------------------------------------------------------------------
**/
    @AuraEnabled
    public static String fetchMailingAddress(String accountRecordID)
    {
        Account accountRecord = [select id,billingstreet,billingcity,billingstate,billingPostalCode,BillingCountry from account where id=: accountRecordID];
        string mailingAddress = accountRecord.billingstreet+ accountRecord.billingcity + accountRecord.billingstate + accountRecord.billingPostalCode+ accountRecord.BillingCountry;
        return mailingAddress;
    } 
    /**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Description
* used to run case assignment rule after creation of the Deposit Application record   
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @param --- created case record id
* @param --- record type , to verify if its deposit application 
* -------------------------------------------------------------------------------------------------------------------------------------------------
**/
    @AuraEnabled
    public static void runCaseAssignmentRule(String caseRecordID, String recordType)
    {	
        Case caseRecord = [select id, ownerid , WT_Requester_s_Name__c, CreatedById from case where id =: caseRecordID];
        if(recordType =='CCPA' )
        {
            AssignmentRule caseAssignmentRule = new AssignmentRule();
            caseAssignmentRule = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];       
            Database.DMLOptions dmlOpts = new Database.DMLOptions();
            dmlOpts.assignmentRuleHeader.assignmentRuleId= caseAssignmentRule.id;       
            caseRecord.setOptions(dmlOpts);
            update caseRecord;
        }
        caseShare caseRecordShare  = new caseShare();
        caseRecordShare.caseId = caseRecord.id;
        caseRecordShare.UserOrGroupId = caseRecord.CreatedById;
        caseRecordShare.caseAccessLevel = 'Read';
        caseRecordShare.RowCause = Schema.caseShare.RowCause.Manual;
        Database.SaveResult shareRecord = Database.insert(caseRecordShare,false);
        if(shareRecord.isSuccess()== false)
        {
            Database.Error error = shareRecord.getErrors()[0];
            System.debug(error.getStatusCode() + ': ' + error.getMessage());
        }
    }
    /**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Description
* used to populate resolution target date based on the request type selected    
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @param ---  request type string to find which date to populate 
* @param --- record type , to verify if its deposit application , ccpa
* @return -- returns the resolution target date 
* -------------------------------------------------------------------------------------------------------------------------------------------------
**/
    @AuraEnabled
    public static datetime calculateResolutionTarget(String requestValue, String recordType)
    {
        System.debug('requestValue=='+requestValue);
        DateTime reportDate;
        Datetime dateToday=System.now();
        list<WT_Request_Type_SLA__mdt> requestTypeSetting = [Select Record_Type__c, Request_Type__c, Hours__c from WT_Request_Type_SLA__mdt];
        map<string, decimal> depositApplicationMap = new map<string, decimal>();
        if(requestTypeSetting.size() > 0)
        {
            for(WT_Request_Type_SLA__mdt requestType:requestTypeSetting)
            {
                if(requestType.Record_Type__c == 'Deposit Application')
                {
                    depositApplicationMap.put(requestType.Request_Type__c, requestType.Hours__c);
                }
            }
        }
        if(recordType == 'Deposit Application')
        {
            if(depositApplicationMap.get(requestValue) != null)
            {
                reportDate = dateToday.addHours(Integer.valueOf(depositApplicationMap.get(requestValue)));
            }
        }
        if(recordType =='CCPA')
        {
            //reportDate= dateToday.addDays(45);
            Date TodaysDate = Date.valueOf(dateToday);
            reportDate=WT_CalculateSLAController.calculateWorkingDays(TodaysDate,45);
        }
        if(recordType =='Compliance Complaint')
        {
            if(requestValue=='Complex Issue')
            {
                reportDate= dateToday.addDays(20);
            }
            else {
                reportDate= dateToday.addDays(10);
            }
        }
        return reportDate;
    }
    /**  
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Description
* used to set report by date for compliance cases
* -------------------------------------------------------------------------------------------------------------------------------------------------
**/    
    @AuraEnabled
    public static datetime setReportByDate()
    {
        DateTime reportByDate = Date.Today().addDays(10);
        return reportByDate;
    }
    
    /**  
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Description
* used to set Account Name on Case Title field
* -------------------------------------------------------------------------------------------------------------------------------------------------
**/    
    @AuraEnabled
    public static String setCaseTitle(Id CustomerId)
    {
        Account accRecord=[Select id,Name from Account where Id=:CustomerId];
        return accRecord.Name;
    }
    
    @AuraEnabled
        public static Case fetchCase(Id caseRecordID)
    {	
        
        System.debug('caseRecordID=='+caseRecordID);
        Case caseRecord = [select id, Status from case where id =: caseRecordID];
        System.debug('caseRec=='+caseRecord);
        return caseRecord;
    }
    
     @AuraEnabled
        public static WT_Employee__c setEmployeeDetails(Id EmployeeID)
    {	
        
        WT_Employee__c employeeRecord= [SELECT Id, WT_Entity__c, WT_Bank__c,WT_Employee_ID__c,WT_First_Name__c, WT_Middle_Initial__c, WT_Last_Name__c, WT_Branch__c FROM WT_Employee__c where id =: employeeID];
        return employeeRecord;
    }
}