/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class CSIDocumentResponseDTO {
    global tffa.CSIDocumentResponseDTO.Envelope Envelope;
    global CSIDocumentResponseDTO() {

    }
    global static Map<String,Object> deserializeAsMap(String jsonString) {
        return null;
    }
    global static tffa.CSIDocumentResponseDTO parse(String json) {
        return null;
    }
    global static String toDebugString(String json, Boolean includeContent) {
        return null;
    }
global class AssociationInfo {
    global String filteringoption;
    global String groupcode;
    global String isoptional;
    global String maxgroupcount;
    global String suffix;
    global tffa.CSIDocumentResponseDTO.Type type;
    global AssociationInfo() {

    }
}
global class Body {
    global tffa.CSIDocumentResponseDTO.CheckForResponseResponse CheckForResponseResponse;
    global Body() {

    }
}
global class CheckForResponseResponse {
    global tffa.CSIDocumentResponseDTO.JobOutputData jobOutputData;
    global tffa.CSIDocumentResponseDTO.JobStatus jobStatus;
    global CheckForResponseResponse() {

    }
}
global class DataEntry {
    global String mainEntry;
    global DataEntry() {

    }
}
global class Datapoint {
    global String defaultvalue;
    global String longdescription;
    global String shortdescription;
    global String transactionvaluepath;
    global String usagetype;
    global String value;
    global String valuesource;
    global String valuestatus;
    global Datapoint() {

    }
}
global class DocSpec {
    global tffa.CSIDocumentResponseDTO.DocumentAssociations DocumentAssociations;
    global tffa.CSIDocumentResponseDTO.DocumentAttributes DocumentAttributes;
    global tffa.CSIDocumentResponseDTO.DstFile DstFile;
    global String FormId;
    global String FormSubtitle;
    global String FormTitle;
    global String FormVersion;
    global tffa.CSIDocumentResponseDTO.FxlList FxlList;
    global String MxlList;
    global String NumberOfCopies;
    global String OxlList;
    global String Tag;
    global DocSpec() {

    }
}
global class DocumentAssociations {
    global tffa.CSIDocumentResponseDTO.AssociationInfo AssociationInfo;
    global DocumentAssociations() {

    }
}
global class DocumentAttributes {
    global tffa.CSIDocumentResponseDTO.NamedAtribute NamedAtribute;
    global DocumentAttributes() {

    }
}
global class DstFile {
    global String filenameprefix;
    global String filenamesuffix;
    global String pageheightinches;
    global String pagewidthinches;
    global String path;
    global String printerproperties;
    global tffa.CSIDocumentResponseDTO.Smartdocproperties smartdocproperties;
    global DstFile() {

    }
}
global class Envelope {
    global tffa.CSIDocumentResponseDTO.Body Body;
    global Envelope() {

    }
}
global class FileData {
    global String SignatureMetadata;
    global String tag;
    global String type;
    global FileData() {

    }
}
global class FxlFileData {
    global String content;
    global String tag;
    global String type;
    global FxlFileData() {

    }
}
global class FxlList {
    global tffa.CSIDocumentResponseDTO.FxlFileData FileData;
    global FxlList() {

    }
}
global class HeaderEntry {
    global String documentinformationmustberecorded;
    global String documentinformationnegotiableinstrumentindicator;
    global String signatureModelSignatureType;
    global HeaderEntry() {

    }
}
global class JobOutputData {
    global tffa.CSIDocumentResponseDTO.MissingDatapoints MissingDatapoints;
    global tffa.CSIDocumentResponseDTO.RenderedFiles RenderedFiles;
    global tffa.CSIDocumentResponseDTO.SelectedDocuments SelectedDocuments;
    global JobOutputData() {

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
global class MissingDatapoints {
    global List<tffa.CSIDocumentResponseDTO.Datapoint> Datapoint;
    global MissingDatapoints() {

    }
}
global class NamedAtribute {
    global String Name;
    global String Value;
    global NamedAtribute() {

    }
}
global class RenderedFiles {
    global List<tffa.CSIDocumentResponseDTO.FileData> FileData;
    global RenderedFiles() {

    }
}
global class SelectedDocuments {
    global List<tffa.CSIDocumentResponseDTO.DocSpec> DocSpec;
    global SelectedDocuments() {

    }
}
global class Smartdocproperties {
    global String auditEntry;
    global tffa.CSIDocumentResponseDTO.DataEntry dataEntry;
    global tffa.CSIDocumentResponseDTO.HeaderEntry headerEntry;
    global String smartdocvalidationdtd;
    global String smartdocversion;
    global Smartdocproperties() {

    }
}
global class Type {
    global String filteringoption;
    global String isoptional;
    global String sourcetype;
    global String value;
    global Type() {

    }
}
}
