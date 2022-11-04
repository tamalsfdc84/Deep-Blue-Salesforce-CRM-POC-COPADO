/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class PlaidBankTransferDTO {
    global PlaidBankTransferDTO() {

    }
global class BankFailureReason {
    global String ach_return_code;
    global String description;
    global BankFailureReason() {

    }
}
global class BankTransfer {
    global String account_id;
    global String ach_class;
    global String amount;
    global Boolean cancellable;
    global String created;
    global String custom_tag;
    global String description;
    global String direction;
    global tffa.PlaidBankTransferDTO.BankFailureReason failure_reason;
    global String id;
    global String iso_currency_code;
    global Map<String,String> metadata;
    global String network;
    global String origination_account_id;
    global String status;
    global String type;
    global tffa.PlaidBankTransferDTO.User user;
    global BankTransfer() {

    }
}
global class BankTransferCreateRequest extends tffa.PlaidBankTransferDTO.BaseDTO {
    global String access_token;
    global String account_id;
    global String ach_class;
    global String amount;
    global String client_id;
    global String custom_tag;
    global String description;
    global String idempotency_key;
    global String iso_currency_code;
    global Map<String,String> metadata;
    global String network;
    global String origination_account_id;
    global String secret;
    global String type;
    global tffa.PlaidBankTransferDTO.User user;
    global BankTransferCreateRequest() {

    }
}
global class BankTransferCreateResponse extends tffa.PlaidBankTransferDTO.ResponseDTO {
    global tffa.PlaidBankTransferDTO.BankTransfer bank_transfer;
    global BankTransferCreateResponse() {

    }
}
global class BankTransferEvent {
    global String account_id;
    global String bank_transfer_amount;
    global String bank_transfer_id;
    global String bank_transfer_iso_currency_code;
    global String bank_transfer_type;
    global String direction;
    global Integer event_id;
    global String event_type;
    global tffa.PlaidBankTransferDTO.BankFailureReason failure_reason;
    global String origination_account_id;
    global tffa.PlaidBankTransferDTO.ReceiverDetails receiver_details;
    global String timestamp;
    global BankTransferEvent() {

    }
}
global class BankTransferEventListRequest extends tffa.PlaidBankTransferDTO.BaseDTO {
    global String account_id;
    global Integer after_id;
    global String bank_transfer_id;
    global String bank_transfer_type;
    global String client_id;
    global Integer count;
    global String direction;
    global String end_date;
    global String event_types;
    global Integer offset;
    global String origination_account_id;
    global String secret;
    global String start_date;
    global BankTransferEventListRequest() {

    }
}
global class BankTransferEventListResponse extends tffa.PlaidBankTransferDTO.ResponseDTO {
    global List<tffa.PlaidBankTransferDTO.BankTransferEvent> bank_transfer_events;
    global BankTransferEventListResponse() {

    }
}
global class BankTransferGetResponse extends tffa.PlaidBankTransferDTO.ResponseDTO {
    global tffa.PlaidBankTransferDTO.BankTransfer bank_transfer;
    global BankTransferGetResponse() {

    }
}
global class BankTransferListRequest extends tffa.PlaidBankTransferDTO.BaseDTO {
    global String client_id;
    global Integer count;
    global String direction;
    global String end_date;
    global Integer offset;
    global String origination_account_id;
    global String secret;
    global String start_date;
    global BankTransferListRequest() {

    }
}
global class BankTransferListResponse extends tffa.PlaidBankTransferDTO.ResponseDTO {
    global List<tffa.PlaidBankTransferDTO.BankTransfer> bank_transfers;
    global BankTransferListResponse() {

    }
}
global abstract class BaseDTO extends tffa.AbstractDTO {
    global BaseDTO() {

    }
    global virtual tffa.PlaidBankTransferDTO.BaseDTO deserialize(String jsonString) {
        return null;
    }
    global virtual System.Type getClass() {
        return null;
    }
    global virtual String serialize() {
        return null;
    }
}
global class ReceiverDetails {
    global String available_balance;
    global ReceiverDetails() {

    }
}
global abstract class ResponseDTO extends tffa.PlaidBankTransferDTO.BaseDTO {
    global List<String> causes;
    global String display_message;
    global String documentation_url;
    global String error_code;
    global String error_message;
    global String error_type;
    global String request_id;
    global Integer status;
    global String suggested_action;
    global ResponseDTO() {

    }
}
global class User {
    global String email_address;
    global String legal_name;
    global String routing_number;
    global User() {

    }
}
}
