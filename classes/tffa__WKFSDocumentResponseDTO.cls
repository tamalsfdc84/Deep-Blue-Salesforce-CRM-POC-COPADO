/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class WKFSDocumentResponseDTO {
    global tffa.WKFSDocumentResponseDTO.GenerateResultsResponse generateResultsResponse;
    global WKFSDocumentResponseDTO() {

    }
    global static tffa.WKFSDocumentResponseDTO parse(String json) {
        return null;
    }
    global static String toDebugString(String json, Boolean includeContent) {
        return null;
    }
global class DiscreteParties {
    global List<tffa.WKFSDocumentResponseDTO.DiscreteParty> discreteParty;
    global DiscreteParties() {

    }
}
global class DiscreteParty {
    global String accountNumber;
    global String id;
    global DiscreteParty() {

    }
}
global class DiscretePartyIDs {
    global List<String> discretePartyID;
    global DiscretePartyIDs() {

    }
}
global class DocCustomDataItem {
    global DocCustomDataItem() {

    }
}
global class DocData {
    global String base64;
    global DocData() {

    }
}
global class DocDescriptor {
    global List<tffa.WKFSDocumentResponseDTO.DocCustomDataItem> docCustomDataItems;
    global String docDisplayName;
    global String docID;
    global Boolean docRequiresSignature;
    global String docRootEntityName;
    global String docType;
    global Boolean negotiableInstrumentFlag;
    global Boolean recordableFlag;
    global DocDescriptor() {

    }
}
global class DocInstance {
    global tffa.WKFSDocumentResponseDTO.DiscreteParties discreteParties;
    global tffa.WKFSDocumentResponseDTO.DiscretePartyIDs discretePartyIDs;
    global tffa.WKFSDocumentResponseDTO.DocData docData;
    global String docFormat;
    global String docIDRef;
    global String instanceBarcodeValue;
    global String instanceDisplayName;
    global String instanceFileName;
    global tffa.WKFSDocumentResponseDTO.InstanceFormattingMetadata instanceFormattingMetadata;
    global Integer instancePageCount;
    global String instancePageSize;
    global Boolean instanceRecordableFlag;
    global tffa.WKFSDocumentResponseDTO.SignaturePointSet signaturePointSet;
    global DocInstance() {

    }
}
global class Documents {
    global String docSetPackageIDRef;
    global List<tffa.WKFSDocumentResponseDTO.PackageDoc> packageDocs;
    global List<tffa.WKFSDocumentResponseDTO.Packet> packet;
    global Documents() {

    }
}
global class GenerateResultsResponse {
    global tffa.WKFSDocumentResponseDTO.GetGenerateResultsResult getGenerateResultsResult;
    global GenerateResultsResponse() {

    }
}
global class GetGenerateResultsResult {
    global tffa.WKFSDocumentResponseDTO.Documents documents;
    global String passthroughIdentifier;
    global String status;
    global String statusDescription;
    global String transactionIdentifier;
    global GetGenerateResultsResult() {

    }
}
global class InstanceFormattingMetadata {
    global String instanceSigningInstructions;
    global InstanceFormattingMetadata() {

    }
}
global class PackageDoc {
    global tffa.WKFSDocumentResponseDTO.DocDescriptor docDescriptor;
    global PackageDoc() {

    }
}
global class Packet {
    global List<tffa.WKFSDocumentResponseDTO.DocInstance> docInstances;
    global String packetFileName;
    global String packetName;
    global Packet() {

    }
}
global class SignaturePoint {
    global String fieldName;
    global Decimal height;
    global Boolean includeDate;
    global Integer pageNumber;
    global String pageOrder;
    global Integer sequencing;
    global Boolean signatureRequired;
    global String signatureText;
    global String type;
    global Decimal width;
    global Decimal xCoordinate;
    global Decimal yCoordinate;
    global SignaturePoint() {

    }
}
global class SignaturePointSet {
    global List<tffa.WKFSDocumentResponseDTO.Signer> signer;
    global SignaturePointSet() {

    }
}
global class SignaturePoints {
    global List<tffa.WKFSDocumentResponseDTO.SignaturePoint> signaturePoint;
    global SignaturePoints() {

    }
}
global class Signer {
    global String description;
    global String id;
    global tffa.WKFSDocumentResponseDTO.SignaturePoints signaturePoints;
    global String signerEmail;
    global Signer() {

    }
}
}
