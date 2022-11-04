/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class CSITransactionResponseDTO {
    global tffa.CSITransactionResponseDTO.Envelope Envelope;
    global CSITransactionResponseDTO() {

    }
    global static Map<String,Object> deserializeAsMap(String jsonString) {
        return null;
    }
    global static tffa.CSITransactionResponseDTO parse(String json) {
        return null;
    }
global class Body {
    global tffa.CSITransactionResponseDTO.TransactionResponse TransactionResponse;
    global Body() {

    }
}
global class Envelope {
    global tffa.CSITransactionResponseDTO.Body Body;
    global Envelope() {

    }
}
global class JobStatus {
    global String JobId;
    global String JobManagerUri;
    global String JobServerUri;
    global String NumDocsFail;
    global String NumDocsRenderedComplete;
    global String NumDocsRenderedIncomplete;
    global String NumDocsRequested;
    global String ProcessingState;
    global String TimeOfStateChange;
    global JobStatus() {

    }
}
global class TransactionResponse {
    global tffa.CSITransactionResponseDTO.JobStatus jobStatus;
    global TransactionResponse() {

    }
}
}
