/**
* -----------------------------------------------------------------------------------------------------------------------------------------
* @Name           WT_ContactCenterMulesoftHelper
* @Author         Himanshu Patel
* @ModifiedBy     Himanshu Patel
* @Version        v1.0
* @CreatedDate    05-17-2021
* @UsedBy         WT_ContactCenterSearchController 
* @TestClass      WT_ContactCenterMulesoftHelper_T
* -----------------------------------------------------------------------------------------------------------------------------------------
* @Description
* Helper class used to make a synchronous callout to the Mulesoft API to grab authentication information for a given Person Account
* -----------------------------------------------------------------------------------------------------------------------------------------
* @Changes
* -----------------------------------------------------------------------------------------------------------------------------------------
**/
public without sharing class WT_ContactCenterMulesoftHelper 
{
/**
* -----------------------------------------------------------------------------------------------------------------------------------------
* @Description
* Method to retrieve Customer details from Mulesoft Experience API 

* The API callout passes the three attributes as query string parameters
* The callout response is returned as String
* -----------------------------------------------------------------------------------------------------------------------------------------
* @param     firstName     						String attribute for phone number to search
* @param     lastName     						String attribute for phone number to search
* @param     ssn     							String attribute for phone number to search
* @return    String							   	String response from the callout to Mulesoft
* -----------------------------------------------------------------------------------------------------------------------------------------
**/
    public static String MakeMulesoftCallout(String firstName, String lastName, String ssn, String phoneNumber)
    {    
        String clientId = WT_Contact_Center_Mulesoft__c.getOrgDefaults().WT_Client_Id__c;
        String clientSecret = WT_Contact_Center_Mulesoft__c.getOrgDefaults().WT_Client_Secret__c;
        String tokenUrl = WT_Contact_Center_Mulesoft__c.getOrgDefaults().WT_Token_URL__c;
        String customerProfileUrl = WT_Contact_Center_Mulesoft__c.getOrgDefaults().WT_Customer_Profile_URL__c;
        String queryString = '?grant_type=client_credentials';
        String token = '';
        String returnBody = '';
        
        //Make a callout to the Token URL and grab a valid token
        Http tokenClient = new Http();
        HttpRequest tokenRequest = new HttpRequest();  
        tokenRequest.setEndpoint(tokenUrl + queryString);
        tokenRequest.setTimeout(120000);
        tokenRequest.setMethod('POST');
        tokenRequest.setHeader('Content-Type','application/x-www-form-urlencoded'); 
        Blob headerValue = Blob.valueOf(clientId + ':' + clientSecret);
        String tokenAuthorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        tokenRequest.setHeader('Authorization', tokenAuthorizationHeader);
        
        try
        {
            if(!Test.isRunningTest())
            {
                HTTPResponse response = tokenClient.send(tokenRequest);  
                
                if(response.getStatusCode() == 200)
                {
                    TokenResponseModel tokenModel = (TokenResponseModel)JSON.deserialize(response.getBody(), TokenResponseModel.class);
                    if(tokenModel != null && String.isNotBlank(tokenModel.access_token))
                    {
                        token = tokenModel.access_token;
                    }
                }
            }
            else
            {
                token = 'test';
            }
        }
        catch(Exception ex)
        {
            System.debug('ex: ' + ex.getMessage());
        }
        
        if(String.isNotBlank(token))
        {
            String profileQueryString = '?records_to_return=1&ind_frst_nm=' + firstName + '&ind_lst_nm=' + lastName;
            if(String.isNotBlank(ssn))
            {
                profileQueryString += '&ind_ssn_nmb=' + ssn.replaceAll('\\D','');
            }
            if(String.isNotBlank(phoneNumber))
            {
                profileQueryString += '&ind_phn_nmb=' + phoneNumber.replace(' ', '%20');
            }
            
            Http client = new Http();
            HttpRequest request = new HttpRequest();   
            request.setTimeout(120000);
            request.setEndpoint(customerProfileUrl + profileQueryString);
            request.setMethod('GET');
            String authorizationHeader = 'Bearer ' + token;
            request.setHeader('Authorization', authorizationHeader);
            
            try
            {
                if(!Test.isRunningTest())
                {
                    HTTPResponse response = client.send(request); 
                    returnBody = response.getBody();
                }
                else
                {
                    returnBody = GetMockResponseJson();
                }
            }
            catch(Exception ex)
            {
                System.debug('ex: ' + ex.getMessage());                
            }
        }
        
        return returnBody;
    }
    
    public static String MakeTransactionAPIMulesoftCallout(String financialAccountMdmId)
    {    
        String clientId = WT_Contact_Center_Mulesoft__c.getOrgDefaults().WT_Transactions_API_Client_Id__c;
        String clientSecret = WT_Contact_Center_Mulesoft__c.getOrgDefaults().WT_Transactions_API_Client_Secret__c;
        String tokenUrl = WT_Contact_Center_Mulesoft__c.getOrgDefaults().WT_Transactions_API_Token_URL__c;
        String transactionsUrl = WT_Contact_Center_Mulesoft__c.getOrgDefaults().WT_Transactions_API_URL__c;
        String queryString = '?grant_type=client_credentials';
        String token = '';
        String returnBody = '';
        
        //Make a callout to the Token URL and grab a valid token
        Http tokenClient = new Http();
        HttpRequest tokenRequest = new HttpRequest();  
        tokenRequest.setEndpoint(tokenUrl + queryString);
        tokenRequest.setTimeout(120000);
        tokenRequest.setMethod('POST');
        tokenRequest.setHeader('Content-Type','application/x-www-form-urlencoded'); 
        Blob headerValue = Blob.valueOf(clientId + ':' + clientSecret);
        String tokenAuthorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        tokenRequest.setHeader('Authorization', tokenAuthorizationHeader);
        
        try
        {
            if(!Test.isRunningTest())
            {
                HTTPResponse response = tokenClient.send(tokenRequest);  
                
                if(response.getStatusCode() == 200)
                {
                    TokenResponseModel tokenModel = (TokenResponseModel)JSON.deserialize(response.getBody(), TokenResponseModel.class);
                    if(tokenModel != null && String.isNotBlank(tokenModel.access_token))
                    {
                        token = tokenModel.access_token;
                    }
                }
            }
            else
            {
                token = 'test';
            }
        }
        catch(Exception ex)
        {
            System.debug('ex: ' + ex.getMessage());
        }
        
        if(String.isNotBlank(token))
        {
            String transactionsRequestQueryString = '?accountUid=' + financialAccountMdmId;
            Blob requestIdBlob = Crypto.GenerateAESKey(128);
            String hexString = EncodingUtil.ConvertTohex(requestIdBlob);
            String requestIdGuid = hexString.SubString(0,8)+ '-' + hexString.SubString(8,12) + '-' + hexString.SubString(12,16) + '-' + hexString.SubString(16,20) + '-' + hexString.substring(20);
            
            Http client = new Http();
            HttpRequest request = new HttpRequest();   
            request.setTimeout(120000);
            request.setEndpoint(transactionsUrl + transactionsRequestQueryString);
            request.setMethod('GET');
            String authorizationHeader = 'Bearer ' + token;
            request.setHeader('Authorization', authorizationHeader);
            request.setHeader('wtfc-product-category', 'DP');
            request.setHeader('request-id', requestIdGuid);
            
            try
            {
                if(!Test.isRunningTest())
                {
                    HTTPResponse response = client.send(request); 
                    returnBody = response.getBody();
                }
                else
                {
                    returnBody = GetMockTransactionsApiResponse();
                }

                if(String.isNotBlank(returnBody))
                {
                    returnBody = returnBody.replace(' transactions-intraday-dataLst', 'transactionsIntradayDataLst');
                    returnBody = returnBody.replace('transactions-intraday-dataLst', 'transactionsIntradayDataLst');
                    returnBody = returnBody.replace('posted-transactionsLst', 'postedTransactionsLst');
                }
                System.debug(returnBody);
            }
            catch(Exception ex)
            {
                System.debug('ex: ' + ex.getMessage());                
            }
        }
        
        return returnBody;
    }
    
    public static String MakeIdaAPIQuestionMulesoftCallout(String jsonBody, Boolean isDecisionRequest)
    {    
        String clientId = WT_Contact_Center_Mulesoft__c.getOrgDefaults().WT_IDA_API_Client_Id__c;
        String clientSecret = WT_Contact_Center_Mulesoft__c.getOrgDefaults().WT_IDA_API_Client_Secret__c;
        String tokenUrl = WT_Contact_Center_Mulesoft__c.getOrgDefaults().WT_IDA_API_Token_URL__c;
        String url = WT_Contact_Center_Mulesoft__c.getOrgDefaults().WT_IDA_API_URL__c;
        if(isDecisionRequest)
        {
            url = WT_Contact_Center_Mulesoft__c.getOrgDefaults().WT_IDA_API_Decision_URL__c;
        }
        String queryString = '?grant_type=client_credentials';
        String token = '';
        String returnBody = '';
        
        //Make a callout to the Token URL and grab a valid token
        Http tokenClient = new Http();
        HttpRequest tokenRequest = new HttpRequest();  
        tokenRequest.setEndpoint(tokenUrl + queryString);
        tokenRequest.setTimeout(120000);
        tokenRequest.setMethod('POST');
        tokenRequest.setHeader('Content-Type','application/x-www-form-urlencoded'); 
        Blob headerValue = Blob.valueOf(clientId + ':' + clientSecret);
        String tokenAuthorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        tokenRequest.setHeader('Authorization', tokenAuthorizationHeader);
        
        try
        {
            if(!Test.isRunningTest())
            {
                HTTPResponse response = tokenClient.send(tokenRequest);  
                
                if(response.getStatusCode() == 200)
                {
                    TokenResponseModel tokenModel = (TokenResponseModel)JSON.deserialize(response.getBody(), TokenResponseModel.class);
                    if(tokenModel != null && String.isNotBlank(tokenModel.access_token))
                    {
                        token = tokenModel.access_token;
                    }
                }
            }
            else
            {
                token = 'test';
            }
        }
        catch(Exception ex)
        {
            System.debug('ex: ' + ex.getMessage());
        }
        
        if(String.isNotBlank(token))
        {
            Blob requestIdBlob = Crypto.GenerateAESKey(128);
            String hexString = EncodingUtil.ConvertTohex(requestIdBlob);
            String requestIdGuid = hexString.SubString(0,8)+ '-' + hexString.SubString(8,12) + '-' + hexString.SubString(12,16) + '-' + hexString.SubString(16,20) + '-' + hexString.substring(20);

            if(Test.isRunningTest())
            {
                url = '';
                clientId = '';
                clientSecret = '';
            }
            Http client = new Http();
            HttpRequest request = new HttpRequest();   
            request.setTimeout(120000);
            request.setEndpoint(url);
            request.setMethod('POST');
            String authorizationHeader = 'Bearer ' + token;
            request.setHeader('Authorization', authorizationHeader);
            request.setHeader('X-Correlation-Id', requestIdGuid);
            request.setHeader('client_id', clientId);
            request.setHeader('client_secret', clientSecret);
            request.setHeader('Content-Type','application/json'); 
            request.setBody(jsonBody);
            
            try
            {
                if(!Test.isRunningTest())
                {
                    HTTPResponse response = client.send(request);
                    returnBody = response.getBody();
                    System.debug('returnBody: ' + returnBody);
                }
                else
                {
                    if(!isDecisionRequest)
                    {
                    	returnBody = GetMockIdaQuestionResponseJson();
                    }
                    else
                    {
                        returnBody = GetMockIdaDecisionResponseJson();
                    }
                }
            }
            catch(Exception ex)
            {
                System.debug('ex: ' + ex.getMessage());                
            }
        }
        
        return returnBody;
    }
    
    public static String GetMockIdaDecisionResponseJson()
    {
        return '{' +
            '	"base": 4,' +
            '	"decision": "Fail",' +
            '	"idaOid": "2148559395",' +
            '	"score": 1' +
            '}';
    }
    
    public static String GetMockIdaQuestionResponseJson()
    {
        return '{' +
            '	"idaQuestion1": {' +
            '		"answer1Id": "36438019",' +
            '		"answer1Text": "2000",' +
            '		"answer2Id": "42468393",' +
            '		"answer2Text": "2001",' +
            '		"answer3Id": "46284801",' +
            '		"answer3Text": "2002",' +
            '		"answer4Id": "41944171",' +
            '		"answer4Text": "2003",' +
            '		"answer5Id": "73548867",' +
            '		"answer5Text": "None of the above",' +
            '		"id": "75645994",' +
            '		"questionText": "What year is your Acura 3.2 TL?"' +
            '	},' +
            '	"idaQuestion2": {' +
            '		"answer1Id": "67780616",' +
            '		"answer1Text": "THOMPSON",' +
            '		"answer2Id": "08781827",' +
            '		"answer2Text": "TEMPE",' +
            '		"answer3Id": "68043816",' +
            '		"answer3Text": "TALBOT",' +
            '		"answer4Id": "40632392",' +
            '		"answer4Text": "TENNYSON",' +
            '		"answer5Id": "46793800",' +
            '		"answer5Text": "None of the above",' +
            '		"id": "38010923",' +
            '		"questionText": "With which name are you associated?"' +
            '	},' +
            '	"idaQuestion3": {' +
            '		"answer1Id": "06571080",' +
            '		"answer1Text": "October 2003",' +
            '		"answer2Id": "34210884",' +
            '		"answer2Text": "June 2005",' +
            '		"answer3Id": "02360428",' +
            '		"answer3Text": "May 2008",' +
            '		"answer4Id": "82068588",' +
            '		"answer4Text": "June 2009",' +
            '		"answer5Id": "09192480",' +
            '		"answer5Text": "None of the above",' +
            '		"id": "48381984",' +
            '		"questionText": "When did you purchase or lease your Acura 3.2 TL?"' +
            '	},' +
            '	"idaQuestion4": {' +
            '		"answer1Id": "38028320",' +
            '		"answer1Text": "North Carolina",' +
            '		"answer2Id": "81790060",' +
            '		"answer2Text": "Iowa",' +
            '		"answer3Id": "06963240",' +
            '		"answer3Text": "Maine",' +
            '		"answer4Id": "13238336",' +
            '		"answer4Text": "Illinois",' +
            '		"answer5Id": "14812260",' +
            '		"answer5Text": "None of the above",' +
            '		"id": "04850796",' +
            '		"questionText": "Where was your social security number issued?"' +
            '	},' +
            '	"quizId": "DISC:PEN:2148559283",' +
            '	"quizRemain": "",' +
            '	"quizTime": "",' +
            '	"transId": "4159164524"' +
            '}';
    }
    
/**
* -----------------------------------------------------------------------------------------------------------------------------------------
* @Description
* Method that returns a mock JSON that we would expect as a responce from the Mulesoft Experience API callout
* This method is used to stub the callout
* This can also be called from the test class
* -----------------------------------------------------------------------------------------------------------------------------------------
* @param     N/A
* -----------------------------------------------------------------------------------------------------------------------------------------
**/
	public static String GetMockResponseJson()
    {
        String json=		'{'+
		'  "first_record": 1,'+
		'  "page_size": 10,'+
		'  "total_record_count": 1,'+
		'  "Individuals": ['+
		'    {'+
		'      "frst_nm": "Jean",'+
		'      "lst_nm": "Bratkovich",'+
		'      "mid_nm": "M",'+
		'      "mthr_mdn_nm": "Huscher",'+
		'      "birth_dt": "1967-09-17T00:00:00-05:00",'+
		'      "gndr_type": "Female",'+
		'      "is_emp": "Y",'+
		'      "Identifiers": ['+
		'        {'+
		'          "idnty_type": "Social Security Number",'+
        '          "idnty_cd": "0474",'+
		'          "idnty_status": "Active"'+            
		'        },'+
		'        {'+
		'          "idnty_type": "Driver License",'+
        '          "idnty_cd": "123456789",'+
		'          "idnty_status": "Active"'+            
		'        }'+            
		'      ],'+
		'      "AddressRelationship": ['+
		'        {'+
		'          "is_prim_addr": "Y",'+
		'          "zip_4cd": "3584",'+
		'          "zip_5cd": "60133",'+
		'          "county_nm": "ICE",'+
		'          "state_cd": "IL",'+
		'          "city_nm": "HAN",'+
		'          "addr_line1_tx": "AVE",'+
		'          "ctry_cd": "USA"'+
		'        },'+
		'        {'+
		'          "is_prim_addr": "N",'+
		'          "zip_4cd": "3584",'+
		'          "zip_5cd": "60133",'+
		'          "county_nm": "SODA",'+
		'          "state_cd": "IL",'+
		'          "city_nm": "NOT CITY",'+
		'          "addr_line1_tx": "N AVE",'+
		'          "ctry_cd": "USA"'+
		'        },'+
		'        {'+
		'          "is_prim_addr": "N",'+
		'          "zip_4cd": "3584",'+
		'          "zip_5cd": "60133",'+
		'          "county_nm": "SNOW",'+
		'          "state_cd": "IL",'+
		'          "city_nm": "CAT PARK",'+
		'          "addr_line1_tx": "S AVE",'+
		'          "ctry_cd": "USA"'+
		'        },'+
		'        {'+
		'          "is_prim_addr": "N",'+
		'          "zip_4cd": "3584",'+
		'          "zip_5cd": "60133",'+
		'          "county_nm": "WATER",'+
		'          "state_cd": "IL",'+
		'          "city_nm": "DOG PARK",'+
		'          "addr_line1_tx": "654 S AVE",'+
		'          "ctry_cd": "USA"'+
		'        },'+
		'        {'+
		'          "is_prim_addr": "N",'+
		'          "zip_4cd": "3584",'+
		'          "zip_5cd": "60133",'+
		'          "county_nm": "COOK",'+
		'          "state_cd": "IL",'+
		'          "city_nm": "UPTON PARK",'+
		'          "addr_line1_tx": "1900 CHESTNUT AVE",'+
		'          "ctry_cd": "USA"'+
		'        },'+
		'        {'+
		'          "is_prim_addr": "Y",'+
		'          "zip_4cd": "3584",'+
		'          "zip_5cd": "60133",'+
		'          "county_nm": "FREEZE",'+
		'          "state_cd": "IL",'+
		'          "city_nm": "GREEN PARK",'+
		'          "addr_line1_tx": "1900 SOUTH AVE APT 1",'+
		'          "ctry_cd": "USA"'+
		'        },'+
		'        {'+
		'          "is_prim_addr": "Y",'+
		'          "zip_4cd": "3584",'+
		'          "zip_5cd": "60133",'+
		'          "county_nm": "ATLANTA",'+
		'          "state_cd": "UT",'+
		'          "city_nm": "HANOVER PARK",'+
		'          "addr_line1_tx": "1900 MAIN AVE STE 100",'+
		'          "ctry_cd": "USA"'+
		'        }'+
		'      ],'+
		'      "AccountRelationship": ['+
		'        {'+
		'          "acc_type": "Consumer Internet Banking",'+
		'          "acc_type_cd": "CIB",'+
		'          "acc_nmb": "00001023457433452532474",'+
		'          "acc_bnk_nm": "Town Bank",'+
		'          "acc_bnk_cd": "118"'+
		'        },'+
		'        {'+
		'          "acc_type": "Transaction History - Linked to CIB/BIB",'+
		'          "acc_type_cd": "TRHST",'+
		'          "acc_nmb": "000015729343534520",'+
		'          "acc_bnk_nm": "Town Bank",'+
		'          "acc_bnk_cd": "118"'+
		'        },'+
		'        {'+
		'          "acc_type": "Deposit System",'+
		'          "acc_type_cd": "DP",'+
		'          "acc_nmb": "00408003573453452",'+
		'          "acc_bnk_nm": "Town Bank",'+
		'          "acc_bnk_cd": "118"'+
		'        },'+
		'        {'+
		'          "acc_type": "External Account",'+
		'          "acc_type_cd": "XACCT",'+
		'          "acc_nmb": "2019021109123423443856333154",'+
		'          "acc_bnk_nm": "Schaumburg Bank & Trust Company Na",'+
		'          "acc_bnk_cd": "318"'+
		'        },'+
		'        {'+
		'          "acc_type": "Transaction History - Linked to CIB/BIB",'+
		'          "acc_type_cd": "TRHST",'+
		'          "acc_nmb": "0000021674234481",'+
		'          "acc_bnk_nm": "Schaumburg Bank & Trust Company Na",'+
		'          "acc_bnk_cd": "318"'+
		'        },'+
		'        {'+
		'          "acc_type": "Consumer Internet Banking",'+
		'          "acc_type_cd": "CIB",'+
		'          "acc_nmb": "000005324552854314",'+
		'          "acc_bnk_nm": "Schaumburg Bank & Trust Company Na",'+
		'          "acc_bnk_cd": "318"'+
		'        },'+
		'        {'+
		'          "acc_type": "Deposit System",'+
		'          "acc_type_cd": "DP",'+
		'          "acc_nmb": "00099234500120442",'+
		'          "acc_bnk_nm": "Schaumburg Bank & Trust Company Na",'+
		'          "acc_bnk_cd": "318"'+
		'        },'+
		'        {'+
		'          "acc_type": "Deposit System",'+
		'          "acc_type_cd": "DP",'+
		'          "acc_nmb": "0323450000345421",'+
		'          "acc_bnk_nm": "Schaumburg Bank & Trust Company Na",'+
		'          "acc_bnk_cd": "318"'+
		'        },'+
		'        {'+
		'          "acc_type": "Deposit System",'+
		'          "acc_type_cd": "DP",'+
		'          "acc_nmb": "03243500006132483",'+
		'          "acc_bnk_nm": "Schaumburg Bank & Trust Company Na",'+
		'          "acc_bnk_cd": "318"'+
		'        },'+
		'        {'+
		'          "acc_type": "Deposit System",'+
		'          "acc_type_cd": "DP",'+
		'          "acc_nmb": "037034250006142345",'+
		'          "acc_bnk_nm": "Schaumburg Bank & Trust Company Na",'+
		'          "acc_bnk_cd": "318"'+
		'        }'+
		'      ],'+
		'      "Communication": ['+
		'        {'+
		'          "commcn_type": "Work Phone",'+
		'          "is_pref": "Y",'+
		'          "commcn_value": "(877) 646-9003",'+
		'          "status": "Active"'+
		'        },'+
		'        {'+
		'          "commcn_type": "Home Phone",'+
		'          "is_pref": "Y",'+
		'          "commcn_value": "(847) 857-0745",'+
		'          "status": "Active"'+
		'        },'+
		'        {'+
		'          "commcn_type": "Primary Phone",'+
		'          "is_pref": "Y",'+
		'          "commcn_value": "(847) 857-0745",'+
		'          "status": "Active"'+
		'        },'+
		'        {'+
		'          "commcn_type": "Work Phone",'+
		'          "is_pref": "Y",'+
		'          "commcn_value": "(847) 891-8002",'+
		'          "status": "Active"'+
		'        },'+
		'        {'+
		'          "commcn_type": "Home Phone",'+
		'          "is_pref": "Y",'+
		'          "commcn_value": "(847) 891-8002",'+
		'          "status": "Active"'+
		'        },'+
		'        {'+
		'          "commcn_type": "Work Phone",'+
		'          "is_pref": "Y",'+
		'          "commcn_value": "(630) 741-7187",'+
		'          "status": "Active"'+
		'        }'+
		'      ],'+
		'      "Email": ['+
		'        {'+
		'          "email_type": "",'+
		'          "is_pref": "Y",'+
		'          "email": "jeanbbw708@aol.com"'+
		'        },'+
		'        {'+
		'          "email_type": "Primary Email",'+
		'          "is_pref": "Y",'+
		'          "email": "jbratkovich@wintrust.com"'+
		'        }'+
		'      ],'+
		'      "PasswordPhase": ['+
		'        {'+
		'          "pwd_question": "BLACK & WHITE CAT",'+
		'          "pwd_value": "tester",'+
		'          "acc_bnk_cd": "318"'+
		'        },'+
		'        {'+
		'          "pwd_question": "",'+
		'          "pwd_value": "",'+
		'          "acc_bnk_cd": "380"'+
		'        },'+
		'        {'+
		'          "pwd_question": "FIRST CAR",'+
		'          "pwd_value": "BUICK REGAL",'+
		'          "acc_bnk_cd": "118"'+
		'        }'+
		'      ]'+
		'    }'+
		'  ]'+
		'}';
        
        return json;
    }
    
    public static String GetMockTransactionsApiResponse()
    {
        String responseJson = '{' +
            '  "Response": {' +
            '    "accountUid": "0",' +
            '    "uid": "0",' +
            '    "requestId": "",' +
            '    " transactions-intraday-dataLst": {' +
            '      "transactions": [' +
            '        {' +
            '          "TranDate": "2022-05-31",' +
            '          "TranDesc": "DEPOSIT",' +
            '          "TranAmnt": 12000.00' +
            '        }' +
            '      ]' +
            '    },' +
            '    "savingsPendingTxnLst": {' +
            '      "transactions": [' +
            '        {' +
            '          "TranDate": "",' +
            '          "TranDesc": "",' +
            '          "TranAmnt": 0,' +
            '          "TranCode": "",' +
            '          "TranTypeInd": ""' +
            '        }' +
            '      ]' +
            '    },' +
            '    "ddaPendingTxnLst": {' +
            '      "transactions": [' +
            '        {' +
            '          "TranDate": "",' +
            '          "TranDesc": "",' +
            '          "TranAmnt": 0,' +
            '          "TranCode": "",' +
            '          "TranTypeInd": ""' +
            '        }' +
            '      ]' +
            '    },' +
            '    "posted-transactionsLst": {' +
            '      "transactions": [' +
            '        {' +
            '          "TranDate": "2022-05-13",' +
            '          "TranDesc": "INTEREST",' +
            '          "TranAmnt": 2.91,' +
            '          "TranCode": 761,' +
            '          "TranTypeInd": "C"' +
            '        }' +
            '      ]' +
            '    }' +
            '  }' +
            '}';
        return responseJson;
    }

    public class TokenResponseModel
    {
        public String access_token;
        public String token_type;
        public Integer expires_in;
    }
    
    public class MulesoftCustomerProfileResponseModel
    {
        public Integer first_record;
        public Integer page_size;
        public Integer total_record_count;
        public List<MulesoftCustomerProfileIndividualModel> Individuals;
    }
    
    public class MulesoftCustomerProfileIndividualModel
    {
        public String frst_nm;
		public String lst_nm;
		public String mid_nm;
		public String mthr_mdn_nm;
		public String birth_dt;
		public String gndr_type;
		public String is_emp;
        public List<MulesoftCustomerProfileIndividualIdentifiers> Identifiers;
		public List<MulesoftCustomerProfileIndividualAddressRelationship> AddressRelationship;
		public List<MulesoftCustomerProfileIndividualAccountRelationship> AccountRelationship;
		public List<MulesoftCustomerProfileIndividualCommunication> Communication;
		public List<MulesoftCustomerProfileIndividualEmail> Email;
		public List<MulesoftCustomerProfileIndividualPasswordPhase> PasswordPhase;
    }    
    public class MulesoftCustomerProfileIndividualIdentifiers 
    {
		public String idnty_type;
		public String idnty_cd;
        public String idnty_status;
	}    
    public class MulesoftCustomerProfileIndividualAddressRelationship 
    {
		public String is_prim_addr;
		public String zip_4cd;
		public String zip_5cd;
		public String county_nm;
		public String state_cd;
		public String city_nm;
		public String addr_line1_tx;
		public String ctry_cd;
	}
    public class MulesoftCustomerProfileIndividualAccountRelationship 
    {
		public String acc_type;
		public String acc_type_cd;
		public String acc_nmb;
		public String acc_bnk_nm;
		public String acc_bnk_cd;
	}
    public class MulesoftCustomerProfileIndividualCommunication 
    {
		public String commcn_type;
		public String is_pref;
		public String commcn_value;
		public String status;
	}
	public class MulesoftCustomerProfileIndividualEmail 
    {
		public String email_type;
		public String is_pref;
		public String email;
	}
	public class MulesoftCustomerProfileIndividualPasswordPhase 
    {
		public String pwd_question;
		public String pwd_value;
		public String acc_bnk_cd;
	}    
    
    //Transaction API Response Model
    public class TransactionApiResponseModel
    {
        public Response Response;
    }
    
    public class Response
    {
        public String accountUid;
        public String uid;
        public String requestId;
        public TransactionsIntradayDataLst transactionsIntradayDataLst;
        public SavingsPendingTxnLst savingsPendingTxnLst;
        public DdaPendingTxnLst ddaPendingTxnLst;
        public PostedTransactionsLst postedTransactionsLst;
    } 
    
    public class DdaPendingTxnLst
    {
        public List<TransactionModel> transactions;
    }

    public class PostedTransactionsLst
    {
        public List<TransactionModel> transactions;
    }

    public class SavingsPendingTxnLst
    {
        public List<TransactionModel> transactions;
    }    

    public class TransactionsIntradayDataLst
    {
        public List<TransactionModel> transactions;
    }
    
    public class TransactionModel
    {
        public String TranDate;
        public String TranDesc;
        public Double TranAmnt;
        public String TranCode;
        public String TranTypeInd;
    }
}