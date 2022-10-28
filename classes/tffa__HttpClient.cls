/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class HttpClient {
    global System.HttpRequest httpRequest;
    global HttpClient(String endpoint, Map<String,String> headers) {

    }
    global HttpClient(String endpoint, String body, Map<String,String> headers) {

    }
    global tffa.HttpClient.HttpResponseWrapper get() {
        return null;
    }
    global tffa.HttpClient.HttpResponseWrapper post() {
        return null;
    }
    global tffa.HttpClient.HttpResponseWrapper put() {
        return null;
    }
    global void setClientCertificateName(String certificateName) {

    }
    global void setHeader(String key, String value) {

    }
    global void setHeaders(Map<String,String> headers) {

    }
    global void setTimeout(Integer timeoutDuration) {

    }
global class HttpException extends Exception {
    global tffa.HttpClient.HttpResponseWrapper response;
    global HttpException(String code, String message, tffa.HttpClient.HttpResponseWrapper response) {

    }
}
global class HttpResponseWrapper {
    global HttpResponseWrapper(System.HttpResponse httpResponse) {

    }
    global Object deserialize(String jsonString, System.Type clazz) {
        return null;
    }
    global String getBody() {
        return null;
    }
    global System.HttpResponse getResponse() {
        return null;
    }
    global Integer getStatusCode() {
        return null;
    }
}
}
