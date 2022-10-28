/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class ListOfValuesDTO extends tffa.AbstractDTO {
    global String code;
    global String description;
    global Boolean disabled;
    global List<tffa.ListOfValuesDTO.ListOfValuesItemDTO> items;
    global String locale;
    global String name;
    global ListOfValuesDTO() {

    }
    global ListOfValuesDTO(tffa__ListOfValues__c lov) {

    }
global virtual class ListOfValuesItemDTO extends tffa.AbstractDTO {
    global Boolean disabled;
    global String name;
    global String value;
    global ListOfValuesItemDTO() {

    }
}
}
