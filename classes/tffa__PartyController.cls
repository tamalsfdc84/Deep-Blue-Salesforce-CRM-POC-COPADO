/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class PartyController extends tffa.AbstractController implements tffa.IController {
    global PartyController(tffa.IController p) {

    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response authenticate(tffa.Context ctx, Map<String,Object> params) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response createAssetReport(tffa.Context ctx, String partyJson, Map<String,Object> params) {
        return null;
    }
    @RemoteAction
    global static tffa.Response createOrUpdateAssets(tffa.Context ctx, String id, String listJson) {
        return null;
    }
    @RemoteAction
    global static tffa.Response createOrUpdateFinancialStatements(tffa.Context ctx, String id, String listJson) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response createOrUpdatePartyRelationships(tffa.Context ctx, String listJson) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response doDueDiligence(tffa.Context ctx, String partyJson, String factsJson) {
        return null;
    }
    @RemoteAction
    global static tffa.Response fetchAccountingSystems(tffa.Context ctx, String id, Map<String,Object> params) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response fetchAccounts(tffa.Context ctx, Map<String,Object> params) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response fetchDetails(tffa.Context ctx, Map<String,Object> params) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response fetchExternalAccountsForFunding(tffa.Context ctx, Map<String,Object> params) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response fetchExternalAssetsAndLiabilities(tffa.Context ctx, Map<String,Object> params) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response fetchExternalIncomesAndExpenses(tffa.Context ctx, Map<String,Object> params) {
        return null;
    }
    @RemoteAction
    global static tffa.Response fetchFinancialStatements(tffa.Context ctx, String id, Map<String,Object> params) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response generateOTP(tffa.Context ctx, Map<String,Object> facts) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response initializeAuthentication(tffa.Context ctx, Map<String,Object> params) {
        return null;
    }
    @RemoteAction
    global static tffa.Response initializeExternalAccountSource(tffa.Context ctx, String paramsJson) {
        return null;
    }
    @RemoteAction
    global static tffa.Response initializeIncomeSource(tffa.Context ctx, Map<String,Object> params) {
        return null;
    }
    @RemoteAction
    global static tffa.Response linkAccountingSystem(tffa.Context ctx, String id, Map<String,Object> params) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response parseIdentityDocument(tffa.Context ctx, Map<String,Object> params) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response read(tffa.Context ctx, String id) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response readAddresses(tffa.Context ctx, Map<String,Object> queryParams) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response readAllAssets(tffa.Context ctx, Map<String,Object> queryParams) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response readAllDueDiligences(tffa.Context ctx, Map<String,Object> queryParams) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response readAllPartyAssetRelationships(tffa.Context ctx, Map<String,Object> queryParams) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response readAllPartyRelationships(tffa.Context ctx, Map<String,Object> queryParams) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response registerOnlineBankingUserId(tffa.Context ctx, Map<String,Object> facts) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response search(tffa.Context ctx, Map<String,Object> params) {
        return null;
    }
    @RemoteAction
    global static tffa.Response unlinkAccountingSystem(tffa.Context ctx, String id, Map<String,Object> params) {
        return null;
    }
    @AuraEnabled
    global static tffa.Response unlockOTP(tffa.Context ctx, String factsJson) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response updateDueDiligenceStatus(tffa.Context ctx, String dueDiligencesJson) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response validateOTP(tffa.Context ctx, Map<String,Object> facts) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response validateOnlineBankingUserId(tffa.Context ctx, Map<String,Object> facts) {
        return null;
    }
    @AuraEnabled
    @RemoteAction
    global static tffa.Response verify(tffa.Context ctx, String partyJson, String factsJson) {
        return null;
    }
}
