/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class ApplicantRoleDTO extends tffa.AbstractDTO implements System.Comparable {
    global tffa.ApplicantRoleDTO.EntityDTO application;
    global String authority;
    global String category;
    global String code;
    global String description;
    global String id;
    global String label;
    global Integer maximumAllowed;
    global Integer minimumAllowed;
    global String name;
    global List<tffa.ApplicantRoleDTO.EntityDTO> parties;
    global Boolean primary;
    global Boolean required;
    global Integer sortOrder;
    global ApplicantRoleDTO() {

    }
    global ApplicantRoleDTO(tffa__ApplicantRole__c role) {

    }
    global void addParty(tffa__Party__c party) {

    }
    global void setApplication(tffa__Application__c app) {

    }
global virtual class EntityDTO extends tffa.AbstractDTO {
    global String id;
    global String name;
    global EntityDTO() {

    }
}
}
