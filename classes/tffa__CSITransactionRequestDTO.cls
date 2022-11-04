/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class CSITransactionRequestDTO {
    global tffa.CSITransactionRequestDTO.TransactionRequest TransactionRequest;
    global CSITransactionRequestDTO() {

    }
    global static Map<String,Object> deserializeAsMap(String jsonString) {
        return null;
    }
    global static tffa.CSITransactionRequestDTO parse(String json) {
        return null;
    }
global class DataValuesList {
    global tffa.CSITransactionRequestDTO.FileData FileData;
    global DataValuesList() {

    }
}
global class DocList {
    global tffa.CSITransactionRequestDTO.DocSpec DocSpec;
    global DocList() {

    }
}
global class DocSpec {
    global tffa.CSITransactionRequestDTO.FxlList FxlList;
    global String NumberOfCopies;
    global DocSpec() {

    }
}
global class DstFile {
    global tffa.CSITransactionRequestDTO.Pdfproperties pdfproperties;
    global DstFile() {

    }
}
global class FileData {
    global String content;
    global FileData() {

    }
}
global class FxlList {
    global tffa.CSITransactionRequestDTO.FileData FileData;
    global FxlList() {

    }
}
global class JobTicket {
    global String CombinedOutput;
    global tffa.CSITransactionRequestDTO.DataValuesList DataValuesList;
    global tffa.CSITransactionRequestDTO.DocList DocList;
    global String DocumentLibraryVersion;
    global tffa.CSITransactionRequestDTO.DstFile DstFile;
    global String IsDocumentJavaScriptDisabled;
    global tffa.CSITransactionRequestDTO.Prefs Prefs;
    global JobTicket() {

    }
}
global class Pdfproperties {
    global String digitalsignatureprovider;
    global String drawdigitalsignaturefieldas;
    global String embedformfields;
    global Pdfproperties() {

    }
}
global class Prefs {
    global String licenseKeyString;
    global String numberOfCopies;
    global String renderFormat;
    global String reportInPlayDatapoints;
    global String reportOptionalInPlayDatapoints;
    global String reportSuperfluousDatapoints;
    global String returnPartialDocSet;
    global Prefs() {

    }
}
global class TransactionRequest {
    global tffa.CSITransactionRequestDTO.JobTicket jobTicket;
    global TransactionRequest() {

    }
}
}
