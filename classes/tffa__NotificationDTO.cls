/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class NotificationDTO extends tffa.AbstractDTO {
    global Map<String,Blob> attachments;
    global List<tffa.NotificationDTO.NotificationRecipientDTO> bccRecipients;
    global List<tffa.NotificationDTO.NotificationRecipientDTO> ccRecipients;
    global Boolean confidential;
    global List<String> entityAttachmentIds;
    global String eventName;
    global Map<String,Object> facts;
    global String orgWideEmailAddress {
        get;
        set;
    }
    global String primaryEntityId;
    global List<tffa.NotificationDTO.NotificationRecipientDTO> recipients;
    global Boolean saveEmailAsActivity;
    global String subtype;
    global String template;
    global NotificationDTO() {

    }
    global void addBCCEmailRecipient(String emails) {

    }
    global void addCCEmailRecipient(String emails) {

    }
    global void addEmailRecipient(String emails) {

    }
    global void addFact(String key, Object value) {

    }
    global void addFacts(Map<String,Object> facts) {

    }
    global void addRecipient(tffa.NotificationDTO.NotificationRecipientDTO recipient) {

    }
    global List<String> getRecipientEmailAddresses() {
        return null;
    }
global class NotificationRecipientDTO {
    global String email;
    global String id;
    global String name;
    global String phone;
    global tffa.NotificationDTO.NotificationRecipientType type;
    global NotificationRecipientDTO(tffa.NotificationDTO.NotificationRecipientType type, String id, String name, String email, String phone) {

    }
}
global enum NotificationRecipientType {PARTY, QUEUE, USER}
}
