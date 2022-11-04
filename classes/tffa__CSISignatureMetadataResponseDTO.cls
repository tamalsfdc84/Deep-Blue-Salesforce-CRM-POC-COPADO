/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class CSISignatureMetadataResponseDTO {
    global tffa.CSISignatureMetadataResponseDTO.InlineTemplate InlineTemplate;
    global CSISignatureMetadataResponseDTO() {

    }
    global static Map<String,Object> deserializeAsMap(String jsonString) {
        return null;
    }
    global static tffa.CSISignatureMetadataResponseDTO parse(String json) {
        return null;
    }
    global static String toDebugString(String json, Boolean includeContent) {
        return null;
    }
global class AnchorTabItem {
    global String AnchorTabString;
    global AnchorTabItem() {

    }
}
global class Document {
    global String ID;
    global String Name;
    global String PDFBytes;
    global Document() {

    }
}
global class Documents {
    global tffa.CSISignatureMetadataResponseDTO.Document Document;
    global Documents() {

    }
}
global class Envelope {
    global tffa.CSISignatureMetadataResponseDTO.Documents Documents;
    global tffa.CSISignatureMetadataResponseDTO.Recipients Recipients;
    global tffa.CSISignatureMetadataResponseDTO.Tabs Tabs;
    global Envelope() {

    }
}
global class InlineTemplate {
    global tffa.CSISignatureMetadataResponseDTO.Envelope Envelope;
    global InlineTemplate() {

    }
}
global class Recipient {
    global String AccessCode;
    global String Email;
    global String ID;
    global String RequireIDLookup;
    global String RoutingOrder;
    global String SignerName;
    global String Type;
    global String UserName;
    global Recipient() {

    }
}
global class Recipients {
    global List<tffa.CSISignatureMetadataResponseDTO.Recipient> Recipient;
    global Recipients() {

    }
}
global class Tab {
    global tffa.CSISignatureMetadataResponseDTO.AnchorTabItem AnchorTabItem;
    global String RecipientID;
    global String TabLabel;
    global String TabOrder;
    global String Type;
    global Tab() {

    }
}
global class Tabs {
    global List<tffa.CSISignatureMetadataResponseDTO.Tab> Tab;
    global Tabs() {

    }
}
}
