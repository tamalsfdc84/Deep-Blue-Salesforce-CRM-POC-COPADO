/**
 * Copyright (c) 2020 Terafina Inc
 * @group  Repository
 * @description Custom Metadata Repository
 **/
public with sharing class CZWTFCCustomMetadataRepository extends tffa.AbstractRepository {
  public static Nacha_Config__mdt fetchWtfcNachaConfig() {
    String configName = 'Nacha_Config';
    String q = new tffa.QueryBuilder(Nacha_Config__mdt.SObjectType).selectFields().whereClause('MasterLabel', '= :attr1').build().toQuery();
    List<Nacha_Config__mdt> result = doQuery(q, new List<Object>{ configName });
    return result.isEmpty() ? new Nacha_Config__mdt() : result[0];
  }
}