/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ContentService extends tffa.AbstractService {
    global ContentService() {

    }
    global static ContentVersion createContentWithParticipant(tffa.DocumentMetadataDTO documentMetadata) {
        return null;
    }
    global static List<tffa.DocumentParticipantDTO> createOrUpdateParticipants(List<tffa.DocumentParticipantDTO> participants) {
        return null;
    }
    global static List<ContentVersion> createOrUpdate(List<ContentVersion> contentVersions) {
        return null;
    }
    global static List<tffa.DocumentMetadataDTO> createOrUpdate(List<tffa.DocumentMetadataDTO> documents) {
        return null;
    }
    global static ContentVersion read(String contentDocumentId) {
        return null;
    }
    global static List<tffa.DocumentParticipantDTO> readAllByParticipant(String entityId) {
        return null;
    }
    global static List<tffa.ContentAssetDTO> readAllPublicContentAssets(Map<String,Object> queryParams) {
        return null;
    }
    global static Document readByName(String name) {
        return null;
    }
    global static ContentDocumentLink readByParticipant(String contentDocumentId, String entityId) {
        return null;
    }
    global static tffa.DocumentMetadataDTO readContentMetadata(String contentDocumentId) {
        return null;
    }
    global static List<tffa.ContentAssetDTO> readPublicContentAssetVersions(Map<String,Object> queryParams) {
        return null;
    }
    global static tffa.ContentAssetDTO readPublicContentAsset(Map<String,Object> queryParams) {
        return null;
    }
    global static List<ContentVersion> read(List<String> contentDocumentIds) {
        return null;
    }
    global static List<ContentVersion> read(String entityId, String documentType, String documentSubtype) {
        return null;
    }
    global static void remove(String contentDocumentId) {

    }
    global static void removeByParticipant(List<String> entityIds) {

    }
    global static void removeParticipant(String contentDocumentId, String entityId) {

    }
    global static void remove(Set<String> contentDocumentIds) {

    }
    global static void resolveByParticipant(String entityId, String documentType, String documentSubtype, String participantId) {

    }
    global static void updateParticipant(tffa.DocumentParticipantDTO participant) {

    }
}
