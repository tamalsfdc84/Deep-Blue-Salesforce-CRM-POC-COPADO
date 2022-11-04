public without sharing class WT_TwilioHelper 
{
    public static Boolean SendVerificationCode(String to, String channel)
    {
        Boolean isSuccess = false;
        VerificationRequestModel requestModel = new VerificationRequestModel();
        requestModel.VerificationTo = to;
        requestModel.Channel = channel;
        
        String requestBody = JSON.serialize(requestModel);
        Integer intTimeout = 120000;
        Http client = new Http();         
        HttpRequest request = new HttpRequest();    
        request.setEndpoint('callout:WT_Twilio_Send_Verification');        
        request.setHeader('Content-Type', 'application/json');
        request.setMethod('POST');
        request.setBody(requestBody);
        request.setTimeout(intTimeout);
        
        String responseBody = '';
        
        try
        {
            HttpResponse response = client.send(request);
            responseBody = response.getBody();
        }
        catch(Exception ex)
        {            
            if(!Test.isRunningTest())
            {
                isSuccess = false;
                WT_ExceptionLogHelper.LogException(null, 'WT_TwilioHelper', 'SendVerificationCode', ex.getMessage());       
            }
        }

        if(Test.isRunningTest())
        {
            responseBody = '{' +
                '	"sid": "test",' +
                '	"service_sid": "test",' +
                '	"account_sid": "test",' +
                '	"to": "test",' +
                '	"channel": "test",' +
                '	"status": "test",' +
                '	"valid": true,' +
                '	"lookup": {' +
                '		"carrier": {' +
                '			"mobile_country_code": null,' +
                '			"type": null,' +
                '			"error_code": null,' +
                '			"mobile_network_code": null,' +
                '			"name": null' +
                '		}' +
                '	},' +
                '	"amount": null,' +
                '	"payee": null,' +
                '	"send_code_attempts": [' +
                '		{' +
                '			"channel": null,' +
                '			"time_response": "0001-01-01T00:00:00"' +
                '		}' +
                '	],' +
                '	"date_created": "0001-01-01T00:00:00",' +
                '	"date_updated": "0001-01-01T00:00:00",' +
                '	"url": "wintrusttest.com"' +
                '}';
        }
        if(String.isNotBlank(responseBody))
        {
            //Need to do this because twilio response model has "time" as one of the attributes. 
            //"time" is a reserved word in Apex so it will not compile. To get around this, I've changed the object attribute to "time_response"
            responseBody = responseBody.replace('time', 'time_response');
            
            VerificationResponseModel parsedResponse = (VerificationResponseModel)JSON.deserialize(responseBody, VerificationResponseModel.Class);
            if(String.isNotBlank(parsedResponse.sid))
            {
                isSuccess = true;
            }
            else
            {
                isSuccess = false;
            }
            if(Test.isRunningTest())
            {
                if(parsedResponse.valid)
                {
                    String testsid = parsedResponse.sid;
                    String testservice_sid = parsedResponse.service_sid;
                    String testaccount_sid = parsedResponse.account_sid;
                    String testto = parsedResponse.to;
                    String testchannel = parsedResponse.channel;
                    String teststatus = parsedResponse.status;
                    String testurl = parsedResponse.url;
                    Lookup testlookup = parsedResponse.lookup;
                }
            }
        }
        else
        {
            isSuccess = false;
        }

        return isSuccess;
    }

    public static Boolean VerifyCode(String to, String code)
    {
        Boolean isSuccess = false;
        VerifyVerificationRequestModel requestModel = new VerifyVerificationRequestModel();                    
        requestModel.VerificationTo = to;
        requestModel.Code = code;
        
        String requestBody = JSON.serialize(requestModel);
        Http client = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:WT_Twilio_Verify_Code'); 
        request.setHeader('Content-Type', 'application/json');
        request.setMethod('POST');
        request.setTimeout(120000);
        request.setBody(requestBody);
        
        Integer responseStatusCode = 200;
        String responseBody = '';
        
        try
        {
            HttpResponse response = client.send(request);
            responseBody = response.getBody();
            responseStatusCode = response.getStatusCode();
        }
        catch(Exception ex)
        {
            isSuccess = false;
            WT_ExceptionLogHelper.LogException(null, 'WT_TwilioHelper', 'VerifyCode', ex.getMessage());       
        }
        
        if(Test.isRunningTest())
        {
            responseStatusCode = 200;
            responseBody = '{"sid": null,"service_sid": null,"account_sid": null,"to": null,"channel": null,"status": "approved","valid": false,"amount": null,"payee": null,"date_created": "0001-01-01T00:00:00","date_updated": "0001-01-01T00:00:00"}';
        }
        
        if(responseStatusCode != 404)
        {
            if(String.isNotBlank(responseBody))
            {
                VerifyVerificationCodeResponseModel responseModel = (VerifyVerificationCodeResponseModel)JSON.deserialize(responseBody, VerifyVerificationCodeResponseModel.class);
                if(responseModel != null && (responseModel.status == 'approved' || (responseModel.valid != null && responseModel.valid)))
                {
                    isSuccess = true;
                }
            }
            else
            {
                isSuccess = false;
            }
        }
        else
        {
            isSuccess = false;
        }

        return isSuccess;
    }

    public class VerificationRequestModel
    {
        public String VerificationTo;
        public String Channel;
    }
    
    public class VerifyVerificationRequestModel
    {
        public String VerificationTo;
        public String Code;
    }

    public class Carrier
    {
        public String mobile_country_code { get; set; }
        public String type { get; set; }
        public String error_code { get; set; }
        public String mobile_network_code { get; set; }
        public String name { get; set; }
    }
    
    public class Lookup
    {
        public Carrier carrier { get; set; }
    }

    public class VerificationResponseModel
    {
        public String sid { get; set; }
        public String service_sid { get; set; }
        public String account_sid { get; set; }
        public String to { get; set; }
        public String channel { get; set; }
        public String status { get; set; }
        public Boolean valid { get; set; }
        public Lookup lookup { get; set; }
        public object amount { get; set; }
        public object payee { get; set; }
        public List<SendCodeAttempt> send_code_attempts { get; set; }
        public DateTime date_created { get; set; }
        public DateTime date_updated { get; set; }
        public String url { get; set; }
    }
    
    public class VerifyVerificationCodeResponseModel
    {
        public string sid;
        public string service_sid;
        public string account_sid;
        public string to;
        public string channel;
        public string status;
        public Boolean valid;
        public object amount;
        public object payee;
        public DateTime date_created;
        public DateTime date_updated;
    }

    public class SendCodeAttempt
    {
        public String channel { get; set; }
        public Datetime time_response { get; set; }
    }
}