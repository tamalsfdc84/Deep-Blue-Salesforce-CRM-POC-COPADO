/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class WKFSDocumentRequestMapper {
    global Map<Id,tffa__Application__c> applicationMap;
    global Map<String,List<tffa__Party__c>> authorizedSignatoryMap;
    global Map<String,List<tffa__PartyPartyXref__c>> beneficialOwnerMap;
    global Map<String,List<tffa__Beneficiary__c>> beneficiaryMap;
    global static String EZ_CONFIG_TYPE;
    global Map<String,List<tffa__Party__c>> guardianMap;
    global Map<String,List<tffa__Party__c>> holderMap;
    global static String LT_KYC_DECLINED_REASON_TYPES;
    global static String LT_TF_COUNTRY_OF_CITIZENSHIP;
    global static String LT_WKFS_ACCOUNT_PURPOSE_TYPES;
    global static String LT_WKFS_ACCOUNT_TYPES;
    global static String LT_WKFS_BENEFICIARY_TYPES;
    global static String LT_WKFS_ENTITY_TYPES;
    global static String LT_WKFS_FEE_TYPES;
    global static String LT_WKFS_IDENTIFICATION_TYPES;
    global static String LT_WKFS_INTEREST_FREQUENCY_TYPES;
    global static String LT_WKFS_INTEREST_PAYOUT_TYPES;
    global static String LT_WKFS_ORG_TAX_CLASSIFICATION_TYPES;
    global static String LT_WKFS_OWNERSHIP_DESCRIPTION_TYPES;
    global static String LT_WKFS_OWNERSHIP_TYPES;
    global static String LT_WKFS_PARTY_TYPES;
    global static String LT_WKFS_PHONE_TYPES;
    global static String LT_WKFS_PRODUCT_NAMES;
    global static String LT_WKFS_TERM_UNIT_TYPES;
    global Map<String,List<tffa__Party__c>> ownerPartyMap;
    global Map<Id,tffa__Party__c> partyMap;
    global Map<String,List<tffa__PartyPartyXref__c>> partyRelationMap;
    global Map<String,List<tffa__Party__c>> powerOfAttorneyMap;
    global Map<Id,tffa__Product__c> productMap;
    global Map<String,List<tffa__Party__c>> responsiblePartyMap;
    global Map<String,tffa__ApplicationPartyXref__c> signerApplicantRoleMap;
    global Map<String,List<tffa__Party__c>> signerPartyMap;
    global Map<String,List<tffa__Party__c>> successorResponsibleIndividualMap;
    global Map<String,List<tffa__Party__c>> successorResponsiblePartyMap;
    global Map<String,List<tffa__Party__c>> successorTrusteeMap;
    global Map<String,List<tffa__Party__c>> trusteeMap;
    global WKFSDocumentRequestMapper() {

    }
    global virtual tffa.WKFSDepositTransactionDataDTO.BeneficialOwners buildBeneficialOwners(tffa__Party__c party, tffa__Application__c application) {
        return null;
    }
    global virtual tffa.WKFSDepositTransactionDataDTO.Beneficiaries buildBeneficiaries(tffa__Submission__c submission, tffa__Application__c application) {
        return null;
    }
    global virtual void buildCollections(tffa__Submission__c submission, Map<String,Object> facts) {

    }
    global virtual tffa.WKFSDepositTransactionDataDTO.CustomData buildCustomData(tffa__Party__c party, tffa__Application__c application) {
        return null;
    }
    global virtual tffa.WKFSDocumentRequestDTO.EZConfig buildEZConfig(String templateId, tffa__Submission__c submission) {
        return null;
    }
    global virtual tffa.WKFSDepositTransactionDataDTO.Holder buildHolder(tffa__Party__c party, tffa__Application__c application) {
        return null;
    }
    global virtual tffa.WKFSDepositTransactionDataDTO.Holders buildHolders(tffa__Submission__c submission, tffa__Application__c application) {
        return null;
    }
    global virtual tffa.WKFSDepositTransactionDataDTO.Owners buildOwners(tffa__Submission__c submission, tffa__Application__c application) {
        return null;
    }
    global virtual tffa.WKFSDocumentRequestDTO buildRequestDTO(Map<String,Object> facts) {
        return null;
    }
    global virtual tffa.WKFSDepositTransactionDataDTO.ServicesRequested buildServicesRequested(tffa__Application__c application) {
        return null;
    }
    global virtual tffa.WKFSDepositTransactionDataDTO.Signers buildSigners(tffa__Party__c party, tffa__Application__c application) {
        return null;
    }
    global static tffa.WKFSDocumentRequestMapper getInstance(String providerName) {
        return null;
    }
    global virtual tffa.WKFSDepositTransactionDataDTO.Account populateOwnershipType(tffa__Submission__c submission, tffa__Application__c application, tffa.WKFSDepositTransactionDataDTO.Account account) {
        return null;
    }
}
