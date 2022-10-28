/**
 * Copyright (c) 2019 Terafina Inc
 * @group   Repository
 * @description
 **/
public with sharing class StipCustomMetadataRepository extends tffa.AbstractRepository {
  /**
   * @description used for retrieving Application parties
   * @param String party Id
   * @return List of Application Party
   **/

  public static List<tffa__ApplicationPartyXref__c> getAppPartyStip(string partyid) {
    List<String> fieldnamesApParty = new List<String>{ 'tffa__Application__c' };
    List<String> fieldnamesApplication = new List<String>{ 'Name', 'tffa__Submission__c' };
    String q = new tffa.QueryBuilder(tffa__ApplicationPartyXref__c.SObjectType)
      .selectFields(fieldnamesApParty)
      .selectObject('tffa__Application__r')
      .selectFields(fieldnamesApplication)
      .build()
      .whereClause('tffa__Party__c', '=:attr1')
      .build()
      .toQuery();

    return doQuery(q, new List<Object>{ partyid });
  }

  /**
   * @description used for retrieving Stipulations
   * @param String Stipulation Id
   * @return List of Stipulation
   **/
  public static tffa__Stipulation__c getStipulation(string stipulationId) {
    String query = new tffa.QueryBuilder(tffa__Stipulation__c.SObjectType)
      .selectFields()
      .build()
      .selectObject('tffa__Party__r')
      .selectFields()
      .build()
      .whereClause('Id', '= :attr1')
      .toQuery();

    return (tffa__Stipulation__c) doQueryOne(query, new List<Object>{ stipulationId });
  }
}