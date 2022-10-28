@isTest
global class WT_Add_Mock implements HttpCalloutMock 
{
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) 
    {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"results":[{"address_components":[{"long_name":"3600","short_name":"3600","types":["street_number"]},{"long_name":"South Las Vegas Boulevard","short_name":"S Las Vegas Blvd","types":["route"]},{"long_name":"Las Vegas","short_name":"Las Vegas","types":["locality","political"]},{"long_name":"Clark County","short_name":"Clark County","types":["administrative_area_level_2","political"]},{"long_name":"Nevada","short_name":"NV","types":["administrative_area_level_1","political"]},{"long_name":"United States","short_name":"US","types":["country","political"]},{"long_name":"89109","short_name":"89109","types":["postal_code"]},{"long_name":"4303","short_name":"4303","types":["postal_code_suffix"]}],"formatted_address":"3600 S Las Vegas Blvd, Las Vegas, NV 89109, USA","geometry":{"bounds":{"northeast":{"lat":36.1144415,"lng":-115.1725624},"southwest":{"lat":36.1097408,"lng":-115.1798278}},"location":{"lat":36.1125269,"lng":-115.175947},"location_type":"ROOFTOP","viewport":{"northeast":{"lat":36.1144415,"lng":-115.1725624},"southwest":{"lat":36.1097408,"lng":-115.1798278}}},"place_id":"ChIJ--8YqTrEyIAR_CRGOOSiruI","types":["establishment","parking","point_of_interest","premise"]},{"address_components":[{"long_name":"3600","short_name":"3600","types":["street_number"]},{"long_name":"South Las Vegas Boulevard","short_name":"S Las Vegas Blvd","types":["route"]},{"long_name":"Las Vegas","short_name":"Las Vegas","types":["locality","political"]},{"long_name":"Clark County","short_name":"Clark County","types":["administrative_area_level_2","political"]},{"long_name":"Nevada","short_name":"NV","types":["administrative_area_level_1","political"]},{"long_name":"United States","short_name":"US","types":["country","political"]},{"long_name":"89109","short_name":"89109","types":["postal_code"]}],"formatted_address":"3600 S Las Vegas Blvd, Las Vegas, NV 89109, USA","geometry":{"location":{"lat":36.1125269,"lng":-115.1790843},"location_type":"ROOFTOP","viewport":{"northeast":{"lat":36.1135869802915,"lng":-115.1777353197085},"southwest":{"lat":36.1108890197085,"lng":-115.1804332802915}}},"place_id":"ChIJVcoLbyXEyIARVU3TxH39f8M","plus_code":{"compound_code":"4R6C+V9 Las Vegas, NV, USA","global_code":"85864R6C+V9"},"types":["street_address"]}],"status":"OK"}');
        res.setStatusCode(200);
        return res;
    }
}