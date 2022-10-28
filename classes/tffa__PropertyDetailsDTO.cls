/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class PropertyDetailsDTO extends tffa.AbstractDTO {
    global String additionalFeatures;
    global tffa.PropertyDetailsDTO.Address address;
    global String airConditioningType;
    global String description;
    global String designatorType;
    global String externalReferenceId;
    global String heatingType;
    global List<tffa.PropertyDetailsDTO.ImageURL> images;
    global String infoURL;
    global Integer numberOfBathrooms;
    global Integer numberOfBedrooms;
    global String numberOfFloors;
    global Integer numberOfRooms;
    global Integer parkingSpacesCount;
    global tffa.PropertyDetailsDTO.EstimateDTO rentEstimate;
    global String source;
    global Integer totalArea;
    global tffa.PropertyDetailsDTO.EstimateDTO valuationEstimate;
    global Integer yearBuilt;
    global PropertyDetailsDTO() {

    }
global virtual class Address extends tffa.AbstractDTO {
    global String City;
    global String Line1;
    global String State;
    global String ZipCode;
    global Address() {

    }
}
global virtual class EstimateDTO extends tffa.AbstractDTO {
    global Integer amount;
    global Integer maxAmount;
    global Integer minAmount;
    global Date updatedOn;
    global EstimateDTO() {

    }
}
global virtual class ImageURL extends tffa.AbstractDTO {
    global String url;
    global ImageURL() {

    }
}
}
