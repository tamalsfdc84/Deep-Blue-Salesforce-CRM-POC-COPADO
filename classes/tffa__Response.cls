/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class Response {
    global Object data {
        get;
        set;
    }
    global Map<String,Object> header {
        get;
        set;
    }
    global Integer status {
        get;
        set;
    }
    global static tffa.Response.ResponseBuilder fail(Exception ex) {
        return null;
    }
    global static tffa.Response.ResponseBuilder ok() {
        return null;
    }
    global static tffa.Response.ResponseBuilder ok(Object data) {
        return null;
    }
global class ResponseBuilder {
    global ResponseBuilder(Integer status) {

    }
    global tffa.Response build() {
        return null;
    }
    global void buildRestResponse() {

    }
    global tffa.Response.ResponseBuilder data(Object data) {
        return null;
    }
    global tffa.Response.ResponseBuilder exception(Exception ex) {
        return null;
    }
    global tffa.Response.ResponseBuilder header(String key, String value) {
        return null;
    }
}
}
