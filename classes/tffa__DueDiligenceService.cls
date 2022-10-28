/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class DueDiligenceService extends tffa.AbstractService {
    global static String ITEM_GROUP_MATCHED_DATA;
    global static String ITEM_GROUP_REASON_CODES;
    global static String ITEM_GROUP_WATCH_LISTS;
    global static String ITEM_TYPE_QUESTION;
    global static String ITEM_TYPE_RESPONSE;
    global static String STATUS_DECLINED;
    global static String STATUS_EXPIRED;
    global static String STATUS_FAILED;
    global static String STATUS_IN_PROGRESS;
    global static String STATUS_PASSED;
    global static String STATUS_REVIEW;
    global DueDiligenceService() {

    }
    global static List<tffa__DueDiligence__c> createOrUpdate(List<tffa__DueDiligence__c> entities, Map<String,Object> params) {
        return null;
    }
    global static List<tffa__DueDiligence__c> createOrUpdate(String parentId, List<tffa__DueDiligence__c> entities) {
        return null;
    }
    global static List<tffa__DueDiligence__c> readAll(tffa.QueryContext queryCtx) {
        return null;
    }
    global static List<tffa__DueDiligence__c> readByPartyAndType(String partyId, String ddType) {
        return null;
    }
    global static tffa__DueDiligence__c refreshStatus(tffa__DueDiligence__c diligence, Map<String,Object> params) {
        return null;
    }
    global static void rollupDetails(tffa__Party__c party, tffa__DueDiligence__c diligence) {

    }
    global static tffa__DueDiligence__c updateStatus(tffa__DueDiligence__c dueDiligence) {
        return null;
    }
    global static List<tffa__DueDiligence__c> updateStatus(List<tffa__DueDiligence__c> dueDiligences, Map<String,Object> facts) {
        return null;
    }
    global static List<tffa__Beneficiary__c> verify(List<tffa__Beneficiary__c> beneficiaries, Map<String,Object> facts) {
        return null;
    }
    global static List<tffa__DueDiligence__c> verify(tffa__Party__c party, Map<String,Object> facts) {
        return null;
    }
    global static List<tffa__Party__c> verify(List<tffa__Party__c> parties, Map<String,Object> facts) {
        return null;
    }
}
