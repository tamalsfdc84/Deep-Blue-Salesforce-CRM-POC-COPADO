/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class ApplicationAssigner {
    global ApplicationAssigner() {

    }
    global virtual List<tffa__Application__c> assignToQueue(List<tffa__Application__c> apps, String queueId, Map<String,Object> facts) {
        return null;
    }
    global virtual List<tffa__Application__c> assignToUser(List<tffa__Application__c> apps, String userId, Map<String,Object> facts) {
        return null;
    }
    @InvocableMethod(label='Assign Application' description='Assigns the applications to the specified assignee. In case assigneeType is AUTO, the assignment happens as per internal rules configured.')
    global static List<tffa.ApplicationAssignmentDTO.Response> assign(List<tffa.ApplicationAssignmentDTO.Request> requests) {
        return null;
    }
    global virtual List<tffa__Application__c> assign(List<tffa__Application__c> apps) {
        return null;
    }
    global virtual List<tffa__Application__c> assign(List<tffa__Application__c> apps, Map<String,Object> facts) {
        return null;
    }
}
