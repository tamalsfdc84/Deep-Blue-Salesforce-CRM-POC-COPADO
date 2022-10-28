/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class DocumentParticipantDTO extends tffa.AbstractDTO {
    global String contentDocumentId;
    global String contentDocumentType;
    global Integer contentSize;
    global String contentSizeKB;
    global String documentSubtype;
    global String documentType;
    global SObject entity;
    global Id entityId {
        get;
        set;
    }
    global String entityType;
    global String fileExtension;
    global String fileType;
    global String icon;
    global String name;
    global DocumentParticipantDTO(SObject entity) {

    }
    global DocumentParticipantDTO(String contentDocumentId, Id entityId) {

    }
    global DocumentParticipantDTO(String contentDocumentId, SObject entity) {

    }
    global DocumentParticipantDTO(String contentDocumentId, Id entityId, String entityType) {

    }
}
