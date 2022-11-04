/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class CSISessionResponseDTO {
    global tffa.CSISessionResponseDTO.RuntimeDataCollectionStatus runtimeDataCollectionStatus;
    global tffa.CSISessionResponseDTO.Session session;
    global String transactionData;
    global String url;
    global CSISessionResponseDTO() {

    }
    global static tffa.CSISessionResponseDTO parse(String json) {
        return null;
    }
global class Reasons {
    global Boolean dslComplete;
    global Boolean rmdComplete;
    global Boolean transactionDataComplete;
    global Reasons() {

    }
}
global class RuntimeDataCollectionStatus {
    global Boolean dataCollectionAvailable;
    global Boolean dataCollectionRequired;
    global tffa.CSISessionResponseDTO.Reasons reasons;
    global RuntimeDataCollectionStatus() {

    }
}
global class Session {
    global String id;
    global Session() {

    }
}
}
