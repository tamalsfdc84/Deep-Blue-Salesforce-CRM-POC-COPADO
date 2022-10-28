/**
 * @description Repository/Utility class to create test data
 */
public with sharing class FISCCTestDataRepository {
  /**
   * Creates a submission (persisted)
   */

  public static tffa__Party__c createIndividualPartyWithChildObjects() {
    tffa__Party__c party = createIndividualParty();

    return party;
  }
  public static tffa__Party__c createIndividualParty() {
    tffa__Party__c party = new tffa__Party__c();
    party.tffa__IsExistingCustomer__c = false;
    party.tffa__BirthDate__c = Date.valueOf('1981-02-02');
    party.tffa__Citizenship__c = 'Citizen';
    party.tffa__DoNotCall__c = false;
    party.tffa__DoNotEmail__c = false;
    party.tffa__DoNotText__c = false;
    party.tffa__FirstName__c = 'Florence';
    party.tffa__LastName__c = 'May';
    party.tffa__MaritalStatus__c = 'Married';
    party.tffa__MiddleName__c = 'J';
    party.tffa__NationalIdentifierType__c = 'SSN';
    party.tffa__NationalIdentifierValue__c = '123555555';
    party.tffa__PreferredContactMethod__c = 'Phone';
    party.tffa__PoliticallyExposedPerson__c = false;
    party.tffa__PreferredLanguage__c = 'English';
    party.tffa__PreferredTimeToCall__c = 'Morning';
    party.tffa__Prefilled__c = false;
    party.tffa__Prefix__c = 'Mr';
    party.tffa__PrimaryEmailType__c = 'PRIMARY';
    party.tffa__PrimaryEmail__c = 'a@a.com';
    party.tffa__SecondaryEmailType__c = 'SECONDARY';
    party.tffa__SecondaryEmail__c = 'b@b.com';
    party.tffa__PrimaryPhoneType__c = 'HOME';
    party.tffa__PrimaryPhone__c = ' 131334234';
    party.tffa__SecondaryPhoneType__c = 'WORK';
    party.tffa__SecondaryPhone__c = ' 131334288';
    party.tffa__FicoScore__c = 750;
    party.tffa__IsEmployee__c = false;
    party.tffa__NickName__c = 'Florence';
    party.tffa__SpousalVABenefitsEligibilityIndicator__c = false;
    party.tffa__Type__c = 'INDIVIDUAL';
    return party;
  }
}