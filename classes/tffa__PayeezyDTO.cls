/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class PayeezyDTO {
    global PayeezyDTO() {

    }
global abstract class BaseDTO extends tffa.AbstractDTO {
    global BaseDTO() {

    }
    global virtual tffa.PayeezyDTO.BaseDTO deserialize(String jsonString) {
        return null;
    }
    global virtual String serialize() {
        return null;
    }
}
global class Card extends tffa.PayeezyDTO.BaseDTO {
    global String card_number;
    global String cardholder_name;
    global String cvv;
    global String exp_date;
    global String type;
    global Card() {

    }
}
global class Error extends tffa.PayeezyDTO.BaseDTO {
    global List<tffa.PayeezyDTO.Message> messages;
    global Error() {

    }
}
global class ErrorResponse extends tffa.PayeezyDTO.BaseDTO {
    global String code;
    global String correlation_id;
    global tffa.PayeezyDTO.Error Error;
    global String message;
    global String transaction_status;
    global String validation_status;
    global ErrorResponse() {

    }
    global String getErrorMessage() {
        return null;
    }
}
global class Message extends tffa.PayeezyDTO.BaseDTO {
    global String code;
    global String description;
    global Message() {

    }
}
global class PaymentFormRequest extends tffa.PayeezyDTO.BaseDTO {
    global String x_address;
    global Decimal x_amount;
    global String x_city;
    global String x_country;
    global String x_currency_code;
    global String x_cust_id;
    global String x_description;
    global String x_fp_hash;
    global Integer x_fp_sequence;
    global Long x_fp_timestamp;
    global String x_login;
    global String x_receipt_link_method;
    global String x_receipt_link_url;
    global String x_reference_3;
    global String x_show_form;
    global String x_state;
    global String x_type;
    global String x_zip;
    global PaymentFormRequest() {

    }
}
global class PaymentFormResponse extends tffa.PayeezyDTO.BaseDTO {
    global String url;
    global PaymentFormResponse() {

    }
}
global class ThreeDomainSecureToken extends tffa.PayeezyDTO.BaseDTO {
    global String data;
    global Map<String,Object> header;
    global String merchantIdentifier;
    global String signature;
    global String type;
    global String version;
    global ThreeDomainSecureToken() {

    }
}
global class Token extends tffa.PayeezyDTO.BaseDTO {
    global tffa.PayeezyDTO.Transarmor token_data;
    global String token_type;
    global Token() {

    }
}
global class TransactionRequest extends tffa.PayeezyDTO.BaseDTO {
    global String amount;
    global String currency_code;
    global String merchant_ref;
    global String method;
    global Boolean recurring;
    global String transaction_id;
    global String transaction_tag;
    global String transaction_type;
    global tffa.PayeezyDTO.ThreeDomainSecureToken x3DS;
    global TransactionRequest() {

    }
}
global class TransactionResponse extends tffa.PayeezyDTO.BaseDTO {
    global String amount;
    global String bank_message;
    global String bank_resp_code;
    global tffa.PayeezyDTO.Card card;
    global String correlation_id;
    global String currencyX;
    global tffa.PayeezyDTO.Error Error;
    global String gateway_message;
    global String gateway_resp_code;
    global String method;
    global tffa.PayeezyDTO.Token token;
    global String transaction_id;
    global String transaction_status;
    global String transaction_tag;
    global String transaction_type;
    global String validation_status;
    global TransactionResponse() {

    }
}
global class Transarmor extends tffa.PayeezyDTO.BaseDTO {
    global String value;
    global Transarmor() {

    }
}
}
