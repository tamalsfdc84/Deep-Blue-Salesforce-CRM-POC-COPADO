/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class NoteParticipantDTO extends tffa.AbstractDTO {
    global String contentDocumentId;
    global String documentType;
    global SObject entity;
    global Id entityId {
        get;
        set;
    }
    @AuraEnabled
    global String entityType;
    global String fileType;
    @AuraEnabled
    global String name;
    @AuraEnabled
    global String noteId;
    global NoteParticipantDTO(SObject entity) {

    }
    global NoteParticipantDTO(String noteId, Id entityId) {

    }
    global NoteParticipantDTO(String noteId, Id entityId, String entityType) {

    }
}
