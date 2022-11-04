/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class AlloyIDVServiceProvider extends tffa.DueDiligenceServiceProvider {
    global AlloyIDVServiceProvider() {

    }
    global virtual void logError(tffa.AlloyService.AlloyException ex, tffa.AlloyDTO.EvaluationRequest request) {

    }
    global virtual void logResponse(tffa.AlloyDTO.EvaluationResponse response, tffa.AlloyDTO.EvaluationRequest request) {

    }
    global virtual void populateBusinessDetails(tffa.AlloyDTO.EvaluationRequest request, tffa__Party__c party, Map<String,Object> facts) {

    }
    global virtual void populatePersonDetails(tffa.AlloyDTO.EvaluationRequest request, tffa__Party__c party, Map<String,Object> facts) {

    }
    global virtual void populateRepresentatives(tffa.AlloyDTO.EvaluationRequest request, tffa__Party__c party, List<tffa__PartyPartyXref__c> relatedPartyXrefs, Map<String,Object> facts) {

    }
    global virtual void populateSubmissionDetails(tffa.AlloyDTO.EvaluationRequest request, tffa__Submission__c sub, Map<String,Object> facts) {

    }
    global override List<tffa__DueDiligence__c> refreshStatus(List<tffa__DueDiligence__c> diligences, Map<String,Object> facts) {
        return null;
    }
    global override List<tffa__DueDiligence__c> updateStatus(List<tffa__DueDiligence__c> diligences, Map<String,Object> facts) {
        return null;
    }
    global override List<tffa__Party__c> verify(List<tffa__Party__c> parties, Map<String,Object> facts) {
        return null;
    }
}
