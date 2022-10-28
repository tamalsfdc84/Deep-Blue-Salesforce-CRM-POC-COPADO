/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class AlloyServiceHelper {
    global static String ALLOY;
    global static String BIZCHEX;
    global static String ID_ANALYTICS_CERTAIN_ID;
    global static String ID_ANALYTICS_ID_SCORE;
    global static String IOVATION;
    global static String LEXIS_NEXIS_INSTANT_ID;
    global static String LEXIS_NEXIS_WORLD_COMPLIANCE;
    global static String LT_ALLOY_REVIEW_REASONS;
    global static String LT_BIZCHEX_ORGANIZATION_TYPES;
    global static String LT_ID_ANALYTICS_ID_SCORE_REASON_CODES;
    global static String LT_LEXIS_NEXIS_INSTANT_ID_REASON_CODES;
    global static String LT_SOCURE_30_REASON_CODES;
    global static String MIDDESK;
    global static Map<String,String> OUTCOME_KYC_STATUS_MAP;
    global static Map<String,String> OUTCOME_STATUS_MAP;
    global static String QUALIFILE;
    global static String SKILL_EXTERNAL_KYC_REVIEWER;
    global static String SOCURE_30;
    global static String TAG_BIZCHEX_APPROVE;
    global static String TAG_BIZCHEX_DECLINE;
    global static String TAG_BIZCHEX_REVIEW;
    global static String TAG_DENIED_FRAUD;
    global static String TAG_DEVICE_WARNING;
    global static String TAG_FRAUD_REVIEW;
    global static String TAG_KBA_QUIZ_FAILED;
    global static String TAG_KBA_QUIZ_PASSED;
    global static String TAG_KBA_QUIZ_TIMED_OUT;
    global static String TAG_OFAC_MATCH;
    global static String TAG_PEP_MATCH;
    global static String TAG_QUALIFILE_ACCEPT;
    global static String TAG_QUALIFILE_DECLINE;
    global static String TAG_SOS_FAILURE;
    global static String TAG_SOS_MATCH;
    global AlloyServiceHelper() {

    }
    global void addAddressDetails(tffa.AlloyDTO.EvaluationRequest request, tffa__Address__c address, String type) {

    }
    global void addAddressDetails(tffa.AlloyDTO.Representative rep, tffa__Address__c address, String type) {

    }
    global tffa.DocumentMetadataDTO createResponseDocument(tffa.AlloyDTO.EvaluationResponse response, SObject primaryEntity, SObject relatedEntity) {
        return null;
    }
    global Boolean hasRequiredError(tffa.AlloyDTO.EvaluationResponse response) {
        return null;
    }
    global void parseFraudCheckSources(tffa.AlloyDTO.FraudCheckResults checkResults, List<tffa__DueDiligenceItem__c> items) {

    }
    global tffa__DueDiligenceItem__c parseMatchResult(tffa.AlloyDTO.DataMatchResult matchResult, List<tffa__DueDiligenceItem__c> items, String code, String label, Object data) {
        return null;
    }
    global void parseMatchResults(tffa.AlloyDTO.EvaluationResponse response, List<tffa__DueDiligenceItem__c> items) {

    }
    global void parseModelCodes(tffa.AlloyDTO.CreditRiskModel riskModel, List<tffa__DueDiligenceItem__c> items) {

    }
    global void parseQuestions(tffa.AlloyDTO.QuestionSet questionSet, List<tffa__DueDiligenceItem__c> items, String valueType) {

    }
    global void parseReasonCodes(List<Object> reasonCodes, List<tffa__DueDiligenceItem__c> items, String reasonCodeLookupTable, String tags) {

    }
    global void parseValue(tffa.AlloyDTO.BaseDTO obj, String propertyKey, List<tffa__DueDiligenceItem__c> items, String code, String label) {

    }
    global void parseWatchlistMatches(tffa.AlloyDTO.WatchlistMatchResults matchResults, List<tffa__DueDiligenceItem__c> items) {

    }
    global void populateAddressDetails(tffa.AlloyDTO.Address addressDTO, tffa__Address__c address) {

    }
    global void populateAddressDetails(tffa.AlloyDTO.EvaluationRequest request, tffa__Address__c address) {

    }
    global void populateAnswers(tffa.AlloyDTO.EvaluationRequest request, tffa__DueDiligence__c diligence) {

    }
    global void populateBeneficiaryDetails(tffa.AlloyDTO.EvaluationRequest request, tffa__Beneficiary__c beneficiary) {

    }
    global tffa__DueDiligence__c populateBizChexDetails(tffa__DueDiligence__c diligence, tffa.AlloyDTO.EvaluationResponse response) {
        return null;
    }
    global void populateBusinessDetails(tffa.AlloyDTO.EvaluationRequest request, tffa__Party__c party, String businessTypeLookupTable) {

    }
    global void populateErrorDetails(tffa__Beneficiary__c beneficiary, tffa.AlloyDTO.ErrorResponse response) {

    }
    global void populateErrorDetails(tffa__DueDiligence__c diligence, tffa.AlloyDTO.ErrorResponse response) {

    }
    global void populateEvaluationDetails(tffa__DueDiligence__c diligence, tffa.AlloyDTO.EvaluationResponse response, Boolean includeSummary) {

    }
    global tffa__DueDiligence__c populateFraudDetails(tffa__DueDiligence__c diligence, tffa.AlloyDTO.EvaluationResponse response) {
        return null;
    }
    global tffa__DueDiligence__c populateIDADetails(tffa__DueDiligence__c diligence, tffa.AlloyDTO.EvaluationResponse response) {
        return null;
    }
    global tffa__DueDiligence__c populateIDADetails(tffa__DueDiligence__c diligence, tffa.AlloyDTO.EvaluationResponse response, String service) {
        return null;
    }
    global tffa__DueDiligence__c populateIovationDetails(tffa__DueDiligence__c diligence, tffa.AlloyDTO.EvaluationResponse response) {
        return null;
    }
    global void populateKYCDetails(tffa__Party__c party, tffa.AlloyDTO.EvaluationResponse response) {

    }
    global tffa__DueDiligence__c populateOFACDetails(tffa__DueDiligence__c diligence, tffa.AlloyDTO.EvaluationResponse response) {
        return null;
    }
    global void populateOFACDetails(tffa__Beneficiary__c beneficiary, tffa.AlloyDTO.EvaluationResponse response) {

    }
    global void populatePersonDetails(tffa.AlloyDTO.EvaluationRequest request, tffa__Party__c party) {

    }
    global void populatePersonDetails(tffa.AlloyDTO.Representative rep, tffa__Party__c party) {

    }
    global tffa__DueDiligence__c populateQualiFileDetails(tffa__DueDiligence__c diligence, tffa.AlloyDTO.EvaluationResponse response) {
        return null;
    }
    global tffa__DueDiligence__c populateQuestionDetails(tffa__DueDiligence__c diligence, tffa.AlloyDTO.EvaluationResponse response) {
        return null;
    }
    global void populateRequiredErrorDetails(tffa__Beneficiary__c beneficiary, tffa.AlloyDTO.EvaluationResponse response) {

    }
    global void populateRequiredErrorDetails(tffa__DueDiligence__c diligence, tffa.AlloyDTO.EvaluationResponse response) {

    }
    global void populateReviewDetails(tffa__DueDiligence__c diligence, tffa.AlloyDTO.EntityReview review) {

    }
    global void populateServiceErrorDetails(tffa__DueDiligence__c diligence, tffa.AlloyDTO.EvaluationResponse response, String service) {

    }
    global void populateSubmissionDetails(tffa.AlloyDTO.EvaluationRequest request, tffa__Submission__c sub) {

    }
}
