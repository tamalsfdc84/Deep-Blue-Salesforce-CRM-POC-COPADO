/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class EventExtension {
    global tffa__EventConfiguration__mdt configuration {
        get;
        set;
    }
    global String eventName {
        get;
        set;
    }
    global EventExtension() {

    }
    global virtual void afterPost(List<SObject> ol) {

    }
    global virtual tffa.NotificationDTO createAppNotification(SObject obj) {
        return null;
    }
    global virtual List<tffa.NotificationDTO> createAppNotifications(List<SObject> ol) {
        return null;
    }
    global virtual tffa.NotificationDTO createEmailNotification(SObject obj) {
        return null;
    }
    global virtual List<tffa.NotificationDTO> createEmailNotifications(List<SObject> ol) {
        return null;
    }
    global virtual List<SObject> fetch(List<SObject> objs) {
        return null;
    }
    global static tffa.EventExtension getInstance() {
        return null;
    }
    global static tffa.EventExtension getInstance(String eventName) {
        return null;
    }
    global virtual Object post(Object obj) {
        return null;
    }
    global virtual Object pre(Object obj) {
        return null;
    }
}
