/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class SubmissionController extends tffa.AbstractController implements tffa.IController {
    global SubmissionController(ApexPages.StandardController standardController) {

    }
    global SubmissionController(tffa.IController p) {

    }
    @AuraEnabled
    global static tffa.Response abandon(tffa.Context ctx, String id) {
        return null;
    }
    global static tffa.Response cancel(tffa.Context ctx) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response cancel(tffa.Context ctx, String subJson) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response createOrUpdateDisclosureEnvelopes(tffa.Context ctx, String listJson, Map<String,Object> facts) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response createOrUpdateDisclosures(tffa.Context ctx, String listJson) {
        return null;
    }
    @RemoteAction
    global static tffa.Response createOrUpdateFinancialNeeds(tffa.Context ctx, String listJson) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response createOrUpdateParties(tffa.Context ctx, String partyJson) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response createOrUpdateStipulations(tffa.Context ctx, String listJson) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response deliverDisclosures(tffa.Context ctx, String disclosureJson, String factsJson) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response doDecision(tffa.Context ctx, String factsJson) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response edit(tffa.Context ctx, String subJson) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response fetchApplicationStatus(tffa.Context ctx, Id id) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response fetchCombinedESignUrl(tffa.Context ctx, String factsJson) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response fetchDisclosureStatus(tffa.Context ctx, String disclosureJson, String factsJson) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response fetchDisclosures(tffa.Context ctx, Map<String,Object> facts) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response fetchESignUrl(tffa.Context ctx, String disclosureJson, String factsJson) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response fetchESignUrlForDocument(tffa.Context ctx, String disclosureJson, String factsJson) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response fetchExternalDisclosures(tffa.Context ctx, String factsJson) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response fetchFundingOptions(tffa.Context ctx) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response fetchOffers(tffa.Context ctx, Map<String,Object> params) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response generateAccountNumbers(tffa.Context ctx, String factsJson) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response generateDisclosures(tffa.Context ctx, String factsJson) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response generateEnvelope(tffa.Context ctx, Map<String,Object> facts) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response generateEnvelopes(tffa.Context ctx, String listJson, Map<String,Object> facts) {
        return null;
    }
    @AuraEnabled
    global static tffa.Response generateLink(tffa.Context ctx, Map<String,Object> facts) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response generateSigningURL(tffa.Context ctx, Map<String,Object> facts) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response initializeDocumentSigning(tffa.Context ctx) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response modify(tffa.Context ctx, String subJson) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response onEvent(tffa.Context ctx, Object o) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response process(tffa.Context ctx, String factsJson) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response read(tffa.Context ctx) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response readAllAdditionalPreferences(tffa.Context ctx, Map<String,Object> queryParams) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response readAllApplications(tffa.Context ctx, Map<String,Object> queryParams) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response readAllDisclosures(tffa.Context ctx, Map<String,Object> queryParams) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response readAllEligibilities(tffa.Context ctx, Map<String,Object> queryParams) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response readAllParties(tffa.Context ctx, Map<String,Object> queryParams) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response readAllStipulations(tffa.Context ctx, Map<String,Object> queryParams) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response readAll(tffa.Context ctx, Map<String,Object> queryParams) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response readApplication(tffa.Context ctx, String id) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response readWithParams(tffa.Context ctx, String factsJson) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response remindApplicants(tffa.Context ctx, Map<String,Object> facts) {
        return null;
    }
    @AuraEnabled
    global static tffa.Response reopen(tffa.Context ctx, String subJson) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response resolveAddOnServices(tffa.Context ctx, String factsJson) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response resolveDeclarations(tffa.Context ctx, String factsJson) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response resolveDisclosures(tffa.Context ctx, String factsJson) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response resolveEligibilities(tffa.Context ctx, String factsJson) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response resolveExpectedActivities(tffa.Context ctx, String factsJson) {
        return null;
    }
    @RemoteAction
    global static tffa.Response resolveFinancialNeeds(tffa.Context ctx, Map<String,Object> facts) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response resolveFundingOptions(tffa.Context ctx, String factsJson) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response resolveName(tffa.Context ctx, Map<String,Object> params) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response resolveRecommendations(tffa.Context ctx, String factsJson) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response resolveStipulations(tffa.Context ctx, String factsJson) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response resume(tffa.Context ctx, Map<String,Object> request) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response save(tffa.Context ctx, String subJson) {
        return null;
    }
    @AuraEnabled
    global static tffa.Response start(tffa.Context ctx, Map<String,Object> facts) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response submit(tffa.Context ctx) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response updateApplicationStatus(tffa.Context ctx, String appJson) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response updateDecision(tffa.Context ctx, String subJson, String factsJson) {
        return null;
    }
    @RemoteAction
    global static tffa.Response updateFinancialNeedStatus(tffa.Context ctx, String entityJson) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response updateFundingStatus(tffa.Context ctx, String fundingRequestJson) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response updateRecommendationStatus(tffa.Context ctx, String listJson) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response validate(tffa.Context ctx, String factsJson) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response validateProducts(tffa.Context ctx, Map<String,Object> facts) {
        return null;
    }
}
