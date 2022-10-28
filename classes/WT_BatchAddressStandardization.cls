/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_BatchAddressStandardization
* @Author			Navanit K	<nkamble@wintrust.com>
* @ModifiedBy		Navanit K	<nkamble@wintrust.com>
* @Version			v1.0
* @CreatedDate		20-11-2020
* @UsedBy			
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is used to standardise address from google geocode api
*
*
* --------------------------------------------------------------------------------------------------------------
* @Changes
* v1.0
* 11-27-2020
* --------------------------------------------------------------------------------------------------------------
**/
// Code Coverage: WT_BatchAddressStandardization_Test

global class WT_BatchAddressStandardization implements Database.Batchable<sObject> , Database.AllowsCallouts
{
    global Database.QueryLocator  start(Database.BatchableContext bc) 
    {
        String query = 'SELECT Id, BillingAddress,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry, type,  PersonMailingAddress,  WT_Address_Flag__c FROM Account WHERE WT_Address_Flag__c =\'Address Not Standardized\'';
        system.debug('Query' + Query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Account> scope)
    {
        
        List<CallOutDetail__mdt> geoDetails = new List<CallOutDetail__mdt>([
            Select DeveloperName,endpoint__c,key__c 
            from CallOutDetail__mdt 
            where DeveloperName = 'googleGeoLocationAPI'
        ]);
        
        AddressWrapper addWrap;
        map<id, AddressWrapper> accToStdAddMap = new map<id, AddressWrapper>();
        map<id, Account> accMap = new map<id, Account>();
        
        // process each Account records
        for(Account accRecord:scope)
        {
            //Get the response from google API
            accMap.put(accRecord.Id,accRecord);
            accToStdAddMap.put(accRecord.Id, getStandardAddress(accRecord,geoDetails[0].endpoint__c,geoDetails[0].key__c));
            
        }
        
        try
        {
            setAddress(accMap,accToStdAddMap);
        }
        catch(Exception e) 
        {
            System.debug(e);
        }
    }   
    
    
    public class AddressWrapper 
    {
        string addLine1;
        string city;
        string state;
        string country;
        string postCode;
        decimal lon;
        decimal lat;
        boolean error;
        string errString;
        boolean addressFound;
        
        public AddressWrapper()
        {
            addLine1 = null;
            city = null;
            state = null;
            country = null;
            postCode = null;
            lon = null;
            lat = null;
            error = false;
            addressFound = false;
            errString = null;
        }
    }
    
    public void  setAddress(map<Id,Account> accMap,map<id, AddressWrapper> addWrapper)
    {
        
        List<Account> accWithUpdatedAddresses = new List<Account>();
        Account tempAcc ;
        for(Id accKey : addWrapper.keySet())
        {
            if(!addWrapper.get(accKey).error)
            {
                tempAcc = new Account();
                tempAcc.id = accKey;
                if(accMap.get(accKey).type == 'Prospect')
                {
                    tempAcc.BillingStreet 		= addWrapper.get(accKey).addLine1;
                    tempAcc.BillingCity			= addWrapper.get(accKey).city ;
                    tempAcc.BillingState		= addWrapper.get(accKey).state ;
                    tempAcc.BillingPostalCode	= addWrapper.get(accKey).postCode ;
                    tempAcc.BillingCountry		= addWrapper.get(accKey).country ;    
                    tempAcc.WT_Latitude__c		= String.Valueof(addWrapper.get(accKey).lat) ;
                    tempAcc.WT_Longitude__c		= String.Valueof(addWrapper.get(accKey).lon);
                }
                else
                {
                    tempAcc.PersonMailingStreet 		= addWrapper.get(accKey).addLine1;
                    tempAcc.PersonMailingCity			= addWrapper.get(accKey).city ;
                    tempAcc.PersonMailingState			= addWrapper.get(accKey).state ;
                    tempAcc.PersonMailingPostalCode		= addWrapper.get(accKey).postCode ;
                    tempAcc.PersonMailingCountry		= addWrapper.get(accKey).country ;                    
                    tempAcc.WT_Latitude__c				= String.Valueof(addWrapper.get(accKey).lat) ;
                    tempAcc.WT_Longitude__c				= String.Valueof(addWrapper.get(accKey).lon);
                }
                
                tempAcc.WT_Address_Flag__c = 'Address Standardized';
                
            }
        	else
            {
                system.debug('Error wale' + addWrapper.get(accKey) );
            }
            accWithUpdatedAddresses.add(tempAcc);
        }
        update accWithUpdatedAddresses;
    }
    
    public AddressWrapper getStandardAddress(Account currAcc, string endpoint, string key)
    {
        string address;
        string geoEndPoint = endpoint + '?key=' + key; 
        geoEndPoint += '&address=' ;
        address = getAddress(currAcc);
        AddressWrapper addWrap = new AddressWrapper();
        try
        {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(geoEndPoint + EncodingUtil.urlEncode(address, 'UTF-8') );
            request.setMethod('GET');
            HttpResponse response = http.send(request);
            
            string responseaddress = '{"results":[{"address_components":[{"long_name":"3600","short_name":"3600","types":["street_number"]},{"long_name":"South Las Vegas Boulevard","short_name":"S Las Vegas Blvd","types":["route"]},{"long_name":"Las Vegas","short_name":"Las Vegas","types":["locality","political"]},{"long_name":"Clark County","short_name":"Clark County","types":["administrative_area_level_2","political"]},{"long_name":"Nevada","short_name":"NV","types":["administrative_area_level_1","political"]},{"long_name":"United States","short_name":"US","types":["country","political"]},{"long_name":"89109","short_name":"89109","types":["postal_code"]},{"long_name":"4303","short_name":"4303","types":["postal_code_suffix"]}],"formatted_address":"3600 S Las Vegas Blvd, Las Vegas, NV 89109, USA","geometry":{"bounds":{"northeast":{"lat":36.1144415,"lng":-115.1725624},"southwest":{"lat":36.1097408,"lng":-115.1798278}},"location":{"lat":36.1125269,"lng":-115.175947},"location_type":"ROOFTOP","viewport":{"northeast":{"lat":36.1144415,"lng":-115.1725624},"southwest":{"lat":36.1097408,"lng":-115.1798278}}},"place_id":"ChIJ--8YqTrEyIAR_CRGOOSiruI","types":["establishment","parking","point_of_interest","premise"]},{"address_components":[{"long_name":"3600","short_name":"3600","types":["street_number"]},{"long_name":"South Las Vegas Boulevard","short_name":"S Las Vegas Blvd","types":["route"]},{"long_name":"Las Vegas","short_name":"Las Vegas","types":["locality","political"]},{"long_name":"Clark County","short_name":"Clark County","types":["administrative_area_level_2","political"]},{"long_name":"Nevada","short_name":"NV","types":["administrative_area_level_1","political"]},{"long_name":"United States","short_name":"US","types":["country","political"]},{"long_name":"89109","short_name":"89109","types":["postal_code"]}],"formatted_address":"3600 S Las Vegas Blvd, Las Vegas, NV 89109, USA","geometry":{"location":{"lat":36.112238,"lng":-115.1790843},"location_type":"ROOFTOP","viewport":{"northeast":{"lat":36.1135869802915,"lng":-115.1777353197085},"southwest":{"lat":36.1108890197085,"lng":-115.1804332802915}}},"place_id":"ChIJVcoLbyXEyIARVU3TxH39f8M","plus_code":{"compound_code":"4R6C+V9 Las Vegas, NV, USA","global_code":"85864R6C+V9"},"types":["street_address"]}],"status":"OK"}';
            //addWrap = processResponse(responseaddress);
            
            // If the request is successful, parse the JSON response.
            if (response.getStatusCode() == 200) 
            {
                addWrap = processResponse((string)response.getBody());
            }
            else
            {
                system.debug('Error ' + response.getBody());
                throw new CalloutException('Connection error with Google Service: ' );
            }
            system.debug('addWrapErr' + addWrap);
            return addWrap;
        }
        catch (Exception ex )
        {
            AddressWrapper addWrapErr = new AddressWrapper();
            addWrapErr.error = true;
            addWrapErr.errString = ex.getMessage();
            addWrapErr.addressFound = false;
            system.debug('addWrapErr' + addWrapErr);
            return addWrapErr;
        }
        
        
    }
    
    public string getAddress(Account currAcc)
    {
        string returnString;
        returnString += currAcc.BillingStreet ;
        returnString += ' '+  currAcc.BillingCity;
        returnString += ' '+ currAcc.BillingState;
        returnString += ' '+ currAcc.BillingPostalCode;
        returnString += ' '+ currAcc.BillingCountry;
        returnString = returnString.replaceAll('[^a-zA-Z0-9\\s+]', '');
        return returnString;
    }
    
    public AddressWrapper processResponse(string response)
    {
        Map<String, Object> resObj =  (Map<String, Object>) JSON.deserializeUntyped(response);
        if(resObj.get('error_message') == null)
        {
            system.debug('oyoyoy' + resObj.get('results'));
            
            List<Object> 		resultArray 			= (List<Object>) resObj.get('results');
            Map<String, Object> addressOne 				=  (Map<String, Object>) resultArray[0];
            List<Object> 		addressComponentsArray 	= (List<Object>) addressOne.get('address_components');
            map<string,Object> 	geometry 				= (map<string,Object>)  addressOne.get('geometry');
            map<string,Object> 	location ;
            
            AddressWrapper addWrap = new AddressWrapper();
            
            system.debug('resultArray 0' + resultArray[0]);
            system.debug('addressOne 0' + addressOne);
            system.debug('addressOne 0' + addressOne.get('address_components'));
            
            if(geometry != null)
            {
                location = ( map<string,Object>)  geometry.get('location');
                addWrap.lon = (decimal) location.get('lng');
                addWrap.lat = (decimal) location.get('lat');
            }
            system.debug('addressComponentsArray 0' + addressComponentsArray[0]);
            //system.debug('addressComponentMap 0' + addressComponentMap);
            List<Object> types ;
            Map<string,Object> singleItem ;
            for(Object item : addressComponentsArray )
            {
                singleItem = (Map<string,Object>) item;
                
                system.debug('item ' + singleItem);
                
                types = (List<Object>) singleItem.get('types');
                
                for(Object typeItem : types)
                {
                    if((string)typeItem == 'postal_code')
                    {
                        addWrap.postCode 	= (string) singleItem.get('long_name');
                        break;                
                    }
                    if(typeItem == 'country')
                    {
                        addWrap.country 	= (string) singleItem.get('long_name');
                        break;                
                    }
                    if(typeItem == 'administrative_area_level_1')
                    {
                        addWrap.state 		= (string) singleItem.get('long_name');
                        break;                
                    }
                    if(typeItem == 'administrative_area_level_2')
                    {
                        addWrap.city 		= (string) singleItem.get('long_name');
                        break;                
                    }
                    else
                    {
                        addWrap.addLine1 	= (string) singleItem.get('long_name');
                        break;                
                    }
                }
            }
            system.debug('Add warp ' + addWrap);
            return addWrap;    
        }
        else
        {
            AddressWrapper addWrapErr = new AddressWrapper();
            addWrapErr.error = true;
            addWrapErr.errString = response;
            addWrapErr.addressFound = false;
            
            return addWrapErr;
        }
    }
    
    global void finish(Database.BatchableContext bc){
        // execute any log files 
    }    
}