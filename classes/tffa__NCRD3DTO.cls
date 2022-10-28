/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class NCRD3DTO {
    global static String INDIVIDUAL_PARTY;
    global static String PRIMARY_EMAIL;
    global NCRD3DTO() {

    }
    global static tffa.NCRD3DTO.UserRequestDTO parseRequest(String json) {
        return null;
    }
    global static tffa.NCRD3DTO.UserResponseDTO parseResponse(String json) {
        return null;
    }
    global static tffa.NCRD3DTO.UserRequestDTO toUserRequestDTO(tffa__Submission__c sub, tffa__Party__c party) {
        return null;
    }
global class Address {
    global String city;
    global String countryCode;
    global Integer latitude;
    global String line1;
    global String line2;
    global String line3;
    global String line4;
    global String postalCode;
    global String state;
    global Address() {

    }
}
global class UserRequestDTO {
    global String altEmail;
    global String emailType;
    global String firstName;
    global String hostId;
    global String lastName;
    global String loginId;
    global tffa.NCRD3DTO.Address mailingAddress;
    global Boolean mfa;
    global tffa.NCRD3DTO.Address physicalAddress;
    global String primaryEmail;
    global String primaryPhone;
    global String profileType;
    global String referenceId;
    global String sourceCompanyId;
    global UserRequestDTO() {

    }
}
global class UserResponseDTO {
    global String accountNumber;
    global String error;
    global String loginId;
    global Boolean valid;
    global UserResponseDTO() {

    }
}
}
