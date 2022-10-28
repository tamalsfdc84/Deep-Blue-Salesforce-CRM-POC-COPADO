/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ApplicationAssignmentDTO {
    global ApplicationAssignmentDTO() {

    }
global class Request extends tffa.AbstractDTO {
    @InvocableVariable(label='Application' description='Application to assign. Can be used to support single application assignment in flows.' required=false)
    global tffa__Application__c application;
    @InvocableVariable(label='Applications' description='List of applications to assign.' required=false)
    global List<tffa__Application__c> applications;
    @InvocableVariable(label='Assignee Id' description='Unique identifier of the assignee. This is not required when assignee type is AUTO.' required=false)
    global String assigneeId;
    @InvocableVariable(label='Assignee Type' description='Type of assignee. Supported - USER, QUEUE, AUTO' required=true)
    global String assigneeType;
    @InvocableVariable(label='Purpose' description='Purpose (or reason) of assignment. Can be used to drive additional behaviour.' required=false)
    global String purpose;
    global Request() {

    }
}
global class Response extends tffa.AbstractDTO {
    @InvocableVariable(label='Application' description='Assigned application. Populated if request contains one application.' required=false)
    global tffa__Application__c application;
    @InvocableVariable(label='Applications' description='List of assigned applications.' required=false)
    global List<tffa__Application__c> applications;
    global Response() {

    }
}
}
