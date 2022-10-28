/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class ApplicationTrackerController extends tffa.AbstractController implements tffa.IController {
    global String environmentConfig {
        get;
        set;
    }
    global String params {
        get;
        set;
    }
    global Map<String,String> ui {
        get;
        set;
    }
    global ApplicationTrackerController() {

    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response authenticate(tffa.Context ctx, Map<String,Object> params) {
        return null;
    }
    @TestVisible
    global virtual void init() {

    }
    global virtual System.PageReference initialize() {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response ping(tffa.Context ctx) {
        return null;
    }
    global virtual System.PageReference preInitialize() {
        return null;
    }
}
