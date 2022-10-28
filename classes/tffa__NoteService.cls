/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class NoteService extends tffa.AbstractService {
    global NoteService() {

    }
    @AuraEnabled
    global static List<tffa.NoteDTO> createOrUpdate(List<tffa.NoteDTO> entities) {
        return null;
    }
    global static tffa.NoteDTO read(String noteId) {
        return null;
    }
    @AuraEnabled
    global static List<tffa.NoteDTO> readAllByParticipant(String entityId, Map<String,Object> facts) {
        return null;
    }
    global static tffa__NoteParticipant__c readByParticipant(String noteId, String entityId) {
        return null;
    }
    global static void remove(String noteId) {

    }
    global static void removeByParticipant(List<String> entityIds) {

    }
    global static void updateParticipant(tffa.NoteParticipantDTO participant) {

    }
}
