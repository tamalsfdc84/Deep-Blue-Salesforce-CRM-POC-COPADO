/**
* --------------------------------------------------------------------------------------------------------------
* @Name             WT_PowerBiEmbedManager
* @Author           Venkat Somireddy <vsomireddy@wintrust.com>
* @Version          v1.1
* @CreatedDate      09-02-2021
* @UsedBy           Power Bi Reports LWC Components
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is controller class is used to embed Power Bi Reports
* --------------------------------------------------------------------------------------------------------------
* @Changes
* @LastModifiedBy   Venkat Somireddy
* 03-19-2022 - Added new functionality for sending Role Name for CRE & MM Score Card Reports
* --------------------------------------------------------------------------------------------------------------
// Code Coverage: WT_PowerBiEmbedManager_T
**/
public with sharing class WT_PowerBiEmbedManager {
    /**
*-----------------------------------------------------------------------------------------------------------------------------
* @description
* This method is used to get User details based on User Id.
*-----------------------------------------------------------------------------------------------------------------------------
**/ 
    @AuraEnabled(cacheable=true)
    public static List<User> getUserDetails(String recordId) 
    {                     
        List<User> listUser = [SELECT Id, Name, WT_Line_of_Business__c, WT_MM_Scorecard_Access__c, WT_CRE_Scorecard_Access__c,
                                WT_MM_Scorecard_Team__c,WT_CRE_Scorecard_Team__c,WT_Charter__c 
                                FROM User  
                                WHERE Id = :recordId]; 
        return listUser;    
    }
    /**
*-----------------------------------------------------------------------------------------------------------------------------
* @description
* This method is used to get Power Bi all Report details from object WT_Power_BI_Report__c.
*-----------------------------------------------------------------------------------------------------------------------------
**/ 
    @AuraEnabled(cacheable=true)
    public static List<WT_Power_BI_Report__c> getPowerBIRereports() 
    {
        List<WT_Power_BI_Report__c> reportList = [SELECT Id, Name, WT_Workspace_ID__c, WT_Report_ID__c,
                                                  WT_Report_Type__c,WT_User_Filter__c  
                                                  FROM WT_Power_BI_Report__c ];                            
        return reportList;    
    }
    /**
*-----------------------------------------------------------------------------------------------------------------------------
* @description
* This method is used to get Power Bi Report details from object WT_Power_BI_Report__c based on Record Id.
*-----------------------------------------------------------------------------------------------------------------------------
**/ 
    @AuraEnabled(cacheable=true)
    public static RecordDetailResponse getPowerBIRecordDetails(String recordId) 
    {
        RecordDetailResponse currentRecordDetail = new RecordDetailResponse();
        currentRecordDetail.IsAccountRecord = false;
        String recordObjectName = '';
        
        if(String.isNotBlank(recordId))
        {
            recordObjectName = (Id.valueOf(recordId)).getSObjectType().getDescribe().getName();
        }        
        
        if(recordObjectName == 'Account')
        {
            currentRecordDetail.IsAccountRecord = true;
        }
        
        for(WT_Power_BI_Report__c currentReport : [SELECT Id, Name, WT_Workspace_ID__c, WT_Report_ID__c, WT_Report_Type__c,
                                                   WT_User_Filter__c, WT_CRE_ScoreCard__c, WT_MM_ScoreCard__c
                                                   FROM WT_Power_BI_Report__c  
                                                   WHERE Id = :recordId])
        {
            currentRecordDetail.PowerBiReportSalesforceId = currentReport.Id;
            currentRecordDetail.PowerBiReportName = currentReport.Name;
            currentRecordDetail.PowerBiReportWorkspaceId = currentReport.WT_Workspace_ID__c;
            currentRecordDetail.PowerBiReportId = currentReport.WT_Report_ID__c;
            currentRecordDetail.PowerBiReportType = currentReport.WT_Report_Type__c;
            currentRecordDetail.PowerBiReportUserFilter = currentReport.WT_User_Filter__c;
            currentRecordDetail.IsCreScorecard = currentReport.WT_CRE_ScoreCard__c;
            currentRecordDetail.IsMMScorecard = currentReport.WT_MM_ScoreCard__c;
        }
        return currentRecordDetail;    
    }   
    
    /**
*-----------------------------------------------------------------------------------------------------------------------------
* @description
* This method interacts with Azure AD to acquire an app-only access token.
*-----------------------------------------------------------------------------------------------------------------------------
**/ 
    public static String getPowerBiAccessToken() {
        
        // get auth settings from Custom Metadata Type reconrd
        WT_Power_BI_Settings__mdt authSetting = WT_Power_BI_Settings__mdt.getInstance('PowerBiApp');
        string TenantId = authSetting.WT_Tenant_ID__c;    
        string ClientId = authSetting.WT_Client_ID__c;    
        string ClientSecret = authSetting.WT_Client_Secret__c;        
        System.debug('TenantId: ' + TenantId);
        System.debug('ClientId: ' + ClientId);
        System.debug('ClientSecret: ' + ClientSecret);
        
        // construct URL for client credentials flow
        String aadTokenEndpoint = 'https://login.microsoftonline.com/' + TenantId + '/oauth2/v2.0/token';
        
        // prepare HTTP request 
        HttpRequest reqClientCredentialsFlow = new HttpRequest();
        reqClientCredentialsFlow.setMethod('POST');
        reqClientCredentialsFlow.setEndpoint(aadTokenEndpoint);        
        reqClientCredentialsFlow.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        
        // compose data for POST body
        ClientCredentialPostData postData = new ClientCredentialPostData();
        postData.client_id = ClientId;
        postData.client_info = '1';
        postData.client_secret = ClientSecret;
        postData.scope = 'https://analysis.windows.net/powerbi/api/.default';
        postData.grant_type = 'client_credentials';        
        String postBody = postData.getPostData();
        reqClientCredentialsFlow.setBody(postBody);
        
        // send HTTP POST to execute client credentials flow
        Http http = new Http();        
        HttpResponse response = http.send(reqClientCredentialsFlow);
        
        // extract and return app-only access token for service principal
        String responseJson = response.getBody();
        ClientCredentialResponse responseData = (ClientCredentialResponse)JSON.deserialize(responseJson, ClientCredentialResponse.class);
        String access_token = responseData.access_token;     
        return access_token;
    }

    @AuraEnabled
    public static PowerBiReportData getNonDefaultReportDataForEmbedding(String WorkspaceId, String ReportId, String ReportType,
                                                                        String UserFilter, String CREScoreCard, String MMScoreCard, Boolean isAccountRecord,
                                                                        Id recordId)
    {
        // get auth settings from Custom Metadata Type reconrd
        WT_Power_BI_Settings__mdt authSetting = WT_Power_BI_Settings__mdt.getInstance('PowerBiApp');
        
        string userName = authSetting.WT_User_Name__c;
        string roleName = null;
        string creScoreCardAccess = null;
        string mmScoreCardAccess = null;
        string creScoreCardTeam = null;
        string mmScoreCardTeam = null;
        
        // get access token for Authorization header
        String access_token = getPowerBiAccessToken();        
        //Get User Line Of Business , CRE Score Card & MM Score Card details
        List<User> userDetailsList =  getUserDetails(UserInfo.getUserId());
                
        // Call to Power BI Service API to get report data for embedding        
        HttpRequest reqGetReport = new HttpRequest();
        reqGetReport.setMethod('GET');
        String urlGetReport = 'https://api.powerbi.com/v1.0/myorg/groups/' + WorkspaceId + '/reports/' + ReportId;
        reqGetReport.setEndpoint(urlGetReport);
        reqGetReport.setHeader('Authorization', 'Bearer ' + access_token);
        
        Http http = new Http();
        HttpResponse response = http.send(reqGetReport);
        
        // check response for success
        if(response.getStatusCode() != 200)
        {
            PowerBiReportData getReportError = new PowerBiReportData();
            getReportError.error = 'Get Report Error: ' + response.getStatus();
            return getReportError;
        }            
        
        // extract Power BI report data from JSON response
        String responseJson = response.getBody();
        PowerBiReport powerBiReport = (PowerBiReport)JSON.deserialize(responseJson, PowerBiReport.class);
        
        // Call to Power BI Service API to get embed token for report        
        HttpRequest reqGetEmbedToken = new HttpRequest();
        reqGetEmbedToken.setMethod('POST');
        String urlGetEmbedToken = 'https://api.powerbi.com/v1.0/myorg/groups/' + WorkspaceId + '/reports/' + ReportId + '/GenerateToken';
        reqGetEmbedToken.setEndpoint(urlGetEmbedToken);
        reqGetEmbedToken.setHeader('Content-Type', 'application/json');
        reqGetEmbedToken.setHeader('Authorization', 'Bearer ' + access_token);
        
        String requestBody='';
        if(ReportType == 'PowerBI')
        {
            requestBody ='{"accessLevel": "View","identities":[{"username": "' + userName +'","datasets":["' + powerBiReport.datasetId + '"]}]}';   
        }
        else if(ReportType == 'SSRS')
        {
            requestBody ='{"accessLevel": "View", "datasetId": "' + powerBiReport.datasetId + '"}'; 
        }       
        reqGetEmbedToken.setBody(requestBody);
        Http http1 = new Http();
        HttpResponse responseEmbedToken = http1.send(reqGetEmbedToken);
        
        // check response for success
        if(responseEmbedToken.getStatusCode() != 200)
        {
            PowerBiReportData getEmbedTokenError = new PowerBiReportData();
            getEmbedTokenError.error = 'Body: ' + responseEmbedToken.getBody();
            getEmbedTokenError.error = getEmbedTokenError.error + ' Get Embed Token Error, Status:' + responseEmbedToken.getStatus()+' Status Code: ' + responseEmbedToken.getStatusCode();
            return getEmbedTokenError;            
        }          
        
        // extract Power BI embed token and expiration
        PowerBiEmbedToken embedToken = (PowerBiEmbedToken)JSON.deserialize(responseEmbedToken.getBody(), PowerBiEmbedToken.class);
        
        // create custom remote-able object to return to caller in browser 
        PowerBiReportData powerBiReportData = new PowerBiReportData();        
        powerBiReportData.workspaceId = WorkspaceId;
        powerBiReportData.reportId = ReportId;
        powerBiReportData.name = powerBiReport.name;
        powerBiReportData.embedUrl = powerBiReport.embedUrl;        
        if(isAccountRecord)
        {
            powerBiReportData.embedUrl = powerBiReport.embedUrl + '&rp:AcctID=' + recordId;        
        }
        
        powerBiReportData.embedToken = embedToken.token;
        powerBiReportData.embedTokenExpires = embedToken.expiration;                
        return powerBiReportData;  
    }

    /**
*-----------------------------------------------------------------------------------------------------------------------------
* @description
* This method used to retrieve the embedding data and the embed token for a specific report
*-----------------------------------------------------------------------------------------------------------------------------
**/ 
    @AuraEnabled(cacheable=true)
    public static PowerBiReportData getEmbeddingDataForReport(String WorkspaceId, String ReportId, String ReportType,
                                                                String UserFilter, String CREScoreCard, String MMScoreCard) 
    {    
        // get auth settings from Custom Metadata Type reconrd
        WT_Power_BI_Settings__mdt authSetting = WT_Power_BI_Settings__mdt.getInstance('PowerBiApp');
        
        string userName = authSetting.WT_User_Name__c; 
        string roleName =null;         
        string creScoreCardAccess =null;         
        string mmScoreCardAccess =null;     
        string creScoreCardTeam =null;         
        string mmScoreCardTeam =null;         
        
        System.debug('CREScoreCard: ' + CREScoreCard);
        System.debug('MMScoreCard: ' + MMScoreCard);
        
        // get access token for Authorization header
        String access_token = getPowerBiAccessToken();        
        //Get User Line Of Business , CRE Score Card & MM Score Card details
        List<User> userDetailsList =  getUserDetails(UserInfo.getUserId());
        //If CREScoreCard is Yes, append User Line of Business & CRE Score Card Access in RoleName
        if(CREScoreCard == 'true')
        {            
            for(User userDetails:userDetailsList)
            {                
                if(userDetails.WT_CRE_Scorecard_Team__c!=null)
                {
                    creScoreCardTeam=userDetails.WT_CRE_Scorecard_Team__c;
                }
                else
                {
                    creScoreCardTeam=userDetails.WT_Charter__c;
                }                
                if(userDetails.WT_CRE_Scorecard_Access__c!=null)
                {
                    creScoreCardAccess=userDetails.WT_CRE_Scorecard_Access__c;
                    roleName = 'CRE' +'-'+ userDetails.WT_CRE_Scorecard_Access__c;
                }
                if(userDetails.WT_Line_of_Business__c=='Business Administrator' || userDetails.WT_Line_of_Business__c=='IT Administrator')
                {                    
                    roleName = userDetails.WT_Line_of_Business__c;
                } 
            }            
        }
        //If MMScoreCard is Yes, append User Line of Business & MM Score Card Access in RoleName
        if(MMScoreCard == 'true')
        {            
            for(User userDetails:userDetailsList)
            {
                if(userDetails.WT_MM_Scorecard_Team__c!=null)
                {
                    mmScoreCardTeam=userDetails.WT_MM_Scorecard_Team__c;
                }
                else
                {
                    mmScoreCardTeam=userDetails.WT_Charter__c;
                }
                if(userDetails.WT_MM_Scorecard_Access__c!=null)
                {
                    mmScoreCardAccess=userDetails.WT_MM_Scorecard_Access__c;
                    roleName = 'Middle Market' +'-'+ userDetails.WT_MM_Scorecard_Access__c;
                }
                if(userDetails.WT_Line_of_Business__c=='Business Administrator' || userDetails.WT_Line_of_Business__c=='IT Administrator')
                {
                    roleName = userDetails.WT_Line_of_Business__c;
                }
            }            
        }
        System.debug('RoleName: ' + roleName);      
        
        // Call to Power BI Service API to get report data for embedding        
        HttpRequest reqGetReport = new HttpRequest();
        reqGetReport.setMethod('GET');
        String urlGetReport = 'https://api.powerbi.com/v1.0/myorg/groups/' + WorkspaceId + '/reports/' + ReportId;
        reqGetReport.setEndpoint(urlGetReport);
        reqGetReport.setHeader('Authorization', 'Bearer ' + access_token);
        
        Http http = new Http();        
        HttpResponse response = http.send(reqGetReport);
        
        // check response for success
        if(response.getStatusCode()!=200){
            System.debug('ERROR --- Getting Report Data --- ERROR');
            System.debug('Status Code: ' + response.getStatusCode());
            PowerBiReportData getReportError = new PowerBiReportData();
            getReportError.error = 'Get Report Error: ' + response.getStatus();
            return getReportError;            
        }            
        
        // extract Power BI report data from JSON response
        String responseJson = response.getBody();
        System.debug('ResponseBody: ' + responseJson);   
        PowerBiReport powerBiReport = (PowerBiReport)JSON.deserialize(responseJson, PowerBiReport.class);
        
        // send report info to debug window
        System.debug('id: ' + powerBiReport.id);        
        System.debug('reportType: ' + powerBiReport.reportType);        
        System.debug('name: ' + powerBiReport.name);  
        System.debug('webUrl: ' + powerBiReport.webUrl);      
        System.debug('embedUrl: ' + powerBiReport.embedUrl);        
        System.debug('isFromPbix: ' + powerBiReport.isFromPbix);        
        System.debug('isOwnedByMe: ' + powerBiReport.isOwnedByMe);        
        System.debug('datasetId: ' + powerBiReport.datasetId);        
        
        // Call to Power BI Service API to get embed token for report        
        HttpRequest reqGetEmbedToken = new HttpRequest();
        reqGetEmbedToken.setMethod('POST');
        String urlGetEmbedToken = 'https://api.powerbi.com/v1.0/myorg/groups/' + WorkspaceId + '/reports/' + ReportId + '/GenerateToken';
        reqGetEmbedToken.setEndpoint(urlGetEmbedToken);
        System.debug('urlGetEmbedToken: ' + urlGetEmbedToken);          
        reqGetEmbedToken.setHeader('Content-Type', 'application/json');
        reqGetEmbedToken.setHeader('Authorization', 'Bearer ' + access_token);    
        System.debug('Authorization: ' + 'Bearer ' + access_token);
        String requestBody='';
        if(ReportType=='PowerBI')
        {
            if(UserFilter=='Yes' && roleName!=null)
            {                  
                requestBody ='{"accessLevel": "View" , "identities":[{"username": "' + userName +'","roles": ["' + roleName + '"],"datasets":["' + powerBiReport.datasetId + '"]}]}';              
            }           
            else {
                requestBody ='{"accessLevel": "View","identities":[{"username": "' + userName +'","datasets":["' + powerBiReport.datasetId + '"]}]}';   
            }
        }
        else if(ReportType=='SSRS'){
            if(UserFilter=='Yes')
            {
                requestBody ='{"accessLevel": "View", "reportId": "' + powerBiReport.id + '","identities":[{"username": "' + UserInfo.getUserId() +'","reports":["' + powerBiReport.id + '"]}]}';
            }
            else {
                requestBody ='{"accessLevel": "View", "datasetId": "' + powerBiReport.datasetId + '"}'; 
            }
        }       
        System.debug('requestBody: ' + requestBody);        
        reqGetEmbedToken.setBody(requestBody);
        Http http1 = new Http();
        HttpResponse responseEmbedToken = http1.send(reqGetEmbedToken);
        
        // check response for success
        if(responseEmbedToken.getStatusCode()!=200){
            System.debug('ERROR --- Getting Embed Token --- ERROR');
            System.debug('Response Body: ' + responseEmbedToken.getBody());         
            System.debug('Status Code: ' + responseEmbedToken.getStatusCode());    
            System.debug('Status: ' + responseEmbedToken.getStatus());
            PowerBiReportData getEmbedTokenError = new PowerBiReportData();
            getEmbedTokenError.error = 'Body: ' + responseEmbedToken.getBody();
            getEmbedTokenError.error = getEmbedTokenError.error + ' Get Embed Token Error, Status:' + responseEmbedToken.getStatus()+' Status Code: ' + responseEmbedToken.getStatusCode();
            return getEmbedTokenError;            
        }
        else {
            System.debug('Status Code: ' + responseEmbedToken.getStatusCode());    
            System.debug('Status: ' + responseEmbedToken.getStatus());
            System.debug('Response Body: ' + responseEmbedToken.getBody());  
        }            
        
        // extract Power BI embed token and expiration
        PowerBiEmbedToken embedToken = (PowerBiEmbedToken)JSON.deserialize(responseEmbedToken.getBody(), PowerBiEmbedToken.class);
        
        // send report info to debug window
        System.debug('EmbedToken: ' + embedToken.token);        
        System.debug('EmbedToken ID: ' + embedToken.tokenId);        
        System.debug('expiration: ' + embedToken.expiration);
        
        // create custom remote-able object to return to caller in browser 
        PowerBiReportData powerBiReportData = new PowerBiReportData();        
        powerBiReportData.workspaceId = WorkspaceId;
        powerBiReportData.reportId = ReportId;
        powerBiReportData.name = powerBiReport.name;
        string filterURL=null;
        
        System.debug('creScoreCardAccess: ' + creScoreCardAccess);
        System.debug('mmScoreCardAccess: ' + mmScoreCardAccess);
        
        //Add Filter to Embed URL if CRE ScoreCard Access=='Manager/Team Lead'
        if(creScoreCardAccess!=null && creScoreCardAccess=='Manager/Team Lead' && creScoreCardTeam!=null)
        {
            String teamName = creScoreCardTeam;
            if(teamName.contains('&'))
            {
                teamName = teamName.replace('&', '%26');
            }
            filterURL = '&filter=' + 'Team%2FTeam_x0020_Name eq ' + '\''+ teamName +'\'';                        
            System.debug('Filter-'+ filterURL);  
        }        
        //Add Filter to Embed URL if MMS ScoreCard Access=='Manager/Team Lead'
        else if(mmScoreCardAccess!=null && mmScoreCardAccess=='Manager/Team Lead' && mmScoreCardTeam!=null)
        {
            String teamName = mmScoreCardTeam;
            if(teamName.contains('&'))
            {
                teamName = teamName.replace('&', '%26');
            }
            filterURL = '&filter=' + 'Team%2FTeam_x0020_Name eq ' + '\''+ teamName +'\'';
            System.debug('Filter-'+ filterURL);
        }
        //Add Filter to Embed URL if CRE OR MM ScoreCard Access=='Individual'
        else if((creScoreCardAccess!=null && creScoreCardAccess=='Individual') ||(mmScoreCardAccess!=null && mmScoreCardAccess=='Individual'))
        {            
            System.debug('If 3');            
            filterURL = '&filter=Officer/SourceKey eq ' + '\''+ UserInfo.getUserId() +'\'';
            System.debug('Filter-'+ filterURL);
        }                
        if(filterURL!=null)
        {
            System.debug('Filter URL If - 1');     
            System.debug('Filter-'+ filterURL);
            powerBiReportData.embedUrl = powerBiReport.embedUrl + filterURL;
        }
        else
        {
            System.debug('Filter URL If - 2');     
            powerBiReportData.embedUrl = powerBiReport.embedUrl;
        }
        
        System.debug('powerBiReportData.embedUrl: ' + powerBiReportData.embedUrl); 
        powerBiReportData.embedToken = embedToken.token;
        powerBiReportData.embedTokenExpires = embedToken.expiration;                
        return powerBiReportData;  
    }
    
    public WT_PowerBiEmbedManager() {}
    
    public class ClientCredentialPostData 
    {
        public String client_id;
        public String client_info;
        public string client_secret;
        public String scope;
        public string grant_type;
        public String getPostData()
        {
            return 'client_id=' + this.client_id + 
                '&client_info=' + this.client_info +
                '&client_secret=' + this.client_secret +
                '&scope=' + this.scope +
                '&grant_type=' + grant_type;
        }
    }
    
    public class ClientCredentialResponse 
    {
        public String access_token;
        public String expires_in;
        public String ext_expires_in;
        public String token_type;
    }
    
    public class PowerBiReport    
    {
        public String id { get; set; } 
        public String reportType { get; set; } 
        public String name { get; set; } 
        public String webUrl { get; set; } 
        public String embedUrl { get; set; } 
        public boolean isFromPbix { get; set; } 
        public boolean isOwnedByMe { get; set; } 
        public String datasetId { get; set; } 
    }
    
    public class PowerBiEmbedToken    
    {
        public string token { get; set; } 
        public string tokenId { get; set; } 
        public DateTime expiration { get; set; } 
    }
    
    public class PowerBiReportData    
    {
        @AuraEnabled
        public String workspaceId { get; set; } 
        @AuraEnabled
        public String reportId { get; set; } 
        @AuraEnabled
        public String name { get; set; } 
        @AuraEnabled
        public String embedUrl { get; set; } 
        @AuraEnabled
        public String embedToken { get; set; } 
        @AuraEnabled
        public DateTime embedTokenExpires { get; set; } 
        @AuraEnabled
        public String error { get; set; } 
    }
    
    public class ExportToResponse
    {
        @AuraEnabled public string id;
        @AuraEnabled public string reportId;
        @AuraEnabled public string status;
        @AuraEnabled public Integer percentComplete;      
        @AuraEnabled public String error { get; set; } 
    }
    
    public class RecordDetailResponse
    {
        @AuraEnabled public Boolean IsAccountRecord;
        @AuraEnabled public Id PowerBiReportSalesforceId;
        @AuraEnabled public String PowerBiReportName;
        @AuraEnabled public String PowerBiReportWorkspaceId;
        @AuraEnabled public String PowerBiReportId;
        @AuraEnabled public String PowerBiReportType;
        @AuraEnabled public String PowerBiReportUserFilter;
        @AuraEnabled public Boolean IsCreScorecard;
        @AuraEnabled public Boolean IsMMScorecard;
    }
}