/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class WKFSDocumentRequestDTO {
    global tffa.WKFSDocumentRequestDTO.Generate generate;
    global WKFSDocumentRequestDTO() {

    }
    global static tffa.WKFSDocumentRequestDTO parse(String json) {
        return null;
    }
global class AncillaryOutput {
    global tffa.WKFSDocumentRequestDTO.ESignatureAndFieldSupport eSignatureAndFieldSupport;
    global String outputType;
    global AncillaryOutput() {

    }
}
global class ESignatureAndFieldSupport {
    global Boolean eSignatureCoordinatesOnly;
    global Boolean eSignatureDateSupport;
    global ESignatureAndFieldSupport() {

    }
}
global class EZConfig {
    global String mergeEZConfig;
    global String orgAlias;
    global String orgLOB;
    global String orgName;
    global List<String> productNames;
    global EZConfig() {

    }
}
global class Generate {
    global tffa.WKFSDocumentRequestDTO.Request request;
    global Generate() {

    }
}
global class Request {
    global List<tffa.WKFSDocumentRequestDTO.AncillaryOutput> ancillaryOutput;
    global String contentIdentifier;
    global Integer daysToExpire;
    global String documentFormat;
    global tffa.WKFSDocumentRequestDTO.EZConfig ezConfig;
    global String passthroughIdentifier;
    global String transactionData;
    global Request() {

    }
}
}
