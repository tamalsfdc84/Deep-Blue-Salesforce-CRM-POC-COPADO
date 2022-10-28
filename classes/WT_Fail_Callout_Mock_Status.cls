global class WT_Fail_Callout_Mock_Status implements HttpCalloutMock 
{
	// Implement this interface method
    global HTTPResponse respond(HTTPRequest req) 
    {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"error_message" : "This IP, site or mobile application is not authorized to use this API key. Request received from IP address 136.147.46.8, with empty referer",   "results" : [],   "status" : "REQUEST_DENIED"}');
        res.setStatusCode(400);
        return res;
    }
}