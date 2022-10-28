/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class AbstractIdentityProvider {
    global AbstractIdentityProvider() {

    }
    global virtual Object doFetchUserInfo(tffa__SessionInformation__c sessionInfo, Map<String,Object> facts) {
        return null;
    }
    global virtual tffa__SessionInformation__c doFetch(Map<String,Object> facts) {
        return null;
    }
    global virtual tffa__SessionInformation__c doRefresh(tffa__SessionInformation__c sessionInfo, Map<String,Object> facts) {
        return null;
    }
    global virtual Map<String,String> fetchToken(Map<String,Object> facts) {
        return null;
    }
    global virtual Object fetchUserInfo(Map<String,Object> facts) {
        return null;
    }
    global virtual tffa__SessionInformation__c fetch(Map<String,Object> facts) {
        return null;
    }
    global static tffa.AbstractIdentityProvider getInstance(String name) {
        return null;
    }
    global virtual String getKey(Map<String,Object> facts) {
        return null;
    }
    global virtual tffa__SessionInformation__c readToken(Map<String,Object> facts) {
        return null;
    }
    global virtual Map<String,String> refreshToken(Map<String,Object> facts) {
        return null;
    }
    global virtual tffa__SessionInformation__c refresh(tffa__SessionInformation__c sessionInfo, Map<String,Object> facts) {
        return null;
    }
    global virtual Boolean requiresRefresh(tffa__SessionInformation__c sessionInfo) {
        return null;
    }
    global virtual tffa__SessionInformation__c saveToken(Map<String,String> facts) {
        return null;
    }
}
