public inherited sharing class FISCCTestRepositoryHelper extends tffa.AbstractRepository {
  public static List<FISCC_Adapter_Configs__mdt> getAdapterConfigMetadata(String strDeveloperName) {
    String q = new tffa.QueryBuilder(FISCC_Adapter_Configs__mdt.SObjectType)
      .selectFields()
      .whereClause('DeveloperName', '=:attr1')
      .withLimit(1)
      .build()
      .toQuery();
    List<FISCC_Adapter_Configs__mdt> result = (List<FISCC_Adapter_Configs__mdt>) doQuery(q, new List<Object>{ strDeveloperName });
    return result.isEmpty() ? null : result;
  }

  public static List<FISCC_Charter_Config__mdt> getCharterConfigMetadata1(String DeveloperName) {
    String q = new tffa.QueryBuilder(FISCC_Charter_Config__mdt.SObjectType)
      .selectFields()
      .whereClause('DeveloperName', '=:attr1')
      .withLimit(1)
      .build()
      .toQuery();

    List<FISCC_Charter_Config__mdt> result = (List<FISCC_Charter_Config__mdt>) doQuery(q, new List<Object>{ DeveloperName });
    return result.isEmpty() ? null : result;
  }
}