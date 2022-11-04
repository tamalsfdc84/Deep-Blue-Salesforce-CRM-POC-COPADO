public with sharing class CZWTFCProductRepository extends tffa.AbstractRepository {
  /**
   *
   */
  public static List<tffa__ProductMatrix__c> getAllProductsMatrix() {
    String q = new tffa.QueryBuilder(tffa__ProductMatrix__c.SObjectType).selectFields().build().toQuery();

    List<tffa__ProductMatrix__c> result = (List<tffa__ProductMatrix__c>) doQuery(q, new List<Object>{});
    return result.isEmpty() ? null : result;
  }

  public static tffa__Product__c fetchProductById(String id) {
    String q = new tffa.QueryBuilder(tffa__Product__c.SObjectType).selectFields().whereClause('Id', '=:attr1').build().toQuery();

    List<tffa__Product__c> result = (List<tffa__Product__c>) doQuery(q, new List<Object>{ id });
    return result.isEmpty() ? null : result.get(0);
  }

  /**
   *
   */
  public static tffa__ProductFeature__c fetchProductFeatByExternalId(String externalID, String name) {
    String q = new tffa.QueryBuilder(tffa__ProductFeature__c.SObjectType)
      .selectFields()
      .whereClause('tffa__ExternalId__c', '=:attr1')
      .OpAnd()
      .whereClause('Name', '!=:attr2')
      .build()
      .toQuery();

    List<tffa__ProductFeature__c> result = (List<tffa__ProductFeature__c>) doQuery(q, new List<Object>{ externalID, name });
    return result.isEmpty() ? null : result[0];
  }

  /**
   *
   */
  public static List<tffa__ProductMatrix__c> getProdMatrixByProdCode(String prodCode) {
    List<tffa__ProductMatrix__c> result = new List<tffa__ProductMatrix__c>();

    String query = new tffa.QueryBuilder(tffa__Product__c.SObjectType)
      .selectFields()
      .whereClause('tffa__Code__c', '=:attr1')
      .build()
      .toQuery();

    List<tffa__Product__c> prod = (List<tffa__Product__c>) doQuery(query, new List<Object>{ prodCode });

    if (prod != null && !prod.isEmpty()) {
      String q = new tffa.QueryBuilder(tffa__ProductMatrix__c.SObjectType)
        .selectFields()
        .whereClause('tffa__Product__c', '=:attr1')
        .build()
        .toQuery();

      result = (List<tffa__ProductMatrix__c>) doQuery(q, new List<Object>{ prod[0].Id });
    }
    return result.isEmpty() ? null : result;
  }

  public static Map<String, tffa__Location__c> fetchLocationByIds(List<String> locIds) {
    Map<String, tffa__Location__c> resultMap = new Map<String, tffa__Location__c>();
    String q = new tffa.QueryBuilder(tffa__Location__c.SObjectType).selectFields().whereClause('Id', '= :attr1').build().toQuery();

    List<tffa__Location__c> result = (List<tffa__Location__c>) doQuery(q, new List<Object>{ locIds });

    if (!result.isEmpty()) {
      for (tffa__Location__c loc : result) {
        resultMap.put(loc.tffa__Code__c, loc);
      }
    }

    return resultMap;
  }

  public static List<tffa__BrandLocation__c> fetchLocationByCodes(String brandCode) {
    tffa__Brand__c brandObj = CZWTFCBrandRepository.fetchBrandByCode(brandCode);
    List<tffa__BrandLocation__c> result = new List<tffa__BrandLocation__c>();
    String q = new tffa.QueryBuilder(tffa__BrandLocation__c.SObjectType)
      .selectFields()
      .whereClause('tffa__Brand__c', '= :attr1')
      .build()
      .toQuery();

    if (brandObj != null) {
      result = (List<tffa__BrandLocation__c>) doQuery(q, new List<Object>{ brandObj.Id });
    }
    return result.isEmpty() ? new List<tffa__BrandLocation__c>() : result;
  }

  public static List<tffa__ProductMatrix__c> getAllDigitalProductsMatrix() {
    Map<String, Object> mp = new Map<String, Object>();
    mp.put('Channel__c', 'DIGITAL');
    String q = new tffa.QueryBuilder(tffa__ProductMatrix__c.SObjectType)
      .selectFields()
      .whereWithFacts('StateZipValidation', mp)
      .build()
      .toQuery();

    List<tffa__ProductMatrix__c> result = (List<tffa__ProductMatrix__c>) doQuery(q, new List<Object>{});
    return result.isEmpty() ? null : result;
  }

  public static tffa__Product__c getProductByCode(String prodCode) {

    String query = new tffa.QueryBuilder(tffa__Product__c.SObjectType)
      .selectFields()
      .selectChildObject('tffa__Terms__r')
      .selectFields()
      .build()
      .whereClause('tffa__Code__c', '=:attr1')
      .build()
      .toQuery();

    List<tffa__Product__c> prod = (List<tffa__Product__c>) doQuery(query, new List<Object>{ prodCode });

    return prod.isEmpty() ? null : prod[0];
  }

  public static Map<String, tffa__Product__c> getProductByIds(Set<String> ids) {

    String query = new tffa.QueryBuilder(tffa__Product__c.SObjectType)
      .selectFields()
      .selectChildObject('tffa__Terms__r')
      .selectFields()
      .build()
      .whereClause('Id', 'In:attr1')
      .build()
      .toQuery();

    List<tffa__Product__c> prod = (List<tffa__Product__c>) doQuery(query, new List<Object>{ ids });

    Map<String, tffa__Product__c> productMap = new Map<String, tffa__Product__c>();
    if(!prod.isEmpty()){
      for(tffa__Product__c product : prod){
        productMap.put(product.Id, product);
      }
    }

    return productMap;
  }

  /*
  public static List<tffa__Product__c> readAllProducts(List<String> ids){
   
    String query = new tffa.QueryBuilder(tffa__Product__c.SObjectType)
    .selectFields()
    .selectChildObject('tffa__Features__r')
    .selectFields()
    .build()
    .whereClause('id', 'In:attr1')
    .build()
    .toQuery();

    List<tffa__Product__c> prod = (List<tffa__Product__c>) doQuery(query, new List<Object>{ ids });
    return prod.isEmpty() ? null:prod;
  }*/
}