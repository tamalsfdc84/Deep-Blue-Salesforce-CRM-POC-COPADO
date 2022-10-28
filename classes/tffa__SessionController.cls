/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class SessionController extends tffa.AbstractController implements tffa.IController {
    global SessionController(tffa.IController p) {

    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response expireSession(tffa.Context ctx) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response extendSession(tffa.Context ctx) {
        return null;
    }
    @RemoteAction
    global static tffa.Response verifySession(tffa.Context ctx, Map<String,Object> facts) {
        return null;
    }
}
