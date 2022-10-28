/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class AlloyService {
    global static String ALLOY_APPLICATION_VERSION;
    global static String ALLOY_BYPASS_FORMATTER;
    global static String ALLOY_ENTITY_TOKEN;
    global static String ALLOY_EXTERNAL_ENTITY_ID;
    global static String ALLOY_EXTERNAL_GROUP_ID;
    global static String ALLOY_REFRESH_CACHE;
    global static String X_ALLOY_CLIENT_ID;
    global AlloyService() {

    }
    global AlloyService(String credentialName) {

    }
    global tffa.AlloyDTO.Document createDocumentMetadata(tffa.AlloyDTO.Document request) {
        return null;
    }
    global tffa.AlloyDTO.Note createDocumentNote(tffa.AlloyDTO.Note request) {
        return null;
    }
    global tffa.AlloyDTO.Note createEntityNote(tffa.AlloyDTO.Note request) {
        return null;
    }
    global tffa.AlloyDTO.EntityReview createEntityReview(tffa.AlloyDTO.EntityReview request) {
        return null;
    }
    global tffa.AlloyDTO.Note createEntityReviewNote(tffa.AlloyDTO.Note request) {
        return null;
    }
    global tffa.AlloyDTO.EvaluationResponse createEvaluation(tffa.AlloyDTO.EvaluationRequest request) {
        return null;
    }
    global tffa.AlloyDTO.WebhookAlert parseAndValidateWebhookAlert(String requestBody, Map<String,String> headers) {
        return null;
    }
    global tffa.AlloyDTO.Entity patchEntity(tffa.AlloyDTO.Entity request) {
        return null;
    }
    global tffa.AlloyDTO.EvaluationResponse patchEvaluation(tffa.AlloyDTO.EvaluationRequest request) {
        return null;
    }
    global tffa.AlloyDTO.Document readDocument(String entityToken, String documentToken) {
        return null;
    }
    global List<tffa.AlloyDTO.Document> readDocuments(String entityToken) {
        return null;
    }
    global tffa.AlloyDTO.Entity readEntity(String entityToken) {
        return null;
    }
    global tffa.AlloyDTO.EntityReview readEntityReview(String entityToken, String reviewToken) {
        return null;
    }
    global List<tffa.AlloyDTO.EntityReview> readEntityReviews(String entityToken) {
        return null;
    }
    global tffa.AlloyDTO.EvaluationResponse readEvaluation(String entityToken, String evaluationToken) {
        return null;
    }
    global void setBypassFormatter(Boolean value) {

    }
    global void setRefreshCache(Boolean value) {

    }
    global tffa.AlloyDTO.Document updateDocumentMetadata(tffa.AlloyDTO.Document request) {
        return null;
    }
    global tffa.AlloyDTO.Document uploadDocument(tffa.AlloyDTO.Document request) {
        return null;
    }
global class AlloyException extends Exception {
    global AlloyException(String message, Exception cause, tffa.AlloyDTO.ErrorResponse response) {

    }
    global tffa.AlloyDTO.ErrorResponse getResponse() {
        return null;
    }
}
}
