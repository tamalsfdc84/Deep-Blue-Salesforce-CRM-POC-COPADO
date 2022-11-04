@isTest
global class WT_PowerBIHttpMockCalloutTest implements HttpCalloutMock{
    global HttpResponse respond(HTTPRequest req){
        WT_Power_BI_Settings__mdt authSetting = WT_Power_BI_Settings__mdt.getInstance('PowerBiApp');
        string TenantId = authSetting.WT_Tenant_ID__c;    
        string ClientId = authSetting.WT_Client_ID__c;    
        string ClientSecret = authSetting.WT_Client_Secret__c; 
        String aadTokenEndpoint = 'https://login.microsoftonline.com/' + TenantId + '/oauth2/v2.0/token';

        String postData =    'client_id=' + ClientId + 
                            '&client_info=' + '1' +
                            '&client_secret=' + ClientSecret +
                            '&scope=' + 'https://analysis.windows.net/powerbi/api/.default' +
                            '&grant_type=' + 'client_credentials';
        req.setBody(postData);
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setMethod('POST');
        req.setEndpoint(aadTokenEndpoint);    
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatus('OK');
        res.setStatusCode(200);
        res.setBody('{"token_type":"Bearer","expires_in":3599,"ext_expires_in":3599,"access_token":"eyJ0eX"}');
        return res;
    }
}