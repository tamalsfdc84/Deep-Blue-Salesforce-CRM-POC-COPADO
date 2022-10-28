/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class NoteDTO extends tffa.AbstractDTO {
    @AuraEnabled
    global Blob content;
    @AuraEnabled
    global String createdBy;
    @AuraEnabled
    global Datetime createdDate;
    @AuraEnabled
    global Id entityId;
    @AuraEnabled
    global String id;
    @AuraEnabled
    global String noteContent;
    global List<tffa.NoteParticipantDTO> participants;
    @AuraEnabled
    global Id senderId;
    @AuraEnabled
    global String senderName;
    global List<String> tags;
    @AuraEnabled
    global String title;
    global NoteDTO(String title, Blob content) {

    }
    global NoteDTO(String title, String noteContent) {

    }
    global NoteDTO(String title, Blob content, Id entityId) {

    }
    global NoteDTO(String title, String noteContent, Id entityId) {

    }
    global NoteDTO(String title, String noteContent, Id entityId, String parentId, String parentEntityType) {

    }
}
