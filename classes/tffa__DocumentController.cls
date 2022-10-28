/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class DocumentController extends tffa.AbstractController implements tffa.IController {
    global String imageName {
        get;
        set;
    }
    global String imageURL {
        get;
    }
    global DocumentController() {

    }
    @AuraEnabled
    global static String fetchImageURL(String imageName) {
        return null;
    }
}
