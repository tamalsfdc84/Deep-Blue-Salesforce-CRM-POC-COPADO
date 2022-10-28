/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class PlaidAssetRequestDTO {
    global List<String> accessTokens {
        get;
    }
    global String assetReportToken {
        get;
        set;
    }
    global String clientId {
        get;
        set;
    }
    global Integer daysRequested {
        get;
        set;
    }
    global tffa.PlaidAssetRequestDTO.AssetOptions options {
        get;
        set;
    }
    global String secret {
        get;
        set;
    }
    global PlaidAssetRequestDTO() {

    }
    global static String serialize(tffa.PlaidAssetRequestDTO dto) {
        return null;
    }
    global void setAccessTokens(String value) {

    }
global class AssetOptions {
    global String clientReportId {
        get;
        set;
    }
    global tffa.PlaidAssetRequestDTO.User user {
        get;
        set;
    }
    global String webhook {
        get;
        set;
    }
    global AssetOptions() {

    }
}
global class User {
    global String clientUserId {
        get;
        set;
    }
    global String email {
        get;
        set;
    }
    global String firstName {
        get;
        set;
    }
    global String lastName {
        get;
        set;
    }
    global String middleName {
        get;
        set;
    }
    global String phoneNumber {
        get;
        set;
    }
    global String ssn {
        get;
        set;
    }
    global User() {

    }
}
}
