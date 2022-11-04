/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class CSIDocumentRequestMapper {
    global Map<Id,tffa__Application__c> applicationMap;
    global Map<String,List<tffa__Party__c>> appointeePartyMap;
    global Map<String,List<tffa__Party__c>> authorizedSignatoryMap;
    global Map<String,List<tffa__PartyPartyXref__c>> beneficialOwnerMap;
    global Map<String,List<tffa__Beneficiary__c>> beneficiaryMap;
    global tffa.Credential credential;
    global Map<String,List<tffa__Party__c>> custodianPartyMap;
    global Map<String,List<tffa__Party__c>> deputyPartyMap;
    global static String DIGITAL_SIGNATURE_PROVIDER;
    global Map<String,List<tffa__Party__c>> fiduciaryPartyMap;
    global Map<String,List<tffa__Party__c>> guardianMap;
    global Map<String,List<tffa__Party__c>> holderMap;
    global static String LT_CSI_ACCOUNT_TYPES;
    global static String LT_CSI_BENEFICIARY_TYPES;
    global static String LT_CSI_COMMERCIAL_OWNERSHIP_TYPES;
    global static String LT_CSI_ENTITY_TYPES;
    global static String LT_CSI_IDENTIFICATION_TYPES;
    global static String LT_CSI_INVESTMENT_CONTRIBUTION_TYPES;
    global static String LT_CSI_INVESTMENT_PLAN_TYPES;
    global static String LT_CSI_MARITAL_STATUS_TYPES;
    global static String LT_CSI_OWNERSHIP_TYPES;
    global static String LT_CSI_PRODUCT_NAMES;
    global static String LT_KYC_DECLINED_REASON_TYPES;
    global static String LT_TF_COUNTRY_OF_CITIZENSHIP;
    global Map<String,List<tffa__Party__c>> ownerPartyMap;
    global Map<Id,tffa__Party__c> partyMap;
    global Map<String,List<tffa__PartyPartyXref__c>> partyRelationMap;
    global Map<String,List<tffa__Party__c>> powerOfAttorneyMap;
    global Map<Id,tffa__Product__c> productMap;
    global Map<String,List<tffa__Party__c>> responsiblePartyMap;
    global Map<String,List<tffa__Party__c>> signerPartyMap;
    global Map<String,List<tffa__Party__c>> successorResponsibleIndividualMap;
    global Map<String,List<tffa__Party__c>> successorResponsiblePartyMap;
    global Map<String,List<tffa__Party__c>> successorTrusteeMap;
    global Map<String,List<tffa__Party__c>> trusteeMap;
    global CSIDocumentRequestMapper() {

    }
    global virtual tffa.CSIPartnerDataDTO.ATMDebitCard buildATMDebitCard(tffa__Party__c party, tffa__Application__c application) {
        return null;
    }
    global virtual tffa.CSIPartnerDataDTO.Applicant buildApplicants(tffa__Submission__c submission) {
        return null;
    }
    global virtual List<tffa.CSIPartnerDataDTO.Beneficiary> buildBeneficiaries(tffa__Application__c application) {
        return null;
    }
    global virtual tffa.CSIPartnerDataDTO.Business buildBusiness(tffa__Submission__c submission, tffa__Party__c party, tffa__Application__c application) {
        return null;
    }
    global virtual List<tffa.CSIPartnerDataDTO.Business> buildBusiness(tffa__Submission__c submission, tffa__Application__c application) {
        return null;
    }
    global virtual List<tffa.CSIPartnerDataDTO.Business> buildBusinesses(tffa__Submission__c submission) {
        return null;
    }
    global virtual void buildCollections(tffa__Submission__c submission, Map<String,Object> facts) {

    }
    global virtual List<tffa.CSIPartnerDataDTO.Contact> buildContacts(tffa__Submission__c submission) {
        return null;
    }
    global virtual tffa.CSIPartnerDataDTO.FinancialInstitution buildFinancialInstitution(tffa__Submission__c submission) {
        return null;
    }
    global virtual void buildHeaderInformation(tffa.CSIPartnerDataDTO dto, tffa__Submission__c submission) {

    }
    global virtual tffa.CSIPartnerDataDTO.Individual buildIndividual(tffa__Party__c party, tffa__Application__c application) {
        return null;
    }
    global virtual List<tffa.CSIPartnerDataDTO.Individual> buildIndividuals(tffa__Submission__c submission) {
        return null;
    }
    global virtual tffa.CSIPartnerDataDTO buildRequestDTO(Map<String,Object> facts) {
        return null;
    }
    global virtual List<tffa.CSIPartnerDataDTO.Signer> buildSigners(tffa__Party__c party, tffa__Application__c application) {
        return null;
    }
    global static tffa.CSIDocumentRequestMapper getInstance(String providerName) {
        return null;
    }
    global virtual tffa.CSIPartnerDataDTO.Account populateownershipType(tffa__Submission__c submission, tffa__Application__c application, tffa.CSIPartnerDataDTO.Account account) {
        return null;
    }
    global virtual void setCredential() {

    }
}
