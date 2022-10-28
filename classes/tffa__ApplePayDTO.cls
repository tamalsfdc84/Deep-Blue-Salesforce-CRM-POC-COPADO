/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ApplePayDTO {
    global ApplePayDTO() {

    }
global abstract class BaseDTO extends tffa.AbstractDTO {
    global BaseDTO() {

    }
    global virtual tffa.ApplePayDTO.BaseDTO deserialize(String jsonString) {
        return null;
    }
    global virtual String serialize() {
        return null;
    }
}
global class PaymentSessionRequest extends tffa.ApplePayDTO.BaseDTO {
    global String displayName;
    global String initiative;
    global String initiativeContext;
    global String merchantIdentifier;
    global PaymentSessionRequest() {

    }
}
}
