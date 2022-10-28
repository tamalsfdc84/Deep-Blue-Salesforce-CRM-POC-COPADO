/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class SalesController extends tffa.AbstractController implements tffa.IController {
    global String environmentConfig {
        get;
        set;
    }
    global String id {
        get;
        set;
    }
    global String params {
        get;
        set;
    }
    global String sessionToken {
        get;
        set;
    }
    global Map<String,String> ui {
        get;
        set;
    }
    global SalesController() {

    }
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
